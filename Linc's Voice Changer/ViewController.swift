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
    var aRecorder: RecordAudio!
    var pAudio: PlayAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        aRecorder = RecordAudio()
        pAudio = PlayAudio(audioSession: aRecorder.audioSession)
    }

    // MARK: Button Events
    
    @IBAction func recordVoice(sender: AnyObject) {
        recordTapped()
    }
    
    @IBAction func PlayPauseVoice(sender: AnyObject) {
        
        if pAudio.isPlaying {
            if (pAudio.audioPlayer != nil)
            {
                pAudio.audioPlayer.pause()
            }
            print("paused")
        }
        else {
            print("play normal")
            pAudio.playAudio(1)
        }
    }
    
    @IBAction func SlowVoice(sender: AnyObject) {
        print("play slow")
        pAudio.playAudio(0.5)
        //pAudio.playAudioWithVariablePitch(1000)
    }
    
    @IBAction func FastVoice(sender: AnyObject) {
        print("play fast")
         pAudio.playAudio(2)
        //pAudio.playAudioWithVariablePitch(-1000)
    }
    
    func recordTapped() {
        if !aRecorder.audioRecorder.recording {
            aRecorder.startRecording()
            changeRecordButtonImage("stop.png")
        } else {
            aRecorder.finishRecording(success: true)
            changeRecordButtonImage("record.png")
        }
    }
    
    func changeRecordButtonImage(imageName: String) {
        let image = UIImage(named: imageName) as UIImage!
        self.btRecord.setImage(image, forState: .Normal)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}