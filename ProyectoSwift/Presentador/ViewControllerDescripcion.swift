//
//  ViewControllerDescripcion.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 6/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class ViewControllerDescripcion: UIViewController {
    var token = ""
    var id : Int!
    var productos = [Product]()
    var index : Int = 0

    @IBOutlet weak var labelProducto: UILabel!
    
    @IBOutlet weak var imagenProducto: UIImageView!
    
    @IBOutlet weak var labelDescripcion: UILabel!
    @IBOutlet weak var añadir: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onDataReceived(data: Data) {
    }
    func onErrorReceivingData(message: String) {
        print("Error")
    }
}
