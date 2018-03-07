///  RegistroViewController.swift
//  ProyectoSwift
//
//  Created by Angel on 12/02/2018.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class RegistroViewController: UIViewController, OnHttpResponse {
    
    func onDataReceived(data: Data) {
        //let resultado = RestJsonUtil.jsonToDict(data: data)
        //print(resultado?.values)
    }
    
    func onErrorReceivingData(message: String) {
        
    }
    
    
    
    @IBOutlet weak var regUser: UITextField!
    @IBOutlet weak var regPass: UITextField!
    @IBOutlet weak var regPassConfirmed: UITextField!
    
    @IBOutlet weak var check1: UIImageView!
    @IBOutlet weak var check2: UIImageView!
    
    @IBOutlet weak var btnregister: UIButton!
    
    var confir1 = ""
    var confir2 = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //Ocultos por defecto...
        check1.isHidden = true
        check2.isHidden = true
        
        //Fields tipo password...
        regPass.isSecureTextEntry = true
        regPassConfirmed.isSecureTextEntry = true
        
        //Algo similiar a un TextWatcher de android que utilizan las funciones de textFieldDidChange
        regPass.addTarget(self, action: #selector(RegistroViewController.textField1DidChange(_:)),
                          for: UIControlEvents.editingChanged)
        regPassConfirmed.addTarget(self, action: #selector(RegistroViewController.textField2DidChange(_:)), for: UIControlEvents.editingChanged)
        
    }
    
    @objc func textField1DidChange(_ textField: UITextField) {
        confir1 = textField.text!
    }
    
    @objc func textField2DidChange(_ textField2: UITextField) {
        confir2 = textField2.text!
        
        if confir1 == confir2 {
            check1.isHidden = false
            check2.isHidden = false
        } else {
            check1.isHidden = true
            check2.isHidden = true
        }
        
        if confir1.isEmpty && confir2.isEmpty {
            check1.isHidden = true
            check2.isHidden = true
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func sendRegister(_ sender: UIButton) {
        
        let user = regUser.text
        let pass = regPass.text
        let confirmdPass = regPassConfirmed.text
        
        if !(user?.isEmpty)! && !(pass?.isEmpty)! && !(confirmdPass?.isEmpty)! {
            //Campos completos...
            print("entra")
            if confir1 == confir2 {
                
                var namesUser = [String: Any]()
                namesUser = ["login": user!, "password": pass!]
                //let json = RestJsonUtil.dictToJson(data: namesUser)
                guard let registro = ClienteHttp.init(target: "setMember", authorization: "Basic YW5nZWw6YW5nZWw=", responseObject: self, "POST", namesUser) else {
                    return
                }
                registro.request()
                performSegue(withIdentifier: "registrado", sender: self)
                
            } else {
                
            }
        } else {
            
            let alert = UIAlertController(title: "Campos Vacios", message: "¡Los campos deben de estar completos!", preferredStyle: .alert)
            
            let volver = UIAlertAction(title: "Volver", style: .default, handler: nil)
            
            alert.addAction(volver)
            
            self.present(alert, animated: true, completion: nil)
            
        }
        
        
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
