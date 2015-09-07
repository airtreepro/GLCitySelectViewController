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

- (NSString *)locationCityDesCityOfSelectViewController:(GLCitySelectViewController *)citySelectViewController updateLocationWithLocationCity:(id)LocationCity;

- (void)citySelectViewController:(GLCitySelectViewController *)citySelectViewController getDataWithCompletionHandler:(void (^)(GLCityModel *data))completion;

- (BOOL)citySelectViewController:(GLCitySelectViewController *)citySelectViewController didSelectCity:(id)selectCity locationCity:(id)locationCity;

@end

```
