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
	
	func getAllGames() -> AnyPublisher<[GameResponse], Error>
	func getDetailGame(with gameId: Int) -> AnyPublisher<GameDetailResponse, Error>
	
}

final class RemoteDataSource: NSObject {
	
	private override init() { }
	
	static let shared: RemoteDataSource = RemoteDataSource()
	
}

extension RemoteDataSource: RemoteDataSourceProtocol {
	
	func getAllGames() -> AnyPublisher<[GameResponse], Error> {
		return Future<[GameResponse], Error> { completion in
			var components = URLComponents(string: Endpoints.Gets.games.url)!
			components.queryItems = [
				URLQueryItem(name: "key", value: API.apiKey)
			]
			
			guard let url = components.url else { return }
			
			AF.request(url)
				.validate()
				.responseDecodable(of: GameResponses.self) { response in
					switch response.result {
					case .success(let value):
						completion(.success(value.games))
					case .failure:
						completion(.failure(URLError.invalidResponse))
					}
				}
		}.eraseToAnyPublisher()
	}
	
	func getDetailGame(with gameId: Int) -> AnyPublisher<GameDetailResponse, Error> {
		return Future<GameDetailResponse, Error> { completion in
			var components = URLComponents(string: "\(Endpoints.Gets.games.url)/\(gameId)")!
			components.queryItems = [
				URLQueryItem(name: "key", value: API.apiKey)
			]
			
			guard let url = components.url else { return }
			
			AF.request(url)
				.validate()
				.responseDecodable(of: GameDetailResponse.self) { response in
					switch response.result {
					case .success(let value):
						completion(.success(value))
					case .failure:
						completion(.failure(URLError.invalidResponse))
					}
				}
		}.eraseToAnyPublisher()
	}
	
}
