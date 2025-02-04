//
//  nextSlash.swift
//  Canvas-Explore
//
//  Created by jht2 on 2/4/25.
//

import SwiftUI

func nextSlash(_ context: GraphicsContext, _ size :CGSize) {
  cellSize = CGSize(width: size.width/ncell, height: size.width/ncell)
  
  let path = randomSlash(loc);
  let color = colorSpecs.randomElement() ?? .black
  paths.append(PathData(path: path, color: color));
  for p in paths {
    let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round);
    context.stroke(p.path, with: .color(p.color), style: style)
  }
  loc.x += cellSize.width;
  if loc.x > size.width {
    loc.x = 0;
    loc.y += cellSize.height;
    if loc.y > size.height {
      loc.y = 0
      paths = [];
    }
  }
}

