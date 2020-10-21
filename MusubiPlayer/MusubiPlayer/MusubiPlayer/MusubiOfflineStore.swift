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
    
    public init(_ willStoreURI: String?) {
        self.streamingURI = willStoreURI
        
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
                        // Making Directory for Stored the playlist
                    })
                    
                    // Execute the Connection to Media Server
                    task.resume()
                }
            }
        }
    }
}
