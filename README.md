# ansible-test-kitchen

Test Kitchen is an integration tool for developing and testing infrastructure code on isolated target platforms. This repository has a test kitchen configuration which enables the test run of an ansible playbook and perform smoke tests in an ec2 instance created from the AMI specified in the kitchen configuration file.<br/>
<br/>
The main config file, kitchen.yml, has 4 sections:<br/>
driver: This is used to configured the kitchen driver which in our case is kitchen-ec2. This is whtat is used to create the server to test playbooks.<br/>
provisioner: This is the component that configures/converges the server.<br/>
platforms: This is a list of different OSs that will configuration will be tested on.<br/>
suites: This section is used for defining test-suites to run.</br>
verifier: Theis is where testing frameworks are defined. In our case we are using testinfra.

### Prerequisites
```
rvm (if using mac)
ruby 2.7.0
pip3 install testinfra paramiko ansible-lint
gem install test-kitchen
gem install kitchen-ansible
gem install kitchen-ec2
```

### Run Test
kitchen list
Shows the state of all the test servers that have been configured (refer back to the platforms section in .kitchen.yml):
docker build -t kitchen-ansible .
```
$ kitchen list
Instance           Driver  Provisioner      Verifier    Transport  Last Action
default-centos-6  Ec2  AnsiblePlaybook  Shell  Ssh        <Not Created>
```
This command can be used any time to show the state of the test servers.

kitchen create
Using kitchen create will move testing through to the Last Action=created state; for us, that means it will launch an ec2 instance.

```
$ kitchen create default-centos-6
-----> Starting Test Kitchen (v2.3.4)
-----> Creating <default-centos-6>...
       If you are not using an account that qualifies under the AWS
free-tier, you may be charged to run these suites. The charge
should be minimal, but neither Test Kitchen nor its maintainers
are responsible for your incurred costs.

       Instance <i-01884b8db87587ddd> requested.
       Polling AWS for existence, attempt 0...
       Attempting to tag the instance, 0 retries
       EC2 instance <i-01884b8db87587ddd> created.
       Waited 0/300s for instance <i-01884b8db87587ddd> volumes to be ready.
       Waited 0/300s for instance <i-01884b8db87587ddd> to become ready.
       Waited 5/300s for instance <i-01884b8db87587ddd> to become ready.
       Waited 10/300s for instance <i-01884b8db87587ddd> to become ready.
       Waited 15/300s for instance <i-01884b8db87587ddd> to become ready.
       Waited 20/300s for instance <i-01884b8db87587ddd> to become ready.
       Waited 25/300s for instance <i-01884b8db87587ddd> to become ready.
       EC2 instance <i-01884b8db87587ddd> ready (hostname: 10.220.236.165).
       Waiting for SSH service on 10.220.236.165:22, retrying in 3 seconds
       [SSH] Established
       Finished creating <default-centos-6> (1m56.06s).
-----> Test Kitchen is finished. (1m02.76s)
```

And after this we can check the state again:

```
$ kitchen list
Instance          Driver  Provisioner      Verifier  Transport  Last Action  Last Error
default-centos-6  Ec2     AnsiblePlaybook  Shell     Ssh        Created      <None>
```

kitchen login
We can now use the login command to access our Docker machine:

```
$ kitchen login default-centos-6
Last login: Sat Mar  7 20:56:56 2020 from 172.25.16.73
[centos@ip-10-220-236-165 ~]$ 
```

kitchen converge
This will run the ansible playbook provisioner to configure the ec2 instance. There is too much output to reproduce here, and note that at the time of writing, you can expect to see a lot of ugly debug output coming from kitchen-ansible’s decision-making around how to install Ansible itself.

kitchen verify
To actually run the testinfra unit tests, we proceed to the verify action:
```
$ kitchen verify
-----> Verifying <default-xesa>...
       [Shell] Verify on instance default-xesa with state={:server_id=>"i-01a7a6baa3fb9a7ec", :hostname=>"10.220.236.233", :last_action=>"setup", :last_error=>nil}
============================= test session starts ==============================
platform darwin -- Python 3.7.6, pytest-5.3.5, py-1.8.1, pluggy-0.13.1
rootdir: /Users/frodriguez/Documents/cloudfront_deployment/ansible
plugins: testinfra-5.0.0
collected 2 items

roles/httpd/test/integration/default/testinfra/test_default.py ..        [100%]

=============================== warnings summary ===============================
roles/httpd/test/integration/default/testinfra/test_default.py::test_port_80_is_listening[paramiko://10.220.236.233]
  /usr/local/lib/python3.7/site-packages/paramiko/client.py:837: UserWarning: Unknown ssh-rsa host key for 10.220.236.233: b'cc7e256cf641cdb920cfa3cf3ecc373c'
    key.get_name(), hostname, hexlify(key.get_fingerprint())

-- Docs: https://docs.pytest.org/en/latest/warnings.html
========================= 2 passed, 1 warning in 1.74s =========================
```

kitchen destroy
The last action is the destroy action, which simply destroys the ec2 instance.

kitchen test
The test action wraps around create, converge, setup, verify, and destroy, and automatically halts if any of these actions fail.
