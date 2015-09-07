GLCitySelectViewController
==============================
* The easy ViewController to select city.<br/>
* 用法简单地城市选择控制器


如何使用GLCitySelectViewController
-------------------------------------------
* 手动导入：
    * 将GLCitySelect文件夹中的所有文件拽入项目中
    * 导入头文件`GLCitySelectViewController.h`， `GLGlobal.h`

* 使您的城市模型遵守协议`GLCityModelProperty`，具有下面三个必须的属性<br>
```
@protocol GLCityModelProperty <NSObject>
@property (nonatomic, strong)NSString *cityName;//城市名
@property (nonatomic, strong)NSString *province;//城市所属省名
@property (nonatomic, strong)NSString *pinyin;//城市名拼音
@end
```
* 初始化`GLCitySelectViewController`，遵从协议`GLCitySelectViewControllerDeleage`实现代理方法
```
@protocol GLCitySelectViewControllerDeleage <NSObject>

/** 定位成功回代理方法 */
- (NSString *)locationCityDesCityOfSelectViewController:(GLCitySelectViewController *)citySelectViewController updateLocationWithLocationCity:(id)LocationCity;

/** 为GLCitySelectViewController提供城市列表数据的代理方法 */
- (void)citySelectViewController:(GLCitySelectViewController *)citySelectViewController getDataWithCompletionHandler:(void (^)(GLCityModel *data))completion;

/** 点击城市的代理方法 */
- (BOOL)citySelectViewController:(GLCitySelectViewController *)citySelectViewController didSelectCity:(id)selectCity locationCity:(id)locationCity;

@end

```
期待
-----------------------
* 如果在使用过程中遇到BUG，希望你能Issues我，谢谢！
