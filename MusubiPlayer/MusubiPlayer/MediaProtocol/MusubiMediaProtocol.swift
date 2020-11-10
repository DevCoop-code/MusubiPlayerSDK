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
        if manifestArr[0] == "#" && manifestArr[1] == "E" && manifestArr[2] == "X" && manifestArr[3] == "T" && manifestArr[4] == "M" && manifestArr[5] == "3" && manifestArr[6] == "U" {
            NSLog("File is the HLS PlayList")
            
            var index: Int = 7
            while index < manifest.count - 1 {
//                NSLog("\(manifestArr[index])")
                
                if manifestArr[index] == "#" && manifestArr[index + 1] == "E" && manifestArr[index + 2] == "X" && manifestArr[index + 3] == "T" && manifestArr[index + 4] == "-" && manifestArr[index + 5] == "X" {
                    index += 7      // Skip the '-'
                    
                    // STREAM-INF
                    if manifestArr[index] == "S" && manifestArr[index + 1] == "T" && manifestArr[index + 2] == "R" &&
                        manifestArr[index + 3] == "E" && manifestArr[index + 4] == "A" && manifestArr[index + 5] == "M" &&
                        manifestArr[index + 6] == "-" && manifestArr[index + 7] == "I" && manifestArr[index + 8] == "N" &&
                        manifestArr[index + 9] == "F" {
                        index += 10
                        
                        // Skip the Stream Information(Bandwidth, Codec, etc...)
                        while !(manifestArr[index] == "\n") {
                            index += 1
                        }
                        
                        index += 1
                        
                        var playListURL: String = ""
                        // Extract the Sub PlayList
                        while !(manifestArr[index] == "\n") {
//                            NSLog("hankyo sub url: \(manifestArr[index])")
                            playListURL = playListURL + String(manifestArr[index])
                            index += 1
                        }
                        NSLog("hankyo sub url: \(playListURL)")
                        index += 1
                    }
                }
                else {
                    index += 1
                }
            }
            
        }
        else {
            NSLog("File is not HLS PlayList")
        }
        return nil
    }
}
