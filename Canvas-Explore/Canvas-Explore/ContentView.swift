//
//  ContentView.swift
//  Canvas-Explore
//
//  Created by jht2 on 1/26/25.
//

import SwiftUI

struct ContentView: View {
  var body: some View {
    Canvas { context, size in
//      print("size", size)
      let lineWidth = 10.0
      let nsize = CGSize(width: size.width, height: size.height/4)
      var arect = CGRect(origin: .zero, size: nsize)
      let ellipsePath = Path(ellipseIn: arect)
      context.stroke(ellipsePath, with: .color(.red), lineWidth: lineWidth)
      
      arect.origin.y += nsize.height;
      let rectPath = Rectangle().path(in: arect)
      context.stroke(rectPath, with: .color(.green), lineWidth: lineWidth)
      
      arect.origin.y += nsize.height;
      let capsule = Capsule().path(in: arect)
      context.stroke(capsule, with: .color(.yellow), lineWidth: lineWidth)
      
      arect.origin.y += nsize.height;
      var path = Path()
      path.move(to: arect.origin)
      arect.origin.y += nsize.height;
      var apoint = arect.origin;
      apoint.x += arect.size.width;
      path.addLine(to: apoint)
      context.stroke(path, with: .color(.yellow), lineWidth: lineWidth)

    }
//    .frame(width: 300, height: 200)
//    .border(Color.blue)
  }
}

#Preview {
  ContentView()
}
