#!/usr/bin/env python3

import subprocess
import yaml

# Get Terraform outputs
control_plane_ip = subprocess.run(
    ["terraform", "output", "-raw", "control_plane_ip"],
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
    "all": {
        "hosts": {
            "control-plane": {
                "ansible_host": control_plane_ip,
                "ansible_user": "ubuntu"
            },
            "worker-node": {
                "ansible_host": worker_node_ip,
                "ansible_user": "ubuntu"
            }
        },
        "children": {
            "kube_control_plane": {
                "hosts": {
                    "control-plane": None
                }
            },
            "etcd": {
                "hosts": {
                    "control-plane": None
                }
            },
            "kube_node": {
                "hosts": {
                    "worker-node": None
                }
            },
            "calico_rr": {
                "hosts": {}
            },
            "k8s_cluster": {
                "children": {
                    "kube_control_plane": None,
                    "kube_node": None
                }
            }
        }
    }
}

# Write the inventory to a YAML file
with open("inventory.yml", "w") as file:
    yaml.dump(inventory, file, default_flow_style=False, sort_keys=False)

print("inventory.yml file created successfully!")