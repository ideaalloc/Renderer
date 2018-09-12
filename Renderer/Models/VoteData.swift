//
//  VoteData.swift
//  Renderer
//
//  Created by Bill Lv on 2018/9/1.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

public struct VoteData: ADForm {
  public let question: String
  public let options: [String]
  
  public init(question: String, options: [String]) {
    self.question = question
    self.options = options
  }
  
}
