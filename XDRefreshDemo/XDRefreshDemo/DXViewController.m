//
//  DXViewController.m
//  XDRefreshDemo
//
//  Created by xieyajie on 13-8-29.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#import "DXViewController.h"
#import "XDRefreshTableView.h"

#import "XDRefreshViewLocalDefine.h"

@interface DXViewController ()<UITableViewDataSource, UITableViewDelegate, XDRefreshTableViewDelegate>
{
    XDRefreshTableView *_tableView;
    
    NSInteger _pageCount;
}

@end

@implementation DXViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    _pageCount = 1;
    
    _tableView = [[XDRefreshTableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain pullDelegate:self];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorAdapterContent = NO;
    _tableView.showHeaderPulling = YES;
    _tableView.showFooterPulling = YES;
    _tableView.separatorAdapterContent = YES;
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Delegate

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

#pragma mark - TableView DataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2 * _pageCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier: CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"第 %i 行", indexPath.row];
    
    return cell;
}

#pragma mark - scroll delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_tableView tableViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_tableView tableViewDidEndDragging:scrollView];}


#pragma mark - Refresh Delegate
//下拉加载上一天
- (void)pullingTableViewDidStartRefreshing:(XDRefreshTableView *)tableView
{
    [self performSelector:@selector(refresh) withObject:nil afterDelay:1.0f];
}

//上拉加载
- (void)pullingTableViewDidStartLoading:(XDRefreshTableView *)tableView
{
    [self performSelector:@selector(load) withObject:nil afterDelay:1.0f];
}

#pragma mark - private

- (void)refresh
{
    [_tableView tableViewDidFinishedRefreshWithCompletion:^(BOOL finish){
        _pageCount = 1;
        [_tableView reloadData];
    }];
}

- (void)load
{
    [_tableView tableViewDidFinishedLoadingWithCompletion:^(BOOL finish){
        _pageCount++;
        [_tableView reloadData];
    }];
}


@end
