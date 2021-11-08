//
//  ViewController.swift
//  AlefTest
//
//  Created by Сергей Чумовских  on 08.11.2021.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var visibleView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var ageTextField: UITextField!
    @IBOutlet weak var addChildrenButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    private var tapGesture: UITapGestureRecognizer?
    
    private var myChildren: [MyChildrenModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setMyTap()
        setupTable()
        setupButtons()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWasShown),
                                               name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillBeHidden(notification:)),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    
    // MARK: - Buttons
    
    @IBAction func addChildrenButtonTap(_ sender: Any) {
        guard myChildren.count < 5 else { return }
        myChildren.append(.init(name: nil, age: nil))
        tableView.insertRows(at: [IndexPath(row: myChildren.count-1, section: 0)], with: .automatic)
        setupAddButton()
    }
    
    @IBAction func clearButtonTap(_ sender: Any) {
        let optionMenu = UIAlertController(
            title: "Выберите действие",
            message: "Это действие действительно может внести изменения в ваши данные",
            preferredStyle: .actionSheet)
        let deleteAction = UIAlertAction(title: "Сбросить данные", style: .destructive) { _ in
            self.myChildren = []
            self.nameTextField.text = ""
            self.ageTextField.text = ""
            self.setupAddButton()
            self.tableView.reloadData()
        }
        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
        optionMenu.addAction(deleteAction)
        optionMenu.addAction(cancelAction)
        self.present(optionMenu, animated: true, completion: nil)
    }
    
    private func setupAddButton() {
        if myChildren.count < 5 {
            addChildrenButton.isHidden = false
        } else {
            addChildrenButton.isHidden = true
        }
    }
    
    private func setupButtons() {
        addChildrenButton.layer.borderColor = UIColor.link.cgColor
        clearButton.layer.borderColor = UIColor.red.cgColor
    }
}

// MARK: - Keyboard

extension ViewController {
    
    @objc private func keyboardWasShown(notification: Notification) {
        let info = notification.userInfo! as NSDictionary
        let kbSize = (info.value(forKey: UIResponder.keyboardFrameEndUserInfoKey) as! NSValue).cgRectValue.size
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbSize.height, right: 0.0)
        self.tableView?.contentInset = contentInsets
        tableView?.scrollIndicatorInsets = contentInsets
    }
    
    @objc private func keyboardWillBeHidden(notification: Notification) {
        let contentInsets = UIEdgeInsets.zero
        tableView?.contentInset = contentInsets
        tableView?.scrollIndicatorInsets = contentInsets
    }
    
    private func setMyTap() {
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        visibleView.addGestureRecognizer(tapGesture!)
    }
    
    @objc private func hideKeyboard() {
        self.visibleView?.endEditing(true)
    }
}

// MARK: - TableView

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTable() {
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.register(UINib(nibName: ChildrenTableViewCell.identifier, bundle: nil),
                                forCellReuseIdentifier: ChildrenTableViewCell.identifier)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        myChildren.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ChildrenTableViewCell.identifier, for: indexPath) as? ChildrenTableViewCell
        else {
            return UITableViewCell()
        }
        let child = myChildren[indexPath.row]
        cell.configure(model: child)
        
        cell.deleteButtonTapped = { [weak self] in
            self?.myChildren.remove(at: indexPath.row)
            tableView.deleteRows(at: [IndexPath(row: indexPath.row, section: 0)], with: .none)
            self?.setupAddButton()
            tableView.reloadData()
        }
        cell.endEditingName = { [weak self] in
            if let name = cell.nameTextField.text {
                self?.myChildren[indexPath.row].name = name
            }
            if let age = cell.ageTextField.text {
                self?.myChildren[indexPath.row].age = Int(age)
            }
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        // размер двух View с параметрами ввода + отступы
        return 126
    }
}

