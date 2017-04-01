import UIKit

/*:
 # Mandelbrot Set
 
 For more info, see Graph.swift and Mandelbrot.swift files
 
 */

/*:
 Test if a point is in the set.
 
 Returns 1 if it is, otherwise between 1 and 0 (to represent 'distance' from the set - ie. how many iterations it took to determine it was non-convergent)
 */

isMandelbrot(CGPoint(x: 0.3, y: 1.0))

/*:
 Plain rendering of the whole set.
 */

var greyGraph = Graph.init(width: 1000, height: 1000) { point in
    return PixelData.greyPixel(greyness: 1 - isMandelbrot(point))
}

greyGraph.calculate()



/*:
 A very pretty subsection of the graph with special colouring. Also available, 'coolPixel', 'greyPixel' and 'gradientPixel'.
 */

var colourGraph = Graph.init(width: 500, height: 500,
    centre: CGPoint(x: -0.7463, y: 0.1102),
    scale: CGFloat(0.005)
) { point in
    return PixelData.gradientPixel(
        depth: 1 - isMandelbrot(point),
        start: UIColor.blue,
        finish: UIColor.orange)
}

colourGraph.calculate()

/*:
 Of course, much of this is done outside of the Playground, and in the bundled swift file. You get heaps more speed that way.
 
 Try looking at this excellent graph:
 */

bigGraph.calculate()

/*:
 I did a single-threaded version, but it was very slow. This is actually a very parallel-able problem.  Let's measure the difference in speed.
 
 (I used GCD to make it faster, but there are better ways.)
 */

public func timeMe(_ name: String, block:()->()){
    let date = Date()
    block()
    let timeInterval = NSDate().timeIntervalSince(date as Date)
    print("Elapsed time for \(name): \(timeInterval)")
}

timeMe("single-threaded") {
    let _ = colourGraph.calculateSingleThread()
}

timeMe("gcd") {
    let _ = colourGraph.calculate()
}
