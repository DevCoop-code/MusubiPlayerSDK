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
    var musubiNetwork: MusubiNetwork?
    
    public init(device: MusubiDevice?) {
        super.init()
        self.device = device
        musubiOfflineDispatchQueue = DispatchQueue(label: "offlineStoreQueue")
        musubiNetwork = MusubiNetwork()
        musubiNetwork?.networkCallback = self
        
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
//            if let db:FMDatabase = self.offlineDB {
//                if db.open() {
//                    let condSelectSQL = "SELECT ID FROM MEDIAOFFLINEINFO WHERE URL = '\(streamingURI)'"
//                    let results:FMResultSet? = db.executeQuery(condSelectSQL, withParameterDictionary: nil)
//
//                    if results?.next() == false {
//                        let insertSQL = "INSERT INTO MEDIAOFFLINEINFO (URL) VALUES ('\(streamingURI)')"
//
//                        db.executeUpdate(insertSQL, withArgumentsIn: [])
                        
                        self.musubiNetwork?.httpGet(httpURL: streamingURI)
//                    }
//                    db.close()
//                }
//            }
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

extension MusubiOfflineStore: MusubiNetworkCallback {
    func httpGetResult(url:String, httpStatusCode: Int, httpGetResult: String?, mimeType: String?) {
        if httpStatusCode == 200 {
            if let db:FMDatabase = self.offlineDB {
               if db.open() {
//                   let condSelectSQL = "SELECT ID FROM MEDIAOFFLINEINFO WHERE URL = '\(url)'"
//                   let selectResult: FMResultSet? = db.executeQuery(condSelectSQL, withParameterDictionary: nil)
//                   if selectResult?.next() == true {
                       // Make Directory for store the media Content
//                       let columnID = selectResult?.string(forColumn: "ID")
           //                                    NSLog("Selected ID \(columnID)")
//                       if let fileManager = self.device?.filemgr, let directoryName = columnID {
//                           if !fileManager.fileExists(atPath: directoryName) {
                               // New Offline Content
//                               let newDirPaths = fileManager.urls(for: .documentDirectory, in: .userDomainMask)
//
//                               let rootDirectory = newDirPaths[0].appendingPathComponent("musubi")
//                               let newDir = rootDirectory.appendingPathComponent(directoryName)
//                               do {
//                                   try fileManager.createDirectory(at: newDir,
//                                                                   withIntermediateDirectories: true,
//                                                                   attributes: nil)
//                               } catch let error as NSError {
//                                   NSLog("Error: \(error.localizedDescription)")
//                               }
                               
                               // Store the Master PlayList
//                               fileManager.createFile(atPath: "\(directoryName)/master.m3u8", contents: httpGetResult?.data(using: .utf8), attributes: nil)
                
                let fileManager = self.device?.filemgr
                let newDirPaths = fileManager?.urls(for: .documentDirectory, in: .userDomainMask)
                let rootDirectory = newDirPaths![0].appendingPathComponent("musubi")
                let newDir = rootDirectory.appendingPathComponent("1")
                do {
                    try fileManager!.createDirectory(at: newDir,
                                                   withIntermediateDirectories: true,
                                                   attributes: nil)
                } catch let error as NSError {
                   NSLog("Error: \(error.localizedDescription)")
                }
                
                // Check the Downloaded File
                NSLog("MimeType: \(mimeType)")
                let musubiProtocol = device?.musubiProtocol
                if let mime = mimeType, mime.contains("mpegurl"), let manifestStr = httpGetResult {
                    let hlsType = musubiProtocol?.checkPlayListType(manifest: manifestStr)
                    
                    if hlsType == hlsPlayListType.master {
                        fileManager?.createFile(atPath: "1/master.m3u8", contents: httpGetResult?.data(using: .utf8), attributes: nil)
                        
                        let _subPlayLists = musubiProtocol?.parsingMasterPlayList(manifest: manifestStr)
                        if let subPlayLists = _subPlayLists {
                            for subPlayList in subPlayLists {
                                // Absolute Path
                                if subPlayList.contains("http") {
                                    self.musubiNetwork?.httpGet(httpURL: subPlayList)
                                } else {    // Relative Path
                                    var mediaSubURL: String = ""
                                    let mediaMasterURL = url.split(separator: "/")
                                    for index in 0...mediaMasterURL.count - 2 {
                                        mediaSubURL = mediaSubURL + String(mediaMasterURL[index]) + "/"
                                    }
                                    mediaSubURL = mediaSubURL + subPlayList
                                    NSLog("mediaSubURL : \(mediaSubURL)")
                                    self.musubiNetwork?.httpGet(httpURL: mediaSubURL)
                                }
                            }
                        }
                    }
                    else if hlsType == hlsPlayListType.vod {
                        if let fileManager = fileManager {
                            var index:Int = 1
                            while (index < 10) {    // TODO: Should Get the sub playlist numbers
                                
                                if !fileManager.fileExists(atPath: "1/sub\(index).m3u8") {
                                    fileManager.createFile(atPath: "1/sub\(index).m3u8", contents: httpGetResult?.data(using: .utf8), attributes: nil)
                                    
                                    let _avFileLists = musubiProtocol?.parsingVODPlayList(manifest: manifestStr)
                                    if let avFileLists = _avFileLists {
                                        for avFileList in avFileLists {
                                            // Absolute Path
                                            if avFileList.contains("http") {
                                                self.musubiNetwork?.httpGet(httpURL: avFileList)
                                            } else {    // Relative Path
                                                var avFileURL: String = ""
                                                let mediaSubURL = url.split(separator: "/")
                                                for index in 0...mediaSubURL.count - 2 {
                                                    avFileURL = avFileURL + String(mediaSubURL[index]) + "/"
                                                }
                                                avFileURL = avFileURL + avFileList
                                                NSLog("avFileURL : \(avFileURL)")
                                                self.musubiNetwork?.httpGet(httpURL: avFileURL)
                                            }
                                        }
                                    }
                                    break
                                }
                                index+=1;
                            }
                        }
                    }
                } else if let mime = mimeType, mime.contains("video") || mime.contains("octectstream"){
                    
                }
//                           } else {
//                               // Store the Content
//
//                           }
//                       }
//                   } else {
//
//                   }
                   db.close()
               }
           }
        }
        else {
            NSLog("Offline Store Network Error")
        }
    }
}
