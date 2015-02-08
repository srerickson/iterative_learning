# Iterative Learning (IL)

IL is a web application for conducting iterative/function learning (?) experiments on the web. It also includes Amazon Mechanical Turk integration.

requires ruby version => 2.0, bundler

## Installation

#### Prerequisites
Make sure you have working `ruby` and `gem`
```
$ ruby -v
> ruby 2.0.0p481 (2014-05-08 revision 45883) [universal.x86_64-darwin13]
$ gem -v
> 2.0.14
```

Install `bundler` if you don't have it:
```
gem install bundler
```
or if you don't have permissions to install system gems: 
```
$ gem install --user-install bundler
$ PATH="$(ruby -rubygems -e 'puts Gem.user_dir')/bin:$PATH"
```

#### General Install
grab the code:
```
$ git clone https://github.com/srerickson/iterative_learning.git
$ cd iterative_learning
```
Install dependencies:
```
$ bundle install
```

Setup the sqlite database (`experiment_data.db`)
```
$ bundle exec rake db:migrate
```

Create experiment config file from supplied sample
```
$ cp config/experiments.sample.yml config/experiments.yml
```

If you want to use Mechanical Turk to run the experiment, you will need enter your AWS credentials: 
```
$ ruby-aws
```

Build the experiment
```
$ bundle exec rake il:build
```

Make sure the experiment was successfully generated:
```
$ bundle exec rake il:list
> loading environment ... 
> test_experiment	| eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9... [<- Note your experiment key]
```

Start the server:
```
$ bundle exec thin start --port 3000 -R config.ru
```

Confirm the experiment is running by pointing your browser to: 
```
http://localhost:3000/#/experiment?key=[EXPERIMENT_KEY]
```


## Configuration

The default config file is `config/experiments.yml`. See comments in [experiments.sample.yml](https://github.com/srerickson/iterative_learning/blob/master/config/experiments.sample.yml) for description of available config options.

After modifying `config/experiments.yml`, you need update the database:
```
$ bundle exec rake il:rebuild
```
THIS IS DESTRUCTIVE -- the existing experiments will be removed

To selectively rebuild specific experiments: 
```
$ bundle exec rake il:rebuild[experiment_name]
```

To remove an experiment from the database:
```
$ bundle exec rake il:remove[experiment_name]
```



