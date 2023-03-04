# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

shared_examples "provider/provisioner/puppet" do |provider, options|
  box = options[:box_puppet] || options[:box]
  if !box
    raise ArgumentError,
      "box_basic option must be specified for provider: #{provider}"
  end

  include_context "acceptance"

  before do
    environment.skeleton("provisioner_puppet")
    assert_execute("vagrant", "box", "add", "box", box)
    assert_execute("vagrant", "up", "--provider=#{provider}")
  end

  after do
    assert_execute("vagrant", "destroy", "--force")
  end

  it "provisions with puppet" do
    status("Test: basic manifests")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-puppet-basic")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/basic$/)

    status("Test: basic modules")
    result = execute("vagrant", "ssh", "-c", "cat /vagrant-puppet-basic-modules")
    expect(result).to exit_with(0)
    expect(result.stdout).to match(/modules$/)
  end
end
