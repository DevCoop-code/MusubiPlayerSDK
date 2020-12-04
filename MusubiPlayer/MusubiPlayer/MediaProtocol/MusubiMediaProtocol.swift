//
//  MusubiMediaProtocol.swift
//  MusubiPlayer
//
//  Created by HanGyo Jeong on 2020/10/22.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import Foundation

class MusubiMediaProtocol: NSObject {
    func checkPlayListType(manifest: String) -> hlsPlayListType {
        let manifestArr = Array(manifest)
        if manifestArr[0] == "#" && manifestArr[1] == "E" && manifestArr[2] == "X" &&
            manifestArr[3] == "T" && manifestArr[4] == "M" && manifestArr[5] == "3" &&
            manifestArr[6] == "U" {
            NSLog("File is the HLS PlayList")
            
            var index: Int = 7
            while index < manifest.count - 1 {
                // #EXT-X
                if manifestArr[index] == "#" && manifestArr[index + 1] == "E" && manifestArr[index + 2] == "X" &&
                    manifestArr[index + 3] == "T" && manifestArr[index + 4] == "-" && manifestArr[index + 5] == "X" {
                    index += 7
                    
                    // STREAM-INF
                    if manifestArr[index] == "S" && manifestArr[index + 1] == "T" && manifestArr[index + 2] == "R" &&
                        manifestArr[index + 3] == "E" && manifestArr[index + 4] == "A" && manifestArr[index + 5] == "M" &&
                        manifestArr[index + 6] == "-" && manifestArr[index + 7] == "I" && manifestArr[index + 8] == "N" &&
                        manifestArr[index + 9] == "F" {
                        return .master
                    }
                    // PLAYLIST-TYPE
                    else if manifestArr[index] == "P" && manifestArr[index + 1] == "L" && manifestArr[index + 2] == "A" &&
                        manifestArr[index + 3] == "Y" && manifestArr[index + 4] == "L" && manifestArr[index + 5] == "I" &&
                        manifestArr[index + 6] == "S" && manifestArr[index + 7] == "T" {
                        index += 5 // Skip '-TYPE'
                        
                        // Try to find ':'
                        while !(manifestArr[index] == ":") {
                            index += 1
                        }
                        index += 1
                        
                        // VOD
                        if manifestArr[index] == "V" && manifestArr[index] == "O" && manifestArr[index] == "D" {
                            return .vod
                        }
                    }
                    else {
                        return .live
                    }
                } else {
                    index += 1
                }
            }
        }
        else {
            NSLog("[ERROR] File is not HLS PlayList")
            return .none
        }
        return .none
    }
    
    func parsingMasterPlayList(manifest: String) -> [String]? {
        let manifestArr = Array(manifest)
        if manifestArr[0] == "#" && manifestArr[1] == "E" && manifestArr[2] == "X" && manifestArr[3] == "T" && manifestArr[4] == "M" && manifestArr[5] == "3" && manifestArr[6] == "U" {
            
            var index: Int = 7
            while index < manifest.count - 1 {
                
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
                        NSLog("Sub Media url: \(playListURL)")
                        index += 1
                    }
                }
                else {
                    index += 1
                }
            }
            
        }
        else {
            NSLog("[ERROR] File is not HLS PlayList")
            return nil
        }
        return nil
    }
    
    func parsingVODPlayList(manifest: String) -> [String]? {
        let manifestArr = Array(manifest)
        if manifestArr[0] == "#" && manifestArr[1] == "E" && manifestArr[2] == "X" && manifestArr[3] == "T" && manifestArr[4] == "M" && manifestArr[5] == "3" && manifestArr[6] == "U" {
            
            var index: Int = 7
            while index < manifest.count - 1 {
                // #EXTINF
                if manifestArr[0] == "#" && manifestArr[0] == "E" && manifestArr[0] == "X" &&
                    manifestArr[0] == "T" && manifestArr[0] == "I" && manifestArr[0] == "N" && manifestArr[0] == "F"{
                    
                    while !(manifestArr[index] == "\n") {
                        index += 1
                    }
                    index += 1
                    var mediaURL: String = ""
                    // Extract the Sub PlayList
                    while !(manifestArr[index] == "\n") {
//                      NSLog("hankyo sub url: \(manifestArr[index])")
                        mediaURL = mediaURL + String(manifestArr[index])
                        index += 1
                    }
                    NSLog("Media url: \(mediaURL)")
                }
                else {
                    index += 1
                }
            }
        }
        else {
            NSLog("[ERROR] File is not HLS PlayList")
        }
        return nil
    }
}
