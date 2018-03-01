//
//  ViewController.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 7/2/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit


class ViewController: UIViewController, OnHttpResponse {
    
    @IBOutlet weak var userText: UITextField!
    @IBOutlet weak var passText: UITextField!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func doRequest(_ sender: Any) {
        
        let user = userText.text
        let password = passText.text
        
        let loginString = String(format: "%@:%@", user!, password!)
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64LoginString = loginData.base64EncodedString()
        
        guard let cliente = ClienteHttp(target: "", authorization: "Basic \(base64LoginString)", responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    func onDataReceived(data: Data) {
        
        let resultado = RestJsonUtil.jsonToDict(data: data)
        
        for valueskey in (resultado?.keys)! {
            print("LAS CLAVES SON \(valueskey)")
        }
        
        for values in (resultado?.values)! {
            print("LOS VALORES SON \(values)")
        }
        
        
        
        //print(resultado!["token" ?? "error"])
        //print(resultado!["ok" ?? "error"])
        
        /*if let respuesta = String(data: data, encoding: .utf8) {
            //print("respuesta hecha por el servido")
            print(respuesta)
            //print("Final de la respiesta")
            
            //let resultado = RestJsonUtil.jsonToDict(data: data)
            print(resultado!["token"] as Any)
            print(resultado!["ok"] as Any)
            
            let a = String(describing: resultado!["ok"] as Any)
            print(a)
            
            if a.isEqual("Optional(1)") {
                print("logeado")
                //performSegue(withIdentifier: "logeado1", sender: self)
                
            } else if a.isEqual("Optional(ERROR)") {
                
                print("fallo de logeo")
                
                let alerta = UIAlertController(title: "Contraseña incorrecta", message: "La contraseña o el usuario introducidos son incorrectos", preferredStyle: .alert)
                
                alerta.addAction(UIAlertAction(title: "Volver", style: .default, handler: nil))
                
                self.present(alerta, animated: true)
            }
        }*/
    }
    
    func onErrorReceivingData(message: String) {
        
    }


}

