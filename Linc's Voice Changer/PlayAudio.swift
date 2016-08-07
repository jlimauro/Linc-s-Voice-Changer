//
//  PlayAudio.swift
//  Linc's Voice Changer
//
//  Created by Jeffrey Limauro on 8/7/16.
//  Copyright © 2016 LimauroDev. All rights reserved.
//

import Foundation
import AVFoundation

class PlayAudio: NSObject, AVAudioPlayerDelegate {
    
    private var audioEngine:AVAudioEngine!
    private var audioFile:AVAudioFile!
    private var audioPlayer: AVAudioPlayer!
    private var audioSession: AVAudioSession!
    private var isPlaying: Bool = false
    private var helper: HelperFunctions = HelperFunctions()
    
    init(audioSession: AVAudioSession) {
        self.audioSession = audioSession
        audioEngine = AVAudioEngine()
    }
    
    override init() {
        super.init()
        audioSession = AVAudioSession.sharedInstance()
        audioEngine = AVAudioEngine()
    }
    
    func setAudioPlayer() {
        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: helper.directoryURL()!, fileTypeHint: "m4a")
            audioPlayer.prepareToPlay()
            audioFile = try? AVAudioFile(forReading: helper.directoryURL()!)
        }
        catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func playAudio(rate: Float)
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
            isPlaying = true
            print("started playing audio")
        }
        else {
            isPlaying = false
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
        isPlaying = true
    }
    
    private func audioPlayerNodeFinished()
    {
        print("finished playing audio")
        isPlaying = false
    }
    
    func playingAudioFile() -> Bool
    {
        if isPlaying {
            return true
        } else {
            return false
        }
    }
    
    func pausePlaying() {
        if (audioPlayer != nil)
        {
            audioPlayer.pause()
        }
    }
    
    func IsPlaying() -> Bool {
        return isPlaying
    }

    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayerNodeFinished()
    }
}
