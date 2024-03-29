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


/// https://stackoverflow.com/questions/48134100/can-we-generate-realm-results-in-background-queue-and-use-it-on-main-thread
/// https://www.mongodb.com/docs/legacy/realm/swift/3.0.2/api/Classes/ThreadSafeReference.html
struct RealmManager {
    
    // MARK: - Propertys
    
    private let localRealm = try! Realm()
    
    // Database Table
    private var database: Results<Chatting>
    
    var count: Int { database.count }
    
    var lastChatDate: String {
        let lastDate = database.where {
            $0.from == DataStorage.shared.matchedUser.id || $0.to == DataStorage.shared.matchedUser.id
        }.last?.createdAt
        
        if let lastDate {
            return DateFormatterManager.shared.string(from: lastDate)
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
            .where {
                $0.from == uid || $0.to == uid
            }
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
    
    
    mutating private func fetchData(uid: String) {
        database = localRealm.objects(objectType)
            .where { $0.from == uid }
            .sorted(byKeyPath: byKeyPath, ascending: ascending)
    }
    
    
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
    
    
    mutating func addObserver(completion: @escaping () -> Void) {
        notificationToken = database.observe { _ in
            completion()
        }
    }
}
