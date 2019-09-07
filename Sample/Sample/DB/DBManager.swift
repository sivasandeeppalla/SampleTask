//
//  DBManager.swift
//  Sample
//
//  Created by siva sandeep on 06/09/19.
//  Copyright © 2019 kaha. All rights reserved.
//
import RealmSwift

public class DBManager {
    
    var realm: Realm {
        do {
            let realm = try Realm()
            return realm
        } catch {
            debugPrint(error.localizedDescription)
        }
        return self.realm
    }
    
    func write(writeClosure: () -> Void) {
        do {
            try realm.write {
                writeClosure()
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
    
    func deleteAll() {
        do {
            try realm.write {
                realm.deleteAll()
            }
        } catch {
            debugPrint(error.localizedDescription)
        }
    }
}
