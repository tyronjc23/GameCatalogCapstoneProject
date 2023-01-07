//
//  HomeInteractor.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

protocol FavoriteUseCase {
	
	// Completion Handler
	func getFavoriteGames(completion: @escaping(Result<[Game], Error>) -> Void)
	
	// Combine
	func getFavoriteGamesWithCombine() -> AnyPublisher<[Game], Error>
	
}

class FavoriteInteractor: FavoriteUseCase {
	
	private let repository: GameRepositoryProtocol
	
	required init(repository: GameRepositoryProtocol) {
		self.repository = repository
	}
	
	// MARK: Completion Handler
	
	func getFavoriteGames(completion: @escaping (Result<[Game], Error>) -> Void) {
		repository.getFavoriteGames { result in
			completion(result)
		}
	}
	
	// MARK: Combine Function
	
	func getFavoriteGamesWithCombine() -> AnyPublisher<[Game], Error> {
		return repository.getFavoriteGamesWithCombine()
	}
	
}
