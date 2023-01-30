//
//  HomeInteractor.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

protocol HomeUseCase {
	
	func getGames() -> AnyPublisher<[GameModel], Error>
	func updateGame(game: GameModel) -> AnyPublisher<Bool, Error>
	
}

class HomeInteractor: HomeUseCase {
	
	private let repository: GameRepositoryProtocol
	
	required init(repository: GameRepositoryProtocol) {
		self.repository = repository
	}
	
	func getGames() -> AnyPublisher<[GameModel], Error> {
		return repository.getAllGames()
	}
	
	func updateGame(game: GameModel) -> AnyPublisher<Bool, Error> {
		return repository.updateGame(with: game)
	}
	
}
