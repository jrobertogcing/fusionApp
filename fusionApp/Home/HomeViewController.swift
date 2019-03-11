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

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        userImageView.layer.cornerRadius = 40
        
        // userImageView.layer.bounds.height / 2
        userImageView.clipsToBounds = true
        
        if let flag = UserDefaults.standard.string(forKey: "flagRegistro")  {
            
            flagReceived = flag
            
        }
        if flagReceived == "Facebook"{


            if let name = UserDefaults.standard.string(forKey: "name")  {

                userLabel.text = name

            }
            
            fetchImage()


        } else {
            if nameR != "" {
            userLabel.text = nameR
            } else {
            userLabel.text = "Usuario"
            }
    }
    }
    
    @IBAction func loutGoogleButtonAction(_ sender: UIButton) {
      

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
        let imageURL = URL(string: "http://graph.facebook.com/10155363426747041/picture?type=large")
        // https://www.anipedia.net/imagenes/gatos-800x375.jpg
        // let imageURL = URL(string: "https://www.anipedia.net/imagenes/gatos-800x375.jpg")
        
        var image: UIImage?
        if let url = imageURL {
            //All network operations has to run on different thread(not on main thread).
            DispatchQueue.global(qos: .userInitiated).async {
                let imageData = NSData(contentsOf: url)
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
