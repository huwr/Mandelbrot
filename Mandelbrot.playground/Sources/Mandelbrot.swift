import CoreGraphics

let maxIterations = 100

public func isMandelbrot(_ point: CGPoint) -> Double {
    let cr = point.x
    let ci = point.y
    
    var zr = point.x
    var zi = point.y
    
    for i in 1..<maxIterations {
        if (square(zr) + square(zi)) > 4 {
            return Double(i) / Double(maxIterations)
        }
        
        let zrNext = square(zr) - square(zi) + cr
        let ziNext = ((zr * zi) * 2) + ci
        
        zr = zrNext
        zi = ziNext
    }
    
    return 1.0
}

func square(_ i: CGFloat) -> CGFloat {
    return i * i
}
