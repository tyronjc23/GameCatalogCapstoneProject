//
//  HomePresenter.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation
import Combine

class DetailPresenter {
	
	private let detailUseCase: DetailUseCase
	
	init(detailUseCase: DetailUseCase) {
		self.detailUseCase = detailUseCase
	}
	
	func getGame() -> AnyPublisher<GameModel, Error> {
		return detailUseCase.getGame()
	}
	
}
