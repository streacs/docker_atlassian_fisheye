require 'spec_helper'
require 'serverspec'

describe group('fisheye') do
  it { should exist }
end

describe user('fisheye') do
  it { should exist }
  it { should belong_to_group 'fisheye' }
  it { should have_home_directory '/home/fisheye' }
  it { should have_login_shell '/bin/false' }
end

describe file('/opt/jdk') do
  it { should be_directory }
  it { should be_owned_by 'root' }
  it { should be_grouped_into 'root' }
end

describe file('/home/fisheye') do
  it { should be_directory }
  it { should be_owned_by 'fisheye' }
  it { should be_grouped_into 'fisheye' }
end

describe file('/opt/atlassian/fisheye') do
  it { should be_directory }
  it { should be_owned_by 'fisheye' }
  it { should be_grouped_into 'fisheye' }
end

describe file('/var/opt/atlassian/application-data/fisheye') do
  it { should be_directory }
  it { should be_owned_by 'fisheye' }
  it { should be_grouped_into 'fisheye' }
end

describe file('/opt/atlassian/fisheye/bin/fisheyectl.sh') do
  it { should contain '-Xms2g' }
  it { should contain '-Xmx4g' }
  it { should contain '-server' }
  it { should contain 'FISHEYE_INST=/var/opt/atlassian/application-data/fisheye' }
end