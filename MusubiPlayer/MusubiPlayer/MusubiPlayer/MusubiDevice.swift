//
//  MusubiDevice.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/21.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

open class MusubiDevice: NSObject {
    var filemgr: FileManager?
    var musubiProtocol: MusubiMediaProtocol?
    
    public override init() {
        filemgr = FileManager.default
        musubiProtocol = MusubiMediaProtocol()
    }
}

class MusubiDeviceImpl: MusubiDevice {
    override init() {
        NSLog("Initialize MusubiDevice")
        super.init()
        
        let dirPaths = filemgr?.urls(for: .documentDirectory, in: .userDomainMask)
        if let dirPath = dirPaths?[0] {
            let docsURL = dirPath
            let newDir = docsURL.appendingPathComponent("musubi")
            
            do {
                try filemgr?.createDirectory(at: newDir,
                                             withIntermediateDirectories: true,
                                             attributes: nil)
            } catch let error as NSError {
                NSLog("Error: \(error.localizedDescription)")
            }
            
            // Change the Directory Path(Go to 'musubi' directory)
            filemgr?.changeCurrentDirectoryPath(newDir.path)
            NSLog("Check the Current Directory\(filemgr?.currentDirectoryPath)")
        }
    }
}
