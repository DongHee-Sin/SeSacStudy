//
//  RealmManager.swift
//  SeSacStudy
//
//  Created by 신동희 on 2022/12/05.
//

import Foundation

import RealmSwift


enum RealmError: Error {
    case writeError
    case updateError
    case deleteError
}


struct RealmManager {
    
    // MARK: - Propertys
    
    private let localRealm = try! Realm()
    
    // Database Table
    private var database: Results<Chatting>
    
    var count: Int { database.count }
    
    var lastChatDate: String {
        if let date = database.last?.createdAt {
            return DateFormatterManager.shared.string(from: date)
        }else {
            return "2000-01-01T00:00:00.000Z"
        }
    }
    
    // Table Type 저장
    private var objectType = Chatting.self
    
    // 정렬 기준 저장
    private var byKeyPath: String = "createdAt"
    private var ascending: Bool = true
    
    // Observer 토큰
    private var notificationToken: NotificationToken?
    
    
    
    
    // MARK: - Init
    
    init(uid: String) {
        database = localRealm.objects(objectType)
            .where { $0.from == uid }
            .sorted(byKeyPath: byKeyPath, ascending: ascending)
        
        print("Realm is located at:", localRealm.configuration.fileURL!)
    }
    
    
    
    
    // MARK: - Methods
    
    // Create(add)
    func write(_ objects: [Chatting]) throws {
        do {
            try localRealm.write {
                localRealm.add(objects)
            }
        }
        catch {
            throw RealmError.writeError
        }
    }
    
    
    
    func getData(at index: Int) -> Chatting {
        return database[index]
    }
    
    
    
    // Read
    mutating private func fetchData(uid: String) {
        database = localRealm.objects(objectType)
            .where { $0.from == uid }
            .sorted(byKeyPath: byKeyPath, ascending: ascending)
    }
    
    
    
    // Update
    func update(at index: Int, completion: (Chatting) -> Void) throws {
        let dataToUpdate = database[index]
        
        do {
            try localRealm.write({
                completion(dataToUpdate)
            })
        }
        catch {
            throw RealmError.updateError
        }
    }
    
    
    
    // Delete
    func remove(at index: Int) throws {
        let dataToDelete = database[index]
        
        do {
            try localRealm.write {
                localRealm.delete(dataToDelete)
            }
        }
        catch {
            throw RealmError.deleteError
        }
    }
    
    
    
    // Observer 달기
    /// 데이터 변경되면
    /// 1. fetchData : database 업데이트
    /// 2. tableVeiw reload
    mutating func addObserver(completion: @escaping () -> Void) {
        notificationToken = database.observe { _ in
            completion()
        }
    }
}
