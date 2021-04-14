//
//  SwitchCellViewModel.swift
//  TikTok
//
//  Created by Roy Park on 4/14/21.
//

import Foundation

struct SwitchCellViewModel {
    let title: String
    var isOn: Bool
    
    mutating func setOn(_ on: Bool) {
        self.isOn = on
    }
}
