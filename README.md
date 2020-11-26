# MusubiPlayerSDK
MusubiPlayerSDK is an iOS application level media player.
It uses AVFoundation for playing audio and video both locally and over the Internet. MusubiPlayer can support easily implementing video player in your iOS Application.

# Install MusubiPlayer
MusubiPlayer is available through use Cocoapods
To install it, simply add the following line to your Podfile
```
pod 'MusubiPlayer', '~> 0.0'
```

# Usage
Easy to use MusubiPlayer
- HLS
```
var player: MusubiPlayer?

override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    player = MusubiPlayer(videoPreview)
    
    player?.open("[HLS URL]", mediaType: .hls)

    player?.start()
}
```

# Documentation
The [release notes](RELEASENOTES.md) document

# Author
HanKyo Jeong, hankyo.dev@gmail.com