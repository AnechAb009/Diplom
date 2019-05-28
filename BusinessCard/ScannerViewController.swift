import UIKit
import SugarKit
import AVFoundation
import AudioToolbox
import SuperPuperDuperLayout
import MagicalRecord


class ScannerPresenter: NSObject {
    
    typealias View = ScannerViewController
    weak var view: View?
    
    var found: Bool = false {
        didSet {
            if found {
                AudioServicesPlaySystemSoundWithCompletion(SystemSoundID(1108), nil)
            }
        }
    }
    
    
    let metaDataQueue = DispatchQueue(label: "com.videoMetaData")
    
    lazy var captureDeviceInput: AVCaptureDeviceInput? = {
        guard let videoDevice = AVCaptureDevice.default(for: AVMediaType.video) else { return nil }
        let input = try? AVCaptureDeviceInput(device: videoDevice)
        
        return input
    }()
    
    lazy var captureMetadataOutput: AVCaptureMetadataOutput = {
        let output = AVCaptureMetadataOutput()
        output.setMetadataObjectsDelegate(self, queue: metaDataQueue)
        
        return output
    }()
    
    lazy var captureSession: AVCaptureSession = {
        let captureSession = AVCaptureSession()
        if let aCaptureDeviceInput = captureDeviceInput {
            captureSession.addInput(aCaptureDeviceInput)
        }
        captureSession.addOutput(captureMetadataOutput)
        captureMetadataOutput.metadataObjectTypes = [.qr]
        
        return captureSession
    }()
    
    func interact() {
        
    }
    
    func getKeyVals(from string: String) -> Dictionary<String, String> {
        var results = [String:String]()
        let keyValues = string.components(separatedBy: "&")
        if keyValues.count > 0 {
            for pair in keyValues {
                let kv = pair.components(separatedBy: "=")//.componentsSeparatedByString("=")
                if kv.count > 1 {
                    results.updateValue(kv[1], forKey: kv[0])
                }
            }
            
        }
        return results
    }
    
    func date(from string: String) -> Date? {
        //        let str = "20180419T1823"
        return nil
        
    }
}
//t=20180419T1823&s=76.50&fn=8710000100816026&i=108930&fp=3825702143&n=1
extension ScannerPresenter: AVCaptureMetadataOutputObjectsDelegate {
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        DispatchQueue.main.async { [weak self] in
            if let aliveSelf = self, let metaData = metadataObjects.first as? AVMetadataMachineReadableCodeObject, let contains = aliveSelf.view?.transformedMetadataObject(for: metaData), contains {
                guard aliveSelf.found else {
                    aliveSelf.found = true
                    print("[+] Detected QR Code: \(metaData.stringValue as Any)")
                    
                    if let stringValue = metaData.stringValue, let data = stringValue.data(using: .utf8) {
                        do {
                            let model = try JSONDecoder().decode(BCardModel.self, from: data)
                            self?.view?.delegeta?.save(model)

                        } catch {
                            
                        }
                        self?.view?.dismiss(animated: true, completion: nil)

                    }
                    
//                    if let stringValue = metaData.stringValue,
//                        let data = stringValue.data(using: .utf8),
//                        let json = try? JSONSerialization.jsonObject(with: data, options: []),
//                        let dict = json as? [AnyHashable: Any] {
//                        MagicalRecord.save(blockAndWait: { (context) in
//                            if let user = User.mr_import(from: [dict], in: context).first as? User {
//                                print(user.name as Any)
//                            }
//                        })
//                        //                        DispatchQueue.main.async { [weak self] in
//                        //                        }
//                    }
                    return
                }
            }
        }
    }
}

class ScannerViewController: UIViewController {
    
    var presenter: ScannerPresenter
    weak var delegeta: AddCardViewControllerOut?
    
    lazy var qrFrame = QRFrame()
    
    lazy var qrCaptureView: QRCaptureView = {
        let captureView = QRCaptureView(captureSession: presenter.captureSession)
        return captureView
    }()
    
    init(presenter aPresenter: ScannerPresenter) {
        presenter = aPresenter
        super.init(nibName: nil, bundle: nil)
        presenter.view = self
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        decorate()
        
        requestAccessIfNeeded(with: { [weak self] in
            self?.setupHierarchy()
            self?.setupLayout()
            self?.setupSession()
        })
    }
    
    func transformedMetadataObject(for object: AVMetadataObject) -> Bool {
        let transformed = qrCaptureView.captureVideoPreviewLayer.transformedMetadataObject(for: object)
        if let bounds = transformed?.bounds, qrFrame.frame.contains(bounds) {
            return true
        }
        return false
    }
    
    
    
    //MARK: - Hierarchy
    
    private func setupHierarchy() {
        view.addSubview(qrCaptureView)
        view.addSubview(qrFrame)
        
    }
    
    //MARK: - Layout
    
    private func setupLayout() {
        Layout.to(qrCaptureView) {
            $0.edges.equalToSuperview.value(.zero)
        }
        
        Layout.to(qrFrame) {
            $0.size.equal.value(.init(width: 250, height: 250))
            $0.center.equalToSuperview.value(.zero)
        }
        
    }
    
    //MARK: - Appearance
    
    private func decorate() {
        setupDoneButton()
    }
    
    func setupDoneButton() {
        //        let item = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(done))
        //        navigationItem.rightBarButtonItem = item
        
        let cancel = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(done))
        navigationItem.leftBarButtonItem = cancel
        
    }
    
    @objc func done() {
        dismiss(animated: true, completion: nil)
    }
    
    private func setupSession() {
        presenter.captureSession.startRunning()
    }
    
    private func requestAccessIfNeeded(with completion: @escaping () -> Void) {
        AVCaptureDevice.requestAccess(for: .video, completionHandler: { (granted) in
            if granted {
                DispatchQueue.main.async {
                    completion()
                }
            }
        })
        
    }
}

class QRFrame: UIView {
    
    var strokeColor: UIColor = .white {
        didSet{
            setNeedsDisplay()
        }
    }
    
    private let kCornerWidth = CGFloat(10)
    
    private let kCornerLength = CGFloat(24)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentMode = .redraw
        self.backgroundColor = .clear
        self.isOpaque = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.setStrokeColor(strokeColor.cgColor)
        context.setLineWidth(kCornerWidth)
        context.beginPath()
        
        context.addLines(between: [CGPoint(x: rect.minX, y: rect.minY + kCornerLength), CGPoint(x: rect.minX, y: rect.minY)])
        context.addLines(between: [CGPoint(x: rect.minX, y: rect.minY), CGPoint(x: rect.minX + kCornerLength, y: rect.minY)])
        
        context.addLines(between: [CGPoint(x: rect.maxX - kCornerLength, y: rect.minY), CGPoint(x: rect.maxX, y: rect.minY)])
        context.addLines(between: [CGPoint(x: rect.maxX, y: rect.minY), CGPoint(x: rect.maxX, y: rect.minY + kCornerLength)])
        
        context.addLines(between: [CGPoint(x: rect.maxX, y: rect.maxY - kCornerLength), CGPoint(x: rect.maxX, y: rect.maxY)])
        context.addLines(between: [CGPoint(x: rect.maxX, y: rect.maxY), CGPoint(x: rect.maxX - kCornerLength, y: rect.maxY)])
        
        context.addLines(between: [CGPoint(x: rect.minX + kCornerLength, y: rect.maxY), CGPoint(x: rect.minX, y: rect.maxY)])
        context.addLines(between: [CGPoint(x: rect.minX, y: rect.maxY), CGPoint(x: rect.minX, y: rect.maxY - kCornerLength)])
        
        context.closePath()
        context.strokePath()
    }
}

extension UIColor {
    
    convenience init(r: Int, g: Int, b: Int, a: Float) {
        self.init(red: CGFloat(r) / CGFloat(255), green: CGFloat(g) / CGFloat(255), blue: CGFloat(b) / CGFloat(255), alpha: CGFloat(a))
    }
    
}


extension UIColor {
    
    static var url: UIColor {
        return UIColor(r: 66, g: 111, b: 161, a: 1.0)
    }
    
    static var hashTag: UIColor {
        return url
    }
    
    static var darkRedColor: UIColor {
        return UIColor(r: 213, g: 42, b: 58, a: 1.0)
    }
    
    static var navigationBar: UIColor {
        return UIColor(r: 84, g: 199, b: 252, a: 1.0)
    }
    
    
}

public extension UIImage {
    
    public class func imageFromColor(_ color: UIColor) -> UIImage {
        return self.imageFromColor(color, with: CGSize(width: 1, height: 1))
    }
    
    
    public class func imageFromColor(_ color: UIColor, with size: CGSize) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let returnedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return returnedImage!
    }
    
}

class QRCaptureView: UIView {
    var captureSession: AVCaptureSession
    
    lazy var captureVideoPreviewLayer: AVCaptureVideoPreviewLayer = {
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        previewLayer.frame = bounds
        return previewLayer
    }()
    
    init(captureSession aCaptureSession: AVCaptureSession) {
        captureSession = aCaptureSession
        super.init(frame: .zero)
        
        setupHierarchy()
    }
    
    @available(*, unavailable) required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        captureVideoPreviewLayer.frame = bounds
    }
    
    private func setupHierarchy() {
        layer.insertSublayer(captureVideoPreviewLayer, at: 0)
    }
    
}
