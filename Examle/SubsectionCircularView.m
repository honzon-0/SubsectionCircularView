//
//  SubsectionCircularView.m
//
//  Created by honzon on 16/1/17.
//  Copyright © 2016年 honzon. All rights reserved.
//

#import "SubsectionCircularView.h"


#define kDEFAULT_INSTANCE_WIDTH 5
#define kDEFAULT_INSTANCE_HEIGHT 10
#define kDEFAULT_MAX_INSTANCE_COUNT 40

@interface SubsectionCircularView ()
@property (nonatomic, assign, readwrite)NSUInteger maxInstanceCount;
@property (nonatomic, strong)UILabel *textLabel;
@property (nonatomic, assign)CGFloat instanceHeight;
@property (nonatomic, strong)CAShapeLayer *shaper;
@end

@implementation SubsectionCircularView

- (CALayer *)instantLayer{
    if (!_instantLayer) {
        _instantLayer = [self defaultInstantLayer];
    }
    return _instantLayer;
}


-(void)setMaxInstanceCount:(NSUInteger)maxInstanceCount{
    if (_maxInstanceCount != maxInstanceCount) {
        _maxInstanceCount = maxInstanceCount;
    }
    
    if (_maxInstanceCount == 0 || !_maxInstanceCount) {
        _maxInstanceCount = kDEFAULT_MAX_INSTANCE_COUNT;
    }
}

-(CGFloat)instanceHeight{
    if (_instanceHeight || _instanceHeight == 0) {
        _instanceHeight = kDEFAULT_INSTANCE_HEIGHT;
    }
    return _instanceHeight;
}

- (void)setProgress:(float)progress{
    CGFloat repairProgress = [self repairProgress:progress];
    if (_progress != repairProgress) {
        _progress = repairProgress;
        self.shaper.strokeEnd = repairProgress;
    }
    
    if (_progress > 1) {
        _progress = 1.0;
        self.shaper.strokeEnd = 1.0;
    }
    self.textLabel.text = [NSString stringWithFormat:@"%.0f%%",100*self.shaper.strokeEnd];
}

- (float)repairProgress:(float)progress {
    NSInteger  minInstanceCount = progress *self.maxInstanceCount;
    NSUInteger repaiMin = minInstanceCount *10000;
    CGFloat repairFloat= repaiMin/self.maxInstanceCount;
    return repairFloat/10000;
}

//添加内层试图
- (void)createLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10,10,self.frame.size.width - 20, self.frame.size.width - 20)];
    label.textAlignment = NSTextAlignmentCenter;
    label.layer.cornerRadius = label.bounds.size.width/2;
    label.layer.masksToBounds = YES;
    label.font = [UIFont systemFontOfSize:15];
    label.backgroundColor = [UIColor redColor];
    label.text = @"0%";
    self.textLabel = label;
    
    [self addSubview:label];
}


/****CAReplicatorLayer + CAShaper****/

+ (SubsectionCircularView *)createShaperCircularViewWithFrame:(CGRect)frame superView:(UIView *)superView instanceCount:(NSUInteger)instanceCount maxInstanceCount:(NSUInteger)maxInstanceCount instanctLayer:(CALayer *)instantLayer{
    SubsectionCircularView *circularView = [[SubsectionCircularView alloc] initWithFrame:frame];
    
    circularView.maxInstanceCount = maxInstanceCount;
    circularView.instanceCount = instanceCount;
    circularView.instantLayer = instantLayer;
    if (instantLayer) {
        circularView.instanceHeight = instantLayer.frame.size.height;
    }
    [circularView drawSubsectionCircularView];
    [circularView createLabel];
    
    [superView addSubview:circularView];
    return circularView;
}

//CAShapeLayer
- (void)drawSubsectionCircularView {
    CAShapeLayer *shaper = [CAShapeLayer layer];
    shaper.lineWidth = self.instanceHeight *2;
    shaper.fillColor = [UIColor grayColor].CGColor;
    shaper.strokeColor = [UIColor greenColor].CGColor;
    shaper.strokeStart = 0.0;
    shaper.strokeEnd = 0.0;
    
    UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:self.bounds];
    shaper.path = path.CGPath;
    
    // set Mask
    CAReplicatorLayer * maskReplicator = [self createReplicator];
    [shaper setMask:maskReplicator];
    
    shaper.bounds = CGPathGetBoundingBox(shaper.path);
    shaper.position = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    shaper.transform = CATransform3DMakeRotation(M_PI_2, 0, 0, 1);//修改起点位置
    
    self.shaper = shaper;
    [self.layer addSublayer:shaper];
    
}

//defaultInstantLayer
- (CALayer *)defaultInstantLayer {
    CALayer * layer = [CALayer layer];
    layer.frame = CGRectMake(0, 0, kDEFAULT_INSTANCE_WIDTH, kDEFAULT_INSTANCE_HEIGHT);
    layer.backgroundColor = [UIColor greenColor].CGColor;
    //解决锯齿化问题
    layer.edgeAntialiasingMask = kCALayerBottomEdge|kCALayerLeftEdge | kCALayerRightEdge | kCALayerTopEdge;
    layer.allowsEdgeAntialiasing = YES;
    
    return layer;
}

//CAReplicatorLayer
- (CAReplicatorLayer *)createReplicator{
    CAReplicatorLayer * replicator = [CAReplicatorLayer layer];
    replicator.frame = CGRectMake(self.frame.size.width/2, 0, 0, self.frame.size.width);
    replicator.instanceCount = self.maxInstanceCount;
    replicator.instanceTransform = CATransform3DMakeRotation(M_PI*2 /self.maxInstanceCount , 0, 0, 1);;
    
    [replicator addSublayer:self.instantLayer];
    
    return replicator;
}


@end
