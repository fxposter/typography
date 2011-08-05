#!/bin/sh
# script by http://pivotallabs.com/users/jdean/blog/articles/1728-testing-your-gem-against-multiple-rubies-and-rails-versions-with-rvm

set -e

if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  source "/usr/local/rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
fi

function run {
  gem list --local bundler | grep bundler || gem install bundler --no-ri --no-rdoc
  bundle install > /dev/null
  bundle exec rspec spec
}

for version in 'ruby-1.8.7@typographer' 'ree-1.8.7@typographer' 'ruby-1.9.2@typographer' 'rbx-master@typographer'
	do
		rvm use $version --create
		run
	done

echo 'Success!'

