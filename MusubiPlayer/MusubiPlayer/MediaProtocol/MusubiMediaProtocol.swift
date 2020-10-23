//
//  MusubiMediaProtocol.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/22.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import Foundation

class MusubiMediaProtocol: NSObject {
    func checkNeedToRequestMoreContent(manifest: String) -> [String]? {
           
        let manifestArr = Array(manifest)
        NSLog("manifest : \(manifestArr[0]), \(manifestArr[1]), \(manifestArr[2]), \(manifestArr[3]), \(manifestArr[4])")
        return nil
    }
}
