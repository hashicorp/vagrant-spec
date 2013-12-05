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
