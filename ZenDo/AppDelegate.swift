//
//  AppDelegate.swift
//  ZenDo
//
//  Created by cory.roy on 2018-11-04.
//  Copyright © 2018 cory.roy. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       
       // print(Realm.Configuration.defaultConfiguration.fileURL )
        
        let config = Realm.Configuration(
            schemaVersion: 2,
            
            migrationBlock: {
                migration, oldSchemaVersion in
                if (oldSchemaVersion < 2) {
//                    migration.enumerateObjects(ofType: TodoItem.className()) {
//                        oldObject, newObject in
//                        newObject!["createdAt"] = Date()
//                    }
                }
        })
        
    
        Realm.Configuration.defaultConfiguration = config
        
        do {
            _ = try Realm(configuration: config)
        } catch {
            print("Error initializing Realm")
        }
        
        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {

    }
    
    
    
}

