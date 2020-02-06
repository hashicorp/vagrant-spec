Chef::Config.chef_license = 'accept'

file "/vagrant-chef-basic" do
  content "basic"
end
