//
//  YSYLeftVC.m
//  ZHIHUDaily
//
//  Created by shengyang_yu on 15/12/9.
//  Copyright © 2015年 yushengyang. All rights reserved.
//

#import "YSYLeftVC.h"

#import "YSYRootVC.h"
#import "YSYMainVC.h"
#import "YSYCollectVC.h"
#import "YSYNewsVC.h"
#import "YSYSetVC.h"
#import "YSYThemeListVC.h"

#import "YSYCustomerBtn.h"
#import "ThemeCell.h"
#import "YSYTableView.h"


@interface YSYLeftVC ()<UITableViewDelegate,UITableViewDataSource>
{
    YSY_NetWorkManage *bb;
}
// 保存vc
@property (nonatomic, strong) NSMutableArray *vcArrays;
//** UI **//
// login
@property (nonatomic, strong) UIButton *mLoginBtn;
@property (nonatomic, strong) UIImageView *mUserImage;
@property (nonatomic, strong) UILabel *mUserName;
// segment
@property (nonatomic, strong) UIView *mSegmentView;
@property (nonatomic, strong) YSYCustomerBtn *mCollectBtn;
@property (nonatomic, strong) YSYCustomerBtn *mMessageBtn;
@property (nonatomic, strong) YSYCustomerBtn *mSettingBtn;
// table
@property (nonatomic, strong) YSYTableView *mTypeTable;
@property (nonatomic, strong) NSArray *themes;
// bottom
@property (nonatomic, strong) UIView *mBottomView;
@property (nonatomic, strong) YSYCustomerBtn *mDownloadBtn;
@property (nonatomic, strong) YSYCustomerBtn *mStyleBtn;
//
@property (nonatomic, strong) UINavigationController *mListVC;
@property (nonatomic, strong) YSYThemeListVC *mListRootVC;
@end

@implementation YSYLeftVC

- (instancetype)init {
    self = [super init];
    _mTypeTable = [YSYTableView new];
    _mTypeTable.delegate = self;
    _mTypeTable.dataSource = self;
    return self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.view.backgroundColor = [UIColor ysy_convertHexToRGB:@"232A30"];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor ysy_convertHexToRGB:@"232A30"];
    [self setUI];
    [ZHThemes themesWithBlock:^(ZHThemes *themes, NSError *error) {
        // 成功
        if (!error) {
            _themes = [NSArray arrayWithArray:themes.others];
            [_mTypeTable reloadData];
        }
    }];
}

#pragma mark -生成同种类型的按钮
- (YSYCustomerBtn *)createSimilarButtonFontSize:(CGFloat)size {
    YSYCustomerBtn *btn = [YSYCustomerBtn buttonWithType:UIButtonTypeCustom];
    btn.backgroundColor = [UIColor clearColor];
    [btn setTitleColor:[UIColor ysy_convertHexToRGB:@"94999f"]
              forState:UIControlStateNormal];
    [btn.titleLabel setFont:[UIFont systemFontOfSize:size]];
    
    return btn;
}
- (void)buttonLayoutSubviews:(UIButton *)btn {
    // Center image
    CGPoint center = btn.imageView.center;
    center.x = btn.frame.size.width/2.0;
    center.y = (btn.frame.size.height-btn.titleLabel.frame.size.height)/2 - 1.0;
    btn.imageView.center = center;
    
    //Center text
    CGRect newFrame = [btn titleLabel].frame;
    newFrame.origin.x = 0.0;
    newFrame.origin.y = CGRectGetMaxY(btn.imageView.frame) + 5.0;
    newFrame.size.width = btn.frame.size.width;
    
    btn.titleLabel.frame = newFrame;
    btn.titleLabel.textAlignment = NSTextAlignmentCenter;
}

#pragma mark －状态栏颜色 白色
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

#pragma mark -点击事件
- (void)loginAction:(UIButton *)sender {
    NSLog(@"login");
}

- (void)jump:(UIButton *)sender {
    
    [self.mm_drawerController setCenterViewController:_vcArrays[sender.tag-100] withCloseAnimation:YES completion:^(BOOL finished) {
        
    }];
}

- (void)setCenterVCs:(id)mVC {
    _vcArrays = [[NSMutableArray alloc] init];
    [_vcArrays addObject:mVC];
    /*
    [_vcArrays addObject:[[YSYCollectVC alloc] init]];
    [_vcArrays addObject:[[YSYNewsVC alloc] init]];
    [_vcArrays addObject:[[YSYSetVC alloc] init]];
     */
}

#pragma mark -UITableView delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _themes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *cellID = @"ThemeCell";
    ThemeCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[ThemeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.font = [UIFont systemFontOfSize:__View_Scale(16.0)];
        cell.textLabel.textColor = [UIColor ysy_convertHexToRGB:@"94999f"];
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    [cell setCellModel:_themes[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!_mListVC) {
        self.mListRootVC = [YSYThemeListVC new];
        self.mListVC = [[UINavigationController alloc] initWithRootViewController:self.mListRootVC];
    }
    ZHBaseThemes *tBase = self.themes[indexPath.row];
    uint64_t tID = tBase.mID;
    [self.mm_drawerController closeDrawerAnimated:YES completion:^(BOOL finished) {
        if (finished) {
            self.mListRootVC.mType = tID;
            [self.mm_drawerController setCenterViewController:self.mListVC];
        }
    }];
}

#pragma mark -set UI
- (void)setUI {
    
    CGFloat m_offset_y = 10.0;// 纵向间距
    // login
    {
        CGFloat m_status_h = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);// 状态栏高度
        CGFloat m_img_s = 37.0;// 图片尺寸
        CGFloat m_offset_x = 15.0;// 横向间距
        CGFloat m_btn_w = (__LeftScreen_Width-2*m_offset_x);// 按钮长度
        // 底部按钮
        self.mLoginBtn = ({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.backgroundColor = [UIColor clearColor];
            [btn addTarget:self
                    action:@selector(loginAction:)
          forControlEvents:UIControlEventTouchUpInside];
            [self.view addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(__View_Scale(m_btn_w), __View_Scale(m_img_s)));
                make.top.equalTo(self.view).with.offset(__View_Scale(m_offset_y)+m_status_h);
                make.left.equalTo(self.view).with.offset(__View_Scale(m_offset_x));
            }];
            btn;
        });
        self.mUserImage = ({
            // 头像
            UIImageView *img = [UIImageView new];
            img.backgroundColor = [UIColor redColor];
            img.image = [UIImage imageNamed:@"Setting_Avatar"];
            img.clipsToBounds = YES;
            img.layer.cornerRadius = __View_Scale(m_img_s)/2;
            [self.mLoginBtn addSubview:img];
            [img mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(__View_Scale(m_img_s), __View_Scale(m_img_s)));
                make.left.equalTo(self.mLoginBtn).with.offset(0);
                make.top.equalTo(self.mLoginBtn).with.offset(0);
            }];
            img;
        });
        self.mUserName = ({
            // 名称
            UILabel *lab = [UILabel new];
            lab.backgroundColor = [UIColor clearColor];
            lab.font = [UIFont systemFontOfSize:__View_Scale(16.0)];
            lab.textAlignment = 0;
            lab.textColor = [UIColor ysy_convertHexToRGB:@"94999f"];
            lab.text = @"请登录";
            [self.mLoginBtn addSubview:lab];
            [lab mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.mUserImage.mas_right).with.offset(__View_Scale(m_offset_x));
                make.right.equalTo(self.mLoginBtn).with.offset(0);
                make.top.equalTo(self.mLoginBtn).with.offset(0);
                make.bottom.equalTo(self.mLoginBtn).with.offset(0);
            }];
            lab;
        });
    }
    // segment button
    {
        CGFloat m_view_h = 50.0;// view高度
        CGFloat btn_offset_x = 23.0;// 间距
        self.mSegmentView = ({
            UIView *bView = [UIView new];
            bView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:bView];
            [bView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(__View_Scale(__LeftScreen_Width), __View_Scale(m_view_h)));
                make.left.equalTo(self.view).with.offset(0);
                make.top.equalTo(self.mLoginBtn.mas_bottom).with.offset(__View_Scale(m_offset_y));
            }];
            bView;
        });
        // 收藏按钮
        self.mCollectBtn = ({
            YSYCustomerBtn *btn = [self createSimilarButtonFontSize:__View_Scale(11.0)];
            [btn addTarget:self
                    action:@selector(loginAction:)
          forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"Menu_Icon_Collect"] forState:UIControlStateNormal];
            [btn setTitle:@"收藏" forState:UIControlStateNormal];
            [self.mSegmentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(__View_Scale(m_view_h), __View_Scale(m_view_h)));
                make.top.equalTo(self.mSegmentView).with.offset(0);
                make.left.equalTo(self.mSegmentView).with.offset(0);
            }];
            [self buttonLayoutSubviews:btn];
            btn;
        });
        // 消息按钮
        self.mMessageBtn = ({
            YSYCustomerBtn *btn = [self createSimilarButtonFontSize:__View_Scale(11.0)];
            [btn addTarget:self
                    action:@selector(loginAction:)
          forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"Menu_Icon_Message"] forState:UIControlStateNormal];
            [btn setTitle:@"消息" forState:UIControlStateNormal];
            [self.mSegmentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(__View_Scale(m_view_h), __View_Scale(m_view_h)));
                make.top.equalTo(self.mSegmentView).with.offset(0);
                make.left.equalTo(self.mCollectBtn.mas_right).with.offset(__View_Scale(btn_offset_x));
            }];
            [self buttonLayoutSubviews:btn];
            btn;
        });
        // 设置按钮
        self.mSettingBtn = ({
            YSYCustomerBtn *btn = [self createSimilarButtonFontSize:__View_Scale(11.0)];
            [btn addTarget:self
                    action:@selector(loginAction:)
          forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"Menu_Icon_Setting"] forState:UIControlStateNormal];
            [btn setTitle:@"设置" forState:UIControlStateNormal];
            [self buttonLayoutSubviews:btn];
            [self.mSegmentView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(__View_Scale(m_view_h), __View_Scale(m_view_h)));
                make.top.equalTo(self.mSegmentView).with.offset(0);
                make.left.equalTo(self.mMessageBtn.mas_right).with.offset(__View_Scale(btn_offset_x));
            }];
            btn;
        });
    }
    // bottom
    {
        CGFloat m_view_h = 60.0;// view高度
        CGFloat btn_offset_x = 15.0;// 间距
        CGFloat btn_offset_t = 10.0;// 间距
        CGFloat m_btn_w = (__LeftScreen_Width-2*btn_offset_x-btn_offset_t)/2;// 按钮长度
        self.mBottomView = ({
            UIView *bView = [UIView new];
            bView.backgroundColor = [UIColor clearColor];
            [self.view addSubview:bView];
            [bView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(__View_Scale(__LeftScreen_Width), __View_Scale(m_view_h)));
                make.left.equalTo(self.view).with.offset(0);
                make.bottom.equalTo(self.view).with.offset(0);
            }];
            bView;
        });
        // 完成按钮
        self.mDownloadBtn = ({
            YSYCustomerBtn *btn = [self createSimilarButtonFontSize:__View_Scale(15.0)];
            [btn addTarget:self
                    action:@selector(loginAction:)
          forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"Menu_Download"]
                 forState:UIControlStateNormal];
            [btn setTitle:@"完成" forState:UIControlStateNormal];
            [self.mBottomView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(__View_Scale(m_btn_w), __View_Scale(m_view_h)));
                make.top.equalTo(self.mBottomView).with.offset(0);
                make.left.equalTo(self.mBottomView).with.offset(btn_offset_x);
            }];
            btn;
        });
        // 日间/夜间 模式按钮
        self.mStyleBtn = ({
            YSYCustomerBtn *btn = [self createSimilarButtonFontSize:__View_Scale(15.0)];
            [btn addTarget:self
                    action:@selector(loginAction:)
          forControlEvents:UIControlEventTouchUpInside];
            [btn setImage:[UIImage imageNamed:@"Menu_Dark"]
                 forState:UIControlStateNormal];
            [btn setTitle:@"夜间" forState:UIControlStateNormal];
            [self.mBottomView addSubview:btn];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(__View_Scale(m_btn_w), __View_Scale(m_view_h)));
                make.top.equalTo(self.mBottomView).with.offset(0);
                make.left.equalTo(self.mDownloadBtn.mas_right).with.offset(btn_offset_t);
            }];
            btn;
        });
    }
    // table
    {
        _mTypeTable.backgroundColor = [UIColor clearColor];
        _mTypeTable.backgroundView.backgroundColor = [UIColor clearColor];
        _mTypeTable.rowHeight = __View_Scale(51.0f);
        [self.view addSubview:_mTypeTable];
        [_mTypeTable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo(__View_Scale(__LeftScreen_Width));
            make.left.equalTo(self.view).with.offset(0);
            make.top.equalTo(self.mSegmentView.mas_bottom).with.offset(0);
            make.bottom.equalTo(self.mBottomView.mas_top).with.offset(0);
        }];
    }
}

#pragma mark - set

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
