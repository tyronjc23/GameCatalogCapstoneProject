//
//  profileModel.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 18/11/22.
//

import UIKit

struct ProfileModel {
	static let stateLoginKey = "state"
	static let nameKey = "name"
	static let emailKey = "email"
	
	static var stateLogin: Bool {
		get {
			return UserDefaults.standard.bool(forKey: stateLoginKey)
		}
		
		set {
			UserDefaults.standard.set(newValue, forKey: stateLoginKey)
		}
	}
	
	static var name: String {
		get {
			return UserDefaults.standard.string(forKey: nameKey) ?? ""
		}
		
		set {
			UserDefaults.standard.set(newValue, forKey: nameKey)
		}
	}
	
	static var email: String {
		get {
			return UserDefaults.standard.string(forKey: emailKey) ?? ""
		}
		
		set {
			UserDefaults.standard.set(newValue, forKey: emailKey)
		}
	}
	
	static func synchronize() {
		UserDefaults.standard.synchronize()
	}
	
}
