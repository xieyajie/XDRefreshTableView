//
//  XDRefreshTableView.m
//  XDRefreshDemo
//
//  Created by xieyajie on 13-8-29.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "XDRefreshTableView.h"
#import "XDRefreshViewLocalDefine.h"

@interface XDRefreshTableView()

@end

@implementation XDRefreshTableView

@synthesize pullDelegate = _pullDelegate;

@synthesize headerPullingView = _headerPullingView;
@synthesize footerPullingView = _footerPullingView;

@synthesize showHeaderPulling = _showHeaderPulling;
@synthesize showFooterPulling = _showFooterPulling;

@synthesize headerOffsetY = _headerOffsetY;
@synthesize footerOffsetY = _footerOffsetY;

@synthesize separatorAdapterContent = _separatorAdapterContent;

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame style:UITableViewStylePlain];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style
{
    self = [super initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        _headerPullingView = [[XDPullingView alloc] initWithFrame:CGRectMake(0, -frame.size.height, frame.size.width, frame.size.height) atViewTop:YES];
        [self addSubview:_headerPullingView];
        
        _footerPullingView = [[XDPullingView alloc] initWithFrame:CGRectMake(0, frame.size.height, frame.size.width, frame.size.height) atViewTop:NO];
        [self addSubview:_footerPullingView];
        
        [self addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:nil];
        
        self.headerOffsetY = KREFRESHVIEWMAXOFFSETY;
        self.footerOffsetY = KREFRESHVIEWMAXOFFSETY;
        self.showHeaderPulling = YES;
        self.showFooterPulling = YES;
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style pullDelegate:(id<XDRefreshTableViewDelegate>)delegate
{
    self = [self initWithFrame:frame style:style];
    if (self) {
        // Initialization code
        self.pullDelegate = delegate;
    }
    
    return self;
}


 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
// - (void)drawRect:(CGRect)rect
// {
// // Drawing code
//     [super drawRect:rect];
// }

#pragma mark - set

- (void)setShowHeaderPulling:(BOOL)show
{
    _showHeaderPulling = show;
    _headerPullingView.hidden = !show;
    if(!show)
    {
        _headerPullingView.currentState = XDStateNormal;
    }
}

- (void)setShowFooterPulling:(BOOL)show
{
    _showFooterPulling = show;
    _footerPullingView.hidden = !show;
    if(!show)
    {
        _footerPullingView.currentState = XDStateNormal;
    }
}

- (void)setHeaderOffsetY:(CGFloat)offsetY
{
    if (offsetY < 0) {
        offsetY *= -1;
    }
    
    _headerOffsetY = offsetY;
    if (offsetY > KREFRESHVIEWMINOFFSETY && offsetY < KREFRESHVIEWMAXOFFSETY) {
        if (_headerPullingView.offsetY != offsetY) {
            _headerPullingView.offsetY = offsetY;
        }
    }
}

- (void)setFooterOffsetY:(CGFloat)offsetY
{
    if (offsetY < 0) {
        offsetY *= -1;
    }
    
    _footerOffsetY = offsetY;
    if (offsetY > KREFRESHVIEWMINOFFSETY && offsetY < KREFRESHVIEWMAXOFFSETY) {
        if (_footerPullingView.offsetY != offsetY) {
            _footerPullingView.offsetY = offsetY;
        }
    }
}

- (void)setSeparatorAdapterContent:(BOOL)adapter
{
    if (_separatorAdapterContent != adapter) {
        _separatorAdapterContent = adapter;
        
        if (adapter) {
            UIView *replaceView = [[UIView alloc] initWithFrame: CGRectZero];
            [self setTableFooterView: replaceView];
        }
        else
        {
            self.tableFooterView = nil;
        }
    }
}

#pragma mark - KOV

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"contentSize"]) {
        if (_showFooterPulling) {
            CGFloat y = self.frame.size.height;
            if (y < self.contentSize.height) {
                y = self.contentSize.height;
            }
            
            _footerPullingView.frame = CGRectMake(0, y, self.frame.size.width, self.frame.size.height);
        }
    }
}

#pragma mark - public

- (void)tableViewDidScroll:(UIScrollView *)scrollView
{
    CGSize viewSize = scrollView.frame.size;
    CGSize contentSize = scrollView.contentSize;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY <= 0 && _showHeaderPulling) {
        if (_headerPullingView.currentState == XDStateLoading || _headerPullingView.currentState == XDStateHitTheEnd) {
            return;
        }
        
        if (offsetY < -1 * _headerOffsetY) {
            _headerPullingView.currentState = XDStatePulling;
        }
        else if (offsetY > -1 * _headerOffsetY )
        {
            _headerPullingView.currentState = XDStateNormal;
        }
    }
    else if ((offsetY + viewSize.height) >= contentSize.height && _showFooterPulling)
    {
        if (_footerPullingView.currentState == XDStateLoading || _footerPullingView.currentState == XDStateHitTheEnd) {
            return;
        }
        
        CGFloat bottomMargin = offsetY + viewSize.height - contentSize.height;
        if (contentSize.height < viewSize.height) {
            bottomMargin = offsetY;
        }
        if (bottomMargin > _footerOffsetY) {
            _footerPullingView.currentState = XDStatePulling;
        }
        else if (bottomMargin > 0 && bottomMargin < _footerOffsetY)
        {
            _footerPullingView.currentState = XDStateNormal;
        }
    }
}

- (void)tableViewDidEndDragging:(UIScrollView *)scrollView
{
    CGSize viewSize = scrollView.frame.size;
    CGSize contentSize = scrollView.contentSize;
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY <= 0 && _showHeaderPulling) {
        if (_headerPullingView.currentState == XDStateLoading || _headerPullingView.currentState == XDStateHitTheEnd) {
            return;
        }
        
        if (_headerPullingView.currentState == XDStatePulling) {
            _headerPullingView.currentState = XDStateLoading;
            
            [UIView animateWithDuration:0.5f animations:^{
                self.contentInset = UIEdgeInsetsMake(_headerOffsetY, 0, 0, 0);
            }];
            
            if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(pullingTableViewDidStartRefreshing:)]) {
                [_pullDelegate pullingTableViewDidStartRefreshing:self];
            }
        }
    }
    else if ((offsetY + viewSize.height) >= contentSize.height && _showFooterPulling)
    {
        if (_footerPullingView.currentState == XDStateLoading || _footerPullingView.currentState == XDStateHitTheEnd) {
            return;
        }
        
        if (_footerPullingView.currentState == XDStatePulling) {
            _footerPullingView.currentState = XDStateLoading;
            
            [UIView animateWithDuration:.5f animations:^{
                self.contentInset = UIEdgeInsetsMake(-_footerOffsetY, 0, 0, 0);
            }];
            
            if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(pullingTableViewDidStartLoading:)]) {
                [_pullDelegate pullingTableViewDidStartLoading:self];
            }
        }
    }
}

- (void)tableViewDidFinishedRefreshWithCompletion:(void (^)(BOOL finished))completion
{
    if (_showHeaderPulling) {
        if(_headerPullingView.loading)
        {
            _headerPullingView.loading = NO;
            [_headerPullingView setState:XDStateNormal animated:NO];
            
            NSDate *date = [NSDate date];
            if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(pullingTableViewRefreshingFinishedDate)]) {
                [_pullDelegate pullingTableViewRefreshingFinishedDate];
            }
            [_headerPullingView updateRefreshDate:date];
            
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            } completion:^(BOOL finish){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(finish);
                });
            }];
        }
    }
}

- (void)tableViewDidFinishedLoadingWithCompletion:(void (^)(BOOL finished))completion
{
    if (_showFooterPulling) {
        if (_footerPullingView.loading) {
            _footerPullingView.loading = NO;
            [_footerPullingView setState:XDStateNormal animated:NO];
            
            NSDate *date = [NSDate date];
            if (_pullDelegate && [_pullDelegate respondsToSelector:@selector(pullingTableViewLoadingFinishedDate)]) {
                [_pullDelegate pullingTableViewLoadingFinishedDate];
            }
            [_footerPullingView updateRefreshDate:date];
            
            [UIView animateWithDuration:0.5f delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
                self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
            } completion:^(BOOL finish){
                dispatch_async(dispatch_get_main_queue(), ^{
                    completion(finish);
                });
            }];
        }
    }
    
}

#pragma mark - 自动下拉

//自动下拉，动画完成后调用代理方法
- (void)launchRefreshing
{
    if (self.contentOffset.y > 0) {
        [self scrollRectToVisible:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) animated:YES];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.contentInset = UIEdgeInsetsMake(_headerOffsetY + 5, 0, 0, 0);
    } completion:^(BOOL finish){
        dispatch_async(dispatch_get_main_queue(), ^{
            _headerPullingView.currentState = XDStatePulling;
            [self tableViewDidEndDragging:self];
        });
    }];
}

- (void)launchRefreshingWithCompletion:(void (^)(BOOL finished))completion
{
    if (self.contentOffset.y > 0) {
        [self scrollRectToVisible:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height) animated:YES];
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.contentInset = UIEdgeInsetsMake(_headerOffsetY + 5, 0, 0, 0);
    } completion:^(BOOL finish){
        _headerPullingView.currentState = XDStatePulling;
        
        if (_headerPullingView.currentState == XDStateLoading || _headerPullingView.currentState == XDStateHitTheEnd) {
            return;
        }
        
        if (_headerPullingView.currentState == XDStatePulling) {
            _headerPullingView.currentState = XDStateLoading;
            
            [UIView animateWithDuration:0.5f animations:^{
                self.contentInset = UIEdgeInsetsMake(_headerOffsetY, 0, 0, 0);
            }];
            
            _headerPullingView.loading = NO;
            [UIView animateWithDuration:0.5f animations:^{
                self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
                [_headerPullingView setState:XDStateNormal animated:NO];
            }];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            completion(finish);
        });
    }];
}

- (void)hideMessageAnimation
{
    [UIView animateWithDuration:0.3 animations:^{
        _messageLabel.alpha = 0.0;
    }];
}

- (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration
{
    if (_messageLabel == nil) {
        _messageLabel = [[UILabel alloc] init];
        _messageLabel.alpha = 0.0;
        _messageLabel.layer.cornerRadius = 6.0;
        _messageLabel.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.9];
        _messageLabel.textColor = [UIColor whiteColor];
        _messageLabel.textAlignment = UITextAlignmentCenter;
        _messageLabel.font = [UIFont boldSystemFontOfSize:18.0];
        [self.superview addSubview:_messageLabel];
    }
    _messageLabel.frame = CGRectMake(self.frame.origin.x + 5.0, self.frame.origin.y + 4.0, self.frame.size.width - 10.0, 30.0);
    
    if (message.length) {
        _messageLabel.text = message;
        
        [UIView animateWithDuration:0.3 animations:^{
            _messageLabel.alpha = 1.0;
        }];
        [self performSelector:@selector(hideMessageAnimation) withObject:nil afterDelay:duration];
    }
}



@end
