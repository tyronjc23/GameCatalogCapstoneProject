//
//  GameRepository.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import UIKit
import Combine

protocol GameRepositoryProtocol {
	
	func getAllGames() -> AnyPublisher<[GameModel], Error>
	func getGame(with gameId: Int) -> AnyPublisher<GameModel, Error>
	func getAllFavorites() -> AnyPublisher<[GameModel], Error>
	func updateGame(with game: GameModel) -> AnyPublisher<Bool, Error>
	
}

class GameRepository {
	
	let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
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
	
	func getAllGames() -> AnyPublisher<[GameModel], Error> {
		return self.locale.getAllGames()
			.flatMap { result -> AnyPublisher<[GameModel], Error> in
				if result.isEmpty {
					return self.remote.getAllGames()
						.map { Mapper.mapGameResponseToEntities(input: $0) }
						.flatMap { self.locale.addGames(from: $0) }
						.filter { $0 }
						.flatMap { _ in self.locale.getAllGames()
								.map { Mapper.mapGameEntitiesToDomains(input: $0) }
						}
						.eraseToAnyPublisher()
				} else {
					return self.locale.getAllGames()
						.map { Mapper.mapGameEntitiesToDomains(input: $0) }
						.eraseToAnyPublisher()
				}
			}.eraseToAnyPublisher()
	}
	
	func getGame(with gameId: Int) -> AnyPublisher<GameModel, Error> {
		return self.locale.getGame(with: gameId)
			.flatMap { result -> AnyPublisher<GameModel, Error> in
				if result.gameDescription == "" {
					return self.remote.getDetailGame(with: Int(result.id))
						.map { Mapper.mapGameDetailResponseToEntity(input: $0) }
						.flatMap { self.locale.addDetailGame(from: $0) }
						.filter { $0 }
						.flatMap { _ in self.locale.getGame(with: gameId)
							.map { Mapper.mapGameEntityToDomains(input: $0) }
						}
						.eraseToAnyPublisher()
				} else {
					return self.locale.getGame(with: gameId)
						.map { Mapper.mapGameEntityToDomains(input: $0) }
						.eraseToAnyPublisher()
				}
			}.eraseToAnyPublisher()
	}
	
	func getAllFavorites() -> AnyPublisher<[GameModel], Error> {
		return self.locale.getAllFavorites()
			.map { Mapper.mapGameEntitiesToDomains(input: $0) }
			.filter { !$0.isEmpty }
			.eraseToAnyPublisher()
	}
	
	func updateGame(with game: GameModel) -> AnyPublisher<Bool, Error> {
		return self.locale.updateGame(from: game)
	}
	
}
