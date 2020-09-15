//
//  SceneDelegate.swift
//  RBGarden-Guide
//
//  Created by Stanford on 5/9/20.
//  Copyright © 2020 Monash. All rights reserved.
//

import UIKit
import CoreLocation
class SceneDelegate: UIResponder, UIWindowSceneDelegate{

    var window: UIWindow?
    let locationManager = CLLocationManager()

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
        //link mapViewController to exhibition table
        let splitViewController = window?.rootViewController as! UISplitViewController

        splitViewController.preferredDisplayMode = .allVisible
        
        let navigationController = splitViewController.viewControllers.first as! UINavigationController
        let exhibitionTableViewController = navigationController.viewControllers.first as! ExhibitionTableController
        let bottomNavigationController = splitViewController.viewControllers.last as! UINavigationController
        let mapViewController = bottomNavigationController.viewControllers.first as! HomeMapViewController

        //bottomNavigationController.isNavigationBarHidden=false
        //mapViewController.navigationItem.leftItemsSupplementBackButton = true
        mapViewController.navigationItem.leftBarButtonItem = splitViewController.displayModeButtonItem
        //build coomunication between homeMap and exhibitionTable
        
        exhibitionTableViewController.homeMapController = mapViewController
        mapViewController.exhibitionTableController = exhibitionTableViewController
        
        // request location and initialize user notofication
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        let options: UNAuthorizationOptions = [.badge, .sound, .alert]
        UNUserNotificationCenter.current()
          .requestAuthorization(options: options) { success, error in
            if let error = error {
              print("Error: \(error)")
            }
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 0
        locationManager.startUpdatingLocation()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        
        //If scene is activ, there is no need to use notifications
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.databaseController?.cleanup()
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

extension SceneDelegate: CLLocationManagerDelegate {
    
    
    func handleEvent(for region: CLRegion!, action : String) {
      // Show an alert if application is active
      let message = "You have \(action)ed \(region.identifier)"
      if UIApplication.shared.applicationState == .active {
        window?.rootViewController?.displayMessage(title: "Attention", message: message)
      } else {
        // Otherwise present a local notification
        let notificationContent = UNMutableNotificationContent()
        notificationContent.body = message
        notificationContent.sound = UNNotificationSound.default
        notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(identifier: "location_change",
                                            content: notificationContent,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
          if let error = error {
            print("Error: \(error)")
          }
        }
      }
    }
  
  func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
    if region is CLCircularRegion {

      handleEvent(for: region, action: "enter")
    }
  }
  
  func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
    if region is CLCircularRegion {
      handleEvent(for: region,action: "exit")
    }
  }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        if status == .denied {
            let message = "You need to give RBG Location Permission to do geofencing"
            if UIApplication.shared.applicationState == .active {
                window?.rootViewController?.displayMessage(title: "Attention", message: message)
            } else {
                let notificationContent = UNMutableNotificationContent()
                notificationContent.body = message
                notificationContent.sound = UNNotificationSound.default
                notificationContent.badge = UIApplication.shared.applicationIconBadgeNumber + 1 as NSNumber
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
                let request = UNNotificationRequest(identifier: "permission_change",
                                                    content: notificationContent,
                                                    trigger: trigger)
                UNUserNotificationCenter.current().add(request) { error in
                    if let error = error {
                        print("Error: \(error)")
                    }
                }
            }
        }
        
    }
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//        if let location = locations.last {
//            manager.location
//
//        }
//
//    }

}
