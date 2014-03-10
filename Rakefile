task :default => [:bash, :screen, :vim, :git] do

end

task :copy_bash_profile do
  cp '.bash_profile', File.join(Dir.home, '.bash_profile')
end

task :copy_powerline do
  cp 'powerline-bash.py', File.join(Dir.home, 'powerline-bash.py')
end

task :copy_bashrc do
  cp '.bashrc', File.join(Dir.home, '.bashrc')
end

multitask :bash => [:copy_bash_profile, :copy_powerline, :copy_bashrc] do
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
  cp_r '.vim', File.join(Dir.home, '.vim')
end

multitask :vim => [:copy_vimrc, :copy_vim] do
  `vim +BundleInstall +qall`
end

task :git do
  cp '.gitconfig', File.join(Dir.home, '.gitconfig')
end
