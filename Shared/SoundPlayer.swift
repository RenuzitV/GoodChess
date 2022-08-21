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

func playSound(sound: String, numberOfLoops: Int = 0) {
    if let data = NSDataAsset(name: sound) {
        do {
            audioPlayer[sound] = try AVAudioPlayer(data: data.data)
            audioPlayer[sound]??.numberOfLoops = numberOfLoops
            audioPlayer[sound]??.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}

func stopSound(sound: String){
    audioPlayer[sound]??.stop()
}