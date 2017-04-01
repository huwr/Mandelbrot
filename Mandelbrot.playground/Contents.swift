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

//Graph.init(width: 100, height: 100) { point in
//    return PixelData.greyPixel(greyness: 1 - isMandelbrot(point))
//}.image



/*:
 A very pretty subsection of the graph with special colouring. Also available, 'coolPixel', 'greyPixel' and 'gradientPixel'.
 */

Graph.init(width: 5000, height: 5000,
    centre: CGPoint(x: -0.7463, y: 0.1102),
    scale: CGFloat(0.005)
) { point in
    return PixelData.gradientPixel(
        depth: 1 - isMandelbrot(point),
        start: UIColor.blue,
        finish: UIColor.orange)
}.image

 
