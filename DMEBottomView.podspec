Pod::Spec.new do |s|
  s.name     = 'DMEBottomView'
  s.version  = '0.1.0'
  s.license  = 'None'
  s.summary  = 'Bottom View Controller'
  s.homepage = 'https://github.com/damarte/BZGFormViewController'
  s.author   = { 'David Martínez' => 'damarte86@gmail.com' }
  s.source   = {
    :git => 'https://github.com/damarte/DMEBottomView.git',
    :tag => '0.1.0'
  }
  s.requires_arc = true
  s.platform = :ios, '5.0'
  s.source_files = 'DMEBottomView/*.{h,m}'
end
