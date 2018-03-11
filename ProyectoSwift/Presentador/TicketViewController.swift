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
    var ticketDetail = [TicketDetail]()
    var productosSeleccionados = [ProductPedidos]()
    var token = ""
    var fecha = ""
    var idPe = ""
    var idTicket = ""
    
    @IBOutlet weak var miTableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        miTableView.dataSource = self
        miTableView.delegate = self
        
        
        
        //let date = String(describing: Date())
        //print("La fecha -->", date)
        let quantity = "1"
        let id_member = "2"
        let id_client = ""
        let id = ""
        
        for prod in self.productosSeleccionados {
            
            var newticket = [String: Any]()
            newticket = ["id": id,"date": fecha, "id_member": idPe, "id_client": id_client]
            
            var arrayticket = [Ticket]()
            arrayticket += [
                Ticket(id: id, date: fecha, id_member: idPe)
             ]
            
            tickets.append(contentsOf: arrayticket)
            
            guard let insertarTicket = ClienteHttp.init(target: "setTicket", authorization: "Bearer " + token, responseObject: self, "POST", newticket) else {
                return
            }
            insertarTicket.request()
            
            
            
            var datos = [String: Any]()
            datos = ["id_product": prod.id_producto, "quantity": quantity, "price": prod.precio]
            
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
        cell?.fecha.text = tickets[indexPath.row].date
        cell?.idMember.text = tickets[indexPath.row].id_member
        
        idTicket = tickets[indexPath.row].id
        
        if (cell?.isSelected)! {
            self.idTicket = tickets[indexPath.row].id
            print("Id ticket -> ", idTicket)
        }
        
        return cell!
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is TicketDetailViewController{
            let tdvc = segue.destination as? TicketDetailViewController
            tdvc?.token = token
            tdvc?.idTicketPasado = idTicket
            tdvc?.tickets.append(contentsOf: tickets)
            tdvc?.ticketDetail.append(contentsOf: ticketDetail)
            print("Print id ->", idTicket)
            print("Print id ->", tdvc?.idTicketPasado)
        }
        
    }
    
}

