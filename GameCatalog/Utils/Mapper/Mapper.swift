//
//  Mapper.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 05/12/22.
//

import UIKit

final class Mapper {
	
	static func mapRemoteGamesToDomains(input gameLists: [GameList]) -> [Game] {
		return gameLists.map { result in
			let game = Game(
				id: result.id,
				title: result.title,
				releasedDate: result.releasedDate,
				posterPath: result.posterPath,
				rating: result.rating
			)
			
			var genres = [String]()
			for genre in result.genres {
				genres.append(genre.name)
			}
			game.genres = genres.joined(separator: ", ")
			
			return game
		}
	}
	
	static func mapLocalGamesToDomains(input gameData: [GameData]) -> [Game] {
		return gameData.map { result in
			let game = Game(
				id: Int(result.id),
				title: result.title,
				releasedDate: result.releasedDate,
				posterPath: result.posterPath,
				rating: result.rating
			)
			
			game.genres = result.genres
			game.favorite = result.favorite
			game.gameDescription = result.gameDescription
			game.publishers = result.publishers
			game.developers = result.developers
			
			if let imageData = result.image {
				game.image = UIImage(data: imageData)
			}
			
			if result.imgDownloadState {
				game.state = .downloaded
			}
			
			return game
		}
	}
	
	static func mapLocalGameToDomains(input gameData: GameData) -> Game {
		let game = Game(
			id: Int(gameData.id),
			title: gameData.title,
			releasedDate: gameData.releasedDate,
			posterPath: gameData.posterPath,
			rating: gameData.rating
		)
		
		game.genres = gameData.genres
		game.favorite = gameData.favorite
		game.gameDescription = gameData.gameDescription
		game.publishers = gameData.publishers
		game.developers = gameData.developers
		
		if let imageData = gameData.image {
			game.image = UIImage(data: imageData)
		}
		
		if gameData.imgDownloadState {
			game.state = .downloaded
		}
		
		return game
	}
	
}
