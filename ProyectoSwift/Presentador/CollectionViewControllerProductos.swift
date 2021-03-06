//
//  CollectionViewControllerProductos.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 6/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class CollectionViewControllerProductos: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    var idCategoria : String!
    var token = ""
    var userPro = ""
    var idPro = ""
    var productos = [Product]()
    var productosFiltrados = [Product]()
    var productosSeleccionados = [ProductPedidos]()
    var indexPath : IndexPath = []
    var categorias = [Family]()

    @IBOutlet weak var totalPrecio: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        if productosSeleccionados.count == 0{
            totalPrecio.text = "0"
        }else{
            totalPrecio.text = String(productosSeleccionados.count)
        }
        collectionView.dataSource = self
        collectionView.delegate = self
        print("CAT nueva -> ", self.idCategoria)

        print("PRODUCTOS A MOSTRAR ->", productos.count)
        for p in productos{
            if p.id_family == self.idCategoria{
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
        //cell.labelProducto.text = productos[indexPath.row].product
        cell.imagenProducto.downloadedFrom(link: completo)
        let euro = "€"
        cell.labelPrecio.text = productosFiltrados[indexPath.row].price + euro
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Entra en el didSelected")
        print("Producto seleccionado -> ", productos[indexPath.row].product)
        let productoPedido = ProductPedidos.init(id_producto: productos[indexPath.row].id, precio: productos[indexPath.row].price, id_familia: productos[indexPath.row].id_family, producto: productos[indexPath.row].product, imagen: productos[indexPath.row].imagen)
        productosSeleccionados.append(productoPedido)
        print("Producto cesta -> ", productosSeleccionados.count)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell1", for: indexPath) as! CustomCollectionViewCellProductos
        let main : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = main.instantiateViewController(withIdentifier: "desc") as! ViewControllerDescripcion
        totalPrecio.text = String(productosSeleccionados.count)
        print("Cambiado")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // Volver Al principal
        if segue.destination is ViewControllerPrincipal{
            let vc = segue.destination as? ViewControllerPrincipal
            vc!.categorias.append(contentsOf: self.categorias)
            vc!.token = self.token
            vc!.idPrin = self.idPro
            vc!.userPrin = self.userPro
            vc!.productosSeleccionados.append(contentsOf: self.productosSeleccionados)
            vc!.categorias.append(contentsOf: self.categorias)
        }
        // PEDIDO VIEW CONTROLLER
        if segue.destination is PedidoViewController{
            let vc = segue.destination as? PedidoViewController
            vc?.token = token
            vc?.productosSeleccionados.append(contentsOf: productosSeleccionados)
            print("PRO ENVIADOS -> ", vc?.productosSeleccionados.count)
            vc!.productos.append(contentsOf: self.productos)
            vc!.categorias.append(contentsOf: self.categorias)
            vc?.userPe = userPro
            vc!.idCategoria = self.idCategoria
            vc!.cantidad = self.totalPrecio.text!
            vc?.idPe = idPro
        }

        
    }
}
