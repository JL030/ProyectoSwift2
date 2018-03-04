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
        
        check1.isHidden = true
        check2.isHidden = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRegister(_ sender: UIButton) {
        
        let user = regUser.text
        let pass = regPass.text
        let confirmdPass = regPassConfirmed.text
        
        if (user?.isEmpty)! && (pass?.isEmpty)! && (confirmdPass?.isEmpty)! {
            //Campos completos...
            print("entra")
            if pass == confirmdPass {
                print("Password iguales 1\(pass) 2\(confirmdPass)")
                /*guard let cliente = ClienteHttp(target: "setmember", authorization: "Basic \(base64LoginString)", responseObject: self) else {
                    return
                }
                cliente.request()*/
                check1.isHidden = false
                check2.isHidden = false
                
            } else {
                
                
                
                
            }
        } else {
            
            let alert = UIAlertController(title: "Campos Vacios", message: "¡Los campos deben de estar completos!", preferredStyle: .alert)
            
            let volver = UIAlertAction(title: "Volver", style: .default, handler: nil)
            
            alert.addAction(volver)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        //var parameters = ["user": user, "pass":pass]
        
        
        
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
