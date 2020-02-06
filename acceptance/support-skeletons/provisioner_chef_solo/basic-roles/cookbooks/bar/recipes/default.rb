Chef::Config.chef_license = 'accept'

file "/vagrant-chef-basic-roles" do
  content "basic-roles"
end
