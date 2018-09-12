//
//  ATPRenderer.swift
//  Renderer
//
//  Created by Bill Lv on 2018/8/31.
//  Copyright © 2018 Atlas Protocol. All rights reserved.
//

import Foundation

public protocol ATPRenderer {
  func render()

  func emitEvent(atpEvent: ATPEvent)

  func dispose()
}
