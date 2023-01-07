//
//  GameFavoriteTableViewCell.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 18/11/22.
//

import UIKit

class GameFavoriteTableViewCell: UITableViewCell {
	
	static var identifier = "gameFavoriteCell"
	
	@IBOutlet weak var gameImage: UIImageView!
	@IBOutlet weak var title: UILabel!
	@IBOutlet weak var genres: UILabel!
	@IBOutlet weak var releasedDate: UILabel!
	@IBOutlet weak var rating: UILabel!
	@IBOutlet var ratingStar: [UIImageView]!
	
}
