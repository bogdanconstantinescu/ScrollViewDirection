//
//  ArrowView.m
//  ScrollViewDirection
//
//  Created by Bogdan Constantinescu on 29/08/14.
//  Copyright (c) 2014 Bogdan Constantinescu. All rights reserved.
//

#import "ArrowView.h"
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)

@interface ArrowView ()

@property (nonatomic, strong) UIImageView *arrowView;

@end


@implementation ArrowView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _arrowView = [[UIImageView alloc] initWithFrame: self.bounds];
        _arrowView.image = [UIImage imageNamed: @"arrow"];
        
        [self addSubview: _arrowView];
        
    }
    return self;
}

- (void)rotate: (CGFloat)degrees
{
    CGAffineTransform rotation = CGAffineTransformRotate(_arrowView.transform, DEGREES_TO_RADIANS(degrees));
    _arrowView.transform = rotation;
}

@end
