//
//  AppDelegate.swift
//  Cleanse
//
//  Created by Alek Matthiessen on 10/26/19.
//  Copyright © 2019 The Matthiessen Group, LLC. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import FirebaseDatabase
import FirebaseStorage
import Purchases
import FBSDKCoreKit
import AppsFlyerLib

var entereddiscount = String()

var actualdiscount = String()

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, AppsFlyerTrackerDelegate {
    func onConversionDataSuccess(_ conversionInfo: [AnyHashable : Any]) {
        
        
    }
    
    
      func onConversionDataFail(_ error: Error) {
         print("\(error)")
     }
     // Handle Deeplink
     func onAppOpenAttribution(_ attributionData: [AnyHashable: Any]) {
         //Handle Deep Link Data
         print("onAppOpenAttribution data:")
         for (key, value) in attributionData {
             print(key, ":",value)
         }
     }
     func onAppOpenAttributionFailure(_ error: Error) {
         print("\(error)")
     }

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        AppEvents.activateApp()

        referrer = "On Open"
    
        AppsFlyerTracker.shared().appsFlyerDevKey = "GSfLvX3FDxH58hR3yDZzZe"
        AppsFlyerTracker.shared().appleAppID = "1520062033"
        AppsFlyerTracker.shared().delegate = self
        AppsFlyerTracker.shared().isDebug = true


         // 2 - Replace 'appsFlyerDevKey', `appleAppID` with your DevKey, Apple App ID
    
        
//
//        let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
//        let tabBarBuyer : UITabBarController = mainStoryboardIpad.instantiateViewController(withIdentifier: "HomeTab") as! UITabBarController
        
        uid = UIDevice.current.identifierForVendor?.uuidString ?? "x"


        


let launchedBefore = UserDefaults.standard.bool(forKey: "launchedBefore")
  
  if launchedBefore {
    
    
     let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
     let tabBarBuyer : UITabBarController = mainStoryboardIpad.instantiateViewController(withIdentifier: "HomeTab") as! UITabBarController
      
        self.window = UIWindow(frame: UIScreen.main.bounds)
           self.window?.rootViewController = tabBarBuyer

           self.window?.makeKeyAndVisible()
    
      tabBarBuyer.selectedIndex = 0
      
  } else {
    
    
    let storybaord = UIStoryboard(name: "Main", bundle: Bundle.main)
    let authVC = storybaord.instantiateViewController(withIdentifier: "Onboarding")
    
    
    window?.rootViewController? = authVC
    
    window?.makeKeyAndVisible()
    
    UserDefaults.standard.set(true, forKey: "launchedBefore")
    
}
        
            Purchases.debugLogsEnabled = true
          Purchases.configure(withAPIKey: "ryfdDUwKGrQKWbGaaYJjIobqbOruFudh", appUserID: nil)
          
          referrer = "On Open"
          
          let mainStoryboardIpad : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
          let tabBarBuyer : UITabBarController = mainStoryboardIpad.instantiateViewController(withIdentifier: "HomeTab") as! UITabBarController
          
          uid = UIDevice.current.identifierForVendor?.uuidString ?? "x"
          
        
        queryforpaywall()
        return true
    }
    
    func queryforpaywall() {
                
        ref?.child("Users").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
     
            
            if let slimey = value?["Slimey"] as? String {

                slimeybool = true
                
            } else {
                
                slimeybool = false

            }
            
            if let discountcode = value?["DiscountCode"] as? String {
                
               actualdiscount = discountcode
                
            } else {
                
                
            }
        })
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
        AppsFlyerTracker.shared().trackAppLaunch()

    }
    
    

    // MARK: UISceneSession Lifecycle




}



