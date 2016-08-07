//
//  ViewController.swift
//  Linc's Voice Changer
//
//  Created by Jeffrey Limauro on 8/6/16.
//  Copyright © 2016 LimauroDev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // MARK: Controls
    
    @IBOutlet weak var btSlow: UIButton!
    @IBOutlet weak var btFast: UIButton!
    @IBOutlet weak var btRecord: UIButton!
    @IBOutlet weak var btPlay: UIButton!
    
    // MARK: Properties
    var audioAPI: LibraryAPI!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioAPI = LibraryAPI.sharedInstance
    }

    // MARK: Button Events
    
    @IBAction func recordVoice(sender: AnyObject) {
        recordTapped()
    }
    
    @IBAction func PlayPauseVoice(sender: AnyObject) {
        
        if audioAPI.IsPlaying() {
            audioAPI.pausePlaying()
            print("paused")
        }
        else {
            print("play normal")
            audioAPI.play()
        }
    }
    
    @IBAction func SlowVoice(sender: AnyObject) {
        print("play slow")
        audioAPI.play(0.5)
        //audioAPI.playAudioWithVariablePitch(1000)
    }
    
    @IBAction func FastVoice(sender: AnyObject) {
        print("play fast")
         audioAPI.play(2)
        //audioAPI.pAudio.playAudioWithVariablePitch(-1000)
    }
    
    func recordTapped() {
        if !audioAPI.IsRecording() {
            audioAPI.startRecording()            
            changeRecordButtonImage("stop.png")
        } else {
            audioAPI.finishedRecording()
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