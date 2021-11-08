//
//  DefaultButton.swift
//  AlefTest
//
//  Created by Сергей Чумовских  on 08.11.2021.
//

import Foundation
import UIKit

class DefaultButton: UIButton {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.layer.cornerRadius = 20
        self.layer.borderWidth = 2
    }
}
