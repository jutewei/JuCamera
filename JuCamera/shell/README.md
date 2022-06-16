
### 打包脚本说明 
` 打开终端，cd到shell目录，然后输入./debug或者./release`

### 1、debug 调试模式打包
####  1.1、打包环境选择
```
请输入编译环境 0-sit 1-uat 2-release

0代表sit、1代表uat、2代表线上环境、输入相应的数据即可
```
####  1.2、打包证书选择
```
请选择证书环境  1-developer 2-Enterprise

1、为开发者证书打包（只能安装在绑定过uuid的设备）
2、企业证书打包（可随意安装到任何手机、本项目选2）
```

### 2、release 发布模式打包（线上环境）
#### 2.1、打包证书选择
```
请选择证书环境  1-AppStore 2-ad-hoc 3-Enterprise

1、苹果App Store发布证书打包（只能上传到App Store，测试机无法安装）、
2、需要上线App Store时的Release测试打包（只能安装在绑定过uuid的设备）
3、企业证书打包（可随意安装到任何手机、本项目选3）
```


### 3、shell  打包流水线平台打包（可以忽略）
#### 输入指定字符存 
```
./shell/shell 0 2
echo -e ${string}
exit 0
#第一个参数0代表环境，参考1.1配置；第二个参数2代表证书，1代表开发证书，2代表企业证书
```

### 所以打包配置在config.plist文件里，如有证书变动，修改相应的profile、teamID、bundleID



