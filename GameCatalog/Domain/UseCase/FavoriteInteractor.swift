//
//  HomeInteractor.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

protocol FavoriteUseCase {
	
	func getFavorites() -> AnyPublisher<[GameModel], Error>
	
}

class FavoriteInteractor: FavoriteUseCase {
	
	private let repository: GameRepositoryProtocol
	
	required init(repository: GameRepositoryProtocol) {
		self.repository = repository
	}
	
	func getFavorites() -> AnyPublisher<[GameModel], Error> {
		return repository.getAllFavorites()
	}
	
}
