#!/usr/bin/env ruby -wKU
# encoding: UTF-8

require "fileutils"

def fail message
  puts "ERROR: " + message
  exit(-1)
end

def log message
  stars =  '*' * (message.length + 6)
  puts "\n"
  puts stars
  puts '*  ' + message + '  *'
  puts stars + "\n"
end

def install_brew
  puts 'Installing Homebrew...'
  system %Q[ruby -e "$(curl -fsSkL raw.github.com/mxcl/homebrew/go)"] or fail 'Brew installation failed'
  system %Q[brew doctor]
end

def install_rvm_ruby_reqs
  puts 'RVM requirements...'
  system %Q[brew tap homebrew/dupes]
  system %Q[brew install bash curl git]
  puts 'Ruby requirements...'
  system %Q[brew install autoconf automake apple-gcc42 libtool pkg-config openssl readline libyaml sqlite libxml2 libxslt libksba]
end

def install_rvm_ruby
  puts 'Installing RVM and Ruby...'
  system %Q[curl -L https://get.rvm.io | bash -s stable --ruby] or fail 'RVM & Ruby Installation failed'
end

# Homebrew
log 'Homebrew...'
brew_check = `which brew`
if brew_check
  puts "You have #{`brew -v`}"
else
  install_brew
  puts "Brew done.\n"
end

# RVM && Ruby
log 'RVM & Ruby'
rvm_check = `which rvm`
if rvm_check
  puts "You have #{`rvm -v`}"
else
  install_rvm_ruby_reqs
  install_rvm_ruby
  puts "RVM & Ruby done.\n"
end

# check Ruby
ruby_check = `which ruby`
if ruby_check
  puts "You have #{`ruby -v`}"
else
  system %Q[rvm install ruby] or fail 'Ruby installation failed'
end

# builder
log 'Setuping Builder'
# clone repo
system %Q[git clone git://github.com/dev4dev/bs_modulo.git builder]
# instal bundler
system %Q[gem install bundler]
FileUtils.cd 'builder' do
  # install dep gems
  system %Q[bundle install]
  # create link
  system %Q[ln -s "`pwd`/build.rb" /usr/local/bin/builder]
end

#  Add /usr/local/bin to $PATH
system %Q[echo '\n\nPATH="/usr/local/bin:$PATH"\n' >> ~/.profile]
