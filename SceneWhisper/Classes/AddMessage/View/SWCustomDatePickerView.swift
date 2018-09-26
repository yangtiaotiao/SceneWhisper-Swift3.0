//
//  SWCustomDatePickerView.swift
//  SceneWhisper
//
//  Created by weipo 2017/9/19.
//  Copyright © 2017年 weipo. All rights reserved.
//  密信阅读日期的view

import UIKit

@objc protocol SWCustomDatePickerViewDelegate: NSObjectProtocol {
    
    @objc optional func pickerView(_ pickerView: SWCustomDatePickerView, didSelectedDateData data: Dictionary<String,String>)
}

class SWCustomDatePickerView: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    weak var delegate: SWCustomDatePickerViewDelegate?
    var titleLabel: UILabel?
    var midLabel: UILabel?
    var leftPicker: UIPickerView?
    var rightPicker: UIPickerView?
    var pickType: Int = 0
    var leftLabel: UILabel?
    var rightLabel: UILabel?
    
    fileprivate var monthData: Array<String> = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12"]
    fileprivate var dayData: Array<String> = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"]
    fileprivate var hourData: Array<String> = ["01", "02", "03", "04", "05", "06", "07", "08", "09", "10", "11", "12", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24"]
    fileprivate var leftData: String = ""
    fileprivate var rightData: String = ""
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
    
    deinit {
        self.delegate = nil
    }
    
    func setupViews() {
        
        let label1Frame = CGRect(x: 0.0, y: (self.frame.height - 21.0 * KScaleW) / 2.0, width: 42.0 * KScaleW, height: 21.0 * KScaleW)
        let label1 = UILabel(frame: label1Frame)
        label1.text = "每年"
        label1.textColor = .black
        label1.textAlignment = .center
        self.addSubview(label1)
        titleLabel = label1
        
        let label2Frame = CGRect(x: 92.0 * KScaleW, y: (self.frame.height - 21.0 * KScaleW) / 2.0, width: 21.0 * KScaleW, height: 21.0 * KScaleW)
        let label2 = UILabel(frame: label2Frame)
        label2.text = "至"
        label2.textColor = .black
        label2.textAlignment = .center
        self.addSubview(label2)
        midLabel = label2
        
        let bg1Frame = CGRect(x: 42.0 * KScaleW, y: (self.frame.height - 80.0 * KScaleW) / 2.0, width: 50.0 * KScaleW, height: 80.0 * KScaleW)
        let bg1 = UIImageView(frame: bg1Frame)
        bg1.backgroundColor = UIColor.color(with: "5a5b5f")
        self.addSubview(bg1)
        
        let bg2Frame = CGRect(x: 113.0 * KScaleW, y: (self.frame.height - 80.0 * KScaleW) / 2.0, width: 50.0 * KScaleW, height: 80.0 * KScaleW)
        let bg2 = UIImageView(frame: bg2Frame)
        bg2.backgroundColor = UIColor.color(with: "5a5b5f")
        self.addSubview(bg2)
        
        let picker1 = UIPickerView(frame: bg1Frame)
        picker1.delegate = self
        picker1.dataSource = self
        picker1.showsSelectionIndicator = true
        picker1.tag = 0
        self.addSubview(picker1)
        leftPicker = picker1
        
        let picker2 = UIPickerView(frame: bg2Frame)
        picker2.delegate = self
        picker2.dataSource = self
        picker2.showsSelectionIndicator = true
        self.addSubview(picker2)
        picker2.tag = 1
        rightPicker = picker2
        
        let label3Frame = CGRect(x: 78.0 * KScaleW, y: self.frame.height / 2.0, width: 15.0 * KScaleW, height: 15.0 * KScaleW)
        let label3 = UILabel(frame: label3Frame)
        label3.text = "月"
        label3.textColor = UIColor.white
        label3.textAlignment = .center
        label3.font = UIFont.systemFont(ofSize: 9.0)
        self.addSubview(label3)
        leftLabel = label3
        
        let label4Frame = CGRect(x: 148.0 * KScaleW, y: self.frame.height / 2.0, width: 15.0 * KScaleW, height: 15.0 * KScaleW)
        let label4 = UILabel(frame: label4Frame)
        label4.text = "月"
        label4.textColor = UIColor.white
        label4.textAlignment = .center
        label4.font = UIFont.systemFont(ofSize: 9.0)
        self.addSubview(label4)
        rightLabel = label4
        
    }
    
    func reloadData(_ type: Int) {
        
        pickType = type
        leftPicker?.reloadAllComponents()
        rightPicker?.reloadAllComponents()
        if pickType == 0 {
            leftLabel?.text = "月"
            rightLabel?.text = "月"
        } else if pickType == 1 {
            leftLabel?.text = "日"
            rightLabel?.text = "日"
        } else if pickType == 2 {
            leftLabel?.text = "时"
            rightLabel?.text = "时"
        }
    }
    
    func loadData(_ type: Int, upper: Int, floor: Int) {
        
        pickType = type
        if floor < upper {
            leftPicker?.selectRow(floor, inComponent: 0, animated: true)
            rightPicker?.selectRow(upper, inComponent: 0, animated: true)
            self.pickerView(leftPicker!, didSelectRow: floor, inComponent: 0)
            self.pickerView(rightPicker!, didSelectRow: upper, inComponent: 0)
        } else {
            leftPicker?.selectRow(upper, inComponent: 0, animated: true)
            rightPicker?.selectRow(floor, inComponent: 0, animated: true)
            self.pickerView(leftPicker!, didSelectRow: upper, inComponent: 0)
            self.pickerView(rightPicker!, didSelectRow: floor, inComponent: 0)
        }
  
    }
    
}

extension SWCustomDatePickerView: UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickType == 0 {
            return monthData.count
        } else if pickType == 1 {
            return dayData.count
        } else if pickType == 2 {
            return hourData.count
        }
        return 0
    }
    
}

extension SWCustomDatePickerView: UIPickerViewDelegate {
    
    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        return 50.0
    }
    
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 25.0
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if pickerView.tag == 0 {
            
            if pickType == 0 {
                leftData = monthData[row]
            } else if pickType == 1 {
                leftData = dayData[row]
            } else if pickType == 2 {
                leftData = hourData[row]
            }
            
        } else {
            if pickType == 0 {
                rightData = monthData[row]
            } else if pickType == 1 {
                rightData = dayData[row]
            } else if pickType == 2 {
                rightData = hourData[row]
            }
            
        }
        
        if self.delegate != nil && self.delegate!.responds(to: #selector(SWCustomDatePickerViewDelegate.pickerView(_:didSelectedDateData:))) {
            
            if leftData == "" {
                if pickType == 0 {
                    leftData = monthData[0]
                } else if pickType == 1 {
                    leftData = dayData[0]
                } else if pickType == 2 {
                    leftData = hourData[0]
                }
            }
            
            if rightData == "" {
                if pickType == 0 {
                    rightData = monthData[0]
                } else if pickType == 1 {
                    rightData = dayData[0]
                } else if pickType == 2 {
                    rightData = hourData[0]
                }
            }
            
            let data: Dictionary<String,String> = ["type": pickType.description,
                                                   "upper": leftData,
                                                   "floor": rightData]
            self.delegate!.pickerView!(self, didSelectedDateData: data)
        }
        
    }
    
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        
        let view = UILabel()
        view.textColor = .white
        view.textAlignment = .center
        view.font = UIFont.systemFont(ofSize: 19.0)
        
        if pickerView.tag == 0 {
            if pickType == 0 {
                view.text = monthData[row]
            } else if pickType == 1 {
                view.text = dayData[row]
            } else if pickType == 2 {
                view.text = hourData[row]
            }
        } else {
            if pickType == 0 {
                view.text = monthData[row]
            } else if pickType == 1 {
                view.text = dayData[row]
            } else if pickType == 2 {
                view.text = hourData[row]
            }
        }
        return view
        
    }
}


