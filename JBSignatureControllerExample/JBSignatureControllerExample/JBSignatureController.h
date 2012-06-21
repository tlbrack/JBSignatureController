//
//  JBSignatureController.h
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

#import <UIKit/UIKit.h>
#import "JBSignatureView.h"

@protocol JBSignatureControllerDelegate;



@interface JBSignatureController : UIViewController {
	JBSignatureView *signatureView_;
	UIImageView *signaturePanelBackgroundImageView_;
	UIImage *portraitBackgroundImage_, *landscapeBackgroundImage_;
	UIButton *confirmButton_, *cancelButton_, *clearButton_;
	id<JBSignatureControllerDelegate> delegate_;
}

// Allows you to set th background images in different states
@property(nonatomic,retain) UIImage *portraitBackgroundImage, *landscapeBackgroundImage;

// Buttons for confirm and cancel
@property(nonatomic,retain) UIButton *confirmButton, *cancelButton, *clearButton;

// Delegate
@property(nonatomic,assign) id<JBSignatureControllerDelegate> delegate;

// Clear the signature
-(void)clearSignature;

@end



// Delegate Protocol
@protocol JBSignatureControllerDelegate <NSObject>

@required

// Called when the user clicks the confirm button
-(void)signatureConfirmed:(UIImage *)signatureImage signatureController:(JBSignatureController *)sender;

@optional

// Called when the user clicks the cancel button
-(void)signatureCancelled:(JBSignatureController *)sender;

// Called when the user clears their signature or when clearSignature is called.
-(void)signatureCleared:(UIImage *)clearedSignatureImage signatureController:(JBSignatureController *)sender;

@end