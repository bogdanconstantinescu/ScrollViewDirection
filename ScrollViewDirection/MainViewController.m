//
//  MainViewController.m
//  ScrollViewDirection
//
//  Created by Bogdan Constantinescu on 29/08/14.
//  Copyright (c) 2014 Bogdan Constantinescu. All rights reserved.
//

#import "MainViewController.h"
#import "ArrowView.h"

#pragma mark - Scroll direction

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionCrazy,
    ScrollDirectionLeft,
    ScrollDirectionRight,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionHorizontal,
    ScrollDirectionVertical
} ScrollDirection;

#pragma mark - MainViewController interface

@interface MainViewController ()

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

// scrollView initial offset
@property (nonatomic, assign) CGPoint initialContentOffset;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Setup scrollView

- (void)setupScrollView
{
    // always bounce the scrollView so we can scroll past it's size
    _scrollView.alwaysBounceVertical = YES;
    _scrollView.alwaysBounceHorizontal = YES;
    
    _scrollView.backgroundColor = [UIColor whiteColor];
    
    // only allow scrolling in one direction (up/down or left/right)
    _scrollView.directionalLockEnabled = YES;
    
    // set the UIScrollViewDelegate
    _scrollView.delegate = self;
    
    [self addArrows];
}

- (void)addArrows
{
    // top arrow
    CGRect topArrowFrame = CGRectMake(
                                      CGRectGetMidX(_scrollView.bounds) - 25,
                                      CGRectGetMinY(_scrollView.bounds) - 50,
                                      50.f,
                                      50.f);
    
    ArrowView *topArrowView = [[ArrowView alloc] initWithFrame: topArrowFrame];
    [_scrollView addSubview: topArrowView];
    
    // bottom arrow
    CGRect bottomArrowFrame = CGRectMake(
                                         CGRectGetMidX(_scrollView.bounds) - 25,
                                         CGRectGetMaxY(_scrollView.bounds),
                                         50.f,
                                         50.f);
    
    ArrowView *bottomArrowView = [[ArrowView alloc] initWithFrame: bottomArrowFrame];
    [bottomArrowView rotate: 180.f];
    [_scrollView addSubview: bottomArrowView];
    
    
    // right arrow
    CGRect rightArrowFrame = CGRectMake(
                                        CGRectGetMaxX(_scrollView.bounds),
                                        CGRectGetMidY(_scrollView.bounds) - 25,
                                        50.f,
                                        50.f);
    
    ArrowView *rightArrowView = [[ArrowView alloc] initWithFrame: rightArrowFrame];
    [rightArrowView rotate: 90.f];
    [_scrollView addSubview: rightArrowView];
    
    // left arrow
    CGRect leftArrowFrame = CGRectMake(
                                       CGRectGetMinX(_scrollView.bounds) - 50,
                                       CGRectGetMidY(_scrollView.bounds) - 25,
                                       50.f,
                                       50.f);
    ArrowView *leftArrowView = [[ArrowView alloc] initWithFrame: leftArrowFrame];
    [leftArrowView rotate: 270.f];
    [_scrollView addSubview: leftArrowView];
}

#pragma mark - ViewDidLoad

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupScrollView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Determine scroll direction

- (ScrollDirection)determineScrollDirection: (UIScrollView *)scrollView
{
    ScrollDirection scrollDirection;
    
    // If the scrolling direction is changed on both X and Y it means the
    // scrolling started in one corner and goes diagonal. This will be
    // called ScrollDirectionCrazy
    if (_initialContentOffset.x != scrollView.contentOffset.x &&
        _initialContentOffset.y != scrollView.contentOffset.y) {
        scrollDirection = ScrollDirectionCrazy;
    } else {
        if (_initialContentOffset.x > scrollView.contentOffset.x) {
            scrollDirection = ScrollDirectionLeft;
        } else if (_initialContentOffset.x < scrollView.contentOffset.x) {
            scrollDirection = ScrollDirectionRight;
        } else if (_initialContentOffset.y > scrollView.contentOffset.y) {
            scrollDirection = ScrollDirectionUp;
        } else if (_initialContentOffset.y < scrollView.contentOffset.y) {
            scrollDirection = ScrollDirectionDown;
        } else {
            scrollDirection = ScrollDirectionNone;
        }
    }
    
    return scrollDirection;
}

- (ScrollDirection)determineScrollDirectionAxis: (UIScrollView *)scrollView
{
    ScrollDirection scrollDirection = [self determineScrollDirection: scrollView];
    
    switch (scrollDirection) {
        case ScrollDirectionLeft:
        case ScrollDirectionRight:
            return ScrollDirectionHorizontal;
            
        case ScrollDirectionUp:
        case ScrollDirectionDown:
            return ScrollDirectionVertical;
            
        default:
            return ScrollDirectionNone;
    }
}


#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // For verbosity:
    //
    // _initialContentOffset.x = _scrollView.contentOffset.x;
    // _initialContentOffset.y = _scrollView.contentOffset.y;
    
    _initialContentOffset = _scrollView.contentOffset;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    ScrollDirection scrollDirection = [self determineScrollDirectionAxis: scrollView];
    
    if (scrollDirection == ScrollDirectionVertical) {
        NSLog(@"Scrolling direction: vertical");
    } else if (scrollDirection == ScrollDirectionHorizontal) {
        NSLog(@"Scrolling direction: horizontal");
    } else {
        // This is probably crazy movement: diagonal scrolling
        CGPoint newOffset;
        
        if (abs(scrollView.contentOffset.x) > abs(scrollView.contentOffset.y)) {
            newOffset = CGPointMake(scrollView.contentOffset.x, _initialContentOffset.y);
        } else {
            newOffset = CGPointMake(_initialContentOffset.x, scrollView.contentOffset.y);
        }
        
        // Setting the new offset to the scrollView makes it behave like a proper
        // directional lock, that allows you to scroll in only one direction at any given time
        [_scrollView setContentOffset: newOffset];
    }
}


@end
