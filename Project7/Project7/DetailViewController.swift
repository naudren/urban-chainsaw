import UIKit
import WebKit

class DetailViewController: UIViewController {
    var webView: WKWebView!
    var detailItem: [String: String]!
    
    override func loadView() {
        webView = WKWebView()
        view = webView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard detailItem != nil else { return }
        
        if let body = detailItem["body"], title = detailItem["title"], sigs = detailItem["sigs"], sigsNeeded = detailItem["sigsNeeded"]{
            var html = "<html>"
            html += "<head>"
            html += "<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">"
            html += "<style>"
            html += "header {text-align:center;padding:10px;}"
            html += "section { font-size: 150%; padding:30px}"
            html += "footer { text-align:center; font-size: 200%; color: blue}"
            html += "</style>"
            html += "</head>"
            html += "<body>"
            html += "<header><h1>"
            html += title
            html += "</h1></header>"
            html += "<section><p>"
            html += body
            html += "</p></section>"
            html += "<footer>"
            html += "Signatures: \(sigs)<br>Signatures Needed: \(sigsNeeded)"
            html += "</footer>"
            html += "</body>"
            html += "</html>"
            webView.loadHTMLString(html, baseURL: nil)
        }
    }
}