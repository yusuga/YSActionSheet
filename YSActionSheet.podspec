Pod::Spec.new do |s|
  s.name = 'YSActionSheet'
  s.version = '0.1.1'
  s.summary = 'Customized ActionSheet.'
  s.homepage = 'https://github.com/yusuga/YSActionSheet'
  s.license = 'MIT'
  s.author = 'Yu Sugawara'
  s.source = { :git => 'https://github.com/yusuga/YSActionSheet.git', :tag => s.version.to_s }
  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/YSActionSheet/*.{h,m}'
  s.resources    = 'Classes/YSActionSheet/*.storyboard'
  s.requires_arc = true
  s.compiler_flags = '-fmodules'
  
  s.prefix_header_contents = "#import <YSCocoaLumberjackHelper/YSCocoaLumberjackHelper.h>
#ifdef DEBUG
    static const DDLogLevel ddLogLevel = DDLogLevelAll;
#else
    static const DDLogLevel ddLogLevel = DDLogLevelError;
#endif"
  
  s.dependency 'YSCocoaLumberjackHelper'
end