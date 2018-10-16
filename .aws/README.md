# Place a credentials file with AWS access keys

1. Login to [AWS IAM](https://console.aws.amazon.com/iam/home?region=ap-southeast-1#/users)
2. Create an account (__ansible__) for boto and ec2.py to provide Ansible a [Dynamic Inventory](http://docs.ansible.com/ansible/latest/intro_dynamic_inventory.html#example-aws-ec2-external-inventory-script) from AWS.
    * User name: ansible
    * Access type:
        * [x] Programmatic access
        * [ ] AWS Management Console access
3. Set the following environment variables in  (__../docker-compose.yml__):
    * aws_profile=ansible
4. To configure Boto and ec2.py, create a file at  (__.aws/credentials__) with the following contents:

  ```
  [ansible]
  aws_access_key_id = <your_access_key_here>
  aws_secret_access_key = <your_secret_key_here>
  region = ap-southeast-1
  ```

[How to Use Dynamic Inventory for AWS with Ansible?](http://www.tothenew.com/blog/how-to-use-dynamic-inventory-for-aws-with-ansible/)
