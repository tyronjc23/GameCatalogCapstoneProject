//
//  Mapper.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import UIKit

final class Mapper {
	
	static let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
	
	static func mapGameResponseToEntities(input gameResponse: [GameResponse]) -> [GameData] {
		gameResponse.map { result in
			let game = GameData(context: context)
			game.id = Int32(result.id)
			game.title = result.title
			game.releasedDate = result.releasedDate
			game.posterPath = result.posterPath
			game.rating = result.rating
			
			var genres = [String]()
			for genre in result.genres {
				genres.append(genre.name)
			}
			game.genres = genres.joined(separator: ", ")
			
			return game
		}
	}
	
	static func mapGameEntitiesToDomains(input gameEntities: [GameData]) -> [GameModel] {
		gameEntities.map { result in
			let gameModel = GameModel(id: Int(result.id),
											  title: result.title,
											  releasedDate: result.releasedDate,
											  posterPath: result.posterPath,
											  rating: result.rating)
			
			gameModel.genres = result.genres ?? ""
			gameModel.favorite = result.favorite
			gameModel.gameDescription = result.gameDescription ?? ""
			gameModel.publishers = result.publishers ?? ""
			gameModel.developers = result.developers ?? ""
			
			if result.imgDownloadState {
				gameModel.state = .downloaded
			}
			
			if let image = result.image {
				gameModel.image = UIImage(data: image)
			}
			
			return gameModel
		}
	}
	
	static func mapGameEntityToDomains(input gameEntity: GameData) -> GameModel {
		let gameModel = GameModel(
			id: Int(gameEntity.id),
			title: gameEntity.title,
			releasedDate: gameEntity.releasedDate,
			posterPath: gameEntity.posterPath,
			rating: gameEntity.rating
		)
		
		gameModel.genres = gameEntity.genres ?? ""
		gameModel.favorite = gameEntity.favorite
		gameModel.gameDescription = gameEntity.gameDescription ?? ""
		gameModel.publishers = gameEntity.publishers ?? ""
		gameModel.developers = gameEntity.developers ?? ""
		
		if gameEntity.imgDownloadState {
			gameModel.state = .downloaded
		}
		
		if let image = gameEntity.image {
			gameModel.image = UIImage(data: image)
		}
		
		return gameModel
	}
	
	static func mapGameDetailResponseToEntity(input response: GameDetailResponse) -> GameDetailModel {
		var game = GameDetailModel(gameId: response.id)
		game.gameDescription = response.description
		
		if let dev = response.developers?[0], let pub = response.publishers?[0] {
			game.developers = dev.name
			game.publishers = pub.name
		}
		
		return game
	}
	
}
