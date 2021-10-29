//
//  SubsButton.swift
//  WhatsWebScan
//
//  Created by   Валерий Мельников on 19.10.2021.
//

import UIKit
import SwiftyGif
protocol GifButtonDelegate : AnyObject {
    func userTapButton()
}

class GifButton: UIView {
    
    @IBOutlet weak var imgBtn: UIImageView!
    @IBOutlet weak var titleBtn: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet var contentBtn: UIView!
    weak var delegate : GifButtonDelegate?
    
    
    override init(frame: CGRect) {
       super.init(frame: frame)
        setUI()
   }
   
   required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
       setUI()
   }
   
    private func setUI() {
        Bundle.main.loadNibNamed("GifButton", owner: self, options: nil)
        titleBtn.textColor = .white
        titleBtn.textAlignment = .center
        titleBtn.numberOfLines = 0
        titleBtn.font = .systemFont(ofSize: 20)
        contentBtn.fixInView(self)
    }
    
    open func setText(text : String) {
        titleBtn.text = text
    }
    
    open func setGif(name : String){
        do {
            let gif = try UIImage(gifName: name)
            imgBtn.setGifImage(gif)
        }catch let errror {
            print(errror.localizedDescription)
        }
    }
    
    @IBAction func actionUserTap(_ sender: Any) {
        delegate?.userTapButton()
    }
    
}
