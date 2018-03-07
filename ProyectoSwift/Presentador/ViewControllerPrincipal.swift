//  ViewControllerPrincipal.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 26/2/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

extension UIImageView {
    func downloadedFrom(url: URL, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        contentMode = mode
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                let data = data, error == nil,
                let image = UIImage(data: data)
                else { return }
            DispatchQueue.main.async() {
                self.image = image
            }
            }.resume()
    }
    func downloadedFrom(link: String, contentMode mode: UIViewContentMode = .scaleAspectFit) {
        guard let url = URL(string: link) else { return }
        downloadedFrom(url: url, contentMode: mode)
    }
}

class ViewControllerPrincipal: UIViewController, OnHttpResponse, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var token = ""
    var categorias = [Family]()
    var imagenes : [UIImage] = []
    var productos = [Product]()
    var idCat : String = ""
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
        descargarProductos()
        print("PRODUCTOS RECIBIDOS -> ", productos.count)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return categorias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        let defaultLink = "https://bbdd-javi030.c9users.io/IosPanaderia/images/"
        let completeLink = defaultLink + categorias[indexPath.row].imagen
        cell.nameLabel.text = categorias[indexPath.row].family
        cell.imageView.downloadedFrom(link: completeLink)
        
        if cell.isSelected {
            self.idCat = String(indexPath.row)
            print("GUARDA ID CAT -> ", idCat)
        }
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segue al menu inicial
        if segue.destination is ViewControllerMain {
            let vc = segue.destination as? ViewControllerMain
            vc?.tokenMain = token
        }
        if segue.destination is CollectionViewControllerProductos{
            let vc = segue.destination as? CollectionViewControllerProductos
            vc?.token = self.token
            vc?.productos.append(contentsOf: self.productos)
            vc?.idCategoria = idCat
            print("ID CAT YEEH -> ", idCat )
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "CollectionViewProductos") as! CollectionViewControllerProductos
        idCat = categorias[indexPath.row].id
        print("ID FILA -> ", self.idCat)
        desVC.idCategoria = categorias[indexPath.row].id
        print("ID PASADA -> ", desVC.idCategoria)
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.backgroundColor = .red
    }
    
    func onDataReceived(data: Data) {
    
        let respuesta = RestJsonUtil.jsonToDict(data: data)
        
        do{
            productos = try JSONDecoder().decode([Product].self,
                                                 from: try! JSONSerialization.data(withJSONObject: respuesta!["product"]))
        }catch{
            print("ERROR ABC")
        }
    }
    
    func onErrorReceivingData(message: String) {
        print("ERRORRRR")
    }
    // Descargar Productos
    func descargarProductos(){
        guard let cliente = ClienteHttp(target: "product", authorization: "Bearer " + self.token, responseObject: self) else {
            return
        }
        cliente.request()
    }
}
