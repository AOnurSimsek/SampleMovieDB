//
//  TopNavBar.swift
//  MovieDB
//
//  Created by Abdullah Onur Şimşek on 25.05.2022.
//

import Foundation
import UIKit


@IBDesignable
class TopNavBar: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    var goBackAction:(()->Void)?

    override init(frame: CGRect) {
        super.init(frame: frame)
        ownFirstNib()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        ownFirstNib()
    }
    
    func setTitle(title: String){
        titleLabel.text = title
    }
    
    @IBAction func actButtonBack(_ sender: Any) {
        if let action = goBackAction {
            action()
        }
    }

    
}
