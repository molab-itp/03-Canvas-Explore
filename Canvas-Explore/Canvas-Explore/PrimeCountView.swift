//
// PrimeCountView
//
// display prime numbers as dots on a grid
// in a range based baseCount to baseCount+cellCount
// report density in a range as percent
//

import SwiftUI

struct PrimeDisplay {
  let numInterval = 1000.0;
  let lineWidth = 1.0
  let cellWidth = 40.0
}
let primeDisplay = PrimeDisplay();

struct PrimeCountView: View {
  @State private var startNum = 0.0
  @State var cellCount: Int = 0
  @State var primeCount: Int = 0
  @State var nx: Int = 0
  @State var ny: Int = 0
  
  var body: some View {
    VStack {
      Text("Start: \(Int(startNum))")
      HStack {
        Button("+Step") {
          startNum += primeDisplay.numInterval
        }
        Button("-Step") {
          startNum -= primeDisplay.numInterval
        }
        Button("Zero") {
          startNum = 0
        }
      }
      HStack {
        Text("\(nx)x\(ny) = \(cellCount)")
        Text("nprimes:\(primeCount)")
        if cellCount != 0 {
          let density = Double(primeCount)/Double(cellCount);
          Text(String(format: "density: %.2f", density))
        }
      }
      Canvas { context, size in
        //      print("size", size)
        let (cellCount,primeCount, nx, ny) = drawGridCountPrimes(
          context: context,
          size: size,
          startNum: startNum )
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
  startNum: Double) -> (Int,Int,Int,Int) {
    
    var primeCount = 0
    let (cellCount,xmargin,ymargin,nx,ny) =
    drawGrid(context: context, size: size)
    
    let lineWidth = primeDisplay.lineWidth
    let cellWidth = primeDisplay.cellWidth
    
    var primes: [Int] = []
    let start = Int(startNum)
    let stop = start+cellCount
    for num in start..<stop {
      if isPrime(num) {
        primes.append(num)
        primeCount += 1
        let num0 = num - start - 1
        var x = Double(num0 % nx) * cellWidth;
        var y = Double(num0 / nx) * cellWidth
        x += xmargin
        y += ymargin
        
        let rect = CGRect(x: x, y: y-lineWidth/2,
                          width:cellWidth, height:cellWidth)
        let dotPath = Path(ellipseIn: rect)
        context.fill(dotPath, with: .color(.black) )
      }
    }
    //    print("primes", primes)
    print("start", start, "stop", stop, "primeCount", primeCount)
    return (cellCount, primeCount, nx, ny)
  }

func isPrime(_ num:Int) -> Bool {
  if num < 2 {
    return false
  }
  // Don't need to check all numbers
  let numStop = Int(Double(num).squareRoot())+1
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
    let height:Double = Double(Int(size.height)/Int(cellWidth)) * cellWidth
    let width:Double = Double(Int(size.width)/Int(cellWidth)) * cellWidth
    let xmargin = (size.width - width) / 2.0
    let ymargin = (size.height - height) / 2.0
    
//    var context2 = context
//    context2.translateBy(x: xmargin, y: ymargin)
    
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
