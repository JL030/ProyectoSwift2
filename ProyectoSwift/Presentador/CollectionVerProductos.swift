//
//  CollectionVerProductos.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 11/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class CollectionVerProductos: UIViewController, OnHttpResponse, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var productos = [Product]()
    var token = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        descargarProductos()
        collectionView.dataSource = self
        collectionView.delegate = self
        print("PRODUCTOS -> ", self.productos.count)
        collectionView.reloadData()
        collectionView.reloadData()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCellDescripcionProductos
        collectionView.reloadData()
        let defaultLink = "https://bbdd-javi030.c9users.io/IosPanaderia/images/"
        let completeLink = defaultLink + productos[indexPath.row].imagen
        cell.precioProducto.text = productos[indexPath.row].price
        cell.imagenProducto.downloadedFrom(link: completeLink)
        collectionView.reloadData()
        return cell
    }
    func onDataReceived(data: Data) {
        let respuesta = RestJsonUtil.jsonToDict(data : data)
        
        do{
            // Obtenemos la respuesta de la peticion, como es un JSON, lo decodificamos y lo
            // convertimos
            // en un objeto de la clase family.swift |data es los datos devueltos de la petición|
            productos = try JSONDecoder().decode([Product].self,
                                                  from: try! JSONSerialization.data(withJSONObject: respuesta!["product"]))
            collectionView.reloadData()
        }catch {
            print("Error al recibir los datos")
        }
    }
    func onErrorReceivingData(message: String) {
        print("Error")
    }
    
    // Descargar Productos
    func descargarProductos(){
        guard let cliente = ClienteHttp(target: "product", authorization: "Bearer " + self.token, responseObject: self) else {
            return
        }
        cliente.request()
    }
}
