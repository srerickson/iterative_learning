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

Create settings config files from supplied sample
```
$ cp config/settings.sample.yml config/settings.yml

```

You should change the `secret` setting in config/settings.yml to something unique to help secure your application. 

If you want to use Mechanical Turk to run the experiment, you will need enter your AWS credentials: 
```
$ ruby-aws
```

Build the provided sample experiment
```
$ bundle exec rake il:build[example_basic]
```

Make sure the experiment was successfully generated:
```
$ bundle exec rake il:list
> loading environment ... 
> Found 1 experiment(s)
> ------------------------------------------
> name: example_basic
> description: This is an example experiment.
> access key: eyJ0eXAiOiJKV1Qi.... 
------------------------------------------
```

Start the server:
```
$ bundle exec thin start --port 3000 -R config.ru
```

Confirm the experiment is running by pointing your browser to: 
```
http://localhost:3000/#/experiment?key=[ACCESS KEY]
```
(Use the access key listed from the `rake il:list` command)


## Configuration

Experiments configuration files are stored in the `experiments` folder. Several examples are provided.

To create a new experiment, copy one the provided examples, and edit the file as needed.
```
$ cp experiments/example_basic.yml experiments/your_new_experiment.yml
```

Then build it: 
```
$ bundle exec rake il:build[your_new_experiment]
```

If you make changes to the experiment configuration, you will need to rebuild it to make the changes live. Any collected data will be lost!

To remove an experiment from the database:
```
$ bundle exec rake il:remove[your_new_experiment]
$ bundle exec rake il:build[your_new_experiment]

```



