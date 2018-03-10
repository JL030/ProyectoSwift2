//
//  TicketViewController.swift
//  ProyectoSwift
//
//  Created by Rosenrot on 5/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//

import UIKit

class TicketViewController: UIViewController, OnHttpResponse, UITableViewDataSource, UITableViewDelegate {
    
    var tickets = [Ticket]()
    var token = ""
    var productos = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("token ", token)
        print("Ticket ", tickets.count)
        //descargarTicket()
        //print("Ticket -> ", tickets[0].id, "---", tickets[0].date)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func onDataReceived(data: Data){
        let respuesta = RestJsonUtil.jsonToDict(data : data)
        
        do{
            tickets = try JSONDecoder().decode([Ticket].self, from: try! JSONSerialization.data(withJSONObject: respuesta!["ticket"]))
            
            print("TIKKET ID -> ", tickets[0].id)
        }
        catch {
            print("Error al recibir los datos.")
        }
        
        
    }
    
    func onErrorReceivingData(message: String){
        print("Error al recibir los datos.")
    }
    
    func descargarTicket(){
        guard let miTicket = ClienteHttp(target: "getTicket", authorization: "Bearer " + token, responseObject: self) else {
            return
        }
        miTicket.request()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "cellticket"
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as? TicketTableViewCell else {
            fatalError("Error nena")
        }
        
        //let cell:pedidoTableViewCell = pedidoTableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "cell")
        cell.idticketlabel.text = "Prueba"
        cell.idmemberlabel.text = "yEEH"
        //cell.dateticketlabel.text = tickets[indexPath.row].date
        
        return cell
        
    }
    
}

