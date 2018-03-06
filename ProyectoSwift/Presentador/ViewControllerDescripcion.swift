//
//  ViewControllerDescripcion.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 6/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class ViewControllerDescripcion: UIViewController, OnHttpResponse {
    var token = ""
    var id : Int!
    var productos = [Product]()

    @IBOutlet weak var labelProducto: UILabel!
    
    @IBOutlet weak var imagenProducto: UIImageView!
    
    @IBOutlet weak var labelDescripcion: UILabel!
    @IBOutlet weak var añadir: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        descargarProductos()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Descargar Productos
    
    func descargarProductos(){
        guard let cliente = ClienteHttp(target: "product", authorization: "Bearer " + token, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    func onDataReceived(data: Data) {
    
        let respuesta = RestJsonUtil.jsonToDict(data: data)
        print("RESPUESTA -> ", respuesta)
        do{
            productos = try JSONDecoder().decode([Product].self,
                                 from: try! JSONSerialization.data(withJSONObject: respuesta!["product"]))
            print("PRODUCTOS 1 ", productos.count)
                print("ENTRA BUCLE")
                let urlImagen = "https://bbdd-javi030.c9users.io/IosPanaderia/images/\(productos[0].imagen)"
                print("URL DE LA IMAGEN ",urlImagen)
                if let url = URL(string: urlImagen) {
                    let cola = DispatchQueue(label: "bajar.imagen", qos: .default,
                                             attributes: .concurrent)
                    cola.async {
                        if let data = try? Data(contentsOf: url){
                            var imagen = UIImage(data : data)
                            print("PRODUCTOS -> ", self.productos.count)
                            self.imagenProducto.image = imagen
                            self.labelProducto.text = self.productos[0].imagen
                        }
                    }
                }
        }catch{
            print("Error Catch")
        }
    }
    func onErrorReceivingData(message: String) {
        print("Error")
    }
}
