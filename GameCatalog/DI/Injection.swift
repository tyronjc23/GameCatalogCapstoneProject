//
//  Injection.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import Foundation

final class Injection {
	
	private func provideRepository() -> GameRepositoryProtocol {
		let remote: RemoteDataSource = RemoteDataSource.shared
		let locale: LocaleDataSource = LocaleDataSource.shared
		return GameRepository.shared(locale, remote)
	}
	
	func provideHome() -> HomeUseCase {
		let repository = provideRepository()
		return HomeInteractor(repository: repository)
	}
	
	func provideDetail(gameId: Int) -> DetailUseCase {
		let repository = provideRepository()
		return DetailInteractor(repository: repository, gameId: gameId)
	}
	
	func provideFavorite() -> FavoriteUseCase {
		let repository = provideRepository()
		return FavoriteInteractor(repository: repository)
	}
	
}
