//
//  ViewControllerMain.swift
//  ProyectoSwift
//
//  Created by Angel on 03/03/2018.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class ViewControllerMain: UIViewController, OnHttpResponse {
    var categorias = [Family]()
    var productos = [Product]()
    var imagenes : [UIImage] = []
    var token = ""
    @IBOutlet weak var labelprueba: UILabel!
    var usuario = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("TOKEN 1")
        print(token)
        //labelprueba.text = usuario
        
        // Categorias
        descargarCategorias()
        download()
        performSegue(withIdentifier: "seguePrincipal", sender: self)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func onDataReceived(data: Data) {
        
        let respuesta = RestJsonUtil.jsonToDict(data : data)
        print("ESTO ES")
        print(respuesta!)
        
        /*if respuesta!["product"] != nil {
            do{
                // Obtenemos la respuesta de la peticion, como es un JSON, lo decodificamos y lo
                // convertimos
                // en un objeto de la clase family.swift |data es los datos devueltos de la petición|
                productos = try JSONDecoder().decode([Product].self,
                                                      from: try! JSONSerialization.data(withJSONObject: respuesta!["product"]))
            }catch {
                print("Error al recibir los datos")
            }
        }*/
        //if respuesta!["categories"] != nil{
            do{
                // Obtenemos la respuesta de la peticion, como es un JSON, lo decodificamos y lo
                // convertimos
                // en un objeto de la clase family.swift |data es los datos devueltos de la petición|
                categorias = try JSONDecoder().decode([Family].self,
                                                      from: try! JSONSerialization.data(withJSONObject: respuesta!["categories"]))
            }catch {
                print("Error al recibir los datos")
            }
        //}
        
        print("Categorias -> ", categorias.count)
    }
    
    func onErrorReceivingData(message: String) {
        print("Error al recibir los datos 1")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Segue al principal
        if segue.destination is ViewControllerPrincipal{
            let token = segue.destination as? ViewControllerPrincipal
            token?.token = self.token
            token?.imagenes = self.imagenes
            token?.categorias.append(contentsOf: self.categorias)
            token?.productos = self.productos
        }
    }
    
    // Descargar Productos
    
    func descargarProductos(){
        guard let cliente = ClienteHttp(target: "product", authorization: "Bearer " + token, responseObject: self) else {
            return
        }
        cliente.request()
    }
    // Descargar categorias
    
    func descargarCategorias(){
        guard let cliente = ClienteHttp(target: "family", authorization: "Bearer " + token, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    // Descargar Imagenes
    
    func download() {
        print("Ha entrado")
        for var c in categorias{
            print("ENTRA BUCLE")
            let urlImagen = "https://bbdd-javi030.c9users.io/IosPanaderia/images/\(c.imagen)"
            print("URL DE LA IMAGEN ",urlImagen)
            if let url = URL(string: urlImagen) {
                let cola = DispatchQueue(label: "bajar.imagen", qos: .default,
                                         attributes: .concurrent)
                cola.async {
                    if let data = try? Data(contentsOf: url){
                        c.imagenR = data
                    }
                    /*let imagen = UIImage(data: data) {
                     DispatchQueue.main.async {
                     self.imagenes.append(imagen)
                     print("INDICE DE IMAGENES ", cont)
                     print("imagenes x veces")
                     print(self.imagenes.count)
                     // self.collectionView.reloadData()*/
                    
                }
            }
        }
    }
}

