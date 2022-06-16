#打包环境  app-store, ad-hoc, enterprise, development

#最开始路径工程绝对路径
base_Path=$(pwd)
echo "根目录 $base_Path  $1"
CONFIG_INFO_PATH=$base_Path/config.plist

#工程名路径
workspace_path=$(/usr/libexec/PlistBuddy -c "Print path" "$CONFIG_INFO_PATH")

#获取配置文件
workspace_name=$(/usr/libexec/PlistBuddy -c "Print workspace" "$CONFIG_INFO_PATH")
project_name=$(/usr/libexec/PlistBuddy -c "Print project" "$CONFIG_INFO_PATH")
scheme_name=$(/usr/libexec/PlistBuddy -c "Print scheme" "$CONFIG_INFO_PATH")

ipa_name=$project_name

echo "配置  $workspace_name $project_name $ipa_name"


if [ "$1" == 'Release' ];then
development_mode=Release
exportOptionsPlistPath=$base_Path/ExportRelease.plist
else
development_mode=$1
exportOptionsPlistPath=$base_Path/ExportDebug.plist
fi


IpaSuffix="$development_mode"
echo "证书路径 $exportOptionsPlistPath"

#workspace路径
project_path=$(cd $workspace_path ;pwd)
#资源路径
resource_path=${base_Path}/.package/$(date +%Y-%m-%d)
#build文件夹路径
build_path=$resource_path/build/${development_mode}


echo '*** 正在 清理工程 ***'
xcodebuild \
clean -project ${project_path}/${project_name}.xcodeproj \
-scheme ${scheme_name} \
-configuration ${development_mode} -quiet  || exit
echo '*** 清理完成 ***'


echo '*** 正在 编译工程 For '${development_mode}
xcodebuild \
archive -workspace ${workspace_path}/${workspace_name}.xcworkspace \
-scheme ${scheme_name} \
-configuration ${development_mode} \
-archivePath ${build_path}/${project_name}.xcarchive -quiet  || exit
echo '*** 编译完成 ***'

exportFilePath=$resource_path/ipa/${development_mode}

echo '*** 正在 打包 ***'
buildIpa(){
    xcodebuild -exportArchive -archivePath ${build_path}/${project_name}.xcarchive \
    -configuration ${development_mode} \
    -exportPath $1 \
    -exportOptionsPlist $2 \
    -quiet || exit
}

buildIpa ${exportFilePath} ${exportOptionsPlistPath}

#包名
ipaPath="${exportFilePath}/${project_name}.ipa"


if [ -e $ipaPath ]; then
echo "*** .ipa文件已导出 ${ipaPath}***"
open $exportFilePath
else
echo "*** 创建.ipa文件失败 ***"
fi
echo '*** 打包完成 ***'

#时间

renameIpa="${base_Path}/.package/${scheme_name}.ipa"
#重命名
mv $ipaPath $renameIpa
