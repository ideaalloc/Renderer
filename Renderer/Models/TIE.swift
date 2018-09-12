//
//  TIE.swift
//  Renderer
//
//  Created by Bill Lv on 2018/9/1.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

public struct TIE: Codable {
  public let type: TIEType
  public let raw: String
  
  public init(type: TIEType = .none, raw: String) {
    self.type = type
    self.raw = raw
  }
}

public enum TIEType: String, Codable {
  case voting, none, error
}
