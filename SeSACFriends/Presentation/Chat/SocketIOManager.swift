//
//  SocketIOManager.swift
//  SeSACFriends
//
//  Created by 김정민 on 2022/02/14.
//

import Foundation
import SocketIO


class SocketIOManager: NSObject {
    
    
    static let shared = SocketIOManager()
    
    // 서버와 메시지를 주고받기 위한 클래스
    var manager: SocketManager!
    
    // 클라이언트 소켓
    var socket : SocketIOClient!
    
    
    
    override init() {
        super.init()
        let url = URL(string: "http://test.monocoding.com:35484")!
        
        manager = SocketManager(socketURL: url,config : [
            .log(true),
            .compress,
            .extraHeaders(["idtoken" : UserManager.idtoken! ])
        
        ] )
        
        socket = manager.defaultSocket // "/"로 된 룸
        
        //소켓 연결 메서드
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED" ,data,ack)
        }
        
        //소켓 연결 해제 메서드
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED" ,data,ack)
        }
        
        socket.on("chat") { dataArray, ack in
            print("chat received", dataArray, ack)
            let data = dataArray[0] as! NSDictionary
            let chat = data["chat"] as! String
            let from = data["from"] as! String
            let createdAt = data["createdAt"] as! String
            
            NotificationCenter.default.post(name: NSNotification.Name("getMessage"), object: self , userInfo: ["chat":chat,"from":from, "createdAt" : createdAt])
        }
        
        
    }
    
    
    func establishConnection() {


    }
    
    
    
    
    
}

