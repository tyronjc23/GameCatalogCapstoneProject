//
//  Error.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 27/01/23.
//

import Foundation

enum URLError: LocalizedError {
	case invalidResponse
	case addressUnreachable(URL)
	
	var errorDescription: String? {
		switch self {
		case .invalidResponse: return "The server responded with garbage."
		case .addressUnreachable(let url): return "\(url.absoluteString) is unreachable."
		}
	}
}

enum DatabaseError: LocalizedError {
	
	case noData
	case saveFailed
	case updateFailed
	case requestFailed
	
	var errorDescription: String? {
		switch self {
		case .noData: return "Database can't find the data."
		case .saveFailed: return "Failed to save data."
		case .updateFailed: return "Failed to update data."
		case .requestFailed: return "Your request failed."
		}
	}
	
}
