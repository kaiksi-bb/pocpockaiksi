Pod::Spec.new do |s|
  s.name         = "pocpockaiksi"
  s.version      = "0.4.0"
  s.summary      = "PoC for dependency confusion just testing please don't ban"
  s.description  = "Simple exfil test via hostname + IP."
  s.homepage     = "https://example.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "kaiksi" => "you@example.com" }
  s.source       = { :git => "https://github.com/kaiksi-bb/pocpockaiksi.git", :tag => s.version.to_s }
  s.ios.deployment_target = "12.0"
  s.source_files = "Sources/pocpockaiksi/**/*.swift"
  s.swift_version = '5.0'
end
