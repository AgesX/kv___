//
//  ViewController.swift
//  kvo
//
//  Created by Jz D on 2021/9/23.
//

import UIKit


class Cate: NSObject{
    
    @objc dynamic var age = 51
    
    @objc dynamic var money = 15
    
    var k: String{
        "age"
    }
}



class ViewController: UIViewController {

    let cat = Cate()
    
    var moneyObservation: NSKeyValueObservation?

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        cat.addObserver(self, forKeyPath: cat.k, options: .new, context: nil)
        
        //
        
        moneyObservation = cat.observe(\.money, changeHandler: { cat, change in
            print("money :  ", cat.money)
        })
    }


    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if let dict = change{
            print("age :   ", dict[.newKey] ?? "ha ha")
        }
        
        
    }
    
    
    deinit{
        
        cat.removeObserver(self, forKeyPath: cat.k, context: nil)
        moneyObservation = nil
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("\n\n下一局:")
        cat.age += 3
        cat.money += 1
        
    }
}

