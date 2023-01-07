//
//  HomePresenter.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

class FavoritePresenter {
	
	private let favoriteUseCase: FavoriteUseCase
	
	init(favoriteUseCase: FavoriteUseCase) {
		self.favoriteUseCase = favoriteUseCase
	}
	
	// MARK: Completion Handler
	
	func getFavoriteGames(completion: @escaping(Result<[Game], Error>) -> Void) {
		favoriteUseCase.getFavoriteGames { result in
			completion(result)
		}
	}
	
	// MARK: Combine Function
	
	func getFavoriteGamesWithCombine() -> AnyPublisher<[Game], Error> {
		return favoriteUseCase.getFavoriteGamesWithCombine()
	}
	
}
