Pod::Spec.new do |s|
  s.name         = "pocpockaiksi"
  s.version      = "0.1.0"
  s.summary      = "PoC for dependency confusion just testing please don't ban"
  s.description  = "Simple exfil test via hostname + IP."
  s.homepage     = "https://example.com"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "kaiksi" => "you@example.com" }
  s.source       = { :git => "https://github.com/kiks2627/pocpockaiksi.git", :tag => "#{s.version}" }
  s.ios.deployment_target = "12.0"
  s.source_files = "Sources/**/*.swift"
end

