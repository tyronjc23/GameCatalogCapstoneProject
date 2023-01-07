//
//  RemoteDataSource.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

protocol LocaleDataSourceProtocol: AnyObject {
	
	// Completion Handler
	func getGames(result: @escaping (Result<[GameData], Error>) -> Void)
	func getDetailGame(with gameId: Int, result: @escaping (GameData) -> Void)
	func getFavoriteGames(result: @escaping (Result<[GameData], Error>) -> Void)
	func addGames(from games: [Game], result: @escaping (Bool) -> Void)
	
	// Combine
	func getGamesWithCombine() -> AnyPublisher<[GameData], Error>
	func getFavoriteGamesWithCombine() -> AnyPublisher<[GameData], Error>
	func addGamesWithCombine(from games: [Game]) -> AnyPublisher<Bool, Error>
	
}

final class LocaleDataSource: NSObject {
	
	private override init() { }
	
	static let shared: LocaleDataSource = LocaleDataSource()
	
}

extension LocaleDataSource: LocaleDataSourceProtocol {
	
	// MARK: Completion Handler
	
	func getGames(result: @escaping (Result<[GameData], Error>) -> Void) {
		do {
			let games = try GameData.getGameData()
			result(.success(games))
		} catch {
			result(.failure(error))
		}
	}
	
	func getDetailGame(with gameId: Int, result: @escaping (GameData) -> Void) {
		if let game = GameData.getGame(with: gameId) {
			result(game)
		}
	}
	
	func getFavoriteGames(result: @escaping (Result<[GameData], Error>) -> Void) {
		do {
			let games = try GameData.getFavorites()
			result(.success(games))
		} catch {
			result(.failure(error))
		}
	}
	
	func addGames(from games: [Game], result: @escaping (Bool) -> Void) {
		do {
			for game in games {
				try GameData.saveGameData(game)
			}
			result(true)
		} catch {
			result(false)
		}
	}
	
	// MARK: Combine Function
	
	func getGamesWithCombine() -> AnyPublisher<[GameData], Error> {
		return Future<[GameData], Error> { completion in
			do {
				let games = try GameData.getGameData()
				completion(.success(games))
			} catch {
				completion(.failure(error))
			}
		}.eraseToAnyPublisher()
	}
	
	func getFavoriteGamesWithCombine() -> AnyPublisher<[GameData], Error> {
		return Future<[GameData], Error> { completion in
			do {
				let games = try GameData.getFavorites()
				completion(.success(games))
			} catch {
				completion(.failure(error))
			}
		}.eraseToAnyPublisher()
	}
	
	func addGamesWithCombine(from games: [Game]) -> AnyPublisher<Bool, Error> {
		return Future<Bool, Error> { completion in
			do {
				for game in games {
					try GameData.saveGameData(game)
				}
				completion(.success(true))
			} catch {
				let error = NSError(domain: "Databse error", code: 1)
				completion(.failure(error))
			}
		}.eraseToAnyPublisher()
	}
	
}
