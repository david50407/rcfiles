require 'fileutils'
require 'tempfile'

task :default do
  puts "Welcome to use Davy's automatic tool for installing rcfiles!"
  puts "  `rake bash`    for `.bash_profile`, `.bashrc`, `powerline-shell-clearly.py` installation"
  puts "  `rake screen`  for `.screenrc`                                              installation"
	puts "  `rake vim`     for `.vim`, `.vimrc`                                         installation"
	puts "  `rake git`     for `.gitconfig`, `.gitignore_global`                        installation"
	puts "  `rake tool`    for `.config/opt`                                            installation"
  puts "  `rake install` for above all installation"
end

task :install, [:name] => [:bash, :screen, :vim, :git, :tool] do |t, args|
  args.with_defaults(:name => "")
end

task :copy_bash_profile do
  cp '.bash_profile', File.join(Dir.home, '.bash_profile')
end

task :copy_powerline do
  cp 'powerline-shell-clearly.py', File.join(Dir.home, 'powerline-shell-clearly.py')
  FileUtils.chmod '+x', File.join(Dir.home, 'powerline-shell-clearly.py')
end

task :copy_bashrc do
  cp '.bashrc', File.join(Dir.home, '.bashrc')
end

multitask :bash, [:name] => [:copy_bash_profile, :copy_powerline, :copy_bashrc] do |t, args|
  args.with_defaults(:name => "")
  `source ~/.bashrc`
end

task :screen do
  cp '.screenrc', File.join(Dir.home, '.screenrc')
  sty = `echo $STY`
  `screen -X source #{File.join(Dir.home, '.screenrc')}` unless sty == ''
end

task :copy_vimrc do
  cp '.vimrc', File.join(Dir.home, '.vimrc')
end

task :copy_vim do
  cp_r '.vim/', File.join(Dir.home, '.vim/')
end

multitask :vim => [:copy_vimrc, :copy_vim] do
  puts "Installing Vundle and bundles, please wait."
  `vim +BundleInstall +qall`
end

task :git do
  cp '.gitconfig', File.join(Dir.home, '.gitconfig')
  cp '.gitignore_global', File.join(Dir.home, '.gitignore_global')
end

task :tool do
	cp_r '.config/opt/', File.join(Dir.home, '.config/opt/')
end
