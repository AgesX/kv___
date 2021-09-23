//
//  ViewController.swift
//  kvo
//
//  Created by Jz D on 2021/9/23.
//

import UIKit


class Cate: NSObject{
    
    @objc dynamic var nick = 51
    
    var k: String{
        "nick"
    }
}



class ViewController: UIViewController {

    let cat = Cate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cat.addObserver(self, forKeyPath: cat.k, options: .new, context: nil)
    }


    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let dict = change{
            print(dict[.newKey] ?? "ha ha")
        }
        
        
    }
    
    
    deinit{
        
        cat.removeObserver(self, forKeyPath: cat.k, context: nil)
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        cat.nick += 3
    }
}

