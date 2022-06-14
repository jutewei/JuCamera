#
# Be sure to run `pod lib lint JuCamera.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "JuCamera"
  s.version          = "1.0.0"
  s.summary          = "自定义相机"
  s.homepage         = "https://gitee.com/juvid/JuCamera"
  s.author           = { "cmb" => "jutewei@163.com" }
  s.license          = {
    :type => 'Copyright',
    :text => <<-LICENSE
    © 2021-2022 pingan. All rights reserved.
    LICENSE
  }
  s.platform         = :ios, '9.0'
  s.requires_arc     = true
  s.source           = { :git => "https://gitee.com/juvid/JuCamera.git" , :tag => s.version}
  
  s.subspec 'PABase' do |n|
      n.source_files = 'Source/base/*.{h,m}'
  end
  
  s.subspec 'Core' do |n|
      n.source_files = 'Source/*.{h,m}'
  end
   
end
