Pod::Spec.new do |s|
  s.name = 'Kaeru'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.homepage = 'https://github.com/bannzai/'
  s.summary = 'Switch viewcontroller like ios task manager'
  s.authors = { 'bannzai' => 'kingkong999yhirose@gmail.com' }
  s.source = { :git => 'https://github.com/bannzai/Kaeru.git', :tag => s.version }

  s.ios.deployment_target = '9.0'
  
  s.source_files = 'Kaeru/*.swift'
  s.resources = 'Kaeru/*.xib'
end
