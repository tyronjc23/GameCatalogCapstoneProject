//
//  GameTableViewCell.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 01/11/22.
//

import UIKit

class GameTableViewCell: UITableViewCell {
	
	static var identifier = "gameTableViewCell"
	
	@IBOutlet var gameTitle: UILabel!
	@IBOutlet var gameImage: UIImageView!
	@IBOutlet var gameLoading: UIActivityIndicatorView!
	@IBOutlet var relasedDate: UILabel!
	@IBOutlet var ratingNumber: UILabel!
	@IBOutlet var genres: UILabel!
	@IBOutlet var ratingImage: [UIImageView]!
	
}
