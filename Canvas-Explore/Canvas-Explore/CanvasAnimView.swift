//
//  CanvasAnimView.swift
//  Canvas-Explore
//
//  Created by jht2 on 1/26/25.
//

import SwiftUI

let animInterval = 0.10; // update very tenth of a second
let ncell = 10.0
let lineWidth = 10.0
let colorSpecs = [Color.red, Color.green, Color.yellow, Color.black];

var loc = CGPoint.zero;
var nsize: CGSize = .zero;
struct PathData {
  var path: Path;
  var color: Color;
}
var paths: [PathData] = [];


struct CanvasAnimView: View {
  var body: some View {
    TimelineView(.animation(minimumInterval: animInterval)) { timeline in
      Canvas { context, size in
        //      print("size", size)
        nsize = CGSize(width: size.width/ncell, height: size.width/ncell)
                
        let path = randomSlash(loc);
        let color = colorSpecs.randomElement() ?? .black
        paths.append(PathData(path: path, color: color));
        for p in paths {
          let style = StrokeStyle(lineWidth: lineWidth, lineCap: .round);
          context.stroke(p.path, with: .color(p.color), style: style)
        }
        loc.x += nsize.width;
        if loc.x > size.width {
          loc.x = 0;
          loc.y += nsize.height;
          if loc.y > size.height {
            loc.y = 0
            paths = [];
          }
        }
        // must read to trigger update
        _ = timeline.date
      }
    }
  }
}

func randomSlash(_ p: CGPoint) -> Path {
  var path = Path()
  let x = loc.x;
  let y = loc.y;
  let xlen = nsize.width;
  let ylen = nsize.height;
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

#Preview {
  CanvasAnimView()
}
