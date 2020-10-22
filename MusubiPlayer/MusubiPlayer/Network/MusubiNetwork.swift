//
//  MusubiNetwork.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/22.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

class MusubiNetwork: NSObject {
    
    var networkCallback: MusubiNetworkCallback?
    
    func httpGet(httpURL: String) {
        let url = URL(string: httpURL)
        
        if let httpPath = url {
            let task = URLSession.shared.dataTask(with: httpPath, completionHandler: {
                (data, response, error) -> Void in
                guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                    self.networkCallback?.httpGetResult(url: httpURL, httpStatusCode: (response as? HTTPURLResponse)?.statusCode ?? 0, httpGetResult: nil)
                    return
                }
                
                // Success ttoo connection to Server
                guard let mediaPlayList = String(data: data!, encoding: .utf8) else {
                    return
                }
                self.networkCallback?.httpGetResult(url: httpURL, httpStatusCode: 200, httpGetResult: mediaPlayList)
            })
            
            // Execute the connection to server
            task.resume()
        }
    }
}
