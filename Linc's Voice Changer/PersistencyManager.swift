//
//  PersistencyManager.swift
//  Linc's Voice Changer
//
//  Created by Jeffrey Limauro on 8/10/16.
//  Copyright © 2016 LimauroDev. All rights reserved.
//

import Foundation
import UIKit

class PersistencyManager: NSObject {
    
    private var soundOptions = [SoundOption]()
    
    override init() {
        super.init()
        if let data = NSData(contentsOfFile: NSHomeDirectory().stringByAppendingString("/Documents/SoundOptons.bin")) {
            let unarchiveOption = NSKeyedUnarchiver.unarchiveObjectWithData(data) as! [SoundOption]?
            if let unwrappedOption = unarchiveOption{
                soundOptions = unwrappedOption
            }
        } else {
            createPlaceholderOptions()
        }
    }

    func createPlaceholderOptions() {
        
        let soundOption1 = SoundOption(name: "Slow",
                                 speedRate: 0.5,
                                 pitchRate: nil,
                                 imagePath: "snail.png")
        
        let soundOption2 = SoundOption(name: "Fast",
                                       speedRate: 2,
                                       pitchRate: nil,
                                       imagePath: "rabbit.png")
        
        soundOptions = [soundOption1, soundOption2]
        saveSoundOptions()
    }
    
    func getSoundOptions() -> [SoundOption] {
        return soundOptions
    }
    
    func addSoundOption(soundOption: SoundOption, index: Int) {
    if (soundOptions.count >= index) {
    soundOptions.insert(soundOption, atIndex: index)
    } else {
    soundOptions.append(soundOption)
    }
    }
    
    func deleteSoundOptionAtIndex(index: Int) {
        soundOptions.removeAtIndex(index)
    }
    
    func saveImage(image: UIImage, filename: String) {
        let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
        let data = UIImagePNGRepresentation(image)
        data?.writeToFile(path, atomically: true)
    }
    
    func getImage(filename: String) -> UIImage? {
        var data: NSData?
        do {
            let path = NSHomeDirectory().stringByAppendingString("/Documents/\(filename)")
            data = try NSData(contentsOfFile: path, options: .DataReadingUncached)
        } catch let error as NSError {
            print(error.localizedDescription)
            return nil
        }
        
        if data == nil {
            return nil
        } else {
            return UIImage(data: data!)
        }
    }
    
    func loadImage(fileName: String) -> UIImage? {
        return UIImage(named: fileName)
    }
    
    func saveSoundOptions() {
        let filename = NSHomeDirectory().stringByAppendingString("/Documents/SoundOptons.bin")
        let data = NSKeyedArchiver.archivedDataWithRootObject(soundOptions)
        data.writeToFile(filename, atomically: true)
    }
}