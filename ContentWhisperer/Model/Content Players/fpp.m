//
//  fpp.m
//  ContentWhisperer
//
//  Created by Colin Wilson on 21/11/2019.
//  Copyright © 2019 Colin Wilson. All rights reserved.
//

#import <Foundation/Foundation.h>

void DrawTravelBrochure(CGContextRef cgContext, CGRect viewBounds)
{
    CGFloat backgroundColor[] = { 0.7, 1.0 };
    CGColorSpaceRef grayColorSpace = CGColorSpaceCreateWithName(kCGColorSpaceGenericGray);     /* draw the background color */
    CGContextSetFillColorSpace(cgContext, grayColorSpace);
    CGContextSetFillColor(cgContext, backgroundColor);
    CGContextAddRect(cgContext, viewBounds);
    CGContextFillPath(cgContext);     // Adjust the origin for the rest of the image
    CGContextTranslateCTM(cgContext,CGRectGetMidX(viewBounds), viewBounds.origin.y + viewBounds.size.height / 8.0);
    // Grab a reference to the PDF file
    CFURLRef pdfURL = CFBundleCopyResourceURL(CFBundleGetMainBundle(), CFSTR("TravelBrochure"), CFSTR("pdf"), NULL);
    // Create a CGPDFDocument from it
    CGPDFDocumentRef pdfDocument = CGPDFDocumentCreateWithURL(pdfURL);
    
    // Count the number of pages in the document and calculate
    // a rotation angle from it
    
    size_t numPages = CGPDFDocumentGetNumberOfPages(pdfDocument);
    float angleStep = pi / (3.0 * (float)numPages);
    
    // Calculate a "nice" size for the page
    for(short pageCtr = numPages; pageCtr > 0; pageCtr--) {
        // Draw the current page
        CGPDFPageRef currentPage = CGPDFDocumentGetPage(pdfDocument, pageCtr);
        
        // Run a simple calculation to get a suggested drawingRect
        
        CGRect mediaBox = CGPDFPageGetBoxRect(currentPage, kCGPDFMediaBox);
        float suggestedHeight = viewBounds.size.height * 2.0 / 3.0;
        CGRect suggestedPageRect = CGRectMake(0, 0, suggestedHeight * (mediaBox.size.width / mediaBox.size.height), suggestedHeight);
        CGContextSaveGState(cgContext);
        
        // Calculate the transform to position the page
        CGAffineTransform pageTransform = CGPDFPageGetDrawingTransform(currentPage, kCGPDFMediaBox, suggestedPageRect, 0, true);
        CGContextConcatCTM(cgContext, pageTransform);
        
        // Erase a rectangle with a shadow where the page will go
        CGContextSaveGState(cgContext);
        CGContextSetShadow(cgContext, CGSizeMake(8, 8), 5);
        CGContextAddRect(cgContext, mediaBox);
        CGContextFillPath(cgContext);
        CGContextRestoreGState(cgContext);
        
        // Draw the PDF page
        CGContextDrawPDFPage(cgContext, currentPage);
        
        // Draw a frame around the page
        CGContextAddRect(cgContext, mediaBox);
        CGContextStrokePath(cgContext);
        CGContextRestoreGState(cgContext);
        CFRelease(currentPage);
        currentPage = NULL;
        CGContextRotateCTM(cgContext, angleStep);     } }
