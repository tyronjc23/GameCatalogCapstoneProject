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
