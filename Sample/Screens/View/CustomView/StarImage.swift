//
//  StarImage.swift
//  BellTechnical
//
//  Created by Ritu on 2022-09-01.
//

import UIKit

class StarImage: UIImageView {

    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
        self.image = UIImage(named: "star")
        self.contentMode = .scaleAspectFit
        self.layer.masksToBounds = true
        self.clipsToBounds = true
    }

}
