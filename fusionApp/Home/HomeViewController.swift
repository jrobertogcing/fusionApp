//
//  HomeViewController.swift
//  fusionApp
//
//  Created by Jose González on 3/2/19.
//  Copyright © 2019 reset. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKShareKit


class HomeViewController: UIViewController {

  
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var viewLabel: UILabel!
    
    @IBOutlet weak var userImageView: UIImageView!
    
    //Variables
    
    var nameR = ""
    var flagReceived = ""
    //Variable to know if the picture is already saved.
    var firstOpenFlag = "notOpen"

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = 75
        
        // userImageView.layer.bounds.height / 2
        userImageView.clipsToBounds = true
        
        if let flag = UserDefaults.standard.string(forKey: "flagRegistro")  {
            
            flagReceived = flag
        }
        
        if flagReceived == "Facebook"{
            
            
            if let name = UserDefaults.standard.string(forKey: "name")  {
                
                userLabel.text = name
                
            }
            
            if let firstOpen = UserDefaults.standard.string(forKey: "firstOpenFlag") {
                
                firstOpenFlag = firstOpen
            }
            
            if firstOpenFlag == "notOpen" {
                
                fetchImage()
                
                UserDefaults.standard.set("firstOpen", forKey: "firstOpenFlag")

                
            } else {
                
                // Read image from NSUserdefault
                if let imageData = UserDefaults.standard.data(forKey: "userImage"){

                    userImageView.image = UIImage(data:imageData,scale:1.0)

                } else {

                    //Set generic user image.
                }

                
            }
            
            
        } else if flagReceived == "Gmail" {
            
            if let name = UserDefaults.standard.string(forKey: "name")  {
                
                userLabel.text = name
            }
            
            if let firstOpen = UserDefaults.standard.string(forKey: "firstOpenFlag") {
                
                firstOpenFlag = firstOpen
            }
            
            if firstOpenFlag == "notOpen" {
                
                fetchImage()
                
                UserDefaults.standard.set("firstOpen", forKey: "firstOpenFlag")
                
                
            } else {
                
                // Read image from NSUserdefault
                if let imageData = UserDefaults.standard.data(forKey: "userImage"){
                    
                    userImageView.image = UIImage(data:imageData,scale:1.0)
                    
                } else {
                    
                    //Set generic user image.
                    print("no hay imagen")
            
                }
                
                
            }
            
        }
       
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    
    //MARK: Logout ButtonAction
    
    @IBAction func loutGoogleButtonAction(_ sender: UIButton) {
      
        UserDefaults.standard.removeObject(forKey:"firstOpenFlag")
        
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.removeObject(forKey: "lastName")
        UserDefaults.standard.removeObject(forKey: "email")
        UserDefaults.standard.removeObject(forKey: "image")
        UserDefaults.standard.removeObject(forKey: "userImage")

        
        if flagReceived == "Gmail"{

            // Delete all information in NSUserdefault Gmail
            

        
        } else if flagReceived == "Facebook" {
            
          //  UserDefaults.standard.removeObject(forKey: "userImage")

            // Delete all information in NSUserdefault Facebook


            UserDefaults.standard.removeObject(forKey: "userID")
            
        }
        
        UserDefaults.standard.removeObject(forKey: "flagRegistro")

        
        GIDSignIn.sharedInstance().signOut()
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
        
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "LogInViewController") as! LogInViewController
        self.present(nextViewController, animated:true, completion:nil)

    }
    
    //MARK: Fetch user image
    
    private func fetchImage() {
        
        var imageURL: URL?
        var image: UIImage?

        
        if flagReceived == "Facebook" {
            
            //Get saved User id NSUserDefault
            guard let userID = UserDefaults.standard.string(forKey: "userID") else  {
                return
            }
            imageURL = URL(string: "http://graph.facebook.com/\(userID)/picture?type=large")
            
        } else if flagReceived == "Gmail" {
            
            //Get saved User id NSUserDefault
            guard let imageProfile = UserDefaults.standard.string(forKey: "image") else  {
                return
            }
            
            imageURL = URL(string: imageProfile)
            
            
        }
       
        if let url = imageURL {
            //All network operations has to run on different thread(not on main thread).
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
                
                if imageData != nil {
                    //Save image in NSUserdefault as Data
                    UserDefaults.standard.set(imageData, forKey: "userImage")
                }
                //All UI operations has to run on main thread.
                DispatchQueue.main.async {
                    if imageData != nil {
                        image = UIImage(data: imageData! as Data)
                       // self.userPictureImageView.image = image
                        self.userImageView.image = image
                        //self.userPictureImageView.sizeToFit()
                    } else {
                        image = nil
                    }
                }
            }
        }
    }
    
}
