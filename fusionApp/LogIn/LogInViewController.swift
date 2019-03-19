//
//  LogInViewController.swift
//  fusionApp
//
//  Created by Jose González on 3/2/19.
//  Copyright © 2019 reset. All rights reserved.
//

import UIKit
import GoogleSignIn
import Firebase
import FirebaseAuth
import FBSDKLoginKit


class LogInViewController: UIViewController, GIDSignInUIDelegate, FBSDKLoginButtonDelegate{
    
    
    @IBOutlet weak var faceLogInButton: FBSDKLoginButton!
    
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    
    
    //Variables
    var email  = ""
    var userName  = ""
    var userLastName  = ""
    var telephone = ""
    var userID  = ""
    var userImage = ""

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
       // faceLogInButton.delegate = self
        
    }
    

    @IBAction func googleSignButtonAction(_ sender: Any) {
        
        
        UserDefaults.standard.set("Gmail", forKey: "flagRegistro")

        
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        
        
    }
    
    
    @IBAction func facebookSignButtonAction(_ sender: FBSDKButton) {
        
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result!
                // if user cancel the login
                if (result?.isCancelled)!{
                    return
                }
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    
                    UserDefaults.standard.set("Facebook", forKey: "flagRegistro")
                   
                    // Get and save facebook data
                    self.registerFacebook(completion: { (data) in
                        print(data)
                    })
                    
                    
                    let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
                    
                    let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
                    
                    //nextViewController.nameR = self.userName
                    
                    //  self.show(nextViewController, sender: nil)
                    self.present(nextViewController, animated:true, completion:nil)
                    
                }
            }
        }
        
    }
    
    //Facebook
    func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if error != nil {
            
            print(error.localizedDescription)
            
        }else if result.isCancelled {

            print("User Cancelled log in")
            
        } else {
            
            print("User logged In")
            
            UserDefaults.standard.set("Facebook", forKey: "flagRegistro")
            
            // Delete the local information, in case another user enter to the app
            UserDefaults.standard.set("", forKey: "name")
            UserDefaults.standard.set("", forKey: "lastName")
            UserDefaults.standard.set("", forKey: "telephone")
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set("", forKey: "password")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            //  self.show(nextViewController, sender: nil)
            self.present(nextViewController, animated:true, completion:nil)
            
        }
        
    }
    
    func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        
    }
    
    //MARK: GMAIL AUTH
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        // ...
        if let error = error {
            // ...
            print("error GMAIL")
            print(error)
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("error GMAIL")
                print(error)
                
                
                return
            }
            
            guard let givenName = user.profile.givenName else {return}

            // User is signed in
            // Delete the local information, in case another user enter to the app
            UserDefaults.standard.set("", forKey: "name")
            UserDefaults.standard.set("", forKey: "lastName")
            UserDefaults.standard.set("", forKey: "telephone")
            UserDefaults.standard.set("", forKey: "email")
            UserDefaults.standard.set("", forKey: "password")
            
            //set flag
            UserDefaults.standard.set("Gmail", forKey: "flagRegistro")
            
            let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
            
            let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
            
            nextViewController.nameR = givenName
            
            //  self.show(nextViewController, sender: nil)
            self.present(nextViewController, animated:true, completion:nil)
            
        }
        
        
    }
    
    func getFBUserData(){
        if((FBSDKAccessToken.current()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if (error == nil){
                    //everything works print the user data
                    print(result as Any)
                }
            })
        }
        
    }
    
    func registerFacebook(completion: @escaping(String) -> Void)  {
        
        FBSDKProfile.loadCurrentProfile(completion: { (profile, error) in
            //print("loaded: \(String(describing: profile?.firstName))")
            
            if (error == nil) {
                
                guard let profileName = profile?.firstName  else {
                   return
                }
                
                guard let profileLastName = profile?.lastName  else {
                    return
                }
                
                guard let profileUserID = profile?.userID  else {
                    return
                }
                
                self.userName = profileName
                
                self.userLastName = profileLastName
                
                self.userID = profileUserID
                
                print(self.userID)
                // save new informatión in NSuserdefault
                
                UserDefaults.standard.set(profileName, forKey: "name")
                UserDefaults.standard.set(profileLastName, forKey: "lastName")
                UserDefaults.standard.set(profileUserID, forKey: "userID")

                
                
                print("loaded: \(String(describing: profile?.userID))")
                
                completion("Ready")
                
                //
            } else {
                
                print(error?.localizedDescription as Any)
            }
            
        })
        
    }
}
