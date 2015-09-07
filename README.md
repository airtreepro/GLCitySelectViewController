GLCitySelectViewController
==============================
* The easy ViewController to select city.<br/>
* 用法简单地城市选择控制器


如何使用GLCitySelectViewController
-------------------------------------------
* 手动导入：
    * 将GLCitySelect文件夹中的所有文件拽入项目中
    * 导入头文件`GLCitySelectViewController.h`， `GLGlobal.h`

* 城市模型遵守协议`GLCityModelProperty`<br>
```
@protocol GLCityModelProperty <NSObject>
@property (nonatomic, strong)NSString *cityName;
@property (nonatomic, strong)NSString *province;
@property (nonatomic, strong)NSString *pinyin;
@end
```
* 初始化`GLCitySelectViewController`，遵从协议`GLCitySelectViewControllerDeleage`实现代理方法
```
@protocol GLCitySelectViewControllerDeleage <NSObject>

/**
 *  定位城市文字描述,定位成功时调用该代理方法
 *
 *  @param citySelectViewController 城市选择控制器
 *  @param LocationCity             定位城市模型
 *
 *  @return 定位城市的描述
 */
- (NSString *)locationCityDesCityOfSelectViewController:(GLCitySelectViewController *)citySelectViewController updateLocationWithLocationCity:(id)LocationCity;

/**
 *  城市选择控制器获取列表数据，获取列表数据时调用该代理方法
 *
 *  @param citySelectViewController 城市选择控制器
 *  @param completion               传入数据的block
 */
- (void)citySelectViewController:(GLCitySelectViewController *)citySelectViewController getDataWithCompletionHandler:(void (^)(GLCityModel *data))completion;

/**
 *  点击城市时调用该代理方法
 *
 *  @param citySelectViewController 城市选择控制器
 *  @param selectCity               选择的城市模型
 *  @param locationCity             定位城市模型
 *
 *  @return 返回YES跳转，返回NO不跳回
 */
- (BOOL)citySelectViewController:(GLCitySelectViewController *)citySelectViewController didSelectCity:(id)selectCity locationCity:(id)locationCity;

@end

```
