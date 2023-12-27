//
//  WebViewController.swift
//
//  Created by Md. Mehedi Hasan on 30/5/21.


import UIKit
import WebKit

enum WebSourceType {
    case htmlString
    case url
    case staticHtmlFile
    case dataSource
}

protocol WebViewDataSource {
    func fetchWebData(completionHandler: @escaping (Result<String, Error>) -> Void)
}

class StaticHtmlDataProvider: WebViewDataSource {
    
    let fileName: String
    
    init(fileName: String) {
        self.fileName = fileName
    }
    
    func fetchWebData(completionHandler: @escaping (Result<String, Error>) -> Void) {
        do {
            if let filePath = Bundle.main.path(forResource: fileName, ofType: "html") {
                let content = try String(contentsOfFile: filePath, encoding: .utf8)
                completionHandler(.success(content))
            } else {
                completionHandler(.failure(NSError(domain: "HTML file error", code: 0, userInfo: nil)))
            }
        } catch {
            completionHandler(.failure(NSError(domain: "HTML file error", code: 0, userInfo: nil)))
        }
    }
}

class WebViewController: UIViewController {
    
    let webView = WKWebView()
    
    let activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.frame = CGRect(x: 0, y: 0, width: 44.0, height: 44.0)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.style = .whiteLarge
        activityIndicator.color = .gray
        return activityIndicator
    }()
    
    var sourceType: WebSourceType!
    var htmlString: String?
    var baseURL: URL?
    var dataSource: WebViewDataSource?
    var hrefAnchor: String?
    
    convenience init() {
        self.init(sourceType: .htmlString, url: nil, dataSource: nil)
    }
    
    convenience init(url: URL) {
        self.init(sourceType: .url, url: url, dataSource: nil)
    }
    
    convenience init(dataSource: WebViewDataSource) {
        self.init(sourceType: .dataSource, url: nil, dataSource: dataSource)
    }
    
    private init(sourceType: WebSourceType, url: URL?, dataSource: WebViewDataSource?) {
        self.sourceType = sourceType
        self.baseURL = url
        self.dataSource = dataSource
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK:- ViewController Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        loadWebView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if isModal {
            //Add close button
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icon_close_mono"), style: .done, target: self, action: #selector(closedButtonTapped(_:)))
        }

        if #available(iOS 11.0, *) {
            navigationItem.largeTitleDisplayMode = .never
        }
    }
    
    //MARK:- Helpers
    func setupScene() {
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: nil)
        
        view.backgroundColor = .white
        view.addSubview(webView)
        webView.translatesAutoresizingMaskIntoConstraints = false
        
        webView.edgeAnchors == view.edgeAnchors
        
        // add activity
        webView.navigationDelegate = self
        activityIndicator.center = self.view.center
        webView.addSubview(activityIndicator)
        showActivityIndicator(show: true)
    }
    
    func loadWebView() {

        switch sourceType! {
        case .htmlString:
            if let htmlString = htmlString {
                webView.loadHTMLString(htmlString, baseURL: nil)
            }
        case .url:
            if let url = baseURL {
                webView.load(URLRequest(url: url))
            }
        case .staticHtmlFile:
            webView.loadHTMLString(htmlString!, baseURL: baseURL)
        case .dataSource:
            
            dataSource?.fetchWebData(completionHandler: { [weak self] (result) in
                guard let self = self else { return }
                switch result {
                case .success(let htmlContent):
                    self.webView.loadHTMLString(htmlContent, baseURL: nil)
                case .failure:
                    let errorMessageHtml = Helpers.generateHtml(content: "\(self.title ?? "Information") not found!")
                    self.webView.loadHTMLString(errorMessageHtml, baseURL: nil)
                }
            })
        }
    }
    
    // MARK: - Action
    @objc func closedButtonTapped(_ sender: UIBarButtonItem){
        dismiss(animated: true, completion: nil)
    }
    func showActivityIndicator(show: Bool) {
        if show {
            //activityIndicator.isHidden = false
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
            //activityIndicator.isHidden = true
        }
    }
    
}

extension WebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        //showActivityIndicator(show: true)
    }
    
    func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        showActivityIndicator(show: false)
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        showActivityIndicator(show: false)
        
        //Oneway
        if let hrefAnchor = hrefAnchor, let baseURL = baseURL {
            if let fullURL = URL(string: hrefAnchor, relativeTo: baseURL) {
                webView.load(URLRequest(url: fullURL))
            }
            self.hrefAnchor = nil
        }
        //Anotherway
//        if let hrefAnchor = hrefAnchor {
//            webView.evaluateJavaScript("window.location.href = '" + hrefAnchor + "';", completionHandler: nil)
//            self.hrefAnchor = nil
//        }
        
    }
}
