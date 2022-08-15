//
//  SoundPlayer.swift
//  GoodChess
//
//  Created by Duy Nguyen Vu Minh on 15/08/2022.
//

import Foundation
import AVFoundation
import UIKit


var audioPlayer: AVAudioPlayer?

func playSound(sound: String, numberOfLoops: Int = 0) {
    if let data = NSDataAsset(name: sound) {
        do {
            audioPlayer = try AVAudioPlayer(data: data.data)
            audioPlayer?.numberOfLoops = numberOfLoops
            audioPlayer?.play()
        } catch {
            print(error.localizedDescription)
        }
    }
}
