//
//  File.swift
//  
//
//  Created by   Валерий Мельников on 29.10.2021.
//

import Foundation
import Foundation
import UIKit
import AVKit

public let imageCacheItems = NSCache<AnyObject, AnyObject>()
public let videoPreviewsCacheItems = NSCache<AnyObject, AnyObject>()

open class VideoPreviewLoader : UIImageView {
    
    let loader = UIActivityIndicatorView(style: .medium)
    
    open func loadImage(from url: String) {
        
        guard let url = URL(string: url) else { return }
        image = nil
        
        addLoader()
        
        if let imageFromCache = imageCacheItems.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            self.image = imageFromCache
            self.removeLoader()
            return
        }
        
        self.getThumbnailImageFromVideoUrl(url: url) { img in
            guard let image = img else { return }
            imageCacheItems.setObject(image, forKey: url.absoluteString as AnyObject)
            
            DispatchQueue.main.async {
                self.isHidden = false
                self.image = img!
                self.loader.stopAnimating()
            }
        }
    }

    open func addLoader()-> Void {
        addSubview(loader)
        loader.translatesAutoresizingMaskIntoConstraints = false
        loader.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        loader.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        loader.startAnimating()
    }
    
    open func removeLoader() -> Void {
        loader.removeFromSuperview()
    }
}

extension VideoPreviewLoader {
   open func getThumbnailImageFromVideoUrl(url: URL, completion: @escaping ((_ image: UIImage?)->Void)) {
        
        if let imageFromCache = videoPreviewsCacheItems.object(forKey: url.absoluteString as AnyObject) as? UIImage {
            completion(imageFromCache)
        }
        liteDispatch.thread(dispatchLevel: .global) {
            let asset = AVAsset(url: url)
            let avAssetImageGenerator = AVAssetImageGenerator(asset: asset)
            avAssetImageGenerator.appliesPreferredTrackTransform = true
            let thumnailTime = CMTimeMake(value: 2, timescale: 1)
            do {
                let cgThumbImage = try avAssetImageGenerator.copyCGImage(at: thumnailTime, actualTime: nil)
                let thumbImage = UIImage(cgImage: cgThumbImage)
                videoPreviewsCacheItems.setObject(thumbImage, forKey: url.absoluteString as AnyObject)
                    liteDispatch.thread {
                        completion(thumbImage)
                    }
                   
                
            } catch {
                print(error.localizedDescription)
                liteDispatch.thread {
                    completion(nil)
                }
            }
        }
    }
}
