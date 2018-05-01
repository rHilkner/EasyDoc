# Uncomment the next line to define a global platform for your project
platform :ios, '11.0'

target 'EasyDoc' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EasyDoc
  pod 'Firebase/Database'
  pod 'Firebase/Core'
  pod 'Firebase/Auth'

  target 'EasyDocTests' do
      inherit! :search_paths
  end
end

# Ignoring "CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF" warning ("Block implicitly retains 'self'; explicitly mention 'self' to indicate this is intended behavior. Insert 'self->'.")
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['CLANG_WARN_OBJC_IMPLICIT_RETAIN_SELF'] = 'NO'
    end
  end
end