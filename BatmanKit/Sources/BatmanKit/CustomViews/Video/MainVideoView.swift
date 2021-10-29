//
//  DisplayVIdeo.swift
//  WhatsWebScan
//
//  Created by   Валерий Мельников on 20.10.2021.
//

import UIKit
import AVKit

class MainVideoView: UIView {
    
    enum fileType : String {
        case mp4 = "mp4"
    }
    
    @IBOutlet var contentDisplay: UIView!
    
    private var playerObjectV = AVPlayer()
    private var layerObjectV = AVPlayerLayer()
    
    enum deviceType {
        case iPad
        case iPhone
    }
    
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        setParamUI()
   }
   
   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       setParamUI()
   }
   
    private func setParamUI() {
        Bundle.main.loadNibNamed("MainVideoView", owner: self, options: nil)
        if UIDevice.current.userInterfaceIdiom == .phone {
            prepareVideoPlayer(deviceSupport: .iPhone)
        }else {
            prepareVideoPlayer(deviceSupport: .iPad)
        }
       
        contentDisplay.fixInView(self)
    }
    
    
    fileprivate func prepareVideoPlayer(deviceSupport : deviceType){
        playerObjectV = AVPlayer()
        layerObjectV = AVPlayerLayer(player: playerObjectV)
        layerObjectV.frame = contentDisplay.bounds
        switch deviceSupport {
        case .iPad:
            layerObjectV.videoGravity = .resizeAspectFill
        case .iPhone:
           layerObjectV.videoGravity = .resize
        }
        contentDisplay.layer.addSublayer(layerObjectV)
    }
    
    open func setVideo(name : String, type : fileType){
        if   let path = Bundle.main.path(forResource: name, ofType: type.rawValue ) {
            let fileURL = URL.init(fileURLWithPath: path)
            let item = AVPlayerItem(url: fileURL)
            playerObjectV.replaceCurrentItem(with: item)
            playerObjectV.seek(to: .zero)
            NotificationCenter.default.addObserver(self, selector: #selector(finish), name: .AVPlayerItemDidPlayToEndTime, object: playerObjectV.currentItem)
            playerObjectV.play()
        }
    }
    
    open func restart(){
        playerObjectV.seek(to: .zero)
        playerObjectV.play()
    }
    
    open func stop(){
        playerObjectV.pause()
    }
    
    @objc func finish() {
        playerObjectV.seek(to: .zero)
        playerObjectV.play()
    }
}
