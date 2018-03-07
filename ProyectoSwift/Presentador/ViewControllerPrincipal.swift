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

class ViewControllerPrincipal: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var token = ""
    var categorias = [Family]()
    var imagenes : [UIImage] = []
    var productos = [Product]()
    var idCat = ""
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return categorias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        let defaultLink = "https://bbdd-javi030.c9users.io/IosPanaderia/images/"
        let completeLink = defaultLink + categorias[indexPath.row].imagen
        idCat = categorias[indexPath.row].id
        cell.nameLabel.text = categorias[indexPath.row].family
        cell.imageView.downloadedFrom(link: completeLink)
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
            vc?.idCategoria = self.idCat
            vc?.token = self.token
            print("ID PASADA -> ", vc?.idCategoria)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("Aqui entra")
        let mainStoryboard:UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let desVC = mainStoryboard.instantiateViewController(withIdentifier: "CollectionViewProductos") as! CollectionViewControllerProductos
        let id = categorias[indexPath.row].id
        self.navigationController?.pushViewController(desVC, animated: true)
    }
}
