//
//  TicketViewController.swift
//  ProyectoSwift
//
//  Created by Rosenrot on 5/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController, OnHttpResponse {
    
    var tickets = [Ticket]()
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("token ", token)
        print("Ticket ", tickets.count)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func onDataReceived(data: Data){
        let respuesta = RestJsonUtil.jsonToDict(data : data)
        
        do{
            tickets = try JSONDecoder().decode([Ticket].self, from: try! JSONSerialization.data(withJSONObject: respuesta!["ticket"]))
        }
        catch {
            print("Error al recibir los datos.")
        }
        
        
    }
    
    func onErrorReceivingData(message: String){
        print("Error al recibir los datos.")
    }
    
    func decargarTicket(){
        guard let miTicket = ClienteHttp(target: "ticket", authorization: "Bearer " + token, responseObject: self) else {
            return
        }
        miTicket.request()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tickets.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "TicketTableViewCell"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TicketTableViewCell else {
            fatalError("Error nena")
        }
        
        //let cell:pedidoTableViewCell = pedidoTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.idticketlabel.text = tickets[indexPath.row].id
        cell.idmemberlabel.text = tickets[indexPath.row].id_member
        cell.dateticketlabel.text = tickets[indexPath.row].date
        
        return cell
        
    }
    
}

