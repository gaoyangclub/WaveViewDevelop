//
//  WaterProgressView.m
//  WaveViewTest
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "WaterProgressView.h"

#define WAVE_DEFAULT_PADDING 16
#define RIGHT_RADIUS 55
#define CORNER_RADIUS 50
#define BACK_COLOR [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1]
#define THEME_COLOR [UIColor colorWithRed:72.0/255 green:164.0/255 blue:218.0/255 alpha:1]

@interface WaterProgressView(){
    
}
@property(nonatomic,readwrite) UIWaveView* waveView;

@end

@implementation WaterProgressView

-(void)setProgress:(CGFloat)progress{
    if (progress > 0.95) {
        progress = 0.95;
    }else if(progress < 0.05){
        progress = 0.05;
    }
    self.waveView.progress = progress;
}

-(CGFloat)progress{
    return self.waveView.progress;
}

-(CGFloat)wavePadding{
    if (!_wavePadding) {
        _wavePadding = WAVE_DEFAULT_PADDING;
    }
    return _wavePadding;
}

-(UIWaveView *)waveView{
    if (!_waveView) {
        _waveView = [[UIWaveView alloc] init];
        [self addSubview:_waveView];
//        _waveView.layer.cornerRadius = CORNER_RADIUS - self.wavePadding;
        _waveView.firstWaveColor = THEME_COLOR;
        _waveView.singleWave = YES;
    }
    return _waveView;
}

-(void)layoutSubviews{
    self.waveView.frame = CGRectMake(self.wavePadding, self.wavePadding, CGRectGetWidth(self.bounds) - RIGHT_RADIUS - 2 * self.wavePadding, CGRectGetHeight(self.bounds) - 2 * self.wavePadding);
    
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat maskRadius = CORNER_RADIUS - self.wavePadding / 2;
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.waveView.bounds
                                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(maskRadius, maskRadius)];
    CAShapeLayer* maskLayer = [[CAShapeLayer alloc]init];
    maskLayer.path = bezierPath.CGPath;
    self.waveView.layer.mask = maskLayer;
    
    
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect{
    CGFloat rightWidth = RIGHT_RADIUS * 2;
    CGFloat rightHeight = 80;
    
    CGRect rectFrame = CGRectMake(0, 0, CGRectGetWidth(self.bounds) - rightWidth / 2, CGRectGetHeight(self.bounds));
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:rectFrame
                                                     byRoundingCorners:UIRectCornerBottomLeft | UIRectCornerBottomRight
                                                           cornerRadii:CGSizeMake(CORNER_RADIUS, CORNER_RADIUS)];
    [BACK_COLOR setFill];
    [bezierPath fill];
    
    CGFloat lineWidth = self.wavePadding;
    CGRect rectRight = CGRectMake(CGRectGetWidth(self.bounds) - rightWidth - lineWidth / 2 - 1, CGRectGetHeight(self.bounds) / 2 - rightHeight / 2, rightWidth, rightHeight);
    UIBezierPath *bezierPath2 = [UIBezierPath bezierPathWithRoundedRect:rectRight cornerRadius:CORNER_RADIUS - 22];
    bezierPath2.lineWidth = lineWidth;
    
//    CGPoint rightCenter = CGPointMake(CGRectGetWidth(self.bounds) - RIGHT_RADIUS - bezierPath2.lineWidth / 2, CGRectGetHeight(self.bounds) / 2);
//    [bezierPath2 addArcWithCenter:rightCenter radius:RIGHT_RADIUS startAngle:M_PI_2 endAngle:M_PI_2 + M_PI clockwise:NO];
    [BACK_COLOR setStroke];
    [bezierPath2 stroke];
}

-(void)startWave{
    [self.waveView startWave];
}

-(void)stopWave{
    [self.waveView stopWave];
}

-(void)reset{
    [self.waveView reset];
}


@end
