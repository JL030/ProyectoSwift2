//
//  PedidoViewController.swift
//  ProyectoSwift
//
//  Created by Rosenrot on 5/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class PedidoViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OnHttpResponse {
    
    var pedidos = [Pedido]()
    var resultado = 0.0
    var user = ""
    // AÑADIDO POR JAVI
    var token = ""
    var productosSeleccionados = [ProductPedidos]()
    
    
    @IBOutlet weak var pedidotv: UITableView!
    
    @IBOutlet weak var precioTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        //productosSeleccionados = [ProductPedidos]()
        print("Mis productos ->", productosSeleccionados.count)
        
        /*pedidos += [
         Pedido(nombre: "Pan blanco", precio: 0.80),
         Pedido(nombre: "Barra integral", precio: 1.00),
         Pedido(nombre: "Napolitana", precio: 0.85),
         Pedido(nombre: "Tarta de queso", precio: 3.10)
         ]*/
        
        //var resultado = 0.0
        for prod in self.productosSeleccionados {
            resultado += Double(prod.precio)!
            print("Resultado ->", resultado)
        }
        self.precioTotal?.text = String(resultado)
        
    }
    
    func onDataReceived(data: Data) {
        
    }
    
    func onErrorReceivingData(message: String) {
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return productosSeleccionados.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "PedidoTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? PedidoTableViewCell else {
            fatalError("Error nena")
        }
        
        //let cell:pedidoTableViewCell = pedidoTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        let url = "https://bbdd-javi030.c9users.io/IosPanaderia/images/"
        let urlCompleta = url + productosSeleccionados[indexPath.row].imagen
        cell.imagen.downloadedFrom(link: urlCompleta)
        cell.nombre?.text = productosSeleccionados[indexPath.row].producto
        cell.precio?.text = "\(productosSeleccionados[indexPath.row].precio) €"
        //cell.nombre?.text = "Hola"
        //cell.precio?.text = "Precio"
        
        return cell
        
    }
    
    
    var label : UILabel!
    var stepper : UIStepper!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alerta = UIAlertController(title: "Cantidad", message: "\n\n\n\n", preferredStyle: .alert)
        alerta.addAction(UIAlertAction(title: "Cancelar", style: .default, handler: nil))
        alerta.addAction(UIAlertAction(title: "Aceptar", style: .default, handler: { (action: UIAlertAction!) in
            
            var precio = 0.0
            precio = Double(self.productosSeleccionados[indexPath.row].precio)!
            
            self.resultado += precio * (Double(self.stepper.value))
            let preciototal = String(format: "%.2f" , (Double(self.resultado)))
            self.precioTotal.text = preciototal + " €"
        }))
        
        //Label
        label = UILabel(frame:CGRect(x: 0, y: 0, width: 100, height: 15))
        label.text = "1"
        label.center = CGPoint(x: 180,y: 60)
        
        alerta.view.addSubview(label)
        
        //Stepper
        stepper = UIStepper (frame:CGRect(x: 0, y: 0, width: 0, height: 0))
        // Resume UIStepper value from the beginning
        stepper.wraps = true
        // Position UIStepper in the center of the view
        stepper.center = CGPoint(x: 135,y: 100)
        // If tap and hold the button, UIStepper value will continuously increment
        stepper.autorepeat = true
        stepper.maximumValue = 20
        stepper.minimumValue = 1
        stepper.stepValue = 1
        
        stepper.addTarget(self, action: #selector(actualizar), for: .valueChanged)
        
        alerta.view.addSubview(stepper)
        
        self.present(alerta, animated: true, completion: nil)
        
    }
    
    @objc func actualizar() {
        label.text = "\(Int(stepper.value))"
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete {
            // Delete the row from the data source
            self.pedidos.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }
        
        func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
            // Return false if you do not want the specified item to be editable.
            return true
        }
    }
    
    @IBAction func guardarTicket(_ sender: UIButton) {
        /*var totalproducto = [Pedido]()
         
         for pedido in self.pedidos {
         
         var nomb = pedido.nombre
         var precios = pedido.precio
         var canti = pedido.cantidad
         //var produc = Pedido(nombre: "nombre", precio: 0.0)
         //totalproducto.append(produc)
         
         //print(totalproducto)
         print("Nombre:" + nomb)
         print("Precio:" + "\(precios)")
         print("Cantidad:" + "\(canti)")
         }
         
         //self.precioTotal.text = "\(resultado) €"*/
        
        
        //Probando con datos fijos a la espera de lo de Javi
        
        let date = String(describing: Date())
        print("La fecha -->", date)
        let id_member = 1
        
        for prod in self.productosSeleccionados {
        
            var newticket = [String: Any]()
            newticket = ["date": date, "id_member": id_member]
            
            guard let insertarTicket = ClienteHttp.init(target: "setTicket", authorization: "Bearer " + token, responseObject: self, "POST", newticket) else {
                return
            }
            insertarTicket.request()
            
            
            
            var datos = [String: Any]()
            datos = ["id_product": prod.id_producto, "quantity": 3, "price": prod.precio]
            
            guard let insertarTicketDetail = ClienteHttp.init(target: "setTicketDetail", authorization: "Bearer " + token, responseObject: self, "POST", datos) else {
                return
            }
            insertarTicketDetail.request()
        }
        
        
        
        
        
        print("Pulsado")
        
        /*let idticket = ""
         
         var datos = [String: Any]()
         
         for prod in self.productosSeleccionados {
         print("Id de producto ->", prod.id_producto)
         print("Precio ->", prod.precio)
         datos = ["id_ticket": idticket, "id_product": prod.id_producto, "quantity": 1, "price": prod.precio]
         guard let insertarTicket = ClienteHttp.init(target: "setTicketDetail", authorization: "Basic YW5nZWw6YW5nZWw=", responseObject: self, "POST", datos) else {
         return
         }
         insertarTicket.request()
         print("Y uno")
         
         }*/
        
        /*func prepare(for segue: UIStoryboardSegue, sender: Any?) {
            if segue.destination is TicketViewController{
                let tvc = segue.destination as? TicketViewController
                tvc?.token = self.token
                print("Mandando token -> ", tvc?.token)
            }
        }*/
        
    }
    
}
