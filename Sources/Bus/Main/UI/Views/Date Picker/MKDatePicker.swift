//
//  MKDatePicker.swift
//  MosmetroNew
//
//  Created by Сеня Римиханов on 26.11.2020.
//  Copyright © 2020 Гусейн Римиханов. All rights reserved.
//

import Foundation
import UIKit

/// Protocol for establishing the maximum and minimum possible date of selection in UIDatePicker
protocol _LimitedDatePicker {
    
    /// Method of choosing the minimum possible selection date
    func setMinimumDate(_ date: Date)
    /// Method of choosing the maximum possible selection date
    func setMaximumDate(_ date: Date)
}

class MKDatePicker: UIView {
    
    var onDateChange: ((Date) -> ())?
    var onDoneSelect: ((Date) -> ())?
    
    @IBOutlet var doneButton: UIButton!
    @IBOutlet var datePicker: UIDatePicker!

    @IBAction func handleDoneTap(_ sender: UIButton) {
        self.onDoneSelect?(datePicker.date)
        self.removeFromSuperview()
    }
    
    @objc
    private func handleDateSelection() {
        self.onDateChange?(datePicker.date)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.roundCorners(.all, radius: 10)
        datePicker.addTarget(self, action: #selector(handleDateSelection), for: .valueChanged)
        if #available(iOS 14, *) {
            datePicker.preferredDatePickerStyle = .inline
        }
        self.layer.borderWidth   = 0.0
        self.layer.shadowColor   = UIColor(red: 0, green: 0, blue: 0, alpha: 0.16).cgColor
        self.layer.shadowOffset  = CGSize(width: 0, height: 0)
        self.layer.shadowRadius  = 8
        self.layer.shadowOpacity = 1
        self.layer.masksToBounds = false
    }
}

extension MKDatePicker: _LimitedDatePicker {
    func setMinimumDate(_ date: Date) {
        datePicker.minimumDate = date
    }
    
    func setMaximumDate(_ date: Date) {
        datePicker.maximumDate = date
    }
}
