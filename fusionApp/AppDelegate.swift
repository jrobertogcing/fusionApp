//
//  AppDelegate.swift
//  fusionApp
//
//  Created by Jose González on 3/2/19.
//  Copyright © 2019 reset. All rights reserved.
//

import UIKit
import CoreData
import Firebase
import GoogleSignIn
import FBSDKLoginKit


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
    //Variables
    var window: UIWindow?
    var flagReceived = ""
   

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

        //Firebase
        FirebaseApp.configure()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        
        
        if let flag = UserDefaults.standard.string(forKey: "flagRegistro")  {
            
            flagReceived = flag
            
        }
        print("flagReceived:");        print(flagReceived);
        
        
        if flagReceived == "Facebook" {
            
            
            //Facebook AUTH
            // Facebook
            FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
            
            if (FBSDKAccessToken.currentAccessTokenIsActive()){
                
                self.window = UIWindow(frame: UIScreen.main.bounds)
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                
                let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                
                self.window?.rootViewController = initialViewController
                self.window?.makeKeyAndVisible()
                
                
            }
                
        } else if flagReceived == "Gmail"{
            
           
            //GMAIL AUTH
            Auth.auth().addStateDidChangeListener { (auth, user) in
                if user != nil {
                    
                    
                    self.window = UIWindow(frame: UIScreen.main.bounds)
                    
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    
                    let initialViewController = storyboard.instantiateViewController(withIdentifier: "HomeViewController")
                    
                    self.window?.rootViewController = initialViewController
                    self.window?.makeKeyAndVisible()
                    
                    
                    
                    
                } else {
                    // user is not signed in
                    // go to login controller
                }
                
            }
            
            
        }

        


        return true
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        
        if error != nil {
            // ...
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        
        print("credential")
        print(credential)
        
        //Get data Gmail
        guard let givenName = user.profile.givenName else {return}
        guard let familyName = user.profile.familyName else {return}
        guard let email = user.profile.email else {return}
        guard let image = user.profile.imageURL(withDimension: 100) else {return}
        
        print(user)
        
        
        //Save information in NSUserdefault locally
        UserDefaults.standard.set(givenName, forKey: "name")
        UserDefaults.standard.set(familyName, forKey: "lastName")
        UserDefaults.standard.set(email, forKey: "email")
        UserDefaults.standard.set(image.absoluteString, forKey: "image")
        
        //Save information Firebase cloud
        saveUserInfoFirebase(name: givenName, lastName: familyName, email: email)
        
        guard let imageProfile = UserDefaults.standard.string(forKey: "image") else  {
            return
        }
        print(imageProfile)
        
        
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("error GMAIL")
                print(error)
                return
            } else{
                
                print(authResult?.user as Any)
                
                
                // Send to Home View Controller
                let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let homePage = mainStoryboard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                
                //homePage.nameR = givenName
                
                self.window?.rootViewController = homePage
                
                
            }
            
        }
    }
    
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!, withError error: Error!) {
        // Perform any operations when the user disconnects from app here.
        
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        
        if flagReceived == "Facebook"{
            
            let handled = FBSDKApplicationDelegate.sharedInstance().application(app, open: url, sourceApplication: options[.sourceApplication] as? String, annotation: options[.annotation])
            return handled
            
        } else if flagReceived == "Gmail"{
            
            return GIDSignIn.sharedInstance().handle(url,sourceApplication:options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String, annotation: [:])
            
        }
        
        
        return false
        
    }
    


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "fusionApp")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    //MARK: Save user Firebase
    func saveUserInfoFirebase(name: String, lastName: String, email:String) {

        // For Firebase sotorage
        let db = Firestore.firestore()
        db.collection("usuarios").document(email).setData([

            "name": name,
            "lastName": lastName,
            "email": email

        ]) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Document successfully written!")
            }
        }

    }

}

