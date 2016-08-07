//
//  PlayAudio.swift
//  Linc's Voice Changer
//
//  Created by Jeffrey Limauro on 8/7/16.
//  Copyright © 2016 LimauroDev. All rights reserved.
//

import Foundation
import AVFoundation

public class PlayAudio: NSObject, AVAudioPlayerDelegate {
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    public var audioPlayer: AVAudioPlayer!
    var audioSession: AVAudioSession!
    var helper: HelperFunctions = HelperFunctions()
    var isPlaying: Bool = false
    
    init(audioSession: AVAudioSession) {
        self.audioSession = audioSession
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
            print("playing audio")
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

    public func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        audioPlayerNodeFinished()
    }
}
