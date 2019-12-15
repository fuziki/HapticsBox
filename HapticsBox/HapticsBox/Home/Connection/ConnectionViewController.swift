//
//  ConnectionViewController.swift
//  HapticsBox
//
//  Created by fuziki on 2019/12/15.
//  Copyright © 2019 fuziki.factory. All rights reserved.
//

import Foundation
import UIKit

class ConnectionViewController: UIViewController {
    
    @IBOutlet weak var urlField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(recognizer)
    }
    
    private func connectWs(url: URL) {
        
    }
    
    
    
    
    @IBAction func connect(_ sender: Any) {
        urlField.endEditing(true)
        utlTextInput(self)
    }

    @IBAction func utlTextInput(_ sender: Any) {
        if let text = urlField.text, let url = URL(string: text) {
            connectWs(url: url)
        }
    }
    
    @objc func tapped() {
        urlField.resignFirstResponder()
    }
}
