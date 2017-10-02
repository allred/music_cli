require 'rake/testtask'

Rake::TestTask.new do |t|
  t.pattern = "test/test*.rb"
end

task :zip do
  system "git archive --format=zip -o music_cli.zip HEAD"
end
