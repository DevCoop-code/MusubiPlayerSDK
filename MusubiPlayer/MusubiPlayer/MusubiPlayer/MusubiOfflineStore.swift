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
    
    public init(_ willStoreURI: String?) {
        self.streamingURI = willStoreURI
    }
}
