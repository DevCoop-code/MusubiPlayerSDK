//
//  MusubiOfflineStore.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/21.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

open class MusubiOfflineStore: NSObject {
    var musubiOfflineDispatchQueue: DispatchQueue?
    var device: MusubiDevice?
    
    let offlineStoreDB: String = "offlineStoreDB.db"
    var offlineDB: FMDatabase?
    
    public init(device: MusubiDevice?) {
        self.device = device
        musubiOfflineDispatchQueue = DispatchQueue(label: "offlineStoreQueue")
        
        if let fileManager = self.device?.filemgr {
            if !fileManager.fileExists(atPath: self.offlineStoreDB) {
                let attributes: [FileAttributeKey:AnyObject] = [FileAttributeKey.posixPermissions: NSNumber(value: 0o777)]
                fileManager.createFile(atPath: offlineStoreDB, contents: nil, attributes: attributes)
            }
        }
        
        offlineDB = FMDatabase(path: self.offlineStoreDB)
        if let db:FMDatabase = offlineDB {
            if db.open() {
                let sql_stmt = "CREATE TABLE IF NOT EXISTS MEDIAOFFLINEINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, URL TEXT)"
                if !db.executeStatements(sql_stmt) {
                    NSLog("Error: \(db.lastErrorMessage())")
                }
                db.close()
            } else {
                NSLog("Error: \(db.lastErrorMessage())")
            }
        }
    }
    
    open func startStore(_ streamingURI: String) {
        musubiOfflineDispatchQueue?.async {
            let url = URL(string: streamingURI)
            
            if let streamingURL = url {
                let task = URLSession.shared.dataTask(with: streamingURL, completionHandler: {
                    (data, response, error) -> Void in
                    guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                        return
                    }
                    // Success to Connection of Server
                    guard let mediaPlayList = String(data: data!, encoding: .utf8) else {
                        return
                    }
                    NSLog("Master PlayList %@", mediaPlayList)
      
                    if let db:FMDatabase = self.offlineDB {
                        if db.open() {
                            let condSelectSQL = "SELECT ID FROM MEDIAOFFLINEINFO WHERE URL = '\(streamingURL)'"
                            let results:FMResultSet? = db.executeQuery(condSelectSQL, withParameterDictionary: nil)
                            
                            if results?.next() == false {
                                let insertSQL = "INSERT INTO MEDIAOFFLINEINFO (URL) VALUES ('\(streamingURL)')"
                                
                                db.executeUpdate(insertSQL, withArgumentsIn: [])
                                
                                
                            }
                            db.close()
                        }
                    }
                })
                
                // Execute the Connection to Media Server
                task.resume()
            }
        }
    }
    
    open func remove(_ streamingURI: String) {
        musubiOfflineDispatchQueue?.async {
            if let db:FMDatabase = self.offlineDB {
                if db.open() {
                    let removeSQL = "DELETE FROM MEDIAOFFLINEINFO WHERE URL = ?"
                    db.executeUpdate(removeSQL, withArgumentsIn: [streamingURI])
                    
                    db.close()
                }
            }
        }
    }
}
