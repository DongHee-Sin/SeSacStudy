//
//  SocketDataDelegate.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/07.
//

import Foundation


protocol SocketDataDelegate: AnyObject {
    func received(message: ChatResponse)
}
