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

    @IBOutlet weak var totalPrecio: UILabel!
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
        if cell.añadir.isSelected{
            desVC.index = indexPath.row
        }
        /*if productosSeleccionados.con{
                var cantidad = 1
                let productoNuevo = ProductPedidos.init(id_producto: productos[indexPath.row].id, cantidad: cantidad)
                productosSeleccionados.append(productoNuevo)
                print("Nuevo producto añadido: ", productosSeleccionados.count)
            }else{
                var cantidad = productosSeleccionados[indexPath.row].cantidad
                let cantidadNueva = cantidad + 1
                productosSeleccionados[indexPath.row].cantidad = cantidadNueva
                print("1 MAS")
            }*/
        totalPrecio.text = String(productosSeleccionados.count)
        print("Cambiado")
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is PedidoViewController{
            let vc = segue.destination as? PedidoViewController
            vc?.token = token
            vc?.productosSeleccionados.append(contentsOf: productosSeleccionados)
            print("PRO ENVIADOS -> ", vc?.productosSeleccionados.count)
            vc!.productos.append(contentsOf: self.productos)
            vc!.productos.append(contentsOf: self.productos)
            vc?.userPe = userPro
            vc?.idPe = idPro
        }
        if segue.destination is ViewControllerDescripcion{
            let vc = segue.destination as? ViewControllerDescripcion
            vc?.labelProducto.text = productos[vc!.index].product
            let defaultLink = "https://bbdd-javi030.c9users.io/IosPanaderia/images/"
            let completo = defaultLink + self.productos[vc!.index].imagen
            vc?.imagenProducto.downloadedFrom(link: completo)
            vc?.labelDescripcion.text = productos[vc!.index].description
        }
        
    }
}
