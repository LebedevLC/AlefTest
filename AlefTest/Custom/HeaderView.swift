//
//  HeaderView.swift
//  AlefTest
//
//  Created by Сергей Чумовских  on 08.11.2021.
//

import Foundation
import UIKit

class HeaderView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 8
    }
}
