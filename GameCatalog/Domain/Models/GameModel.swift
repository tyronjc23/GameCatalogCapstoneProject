//
//  GameModel.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 01/11/22.
//

import UIKit

enum DownloadState {
	case new, downloaded, failed
}

class GameModel {
	let id: Int
	let title: String
	let releasedDate: Date
	let posterPath: URL
	let rating: Double
	
	var image: UIImage?
	var gameDescription: String? = ""
	var genres: String? = ""
	var publishers: String? = ""
	var developers: String? = ""
	var favorite: Bool = false
	var state: DownloadState = .new
	
	init(id: Int, title: String, releasedDate: Date, posterPath: URL, rating: Double) {
		self.id = id
		self.title = title
		self.releasedDate = releasedDate
		self.posterPath = posterPath
		self.rating = rating
	}
}

struct GameDetailModel {
	let gameId: Int
	var gameDescription: String? = ""
	var publishers: String? = ""
	var developers: String? = ""
	
	init(gameId: Int, publishers: String? = nil, developers: String? = nil) {
		self.gameId = gameId
		self.publishers = publishers
		self.developers = developers
	}
}
