// AKTabBarController.h
//
// Copyright (c) 2012 Ali Karagoz (http://alikaragoz.net)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#import "AKTabBarView.h"
#import "AKTabBar.h"
#import "AKTab.h"

@interface AKTabBarController : UIViewController <AKTabBarDelegate, UINavigationControllerDelegate>

// View Controllers handled by the tab bar controller.
@property (nonatomic, retain) NSMutableArray *viewControllers;

// This is the minimum height to display the title.
@property (nonatomic, assign) CGFloat minimumHeightToDisplayTitle;

// Used to show / hide the tabs title.
@property (nonatomic, assign) BOOL tabTitleIsHidden;

// Tabs icon colors.
@property (nonatomic, retain) NSArray *iconColors;

// Tabs icon shadow color
@property (nonatomic, retain) UIColor *iconShadowColor;

// Tabs icon shadow offset
@property (nonatomic) CGSize iconShadowOffset;

// Tabs selected icon colors.
@property (nonatomic, retain) NSArray *selectedIconColors;

// Tabs outer glow icon color
@property (nonatomic, retain) UIColor *selectedIconOuterGlowColor;

// Tabs selected colors.
@property (nonatomic, retain) NSArray *tabColors;

// Tabs selected colors.
@property (nonatomic, retain) NSArray *selectedTabColors;

// Tabs icon glossy show / hide
@property (nonatomic, assign) BOOL iconGlossyIsHidden;

// Tab stroke Color
@property (nonatomic, retain) UIColor *tabStrokeColor;

// Tab inner stroke Color
@property (nonatomic, retain) UIColor *tabInnerStrokeColor;

// Tab top embos Color
@property (nonatomic, retain) UIColor *tabEdgeColor;

// Tab bar top embos Color. optional, default to tabEdgeColor
@property (nonatomic, retain) UIColor *topEdgeColor;

// Tab background image
@property (nonatomic, retain) NSString *backgroundImageName;

// Tab selected background image
@property (nonatomic, retain) NSString *selectedBackgroundImageName;

// Tab text color
@property (nonatomic, retain)  UIColor *textColor;

// Tab selected text color
@property (nonatomic, retain)  UIColor *selectedTextColor;

// Current active view controller
@property (nonatomic, retain) UIViewController *selectedViewController;

// Initialization with a specific height.
- (id)initWithTabBarHeight:(NSUInteger)height;

@end
