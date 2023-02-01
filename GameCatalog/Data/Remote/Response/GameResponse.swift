//
//  GameResponse.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 29/01/23.
//

import UIKit

struct GameResponses: Codable {
	let count: Int
	let games: [GameResponse]
	enum CodingKeys: String, CodingKey {
		case count
		case games = "results"
	}
}

struct GameResponse: Codable {
	let id: Int
	let title: String
	let releasedDate: Date
	let posterPath: URL
	let rating: Double
	let ratingsCount: Int
	let genres: [GameGenresResponse]
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
		genres = try container.decode([GameGenresResponse].self, forKey: .genres)
	}
}

struct GameGenresResponse: Codable {
	let id: Int
	let name: String
}

struct GameDetailResponse: Codable {
	let id: Int
	let name, description: String
	let developers: [DevelopersResponse]?
	let publishers: [PublishersResponse]?
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
		developers = try container.decode([DevelopersResponse].self, forKey: .developers)
		publishers = try container.decode([PublishersResponse].self, forKey: .publishers)
	}
}

struct DevelopersResponse: Codable {
	let id: Int
	let name: String
}

struct PublishersResponse: Codable {
	let id: Int
	let name: String
}
