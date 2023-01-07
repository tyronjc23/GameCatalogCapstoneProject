//
//  HomePresenter.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

class HomePresenter {
	
	private let homeUseCase: HomeUseCase
	
	init(homeUseCase: HomeUseCase) {
		self.homeUseCase = homeUseCase
	}
	
	// MARK: Completion Handler
	
	func getGames(completion: @escaping (Result<[Game], Error>) -> Void) {
		homeUseCase.getGames { result in
			completion(result)
		}
	}
	
	// MARK: Combine Function
	
	func getGamesWithCombine() -> AnyPublisher<[Game], Error> {
		return homeUseCase.getGamesWithCombine()
	}
	
}
