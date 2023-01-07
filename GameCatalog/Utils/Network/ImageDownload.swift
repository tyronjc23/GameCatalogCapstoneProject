//
//  ImageDownload.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 02/11/22.
//

import UIKit

class ImageDownload {
	func downloadImage(url: URL) async throws -> UIImage {
		let (imageURL, _) = try await URLSession.shared.download(from: url)
		async let imageData: Data = try Data(contentsOf: imageURL)
		guard let image = UIImage(data: try await imageData) else {
			throw NSError(domain: "Error Load Image", code: 1)
		}
		
		return image
	}
}
