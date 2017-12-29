require 'spec_helper'
require 'serverspec'

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