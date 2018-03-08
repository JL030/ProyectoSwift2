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
    var tokenReal = ""
    var usuario = ""
    var idmember = ""
   
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        passText.isSecureTextEntry = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func doRequest(_ sender: Any) {
        
        let user = userText.text
        let password = passText.text
        
        if !((user)?.isEmpty)! && !((password)?.isEmpty)! {
            
            let loginString = String(format: "%@:%@", user!, password!)
            let loginData = loginString.data(using: String.Encoding.utf8)!
            let base64LoginString = loginData.base64EncodedString()
            
            guard let cliente = ClienteHttp(target: "member", authorization: "Basic \(base64LoginString)", responseObject: self) else {
                return
            }
            cliente.request()
            usuario = user!
            
        } else {
            let alerta = UIAlertController(title: "Campos vacios", message:
                "Porfavor, introduzca todos los datos", preferredStyle: .alert)
            
            let continueAction = UIAlertAction(title: "Volver", style: .default, handler:nil)
            alerta.addAction(continueAction)
            
            self.present(alerta, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        //Segue al menu inicial
        if segue.destination is ViewControllerMain {
            
            let vc = segue.destination as? ViewControllerMain
            vc?.tokenMain = tokenReal
            //nombre de usuario y id del mismo
            vc?.userMain = usuario
            vc?.idMain = idmember
            
        }
    }
    
    
    func onDataReceived(data: Data) {
        
        let dictUser = RestJsonUtil.jsonToDict(data: data)
        
        //let login = Login.init(token: (resultado?.values as? String)!)
        
        do{
            let prueba = try JSONDecoder().decode(Login.self, from: data)
            print(prueba)
            
            if !(prueba.token).isEmpty {
                print("entro")
                
                tokenReal = prueba.token
                
                performSegue(withIdentifier: "login", sender: self)
                //performSegue(withIdentifier: "seguePrincipal", sender: self)
                
                
            }
            
        }catch{
            print("Error")
            
            let alerta = UIAlertController(title: "Contraseña incorrecta", message:
                "Datos incorrectos, vuelva a intentarlo", preferredStyle: .alert)
            
            let continueAction = UIAlertAction(title: "Volver", style: .default, handler:nil)
            alerta.addAction(continueAction)
            
            self.present(alerta, animated: true, completion: nil)
        }
        
        do {
            
            var users = try JSONDecoder().decode([User].self, from: try! JSONSerialization.data(withJSONObject: dictUser!["member"]))
            print("ESTO es usuarios")
            print(users[0].login)
            
            for id in users {
                if id.login == usuario {
                    print("ha entrado en el if y son iguales")
                    print("Usuario logueado:\(id.id, id.login, id.password)")
                    idmember = id.id
                    print(idmember)
                }
            }
            
            
        }catch {
            print("error de usuario")
        }

        
    }
    
    func onErrorReceivingData(message: String) {
        
    }


}

