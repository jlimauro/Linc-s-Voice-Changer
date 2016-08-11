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
    private var persistencyManager: PersistencyManager
    
    override init() {
       
        self.aRecorder = RecordAudio()
        self.pAudio = PlayAudio()
        self.helper = HelperFunctions()
        self.persistencyManager = PersistencyManager()
        super.init()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(LibraryAPI.loadImage(_:)), name: "LVCLoadImageNotification", object: nil)
    }
    
    func loadImage(notification: NSNotification) {
        
        let userInfo = notification.userInfo as! [String: AnyObject]
        let imageView = userInfo["imageView"] as! UIImageView?
        let imageName = userInfo["imageName"] as! String
        
        
        if let imageViewUnWrapped = imageView {
            imageViewUnWrapped.image = persistencyManager.loadImage(imageName)
        }
    }

    // MARK: Data Storage
    func getSoundOptions() -> [SoundOption] {
        return persistencyManager.getSoundOptions()
    }
    
    func addSoundOption(soundOption: SoundOption, index: Int) {
        persistencyManager.addSoundOption(soundOption, index: index)
        // add to cloud
    }
    
    func deleteAlbum(index: Int) {
        persistencyManager.deleteSoundOptionAtIndex(index)
       // delete on cloud
    }
    
    func saveSoundOptions() {
        persistencyManager.saveSoundOptions()
    }
    
    // MARK: Helper Functions
    
    func getFileSavePath() -> NSURL?  {
        return helper.directoryURL()
    }
    
    // MARK: Audio
    
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
