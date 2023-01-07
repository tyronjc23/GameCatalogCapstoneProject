//
//  DetailViewController.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 07/11/22.
//

import UIKit

class DetailViewController: UIViewController {
	
	var game: Game!
	private var gameFavorite: GameData?
	var presenter: DetailPresenter?
	
	@IBOutlet var gameImage: UIImageView!
	@IBOutlet var gameTitle: UILabel!
	@IBOutlet var gameDescription: UITextView!
	@IBOutlet var gameDevelopers: UILabel!
	@IBOutlet var gamePublisher: UILabel!
	@IBOutlet weak var favoriteButton: UIBarButtonItem!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewWillAppear(_ animated: Bool) {
		guard let presenter = presenter else { return }
		presenter.getGame { result in
			switch result {
			case .success(let gameResult):
				self.game = gameResult
				DispatchQueue.main.async {
					self.gameImage.image = self.game.image
					self.gameTitle.text = self.game.title
					self.gameDescription.text = self.game.gameDescription
					self.gamePublisher.text = self.game.publishers
					self.gameDevelopers.text = self.game.developers
					
					self.checkFavorite()
				}
			case .failure(let error):
				print(error.localizedDescription)
			}
		}
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
		GameData.updateData(game)
		
		DispatchQueue.main.async {
			self.checkFavorite()
		}
	}
}
