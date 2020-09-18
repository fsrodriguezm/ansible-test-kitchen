require 'serverspec'
set :backend, :exec

describe port(80) do
  it { should be_listening }
end

describe port(90) do
  it { should_not be_listening }
end