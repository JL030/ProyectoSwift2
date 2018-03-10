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
    var tickets = [Ticket]()
    var resultado = 0.0
    var userPe = ""
    var idPe = ""
    // AÑADIDO POR JAVI
    var token = ""
    var productosSeleccionados = [ProductPedidos]()
    var productos = [Product]()
    
    
    @IBOutlet weak var pedidotv: UITableView!
    
    @IBOutlet weak var precioTotal: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DATOS PASADOS POR MUA\(userPe, idPe)")
        print("TOKEN\(token)")
        navigationItem.leftBarButtonItem = editButtonItem
        descargarTicket()
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
        let respuesta = RestJsonUtil.jsonToDict(data : data)
        //print("Respuesta --->", respuesta!)
        
        do{
            tickets = try JSONDecoder().decode([Ticket].self, from: try! JSONSerialization.data(withJSONObject: respuesta!["ticket"]))
        }
        catch {
            print("Error al recibir los datos.")
        }
        print("Ticket en pedidoview", tickets.count)
        print("asdasd en pedido view", tickets[0].id)
    }
    
    func onErrorReceivingData(message: String){
        print("Error al recibir los datos.")
    }
    
    func descargarTicket(){
        guard let miTicket = ClienteHttp(target: "ticket", authorization: "Bearer " + self.token, responseObject: self) else {
            return
        }
        miTicket.request()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TicketViewController{
            let tvc = segue.destination as? TicketViewController
            tvc?.token = token
            tvc?.tickets.append(contentsOf: self.tickets)
            tvc!.productosSeleccionados.append(contentsOf: self.productosSeleccionados)
            print("Los tickets que mando por segue ->", tickets.count)
            //print("Id ticket mandado por segue", tickets[0].id)
            
            //print("Mandando token -> ", tvc?.token)
        }
        if segue.destination is CollectionViewControllerProductos{
            let vc = segue.destination as? CollectionViewControllerProductos
            vc!.productos.append(contentsOf: self.productos)
            vc!.productosSeleccionados.append(contentsOf: self.productosSeleccionados)
        }
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
        
        /*let date = String(describing: Date())
        print("La fecha -->", date)
        let id_member = "1"
        let id_client = "2"
        
        for prod in self.productosSeleccionados {
            
            var newticket = [String: Any]()
            newticket = ["date": date, "id_member": id_member, "id_client": id_client]
            
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
            
        
        }*/
        performSegue(withIdentifier: "sendTicket", sender: self)
        
        
        
        
        
        //print("Pulsado")
        
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
        
        
        
    }
    
}

