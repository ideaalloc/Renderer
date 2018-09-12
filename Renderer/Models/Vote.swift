//
//  Vote.swift
//  Renderer
//
//  Created by Bill Lv on 2018/8/29.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

public struct Vote: ATPEvent {
  let nasAddress: String
  let campaignID: String
  let index: String
  let answer: String

  public init(nasAddress: String
      , campaignID: String
      , index: String = "1"
      , answer: String = "1") {
    self.nasAddress = nasAddress
    self.campaignID = campaignID
    self.index = index
    self.answer = answer
  }
}
