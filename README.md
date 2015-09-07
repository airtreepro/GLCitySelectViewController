GLCitySelectViewController
==============================
* The easy ViewController to select city.<br/>
* 用法简单地城市选择控制器


如何使用GLCitySelectViewController
-------------------------------------------
* 手动导入：
    * 将GLCitySelect文件夹中的所有文件拽入项目中
    * 导入头文件`GLCitySelectViewController.h`， `GLGlobal.h`
* 城市模型遵守协议`GLCityModelProperty`
      @protocol GLCityModelProperty <NSObject>
      @property (nonatomic, strong)NSString *cityName;
      @property (nonatomic, strong)NSString *province;
      @property (nonatomic, strong)NSString *pinyin;
      @end
* 初始化`GLCitySelectViewController`，遵从协议`GLCitySelectViewControllerDeleage`
