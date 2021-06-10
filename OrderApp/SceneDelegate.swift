//
//  SceneDelegate.swift
//  OrderApp
//
//  Created by Олег Бабыр on 29.05.2021.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    var orderTabBarItem: UITabBarItem!
    
    func stateRestorationActivity(for scene: UIScene) -> NSUserActivity? {
        return MenuController.shared.userActivity
    }
    
    func configureScene(for userActivity: NSUserActivity) {
        if let restoredOrder = userActivity.order {
            MenuController.shared.order = restoredOrder
        }
        
        guard
            let restorationController = StateRestorationController(userActivity: userActivity),
            let tabBarController  = window?.rootViewController as? UITabBarController,
            tabBarController.viewControllers?.count  == 2,
            let categoryTableViewConntroller = (tabBarController.viewControllers?[0] as? UINavigationController)?.topViewController as? CategoryTableViewController
        else {
            return
        }
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        switch restorationController {
        case .categories:
            break
        case .order:
            tabBarController.selectedIndex = 1
        case .menu(category: let category):
            let menuTableViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue) { coder in
                return MenuTableViewController(coder: coder, category: category)
            }
            categoryTableViewConntroller.navigationController?.pushViewController(menuTableViewController, animated: false)
        case .menuItemDetail(let menuItem):
            
            let menuTableViewController = storyboard.instantiateViewController(identifier: StateRestorationController.Identifier.menu.rawValue, creator: { coder in
                return MenuTableViewController(coder: coder, category: menuItem.category)
            })
            
            let menuItemTableViewController = storyboard.instantiateViewController(identifier: restorationController.identifier.rawValue) { coder in
                return MenuItemViewController(coder: coder, menuItem: menuItem)
            }
            
            categoryTableViewConntroller.navigationController?.pushViewController(menuTableViewController, animated: false)
            categoryTableViewConntroller.navigationController?.pushViewController(menuItemTableViewController, animated: false)
        }
    }
    
    @objc func updateOrderBadge(){
        switch MenuController.shared.order.menuItems.count {
        case 0:
            orderTabBarItem.badgeValue = nil
        default:
            orderTabBarItem.badgeValue = String(MenuController.shared.order.menuItems.count)
        }

    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateOrderBadge), name: MenuController.orderUpdatedNotification, object: nil)
        orderTabBarItem = (window?.rootViewController as? UITabBarController)?.viewControllers?[1].tabBarItem
        
        if let userActivity = connectionOptions.userActivities.first ?? session.stateRestorationActivity {
            configureScene(for: userActivity)
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
        // to restore the scene back to its current state.
    }


}

