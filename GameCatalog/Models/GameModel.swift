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

class Game {
	let id: Int
	let title: String
	let releasedDate: Date
	let posterPath: URL
	let rating: Double
	
	var image: UIImage?
	var gameDescription: String?
	var genres: String?
	var publishers: String?
	var developers: String?
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

struct GameLists: Codable {
	let count: Int
	let games: [GameList]
	enum CodingKeys: String, CodingKey {
		case count
		case games = "results"
	}
}

struct GameList: Codable {
	let id: Int
	let title: String
	let releasedDate: Date
	let posterPath: URL
	let rating: Double
	let ratingsCount: Int
	let genres: [GameGenres]
	enum CodingKeys: String, CodingKey {
		case id
		case title = "name"
		case releasedDate = "released"
		case posterPath = "background_image"
		case rating
		case ratingsCount = "ratings_count"
		case genres
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		let path = try container.decode(String.self, forKey: .posterPath)
		posterPath = URL(string: path)!
		
		let dateString = try container.decode(String.self, forKey: .releasedDate)
		let dateFormatter = DateFormatter()
		dateFormatter.dateFormat = "yyyy-MM-dd"
		releasedDate = dateFormatter.date(from: dateString)!
		
		id = try container.decode(Int.self, forKey: .id)
		title = try container.decode(String.self, forKey: .title)
		rating = try container.decode(Double.self, forKey: .rating)
		ratingsCount = try container.decode(Int.self, forKey: .ratingsCount)
		genres = try container.decode([GameGenres].self, forKey: .genres)
	}
}

struct GameGenres: Codable {
	let id: Int
	let name: String
}

struct GameDetail: Codable {
	let id: Int
	let name, description: String
	let developers: [Developers]?
	let publishers: [Publishers]?
	enum CodingKeys: String, CodingKey {
		case id
		case name
		case description = "description_raw"
		case developers
		case publishers
	}
	
	init(from decoder: Decoder) throws {
		let container = try decoder.container(keyedBy: CodingKeys.self)
		
		id = try container.decode(Int.self, forKey: .id)
		name = try container.decode(String.self, forKey: .name)
		description = try container.decode(String.self, forKey: .description)
		developers = try container.decode([Developers].self, forKey: .developers)
		publishers = try container.decode([Publishers].self, forKey: .publishers)
	}
}

struct Developers: Codable {
	let id: Int
	let name: String
}

struct Publishers: Codable {
	let id: Int
	let name: String
}
