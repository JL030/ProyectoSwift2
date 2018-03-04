//
//  RegistroViewController.swift
//  ProyectoSwift
//
//  Created by Angel on 12/02/2018.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController {
    
    @IBOutlet weak var regUser: UITextField!
    @IBOutlet weak var regPass: UITextField!
    @IBOutlet weak var regPassConfirmed: UITextField!
    
    @IBOutlet weak var check1: UIImageView!
    @IBOutlet weak var check2: UIImageView!
    
    @IBOutlet weak var btnregister: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*
         Funcionamiento de las imagenes para que aparezcan y demas...
         */

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRegister(_ sender: UIButton) {
        
        let user = regUser.text
        let pass = regPass.text
        let confirmdPass = regPassConfirmed.text
        
        var parameters = Dictionary<String, Any>()
        
        parameters = [
        "user" : "\(user)",
            "pass" : "\(pass)"]
        
    }
    
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
