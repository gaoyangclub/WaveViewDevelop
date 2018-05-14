//
//  UIWaveView.m
//  WaveViewTest
//
//  Created by admin on 16/10/9.
//  Copyright © 2016年 admin. All rights reserved.
//

#import "UIWaveView.h"

/**
 正弦型函数解析式：y = Asin(ωx + φ) + h
 各常数值对函数图像的影响：
 φ（初相位）：决定波形与X轴位置关系或横向移动距离（左加右减）
 ω：决定周期（最小正周期T=2π/|ω|）
 A：决定峰值（即纵向拉伸压缩的倍数）
 h：表示波形在Y轴的位置关系或纵向移动距离（上加下减）
 */
@interface UIWaveView(){
    CGFloat waveAmplitude;  // 波纹振幅 A
    CGFloat waveCycle;      // 波纹周期 ω
    CGFloat waveSpeed;      // 波纹速度
    CGFloat waveGrowth;     // 波纹上升速度
    
    CGFloat waterWaveHeight;
    CGFloat waterWaveWidth;
    CGFloat offsetX;           // 波浪x位移 φ
    CGFloat currentWavePointY; // 当前波浪上市高度Y（高度从大到小 坐标系向下增长）h
    
    float variable;     //可变参数 更加真实 模拟波纹
    BOOL increase;      // 增减变化
    
    UIColor* _firstWaveColor;
    UIColor* _secondWaveColor;
}

@property (nonatomic, retain) CADisplayLink *waveDisplaylink;//每帧触发
@property (nonatomic, retain) CAShapeLayer  *firstWaveLayer;
@property (nonatomic, retain) CAShapeLayer  *secondWaveLayer;

@end

@implementation UIWaveView

-(UIColor *)firstWaveColor{
    if (!_firstWaveColor) {
        _firstWaveColor = [UIColor colorWithRed:223/255.0 green:83/255.0 blue:64/255.0 alpha:1];
    }
    return _firstWaveColor;
}

-(void)setFirstWaveColor:(UIColor *)firstWaveColor{
    _firstWaveColor = firstWaveColor;
    [self setNeedsLayout];
}

-(UIColor *)secondWaveColor{
    if (!_secondWaveColor) {
        _secondWaveColor = [UIColor colorWithRed:236/255.0f green:90/255.0f blue:66/255.0f alpha:0.5];
    }
    return _secondWaveColor;
}

-(void)setSecondWaveColor:(UIColor *)secondWaveColor{
    _secondWaveColor = secondWaveColor;
    [self setNeedsLayout];
}

-(CAShapeLayer *)firstWaveLayer{
    if (!_firstWaveLayer) {
        _firstWaveLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_firstWaveLayer];
    }
    return _firstWaveLayer;
}

-(CAShapeLayer *)secondWaveLayer{
    if (!_secondWaveLayer) {
        _secondWaveLayer = [[CAShapeLayer alloc] init];
        [self.layer addSublayer:_secondWaveLayer];
    }
    return _secondWaveLayer;
}

-(CADisplayLink *)waveDisplaylink{
    if (!_waveDisplaylink) {
        _waveDisplaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(getCurrentWave:)];
    }
    return _waveDisplaylink;
}

-(void)layoutSubviews{
    self.secondWaveLayer.fillColor = self.secondWaveColor.CGColor;
    self.firstWaveLayer.fillColor = self.firstWaveColor.CGColor;
    
    waterWaveHeight = self.frame.size.height / 2;
    waterWaveWidth = self.frame.size.width;
    
    if (waterWaveWidth > 0) {
        waveCycle =  1.29 * M_PI / waterWaveWidth;
    }
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        self.layer.masksToBounds = YES;
        
        waveGrowth = 0.85;
        waveSpeed = 0.2 / M_PI;
        
        [self reset];
    });
}

/** 为了追求真实感波浪起伏错落有致 **/
-(void)animateWave
{
    if (_progress < 0.1) {
        variable = 0.5;
    }else{
        if (increase) {
            variable += 0.01;
        }else{
            variable -= 0.01;
        }
        if (variable <= 1) {
            increase = YES;
        }else if (variable >= 1.6) {
            increase = NO;
        }
    }
    waveAmplitude = variable * 5;
}

-(void)getCurrentWave:(CADisplayLink *)displayLink{
    [self animateWave];
    
    CGFloat targetPointY = 2 * waterWaveHeight * (1 - _progress);
    if (waveGrowth > 0 && currentWavePointY > targetPointY){
        [self wavePointGrowthUp:targetPointY growth:waveGrowth];
//        NSLog(@"上涨");
    }else if(waveGrowth > 0 && currentWavePointY < targetPointY){
        [self wavePointGrowthDown:targetPointY growth:waveGrowth];
//        NSLog(@"下降");
    }
    else if (waveGrowth < 0 && currentWavePointY > targetPointY){
        [self wavePointGrowthUp:targetPointY growth:-waveGrowth];
    }
    else if (waveGrowth < 0 && currentWavePointY < targetPointY){
        [self wavePointGrowthDown:targetPointY growth:-waveGrowth];
    }
    // 波浪位移
    offsetX += waveSpeed;
    
    [self setWaveLayerPath:self.firstWaveLayer isSin:YES];
    if (!self.singleWave) {
        [self setWaveLayerPath:self.secondWaveLayer isSin:NO];
    }
}

-(void)wavePointGrowthUp:(CGFloat)targetPointY growth:(CGFloat)growth{
    if (currentWavePointY - growth < targetPointY) {//到达边界
        currentWavePointY = targetPointY;
    }else{
        currentWavePointY -= growth;// 波浪高度未到指定高度 继续上涨
    }
}

-(void)wavePointGrowthDown:(CGFloat)targetPointY growth:(CGFloat)growth{
    if (currentWavePointY + growth > targetPointY) {//到达边界
        currentWavePointY = targetPointY;
    }else{
        currentWavePointY += growth;// 波浪高度未到指定高度 继续下降
    }
}

-(void)setWaveLayerPath:(CAShapeLayer*)layer isSin:(BOOL)isSin{
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat y = currentWavePointY;
    CGPathMoveToPoint(path, nil, 0, y);
    for (float x = 0.0f; x <=  waterWaveWidth ; x++) {
        // 正弦波浪公式
        if (isSin) {
            y = waveAmplitude * sin(waveCycle * x + offsetX) + currentWavePointY;
        }else{
            y = waveAmplitude * cos(waveCycle * x + offsetX) + currentWavePointY;
        }
        CGPathAddLineToPoint(path, nil, x, y);
    }
    
    CGPathAddLineToPoint(path, nil, waterWaveWidth, self.frame.size.height);
    CGPathAddLineToPoint(path, nil, 0, self.frame.size.height);
    CGPathCloseSubpath(path);
    
    layer.path = path;
    CGPathRelease(path);
}

-(void)startWave{
    [self.waveDisplaylink addToRunLoop:[NSRunLoop mainRunLoop] forMode:NSRunLoopCommonModes];
}

-(void)stopWave{
    if (_waveDisplaylink) {
        [_waveDisplaylink invalidate];
        _waveDisplaylink = nil;
    }
}

- (void)reset
{
//    currentWavePointY = self.frame.size.height;
    currentWavePointY = 2 * waterWaveHeight * (1 - _progress);
    
    variable = 1.6;
    increase = NO;
    
    offsetX = 0;
}

-(void)dealloc{
    [self stopWave];
}

@end


