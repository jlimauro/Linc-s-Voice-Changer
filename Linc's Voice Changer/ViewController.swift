//
//  ViewController.swift
//  Linc's Voice Changer
//
//  Created by Jeffrey Limauro on 8/6/16.
//  Copyright © 2016 LimauroDev. All rights reserved.
//

import UIKit
import AVFoundation
import Foundation

class ViewController: UIViewController, AVAudioRecorderDelegate, AVAudioPlayerDelegate {

    // MARK: Controls
    
    @IBOutlet weak var btSlow: UIButton!
    @IBOutlet weak var btFast: UIButton!
    @IBOutlet weak var btRecord: UIButton!
    @IBOutlet weak var btPlay: UIButton!
    
    // MARK: Properties
    
    var audioRecorder: AVAudioRecorder!
    var audioSession: AVAudioSession!
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    var audioPlayer: AVAudioPlayer!
    
    var IsRecording: Bool = false
    var IsPlaying: Bool = false
    
    // MARK: Recording settings
    
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(int: 1),
                          AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        audioSession = AVAudioSession.sharedInstance()
        audioEngine = AVAudioEngine()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: self.directoryURL()!,
                                                settings: recordSettings)
            audioRecorder.prepareToRecord()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }

    // MARK: Button Events
    
    @IBAction func recordVoice(sender: AnyObject) {
        recordTapped()
    }
    
    @IBAction func PlayPauseVoice(sender: AnyObject) {
        
        if IsPlaying {
            if (audioPlayer != nil)
            {
                audioPlayer.pause()
            }
            print("paused")
            IsPlaying = false
        }
        else {
            print("play normal")
            playAudio(1)
            IsPlaying = true
        }
    }
    
    @IBAction func SlowVoice(sender: AnyObject) {
        print("play slow")
        playAudio(0.5)
        //playAudioWithVariablePitch(1000)
    }
    
    @IBAction func FastVoice(sender: AnyObject) {
        print("play fast")
         playAudio(2)
        //playAudioWithVariablePitch(-1000)
    }
    
    
    // MARK: Play Audio
    
    func setAudioPlayer() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: self.directoryURL()!, fileTypeHint: "m4a")
            audioPlayer.prepareToPlay()
            audioFile = try? AVAudioFile(forReading: self.directoryURL()!)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    private func playAudio(rate: Float)
    {
        setAudioPlayer()
        if (audioPlayer != nil) {
        audioPlayer.stop()
        audioEngine.stop()
        audioPlayer.delegate = self
        audioPlayer.enableRate = true
        audioPlayer.currentTime = 0.0
        audioPlayer.rate = rate
        audioPlayer.prepareToPlay()
        audioPlayer.play()
            IsPlaying = true
            print("playing audio")
        }
        else {
            IsPlaying = false
        }
    }
    
    func playAudioWithVariablePitch(pitch: Float)
    {
        setAudioPlayer()
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        let audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        let changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: { self.audioPlayerNodeFinished() })
        
        do {
            try audioEngine.start()
        } catch _ {
        }
        
        audioPlayerNode.play()
        IsPlaying = true
    }

    func audioPlayerNodeFinished()
    {
        IsPlaying = false
        print("finished")
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayerNodeFinished()
    }
    
    
    // MARK: Record Audio
    
    func startRecording() {
        if !audioRecorder.recording {
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setActive(true)
                audioRecorder.record()
            } catch {
            }
        }
        print("recording")
    }
    
    func finishRecording(success success: Bool) {
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setActive(false)
        } catch {
        }
        
        print("stopped recording")
    }
    
    func recordTapped() {
        if !audioRecorder.recording {
            startRecording()
            changeRecordButtonImage("stop.png")
        } else {
            finishRecording(success: true)
            changeRecordButtonImage("record.png")
        }
    }
    
    func changeRecordButtonImage(imageName: String) {
        let image = UIImage(named: imageName) as UIImage!
        self.btRecord.setImage(image, forState: .Normal)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
    
    
    // MARK: Get Folder/File Location
    
    func directoryURL() -> NSURL? {
        let fileManager = NSFileManager.defaultManager()
        let urls = fileManager.URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)
        let documentDirectory = urls[0] as NSURL
        let soundURL = documentDirectory.URLByAppendingPathComponent("sound.m4a")
        return soundURL
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}