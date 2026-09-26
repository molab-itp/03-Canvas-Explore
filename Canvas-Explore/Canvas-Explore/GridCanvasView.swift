//
//  GridCanvasView.swift
//  Canvas-Explore
//
//  Created by jht2 on 9/25/26.
//

import SwiftUI

@Observable
class AppModel {
  @ObservationIgnored var count: Int = 0
}

struct GridCanvasView: View {
  @State var appModel = AppModel();
  @State var countUI: Int = 0
  var body: some View {
    VStack {
      HStack {
        Button("Action") {
          // Action
          print("Action appModel.count", appModel.count)
          countUI = appModel.count
//          countUI += 1
          print("Action countUI", countUI)
        }
        Text("countUI \(countUI)")
      }
      Canvas { context, size in
        //      print("size", size)
        let lineWidth = 1.0
        let cell = 10.0
        let count = drawGrid(context: context,
                             size: size,
                             lineWidth: lineWidth,
                             cell: cell)
        // setting @State count in Canvas fails
        print("Canvas count", count)
        //      Task {
        print("Task before appModel.count", appModel.count)
        print("Task before count", count)
        print("Task before countUI", countUI)
//        if appModel.count != count {
          appModel.count = count
//        }
        //        print("Task count", count)
        print("Task appModel.count", appModel.count)
        //      }
      }
    }
    .onAppear {
      print("onAppear a appModel.count", appModel.count)
      countUI = appModel.count
    }
  }
}

// count depends on size
//
func drawGrid(context :GraphicsContext,
              size :CGSize,
              lineWidth: CGFloat,
              cell: CGFloat) -> Int {
  // grid columns
  var x = 0.0
  var nx = 0
  while x < size.width {
    var path = Path()
    path.move(to: CGPoint(x: x, y:0))
    path.addLine(to: CGPoint(x: x, y: size.height))
    context.stroke(path, with: .color(.black), lineWidth: lineWidth)
    x += cell
    nx += 1
  }
  // grid rows
  var y = 0.0
  var ny = 0
  while y < size.height {
    var path = Path()
    path.move(to: CGPoint(x: 0, y:y))
    path.addLine(to: CGPoint(x: size.width, y: y))
    context.stroke(path, with: .color(.black), lineWidth: lineWidth)
    y += cell
    ny += 1
  }
  let count = nx * ny;
  print("drawGrida nx", nx, "ny", ny, "count", count)
  x = (Double(nx) / 2.0).rounded(.up) * cell // 4.0 * cell
  y = (Double(ny) / 2.0).rounded(.up) * cell // 4.0 * cell
  // Solid circle
  let rt = CGRect(x: x, y:y-lineWidth/2, width:cell, height:cell)
  let ellipsePath = Path(ellipseIn: rt)
  context.fill(ellipsePath, with: .color(.black) )
  return count;
}

#Preview {
  GridCanvasView()
}
