//
//  SceneDelegate.swift
//  GameCatalog
//
//  Created by Tyron Aprilian on 01/11/22.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
	
	var window: UIWindow?
	let storyboard = UIStoryboard(name: "Main", bundle: nil)
	
	func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
		guard let windowScene = (scene as? UIWindowScene) else { return }
		
		let window = UIWindow(windowScene: windowScene)
		
		if let homeVC = storyboard.instantiateViewController(withIdentifier: "HomeScene") as? HomeViewController,
			let favoriteVC = storyboard.instantiateViewController(withIdentifier: "FavoriteScene") as? FavoriteViewController,
			let profileVC = storyboard.instantiateViewController(withIdentifier: "ProfileScene") as? ProfileViewController {
			let tabBar = UITabBarController()
			let inject = Injection.init()
			
			// Home View Controller
			homeVC.presenter = HomePresenter(homeUseCase: inject.provideHome())
			let homeNav = UINavigationController(rootViewController: homeVC)
			homeNav.tabBarItem = UITabBarItem(title: "Games", image: UIImage(systemName: "gamecontroller.fill"), tag: 0)
			homeNav.navigationBar.prefersLargeTitles = true
			
			// Favorite View Controller
			favoriteVC.presenter = FavoritePresenter(favoriteUseCase: inject.provideFavorite())
			let favoriteNav = UINavigationController(rootViewController: favoriteVC)
			favoriteNav.tabBarItem = UITabBarItem(title: "Favorites", image: UIImage(systemName: "heart.fill"), tag: 1)
			favoriteNav.navigationBar.prefersLargeTitles = true
			
			// Profile View Controller
			let profileNav = UINavigationController(rootViewController: profileVC)
			profileNav.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person.circle"), tag: 2)
			profileNav.navigationBar.prefersLargeTitles = true
			
			tabBar.setViewControllers([homeNav, favoriteNav, profileNav], animated: true)
			window.rootViewController = tabBar
			self.window = window
			window.makeKeyAndVisible()
		}
	}
	
	func sceneDidDisconnect(_ scene: UIScene) {
		// Called as the scene is being released by the system.
		// This occurs shortly after the scene enters the background, or when its session is discarded.
		// Release any resources associated with this scene that can be re-created the next time the scene connects.
		// The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
	}
	
	func sceneDidBecomeActive(_ scene: UIScene) {
		// Called when the scene has moved from an inactive state to an active state.
		// Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
	}
	
	func sceneWillResignActive(_ scene: UIScene) {
		// Called when the scene will move from an active state to an inactive state.
		// This may occur due to temporary interruptions (ex. an incoming phone call).
	}
	
	func sceneWillEnterForeground(_ scene: UIScene) {
		// Called as the scene transitions from the background to the foreground.
		// Use this method to undo the changes made on entering the background.
	}
	
	func sceneDidEnterBackground(_ scene: UIScene) {
		// Called as the scene transitions from the foreground to the background.
		// Use this method to save data, release shared resources, and store enough scene-specific state information
	}
}
