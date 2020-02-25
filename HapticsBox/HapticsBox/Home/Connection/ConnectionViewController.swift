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
    @IBOutlet weak var textView: UITextView!
    
    private var server: WebSocketServer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        server = WebSocketServer()
        server.on(text: { [weak self] (text: String) in
            HapticsBoxEngine.shared.play(ahapString: text)
            DispatchQueue.main.async { [weak self] in
                self?.textView.text = text
            }
        })
        urlField.text = "ws://192.168.11.9:8080/haptic"
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(recognizer)
    }

    @IBAction func utlTextInput(_ sender: Any) {
    }
    
    @objc func tapped() {
        urlField.resignFirstResponder()
    }
}
