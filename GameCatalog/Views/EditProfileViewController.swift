//
//  EditProfileViewController.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 18/11/22.
//

import UIKit

class EditProfileViewController: UIViewController {
	
	@IBOutlet weak var nameField: UITextField!
	@IBOutlet weak var emailField: UITextField!
	
	override func viewDidLoad() {
		super.viewDidLoad()
	}
	
	override func viewDidAppear(_ animated: Bool) {
		ProfileModel.synchronize()
		
		if ProfileModel.stateLogin {
			nameField.text = ProfileModel.name
			emailField.text = ProfileModel.email
		} else {
			nameField.text = UserDefaults.standard.string(forKey: "nameKey")
			emailField.text = UserDefaults.standard.string(forKey: "emailKey")
		}
	}
	
	@IBAction func saveButton(_ sender: Any) {
		if let name = nameField.text, let email = emailField.text {
			if name.isEmpty {
				textEmpty(name)
			} else if email.isEmpty {
				textEmpty(email)
			} else {
				ProfileModel.stateLogin = true
				ProfileModel.name = name
				ProfileModel.email = email
				
				self.dismiss(animated: true)
			}
		}
	}
	
	@IBAction func cancelButton(_ sender: Any) {
		self.dismiss(animated: true)
	}
	
	func textEmpty(_ field: String) {
		let alert = UIAlertController(title: "Alert",
												message: "\(field) is Empty.",
												preferredStyle: .alert)
		
		alert.addAction(UIAlertAction(title: "OK",
												style: .default,
												handler: nil))
		
		self.present(alert, animated: true, completion: nil)
	}
}
