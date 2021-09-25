//
//  UserStorage.swift
//  MapsLocation
//
//  Created by Alexey on 25.08.2021.
//

import RealmSwift

class UserStorage {
    static var shared = UserStorage()
    
    private var realm = try! Realm()
    
    private init() {  }
    
    // MARK: - Saving data
    
    func addUser(_ user: User) -> Bool {
        if isUserExist(user: user) {
            return false
        } else {
            createUser(user)
            return true
        }
    }

    
    func saveCustomMarker(_ image: UIImage, for username: String) {
        guard let documentsDirectory = FileManager.default.urls(for: .documentDirectory,
                                                                in: .userDomainMask).first else { return }
        
        let fileName = username
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 1) else { return }
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            do {
                try FileManager.default.removeItem(atPath: fileURL.path)
            } catch let removeError {
                print("Couldn't remove file at path", removeError)
            }
        }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("error saving file with error", error)
        }
    }
    
    func loadCustomMarker(for username: String) -> UIImage? {
        let documentDirectory = FileManager.SearchPathDirectory.documentDirectory
        
        let userDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(documentDirectory, userDomainMask, true)
        
        if let dirPath = paths.first {
            let imageUrl = URL(fileURLWithPath: dirPath).appendingPathComponent(username)
            let image = UIImage(contentsOfFile: imageUrl.path)
            return image
            
        }
        
        return nil
    }
    
    private func createUser(_ user: User) {
        try? realm.write {
            realm.add(user)
        }
    }
    
    // MARK: - isUserExist
    
    func isUserExist(user: User) -> Bool {
        guard let databaseUser = realm.object(ofType: User.self, forPrimaryKey: user.login) else { return false }
        
        if user.password == databaseUser.password {
            return true
        } else {
            return false
        }
    }
    
}
