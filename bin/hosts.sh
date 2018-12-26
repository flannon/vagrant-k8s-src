#!/bin/bash

# Red Hat Lab hosts
[[ $(grep '172.39.144.99 k8s-src.lab.example.com k8s-src' /etc/hosts) ]] || echo '172.39.144.99 k8-src.lab.example.com workstation' >> /etc/hosts

[[ $(grep '172.25.144.9 oc-src.lab.example.com oc-src' /etc/hosts) ]] || echo '172.39.144.9 oc-src.lab.example.com oc-src' >> /etc/hosts

