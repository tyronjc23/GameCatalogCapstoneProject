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
	
	func getGames() -> AnyPublisher<[GameModel], Error> {
		return homeUseCase.getGames()
	}
	
	func updateGames(game: GameModel) -> AnyPublisher<Bool, Error> {
		return homeUseCase.updateGame(game: game)
	}
	
}
