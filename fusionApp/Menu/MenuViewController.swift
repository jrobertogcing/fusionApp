//
//  MenuViewController.swift
//  fusionApp
//
//  Created by Jose González on 3/7/19.
//  Copyright © 2019 reset. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func optionOneButtonAction(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "BoulderViewController") as! BoulderViewController
        self.present(nextViewController, animated:true, completion:nil)
    }
    
    @IBAction func optionTwoButtonAction(_ sender: UIButton) {
        
        alertGeneral(errorDescrip: "Aún no hay vías nuevas registradas para tu perdil", information: "Vías")
        
        
    }
    
    @IBAction func optionThreeButtonAction(_ sender: UIButton) {
        
        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil)
        
        let nextViewController = storyBoard.instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
        self.present(nextViewController, animated:true, completion:nil)

        
        
    }
    
    // MARK: Alerts
    func alertGeneral(errorDescrip:String, information: String) {
        
        
        let alertGeneral = UIAlertController(title: information, message: errorDescrip, preferredStyle: .alert)
        
        let aceptAction = UIAlertAction(title: "Ok", style: .default)
        
        alertGeneral.addAction(aceptAction)
        present(alertGeneral, animated: true)
        
        
    }
    
    

}
