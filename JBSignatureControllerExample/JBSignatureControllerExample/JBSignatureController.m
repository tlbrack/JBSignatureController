//
//  JBSignatureController.m
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

#import "JBSignatureController.h"




#pragma mark - Private Interface

@interface JBSignatureController()

// The view responsible for handling signature sketching
@property(nonatomic,retain) JBSignatureView *signatureView;

// The background image underneathe the sketch
@property(nonatomic,retain) UIImageView *signaturePanelBackgroundImageView;

// Private Methods
-(void)didTapConfirmButton;
-(void)didTapCancelButton;
-(void)didTapClearButton;

@end



@implementation JBSignatureController

@synthesize
signaturePanelBackgroundImageView = signaturePanelBackgroundImageView_,
signatureView = signatureView_,
portraitBackgroundImage = portraitBackgroundImage_,
landscapeBackgroundImage = landscapeBackgroundImage_,
confirmButton = confirmButton_,
cancelButton = cancelButton_,
clearButton = clearButton_,
delegate = delegate_;



#pragma mark - Init & Dealloc

/**
 * Designated initializer
 **/
-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
	}
	
	return self;
	
}

/**
 * Initializer
 **/
-(id)init {
	return [self initWithNibName:nil bundle:nil];
}

-(void)dealloc {
    [portraitBackgroundImage_ release];
    [landscapeBackgroundImage_ release];
    [confirmButton_ release];
    [cancelButton_ release];
    [clearButton_ release];
    [signatureView_ release];
    [signaturePanelBackgroundImageView_ release];
    [super dealloc];
}



#pragma mark - View Lifecycle

/**
 * Since we're not using a nib. We need to load our views manually.
 **/
-(void)loadView {
	
	self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
	
	// Background images
	self.portraitBackgroundImage = [UIImage imageNamed:@"bg-signature-portrait"];
	self.landscapeBackgroundImage = [UIImage imageNamed:@"bg-signature-landscape"];
	self.signaturePanelBackgroundImageView = [[UIImageView alloc] initWithImage:self.portraitBackgroundImage];
	
	// Signature view
	self.signatureView = [[JBSignatureView alloc] init];
	
	// Confirm
	self.confirmButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.confirmButton setTitle:@"Confirm" forState:UIControlStateNormal];
	[self.confirmButton sizeToFit];
	[self.confirmButton setFrame:CGRectMake(self.view.frame.size.width - self.confirmButton.frame.size.width - 10.0f, 
											10.0f, 
											self.confirmButton.frame.size.width, 
											self.confirmButton.frame.size.height)];
	[self.confirmButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin];
	
	// Cancel
	self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.cancelButton setTitle:@"Cancel" forState:UIControlStateNormal];
	[self.cancelButton sizeToFit];
	[self.cancelButton setFrame:CGRectMake(10.0f, 
										   10.0f, 
										   self.cancelButton.frame.size.width, 
										   self.cancelButton.frame.size.height)];
	[self.cancelButton setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin];
    
    // Clear
    self.clearButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [self.clearButton sizeToFit];
    [self.clearButton setFrame:CGRectMake(self.view.frame.size.width/2.0f - self.clearButton.frame.size.width/2.0f,
                                          10.0f, 
                                          self.clearButton.frame.size.width, 
                                          self.clearButton.frame.size.height)];
    [self.clearButton setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
}

/**
 * Setup the view heirarchy
 **/
-(void)viewDidLoad {
	
	// Background Image
	[self.signaturePanelBackgroundImageView setFrame:self.view.bounds];
	[self.signaturePanelBackgroundImageView setContentMode:UIViewContentModeTopLeft];
	[self.view addSubview:self.signaturePanelBackgroundImageView];
	
	// Signature View
	[self.signatureView setFrame:self.view.bounds];
	[self.view addSubview:self.signatureView];
	
	// Buttons
	[self.view addSubview:self.cancelButton];
	[self.view addSubview:self.confirmButton];
    [self.view addSubview:self.clearButton];
	
	// Button actions
    [self.confirmButton addTarget:self action:@selector(didTapConfirmButton) forControlEvents:UIControlEventTouchUpInside];
	[self.cancelButton addTarget:self action:@selector(didTapCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [self.clearButton addTarget:self action:@selector(didTapClearButton) forControlEvents:UIControlEventTouchUpInside];	
}

/**
 * Support for different orientations
 **/
-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation { 	
	return YES;
}

/**
 * Upon rotation, switch out the background image
 **/
-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
		toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
		[self.signaturePanelBackgroundImageView setImage:self.landscapeBackgroundImage];
	} else {
		[self.signaturePanelBackgroundImageView setImage:self.portraitBackgroundImage];
	}
	
}

/**
 * After rotation, we need to adjust the signature view's frame to fill.
 **/
-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	[self.signatureView setFrame:self.view.bounds];
	[self.signatureView setNeedsDisplay];
}


#pragma mark - Actions

/**
 * Upon confirmation, message the delegate with the image of the signature.
 **/
-(void)didTapConfirmButton {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(signatureConfirmed:signatureController:)]) {
		UIImage *signatureImage = [self.signatureView getSignatureImage];
		[self.delegate signatureConfirmed:signatureImage signatureController:self];
	}
	
}

/**
 * Upon cancellation, message the delegate.
 **/
-(void)didTapCancelButton {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(signatureCancelled:)]) {
		[self.delegate signatureCancelled:self];
	}
	
}

/**
 * Upon clear, message the delegate.
 */
-(void)didTapClearButton {
    [self clearSignature];
}

#pragma mark - Public Methods

/**
 * Clears the signature from the signature view. If the delegate is subscribed,
 * this method also messages the delegate with the image before it's cleared.
 **/
-(void)clearSignature {
	
	if (self.delegate && [self.delegate respondsToSelector:@selector(signatureCleared:signatureController:)]) {
		UIImage *signatureImage = [self.signatureView getSignatureImage];
		[self.delegate signatureCleared:signatureImage signatureController:self];
	}
	
	[self.signatureView clearSignature];
}


@end
