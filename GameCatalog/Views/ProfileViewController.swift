//
//  ProfileViewController.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 18/11/22.
//

import UIKit

class ProfileViewController: UIViewController {
	
	@IBOutlet weak var profileName: UILabel!
	@IBOutlet weak var profileEmail: UILabel!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		ProfileModel.synchronize()
		
		if ProfileModel.stateLogin {
			profileName.text = ProfileModel.name
			profileEmail.text = ProfileModel.email
		} else {
			profileName.text = UserDefaults.standard.string(forKey: "nameKey")
			profileEmail.text = UserDefaults.standard.string(forKey: "emailKey")
		}
	}
	
	@IBAction func editButton(_ sender: Any) {
		self.performSegue(withIdentifier: "moveToEdit", sender: self)
	}
}
