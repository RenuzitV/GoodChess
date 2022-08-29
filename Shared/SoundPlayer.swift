//
//  SoundPlayer.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation
import AVFoundation
import AVFAudio
import SwiftUI

var audioPlayer: [String:AVAudioPlayer?] = [:]

func playSound(sound: String, numberOfLoops: Int = 0, atTime: Double = 0) {
    if let data = NSDataAsset(name: sound) {
        do {
            audioPlayer[sound] = try AVAudioPlayer(data: data.data)
            audioPlayer[sound]??.numberOfLoops = numberOfLoops
            audioPlayer[sound]??.currentTime = atTime
            audioPlayer[sound]??.play()            
        } catch {
            print(error.localizedDescription)
        }
    }
}

func stopSound(sound: String){
    audioPlayer[sound]??.stop()
}

func pauseSound(sound: String){
    audioPlayer[sound]??.pause()
}

func isPlaying(sound: String) -> Bool{
    return audioPlayer[sound]??.isPlaying ?? false
}
