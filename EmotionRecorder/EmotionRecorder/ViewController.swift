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
import MessageUI

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, AVCaptureFileOutputRecordingDelegate, MFMailComposeViewControllerDelegate{
    
    var playerViewController = AVPlayerViewController()
    var playerView = AVPlayer()
    var tele : Telemetry?
    
    var captureSession : AVCaptureSession?
    var stillImageOutput : AVCaptureStillImageOutput?
    var previewLayer : AVCaptureVideoPreviewLayer?
    let videoFileOutput = AVCaptureMovieFileOutput()
    @IBOutlet weak var cameraView: UIView!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
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
        beginSession(captureDevice!)
    }
    
    func beginSession(captureDevice : AVCaptureDevice){
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
    
    @IBAction func recordVideo(sender: AnyObject) {
        //Starting recording data
        tele = Telemetry()
        
        var recordingDelegate : AVCaptureFileOutputRecordingDelegate? = self
        self.captureSession!.addOutput(videoFileOutput)
        
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        let filePath = documentsURL.URLByAppendingPathComponent("recording.mp4")
        videoFileOutput.startRecordingToOutputFileURL(filePath, recordingDelegate: recordingDelegate)
    }
    
    @IBAction func stopVideo(sender: AnyObject) {
        self.videoFileOutput.stopRecording()
        sendMail()
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didStartRecordingToOutputFileAtURL fileURL: NSURL!, fromConnections connections: [AnyObject]!) {
        return
    }
    
    func captureOutput(captureOutput: AVCaptureFileOutput!, didFinishRecordingToOutputFileAtURL outputFileURL: NSURL!, fromConnections connections: [AnyObject]!, error: NSError!) {
        return
    }
    
    func sendMail(){
        if (MFMailComposeViewController.canSendMail()){
            print("passed this check")
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setSubject("CSV File")
            mailComposer.setMessageBody("body text", isHTML: false)
            var data = tele!.dataString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
            if let content = data{
                print("NSData : \(content)")
            }
            
            mailComposer.addAttachmentData(data!, mimeType: "text/csv", fileName: "Telemetry.csv")
            self.presentViewController(mailComposer, animated: true, completion: nil)
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
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
    
    @IBAction func playVideo(sender: AnyObject) {
        let fileURL = NSBundle.mainBundle().pathForResource("video", ofType:"mp4")
        playerView = AVPlayer(URL: NSURL(fileURLWithPath: fileURL!))
        playerViewController.player = playerView
        self.presentViewController(playerViewController, animated: true){
            self.playerViewController.player?.play()
        }

    }
  
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
