//
//  ViewController.swift
//  AlisasAdventskalender
//
//  Created by Steffen Gundermann on 27.11.19.
//  Copyright © 2019 Gundev. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseAuth
import AVFoundation

class ViewController: UIViewController {
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var openButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    var player: AVAudioPlayer?
    
    @IBAction func open(_ sender: Any) {
        getImage()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Auth.auth().signIn(withEmail: "steffengundermann95@web.de", password: "test1234"){
            [weak self] authResult, error in
            guard let strongSelf = self else { return }
        }
        openButton.isHidden = false
        dayLabel.text = getDay()
    }
    
    func getDay() -> String {
        let date = Date()
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        let stringDate = "\(day).\(month).\(year)"
        return stringDate
    }
    
    func getImage(){
        let storage = Storage.storage()
        let dayString = getDay()
        let pathReference = storage.reference(withPath: "AlisasAdventskalender/\(dayString).png")
        
        pathReference.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            // Uh-oh, an error occurred!
            print(error)
          } else {
            // Data for "images/island.jpg" is returned
            let image = UIImage(data: data!)
            self.imageView.image = image
            self.openButton.isHidden = true
            self.playSound()
          }
        }
    }
    
    func playSound(){
        guard let url = Bundle.main.url(forResource: "bells", withExtension: "wav") else { return }

        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)

            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)

            guard let player = player else { return }

            player.play()

        } catch let error {
            print(error.localizedDescription)
        }
    }


}

