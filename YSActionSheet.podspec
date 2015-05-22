Pod::Spec.new do |s|
  s.name = 'YSActionSheet'
  s.version = '0.2.0'
  s.summary = 'Customizable action sheet.'
  s.homepage = 'https://github.com/yusuga/YSActionSheet'
  s.license = 'MIT'
  s.author = 'Yu Sugawara'
  s.source = { :git => 'https://github.com/yusuga/YSActionSheet.git', :tag => s.version.to_s }
  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/YSActionSheet/*.{h,m}'
  s.requires_arc = true
  s.compiler_flags = '-fmodules'
  
  s.prefix_header_contents = "#import <LumberjackLauncher/LumberjackLauncher.h>"
  
  s.dependency 'LumberjackLauncher'
  
  s.subspec 'Utility' do |ss|
    ss.source_files = 'Classes/YSActionSheet/Utility/*.{h,m}'
  end
  
  s.subspec 'Model' do |ss|
    ss.source_files = 'Classes/YSActionSheet/Model/*.{h,m}'
  end
  
  s.subspec 'View' do |ss|
    ss.dependency 'YSActionSheet/Utility'
    ss.source_files = 'Classes/YSActionSheet/View/*.{h,m}'
    ss.resources    = 'Classes/YSActionSheet/View/*.xib'
  end
  
  s.subspec 'ViewController' do |ss|
    ss.dependency 'YSActionSheet/View'
    ss.dependency 'YSActionSheet/Model'
    ss.source_files = 'Classes/YSActionSheet/ViewController/*.{h,m}'
    ss.resources    = 'Classes/YSActionSheet/ViewController/*.storyboard'
  end
end