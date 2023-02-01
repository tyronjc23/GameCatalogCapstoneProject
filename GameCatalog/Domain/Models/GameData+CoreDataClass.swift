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
	
	static func getAllGames() throws -> [GameData] {
		let request = GameData.fetchRequest()
		let sort = NSSortDescriptor(key: "title", ascending: true)
		request.sortDescriptors = [sort]
		do {
			return try context.fetch(request)
		} catch {
			throw DatabaseError.noData
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
	
	static func getAllFavorites() throws -> [GameData] {
		let request = GameData.fetchRequest()
		let filter = NSPredicate(format: "favorite == \(true)")
		let sort = NSSortDescriptor(key: "title", ascending: true)
		request.predicate = filter
		request.sortDescriptors = [sort]
		do {
			return try context.fetch(request)
		} catch {
			throw DatabaseError.noData
		}
	}
	
	static func saveGameData(_ game: GameData) throws {
		do {
			try context.save()
		} catch {
			print("Error: \(error)")
			throw DatabaseError.saveFailed
		}
	}
	
	static func addDetailGame(_ detail: GameDetailModel) throws {
		if let gameData = getGame(with: detail.gameId) {
			gameData.gameDescription = detail.gameDescription
			gameData.developers = detail.developers
			gameData.publishers = detail.publishers
		}
		
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print("Update Failed!: \(error)")
				throw DatabaseError.updateFailed
			}
		} else {
			print("No Data to Update.")
			throw DatabaseError.requestFailed
		}
	}
	
	static func updateData(_ game: GameData) throws {
		if let gameData = getGame(with: Int(game.id)) {
			gameData.image = game.image
			gameData.favorite = game.favorite
			gameData.gameDescription = game.gameDescription
			gameData.developers = game.developers
			gameData.publishers = game.publishers
			gameData.imgDownloadState = game.imgDownloadState
		}
		
		if context.hasChanges {
			do {
				try context.save()
			} catch {
				print("Update Failed!: \(error)")
				throw DatabaseError.updateFailed
			}
		} else {
			print("No Data to Update.")
			throw DatabaseError.requestFailed
		}
	}
	
	static func update(_ game: GameModel) throws {
		if let gameData = getGame(with: Int(game.id)) {
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
				print("Update Failed!: \(error)")
				throw DatabaseError.updateFailed
			}
		} else {
			print("No Data to Update.")
			throw DatabaseError.requestFailed
		}
	}
	
	static func deleteFavorite(_ item: GameData) throws {
		context.delete(item)
		
		do {
			try context.save()
		} catch {
			throw DatabaseError.requestFailed
		}
	}
	
	static func deleteAll() throws {
		let delete = NSBatchDeleteRequest(fetchRequest: fetchRequest())
		
		do {
			try context.execute(delete)
		} catch {
			throw DatabaseError.requestFailed
		}
	}
	
}
