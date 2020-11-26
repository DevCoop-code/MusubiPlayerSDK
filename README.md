# MusubiPlayerSDK
MusubiPlayerSDK is an iOS application level media player.
It uses AVFoundation for playing audio and video both locally and over the Internet. MusubiPlayer can support easily implementing video player in your iOS Application.

# Install MusubiPlayer
MusubiPlayer is available through use Cocoapods
To install it, simply add the following line to your Podfile
```
pod 'MusubiPlayer', '~> 0.1'
```

# Demo
<img src="https://raw.githubusercontent.com/hankyojeong/MusubiPlayerSDK/master/images/demo1.png" width="50%" height="50%">

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

- Play Video with External Subtitle
  - MusubiVideo Player Support SMI, SRT Subtitles
    - SubtitleType(1): Subtitle over HTTP Network
    - SubtitleType(2): Local Subtitle
```
player?.open(mediaURL, mediaType: .hls)
player?.setExternalSubtitle("/[subtitleName].smi", SubtitleType(2))
player?.start()
```

# Documentation
The [release notes](RELEASENOTES.md) document

# Author
HanKyo Jeong, hankyo.dev@gmail.com