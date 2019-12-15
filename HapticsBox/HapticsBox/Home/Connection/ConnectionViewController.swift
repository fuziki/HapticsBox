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
    
    private var client: TanuClient!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        client = TanuClient()
        client.on(text: { (text: String) in
            HapticsBoxEngine.shared.play(ahapString: text)
        })
        client.on(connect: {
            print("on connect ws")
        })
        client.on(diconnect: { [weak self] (error: Error?) in
            print("on disconnect error: \(String(describing: error))")
            self?.connectButton.setTitle("connect", for: .normal)
        })
        urlField.text = Configs.macUrl  //input your server url
        
        let recognizer = UITapGestureRecognizer(target: self, action: #selector(tapped))
        self.view.addGestureRecognizer(recognizer)
    }
    
    private func connect(url: URL) {
        client.connect(url: url)
        connectButton.setTitle("disconnect", for: .normal)
    }
    
    private func disconnect() {
        client.disconnect()
        connectButton.setTitle("connect", for: .normal)
    }
    
    private func togleConnect(url: URL) {
        if client.isConnected {
            disconnect()
        } else {
            connect(url: url)
        }
    }

    @IBAction func connect(_ sender: Any) {
        urlField.endEditing(true)
        utlTextInput(self)
    }

    @IBAction func utlTextInput(_ sender: Any) {
        if let text = urlField.text, let url = URL(string: text) {
            togleConnect(url: url)
        }
    }
    
    @objc func tapped() {
        urlField.resignFirstResponder()
    }
}
