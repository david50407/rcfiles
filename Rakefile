require 'fileutils'
require 'tempfile'

task :default do
  puts "Welcome to use Davy's automatic tool for installing rcfiles!"
  puts "  `rake bash`    for `.bash_profile`, `.bashrc`, `powerline-bash.py` installation"
  puts "  `rake screen`  for `.screenrc`      installation"
  puts "  `rake vim`     for `.vim`, `.vimrc` installation"
  puts "  `rake git`     for `.gitconfig`     installation"
  puts "  `rake install` for above all installation"
  puts "  `rake install[NAME]` for above and set unique ID for powerline"
end

def unique_powerline(name = "")
  t_file = Tempfile.new('.powerline-bash.py.tmp')
  File.open File.join(Dir.home, 'powerline-bash.py'), 'r' do |f|
    f.each_line do |line|
      if line =~ /^UNIQUEID/
        t_file.puts %(UNIQUEID = "#{name}")
      else
        t_file.puts line.rstrip
      end
    end
  end
  t_file.close
  mv t_file.path, File.join(Dir.home, 'powerline-bash.py')
  FileUtils.chmod '+x', File.join(Dir.home, 'powerline-bash.py')
end

task :install, [:name] => [:bash, :screen, :vim, :git] do |t, args|
  args.with_defaults(:name => "")
end

task :copy_bash_profile do
  cp '.bash_profile', File.join(Dir.home, '.bash_profile')
end

task :copy_powerline do
  cp 'powerline-bash.py', File.join(Dir.home, 'powerline-bash.py')
  FileUtils.chmod '+x', File.join(Dir.home, 'powerline-bash.py')
end

task :copy_bashrc do
  cp '.bashrc', File.join(Dir.home, '.bashrc')
end

multitask :bash, [:name] => [:copy_bash_profile, :copy_powerline, :copy_bashrc] do |t, args|
  args.with_defaults(:name => "")
  `source ~/.bashrc`
  unique_powerline args.name unless args.name.empty?
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
end
