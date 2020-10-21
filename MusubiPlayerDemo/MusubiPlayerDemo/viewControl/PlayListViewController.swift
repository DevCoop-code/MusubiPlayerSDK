//
//  ViewController.swift
//  MusubiPlayerDemo
//
//  Created by HanGyo Jeong on 2020/10/09.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit
import MusubiPlayer

class PlayListViewController: UIViewController {
    
    @IBOutlet weak var playlistTableView: UITableView!
    
    var mediaArray = [mediaPlayList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playlistTableView.rowHeight = 80
        
        playlistTableView.delegate = self
        playlistTableView.dataSource = self
        
        // Parsing Media PlayList(format: JSON)
        let mediaJsonFilePath = Bundle.main.path(forResource: "hlsMediaList", ofType: "json")
        if let data = try? String(contentsOfFile: mediaJsonFilePath!).data(using: .utf8) {
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as! [String: Any] {
                if let mediaInfoDic = json["hlsSamples"] as? [[String: String]] {
                    for mediaInfo in mediaInfoDic {
                        let name = mediaInfo["name"]!
                        let uri = mediaInfo["uri"]!
                        let mediaList: mediaPlayList = mediaPlayList(title: name, url: uri)
                        
                        mediaArray.append(mediaList)
                    }
                }
            }
        }
    }

//    override func viewDidAppear(_ animated: Bool) {
//        var musubiPlayerController:MusubiPlayerViewController = MusubiPlayerViewController()
//        musubiPlayerController.mediaURL = "https://bitdash-a.akamaihd.net/content/MI201109210084_1/m3u8s/f08e80da-bf1d-4e3d-8899-f0f6155f6efa.m3u8"
//        self.present(musubiPlayerController, animated: true, completion: nil)
//    }
}

extension PlayListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mediaArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = playlistTableView.dequeueReusableCell(withIdentifier: "mediaPlayListCell", for: indexPath) as! mediaPlaylistCell
        
        let row = indexPath.row
        cell.mediaPlaylistTitle.text = mediaArray[row].title
        cell.mediaPlaylistURL.text = mediaArray[row].url
        
        return cell
    }
    
    
}
