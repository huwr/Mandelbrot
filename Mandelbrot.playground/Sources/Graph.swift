import Foundation
import UIKit

extension UIColor {
    var coreImageColor: CIColor {
        return CIColor(color: self)
    }
    var components: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        let coreImageColor = self.coreImageColor
        return (coreImageColor.red, coreImageColor.green, coreImageColor.blue, coreImageColor.alpha)
    }
}

public struct PixelData: CustomStringConvertible {
    var a: UInt8 = 0
    var r: UInt8 = 0
    var g: UInt8 = 0
    var b: UInt8 = 0
    
    public var description: String {
        get { return "a:\(a), r:\(r), g:\(g), b:\(b)" }
    }
    
    public static func randomPixel() -> PixelData {
        return PixelData.init(
            a: 255,
            r: randomChannelValue(),
            g: randomChannelValue(),
            b: randomChannelValue()
        )
    }
    
    public static func blackPixel() -> PixelData {
        return PixelData.init(a: 255, r: 0, g: 0, b: 0)
    }
    
    public static func whitePixel() -> PixelData {
        return PixelData.init(a: 255, r: 255, g: 255, b: 255)
    }
    
    public static func greyPixel(greyness: Double) -> PixelData {
        let x = UInt8(greyness * 255)
        return PixelData.init(
            a: 255,
            r: x,
            g: x,
            b: x
        )
    }
    
    private static func interporlate(between start: CGFloat, and end: CGFloat, value: CGFloat) -> UInt8 {
        let x = (start * value) + (end * (1 - value))
        return UInt8(x * 255)
    }
    
    public static func gradientPixel(depth: Double, start: UIColor, finish: UIColor) -> PixelData {
        let r = interporlate(between: start.components.red, and: finish.components.red, value: CGFloat(depth))
        let g = interporlate(between: start.components.green, and: finish.components.green, value: CGFloat(depth))
        let b = interporlate(between: start.components.blue, and: finish.components.blue, value: CGFloat(depth))
        
        return PixelData.init(a: 255, r: r, g: g, b: b)
    }
    
    public static func coolPixel(coolness: Double) -> PixelData {
        let scaledCoolness = coolness == 1.0 ? 0 : UInt32(coolness * 0xffffff)
        return PixelData.init(
            a: 255,
            r: UInt8((scaledCoolness & (0xff0000)) >> 16),
            g: UInt8((scaledCoolness & (0x00ff00)) >> 8),
            b: UInt8((scaledCoolness & (0x0000ff)) >> 0)
        )
    }
    
    static private func randomChannelValue() -> UInt8 {
        return UInt8(arc4random_uniform(256))
    }
}




public struct Graph {
    private var pixels: [PixelData]
    var size: CGSize
    
    public init(width: Int, height: Int, predicate: (CGPoint) -> PixelData) {
        self.init(width: width, height: height,
                  centre: CGPoint(x: 0, y: 0), scale: CGFloat(4),
                  predicate: predicate)
    }
    
    public init(width: Int, height: Int, centre: CGPoint, scale: CGFloat, predicate: (CGPoint) -> PixelData) {
        size = CGSize(width: width, height: height)
        
        pixels = [PixelData]()
        
        for index in 0..<(width * height) {
            let point = indexToPoint(index, centre: centre, size: size, scale: scale)
            pixels.append(predicate(point))
        }
    }
    
    private func indexToPoint(_ index: Int, centre: CGPoint, size: CGSize, scale: CGFloat) -> CGPoint {
        let aspectRatio = size.height / size.width
        
        var point = CGPoint(
            x: index % Int(size.width),
            y: index / Int(size.height)
        )
        
        point.x = (((point.x * scale / size.width) - scale / 2.0) + (centre.x * aspectRatio)) / aspectRatio
        point.y = (((point.y * scale / size.height) - scale / 2.0) * -1) + centre.y
        
        return point
    }
    
    public var image: UIImage? {
        guard pixels.count == Int(size.width * size.height) else { return nil }
        
        let data: Data = pixels.withUnsafeBufferPointer {
            return Data(buffer: $0)
        }
        
        let cfdata = NSData(data: data) as CFData
        guard let provider = CGDataProvider(data: cfdata) else {
            return nil
        }
        
        guard let cgimage = CGImage(
            width: Int(size.width),
            height: Int(size.height),
            bitsPerComponent: 8,
            bitsPerPixel: 32,
            bytesPerRow: Int(size.width) * MemoryLayout<PixelData>.size,
            space: CGColorSpaceCreateDeviceRGB(),
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.premultipliedFirst.rawValue),
            provider: provider,
            decode: nil,
            shouldInterpolate: true,
            intent: .defaultIntent
            ) else { return nil }
        
        return UIImage(cgImage: cgimage)
    }

}

