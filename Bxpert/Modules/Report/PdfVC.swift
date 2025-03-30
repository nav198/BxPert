//
//  PdfVC.swift
//  Bxpert
//
//  Created by Naveen on 27/03/25.
//

import UIKit
import PDFKit

class PDFViewController: UIViewController {
    
    var pdfURL: URL?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        pdfURL = URL(string: ApiURl.pdf.rawValue)
        setupPDFView()
    }

    private func setupPDFView() {
        guard let pdfURL = pdfURL else { return }
        
        let pdfView = PDFView(frame: view.bounds)
        pdfView.autoScales = true
        pdfView.document = PDFDocument(url: pdfURL)
        
        view.addSubview(pdfView)
    }
}
