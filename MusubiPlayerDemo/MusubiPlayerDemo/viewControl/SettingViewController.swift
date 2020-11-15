//
//  SettingViewController.swift
//  MusubiPlayerDemo
//
//  Created by HanGyo Jeong on 2020/11/15.
//  Copyright © 2020 HanGyoJeong. All rights reserved.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var settingTableView: UITableView!
    
    var settingArray = [modeCellStruct]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        settingTableView.rowHeight = 80
        settingTableView.delegate = self
        settingTableView.dataSource = self
        
        let modeCell: modeCellStruct = modeCellStruct(title: "Use Musubi Player")
        settingArray.append(modeCell)
    }
}

extension SettingViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = settingTableView.dequeueReusableCell(withIdentifier: "playModeSwitchCell", for: indexPath) as! switchCell
        
        let row = indexPath.row
        cell.modeName.text = settingArray[row].title
        
        return cell
    }
}
