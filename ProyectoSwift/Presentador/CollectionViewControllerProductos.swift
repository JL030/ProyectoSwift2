//
//  CollectionViewControllerProductos.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 6/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class CollectionViewControllerProductos: UIViewController, OnHttpResponse, UICollectionViewDataSource {

    var idCategoria = ""
    var token = ""
    var productos = [Product]()

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("CAT nueva -> ", self.idCategoria)
        descargarProductos()
        collectionView.reloadData()
    }
    
    // Descargar Productos
    func descargarProductos(){
        guard let cliente = ClienteHttp(target: "product", authorization: "Bearer " + self.token, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    func onDataReceived(data: Data) {
        print("ENTRA")
        let respuesta = RestJsonUtil.jsonToDict(data: data)
        print("RESPUESTA -> " , respuesta)
        
        do{
            productos = try JSONDecoder().decode([Product].self,
                                                 from: try! JSONSerialization.data(withJSONObject: respuesta!["product"]))
            print("PRODUCTOS -> ", productos.count)
        }catch{
            print("ERROR ABC")
        }
    }
    
    func onErrorReceivingData(message: String) {
        print("ERRORRRR")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productos.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        let defaultLink = "https://bbdd-javi030.c9users.io/IosPanaderia/images/"
        return cell
    }
}
