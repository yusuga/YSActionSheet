Pod::Spec.new do |s|
  s.name = 'YSActionSheet'
  s.version = '0.2.13'
  s.summary = 'Customizable action sheet.'
  s.homepage = 'https://github.com/yusuga/YSActionSheet'
  s.license = 'MIT'
  s.author = 'Yu Sugawara'
  s.source = { :git => 'https://github.com/yusuga/YSActionSheet.git', :tag => s.version.to_s }
  s.platform = :ios, '7.0'
  s.ios.deployment_target = '7.0'
  s.source_files = 'Classes/YSActionSheet/**/*.{h,m}'
  s.resources    = 'Classes/YSActionSheet/**/*.{xib,storyboard}'
  s.requires_arc = true
  s.compiler_flags = '-fmodules'
end