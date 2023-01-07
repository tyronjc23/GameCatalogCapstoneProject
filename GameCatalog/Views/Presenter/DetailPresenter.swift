//
//  HomePresenter.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation

protocol DetailPresenterProtocol {
	
	func getGame(completion: @escaping(Result<Game, Error>) -> Void)
	
}

class DetailPresenter: DetailPresenterProtocol {
	
	private let detailUseCase: DetailUseCase
	
	init(detailUseCase: DetailUseCase) {
		self.detailUseCase = detailUseCase
	}
	
	func getGame(completion: @escaping(Result<Game, Error>) -> Void) {
		detailUseCase.getGame { result in
			completion(result)
		}
	}
	
}
