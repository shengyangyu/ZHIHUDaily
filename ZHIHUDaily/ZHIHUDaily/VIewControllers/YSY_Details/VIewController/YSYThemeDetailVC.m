//
//  YSYThemeDetailVC.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/28.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYThemeDetailVC.h"

@interface YSYThemeDetailVC ()<UIWebViewDelegate>

@property (nonatomic, strong) DetailViewModel *mModel;
@property (nonatomic, strong) UIWebView *mShowWeb;

@end

@implementation YSYThemeDetailVC

- (instancetype)initWithModel:(DetailViewModel *)model {
    
    self = [super init];
    if (self) {
        _mModel = model;
        [_mModel addObserver:self forKeyPath:@"mDetailModel" options:NSKeyValueObservingOptionNew context:nil];
        [_mModel getDetailWithID:model.mModelID];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self setUI];
}

#pragma mark - Hidden
- (BOOL)fd_prefersNavigationBarHidden {
    return YES;
}

- (void)setUI {
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mShowWeb];
    [self.mShowWeb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view).with.insets(UIEdgeInsetsMake(20, 0, 0, 0));
    }];
}
#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {

    if ([keyPath isEqualToString:@"mDetailModel"]) {
        //[_imageView sd_setImageWithURL:[NSURL URLWithString:_viewmodel.imageURLString]];
        //CGSize size = [_viewmodel.titleAttText boundingRectWithSize:CGSizeMake(kScreenWidth-30, 60) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size;
        //_titleLab.frame = CGRectMake(15, _headerView.frame.size.height-20-size.height, kScreenWidth-30, size.height);
        //_titleLab.attributedText = _viewmodel.titleAttText;
        //_imaSourceLab.text = _viewmodel.imaSourceText;
        [self.mShowWeb loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_mModel.mShareURL]]];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //[_preView removeFromSuperview];
        });
    }
}

#pragma mark - getter setter
- (UIWebView *)mShowWeb {
    if (!_mShowWeb) {
        _mShowWeb = [[UIWebView alloc]init];
        _mShowWeb.delegate = self;
        _mShowWeb.userInteractionEnabled = YES;
        _mShowWeb.scalesPageToFit = YES;
        _mShowWeb.opaque = NO;
        _mShowWeb.backgroundColor = [UIColor ysy_convertHexToRGB:@"e6e6e6"];
    }
    return _mShowWeb;
}

#pragma mark - dealloc
- (void)dealloc {
    [_mModel removeObserver:self forKeyPath:@"mDetailModel"];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
