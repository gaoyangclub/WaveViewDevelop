//
//  WaterProgressView.h
//  WaveViewTest
//
//  Created by admin on 16/10/10.
//  Copyright © 2016年 admin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIWaveView.h"

@interface WaterProgressView : UIView

@property(nonatomic,assign) CGFloat wavePadding;
//@property(nonatomic,readonly) UIWaveView* waveView;
@property(nonatomic,assign) CGFloat progress;            // 百分比 0 - 1


-(void) startWave;
-(void) stopWave;
-(void) reset;

@end
