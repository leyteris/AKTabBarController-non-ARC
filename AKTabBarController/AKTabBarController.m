// AKTabBarController.m
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

#import "AKTabBarController.h"
#import "UIViewController+AKTabBarController.h"

// Default height of the tab bar
static const int kDefaultTabBarHeight = 50;

// Default Push animation duration
static const float kPushAnimationDuration = 0.35;

@interface AKTabBarController ()
{
    BOOL visible;
}

typedef enum {
    AKShowHideFromLeft,
    AKShowHideFromRight
} AKShowHideFrom;

@property (nonatomic, retain) NSArray          *prevViewControllers;

- (void)loadTabs;
- (void)showTabBar:(AKShowHideFrom)showHideFrom animated:(BOOL)animated;
- (void)hideTabBar:(AKShowHideFrom)showHideFrom animated:(BOOL)animated;

@end

@implementation AKTabBarController
{
    // Bottom tab bar view
    AKTabBar *tabBar;
    
    // Content view
    AKTabBarView *tabBarView;
    
    // Tab Bar height
    NSUInteger tabBarHeight;
}

- (void)dealloc
{
    self.viewControllers = nil;
    self.iconColors = nil;
    self.iconShadowColor = nil;
    self.selectedIconColors = nil;
    self.selectedIconOuterGlowColor = nil;
    self.tabColors = nil;
    self.selectedTabColors = nil;
    self.tabStrokeColor = nil;
    self.tabInnerStrokeColor = nil;
    self.tabEdgeColor = nil;
    self.topEdgeColor = nil;
    self.backgroundImageName = nil;
    self.selectedBackgroundImageName = nil;
    self.textColor = nil;
    self.selectedTextColor = nil;
    self.selectedViewController = nil;
    self.prevViewControllers = nil;
    
    [tabBar release];
    tabBar = nil;
    [tabBarView release];
    tabBarView = nil;
    
    [super dealloc];
}

#pragma mark - Initialization

- (id)init
{    
    return [self initWithTabBarHeight:kDefaultTabBarHeight];
}

- (id)initWithTabBarHeight:(NSUInteger)height
{
    self = [super init];
    if (!self) return nil;
    
    tabBarHeight = height;
    
    // default settings
    _iconShadowOffset = CGSizeMake(0, -1);
    
    return self;
}

- (void)loadView
{
    [super loadView];
    
    // Creating and adding the tab bar view
    tabBarView = [[AKTabBarView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
    self.view = tabBarView;
    
    // Creating and adding the tab bar
    CGRect tabBarRect = CGRectMake(0.0, CGRectGetHeight(self.view.bounds) - tabBarHeight, CGRectGetWidth(self.view.frame), tabBarHeight);
    tabBar = [[AKTabBar alloc] initWithFrame:tabBarRect];
    tabBar.delegate = self;
    
    tabBarView.tabBar = tabBar;
    tabBarView.contentView = _selectedViewController.view;
    [[self navigationItem] setTitle:[_selectedViewController title]];
    [self loadTabs];
}

- (void)loadTabs
{
    NSMutableArray *tabs = [[[NSMutableArray alloc] init] autorelease];
    for (UIViewController *vc in self.viewControllers)
    {
        [[tabBarView tabBar] setBackgroundImageName:[self backgroundImageName]];
        [[tabBarView tabBar] setTabColors:[self tabCGColors]];
        [[tabBarView tabBar] setEdgeColor:[self tabEdgeColor]];
        [[tabBarView tabBar] setTopEdgeColor:[self topEdgeColor]];
        
        AKTab *tab = [[[AKTab alloc] init] autorelease];
        [tab setTabImageWithName:[vc tabImageName]];
        [tab setBackgroundImageName:[self backgroundImageName]];
        [tab setSelectedBackgroundImageName:[self selectedBackgroundImageName]];
        [tab setTabIconColors:[self iconCGColors]];
        [tab setTabIconShadowColor:[self iconShadowColor]];
        [tab setTabIconShadowOffset:[self iconShadowOffset]];
        [tab setTabIconColorsSelected:[self selectedIconCGColors]];
        [tab setTabIconOuterGlowColorSelected:[self selectedIconOuterGlowColor]];
        [tab setTabSelectedColors:[self selectedTabCGColors]];
        [tab setEdgeColor:[self tabEdgeColor]];
        [tab setTopEdgeColor:[self topEdgeColor]];
        [tab setGlossyIsHidden:[self iconGlossyIsHidden]];
        [tab setStrokeColor:[self tabStrokeColor]];
        [tab setInnerStrokeColor:[self tabInnerStrokeColor]];
        [tab setTextColor:[self textColor]];
        [tab setSelectedTextColor:[self selectedTextColor]];
        [tab setTabTitle:[vc tabTitle]];
        
        [tab setTabBarHeight:tabBarHeight];
        
        if (_minimumHeightToDisplayTitle)
            [tab setMinimumHeightToDisplayTitle:_minimumHeightToDisplayTitle];
        
        if (_tabTitleIsHidden)
            [tab setTitleIsHidden:YES];
        
        if ([[vc class] isSubclassOfClass:[UINavigationController class]])
            ((UINavigationController *)vc).delegate = self;
        
        [tabs addObject:tab];
    }
    
    [tabBar setTabs:tabs];
    
    // Setting the first view controller as the active one
    [tabBar setSelectedTab:[tabBar.tabs objectAtIndex:0]];
}

- (NSArray *) selectedIconCGColors
{
    return _selectedIconColors ? @[(id)[[_selectedIconColors objectAtIndex:0] CGColor], (id)[[_selectedIconColors objectAtIndex:1] CGColor]] : nil;
}

- (NSArray *) iconCGColors
{
    return _iconColors ? @[(id)[[_iconColors objectAtIndex:0] CGColor], (id)[[_iconColors objectAtIndex:1] CGColor]] : nil;
}

- (NSArray *) tabCGColors
{
    return _tabColors ? @[(id)[[_tabColors objectAtIndex:0] CGColor], (id)[[_tabColors objectAtIndex:1] CGColor]] : nil;
}

- (NSArray *) selectedTabCGColors
{
    return _selectedTabColors ? @[(id)[[_selectedTabColors objectAtIndex:0] CGColor], (id)[[_selectedTabColors objectAtIndex:1] CGColor]] : nil;
}

#pragma - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (!self.prevViewControllers) {
        self.prevViewControllers = [navigationController viewControllers];
    }
    
    
    // We detect is the view as been push or popped
    BOOL pushed;
    
    if ([self.prevViewControllers count] <= [[navigationController viewControllers] count])
        pushed = YES;
    else
        pushed = NO;
    
    // Logic to know when to show or hide the tab bar
    BOOL isPreviousHidden, isNextHidden;
    
    isPreviousHidden = [[self.prevViewControllers lastObject] hidesBottomBarWhenPushed];
    isNextHidden = [viewController hidesBottomBarWhenPushed];
    
    self.prevViewControllers = [navigationController viewControllers];
    
    if (!isPreviousHidden && !isNextHidden)
        return;
    
    else if (!isPreviousHidden && isNextHidden)
        [self hideTabBar:(pushed ? AKShowHideFromRight : AKShowHideFromLeft) animated:animated];
    
    else if (isPreviousHidden && !isNextHidden)
        [self showTabBar:(pushed ? AKShowHideFromRight : AKShowHideFromLeft) animated:animated];
    
    else if (isPreviousHidden && isNextHidden)
        return;
}

- (void)showTabBar:(AKShowHideFrom)showHideFrom animated:(BOOL)animated
{
    
    CGFloat directionVector;
    
    switch (showHideFrom) {
        case AKShowHideFromLeft:
            directionVector = -1.0;
            break;
        case AKShowHideFromRight:
            directionVector = 1.0;
            break;
        default:
            break;
    }
    
    tabBar.hidden = NO;
    tabBar.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds) * directionVector, 0);
    // when the tabbarview is resized we can see the view behind
    
    [UIView animateWithDuration:((animated) ? kPushAnimationDuration : 0) animations:^{
        tabBar.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        tabBarView.isTabBarHidding = NO;
        [tabBarView setNeedsLayout];
    }];
}

- (void)hideTabBar:(AKShowHideFrom)showHideFrom animated:(BOOL)animated
{
    
    CGFloat directionVector;
    switch (showHideFrom) {
        case AKShowHideFromLeft:
            directionVector = 1.0;
            break;
        case AKShowHideFromRight:
            directionVector = -1.0;
            break;
        default:
            break;
    }
    
    tabBarView.isTabBarHidding = YES;
    
    CGRect tmpTabBarView = tabBarView.contentView.frame;
    tmpTabBarView.size.height = tabBarView.bounds.size.height;
    tabBarView.contentView.frame = tmpTabBarView;
    
    [UIView animateWithDuration:((animated) ? kPushAnimationDuration : 0) animations:^{
        tabBar.transform = CGAffineTransformMakeTranslation(CGRectGetWidth(self.view.bounds) * directionVector, 0);
    } completion:^(BOOL finished) {
        tabBar.hidden = YES;
        tabBar.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark - Setters

- (void)setViewControllers:(NSMutableArray *)viewControllers
{
    if(_viewControllers != nil)
       [_viewControllers release];
    _viewControllers = [viewControllers retain];
    
    // When setting the view controllers, the first vc is the selected one;
    if(_viewControllers != nil && _viewControllers.count != 0) {
        [self setSelectedViewController:[_viewControllers objectAtIndex:0]];
    }
}

- (void)setSelectedViewController:(UIViewController *)selectedViewController
{
    UIViewController *previousSelectedViewController = selectedViewController;
    if (_selectedViewController != selectedViewController) {
        [_selectedViewController autorelease];
        _selectedViewController = [selectedViewController retain];
        
        if ((self.childViewControllers == nil || !self.childViewControllers.count) && visible) {
			[previousSelectedViewController viewWillDisappear:NO];
			[selectedViewController viewWillAppear:NO];
		}
        [tabBarView setContentView:selectedViewController.view];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] < 5.0) {
            if([selectedViewController respondsToSelector:@selector(viewDidLayoutSubviews)]) {
                [selectedViewController performSelector:@selector(viewDidLayoutSubviews)];
            }
        }
        if ((self.childViewControllers == nil || !self.childViewControllers.count) && visible) {
			[previousSelectedViewController viewDidDisappear:NO];
			[selectedViewController viewDidAppear:NO];
		}
        
        [tabBar setSelectedTab:[tabBar.tabs objectAtIndex:[self.viewControllers indexOfObject:selectedViewController]]];
    }
}


#pragma mark - Required Protocol Method

- (void)tabBar:(AKTabBar *)AKTabBarDelegate didSelectTabAtIndex:(NSInteger)index
{
    UIViewController *vc = [self.viewControllers objectAtIndex:index];
    
    if (self.selectedViewController == vc)
    {
        if ([vc isKindOfClass:[UINavigationController class]])
            [(UINavigationController *)self.selectedViewController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [[self navigationItem] setTitle:[vc title]];
        self.selectedViewController = vc;
    }
}

#pragma mark - Rotation Events

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return [self.selectedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.selectedViewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    // Redraw with will rotating and keeping the aspect ratio
    for (AKTab *tab in [tabBar tabs])
        [tab setNeedsDisplay];
    
    [self.selectedViewController willAnimateRotationToInterfaceOrientation:interfaceOrientation duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.selectedViewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

#pragma mark - ViewController Life cycle

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
    if ((self.childViewControllers == nil || !self.childViewControllers.count))
        [self.selectedViewController viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
    
    if ((self.childViewControllers == nil || !self.childViewControllers.count))
        [self.selectedViewController viewDidAppear:animated];
    
    visible = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
    
    if ((self.childViewControllers == nil || !self.childViewControllers.count))
        [self.selectedViewController viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
    
    if (![self respondsToSelector:@selector(addChildViewController:)])
        [self.selectedViewController viewDidDisappear:animated];
    
    visible = NO;
}

@end