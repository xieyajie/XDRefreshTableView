//
//  XDPullingView.h
//  XDRefreshDemo
//
//  Created by xieyajie on 13-8-29.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    XDStateNormal = 0,
    XDStatePulling = 1,
    XDStateLoading = 2,
    XDStateHitTheEnd = 3
} XDState;

@interface XDPullingView : UIView
{
    UILabel *_stateLabel;
    UILabel *_dateLabel;
    UIActivityIndicatorView *_activityView;
    
    NSMutableDictionary *_pullingContents;
}

@property (nonatomic) XDState currentState;

@property (nonatomic) BOOL isHeaderView;
@property (nonatomic) CGFloat offsetY;
@property (nonatomic) BOOL loading;

- (id)initWithFrame:(CGRect)frame atViewTop:(BOOL)isTop;

- (void)setContent:(NSString *)content forState:(XDState)state;
- (void)setState:(XDState)state animated:(BOOL)animated;

- (void)updateRefreshDate:(NSDate *)date;

@end
