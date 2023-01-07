//
//  GameRepository.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

protocol GameRepositoryProtocol {
	
	// Completion Handler
	func getGames(result: @escaping(Result<[Game], Error>) -> Void)
	func getDetailGame(with gameId: Int, result: @escaping(Result<Game, Error>) -> Void)
	func getFavoriteGames(result: @escaping(Result<[Game], Error>) -> Void)
	
	// Combine
	func getGamesWithCombine() -> AnyPublisher<[Game], Error>
	func getFavoriteGamesWithCombine() -> AnyPublisher<[Game], Error>
	
}

class GameRepository {
	
	typealias GameInstance = (LocaleDataSource, RemoteDataSource) -> GameRepository
	
	fileprivate let locale: LocaleDataSource
	fileprivate let remote: RemoteDataSource
	
	private init(locale: LocaleDataSource, remote: RemoteDataSource) {
		self.locale = locale
		self.remote = remote
	}
	
	static let shared: GameInstance = { localeRepository, remoteRepository in
		return GameRepository(locale: localeRepository, remote: remoteRepository)
	}
	
}

extension GameRepository: GameRepositoryProtocol {
	
	// MARK: Completion Handler
	
	func getGames(result: @escaping (Result<[Game], Error>) -> Void) {
		locale.getGames { gameDataResponses in
			switch gameDataResponses {
			case .success(let gameData):
				if gameData.isEmpty {
					self.remote.getGames { responses in
						switch responses {
						case .success(let gameResponse):
							let gameAdd = Mapper.mapRemoteGamesToDomains(input: gameResponse)
							self.locale.addGames(from: gameAdd) { isAdd in
								if isAdd {
									self.locale.getGames { response in
										do {
											let gameData = try response.get()
											let games = Mapper.mapLocalGamesToDomains(input: gameData)
											result(.success(games))
										} catch {
											result(.failure(error))
										}
									}
								} else {
									result(.failure(NSError(domain: "Gagal Menyimpan ke CORE DATA", code: 1)))
								}
							}
						case .failure(let error):
							result(.failure(error))
						}
					}
				} else {
					let games = Mapper.mapLocalGamesToDomains(input: gameData)
					result(.success(games))
				}
			case .failure(let error):
				result(.failure(error))
			}
		}
	}
	
	func getDetailGame(with gameId: Int, result: @escaping (Result<Game, Error>) -> Void) {
		locale.getDetailGame(with: gameId) { [self] gameData in
			let game = Mapper.mapLocalGameToDomains(input: gameData)
			if game.gameDescription == nil {
				remote.getDetailGame(gameId: gameId) { response in
					switch response {
					case .success(let detail):
						if let dev = detail.developers?[0], let pub = detail.publishers?[0] {
							game.gameDescription = detail.description
							game.developers = dev.name
							game.publishers = pub.name
							GameData.updateData(game)
							result(.success(game))
						}
					case .failure(let error):
						result(.failure(error))
					}
				}
			} else {
				result(.success(game))
			}
		}
	}
	
	func getFavoriteGames(result: @escaping (Result<[Game], Error>) -> Void) {
		locale.getFavoriteGames { responses in
			switch responses {
			case .success(let gameData):
				if !gameData.isEmpty {
					let favoriteGames = Mapper.mapLocalGamesToDomains(input: gameData)
					result(.success(favoriteGames))
				} else {
					let error = NSError(domain: "No Favorite Games", code: 1)
					result(.failure(error))
				}
			case .failure(let error):
				result(.failure(error))
			}
			
		}
	}
	
	// MARK: Combine Function
	
	func getGamesWithCombine() -> AnyPublisher<[Game], Error> {
		return self.locale.getGamesWithCombine()
			.flatMap { result -> AnyPublisher<[Game], Error> in
				if result.isEmpty {
					return self.remote.getGamesWithCombine()
						.map { Mapper.mapRemoteGamesToDomains(input: $0) }
						.flatMap { self.locale.addGamesWithCombine(from: $0) }
						.filter { $0 }
						.flatMap { _ in self.locale.getGamesWithCombine()
								.map { Mapper.mapLocalGamesToDomains(input: $0) }
						}
						.eraseToAnyPublisher()
				} else {
					return self.locale.getGamesWithCombine()
						.map { Mapper.mapLocalGamesToDomains(input: $0) }
						.eraseToAnyPublisher()
				}
			}.eraseToAnyPublisher()
	}
	
	func getFavoriteGamesWithCombine() -> AnyPublisher<[Game], Error> {
		return self.locale.getFavoriteGamesWithCombine()
			.map { Mapper.mapLocalGamesToDomains(input: $0) }
			.filter { !$0.isEmpty }
			.eraseToAnyPublisher()
	}
	
}
