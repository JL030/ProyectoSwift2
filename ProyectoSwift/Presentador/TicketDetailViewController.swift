//
//  TicketDetailViewController.swift
//  ProyectoSwift
//
//  Created by Rosenrot on 11/3/18.
//  Copyright © 2018 Javier Lopez Girela. All rights reserved.
//


import UIKit

class TicketDetailViewController: UIViewController, OnHttpResponse {
    func onDataReceived(data: Data) {
        
    }
    
    func onErrorReceivingData(message: String) {
        
    }
    
    
    var idTicketPasado : String = ""
    var tickets = [Ticket]()
    var ticketfiltrado = [Ticket]()
    var ticketDetail = [TicketDetail]()
    var token = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("Id del ticket pasado ->", idTicketPasado)
        print("ticket con detalle ", ticketDetail.count)
        descargarTicketDetail()
        
        /*for elticket in tickets{
         if elticket.id = self.idTicketPasado{
         self.ticketfiltrado.append(elticket)
         }
         }*/
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func descargarTicketDetail(){
        guard let miTicket = ClienteHttp(target: "ticket", authorization: "Bearer " + self.token, responseObject: self) else {
            return
        }
        miTicket.request()
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
