//
//  GLCitySelectViewController.m
//  GLCitySelectViewController
//
//  Created by Glenn on 15/9/2.
//  Copyright (c) 2015年 Glenn. All rights reserved.
//

#import "GLCitySelectViewController.h"
#import "GLHelper.h"
#import "GLLocationManager.h"
#import "GLSpecialCityCell.h"
#import "GLCommonCityCell.h"
#import "GLLocationCityManager.h"
#import "UIImage+GLAdditional.h"
#import "GLCommonMacro.h"
#import "GLNotificationMacro.h"
#import "GLGlobal.h"
#import "UIView+GLAdditional.h"
#import "GLDefine.h"
#import "NSString+GLAdditional.h"


#import "GLCityModel.h"

#define kHeightForSingleCityCell    44.0f
#define kHeightForHotCityCell       168.f

#define kSearchBarHeight            44.0f
typedef enum
{
    GLCityCellTypeHotCity = 0,
    GLCityCellTypeLocalCity,
    GLCityCellTypeRecentCity,
    GLCityCellTypeCommonCity
}GLCityCellType;
typedef enum
{
    GLCityLocationDisable = -3,
    GLCityLocating = -2,
    GLCityLocationFailed = -1,
}LSCitySelectedType;

@interface GLCitySelectViewController ()<UITableViewDataSource,UITableViewDelegate, UISearchBarDelegate,GLSpecialCityCellDelegate,UISearchDisplayDelegate>
{
    NSMutableArray*                             _hotCityDataArray;   //热门城市
    NSMutableArray*                             _allCityDataArray;   //所有城市
    NSMutableArray*                             _recentCityDataArray;//最近浏览城市
    NSMutableArray*                             _searchResultArray;
    NSMutableArray*                             _firstLetterKeysArray;//首字母
    NSMutableDictionary*                        _citiesDictionary;
    UISearchBar*                                _citySearchBar;
    UISearchDisplayController*                  _citySearchDisplayController;
    GLCity*                                     _locationCity; //定位城市
    
    BOOL                                        _isRecentDataExits;
    GLSpecialCityCell*                          _hotCityCell;
    GLSpecialCityCell*                          _recentCityCell;
    BOOL                                        _isAnimating;
    
    NSString *                                  _locationCityDes;
    GLCityModel *                               _cityData;
    
    struct {
        unsigned int didGetData : 1;
        unsigned int didSelectCity : 1;
        unsigned int didUpdateLocation : 1;
    }_delegateFlags;
}
@property (weak, nonatomic) IBOutlet UITableView *cityListTableView;
@end

@implementation GLCitySelectViewController
#pragma mark -lifecycle method

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _hotCityDataArray = [NSMutableArray array];
        _allCityDataArray = [NSMutableArray array];
        _recentCityDataArray = [NSMutableArray array];
        _firstLetterKeysArray = [NSMutableArray array];
        _citiesDictionary = [NSMutableDictionary dictionary];
        _locationCity = [[GLCity alloc] init];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(locationUpdated:) name:kLocationCityChangeNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = kViewControllerBackgroundColor;
    _cityListTableView.backgroundColor = kViewControllerBackgroundColor;
    
    NSString* cityName = [GLGlobal sharedGlobal].currentCity.cityName;
    if (cityName) {
        [self setCityNavTitle:[NSString stringWithFormat:@"当前城市-%@",cityName]];
    }else{
        [self setCityNavTitle:@"选择城市"];
    }
    [self setNavLeftButtonwithImg:@"icon_back.png" selImg:nil title:nil action:@selector(backBtnClicked:)];
    
    UIButton* btn = [[UIButton alloc]initWithFrame:CGRectMake(30, 0, 40, 40)];
    if (iOS7System) {
        btn.left = 20;
    }else{
        btn.left = 10;
    }
    [btn setImage:IMAGE_AT_APPDIR(@"icon_refresh_city.png") forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(refreshBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    UIView* customView = [[UIView alloc]initWithFrame:CGRectMake(0, 2, 60, 40)];
    customView.backgroundColor = [UIColor clearColor];
    [customView addSubview:btn];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:customView];
    
    
    UIButton* backBtn = (UIButton*)self.navigationItem.leftBarButtonItem.customView;
    backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -25, 0, 0);
    if (iOS7System) {
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -30, 0, 0);
    }else{
        backBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    }
    _citySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, kViewSizeWidth,kSearchBarHeight)];
    _citySearchBar.barStyle = UIBarStyleDefault;
    _citySearchBar.tintColor = RGBA(240, 240, 240, 1.f);
    if ([_cityListTableView respondsToSelector:@selector(setSectionIndexBackgroundColor:)]) {
        [_cityListTableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    }
    
    for (UIView* subView in _citySearchBar.subviews) {
        for (UIView* subSubView in subView.subviews) {
            if ([subSubView.description rangeOfString:@"<UISearchBarTextField"].location!=NSNotFound) {
                subSubView.tintColor = [UIColor lightGrayColor];
            }
        }
    }
    
    _citySearchBar.delegate = self;
    _citySearchBar.placeholder = @"请输入要查找的城市...";
    _citySearchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.view addSubview:_citySearchBar];
    
    if (iOS7System) {
        [_citySearchBar setBackgroundImage:[[UIImage imageNamed:@"bg_nav"] stretchableImageWithLeftCapWidth:10 topCapHeight:10] forBarPosition:UIBarPositionTopAttached barMetrics:UIBarMetricsDefault];
    }
    _citySearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:_citySearchBar contentsController:self];
    _citySearchDisplayController.searchResultsDelegate = self;
    _citySearchDisplayController.searchResultsDataSource = self;
    _citySearchDisplayController.delegate = self;
    [self requestCityList];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
}

//停止旋转动画
- (void)stopSpin
{
    _isAnimating = NO;
    UIButton* rotateBtn = (UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews lastObject];
    [rotateBtn.layer removeAllAnimations];
}
- (void)spinTheHotWheel
{
    UIButton* rotateBtn = (UIButton*)[self.navigationItem.rightBarButtonItem.customView.subviews lastObject];
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    rotationAnimation.duration = 0.6f;
    rotationAnimation.repeatCount = MAXFLOAT;//你可以设置到最大的整数值
    rotationAnimation.cumulative = NO;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    [rotateBtn.layer addAnimation:rotationAnimation forKey:@"Rotation"];
    
}
#pragma mark -network method
-(void)requestCityList
{
    __weak typeof(self) weakSelt = self;
    
    if (_delegateFlags.didGetData) {
        
        [_delegate citySelectViewController:self getDataWithCompletionHandler:^(GLCityModel *data) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelt parseCityData:data];
            });
        }];
    }
}

- (void)setDelegate:(id<GLCitySelectViewControllerDeleage>)delegate {
    _delegate = delegate;
    if ([_delegate respondsToSelector:@selector(citySelectViewController:getDataWithCompletionHandler:)]) {
        _delegateFlags.didGetData = YES;
    }
    
    if ([_delegate respondsToSelector:@selector(citySelectViewController:didSelectCity:locationCity:)]) {
        _delegateFlags.didSelectCity = YES;
    }
    
    if ([_delegate respondsToSelector:@selector(locationCityDesCityOfSelectViewController:updateLocationWithLocationCity:)]) {
        _delegateFlags.didUpdateLocation = YES;
    }
}

#pragma mark ib method
-(void)backBtnClicked:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)refreshBtnClicked:(id)sender
{
    
    _isAnimating = YES;
    [self spinTheHotWheel];
    [self requestCityList];
}

#pragma mark -private method

- (void)parseCityData:(GLCityModel*)citysModel
{
    [_allCityDataArray removeAllObjects];
    [_hotCityDataArray removeAllObjects];
    [_citiesDictionary removeAllObjects];
    [_firstLetterKeysArray removeAllObjects];
    [_recentCityDataArray removeAllObjects];
    
    if (citysModel) {
        
        _cityData = citysModel;
        
        NSMutableArray *allCityDataArray = [NSMutableArray array];
        
        for (int i = 0; i < citysModel.allcity.count; i ++) {
            id obj = citysModel.allcity[i];
            GLCity *city = [[GLCity alloc] init];
            city.cityName = [obj valueForKeyPath:@"cityName"];
            city.pinyin = [obj valueForKeyPath:@"pinyin"];
            city.province = [obj valueForKeyPath:@"province"];
            city.cityStatus = 0;
            [allCityDataArray addObject:city];
        }
        
        [_allCityDataArray addObjectsFromArray:allCityDataArray];

        if (_showHotCityCell) {
            
        }
        
        if (_showHotCityCell) {
            NSMutableArray *hotCityDataArray = [NSMutableArray array];
            
            for (int i = 0; i < citysModel.hotcity.count; i ++) {
                id obj = citysModel.hotcity[i];
                GLCity *city = [[GLCity alloc] init];
                city.cityName = [obj valueForKeyPath:@"cityName"];
                city.pinyin = [obj valueForKeyPath:@"pinyin"];
                city.province = [obj valueForKeyPath:@"province"];
                city.cityStatus = 0;
                [hotCityDataArray addObject:city];
            }
            
            [_hotCityDataArray addObjectsFromArray:hotCityDataArray];
        }
    }
    
    //设置首字母
    //定位
    GLCity *city = [[GLCity alloc] init];
    if (![GLLocationManager locationServicesEnabled])
    {
        city.cityName = @"定位服务不可用";
        city.cityStatus = GLCityLocationDisable;
    }
    else
    {
        city.cityName = @"正在定位中";
        city.cityStatus = GLCityLocating;
        [[[GLLocationCityManager shareInstance]class] reObtainLocation];
    }
    
    NSMutableArray *locCityArray = [NSMutableArray arrayWithObject:city];
    [_firstLetterKeysArray addObject:@"#"];
    [_citiesDictionary setObject:locCityArray forKey:@"#"];
    
    //最近浏览
    if (_showRecentCityCell) {
        NSData *tmpData = [GLHelper requestDataOfCacheWithFolderName:kCityRecentfolder prefix:@"city" subfix:@"recentlyCity"];
        NSMutableArray *r = [NSKeyedUnarchiver unarchiveObjectWithData:tmpData];
        if (!r)
        {
            _isRecentDataExits = NO;
        }
        else
        {
            if ([r count] > 1)
            {
                [_recentCityDataArray setArray:r];
                [_firstLetterKeysArray addObject:@"$"];
                NSMutableArray *t = [NSMutableArray arrayWithArray:r];
                [t removeObjectAtIndex:0];
                [_citiesDictionary setObject:t forKey:@"$"];
                _isRecentDataExits = YES;
            }
            else if ([r count] == 1)
            {
                [_recentCityDataArray setArray:r];
                _isRecentDataExits = NO;
            }
        }
    }
    
    //    //热门城市
    [_firstLetterKeysArray addObject:@"*"];
    [_citiesDictionary setObject:_hotCityDataArray forKey:@"*"];
    [self makeDictionaryFromArray:_allCityDataArray];
    [_cityListTableView reloadData];
    
}

- (void)doSearch:(NSString *)searchText {
    if (!_searchResultArray) {
        _searchResultArray = [[NSMutableArray alloc] init];
    }
    NSMutableArray* resultArray = [NSMutableArray array];
    if(searchText && ![searchText isEmptyOrWhitespace]) {
        if(_allCityDataArray && [_allCityDataArray count] > 0) {
            for (int i = 1; i < [_allCityDataArray count]; i++) {
                GLCity *city = [_allCityDataArray objectAtIndex:i];
                if([city.cityName containsString:searchText] || [city.pinyin hasPrefix:[searchText lowercaseString]]) {
                    [resultArray addObject:city];
                }
            }
        }
    }
    if (resultArray.count>0) {
        [_searchResultArray removeAllObjects];
        [_searchResultArray addObjectsFromArray:resultArray];
    }
    [self.searchDisplayController.searchResultsTableView reloadData];
}
-(void)locationUpdated:(NSNotification*)notification
{
    if ([notification.object isKindOfClass:[NSError class]]) {
        _locationCity.cityStatus = GLCityLocationFailed;
        [self performSelector:@selector(stopSpin) withObject:nil afterDelay:1];
    }else if([notification.object isKindOfClass:[GLCity class]]){
        _locationCity = notification.object;
        
        if (_delegateFlags.didUpdateLocation) {
            NSString *locationCityName = _locationCity.cityName;
            id locationCity = nil;
            for (id city in _cityData.allcity) {
                NSString *cityName = [city valueForKeyPath:@"cityName"];
                if ([locationCityName isEqualToString:cityName]) {
                    locationCity = city;
                }
            }
            _locationCityDes = [_delegate locationCityDesCityOfSelectViewController:self updateLocationWithLocationCity:locationCity];
        }
        
        [self stopSpin];
    }else{
        [self stopSpin];
        return;
    }
    
    [_citiesDictionary[@"#"]setArray:@[_locationCity]];
    if (_cityListTableView.numberOfSections>0) {
        [_cityListTableView beginUpdates];
        [_cityListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [_cityListTableView endUpdates];
    }
}
- (void)locationFailedRefreshCell
{
    //定位失败
    _locationCity.cityStatus = GLCityLocationFailed;
    _locationCity.cityName = @"定位失败，请点击重试";
    
    NSMutableArray *cityArray = [_citiesDictionary objectForKey:@"#"];
    if (cityArray)
    {
        [cityArray replaceObjectAtIndex:0 withObject:_locationCity];
    }
    else
    {
        [cityArray addObject:_locationCity];
    }
    if (_cityListTableView.numberOfSections>0) {
        [_cityListTableView beginUpdates];
        [_cityListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [_cityListTableView endUpdates];
        
    }
}
- (void)makeDictionaryFromArray:(NSArray *)cityArray {
    for (int i = 0 ; i < [cityArray count] ; i++)
    {
        NSString *firstLetter;
        GLCity *city = [cityArray objectAtIndex:i];
        if (city.cityName && [city.cityName length]>0) {
            
            if ([city.cityName isEqualToString:@"重庆"] ||
                [city.cityName isEqualToString:@"长治"] ||
                [city.cityName isEqualToString:@"长沙"] ||
                [city.cityName isEqualToString:@"长春"]) {
                
                firstLetter = @"C";
            } else if ([city.cityName isEqualToString:@"厦门"]) {
                firstLetter = @"X";
            } else {
                char letter = [GLHelper pingyinOfFirstLetter:city.cityName];
                if ( ( letter>='a' && letter<='z') || ( letter>='A' && letter<='Z' ) ) {
                    firstLetter = [[NSString stringWithFormat:@"%c",letter] uppercaseString];
                } else {
                    firstLetter = [NSString stringWithFormat:@"%c",'~'];
                }
            }
        }
        else
        {
            firstLetter = [NSString stringWithFormat:@"%c",'~'];
        }
        
        NSMutableArray *cityArray = [[NSMutableArray alloc] init];
        if ([_firstLetterKeysArray containsObject:firstLetter])
        {
            //如果该字母已经存在于字典的键中
            [cityArray addObjectsFromArray:(NSMutableArray *)[_citiesDictionary objectForKey:firstLetter]];	//就取出原来的名字数组然后加上新的名字
        }
        else
        {
            [_firstLetterKeysArray addObject:firstLetter];
        }
        
        [cityArray addObject:city];
        [_citiesDictionary setObject:cityArray forKey:firstLetter];
    }
    
    [_firstLetterKeysArray setArray:[[_citiesDictionary allKeys] sortedArrayUsingSelector:@selector(compare:)]];
}

#pragma mark UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    [_citySearchBar setShowsCancelButton:YES animated:YES];
    if (!iOS7System) {
        for(UIView *subView in searchBar.subviews){
            if([subView isKindOfClass:UIButton.class]){
                UIButton* btn = (UIButton*)subView;
                [btn setTitle:@"取消" forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageWithColor:[UIColor darkGrayColor] size:CGSizeMake(30, 20)] forState:UIControlStateNormal];
                btn.layer.cornerRadius = 5.f;
                btn.layer.masksToBounds = YES;
            }
        }
    }
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    //[self doSearch:searchBar.text];
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}


- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText==nil || [searchText isEqualToString:@""]) {
        [_searchResultArray removeAllObjects];
        [self.searchDisplayController.searchResultsTableView reloadData];
        return;
    }
    [self doSearch:searchText];
}

-(void)searchDisplayController:(UISearchDisplayController *)controller willShowSearchResultsTableView:(UITableView *)tableView
{
    [tableView setContentInset:UIEdgeInsetsZero];
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    [tableView setScrollIndicatorInsets:UIEdgeInsetsZero];
}

- (BOOL)selectCityModel2Delegate {
    NSString *currentCityName = [GLGlobal sharedGlobal].currentCity.cityName;
    id currentCity = nil;
    for (id city in _cityData.allcity) {
        NSString *cityName = [city valueForKeyPath:@"cityName"];
        if ([currentCityName isEqualToString:cityName]) {
            currentCity = city;
        }
    }
    
    NSString *locationCityName = [GLGlobal sharedGlobal].locationCity.cityName;
    id locationCity = nil;
    for (id city in _cityData.allcity) {
        NSString *cityName = [city valueForKeyPath:@"cityName"];
        if ([locationCityName isEqualToString:cityName]) {
            locationCity = city;
        }
    }
    
    BOOL dismiss = YES;
    
    if (_delegateFlags.didSelectCity) {
        dismiss =[_delegate citySelectViewController:self didSelectCity:currentCity locationCity:locationCity];
    }
    return dismiss;
}

#pragma mark -UITableViewDelegate
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return nil;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (tableView == _cityListTableView) {
        return 25;
    }
    return 0;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (tableView == _cityListTableView) {
        UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.width, 25)];
        titleLabel.backgroundColor = RGB(206, 206,206);
        titleLabel.textColor = [UIColor blackColor];
        titleLabel.font = [UIFont systemFontOfSize:15];
        NSString *title = nil;
        
        if (_isRecentDataExits>0)
        {
            if (section == 0)
            {
                title = @"定位城市";
            }
            else if (section == 1)
            {
                title = @"最近浏览城市";
            }
            else if(section == 2)
            {
                title = @"热门城市";
            }
            else
            {
                if ([[_firstLetterKeysArray objectAtIndex:section] isEqualToString:@"~"])
                {
                    title = @"其他";
                }
                else
                {
                    title = [_firstLetterKeysArray objectAtIndex:section];
                }
            }
        }
        else
        {
            if (section == 0)
            {
                title = @"定位城市";
            }
            else if(section == 1)
            {
                title = @"热门城市";
            }
            else if ([[_firstLetterKeysArray objectAtIndex:section] isEqualToString:@"~"])
            {
                title = @"其他";
            }
            else
            {
                title = [_firstLetterKeysArray objectAtIndex:section];
            }
        }
        titleLabel.text = [NSString stringWithFormat:@"  %@",title];
        return titleLabel;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==_cityListTableView) {
        if (_isRecentDataExits>0) {
            if (indexPath.section==2) {
                return kHeightForHotCityCell;
            }
        }else{
            if (indexPath.section==1) {
                return kHeightForHotCityCell;
            }
        }
    }
    return kHeightForSingleCityCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    GLCity *selectedCity;
    if (tableView == _cityListTableView)
    {
        NSString* letter = [_firstLetterKeysArray objectAtIndex:indexPath.section];
        if ([letter isEqualToString:@"*"] || [letter isEqualToString:@"$"]) {
            return;
        }
        selectedCity = [(NSMutableArray *)[_citiesDictionary objectForKey:letter] objectAtIndex:indexPath.row];
    }
    else
    {
        if (_searchResultArray && [_searchResultArray count] > 0)
        {
            selectedCity = [_searchResultArray objectAtIndex:indexPath.row];
        }
    }
    
    if (indexPath.section == 0 && indexPath.row == 0 && selectedCity.cityName && ![selectedCity.cityName isEqualToString:@""]) {
        
        for (int i = 0; i < _allCityDataArray.count; i ++) {
            GLCity *city = _allCityDataArray[i];
            if ([selectedCity.cityName isEqualToString:city.cityName]) {
                selectedCity = city;
            }
        }
    }
    
    if (selectedCity.cityStatus > -1)
    {
        //添加到最近浏览城市
        [self saveSelectCityToHistory:selectedCity];
    }
    else if (selectedCity.cityStatus == GLCityLocationDisable)
    {
        //定位服务不可用
        if([CLLocationManager locationServicesEnabled] &&
           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            [GLHelper alertWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启拉手团购)" withBtnTitle:@"知道了"];
        }
        else
        {
            [GLHelper alertWithTitle:@"定位服务不可用" message:nil withBtnTitle:@"知道了"];
        }
    }
    else if (selectedCity.cityStatus == GLCityLocating)
    {
        
        //正在定位中
        
    }
    else if (selectedCity.cityStatus == GLCityLocationFailed)
    {
        //定位失败
        //定位服务不可用
        if([CLLocationManager locationServicesEnabled] &&
           [CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied)
        {
            [GLHelper alertWithTitle:@"定位服务未开启" message:@"请在系统设置中开启定位服务(设置>隐私>定位服务>开启拉手团购)" withBtnTitle:@"知道了"];
        }
        else
        {
            NSMutableArray *cityArray = [_citiesDictionary objectForKey:@"#"];
            if (cityArray)
            {
                GLCity *cityInfo = (GLCity*)[cityArray objectAtIndex:0];
                cityInfo.cityName = @"正在定位中";
                cityInfo.cityStatus = GLCityLocating;
            }
            
            if (_cityListTableView.numberOfSections>0) {
                [_cityListTableView beginUpdates];
                [_cityListTableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                [_cityListTableView endUpdates];
                
            }
            [[[GLLocationCityManager shareInstance]class] reObtainLocation];
        }
    }
}

#pragma UITableViewDatasource
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    if (tableView == _cityListTableView)
    {
        return _firstLetterKeysArray;
    }
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_allCityDataArray count] == 0){
        return 0;
    }
    if (tableView == _cityListTableView)
    {
        if (_firstLetterKeysArray.count==0) {
#warning 提示
            //            [self showNoNetWorkView];
        }
        return [_firstLetterKeysArray count];
    }
    else
    {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_allCityDataArray.count==0) {
        return 0;
    }
    if (tableView == _cityListTableView){
        if (_isRecentDataExits>0) {
            if (section<3) {
                return 1;
            }
        }else{
            if (section<2) {
                return 1;
            }
        }
        int rowsCount = [[_citiesDictionary objectForKey:[_firstLetterKeysArray objectAtIndex:section]] count];
        return rowsCount;
    }else if (_searchResultArray && [_searchResultArray count] > 0)
    {
        return [_searchResultArray count];
    }
    return 0;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0 && indexPath.row==0) {
        for (UIView* subView in tableView.subviews) {
            if ([subView.description hasPrefix:@"<UITableViewIndex"]) {
                
                if ([subView respondsToSelector:@selector(setTintColor:)]) {
                    subView.tintColor =RGB(72, 72, 72);
                }
            }
        }
    }
    
    static NSString* specialIdentify = @"LSSpecialCityCell";
    static NSString* commonIdentify = @"LSCommonCityCell";
    GLSpecialCityCell* specialCell = nil;
    GLCommonCityCell*  commonCell = nil;
    NSArray* cityArray = _citiesDictionary[_firstLetterKeysArray[indexPath.section]];
    if(tableView==_cityListTableView){
        int cityCellType = -1;
        if (_isRecentDataExits>0) {
            if (indexPath.section==1) {
                cityCellType = GLCityCellTypeRecentCity;
            }else if(indexPath.section==2){
                cityCellType = GLCityCellTypeHotCity;
            }else{
                cityCellType = GLCityCellTypeCommonCity;
            }
        }else{
            if (indexPath.section==1) {
                cityCellType = GLCityCellTypeHotCity;
            }else{
                cityCellType = GLCityCellTypeCommonCity;
            }
        }
        if (cityCellType==GLCityCellTypeCommonCity) {
            commonCell = [tableView dequeueReusableCellWithIdentifier:commonIdentify];
            if (!commonCell) {
                commonCell = [GLCommonCityCell loadFromXib];
                commonCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            GLCity* city = cityArray[indexPath.row];
            [commonCell fillCellWithObject:cityArray[indexPath.row]];
            
            if (indexPath.section == 0) {
                commonCell.tipLabel.hidden = NO;
                commonCell.tipLabel.text = _locationCityDes;
            }
            
            if (indexPath.section>0) {
                if ([[GLGlobal sharedGlobal].currentCity.cityName isEqualToString:city.cityName]) {
                    [commonCell setStatus:YES];
                    [commonCell setTitleColor:kOrangeTextColor];
                }else{
                    [commonCell setStatus:NO];
                    [commonCell setTitleColor:[UIColor blackColor]];
                }
                commonCell.tipLabel.hidden = YES;
            }else{
                [commonCell setStatus:NO];
            }
            
            return commonCell;
        }else{
            if (cityCellType==GLCityCellTypeHotCity) {
                if (!_hotCityCell) {
                    _hotCityCell =[[GLSpecialCityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specialIdentify];
                    _hotCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    _hotCityCell.delegate = self;
                }
                specialCell = _hotCityCell;
            }else if(cityCellType==GLCityCellTypeRecentCity){
                if (!_recentCityCell) {
                    _recentCityCell =[[GLSpecialCityCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:specialIdentify];
                    _recentCityCell.selectionStyle = UITableViewCellSelectionStyleNone;
                    _recentCityCell.delegate = self;
                }
                specialCell = _recentCityCell;
            }
            [specialCell fillCellWithObject:cityArray];
            return specialCell;
        }
    }else{
        static NSString* identify = @"SearchResultIdentify";
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:identify];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
        }
        GLCity* city = _searchResultArray[indexPath.row];
        cell.textLabel.text = city.cityName;
        return cell;
    }
}

#pragma mark LSSpecialCityCellDelegate
-(void)specialCell:(GLSpecialCityCell *)cell selectModel:(GLCity *)city
{
    [self saveSelectCityToHistory:city];
}

-(void)saveSelectCityToHistory:(GLCity*)city
{
    BOOL isSame = NO;
    NSUInteger index = 0;
    for (GLCity *item in _recentCityDataArray)
    {
        if ([item.cityName isEqualToString:city.cityName])
        {
            index = [_recentCityDataArray indexOfObject:item];
            isSame = YES;
            break;
        }
    }
    if (isSame)
    {
        [_recentCityDataArray removeObjectAtIndex:index];
        [_recentCityDataArray insertObject:city atIndex:0];
    }
    else
    {
        if ([_recentCityDataArray count] > 4)
        {
            [_recentCityDataArray removeLastObject];
        }
        [_recentCityDataArray insertObject:city atIndex:0];
    }
    
    [GLGlobal sharedGlobal].currentCity = city;
    [GLGlobal writeGlobeVariablesToFile];
    
    [GLHelper cacheRequestData:[NSKeyedArchiver archivedDataWithRootObject:_recentCityDataArray] folderName:kCityRecentfolder prefix:@"city" subfix:@"recentlyCity"];
    
    if ([self selectCityModel2Delegate]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)setCityNavTitle:(NSString *)title
{
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    titleView.autoresizesSubviews = YES;
    titleView.backgroundColor = [UIColor clearColor];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont boldSystemFontOfSize:18];
    titleLabel.textAlignment = kTextAlignmentCenter;
    titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    titleLabel.autoresizingMask = titleView.autoresizingMask;
    CGRect leftViewbounds = self.navigationItem.leftBarButtonItem.customView.bounds;
    CGRect rightViewbounds = self.navigationItem.rightBarButtonItem.customView.bounds;
    CGRect frame;
    CGFloat maxWidth = leftViewbounds.size.width > rightViewbounds.size.width ? leftViewbounds.size.width : rightViewbounds.size.width;
    maxWidth += 15;
    frame = titleLabel.frame;
    frame.size.width = 320 - maxWidth * 2;
    titleLabel.frame = frame;
    frame = titleView.frame;
    frame.size.width = 320 - maxWidth * 2;
    titleView.frame = frame;
    titleLabel.text = title;
    [titleView addSubview:titleLabel];
    self.navigationItem.titleView = titleView;
}


@end