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
                if let imageData = UserDefaults.standard.data(forKey: "facebookImage"){

                    userImageView.image = UIImage(data:imageData,scale:1.0)

                } else {

                    //Set generic user image.
                }

                
            }
            
            
        } else {
            if nameR != "" {
                userLabel.text = nameR
            } else {
                userLabel.text = "Usuario"
            }
        }
       
    }
    
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        
//        if flagReceived == "Facebook"{
//
//            //Read image NSuserdefault
//
//            if userImageView.image == nil {
//
//
//                if let imageData = UserDefaults.standard.data(forKey: "facebookImage"){
//
//                    userImageView.image = UIImage(data:imageData,scale:1.0)
//
//                } else {
//
//                    //Set generic user image.
//                }
//
//            }
//              //  userImageView.image = image
//
//
//
//
//        }
    }
    
    
    
    @IBAction func loutGoogleButtonAction(_ sender: UIButton) {
      

        UserDefaults.standard.removeObject(forKey:"firstOpenFlag")
        
        
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
    
    @IBAction func viewOneButtonAction(_ sender: UIButton) {
        
        viewLabel.text = "Boulder"
        
    }
    
    @IBAction func viewTwoButtonAction(_ sender: UIButton) {
        
        viewLabel.text = "Vías"

        
    }
    
    @IBAction func viewThreeButtonAction(_ sender: UIButton) {
        
        viewLabel.text = "Retos Fusión"

        
    }
    
    //MARK: Fetch image Facebook
    
    private func fetchImage() {
        
        
        //Get saved User id NSUserDefault
        guard let userID = UserDefaults.standard.string(forKey: "userID") else  {
            return
        }
        
        print(userID)
        //Get image saved in NSUserdefault
        
       //let imageURL = URL(string: "http://graph.facebook.com/10155363426747041/picture?type=large")
        // https://www.anipedia.net/imagenes/gatos-800x375.jpg
        // let imageURL = URL(string: "https://www.anipedia.net/imagenes/gatos-800x375.jpg")
        
        let imageURL = URL(string: "http://graph.facebook.com/\(userID)/picture?type=large")

        
        var image: UIImage?
        if let url = imageURL {
            //All network operations has to run on different thread(not on main thread).
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
                
                if imageData != nil {
                    //Save image in NSUserdefault as Data
                    UserDefaults.standard.set(imageData, forKey: "facebookImage")
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
