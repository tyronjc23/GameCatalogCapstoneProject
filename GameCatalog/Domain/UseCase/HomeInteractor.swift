//
//  HomeInteractor.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

protocol HomeUseCase {
	
	// Completion Handler
	func getGames(completion: @escaping(Result<[Game], Error>) -> Void)
	
	// Combine
	func getGamesWithCombine() -> AnyPublisher<[Game], Error>
	
}

class HomeInteractor: HomeUseCase {
	
	private let repository: GameRepositoryProtocol
	
	required init(repository: GameRepositoryProtocol) {
		self.repository = repository
	}
	
	// MARK: Completion Handler
	
	func getGames(completion: @escaping (Result<[Game], Error>) -> Void) {
		repository.getGames { result in
			completion(result)
		}
	}
	
	// MARK: Combine Function
	
	func getGamesWithCombine() -> AnyPublisher<[Game], Error> {
		return repository.getGamesWithCombine()
	}
	
}
