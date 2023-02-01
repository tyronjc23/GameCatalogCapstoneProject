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
	
	func getFavorites() -> AnyPublisher<[GameModel], Error> {
		return favoriteUseCase.getFavorites()
	}
	
}
