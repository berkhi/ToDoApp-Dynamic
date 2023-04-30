//
//  PopUp.swift
//  ToDoApp
//
//  Created by BerkH on 30.04.2023.
//

import UIKit

class PopUp: UIView {

    @IBOutlet var txtAddTask: UITextField!
    @IBOutlet var btnCreate: UIButton!
    @IBOutlet var btnCancel: UIButton!
    
    required init?(coder: NSCoder){
//         self.view = UIView()
//         self.vc = UIViewController()
         super.init(coder: coder)
         isUserInteractionEnabled = true
     }
     
     override init(frame: CGRect){
//         self.view = UIView()
//         self.vc = inView
         super.init(frame: frame)
         xibSetup(frame: CGRect(x: 0, y: 0, width: frame.width, height: frame.width))
     }
     
     func xibSetup(frame: CGRect){
         let view = loadNibView()
         view.frame = frame
         addSubview(view)
     }
     
     func loadNibView() -> UIView{
         let bundle = Bundle(for: type(of: self))
         let nib = UINib(nibName: "PopUp", bundle: bundle)
         let view = nib.instantiate(withOwner: self).first as! UIView
         return view
     }

}
