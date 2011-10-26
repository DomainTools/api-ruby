desc "Bundle gem"
task :bundle do
  begin
    require 'jeweler'
    Jeweler::Tasks.new do |gem|
      gem.name = "domain_tools"
      gem.summary = "Ruby gem for requesting domaintools.com webservices"
      gem.description = "Ruby wrapper of the domaintools.com API, allowing you to easily request any service available on domaintools.com"
      gem.email = "MemberServices@DomainTools.com"
      gem.homepage = "http://www.domaintools.com/api/"
      gem.authors = ["DomainTools, LLC"]
    end
  rescue LoadError
    puts "Jeweler not available. Install it with: gem install jeweler"
  end
end

desc  "Start unit tests with bunlde gems"
task :test do
  sh "bundle exec ruby -Itest tests/unit.rb"
end

desc "Open an irb session preloaded with this library"
task :debug do
  sh "irb -rubygems -I lib -r domain_tools.rb"
end
