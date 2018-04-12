//
//  GKFileViewController.m
//  GKDownloadManagerDemo
//
//  Created by aystfm on 2018/4/12.
//  Copyright © 2018年 QuintGao. All rights reserved.
//

#import "GKFileViewController.h"
#import "GKFileViewCell.h"

@interface GKFileViewController ()<UITableViewDelegate, UITableViewDataSource, GKDownloadManagerDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataList;

@end

@implementation GKFileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"文件列表";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部删除" style:UIBarButtonItemStylePlain target:self action:@selector(clearALL)];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部下载" style:UIBarButtonItemStylePlain target:self action:@selector(downloadALL)];
    
    [self.view addSubview:self.tableView];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"data1" ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath]; 
    
    NSArray *arr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    
    self.dataList = [GKFileModel mj_objectArrayWithKeyValuesArray:arr];
    
    // 获取列表文件的下载状态
    [[KDownloadManager downloadFileList] enumerateObjectsUsingBlock:^(GKDownloadModel * _Nonnull model, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.dataList enumerateObjectsUsingBlock:^(GKFileModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj.file_id isEqualToString:model.fileID]) {
                obj.state       = model.state;
                obj.file_size   = model.file_size;
            }
        }];
    }];
    
    // 设置代理
    KDownloadManager.delegate = self;
    [KDownloadManager setCanBreakpoint:YES];
}

- (void)clearALL {
    NSMutableArray *downloadArr = [NSMutableArray new];
    
    [self.dataList enumerateObjectsUsingBlock:^(GKFileModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKDownloadModel *model = [GKDownloadModel new];
        model.fileID    = obj.file_id;
        model.fileUrl   = obj.file_url;
        model.state     = obj.state;
        
        [downloadArr addObject:model];
    }];
    
    [KDownloadManager removeDownloadArr:downloadArr];
}

// 全部开始
- (void)downloadALL {
    NSMutableArray *downloadArr = [NSMutableArray new];
    
    [self.dataList enumerateObjectsUsingBlock:^(GKFileModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKDownloadModel *model = [GKDownloadModel new];
        model.fileID    = obj.file_id;
        model.fileUrl   = obj.file_url;
        model.state     = obj.state;
        
        [downloadArr addObject:model];
    }];
    
    [KDownloadManager addDownloadArr:downloadArr];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部暂停" style:UIBarButtonItemStylePlain target:self action:@selector(pauseDownloadALL)];
}

// 全部暂停
- (void)pauseDownloadALL {
    NSMutableArray *downloadArr = [NSMutableArray new];
    
    [self.dataList enumerateObjectsUsingBlock:^(GKFileModel *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        GKDownloadModel *model = [GKDownloadModel new];
        model.fileID    = obj.file_id;
        model.fileUrl   = obj.file_url;
        model.state     = obj.state;
        
        [downloadArr addObject:model];
    }];
    
    [KDownloadManager pausedDownloadArr:downloadArr];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"全部下载" style:UIBarButtonItemStylePlain target:self action:@selector(downloadALL)];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GKFileViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFileViewCellID forIndexPath:indexPath];
    cell.model = self.dataList[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    GKFileModel *model = self.dataList[indexPath.row];
    
    GKDownloadModel *downloadModel = [GKDownloadModel new];
    downloadModel.fileID    = model.file_id;
    downloadModel.fileUrl   = model.file_url;
    downloadModel.state     = model.state;
    
    if (model.state == GKDownloadManagerStateNone || model.state == GKDownloadManagerStateFailed) { // 未开始下载或下载失败
        [KDownloadManager addDownloadArr:@[downloadModel]];
    }else if (model.state == GKDownloadManagerStatePaused) { // 暂停下载
        [KDownloadManager resumeDownloadArr:@[downloadModel]];
    }else if (model.state == GKDownloadManagerStateFinished) { // 下载完成，什么也不做
        
    }else { // 其他 等待下载、正在下载,点击后暂停下载
        [KDownloadManager pausedDownloadArr:@[downloadModel]];
    }
}

#pragma mark - GKDownloadManagerDelegate
- (void)gkDownloadManager:(GKDownloadManager *)downloadManager downloadModel:(GKDownloadModel *)downloadModel stateChanged:(GKDownloadManagerState)state {
    [self.dataList enumerateObjectsUsingBlock:^(GKFileModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.file_id isEqualToString:downloadModel.fileID]) {
            model.state = downloadModel.state;
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)gkDownloadManager:(GKDownloadManager *)downloadManager downloadModel:(GKDownloadModel *)downloadModel totalSize:(NSInteger)totalSize downloadSize:(NSInteger)downloadSize progress:(float)progress {
    [self.dataList enumerateObjectsUsingBlock:^(GKFileModel *model, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([model.file_id isEqualToString:downloadModel.fileID]) {
            model.file_size = [NSString stringWithFormat:@"%@", [KDownloadManager convertFromByteNum:totalSize]];
            model.completed_size = [NSString stringWithFormat:@"%@", [KDownloadManager convertFromByteNum:downloadSize]];
            model.progress = progress;
        }
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}

- (void)gkDownloadManager:(GKDownloadManager *)downloadManager removedDownloadArr:(NSArray *)downloadArr {
    // 这里处理下载完成或正在下载的文件的删除操作
}

#pragma mark - 懒加载
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        [_tableView registerClass:[GKFileViewCell class] forCellReuseIdentifier:kFileViewCellID];
        _tableView.rowHeight = 60.0f;
    }
    return _tableView;
}

@end
