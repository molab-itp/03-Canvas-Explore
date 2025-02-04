//
//  File.swift
//  Canvas-Explore
//
//  Created by jht2 on 2/4/25.
//

import SwiftUI

func randomSlash(_ p: CGPoint) -> Path {
  var path = Path()
  let x = loc.x;
  let y = loc.y;
  let xlen = cellSize.width;
  let ylen = cellSize.height;
  if Bool.random() {
    // Draw line top left to bottom right
    path.move(to: CGPoint(x: x, y: y))
    path.addLine(to: CGPoint(x: x+xlen, y: y+ylen))
  }
  else {
    // Draw line top right to bottom left
    path.move(to: CGPoint(x: x+xlen, y: y))
    path.addLine(to: CGPoint(x: x, y: y+ylen))
  }
  return path;
}
