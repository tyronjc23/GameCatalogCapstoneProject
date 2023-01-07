//
//  ViewController.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 01/11/22.
//

import UIKit
import Combine

class HomeViewController: UIViewController {
	@IBOutlet var gameTableView: UITableView!
	private var games: [Game] = []
	private var filterGames: [Game] = []
	var searchController = UISearchController()
	var presenter: HomePresenter?
	
	private var cancellables: Set<AnyCancellable> = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		navigationItem.searchController = searchController
		searchController.searchResultsUpdater = self
		
		gameTableView?.dataSource = self
		gameTableView?.delegate = self
		
		getCoreDataDBPath()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		getGames()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "detailGame" {
			if let detailViewController = segue.destination as? DetailViewController {
				guard let game = sender as? Game else { return }
				let detailUseCase = Injection.init().provideDetail(gameId: game.id)
				let detailPresenter = DetailPresenter(detailUseCase: detailUseCase)
				detailViewController.presenter = detailPresenter
			}
		}
	}
	
	private func getGames() {
		guard let presenter = presenter else { return }
		presenter.getGamesWithCombine()
			.receive(on: RunLoop.main)
			.sink(receiveCompletion: { completion in
				switch completion {
				case .failure:
					print(completion)
					let alert = UIAlertController(title: "Alert",
															message: String(describing: completion),
															preferredStyle: .alert)
					alert.addAction(UIAlertAction(title: "OK",
															style: .default,
															handler: nil))
					self.present(alert, animated: true)
				case .finished:
					break
				}
			}, receiveValue: { games in
				self.games = games
				self.filterGames = self.games
				self.gameTableView?.reloadData()
			})
			.store(in: &cancellables)
	}
	
	private func getCoreDataDBPath() {
		let path = FileManager
			.default
			.urls(for: .applicationSupportDirectory, in: .userDomainMask)
			.last?
			.absoluteString
			.replacingOccurrences(of: "file://", with: "")
			.removingPercentEncoding
		
		print("Core Data DB Path : \(path ?? "Not found")")
	}
	
	@IBAction func DeleteData(_ sender: Any) {
		GameData.deleteAll()
		self.games = []
		self.filterGames = []
		DispatchQueue.main.async {
			self.gameTableView?.reloadData()
		}
	}
}

extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return filterGames.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: GameTableViewCell.identifier, for: indexPath) as? GameTableViewCell {
			
			let game = filterGames[indexPath.row]
			
			cell.gameTitle.text = game.title
			cell.relasedDate.text = game.releasedDate.formatted(date: .long, time: .omitted)
			cell.genres.text = game.genres
			cell.ratingNumber.text = String(game.rating)
			cell.gameImage.image = game.image
			
			for rate in cell.ratingImage {
				if rate.tag <= Int(game.rating) {
					rate.image = UIImage(systemName: "star.fill")
				} else {
					rate.image = UIImage(systemName: "star")
				}
			}
			
			if game.state == .new {
				cell.gameLoading.isHidden = false
				cell.gameLoading.startAnimating()
				startDownload(game: game, indexPath: indexPath)
			} else {
				cell.gameLoading.isHidden = true
				cell.gameLoading.stopAnimating()
			}
			
			return cell
		} else {
			return UITableViewCell()
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: "detailGame", sender: filterGames[indexPath.row])
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		var favoriteActionTitle: String
		let game = filterGames[indexPath.row]
		
		if game.favorite {
			favoriteActionTitle = "Unfavorite"
		} else {
			favoriteActionTitle = "Favorite"
		}
		
		let favoriteAction = UIContextualAction(style: .normal, title: favoriteActionTitle) {[weak self] (_, _, completion) in
			self?.favoriteGame(game)
			completion(true)
			tableView.reloadRows(at: [indexPath], with: .automatic)
		}
		
		favoriteAction.backgroundColor = .systemGreen
		
		return UISwipeActionsConfiguration(actions: [favoriteAction])
	}
	
	private func startDownload(game: Game, indexPath: IndexPath) {
		let imageDownload = ImageDownload()
		
		if game.state == .new {
			Task {
				do {
					let image = try await imageDownload.downloadImage(url: game.posterPath)
					game.state = .downloaded
					game.image = image
					GameData.updateData(game)
					self.gameTableView?.reloadRows(at: [indexPath], with: .automatic)
				} catch {
					game.state = .failed
					game.image = nil
				}
			}
		}
	}
	
	private func favoriteGame(_ game: Game) {
		if game.favorite {
			game.favorite = false
		} else {
			game.favorite = true
		}
		
		GameData.updateData(game)
	}
}

extension HomeViewController: UISearchResultsUpdating {
	func updateSearchResults(for searchController: UISearchController) {
		guard let text = searchController.searchBar.text else {
			return
		}
		
		filterGames.removeAll()
		
		if text == "" {
			filterGames = games
		} else {
			for gameItem in games where gameItem.title.uppercased().contains(text.uppercased()) {
				filterGames.append(gameItem)
			}
		}
		
		self.gameTableView?.reloadData()
	}
}
