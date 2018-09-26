//
//  SWPickerView.swift
//  SceneWhisper
//
//  Created by weipo 2017/9/17.
//  Copyright © 2017年 weipo. All rights reserved.
//  阅读次数选择器

import UIKit

@objc protocol SWPickerViewDelegate: NSObjectProtocol {
    
    @objc optional func pickerView(_ pickerView: SWPickerView, didSelectedData dataString: String)
    
}

class SWPickerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    weak var delegate: SWPickerViewDelegate?
    var backgroundImage: UIImageView?
    fileprivate var dataResource: Array<Array<String>>? = [["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"], ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]]
    var swPicker: UIPickerView?
    fileprivate var hundred: String = ""
    fileprivate var decade: String = ""
    fileprivate var unit: String = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    deinit {
        self.delegate = nil
    }

    func setupViews() {
        
        let bgImage = UIImageView(frame: CGRect(origin: .zero, size: self.frame.size))
        bgImage.image = UIImage(named: "3时间滚动")
        self.addSubview(bgImage)
        backgroundImage = bgImage
        
        let picker = UIPickerView(frame: CGRect(origin: .zero, size: self.frame.size))
        picker.delegate = self
        picker.dataSource = self
        picker.showsSelectionIndicator = true
        self.addSubview(picker)
        swPicker = picker
        
        let frame1 = CGRect(x: 29.0, y: self.frame.height / 2.0 , width: 15.0, height: 15.0)
        let label1 = UILabel(frame: frame1)
        label1.textColor = .white
        label1.text = "百位"
        label1.font = UIFont.systemFont(ofSize: 5.0)
        self.addSubview(label1)
        
        let frame2 = CGRect(x: 70.0, y: self.frame.height / 2.0 , width: 15.0, height: 15.0)
        let label2 = UILabel(frame: frame2)
        label2.textColor = .white
        label2.text = "十位"
        label2.font = UIFont.systemFont(ofSize: 5.0)
        self.addSubview(label2)
        
        let frame3 = CGRect(x: 110.0, y: self.frame.height / 2.0 , width: 15.0, height: 15.0)
        let label3 = UILabel(frame: frame3)
        label3.textColor = .white
        label3.text = "个位"
        label3.font = UIFont.systemFont(ofSize: 5.0)
        self.addSubview(label3)
        
    }
    
    func loadData(_ data: Int) {
        
        hundred = Int(data / 100).description
        decade = Int((data % 100) / 10).description
        unit = Int((data % 100) % 10).description
        
        print("hundred: \(hundred), decade: \(decade), unit: \(unit)")
        
        swPicker?.selectRow(Int(hundred)!, inComponent: 0, animated: true)
        swPicker?.selectRow(Int(decade)!, inComponent: 1, animated: true)
        swPicker?.selectRow(Int(unit)!, inComponent: 2, animated: true)
        
    }
    
}

extension SWPickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.dataResource!.count
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.dataResource![component].count
    }
    
}


extension SWPickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 36.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 22.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("did select compent \(component), row: \(row), text: \(dataResource![component][row])")
        
        switch component {
        case 0:
            hundred = dataResource![0][row]
            break
        case 1:
            decade = dataResource![1][row]
            break
        case 2:
            unit = dataResource![2][row]
            break
        default:
            break
        }
        
        let dataString = hundred + decade + unit
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(self.delegate!.pickerView(_:didSelectedData:))) {
            self.delegate!.pickerView!(self, didSelectedData: dataString)
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        var dataString = ""
        switch component {
        case 0:
            dataString += dataResource![component][row]
            break
        case 1:
            dataString += dataResource![component][row]
            break
        case 2:
            dataString += dataResource![component][row]
            break
        default:
            break
        }
        return dataString
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view = UILabel()
        view.text = dataResource![component][row]
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 19.0)
        
        switch component {
        case 0:
//            view.backgroundColor = .red
            break
        case 1:
//            view.backgroundColor = .yellow
            break
        case 2:
//            view.backgroundColor = .blue
            break
        default:
            break
        }
        return view
    }
    
}




