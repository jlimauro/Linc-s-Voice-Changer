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
    @IBOutlet weak var scroller: HorizontalScroller!
    
    // MARK: Properties
    var audioAPI: LibraryAPI!
    private var allSoundOptions = [SoundOption]()
    private var currentOptionIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.translucent = false
        
        audioAPI = LibraryAPI.sharedInstance
        
        scroller.delegate = self
        reloadScroller()
    }
    
    // Imaged Tapped
    func playSelectedOption(soundOptionIndex: Int) {
        
        if (soundOptionIndex < allSoundOptions.count && soundOptionIndex > -1) {
            
            let soundOption = allSoundOptions[soundOptionIndex]
            
            if let rate = soundOption.speedRate {
                audioAPI.play(rate)
                print("playing tapped rate: \(rate)")
            }
        }
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

  func reloadScroller() {
    allSoundOptions = LibraryAPI.sharedInstance.getSoundOptions()
    
    if currentOptionIndex < 0 {
        currentOptionIndex = 0
    } else if currentOptionIndex >= allSoundOptions.count {
        currentOptionIndex = allSoundOptions.count - 1
    }
    scroller.reload()
}

func initialViewIndex(scroller: HorizontalScroller) -> Int {
    return currentOptionIndex
    }
}

extension ViewController: HorizontalScrollerDelegate {
    
    func horizontalScrollerClickedViewAtIndex(scroller: HorizontalScroller, index: Int) {
        
        let previousSoundOptionView = scroller.viewAtIndex(currentOptionIndex) as! SoundOptionView
        previousSoundOptionView.highlightAlbum(false)
        
        currentOptionIndex = index
        
        let soundOptionView = scroller.viewAtIndex(index) as! SoundOptionView
        soundOptionView.highlightAlbum(true)
        
        playSelectedOption(index)
    }
    
    func numberOfViewsForHorizontalScroller(scroller: HorizontalScroller) -> (Int) {
        return allSoundOptions.count
    }
    
    func horizontalScrollerViewAtIndex(scroller: HorizontalScroller, index: Int) -> (UIView) {
        let soundOption = allSoundOptions[index]
        let soundOptionView = SoundOptionView(frame: CGRect(x: 0, y: 0, width: 100, height: 100), imagePath: soundOption.imagePath)
        if currentOptionIndex == index {
            soundOptionView.highlightAlbum(true)
        } else {
            soundOptionView.highlightAlbum(false)
        }
        return soundOptionView
    }
}

