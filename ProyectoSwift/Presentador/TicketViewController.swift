//
//  TicketViewController.swift
//  ProyectoSwift
//
//  Created by Rosenrot on 5/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, OnHttpResponse {
    
    var tickets = [Ticket]()
    var productosSeleccionados = [ProductPedidos]()
    var token = ""
    
    @IBOutlet weak var miTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        miTableView.dataSource = self
        miTableView.delegate = self
        
        
        
        let date = String(describing: Date())
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
            
            
        }
        
        
        descargarTicket()
        print("token ", token)
        
        
        /*tickets += [
         Ticket(id: "1", date: "datemia", id_member: "1")
         ]*/
        
    }
    
    func onDataReceived(data: Data) {
        /*let respuesta = RestJsonUtil.jsonToDict(data : data)
         print("Respuesta --->", respuesta!)
         
         do{
         tickets = try JSONDecoder().decode([Ticket].self, from: try! JSONSerialization.data(withJSONObject: respuesta!["ticket"]))
         }
         catch {
         print("Error al recibir los datos.")
         }
         print("Ticket ", tickets.count)
         print("asdasd", tickets[0].id)*/
    }
    
    func onErrorReceivingData(message: String){
        print("Error al recibir los datos.")
    }
    
    /*func itemsDownloaded() {
     
     //tickets = ticket
     self.miTableView.reloadData()
     }*/
    
    
    func descargarTicket(){
        guard let miTicket = ClienteHttp(target: "ticket", authorization: "Bearer " + self.token, responseObject: self) else {
            return
        }
        miTicket.request()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TicketTableViewCell"
        
        let cell = miTableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TicketTableViewCell
        
        
        cell?.idTicket.text = tickets[indexPath.row].id
        print("el id", tickets[indexPath.row].id)
        //cell.date.text = tickets[indexPath.row].date
        cell?.idMember.text = tickets[indexPath.row].id_member
        
        return cell!
        
    }
    
}

