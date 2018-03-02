//  ViewControllerPrincipal.swift
//  ProyectoSwift
//
//  Created by Javier Lopez Girela on 26/2/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

struct family : Codable{
    var id : Int
    var family : String
    var imagen : String
}

class ViewControllerPrincipal: UIViewController, UICollectionViewDataSource {
    // HOLA
    var categorias = [family]()
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.dataSource = self
        
        let url = URL(string : "https://bbdd-javi030.c9users.io/IosPanaderia/")
        URLSession.shared.dataTask(with: url!) { (data, response, error) in
            do{
                self.categorias = try JSONDecoder().decode([family].self, from: data!)
            }catch {
                print("error")
            }
            
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }.resume()
     
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categorias.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "customCell", for: indexPath) as! CustomCollectionViewCell
        
        cell.nameLabel.text = categorias[indexPath.row].family.capitalized
        return cell
    }


}
