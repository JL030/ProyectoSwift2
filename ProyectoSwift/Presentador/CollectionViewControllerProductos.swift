//
//  CollectionViewControllerProductos.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 6/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class CollectionViewControllerProductos: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var idCategoria : String = ""
    var token = ""
    var productos = [Product]()
    var productosFiltrados = [Product]()

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        collectionView.delegate = self
        print("CAT nueva -> ", self.idCategoria)
        print("PRODUCTOS A MOSTRAR ->", productos.count)
        for p in productos{
            if p.id_family == self.idCategoria{
                print("ID_FAMILY -> ",p.id_family)
                print("ID CATEGORIA -> ", self.idCategoria)
                productosFiltrados.append(p)
            }
        }
        print("Numero de P filtrados -> ", productosFiltrados.count)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.productosFiltrados.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell1", for: indexPath) as! CustomCollectionViewCellProductos
    
        let defaultLink = "https://bbdd-javi030.c9users.io/IosPanaderia/images/"
        let completo = defaultLink + self.productosFiltrados[indexPath.row].imagen
        cell.labelProducto.text = productosFiltrados[indexPath.row].product
        cell.imagenProducto.downloadedFrom(link: completo)
        return cell
    }
}
