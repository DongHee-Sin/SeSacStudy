//
//  SocketIOManager.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/06.
//

import Foundation

import SocketIO


final class SocketIOManager {

    // MARK: - Propertys
    private var manager: SocketManager
    private var socket: SocketIOClient
    
    private var delegate: SocketDataDelegate
    
    
    
    
    // MARK: - Init
    init(delegate: SocketDataDelegate) {
        self.delegate = delegate
        
        manager = SocketManager(socketURL: URL(string: "http://api.sesac.co.kr:1210")!, config: [.forceWebsockets(true)])
        socket = manager.defaultSocket
        
        // 연결
        socket.on(clientEvent: .connect) { data, ack in
            print("SOCKET IS CONNECTED", data, ack)
            self.socket.emit("changesocketid", DataStorage.shared.login.uid)
        }
        
        // 연결 해제
        socket.on(clientEvent: .disconnect) { data, ack in
            print("SOCKET IS DISCONNECTED", data, ack)
        }
        
        // 이벤트 수신
        socket.on("chat") { [weak self] dataArray, ack in
            print("SESAC RECEIVED", dataArray, ack)
            
            let data = dataArray[0] as! NSDictionary
            let id = data[ChatResponse.CodingKeys.id.rawValue] as! String
            let to = data[ChatResponse.CodingKeys.to.rawValue] as! String
            let from = data[ChatResponse.CodingKeys.from.rawValue] as! String
            let chat = data[ChatResponse.CodingKeys.chat.rawValue] as! String
            let createdAt = data[ChatResponse.CodingKeys.createdAt.rawValue] as! String
            
            print("⭐️⭐️⭐️ check >>>", chat, to, from, createdAt)
            
            let chatResponse = ChatResponse(id: id, to: to, from: from, chat: chat, createdAt: createdAt)
            self?.delegate.received(message: chatResponse)
        }
    }
    
    
    
    
    // MARK: - Methods
    func establishConnection() {
        socket.connect()
    }
    
    
    func closeConnection() {
        socket.disconnect()
    }
}
