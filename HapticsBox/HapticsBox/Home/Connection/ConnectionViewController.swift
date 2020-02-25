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
    @IBOutlet weak var connectButton: UIButton!
    
    private var server: WebSocketServer!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        server = WebSocketServer()
        server.on(text: { (text: String) in
            HapticsBoxEngine.shared.play(ahapString: text)
        })
        urlField.text = Configs.macUrl  //input your server url
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(recognizer)
    }

    @IBAction func utlTextInput(_ sender: Any) {
    }
    
    @objc func tapped() {
        urlField.resignFirstResponder()
    }
}
