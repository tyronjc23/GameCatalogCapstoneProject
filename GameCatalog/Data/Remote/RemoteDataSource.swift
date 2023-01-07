//
//  RemoteDataSource.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Alamofire
import Combine

protocol RemoteDataSourceProtocol: AnyObject {
	
	// Completion Handler
	func getGames(result: @escaping (Result<[GameList], URLError>) -> Void)
	func getDetailGame(gameId: Int, result: @escaping (Result<GameDetail, URLError>) -> Void)
	
	// Combine
	func getGamesWithCombine() -> AnyPublisher<[GameList], Error>
	
}

final class RemoteDataSource: NSObject {
	
	private override init() { }
	
	static let shared: RemoteDataSource = RemoteDataSource()
	
}

extension RemoteDataSource: RemoteDataSourceProtocol {
	
	// MARK: Completion Handler
	
	func getGames(result: @escaping (Result<[GameList], URLError>) -> Void) {
		var components = URLComponents(string: Endpoints.Gets.games.url)!
		components.queryItems = [
			URLQueryItem(name: "key", value: API.apiKey)
		]
		
		guard let url = components.url else { return }
		
		AF.request(url)
			.validate()
			.responseDecodable(of: GameLists.self) { response in
				switch response.result {
				case .success(let value):
					result(.success(value.games))
				case .failure:
					result(.failure(URLError(.badServerResponse)))
				}
			}
	}
	
	func getDetailGame(gameId: Int, result: @escaping (Result<GameDetail, URLError>) -> Void) {
		var components = URLComponents(string: "\(Endpoints.Gets.games.url)/\(gameId)")!
		components.queryItems = [
			URLQueryItem(name: "key", value: API.apiKey)
		]
		
		guard let url = components.url else { return }
		
		AF.request(url)
			.validate()
			.responseDecodable(of: GameDetail.self) { response in
				switch response.result {
				case .success(let value):
					result(.success(value))
				case .failure:
					result(.failure(URLError(.badServerResponse)))
				}
			}
	}
	
	// MARK: Combine Function
	
	func getGamesWithCombine() -> AnyPublisher<[GameList], Error> {
		return Future<[GameList], Error> { completion in
			var components = URLComponents(string: Endpoints.Gets.games.url)!
			components.queryItems = [
				URLQueryItem(name: "key", value: API.apiKey)
			]
			
			guard let url = components.url else { return }
			
			AF.request(url)
				.validate()
				.responseDecodable(of: GameLists.self) { response in
					switch response.result {
					case .success(let value):
						completion(.success(value.games))
					case .failure:
						completion(.failure(URLError(.badServerResponse)))
					}
				}
		}.eraseToAnyPublisher()
	}
	
	func getDetailGameWithCombine(gameId: Int) -> AnyPublisher<GameDetail, Error> {
		return Future<GameDetail, Error> { completion in
			var components = URLComponents(string: "\(Endpoints.Gets.games.url)/\(gameId)")!
			components.queryItems = [
				URLQueryItem(name: "key", value: API.apiKey)
			]
			
			guard let url = components.url else { return }
			
			AF.request(url)
				.validate()
				.responseDecodable(of: GameDetail.self) { response in
					switch response.result {
					case .success(let value):
						completion(.success(value))
					case .failure:
						completion(.failure(URLError(.badServerResponse)))
					}
				}
		}.eraseToAnyPublisher()
	}
	
}
