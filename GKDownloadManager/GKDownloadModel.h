//
//  GKDownloadModel.h
//  GKDownloadManager
//
//  Created by QuintGao on 2018/4/11.
//  Copyright © 2018年 QuintGao. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, GKDownloadManagerState) {
    GKDownloadManagerStateNone          = 0,    // 未开始
    GKDownloadManagerStateWaiting       = 1,    // 等待下载
    GKDownloadManagerStateDownloading   = 2,    // 下载中
    GKDownloadManagerStatePaused        = 3,    // 下载暂停
    GKDownloadManagerStateFailed        = 4,    // 下载失败
    GKDownloadManagerStateFinished      = 5     // 下载完成
};

@interface GKDownloadModel : NSObject

@property (nonatomic, copy) NSString *fileID;
@property (nonatomic, copy) NSString *fileUrl;
@property (nonatomic, copy) NSString *fileLocalPath;
@property (nonatomic, assign) GKDownloadManagerState state;
@property (nonatomic, copy) NSString *file_size; //（B）

/** 文件的总长度 */
@property (nonatomic, assign) NSInteger fileLength;
/** 当前的下载长度 */
@property (nonatomic, assign) NSInteger currentLength;

@end
