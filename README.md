# Werkzeug

Collection of every day tools for your Ruby projects.

## Description

To reduce overhead and to avoid to re-invent often used patterns and helper classes this gem offers you a toolset of optimized classes and helper methods. All parts are implemented with focus on fast code avoiding any overhead.

### Features Overview

<dl>
  <dt>CustomExceptions</dt>
  <dd>Allows you to define hierarchies of exceptions with standard text.</dd>

  <dt>DataFile</dt>
  <dd>Offers access to <code>__DATA__</code> sections (like inline templates like in <a href="https://github.com/sinatra/sinatra#inline-templates" rel="nofollow">Sinatra</a>).</dd>

  <dt>Events</dt>
  <dd>Implements an easy to use event subscription and handling algorithm.</dd>

  <dt>Future</dt>
  <dd>Powerful asynchronous code execution with a very small footprint. Uses `ThreadPool` (see below).</dd>

  <dt>HostOS</dt>
  <dd>Information about the underlying OS of your project.</dd>

  <dt>PidFile</dt>
  <dd>Allows to check and run a single instance of your application.</dd>

  <dt>PrefixedCalls</dt>
  <dd>Module can be included in any class to call all methods with given prefix via `#call_all`.</dd>

  <dt>SequenceFactory</dt>
  <dd>Simple factory to create sequences of given elements.</dd>

  <dt>ThreadPool</dt>
  <dd>Small but powerful thread pool implementation.</dd>

  <dt>ToolFunctions</dt>
  <dd>A set of tool functions to define enumerable and constants .</dd>
</dl>

### Installation

Use [Bundler](http://gembundler.com/) to use Werkzeug in your own project:

Add to your `Gemfile`:

```ruby
gem 'werkzeug'
```

and install it by running Bundler:

```bash
$ bundle
```

To install the gem globally use:

```bash
$ gem install werkzeug
```

After that you need only a single line of code in your project code to have all tools on board:

```ruby
require 'werkzeug'
```

### Some More Help

Please, have a look at the [tests](https://github.com/mblumtritt/werkzeug/blob/master/test) for better understanding of the tools.
