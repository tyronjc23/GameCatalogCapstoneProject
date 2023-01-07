//
//  HomeInteractor.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation

protocol DetailUseCase {
	
	func getGame(completion: @escaping(Result<Game, Error>) -> Void)
	
}

class DetailInteractor: DetailUseCase {
	
	private let repository: GameRepositoryProtocol
	private var gameId: Int
	
	required init(repository: GameRepositoryProtocol, gameId: Int) {
		self.repository = repository
		self.gameId = gameId
	}
	
	func getGame(completion: @escaping(Result<Game, Error>) -> Void) {
		repository.getDetailGame(with: gameId) { result in
			switch result {
			case .success(let game):
				completion(.success(game))
			case .failure(let error):
				completion(.failure(error))
				
			}
		}
	}
	
}
