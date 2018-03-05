//  ViewControllerPrincipal.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 26/2/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class ViewControllerPrincipal: UIViewController, OnHttpResponse, UICollectionViewDataSource {
    
    var token = ""
    var categorias = [Family]()
    var imagenes = [UIImage]()

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("ESTE ES EL token")
        print(token)
        collectionView.dataSource = self
        
        
        guard let cliente = ClienteHttp(target: "family", authorization: "Bearer " + token, responseObject: self) else {
            return
        }
        cliente.request()
    }
    
    func onDataReceived(data: Data) {
        
        let respuesta = RestJsonUtil.jsonToDict(data : data)
        print("ESTO ES")
        print(respuesta!)
        
        do{
            // Obtenemos la respuesta de la peticion, como es un JSON, lo decodificamos y lo
            // convertimos
            // en un objeto de la clase family.swift |data es los datos devueltos de la petición|
            categorias = try JSONDecoder().decode([Family].self,
                                                  from: try! JSONSerialization.data(withJSONObject: respuesta!["categories"]))
        }catch {
            print("Error al recibir los datos")
        }
        collectionView.reloadData()
    }
    
    func onErrorReceivingData(message: String) {
        print("Error al recibir los datos 1")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        var imagen : String = categorias[indexPath.row].imagen
        print("imagen")
        print(imagen)
        download(imagen: imagen)
        cell.nameLabel.text = categorias[indexPath.row].family
        cell.imageView.image = imagenes[indexPath.row]
        return cell
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //Segue al menu inicial
        if segue.destination is ViewControllerMain {
            
            let vc = segue.destination as? ViewControllerMain
            vc?.token = token
        }
    }
    func download(imagen :String) {
        let urlImagen = "https://bbdd-javi030.c9users.io/IosPanaderia/ \(imagen)"
        if let url = URL(string: urlImagen) {
            let cola = DispatchQueue(label: "bajar.imagen", qos: .default,
                                     attributes: .concurrent)
            cola.async {
                if let data = try? Data(contentsOf: url),
                    let imagen = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.imagenes = [imagen]
                    }
                }
            }
            
        }
        
    }
    
}
