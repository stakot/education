[defaults]
private_key_file = /home/sko/Documents/hillel2.pem 
remote_user = centos
host_key_checking = False

[ssh_connection]
ssh_args = '-o ProxyCommand="ssh -W %h:%p -q ec2-user@${bastion_ip} -i /home/sko/Documents/hillel2.pem"'