, UICollectionViewDelegate//
//  ViewControllerPrincipal.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 26/2/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class ViewControllerPrincipal: UIViewController, UICollectionViewDelegate {
    // HOLA
    let categories = ["Pan", "Bollería", "Croasant", "Navidad", "Otros"]
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
      
        var imagen : UIImageView
        imagen = ClienteHttp.downloadImage("https://bbdd-javi030.c9users.io/IosPanaderia/images/11.png&text=Loaded+Image!")
        if imagen == nil{
            print("No hay imagen")
        }else{
            print("imagen ",imagen)
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
