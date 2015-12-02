//
//  Shape.swift
//  algorhythm
//
//  Created by Xu, Cheng on 11/20/15.
//  Copyright © 2015 sansserif. All rights reserved.
//

import Foundation
import AVFoundation

class Shape: NSObject, AVAudioPlayerDelegate{
    //http://makeapppie.com/2014/08/04/the-swift-swift-tutorial-why-do-we-need-delegates
    
    var timeArray = [AVAudioPlayer?](count:16, repeatedValue: nil)
    
//    var littlIcon : UIimage
//    
    override init (){
        super.init()
   
    }
    
    
    
    func play(index: Int){
        //check each of the slot in ticSlots and play the audio, if occupied, play the sound.
        if ( self.timeArray[index] != nil) {
            self.timeArray[index]?.play()
        }
        
    }
    
    
    //load the audio files given the file names
    func prepareAVAudioPlayer(fileName: String, fileType: String) -> AVAudioPlayer {
        let path = NSBundle.mainBundle().pathForResource(fileName, ofType: fileType)
        let fileURL = NSURL.fileURLWithPath(path!)
        let tempPlayer = try! AVAudioPlayer(contentsOfURL: fileURL)
        tempPlayer.delegate = self
        tempPlayer.prepareToPlay()
        return tempPlayer
    }
    
    
    
    
}