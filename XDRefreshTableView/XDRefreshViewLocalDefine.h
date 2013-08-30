//
//  XDRefreshViewLocalDefine.h
//  XDRefreshDemo
//
//  Created by xieyajie on 13-8-29.
//  Copyright (c) 2013年 xieyajie. All rights reserved.
//

#ifndef XDRefreshDemo_XDRefreshViewLocalDefine_h
#define XDRefreshDemo_XDRefreshViewLocalDefine_h

#if !defined __IPHONE_OS_VERSION_MIN_REQUIRED >= __IPHONE_5_0
# define KTextAlignmentLeft UITextAlignmentLeft
# define KTextAlignmentCenter UITextAlignmentCenter
# define KTextAlignmentRight UITextAlignmentRight

#else
# define KTextAlignmentLeft NSTextAlignmentLeft
# define KTextAlignmentCenter NSTextAlignmentCenter
# define KTextAlignmentRight NSTextAlignmentRight
#endif

#define KREFRESHVIEWMINOFFSETY 0.0
#define KREFRESHVIEWMAXOFFSETY 60.0


#endif
