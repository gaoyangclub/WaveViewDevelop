//
//  UIWaveView.h
//  WaveViewTest
//
//  Created by admin on 16/10/9.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIWaveView : UIView

@property (nonatomic, retain)   UIColor *firstWaveColor;    // 第一个波浪颜色
@property (nonatomic, retain)   UIColor *secondWaveColor;   // 第二个波浪颜色

@property (nonatomic, assign)   CGFloat progress;            // 百分比 0 - 1

@property (nonatomic, assign)   BOOL singleWave;            // 是否单个波浪 默认NO

-(void) startWave;

-(void) stopWave;

-(void) reset;

@end
