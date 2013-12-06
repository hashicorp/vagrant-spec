# Vagrant Spec

**Work-in-progress:** This library is not ready for general use yet and
is under active development. The documentation will become much better once
this is more easily usable.

`vagrant-spec` is a both a specification of how Vagrant and its various
components should behave as well as a library of testing helpers that
let you write your own unit and acceptance tests for Vagrant.

The library provides a set of helper methods in addition to
[RSpec](https://github.com/rspec/rspec) matchers and expectations to help
you both unit test and acceptance test Vagrant components. The RSpec
components are built on top of the helper methods so that the test library
can be used with your test framework of choice.

## Running Acceptance Tests

This section documents how acceptance tests can be configured, run, and
written. Acceptance tests test Vagrant as a black box: they configure some
Vagrant environment (by creating a Vagrantfile and perhaps other files),
execute Vagrant, and assert some sort of result. They have _zero_ access
to the code internals.

`vagrant-spec` contains a set of acceptance tests that can easily verify
the behavior of Vagrant. It also provides a framework for writing new
acceptance tests that can easily be executed in the context of Vagrant.

### Configuration

Before running the acceptance tests, you must first configure
`vagrant-spec.` Configuration is done by creating the file 
`vagrant-spec.config.rb`. It looks like the following:

```ruby
Vagrant::Spec::Acceptance.configure do |c|
  # ...
end
```

The available options for `c` and their defaults are fully documented
in [the configuration source file](https://github.com/mitchellh/vagrant-spec/blob/master/lib/vagrant-spec/acceptance/configuration.rb). Please read through the documentation thoroughly and
implement what you need.

### Running

Running the full suite of acceptance tests can be horribly long.
It is recommended you only run a component at a time (or a handful
of components). To view the list of testable components based on 
your configuration, run `vagrant-spec components`. You might
see something like the following:

```
$ vagrant-spec components
cli
provider/virtualbox/basic
provider/virtualbox/provisioner/shell
provider/virtualbox/synced_folder
```

Choose a component to run, and run it:

```
$ vagrant-spec run --components cli
...
```

That component will be tested.

## Writing Acceptance Tests

In addition to running the tests that already exist, `vagrant-spec`
makes it trivial to write new acceptance tests. This is especially
useful if you're writing your own plugin.

All new tests must go within their own folder in your project.
For the sake of these docs, put your tests in the `vagrant-spec`
folder.

### Configuring Component Paths

For `vagrant-spec` to know about new tests you write, you must
add the path that will hold the Ruby files to the configuration
"component_paths". These are the paths where the tests are 
automatically loaded from by `vagrant-spec`. Example:

```ruby
Vagrant::Spec::Acceptance.configure do |c|
  c.component_paths << "vagrant-spec"
end
```

If the path is relative, it will be relative to the pwd when 
`vagrant-spec` is executed.

### Standalone Components

If your plugin doesn't depend on a specific provider, then it is
known as a _component_ (specifically a standalone one) of
`vagrant-spec.` Create a new file in the `vagrant-spec` folder
of your project with something that looks like the following:

```ruby
describe "my test", component: "my-test" do
  include_context "acceptance"

  it "can output the version" do
    expect(execute("vagrant", "-v")).to exit_with(0)
  end
end
```

This should be fairly straightforward RSpec code. The key
things are:

* `component: "my-test"` in the describe definition. This is read
  by `vagrant-spec` and will be what is outputted in by
  `vagrant-spec components`. Set this to something unique. The actual
  name of the describe block (in this case "my test") doesn't matter
  except for output.

* `include_context "acceptance"` exposes important helpers such
  as the `execute` method used. These helpers allow you to execute
  Vagrant in a completely isolated environment so it doesn't mess up
  any actual Vagrant state that may be setup on your computer.

And that's it for writing a custom component. You should be able to
see it when you run `vagrant-spec components` and you should also
be able to run it.

### Provider Parameterized Components

Tests that require a provider (basically any test that executes
`vagrant up`) are known as provider parameterized components. They
will be executed for every provider under test. 

These are useful, for example, for provisioners. Provisioners should
work regardless of what provider is running them. Therefore, if you're
testing VirtualBox and VMware, you want to be sure that the "shell"
provisioner works, for example. 

Provider parameterized components are implemented as RSpec
shared examples:

```ruby
shared_examples "provider/foo" do |provider, options|
  it "does things" do
    puts "Executing for provider: #{provider}"
  end
end
```

The key things in this are:

* The `provider/` prefix in the name of the shared example group.
  `vagrant-spec` treats this specially as a provider parameterized
  component. A new component will automatically be created by
  `vagrant-spec` for every provider.

* The `|provider, options|` parameters to the shared example group. 
  Parameterized components are, as they're named, parameterized. 
  The two parameters they receive are the provider under test
  as well as any options for that provider.

If you have `vagrant-spec` configured to test a provider, then when
you run `vagrant-spec components`, you should see your component
listed:

```
$ vagrant-spec components
...
provider/virtualbox/foo
...
```

And you can now run the tests!
