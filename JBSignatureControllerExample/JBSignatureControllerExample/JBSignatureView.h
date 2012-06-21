//
//  JBSignatureView.h
//  JBSignatureController
//
//  Created by Jesse Bunch on 12/10/11.
//  Travis Brack
//   added MIT license blurb according to license specified 
//   on https://github.com/bunchjesse/JBSignatureController 6/20/2012
//
//  Copyright (c) 2011 Jesse Bunch. All rights reserved.
//  Permission is hereby granted, free of charge, to any person obtaining 
//  a copy of this software and associated documentation files (the "Software"), 
//  to deal in the Software without restriction, including without limitation the 
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
//  copies of the Software, and to permit persons to whom the Software is furnished 
//  to do so, subject to the following conditions:

//  The above copyright notice and this permission notice shall be included in all 
//  copies or substantial portions of the Software.

//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
//  INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A 
//  PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
//  HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION 
//  OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE 
//  SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// TODO: support dots
// TODO: improve width of lines -- quite blocky as is

#import <UIKit/UIKit.h>

@interface JBSignatureView : UIView {
    NSMutableArray *handwritingCoords_;
    UIImage *currentSignatureImage_;
	float lineWidth_;
	float signatureImageMargin_;
	BOOL shouldCropSignatureImage_;
	UIColor *foreColor_;
	CGPoint lastTapPoint_;
}

// Sets the stroke width
@property(nonatomic) float lineWidth;

// The stroke color
@property(nonatomic,retain) UIColor *foreColor;

// When you get the signature UIIMage, this var
// lets you wrap a point margin around the image.
@property(nonatomic) float signatureImageMargin;

// If YES, the control will crop and center the signature
@property(nonatomic) BOOL shouldCropSignatureImage;



// Returns the signature as a UIImage
-(UIImage *)getSignatureImage;

// Clears the signature from the screen
-(void)clearSignature;

@end
