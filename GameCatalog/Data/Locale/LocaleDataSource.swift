//
//  RemoteDataSource.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

protocol LocaleDataSourceProtocol: AnyObject {
	
	func getAllGames() -> AnyPublisher<[GameData], Error>
	func getGame(with gameId: Int) -> AnyPublisher <GameData, Error>
	func getAllFavorites() -> AnyPublisher<[GameData], Error>
	func addGames(from games: [GameData]) -> AnyPublisher<Bool, Error>
	
}

final class LocaleDataSource: NSObject {
	
	private override init() { }
	
	static let shared: LocaleDataSource = LocaleDataSource()
	
}

extension LocaleDataSource: LocaleDataSourceProtocol {
	
	func getAllGames() -> AnyPublisher<[GameData], Error> {
		return Future<[GameData], Error> { completion in
			do {
				let games = try GameData.getAllGames()
				completion(.success(games))
			} catch {
				completion(.failure(DatabaseError.noData))
			}
		}.eraseToAnyPublisher()
	}
	
	func getGame(with gameId: Int) -> AnyPublisher<GameData, Error> {
		return Future<GameData, Error> { completion in
			guard let game = GameData.getGame(with: gameId) else {
				completion(.failure(DatabaseError.noData))
				return
			}
			completion(.success(game))
			
		}.eraseToAnyPublisher()
	}
	
	func getAllFavorites() -> AnyPublisher<[GameData], Error> {
		return Future<[GameData], Error> { completion in
			do {
				let games = try GameData.getAllFavorites()
				completion(.success(games))
			} catch {
				completion(.failure(DatabaseError.noData))
			}
		}.eraseToAnyPublisher()
	}
	
	func addGames(from games: [GameData]) -> AnyPublisher<Bool, Error> {
		return Future<Bool, Error> { completion in
			do {
				for game in games {
					try GameData.saveGameData(game)
				}
				completion(.success(true))
			} catch {
				completion(.failure(error))
			}
		}.eraseToAnyPublisher()
	}
	
	func addDetailGame(from detail: GameDetailModel) -> AnyPublisher<Bool, Error> {
		return Future<Bool, Error> { completion in
			do {
				try GameData.addDetailGame(detail)
				completion(.success(true))
			} catch {
				completion(.failure(error))
			}
		}.eraseToAnyPublisher()
	}
	
	func updateGame(from game: GameModel) -> AnyPublisher<Bool, Error> {
		return Future<Bool, Error> { completion in
			do {
				try GameData.update(game)
				completion(.success(true))
			} catch {
				completion(.failure(error))
			}
		}.eraseToAnyPublisher()
	}
	
}
