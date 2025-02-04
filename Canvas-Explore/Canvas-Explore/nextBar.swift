//
//  nextBox.swift
//  Canvas-Explore
//
//  Created by jht2 on 2/4/25.
//

import SwiftUI

func nextBar(_ context: GraphicsContext, _ size :CGSize) {
  cellSize = CGSize(width: size.width/ncell, height: size.width/ncell)
  
  paths = [];

  var path = Path()
  let x = loc.x;
  let y = loc.y;
  path.move(to: CGPoint(x: x, y: y))
  path.addLine(to: CGPoint(x: x+cellSize.width, y: y))

  let color = colorSpecs[colorIndex]
  paths.append(PathData(path: path, color: color));
  
  for p in paths {
    let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round);
    context.stroke(p.path, with: .color(p.color), style: style)
  }
  loc.y += step;
  if loc.y > size.height {
    loc.y = 0
    nextColor()
  }
}
