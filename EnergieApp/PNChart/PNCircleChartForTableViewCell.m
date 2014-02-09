//
//  PNCircleChartForTableViewCell.m
//  EnergieApp
//
//  Created by Matthias Vermeulen on 9/02/14.
//  Copyright (c) 2014 Noizy. All rights reserved.
//

#import "PNCircleChartForTableViewCell.h"
#import "UICountingLabel.h"

@implementation PNCircleChartForTableViewCell

- (id)initWithFrame:(CGRect)frame andTotal:(NSNumber *)total andCurrent:(NSNumber *)current
{
    self = [super initWithFrame:frame];
    
    if (self) {
        _total = total;
        _current = current;
        _strokeColor = PNFreshGreen;
        
        _lineWidth = [NSNumber numberWithFloat:8.0];
        UIBezierPath* circlePath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.center.x,self.center.y) radius:self.frame.size.height*0.5 startAngle:DEGREES_TO_RADIANS(270) endAngle:DEGREES_TO_RADIANS(270.01) clockwise:NO];
        
        _circle               = [CAShapeLayer layer];
        _circle.path          = circlePath.CGPath;
        _circle.lineCap       = kCALineCapRound;
        _circle.fillColor     = [UIColor clearColor].CGColor;
        _circle.lineWidth     = [_lineWidth floatValue];
        _circle.zPosition     = 1;
        
        _circleBG             = [CAShapeLayer layer];
        _circleBG.path        = circlePath.CGPath;
        _circleBG.lineCap     = kCALineCapRound;
        _circleBG.fillColor   = [UIColor clearColor].CGColor;
        _circleBG.lineWidth   = [_lineWidth floatValue];
        _circleBG.strokeColor = PNLightYellow.CGColor;
        _circleBG.strokeEnd   = 1.0;
        _circleBG.zPosition   = -1;
        
        [self.layer addSublayer:_circle];
        [self.layer addSublayer:_circleBG];
        
		_gradeLabel = [[UICountingLabel alloc] initWithFrame:CGRectMake(0, 0, 50.0, 50.0)];
        
    }
    
    return self;
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
