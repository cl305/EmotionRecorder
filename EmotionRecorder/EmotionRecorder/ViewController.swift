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

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    
    @IBOutlet weak var cameraView: UIView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSessionPreset1280x720
        
        let videoDevices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        var captureDevice : AVCaptureDevice?
        
        for device in videoDevices{
            let device = device as! AVCaptureDevice
            if device.position == AVCaptureDevicePosition.Front{
                captureDevice = device
                break
            }
        }
        
        var error : NSError?
        var input : AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device : captureDevice)
        }
        catch let error1 as NSError {
            error = error1
            input = nil
        }
        
        if (error == nil && captureSession?.canAddInput(input) != nil){
            captureSession?.addInput(input)
            stillImageOutput = AVCaptureStillImageOutput()
            stillImageOutput?.outputSettings = [AVVideoCodecKey : AVVideoCodecJPEG]
            
            if(captureSession?.canAddOutput(stillImageOutput) != nil){
                captureSession?.addOutput(stillImageOutput)
                previewLayer = AVCaptureVideoPreviewLayer(session : captureSession)
                previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
                previewLayer?.connection.videoOrientation = AVCaptureVideoOrientation.Portrait
                cameraView.layer.addSublayer(previewLayer!)
                captureSession?.startRunning()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidLoad()
        previewLayer?.frame = cameraView.bounds
    }
    
    //Properties
    @IBOutlet weak var watchVideoButton: UIButton!
    @IBOutlet weak var recordVideoButton: UIButton!
    //
    
    @IBAction func playVideo(sender: AnyObject) {
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
