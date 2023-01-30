//
//  DetailViewController.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 07/11/22.
//

import UIKit
import Combine

class DetailViewController: UIViewController {
	
	var game: GameModel!
	private var gameFavorite: GameData?
	var homeController = HomeViewController()
	var presenter: DetailPresenter!
	
	@IBOutlet var gameImage: UIImageView!
	@IBOutlet var gameTitle: UILabel!
	@IBOutlet var gameDescription: UITextView!
	@IBOutlet var gameDevelopers: UILabel!
	@IBOutlet var gamePublisher: UILabel!
	@IBOutlet weak var favoriteButton: UIBarButtonItem!
	
	private var cancellables: Set<AnyCancellable> = []
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		presenter.getGame()
			.receive(on: RunLoop.main)
			.sink { completion in
				switch completion {
				case .failure(let error):
					print(error.localizedDescription)
				case .finished:
					break
				}
			} receiveValue: { gameResult in
				self.game = gameResult
				self.gameImage.image = gameResult.image
				self.gameTitle.text = gameResult.title
				self.gameDescription.text = gameResult.gameDescription
				self.gamePublisher.text = gameResult.publishers
				self.gameDevelopers.text = gameResult.developers
				
				self.checkFavorite()
			}.store(in: &cancellables)
	}
	
	func checkFavorite() {
		if game.favorite {
			favoriteButton.image = UIImage(systemName: "heart.fill")
		} else {
			favoriteButton.image = UIImage(systemName: "heart")
		}
	}
	
	@IBAction func saveFavorite(_ sender: Any) {
		if game.favorite {
			game.favorite = false
		} else {
			game.favorite = true
		}
		
		homeController.updateGame(game)
		
		DispatchQueue.main.async {
			self.checkFavorite()
		}
	}
}
