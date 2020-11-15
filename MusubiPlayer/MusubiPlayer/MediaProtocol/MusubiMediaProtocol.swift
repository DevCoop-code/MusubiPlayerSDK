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
        var playListType: hlsPlayListType = .none
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
                        playListType = .master
//                        return .master
                    }
                    // PLAYLIST-TYPE
                    else if manifestArr[index] == "P" && manifestArr[index + 1] == "L" && manifestArr[index + 2] == "A" &&
                        manifestArr[index + 3] == "Y" && manifestArr[index + 4] == "L" && manifestArr[index + 5] == "I" &&
                        manifestArr[index + 6] == "S" && manifestArr[index + 7] == "T" {
                        index += 8
                        index += 5 // Skip '-TYPE'
                        // Try to find ':'
                        while !(manifestArr[index] == ":") {
                            index += 1
                        }
                        index += 1
                        
                        NSLog("hankyo: \(manifestArr[index]), \(manifestArr[index + 1]), \(manifestArr[index + 2]),")
                        
                        // VOD
                        if manifestArr[index] == "V" && manifestArr[index + 1] == "O" && manifestArr[index + 2] == "D" {
                            playListType = .vod
//                            return .vod
                        }
                    }
                } else {
                    index += 1
                }
            }
        }
        else {
            NSLog("File is not HLS PlayList")
            return .none
        }
        return playListType
    }
    
    func parsingMasterPlayList(manifest: String) -> [String]? {
        var subManifests: [String]? = []
        let manifestArr = Array(manifest)
        if manifestArr[0] == "#" && manifestArr[1] == "E" && manifestArr[2] == "X" && manifestArr[3] == "T" && manifestArr[4] == "M" && manifestArr[5] == "3" && manifestArr[6] == "U" {
            
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
                        subManifests?.append(playListURL)
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
            return nil
        }
        return subManifests
    }
    
    func parsingVODPlayList(manifest: String) -> [String]? {
        var avFiles: [String]? = []
        let manifestArr = Array(manifest)
        if manifestArr[0] == "#" && manifestArr[1] == "E" && manifestArr[2] == "X" && manifestArr[3] == "T" && manifestArr[4] == "M" && manifestArr[5] == "3" && manifestArr[6] == "U" {
            
            var index: Int = 7
            while index < manifest.count - 1 {
                // #EXTINF
                if manifestArr[index] == "#" && manifestArr[index + 1] == "E" && manifestArr[index + 2] == "X" &&
                    manifestArr[index + 3] == "T" && manifestArr[index + 4] == "I" && manifestArr[index + 5] == "N" && manifestArr[index + 6] == "F"{
                    index += 7
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
                    NSLog("hankyo media url: \(mediaURL)")
                    avFiles?.append(mediaURL)
                }
                else {
                    index += 1
                }
            }
        }
        else {
            NSLog("File is not HLS PlayList")
        }
        return avFiles
    }
}
