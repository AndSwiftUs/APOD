import UIKit

final class APODView: UIView {
    
    lazy var zoomView = UIScrollView()
    lazy var imageView = UIImageView()
    lazy var imageNameLabel = UILabel()
    lazy var imageTextScrollingView = UIScrollView()
    lazy var imageTextLabel = UILabel()
    
    init() {
        super.init(frame: .zero)
        
        addSubviews()
        setUpConstraints()
        setUpViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func addSubviews() {
        
        zoomView.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        imageTextScrollingView.addSubview(imageTextLabel)
        imageTextLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let subviews = [ zoomView, imageNameLabel, imageTextScrollingView]
        
        subviews.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
    }
    
    private func setUpViews() {
                        
        zoomView.bounces = true
        zoomView.minimumZoomScale = 1
        zoomView.maximumZoomScale = 3
        zoomView.showsHorizontalScrollIndicator = false
        zoomView.showsVerticalScrollIndicator = false
        zoomView.delegate = self
        zoomView.isUserInteractionEnabled = true
        
        imageView.contentMode = UIView.ContentMode.scaleAspectFit
        
        imageNameLabel.textAlignment = .center
        imageNameLabel.adjustsFontSizeToFitWidth = true
        imageNameLabel.numberOfLines = 2
        imageNameLabel.font = UIFont.boldSystemFont(ofSize: 18)
        
        imageNameLabel.clipsToBounds = true
        imageNameLabel.layer.cornerRadius = 4
        
        imageTextLabel.textAlignment = .center
        imageTextLabel.numberOfLines = 100
        imageTextLabel.font = UIFont.systemFont(ofSize: UIFont.smallSystemFontSize)
        
        let doubleTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap(_:)))
        doubleTapRecognizer.numberOfTapsRequired = 2
        zoomView.addGestureRecognizer(doubleTapRecognizer)
    }
    
    @objc private func handleDoubleTap(_ sender: UITapGestureRecognizer) {
        if zoomView.zoomScale == 1 {
            zoomView.setZoomScale(3, animated: true)
        } else {
            zoomView.setZoomScale(1, animated: true)
        }
    }
    
    private func setUpConstraints() {
        NSLayoutConstraint.activate([
            
            imageNameLabel.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            imageNameLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageNameLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 8/10),
            
            zoomView.topAnchor.constraint(equalTo: imageNameLabel.bottomAnchor),
            zoomView.centerXAnchor.constraint(equalTo: centerXAnchor),
            zoomView.widthAnchor.constraint(equalTo: widthAnchor, constant: -AppConstants.defaultPaggin),
            zoomView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 6/10),

            imageView.topAnchor.constraint(equalTo: zoomView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: zoomView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: zoomView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: zoomView.trailingAnchor),
            imageView.centerYAnchor.constraint(equalTo: zoomView.centerYAnchor),
            imageView.centerXAnchor.constraint(equalTo: zoomView.centerXAnchor),
            
            imageTextScrollingView.topAnchor.constraint(equalTo: zoomView.bottomAnchor),
            imageTextScrollingView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            imageTextScrollingView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageTextScrollingView.widthAnchor.constraint(equalTo: widthAnchor),
            
            imageTextLabel.topAnchor.constraint(equalTo: imageTextScrollingView.topAnchor),
            imageTextLabel.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 9/10),
            imageTextLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageTextLabel.bottomAnchor.constraint(equalTo: imageTextScrollingView.bottomAnchor),
            
        ])
    }
}

extension APODView: UIScrollViewDelegate {
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
}
