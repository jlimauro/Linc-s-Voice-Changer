//
//  LibraryAPI.swift
//  Linc's Voice Changer
//
//  Created by Jeffrey Limauro on 8/7/16.
//  Copyright © 2016 LimauroDev. All rights reserved.
//

import UIKit

class LibraryAPI: NSObject {
    
    class var sharedInstance: LibraryAPI {
        
        struct Singleton {
            static let instance = LibraryAPI()
        }
        
        return Singleton.instance
    }
    
    private var aRecorder: RecordAudio
    private var pAudio: PlayAudio
    private var helper: HelperFunctions
    
    override init() {
       
        self.aRecorder = RecordAudio()
        self.pAudio = PlayAudio()
        self.helper = HelperFunctions()
        
        super.init()
        
    }
    
    func getFileSavePath() -> NSURL?  {
        return helper.directoryURL()
    }
    
    func IsPlaying() -> Bool {
      return  pAudio.IsPlaying()
    }
    
    func pausePlaying() {
        pAudio.pausePlaying()
    }
    
    func play() {
        pAudio.playAudio(1)
    }
    
    func play(rate: Float) {
        pAudio.playAudio(rate)
    }
    
    func playAudioWithVariablePitch(rate: Float) {
        pAudio.playAudioWithVariablePitch(rate)
    }
    
    func IsRecording() -> Bool {
        return aRecorder.IsRecording()
    }
    
    func startRecording() {
        aRecorder.startRecording()
    }
    
    func finishedRecording() {
        aRecorder.finishRecording(success: true)
    }
}
