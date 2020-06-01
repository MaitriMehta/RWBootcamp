//
//  WebViewController.swift
//  Week01
//
//  Created by Maitri Mehta on 5/31/20.
//  Copyright © 2020 Maitri. All rights reserved.
//

import UIKit
import WebKit

class WebViewController: UIViewController {
    @IBOutlet private weak var webView: WKWebView!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url: URL!
        url = URL(string: "https://en.wikipedia.org/wiki/RGB_color_model")
        if let wikiURL = url {
            let urlRequest = URLRequest(url: wikiURL)
            webView.load(urlRequest)
        }
    }
    @IBAction func btnCloseTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

}
