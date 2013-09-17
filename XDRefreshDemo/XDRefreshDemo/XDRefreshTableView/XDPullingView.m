//
//  XDPullingView.m
//  XDRefreshDemo
//
//  Created by xieyajie on 13-8-29.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDPullingView.h"

#import "XDRefreshViewLocalDefine.h"

@interface XDPullingView()

@property (nonatomic, strong) UILabel *stateLabel;
@property (nonatomic, strong) UILabel *dateLabel;
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation XDPullingView

//private
@synthesize stateLabel = _stateLabel;
@synthesize dateLabel = _dateLabel;
@synthesize activityView = _activityView;

//public
@synthesize currentState = _currentState;

@synthesize isHeaderView = _isHeaderView;
@synthesize offsetY = _offsetY;
@synthesize loading = _loading;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		self.backgroundColor = [UIColor clearColor];
        
        [self addSubview:self.stateLabel];
        [self addSubview:self.dateLabel];
        [self addSubview:self.activityView];
        
        self.isHeaderView = YES;
//        self.offsetY = KREFRESHVIEWMAXOFFSETY;
        _currentState = XDStateNormal;
    }
    return self;
}


- (id)initWithFrame:(CGRect)frame atViewTop:(BOOL)isTop
{
    self = [self initWithFrame:frame];
    if (self) {
        // Initialization code
        self.isHeaderView = isTop;
        self.offsetY = KREFRESHVIEWMAXOFFSETY;
    }
    return self;
}

#pragma mark - get

- (UILabel *)stateLabel
{
    if (_stateLabel == nil) {
        UIFont *font = [UIFont systemFontOfSize:12.0f];
        _stateLabel = [[UILabel alloc] init];
        _stateLabel.font = font;
        _stateLabel.textColor = [UIColor blackColor];
        _stateLabel.textAlignment = KTextAlignmentCenter;
        _stateLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _stateLabel;
}

- (UILabel *)dateLabel
{
    if (_dateLabel == nil) {
        UIFont *font = [UIFont systemFontOfSize:12.0f];
        _dateLabel = [[UILabel alloc] init];
        _dateLabel.font = font;
        _dateLabel.textColor = [UIColor blackColor];
        _dateLabel.textAlignment = KTextAlignmentCenter;
        _dateLabel.backgroundColor = [UIColor clearColor];
    }
    
    return _dateLabel;
}

- (UIActivityIndicatorView *)activityView
{
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    
    return _activityView;
}

#pragma mark - set

- (void)setIsHeaderView:(BOOL)isTop
{
    if (_isHeaderView != isTop) {
        _isHeaderView = isTop;
        if (_isHeaderView) {
            _pullingContents = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"下拉刷新",  [NSNumber numberWithInteger:XDStateNormal], @"释放加载最新内容", [NSNumber numberWithInteger:XDStatePulling], @"正在刷新", [NSNumber numberWithInteger:XDStateLoading], @"没有最新内容了哦", [NSNumber numberWithInteger:XDStateHitTheEnd], nil];
        }
        else{
            _pullingContents = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"上拉加载",  [NSNumber numberWithInteger:XDStateNormal], @"释放加载更多内容", [NSNumber numberWithInteger:XDStatePulling], @"正在加载", [NSNumber numberWithInteger:XDStateLoading], @"没有更多内容了哦", [NSNumber numberWithInteger:XDStateHitTheEnd], nil];
        }
    }
}

- (void)setOffsetY:(CGFloat)offset
{
    if (_offsetY != offset) {
        _offsetY = offset;
        [self layoutFrame];
    }
}

- (void)setCurrentState:(XDState)state
{
    [self setState:state animated:YES];
}

#pragma mark - private

- (void)layoutFrame
{
    CGFloat labelHeight = 20.f;
    CGSize size = self.frame.size;
    
    CGFloat verticalMargin = (_offsetY - 2 * labelHeight) / 2;
    CGFloat y = verticalMargin;
    if (_isHeaderView) {
        y = self.frame.size.height - _offsetY + verticalMargin;
    }
    
    self.stateLabel.frame = CGRectMake(0, y, size.width, labelHeight);
    self.dateLabel.frame = CGRectMake(0, y + labelHeight, size.width, labelHeight);
    self.activityView.frame = CGRectMake(80, y, 20.0, 20.0);
    
    self.stateLabel.text = [_pullingContents objectForKey:[NSNumber numberWithInteger:_currentState]];
}

#pragma mark - public

- (void)setContent:(NSString *)content forState:(XDState)state
{
    [_pullingContents setObject:content forKey:[NSNumber numberWithInteger:state]];
}

- (void)setState:(XDState)state animated:(BOOL)animated
{
    if (_currentState != state)
    {
        _currentState = state;
        NSString *content = [_pullingContents objectForKey:[NSNumber numberWithInteger:_currentState]];
        
        if (_currentState == XDStateLoading) {    //Loading
            self.activityView.hidden = NO;
            [self.activityView startAnimating];
            
            _loading = YES;
        }
        else if (_currentState == XDStatePulling && !_loading) {    //Scrolling
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
        }
        else if (_currentState == XDStateNormal && !_loading){    //Reset
            self.activityView.hidden = YES;
            [self.activityView stopAnimating];
        }
        
        self.stateLabel.text = NSLocalizedString(content, @"");
    }
}

- (void)updateRefreshDate:(NSDate *)date
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    df.dateFormat = @"yyyy-MM-dd HH:mm";
    NSString *dateString = [df stringFromDate:date];
    NSString *title = NSLocalizedString(@"今天", nil);
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSYearCalendarUnit|NSMonthCalendarUnit|NSDayCalendarUnit
                                               fromDate:date toDate:[NSDate date] options:0];
    int year = [components year];
    int month = [components month];
    int day = [components day];
    if (year == 0 && month == 0 && day < 3) {
        if (day == 0) {
            title = NSLocalizedString(@"今天",nil);
        } else if (day == 1) {
            title = NSLocalizedString(@"昨天",nil);
        } else if (day == 2) {
            title = NSLocalizedString(@"前天",nil);
        }
        df.dateFormat = [NSString stringWithFormat:@"%@ HH:mm",title];
        dateString = [df stringFromDate:date];
        
    }
    _dateLabel.text = [NSString stringWithFormat:@"%@: %@",
                       NSLocalizedString(@"最后更新", @""),
                       dateString];
}

@end
