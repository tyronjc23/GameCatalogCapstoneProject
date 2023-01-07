//
//  GameData+CoreDataClass.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 18/11/22.
//
//

import CoreData
import UIKit

@objc(GameData)
public class GameData: NSManagedObject {
	
	static let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
	
	static func getGameData() throws -> [GameData] {
		let request = GameData.fetchRequest()
		let sort = NSSortDescriptor(key: "title", ascending: true)
		request.sortDescriptors = [sort]
		do {
			return try context.fetch(request)
		} catch {
			print(error)
			throw error
		}
	}
	
	static func getGame(with gameId: Int) -> GameData? {
		let request = GameData.fetchRequest()
		request.fetchLimit = 1
		let filter = NSPredicate(format: "id == \(gameId)")
		request.predicate = filter
		do {
			return try context.fetch(request).first
		} catch {
			print(error)
			return nil
		}
		
	}
	
	static func getFavorites() throws -> [GameData] {
		let request = GameData.fetchRequest()
		let filter = NSPredicate(format: "favorite == \(true)")
		let sort = NSSortDescriptor(key: "title", ascending: true)
		request.predicate = filter
		request.sortDescriptors = [sort]
		do {
			return try context.fetch(request)
		} catch {
			print(error)
			throw error
		}
	}
	
	static func getFavorite(with gameId: Int) -> GameData? {
		let request = GameData.fetchRequest()
		request.fetchLimit = 1
		let filter = NSPredicate(format: "id == \(gameId)")
		request.predicate = filter
		do {
			return try context.fetch(request).first
		} catch {
			print(error)
			return nil
		}
	}
	
	static func saveFavorite(_ gameId: Int, _ title: String, _ releasedDate: Date, _ rating: Double, _ image: Data, _ url: URL) {
		let newFavorite = GameData(context: context)
		newFavorite.id = Int32(gameId)
		newFavorite.title = title
		newFavorite.releasedDate = releasedDate
		newFavorite.rating = rating
		newFavorite.image = image
		newFavorite.posterPath = url
		do {
			try context.save()
		} catch let error as NSError {
			print("Error: \(error), \(error.userInfo)")
		}
	}
	
	static func saveGameData(_ game: Game) throws {
		let newData = GameData(context: context)
		
		newData.id = Int32(game.id)
		newData.title = game.title
		newData.releasedDate = game.releasedDate
		newData.rating = game.rating
		newData.image = game.image?.pngData()
		newData.posterPath = game.posterPath
		newData.favorite = game.favorite
		newData.genres = game.genres
		do {
			try context.save()
		} catch {
			print("Error: \(error)")
			throw error
		}
	}
	
	static func updateData(_ game: Game) {
		if let gameData = getFavorite(with: game.id) {
			gameData.image = game.image?.pngData()
			gameData.favorite = game.favorite
			gameData.gameDescription = game.gameDescription
			gameData.developers = game.developers
			gameData.publishers = game.publishers
			
			if game.state == .downloaded {
				gameData.imgDownloadState = true
			}
		}
		
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print("Error: \(error)")
			}
		} else {
			print("Update Failed!")
		}
		
	}
	
	static func deleteFavorite(_ item: GameData) {
		context.delete(item)
		
		do {
			try context.save()
		} catch let error as NSError {
			print("Error: \(error), \(error.userInfo)")
		}
	}
	
	static func deleteAll() {
		let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest())
		do {
			try context.execute(delete)
		} catch {
			print(error)
		}
	}
	
}
