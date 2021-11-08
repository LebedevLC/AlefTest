//
//  ChildrenTableViewCell.swift
//  AlefTest
//
//  Created by Сергей Чумовских  on 08.11.2021.
//

import UIKit

class ChildrenTableViewCell: UITableViewCell, UITextFieldDelegate {

    static let identifier = "ChildrenTableViewCell"
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var deleteButton: UIButton!
    
    var deleteButtonTapped: (() -> Void)?
    var endEditingName: (() -> Void)?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        nameTextField.delegate = self
        ageTextField.delegate = self
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        nameTextField.text = nil
        ageTextField.text = nil
    }
    
    @IBAction func deleteButtonTap(_ sender: Any) {
        self.deleteButtonTapped?()
    }
    
    func configure(model: MyChildrenModel?) {
        nameTextField.text = model?.name ?? ""
        guard let age = model?.age else {return}
        ageTextField.text = "\(age)"
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        self.endEditingName?()
    }
    
}
