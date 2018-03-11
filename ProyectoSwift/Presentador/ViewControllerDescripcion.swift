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
    var id : String = ""
    var productos = [Product]()
    var imagen : String = ""
    var nombre :String = ""
    var des: String = ""

    @IBOutlet weak var labelProducto: UILabel!
    
    @IBOutlet weak var imagenProducto: UIImageView!
    
    @IBOutlet weak var labelDescripcion: UILabel!
    @IBOutlet weak var añadir: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print("Productos N -> ", self.productos.count)
    }
}
