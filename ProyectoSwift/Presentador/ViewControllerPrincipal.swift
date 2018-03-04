//  ViewControllerPrincipal.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 26/2/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class ViewControllerPrincipal: UIViewController, OnHttpResponse, UICollectionViewDataSource {
    
    var token = ""

    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        print("token")
        print(token)
        collectionView.dataSource = self
        
        guard let cliente = ClienteHttp(target: "family", authorization: "Basic amF2aTpqYXZp", responseObject: self) else {
            return
        }
        cliente.request()
        //let url = URL(string : "https://bbdd-javi030.c9users.io/IosPanaderia/")
        
     
    }
    
    func onDataReceived(data: Data) {
        
        do{
            // Obtenemos la respuesta de la peticion, como es un JSON, lo decodificamos y lo convertimos
            // en un objeto de la clase family.swift |data es los datos devueltos de la petición|
            let categorias = try JSONDecoder().decode(Family.self, from: data)
            print(categorias)
            if(categorias.family.isEmpty){
                print("******NO HAY DATOS DE CATEGORIAS******")
            }else{
                print("******CATEGORIAS*****")
                print(categorias.id, categorias.family)
            }
        }catch {
            print("Error al recibir los datos")
        }
    }
    
    func onErrorReceivingData(message: String) {
        print("Error al recibir los datos 1")
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.nameLabel.text = token//categorias[indexPath.row].family.capitalized
        return cell
    }
}
