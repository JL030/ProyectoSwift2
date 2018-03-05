//
//  ViewControllerMain.swift
//  ProyectoSwift
//
//  Created by Angel on 03/03/2018.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class ViewControllerMain: UIViewController {
    var token = ""
    @IBOutlet weak var labelprueba: UILabel!
    var usuario = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TOKEN 1")
        print(token)
        //labelprueba.text = usuario
        
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue al principal
        if segue.destination is ViewControllerPrincipal{
            let token = segue.destination as? ViewControllerPrincipal
            token?.token = self.token
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
