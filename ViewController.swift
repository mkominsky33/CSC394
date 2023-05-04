//
//  ViewController.swift
//  ColorSense v1
//
//  Created by Miles Kominsky on 4/4/23.
//
import AVFoundation
import UIKit

class ViewController: UIViewController {
    
    //capture session
    var session: AVCaptureSession?
    //photo output
    let output = AVCapturePhotoOutput()
    //Shutter button
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    private let shutterButton: UIButton = {
        let button = UIButton(frame: CGRect(x:0, y:0, width: 100, height: 100))
        button.layer.cornerRadius = 50
        button.layer.borderWidth = 3
        button.layer.borderColor = UIColor.white.cgColor
        return button
    }()
    
    private var imageView: UIImageView!
    private var selectedImageView: UIImageView?
    private var imageScale: CGFloat = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        view.layer.addSublayer(previewLayer)
        view.addSubview(shutterButton)
        checkCameraPermission()
        
        
        
        shutterButton.addTarget(self, action: #selector(didTapTakePhoto), for: .touchUpInside)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewLayer.frame = view.bounds
        
        
        shutterButton.center = CGPoint(x: view.frame.size.width/2, y: view.frame.size.height - 100)
    }
    
    private func checkCameraPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .notDetermined:
            //request
            AVCaptureDevice.requestAccess(for: .video) {[weak self]granted in guard granted else {
                return
            }
                DispatchQueue.main.async {
                    self?.setUpCamera()
                }
        }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            setUpCamera()
        @unknown default:
            break
        }
    }

    private func setUpCamera() {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                }
                
                if session.canAddOutput(output){
                    session.addOutput(output)
                }
                
                //preview layer stuff
                previewLayer.videoGravity = .resizeAspect

                previewLayer.session = session
                
                session.startRunning()
                self.session = session
            }
            catch {
                
                print(error)
                
            }
        }
    }
    
    @objc private func didTapTakePhoto() {
        output.capturePhoto(with: AVCapturePhotoSettings(), delegate: self)
    }
    
    
    
    
    
}

extension ViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        guard let data = photo.fileDataRepresentation() else {
            return
        }
        
        // Stop the camera session
        session?.stopRunning()
        
        // Create a UIImage from the captured photo data
        let image = UIImage(data: data)
    
        
        // Create a UIImageView to display the image
        let imageView = UIImageView(image: image)
        
        imageView.image = image
        selectedImageView = imageView
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        
        // Add a tap gesture recognizer to the image view
        let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapImageView(_:)))
        imageView.addGestureRecognizer(tapRecognizer)
        imageView.isUserInteractionEnabled = true
        
        // Add the image view to the view hierarchy
        view.addSubview(imageView)
    }
    
    @objc private func didTapImageView(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView else {
            return
        }
        
        // Get the location of the tap in the image view's coordinate system
        // Get the location of the tap in the image view's coordinate system
        let tapLocationInView = sender.location(in: imageView)

        // Convert the tap location from the image view's coordinate system to the parent view's coordinate system
        let tapLocationInImage = CGPoint(x: tapLocationInView.x * imageView.image!.size.width / imageView.bounds.size.width,
                                             y: tapLocationInView.y * imageView.image!.size.height / imageView.bounds.size.height)

        let circleLayer = CAShapeLayer()
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.strokeColor = UIColor.white.cgColor
        circleLayer.lineWidth = 2.0

        let viewSize = imageView.bounds.size
        let radius = min(viewSize.width, viewSize.height) * 0.025

        let circlePath = UIBezierPath(arcCenter: tapLocationInView, radius: radius, startAngle: 0.0, endAngle: .pi * 2.0, clockwise: true)

        // Set the shape layer's path to the circle path
        circleLayer.path = circlePath.cgPath

        // Add the shape layer to the parent view's layer
        view.layer.addSublayer(circleLayer)

        // Convert the center of the circle from the parent view's coordinate system to the image view's coordinate system
        let centerOfCircleInImageView = imageView.convert(tapLocationInView, from: imageView)

        // Get the image data
        guard let image = imageView.image,
              let _ = image.cgImage?.dataProvider?.data else {
            return
        }

        let x = Int(tapLocationInImage.x)
        let y = Int(tapLocationInImage.y)
        let pixel = image.getPixelColor(x: x, y: y)
        let red = pixel.red
        let green = pixel.green
        let blue = pixel.blue

        
        // Convert RGB to HSL
        let hsl  = rgbToHsl(red: red, green: green, blue: blue)
        
        // Convert RGB to hexadecimal
        let hexadecimal = rgbToHex(red: red, green: green, blue: blue)
        
        let rgb = (red,green,blue)
        
        let closestColor = closestColorName(rgb: rgb)
        
        let shortenedString = closestColor!
            .replacingOccurrences(of: "Optional(", with: "")
            .replacingOccurrences(of: ")", with: "")
        
        let hue = Int(hsl.h)
        let saturation = Int(hsl.s * 100)
        let light = Int(hsl.l * 100)
                
        
        // Show a pop-up with the most frequent RGB, HSL, and hexadecimal values
        let message = "RGB: (\(red), \(green), \(blue))\nHSL: (\(hue), \(saturation)%, \(light)%)\nHexadecimal: \(hexadecimal)"
        
        let alert = UIAlertController(title: "Closest Color: \(shortenedString)", message: message, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(red: CGFloat(red)/255, green: CGFloat(green)/255, blue: CGFloat(blue)/255, alpha: 1.0)


        
        self.present(alert, animated: true, completion: nil)
        
                
        func closestColorName(rgb: (Int, Int, Int)) -> String? {
            let colors: [(String, (Int, Int, Int), (Int, Int, Int))] = [
                ("Red", (255, 0, 0), (255, 50, 50)),
                ("Green", (0, 255, 0), (50, 255, 50)),
                ("Light Green", (144, 255, 144), (180, 255, 180)),
                ("Blue", (0, 0, 255), (50, 50, 255)),
                ("Yellow", (255, 255, 0), (255, 255, 200)),
                ("Purple", (128, 0, 128), (180, 50, 180)),
                ("Orange", (255, 165, 0), (255, 200, 50)),
                ("Dark Orange", (200, 90, 0), (225, 110, 0)),
                ("Pink", (255, 192, 203), (255, 150, 180)),
                ("Brown", (165, 42, 42), (200, 100, 100)),
                ("Black", (0, 0, 0), (50, 50, 50)),
                ("White", (255, 255, 255), (230, 230, 230)),
                ("Gray", (135, 135, 135), (145, 145, 145)),
                ("Navy", (0, 0, 128), (50, 50, 180)),
                ("Sky Blue", (135, 206, 235), (100, 180, 220)),
                ("Turquoise", (64, 224, 208), (100, 220, 200)),
                ("Teal", (0, 128, 128), (50, 180, 180)),
                ("Magenta", (255, 0, 255), (255, 50, 255)),
                ("Lavender", (230, 230, 250), (200, 200, 250)),
                ("Gold", (255, 215, 0), (255, 230, 50)),
                ("Silver", (192, 192, 192), (200, 200, 200)),
                ("Beige", (245, 245, 220), (230, 230, 200)),
                ("Maroon", (128, 0, 0), (180, 50, 50)),
                ("Olive", (128, 128, 0), (180, 180, 50)),
                ("Forest Green", (34, 139, 34), (50, 180, 50)),
                ("Lime", (0, 255, 0), (50, 255, 50)),
                ("Cyan", (0, 255, 255), (50, 255, 255)),
                ("Aqua", (0, 128, 128), (50, 180, 180)),
                ("Indigo", (75, 0, 130), (120, 50, 180)),
                ("Violet", (238, 130, 238), (200, 100, 200)),
                ("Pink", (255, 192, 203), (255, 150, 180)),
                ("Light Pink", (255, 182, 193), (255, 160, 180)),
                ("Dark Pink", (197, 27, 125), (220, 70, 150))
            ]

            
            // Check if the given RGB values fall within any of the color ranges
            for (name, colorMin, colorMax) in colors {
                if rgb.0 >= colorMin.0 && rgb.0 <= colorMax.0 &&
                   rgb.1 >= colorMin.1 && rgb.1 <= colorMax.1 &&
                   rgb.2 >= colorMin.2 && rgb.2 <= colorMax.2 {
                    return name
                }
            }
            func distance(a: (Int, Int, Int), b: (Int, Int, Int)) -> Int {
                    let dr = a.0 - b.0
                    let dg = a.1 - b.1
                    let db = a.2 - b.2
                    return dr * dr + dg * dg + db * db
                }

            // If no color range matches, find the closest color by computing the squared Euclidean distance
            var minDistance = Int.max
            var closestColorName: String?
            for (name, color, _) in colors {
                let d = distance(a: rgb, b: color)
                if d < minDistance {
                    minDistance = d
                    closestColorName = name
                }
            }
            return closestColorName
        }

        
        func rgbToHsl(red: Int, green: Int, blue: Int) -> (h: Double, s: Double, l: Double) {
            let r = Double(red) / 255.0
            let g = Double(green) / 255.0
            let b = Double(blue) / 255.0
            
            let maxColor = max(r, max(g, b))
            let minColor = min(r, min(g, b))
            var hue: Double = 0.0
            var saturation: Double = 0.0
            let lightness = (maxColor + minColor) / 2.0
            
            if maxColor == minColor {
                hue = 0.0
                saturation = 0.0
            } else {
                let delta = maxColor - minColor
                saturation = lightness > 0.5 ? delta / (2.0 - maxColor - minColor) : delta / (maxColor + minColor)
                
                if maxColor == r {
                    hue = (g - b) / delta + (g < b ? 6.0 : 0.0)
                } else if maxColor == g {
                    hue = (b - r) / delta + 2.0
                } else {
                    hue = (r - g) / delta + 4.0
                }
                hue *= 60.0
            }
            
            return (h: hue, s: saturation, l: lightness)
        }
        
        func rgbToHex(red: Int, green: Int, blue: Int) -> String {
            let redHex = String(format: "%02X", red)
            let greenHex = String(format: "%02X", green)
            let blueHex = String(format: "%02X", blue)
            return "\(redHex)\(greenHex)\(blueHex)"
        }
        func distanceBetweenPoints(center: CGPoint, point2: CGPoint) -> CGFloat {
            let xDist = point2.x - center.x
            let yDist = point2.y - center.y
            return sqrt((xDist * xDist) + (yDist * yDist))
        }

    }

}

extension UIImage {
    func getPixelColor(x: Int, y: Int) -> (red: Int, green: Int, blue: Int) {
        guard let cgImage = cgImage, let pixelData = cgImage.dataProvider?.data else {
            return (0, 0, 0)
        }
        let data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        let pixelInfo: Int = ((Int(size.width) * y) + x) * 4
        let r = Int(data[pixelInfo])
        let g = Int(data[pixelInfo+1])
        let b = Int(data[pixelInfo+2])
        return (r, g, b)
    }
}

