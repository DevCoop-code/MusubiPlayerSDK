//
//  MusubiOfflineStore.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/21.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

open class MusubiOfflineStore: NSObject {
    
    var streamingURI: String?
    var musubiOfflineDispatchQueue: DispatchQueue?
    var device: MusubiDevice?
    
    let offlineStoreDB: String = "offlineStoreDB.db"
    
    public init(_ willStoreURI: String?, device: MusubiDevice?) {
        self.streamingURI = willStoreURI
        self.device = device
        musubiOfflineDispatchQueue = DispatchQueue(label: "offlineStoreQueue")
    }
    
    open func startStore() {
        musubiOfflineDispatchQueue?.async {
            if let streamingPath = self.streamingURI {
                let url = URL(string: streamingPath)
                
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
                        
                        
//                        let masterPlayList = "<url>\(streamingURL.path)</url>\n"
//
//                        if let fileManager = self.device?.filemgr {
//                            if !fileManager.fileExists(atPath: "offlinePlayList") {
//                                fileManager.createFile(atPath: "offlinePlayList", contents: masterPlayList.data(using: .utf8), attributes: nil)
//                            }
//                        }
                        if let fileManager = self .device?.filemgr {
                            if !fileManager.fileExists(atPath: self.offlineStoreDB) {
                                let contactDB = FMDatabase(path: self.offlineStoreDB)
                                
                                if contactDB == nil {
                                    NSLog("Error: \(contactDB.lastErrorMessage())")
                                }
                                
                                if contactDB.open() {
                                    let sql_stmt = "CREATE TABLE IF NOT EXISTS MEDIAOFFLINEINFO (ID INTEGER PRIMARY KEY AUTOINCREMENT, URL TEXT)"
                                    if !contactDB.executeStatements(sql_stmt) {
                                        NSLog("Error: \(contactDB.lastErrorMessage())")
                                    }
                                    contactDB.close()
                                } else {
                                    NSLog("Error: \(contactDB.lastErrorMessage())")
                                }
                            }
                        }
                    })
                    
                    // Execute the Connection to Media Server
                    task.resume()
                }
            }
        }
    }
}
