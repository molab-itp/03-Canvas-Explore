//
//  CanvasAnimView.swift
//  Canvas-Explore
//
//  Created by jht2 on 1/26/25.
//

import SwiftUI

// Swift implmentation of 10Print algorithm
// spiced up with a little color

let animInterval = 0.10; // update very tenth of a second
let ncell = 10.0
let lineWidth = 10.0
let colorSpecs = [Color.red, Color.green, Color.yellow, Color.black];

var loc = CGPoint.zero;
var cellSize: CGSize = .zero;
struct PathData {
  var path: Path;
  var color: Color;
}
var paths: [PathData] = [];

let step = 10.0;
var colorIndex = 0;
var inited : Bool = false;

struct CanvasAnimView: View {
  var body: some View {
    TimelineView(.animation(minimumInterval: animInterval)) { timeline in
      VStack {
        Canvas { context, size in
          // print("size", size)
          if !inited {
            loc.x = size.width / 2
            inited = true
          }
          nextBar(context, size);
          // nextSlash(context, size);
          // must read to trigger update
          _ = timeline.date
        }
        ButtonBarView();
      }
    }
  }
}

struct ButtonBarView: View {
  var body: some View {
    HStack {
      Button("Left") {
        loc.x -= step;
      }
      Button("Right") {
        loc.x += step;
      }
      Button(action: nextColor) {
        Label("Sign In", systemImage: "arrow.trianglehead.clockwise")
          .labelStyle(.iconOnly)
      }
    }
  }
}
  
func nextColor() {
  colorIndex = (colorIndex + 1) % colorSpecs.count
}

// See UIGraphicsImageRenderer version:
// https://github.com/molab-itp/01-UIRender-playground / 10print save

#Preview {
  CanvasAnimView()
}

