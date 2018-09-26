//
//  SignatureBoardViewController.swift
//  SceneWhisper
//
//  Created by weipo 2017/4/18.
//  Copyright © 2017年 weipo. All rights reserved.
//

import UIKit

class SignatureBoardViewController: UIViewController {
    
    var whiteBoardView: WhiteBoardView?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.title = "签名板"
        self.view.backgroundColor = UIColor.white
        
        whiteBoardView = WhiteBoardView(frame: CGRect(x: 0.0, y: 64.0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height - 64.0))
        self.view.addSubview(whiteBoardView!)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: false);
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false);
    }

}
