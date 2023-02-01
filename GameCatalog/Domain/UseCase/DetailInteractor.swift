//
//  HomeInteractor.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

protocol DetailUseCase {
	
	func getGame() -> AnyPublisher<GameModel, Error>
	
}

class DetailInteractor: DetailUseCase {
	
	private let repository: GameRepositoryProtocol
	private var gameId: Int
	
	required init(repository: GameRepositoryProtocol, gameId: Int) {
		self.repository = repository
		self.gameId = gameId
	}
	
	func getGame() -> AnyPublisher<GameModel, Error> {
		return repository.getGame(with: gameId)
	}
	
}
