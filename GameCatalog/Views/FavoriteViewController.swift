//
//  FavoriteViewController.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 18/11/22.
//

import UIKit
import Combine

class FavoriteViewController: UIViewController {
	
	@IBOutlet var gameTableView: UITableView!
	private var favoriteGames: [GameModel] = []
	var presenter: FavoritePresenter?
	var homeController = HomeViewController()
	
	private var cancellables: Set<AnyCancellable> = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		gameTableView.dataSource = self
		gameTableView.delegate = self
		
	}
	
	override func viewDidAppear(_ animated: Bool) {
		fetchGame()
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "detailGame" {
			if let detailViewController = segue.destination as? DetailViewController {
				guard let game = sender as? GameModel else { return }
				let detailUseCase = Injection.init().provideDetail(gameId: game.id)
				let detailPresenter = DetailPresenter(detailUseCase: detailUseCase)
				detailViewController.presenter = detailPresenter
			}
		}
	}
	
	func fetchGame() {
		guard let presenter = presenter else { return }
		presenter.getFavorites()
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
				self.favoriteGames = games
				self.gameTableView.reloadData()
			})
			.store(in: &cancellables)
	}
	
}

extension FavoriteViewController: UITableViewDataSource, UITableViewDelegate {
	
	func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return favoriteGames.isEmpty ? 0 : favoriteGames.count
	}
	
	func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
		if let cell = tableView.dequeueReusableCell(withIdentifier: GameFavoriteTableViewCell.identifier, for: indexPath) as? GameFavoriteTableViewCell, !favoriteGames.isEmpty {
			let game = favoriteGames[indexPath.row]
			cell.title.text = game.title
			cell.genres.text = game.genres
			cell.rating.text = String(game.rating)
			cell.releasedDate.text = game.releasedDate.formatted(date: .long, time: .omitted)
			cell.gameImage.image = game.image
			return cell
		} else {
			return UITableViewCell()
		}
	}
	
	func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
		tableView.deselectRow(at: indexPath, animated: true)
		performSegue(withIdentifier: "detailGame", sender: favoriteGames[indexPath.row])
	}
	
	func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
		let deleteAction = UIContextualAction(style: .destructive, title: "Remove") { [weak self] (_, _, completion) in
			guard let item = self?.favoriteGames[indexPath.row] else { return }
			
			let alert = UIAlertController(title: "",
													message: "Do you want to remove \(item.title) from favorite?",
													preferredStyle: .alert)
			
			let deleteButton = UIAlertAction(title: "Remove", style: .destructive) {[weak self] (_) in
				item.favorite = false
				
				self?.homeController.updateGame(item)
				
				DispatchQueue.main.async {
					self?.favoriteGames.remove(at: indexPath.row)
					tableView.deleteRows(at: [indexPath], with: .automatic)
				}
				completion(true)
			}
			
			alert.addAction(UIAlertAction(title: "Cancel", style: .default))
			alert.addAction(deleteButton)
			self!.present(alert, animated: true)
		}
		
		return UISwipeActionsConfiguration(actions: [deleteAction])
	}
	
}
