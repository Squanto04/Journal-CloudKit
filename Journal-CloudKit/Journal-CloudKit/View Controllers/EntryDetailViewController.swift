//
//  EntryDetailViewController.swift
//  Journal-CloudKit
//
//  Created by Jordan Lamb on 10/14/19.
//  Copyright © 2019 Squanto Inc. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIViewController {
    
    var entry: Entry? {
        didSet {
            loadViewIfNeeded()
            updateViews()
        }
    }

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var clearTitleButton: UIButton!
    @IBOutlet weak var clearBodyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDesign()
    }
    
    @IBAction func mainViewTapped(_ sender: Any) {
        titleTextField.resignFirstResponder()
        bodyTextView.resignFirstResponder()
    }
    
    @IBAction func clearTitleButtonTapped(_ sender: Any) {
        titleTextField.text = ""
    }
    
    @IBAction func clearBodyButtonTapped(_ sender: Any) {
        bodyTextView.text = ""
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let title = titleTextField.text,
            let bodyText = bodyTextView.text,
            !title.isEmpty,
            !bodyText.isEmpty
            else { return }

            EntryController.shared.addEntryWith(title: title, body: bodyText) { (success) in
                if success {
                    print("Entry Added")
                    self.navigationController?.popViewController(animated: true)
                } else {
                    print("Error Adding Entry")
                }
            }
    }
    
    // MARK: - Helper Functions
    func updateViews() {
        guard let entry = entry else { return }
        titleTextField.text = entry.title
        bodyTextView.text = entry.bodyText
    }
    
    func updateDesign() {
        clearTitleButton.layer.cornerRadius = 5
        clearBodyButton.layer.cornerRadius = 5
        bodyTextView.layer.borderWidth = 1
        bodyTextView.layer.borderColor = UIColor.lightGray.cgColor
        bodyTextView.layer.cornerRadius = 5
        titleTextField.layer.borderColor = UIColor.lightGray.cgColor
        titleTextField.layer.borderWidth = 0.5
        titleTextField.layer.cornerRadius = 5
    }

}

extension EntryDetailViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        titleTextField.resignFirstResponder()
        
        return true
    }
}
