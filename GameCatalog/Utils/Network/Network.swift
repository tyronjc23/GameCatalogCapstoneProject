//
//  Network.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 01/11/22.
//

import Foundation

struct API {
	
	static let baseUrl = "https://api.rawg.io/api/"
	static var apiKey: String {
		guard let filePath = Bundle.main.path(forResource: "rawg-info", ofType: "plist") else {
			fatalError("File plist tidak ditemukan.")
		}
		
		let plist = NSDictionary(contentsOfFile: filePath)
		guard let value = plist?.object(forKey: "API_KEY") as? String else {
			fatalError("Key tidak ditemukan.")
		}
		
		return value
	}
	
}

protocol Endpoint {
	
	var url: String { get }
	
}

enum Endpoints {
	
	enum Gets: Endpoint {
		case games
		
		public var url: String {
			switch self {
			case .games: return "\(API.baseUrl)games"
			}
		}
	}
	
}

class Network {
	private var apiKey: String {
		guard let filePath = Bundle.main.path(forResource: "rawg-info", ofType: "plist") else {
			fatalError("File plist tidak ditemukan.")
		}
		
		let plist = NSDictionary(contentsOfFile: filePath)
		guard let value = plist?.object(forKey: "API_KEY") as? String else {
			fatalError("Key tidak ditemukan.")
		}
		
		return value
	}
	
	func getGames() async throws -> [Game] {
		var components = URLComponents(string: "https://api.rawg.io/api/games")!
		components.queryItems = [
			URLQueryItem(name: "key", value: apiKey)
		]
		
		guard let url = components.url else {
			throw NSError(domain: "Error", code: 1)
		}
		
		let request = URLRequest(url: url)
		
		let (data, response) = try await URLSession.shared.data(for: request)
		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			fatalError("Error: Failed Fetch Data \(response)")
		}
		
		let result = try JSONDecoder().decode(GameLists.self, from: data)
		
		return mapper(input: result.games)
	}
	
	func getDetailGame(gameId: Int) async throws -> GameDetail {
		var components = URLComponents(string: "https://api.rawg.io/api/games/\(gameId)")!
		components.queryItems = [
			URLQueryItem(name: "key", value: apiKey)
		]
		
		guard let url = components.url else {
			throw NSError(domain: "Error", code: 1)
		}
		
		let request = URLRequest(url: url)
		
		let (data, response) = try await URLSession.shared.data(for: request)
		guard (response as? HTTPURLResponse)?.statusCode == 200 else {
			fatalError("Error: Failed Fetch Data \(response)")
		}
		
		return try JSONDecoder().decode(GameDetail.self, from: data)
	}
}

extension Network {
	fileprivate func mapper(input gameLists: [GameList]) -> [Game] {
		return gameLists.map { result in
			return Game(
				id: result.id,
				title: result.title,
				releasedDate: result.releasedDate,
				posterPath: result.posterPath,
				rating: result.rating
			)
		}
	}
}
