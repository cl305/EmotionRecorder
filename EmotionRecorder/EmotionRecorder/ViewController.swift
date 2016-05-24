//
//  ViewController.swift
//  EmotionRecorder
//
//  Created by Cody Li on 5/24/16.
//  Copyright © 2016 Cody Li. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation

class ViewController: UIViewController {
    
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        var fileURL = NSURL(fileURLWithPath: "/Users/codyli/Documents/Summer 2016 Internship/EmotionRecorder/EmotionRecorder/EmotionRecorder/Assets.xcassets/video.dataset/video.mp4")
        playerView = AVPlayer(URL: fileURL)
        playerViewController.player = playerView
        self.presentViewController(playerViewController, animated: true){
            self.playerViewController.player?.play()
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
