//
//  Account.swift
//  Renderer
//
//  Created by Bill Lv on 2018/9/1.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

public struct Account: Codable {
  let nasAddress: String
  let campaignID: String
  
  public init(nasAddress: String, campaignID: String) {
    self.nasAddress = nasAddress
    self.campaignID = campaignID
  }
}
