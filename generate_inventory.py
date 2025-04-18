#!/usr/bin/env python3

import subprocess
import yaml

# Get Terraform outputs
control_plane_dns = subprocess.run(
    ["terraform", "output", "-raw", "control_plane_dns"],
    capture_output=True,
    text=True
).stdout.strip()

control_plane_ip = subprocess.run(
    ["terraform", "output", "-raw", "control_plane_ip"],
    capture_output=True,
    text=True
).stdout.strip()

worker_node_dns = subprocess.run(
    ["terraform", "output", "-raw", "worker_node_dns"],
    capture_output=True,
    text=True
).stdout.strip()

worker_node_ip = subprocess.run(
    ["terraform", "output", "-raw", "worker_node_ip"],
    capture_output=True,
    text=True
).stdout.strip()

# Define the inventory structure
inventory = {
    'all': {
        'hosts': {
            control_plane_dns: {
                'ansible_host': control_plane_ip
            },
            worker_node_dns: {
                'ansible_host': worker_node_ip
            }
        },
        'children': {
            'kube_control_plane': {
                'hosts': {
                    control_plane_dns: ''
                }
            },
            'etcd': {
                'hosts': {
                    control_plane_dns: ''
                }
            },
            'kube_node': {
                'hosts': {
                    worker_node_dns: ''
                }
            },
            'k8s_cluster': {
                'children': {
                    'kube_control_plane': '',
                    'kube_node': ''
                }
            }
        }
    },
    'vars': {
        'ansible_ssh_common_args': ">-\n  -o ProxyCommand=\"ssh -W %h:%p -p 22 -i /root/.ssh/k8s_key ubuntu@72.44.43.146\"",
        'ansible_ssh_private_key_file': '/root/.ssh/k8s_key',
        'ansible_user': 'ubuntu'
    }
}

# Write the inventory to a YAML file
with open("inventory.yml", "w") as file:
    yaml.dump(inventory, file, default_flow_style=False, sort_keys=False)

print("inventory.yml file created successfully!")
