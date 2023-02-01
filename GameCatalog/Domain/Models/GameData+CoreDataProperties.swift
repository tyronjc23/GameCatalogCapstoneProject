//
//  GameData+CoreDataProperties.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 09/12/22.
//
//

import Foundation
import CoreData

extension GameData {
	
	@nonobjc public class func fetchRequest() -> NSFetchRequest<GameData> {
		return NSFetchRequest<GameData>(entityName: "GameData")
	}
	
	@NSManaged public var developers: String?
	@NSManaged public var favorite: Bool
	@NSManaged public var gameDescription: String?
	@NSManaged public var genres: String?
	@NSManaged public var id: Int32
	@NSManaged public var image: Data?
	@NSManaged public var imgDownloadState: Bool
	@NSManaged public var publishers: String?
	@NSManaged public var rating: Double
	@NSManaged public var releasedDate: Date
	@NSManaged public var title: String
	@NSManaged public var posterPath: URL
	
}

extension GameData: Identifiable {
	
}
