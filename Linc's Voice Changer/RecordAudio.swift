//
//  RecordAudio.swift
//  Linc's Voice Changer
//
//  Created by Jeffrey Limauro on 8/7/16.
//  Copyright © 2016 LimauroDev. All rights reserved.
//

import Foundation
import AVFoundation

public class RecordAudio: NSObject, AVAudioRecorderDelegate {
    
    public var audioSession: AVAudioSession!
    public var audioRecorder: AVAudioRecorder!
    
    var helper: HelperFunctions = HelperFunctions()
    
    // MARK: Recording settings
    
    let recordSettings = [AVSampleRateKey : NSNumber(float: Float(44100.0)),
                          AVFormatIDKey : NSNumber(int: Int32(kAudioFormatMPEG4AAC)),
                          AVNumberOfChannelsKey : NSNumber(int: 1),
                          AVEncoderAudioQualityKey : NSNumber(int: Int32(AVAudioQuality.Medium.rawValue))]

    override init() {
        
        audioSession = AVAudioSession.sharedInstance()
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord)
            try audioRecorder = AVAudioRecorder(URL: helper.directoryURL()!, settings: recordSettings)
            audioRecorder.prepareToRecord()
        } catch let error as NSError {
            print(error.localizedDescription)
        }
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
    
    public func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            finishRecording(success: false)
        }
    }
}
