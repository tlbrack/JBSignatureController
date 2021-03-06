//
//  SignatureView.m
//  JBSignatureControl
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

#import "JBSignatureView.h"



#pragma mark - Private Interface

@interface JBSignatureView ()

@property(nonatomic,retain) NSMutableArray *lines;

-(void)addPoint:(CGPoint)touchLocation toLine:(NSMutableArray*)line;

@end



@implementation JBSignatureView

@synthesize 
lines = lines_,
lineWidth = lineWidth_,
signatureImageMargin = signatureImageMargin_,
shouldCropSignatureImage = shouldCropSignatureImage_,
foreColor = foreColor_;



#pragma mark - Initializers

/**
 * Designated initializer
 **/
- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.lines = [[NSMutableArray alloc] init];
		self.lineWidth = 2.0f;
		self.signatureImageMargin = 10.0f;
		self.shouldCropSignatureImage = YES;
		self.foreColor = [UIColor blackColor];
		self.backgroundColor = [UIColor clearColor];
		lastTapPoint_ = CGPointZero;
    }
    return self;
}

- (void)dealloc {
    [foreColor_ release];
    [lines_ release];
    [super dealloc];
}


#pragma mark - Drawing

/**
 * Main drawing method. We keep an array of touch coordinates to represent
 * the user dragging their finter across the screen. This method loops through
 * those coordinates and draws a line to each. When the user lifts their finger,
 * we insert a CGPointZero object into the array and handle that here.
 **/
- (void)drawRect:(CGRect)rect {
	
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	// Set drawing params
	CGContextSetLineWidth(context, self.lineWidth);
	CGContextSetStrokeColorWithColor(context, [self.foreColor CGColor]);
	CGContextSetLineCap(context, kCGLineCapButt);
	CGContextSetLineJoin(context, kCGLineJoinRound);
	CGContextBeginPath(context);
	
	// This flag tells us to move to the point
	// rather than draw a line to the point
	BOOL isFirstPoint = YES;
	
	// Loop through the strings in the array
	// which are just serialized CGPoints
    for (NSMutableArray *line in self.lines) {
        
        isFirstPoint = YES;
        for (NSString *touchString in line) {
            
            // Unserialize
            CGPoint tapLocation = CGPointFromString(touchString);
            
            // If first point, move to it and continue. Otherwize, draw a line from
            // the last point to this one.
            if (isFirstPoint) {
                CGContextMoveToPoint(context, tapLocation.x, tapLocation.y);
                isFirstPoint = NO;
            } else {
                CGPoint startPoint = CGContextGetPathCurrentPoint(context);
                CGContextAddQuadCurveToPoint(context, startPoint.x, startPoint.y, tapLocation.x, tapLocation.y);
                CGContextAddLineToPoint(context, tapLocation.x, tapLocation.y);
            }
            
        }	
    }
	
	CGContextStrokePath(context);
}

#pragma mark - Touch Handling

/**
 * Not implemented.
 **/
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self];    
    
    // add a new line
    NSMutableArray *newLine = [[[NSMutableArray alloc] init] autorelease];
    [lines_ addObject:newLine];
    
    [self addPoint:touchLocation toLine:newLine];
}

/**
 * This method adds the touch to our array.
 **/
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
	
	UITouch *touch = [touches anyObject];
	CGPoint touchLocation = [touch locationInView:self];
	
    [self addPoint:touchLocation toLine:[lines_ lastObject]];
}

/**
 * Add a CGPointZero to our array to denote the user's finger has been
 * lifted.
 **/
-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
 
    // support points
    if ([[lines_ lastObject] count] == 1) {
        [self addPoint:CGPointMake(lastTapPoint_.x + 1.0, lastTapPoint_.y - 1.0) 
                toLine:[lines_ lastObject]];
    }
}

/**
 * Touches Cancelled.
 **/
-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {

}


#pragma mark - Private Methods

/**
 * Add a point to the line
 */
-(void)addPoint:(CGPoint)touchLocation toLine:(NSMutableArray*)line {
    // keep a point if it is the start of a line or a bit away from the last
    if (line.count < 2 ||
		fabs(touchLocation.x - lastTapPoint_.x) > 2.0f ||
		fabs(touchLocation.y - lastTapPoint_.y) > 2.0f) {
		
		[line addObject:NSStringFromCGPoint(touchLocation)];
		[self setNeedsDisplay];
		lastTapPoint_ = touchLocation;
    }
}

#pragma mark - Public Methods

/**
 * Returns a UIImage with the signature cropped and centered with the margin
 * specified in the signatureImageMargin property.
 **/
-(UIImage *)getSignatureImage {
	
	// Grab the image
	UIGraphicsBeginImageContext(self.bounds.size);
	[self drawRect: self.bounds];
	UIImage *signatureImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	// Stop here if we're not supposed to crop
	if (!self.shouldCropSignatureImage) {
		return signatureImage;
	}
	
	// Crop bound floats
	// Give really high limits to min values so at least one tap
	// location will be set as the minimum...
	float minX = 99999999.0f, minY = 999999999.0f, maxX = 0.0f, maxY = 0.0f;
	
	// Loop through current coordinates to get the crop bounds
    for (NSMutableArray *line in lines_) {
      for (NSString *touchString in line) {
		
		// Unserialize
		CGPoint tapLocation = CGPointFromString(touchString);
		
		// Ignore CGPointZero
		if (CGPointEqualToPoint(tapLocation, CGPointZero)) {
			continue;
		}
		
		// Set boundaries
		if (tapLocation.x < minX) minX = tapLocation.x;
		if (tapLocation.x > maxX) maxX = tapLocation.x;
		if (tapLocation.y < minY) minY = tapLocation.y;
		if (tapLocation.y > maxY) maxY = tapLocation.y;
      }	
	}
	
	// Crop to the bounds (include a margin)
	CGRect cropRect = CGRectMake(minX - lineWidth_ - self.signatureImageMargin,
								 minY - lineWidth_ - self.signatureImageMargin,
								 maxX - minX + (lineWidth_ * 2.0f) + (self.signatureImageMargin * 2.0f), 
								 maxY - minY + (lineWidth_ * 2.0f) + (self.signatureImageMargin * 2.0f));
	CGImageRef imageRef = CGImageCreateWithImageInRect([signatureImage CGImage], cropRect);
	
	// Convert back to UIImage
	UIImage *signatureImageCropped = [UIImage imageWithCGImage:imageRef];
	
	// All done!
	CFRelease(imageRef);
	return signatureImageCropped;
	
}

/**
 * Clears any drawn signature from the screen
 **/
-(void)clearSignature {
	[self.lines removeAllObjects];
	[self setNeedsDisplay];
}

@end
