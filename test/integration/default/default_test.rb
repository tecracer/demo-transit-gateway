
describe http('http://10.0.1.16') do
  its('status') { should cmp 200 }
  its('body') { should eq 'Node A' }
end

describe http('http://10.0.2.16') do
  its('status') { should cmp 200 }
end

describe http('http://10.0.3.16') do
  its('status') { should cmp 200 }
end

