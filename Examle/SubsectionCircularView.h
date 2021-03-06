//
//  SubsectionCircularView.h
//
//  Created by honzon on 16/1/17.
//  Copyright © 2016年 honzon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubsectionCircularView : UIView
@property (nonatomic, assign)NSUInteger instanceCount;
@property (nonatomic, assign, readonly)NSUInteger maxInstanceCount;
@property (nonatomic, assign)float progress;
@property (nonatomic, strong)CALayer *instantLayer;
+ (SubsectionCircularView *)createShaperCircularViewWithFrame:(CGRect)frame superView:(UIView *)superView instanceCount:(NSUInteger)instanceCount maxInstanceCount:(NSUInteger)maxInstanceCount instanctLayer:(CALayer *)instantLayer;
@end
