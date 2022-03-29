Pod::Spec.new do |s|

    s.name = 'MultiScrollContainer'
    s.version = '2.0.0'
    s.license = { :type => 'MIT' }
    s.homepage = 'https://github.com/iWECon/MultiScrollContainer'
    s.authors = 'Pansitong iWw'
    s.ios.deployment_target = '10.0'
    s.summary = 'MultiScrollContainer 嵌套滑动库'
    s.source = { :git => 'https://github.com/iWECon/MultiScrollContainer.git', :tag => s.version }
    s.source_files = [
        'Sources/**/*.swift',
    ]
    
    s.cocoapods_version = '>= 1.10.0'
    s.swift_version = ['5.3']
    
    # dependencies
    s.dependency 'Pager'
    s.dependency 'SegmentedController'
    s.dependency 'Segmenter'
    s.dependency 'YTPageController'
    
end
