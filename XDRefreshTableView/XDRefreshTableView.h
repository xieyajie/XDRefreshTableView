//
//  XDRefreshTableView.h
//  XDRefreshDemo
//
//  Created by xieyajie on 13-8-29.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XDPullingView.h"

@protocol XDRefreshTableViewDelegate;

@interface XDRefreshTableView : UITableView
{
    UILabel *_messageLabel;
}

@property (nonatomic, unsafe_unretained) id<XDRefreshTableViewDelegate> pullDelegate;

//下拉时顶部显示的刷新页面
@property (nonatomic, strong) XDPullingView *headerPullingView;
//上拉时底部显示的刷新页面
@property (nonatomic, strong) XDPullingView *footerPullingView;

//是否支持下拉刷新
@property (nonatomic) BOOL showHeaderPulling;
//是否支持上拉加载
@property (nonatomic) BOOL showFooterPulling;

//偏移量是多少时显示顶部刷新页面(>0)
@property (nonatomic) CGFloat headerOffsetY;
//偏移量是多少时显示底部刷新页面(>0)
@property (nonatomic) CGFloat footerOffsetY;

//内容未满一屏时，分割线是否适配显示的有内容的cell.  YES:只有有内容的cell才会显示分割线，其余地方空白；NO：该屏所有cell都显示分割线
@property (nonatomic) BOOL separatorAdapterContent;


- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style pullDelegate:(id<XDRefreshTableViewDelegate>)delegate;

- (void)tableViewDidScroll:(UIScrollView *)scrollView;
- (void)tableViewDidEndDragging:(UIScrollView *)scrollView;
- (void)tableViewDidFinishedRefreshWithCompletion:(void (^)(BOOL finished))completion;
- (void)tableViewDidFinishedLoadingWithCompletion:(void (^)(BOOL finished))completion;

//自动下拉，动画完成后调用代理方法
- (void)launchRefreshing;
//自动下拉，只加载动画
- (void)launchRefreshingWithCompletion:(void (^)(BOOL finished))completion;

- (void)hideMessageAnimation;
- (void)showMessage:(NSString *)message duration:(NSTimeInterval)duration;

@end

@protocol XDRefreshTableViewDelegate <NSObject>

@optional
- (void)pullingTableViewDidStartRefreshing:(XDRefreshTableView *)tableView;
- (void)pullingTableViewDidStartLoading:(XDRefreshTableView *)tableView;

- (NSDate *)pullingTableViewRefreshingFinishedDate;
- (NSDate *)pullingTableViewLoadingFinishedDate;

@end
