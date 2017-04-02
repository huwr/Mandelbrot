import UIKit

public extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    public var components: ColorComponents {
        let coreImageColor = self.coreImageColor
        return ColorComponents.init(alpha: coreImageColor.alpha, red: coreImageColor.red, green: coreImageColor.green, blue: coreImageColor.blue)
    }
}

public struct ColorComponents {
    public var alpha: CGFloat
    public var red: CGFloat
    public var green: CGFloat
    public var blue: CGFloat
}
