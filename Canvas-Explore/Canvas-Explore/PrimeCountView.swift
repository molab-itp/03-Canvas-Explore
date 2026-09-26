//
//  GridCanvasView.swift
//  Canvas-Explore
//
//  Created by jht2 on 9/25/26.
//

import SwiftUI

struct PrimeDisplay {
  let baseStep = 1000.0;
  let lineWidth = 1.0
  let cellWidth = 25.0
}
let primeDisplay = PrimeDisplay();

struct PrimeCountView: View {
  @State var cellCount: Int = 0
  @State var nx: Int = 0
  @State var ny: Int = 0
  @State private var baseCount = 0.0
  @State var primeCount: Int = 0
  
  var body: some View {
    VStack {
      Text("Base: \(Int(baseCount))")
      HStack {
        //        let baseStep = primeDisplay.baseStep
        //        Slider(value: $baseCount, in: 0...1000_000, step: baseStep)
        Button("+Step") {
          baseCount += primeDisplay.baseStep
        }
        Button("-Step") {
          baseCount -= primeDisplay.baseStep
        }
      }
      HStack {
        Text("\(nx)x\(ny) = \(cellCount)")
        Text("nprimes:\(primeCount)")
        if cellCount != 0 {
          let preCent = Double(primeCount)/Double(cellCount);
          Text(String(format: "%.2f", preCent))
        }
      }
      Canvas { context, size in
        //      print("size", size)
        let (cellCount,primeCount, nx, ny) = drawGridCountPrimes(
          context: context,
          size: size,
          baseCount: baseCount )
        Task {
          // must defer setting with Task
          self.cellCount = cellCount
          self.primeCount = primeCount
          self.nx = nx
          self.ny = ny
        }
      }
    }
    .onAppear {
      //      print("onAppear countUI", countUI)
    }
  }
}

func drawGridCountPrimes(
  context :GraphicsContext,
  size :CGSize,
  baseCount: Double) -> (Int,Int,Int,Int) {
    
    var primeCount = 0
    let (cellCount,xmargin,ymargin,nx,ny) =
    drawGrid(context: context, size: size)
    
    let lineWidth = primeDisplay.lineWidth
    let cellWidth = primeDisplay.cellWidth
    
    var primes: [Int] = []
    let bc = Int(baseCount)
    for num in bc..<bc+cellCount {
      if isPrime(num) {
//        print("prime ", num)
        primes.append(num)
        primeCount += 1
        let num0 = num - bc - 1
        var x = Double(num0 % nx) * cellWidth;
        var y = Double(num0 / nx) * cellWidth
        x += xmargin
        y += ymargin
        
        let rt = CGRect(x: x, y:y-lineWidth/2,
                        width:cellWidth, height:cellWidth)
        let ellipsePath = Path(ellipseIn: rt)
        context.fill(ellipsePath, with: .color(.black) )
      }
    }
    print("primes", primes)
    print("primeCount", primeCount)
    return (cellCount, primeCount, nx, ny)
  }

func isPrime(_ num:Int) -> Bool {
  if num < 2 {
    return false
  }
  // Don't need to check all numbers
  //  let numStop = Int(Double(num).squareRoot());
  //  if numStop < 2 {
  //    return true
  //  }
  let numStop = num
  for i in 2..<numStop {
    if num % i == 0 {
      return false
    }
  }
  return true
}

// cellCount depends on size
func drawGrid(
  context :GraphicsContext,
  size :CGSize ) -> (Int,Double,Double,Int,Int) {
    
    let lineWidth = primeDisplay.lineWidth
    let cellWidth = primeDisplay.cellWidth
    // grid columns
    var x = 0.0
    var nx = 0
    let height:Double = Double( Int(size.height) / Int(cellWidth) ) * cellWidth
    let width:Double = Double( Int(size.width) / Int(cellWidth) ) * cellWidth
    let xmargin = (size.width - width) / 2.0
    let ymargin = (size.height - height) / 2.0
    while x <= width {
      var path = Path()
      path.move(to: CGPoint(x: x + xmargin, y:ymargin))
      path.addLine(to: CGPoint(x: x + xmargin, y: height + ymargin))
      context.stroke(path, with: .color(.black), lineWidth: lineWidth)
      x += cellWidth
      nx += 1
    }
    // grid rows
    var y = 0.0
    var ny = 0
    while y <= height {
      var path = Path()
      path.move(to: CGPoint(x: 0 + xmargin, y:y + ymargin))
      path.addLine(to: CGPoint(x: width + xmargin, y: y + ymargin))
      context.stroke(path, with: .color(.black), lineWidth: lineWidth)
      y += cellWidth
      ny += 1
    }
    nx -= 1;
    ny -= 1;
    let cellCount = nx * ny;
    
    print("drawGrid cellCount", cellCount)
    // Draw centered cell
    //  x = (Double(nx-1) / 2.0).rounded(.down) * cellWidth // 4.0 * cell
    //  y = (Double(ny-1) / 2.0).rounded(.down) * cellWidth // 4.0 * cell
    //  x += xmargin
    //  y += ymargin
    //  let rt = CGRect(x: x, y:y-lineWidth/2, width:cellWidth, height:cellWidth)
    //  let ellipsePath = Path(ellipseIn: rt)
    //  context.fill(ellipsePath, with: .color(.black) )
    
    return (cellCount, xmargin, ymargin, nx, ny);
  }

#Preview {
  PrimeCountView()
}
