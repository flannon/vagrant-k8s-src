# Targets build available ansible environmwents
# 
.PHONY: k8s-src
#k8s-src:
#	sed -i '' 's/templates/k8s-src/g' Vagrantfile
#	sed -i '' 's/192.168.0.1/172.39.144.99/g' Vagrantfile
#	sed -i '' 's/CPUS \= \"2\"/CPUS \= \"4\"/g' Vagrantfile
#	sed -i '' 's/MEMORY \= \"1024\"/MEMORY \= \"6144\"/g' Vagrantfile
#	vagrant up
#
#.PHONY: clean
#clean:
#	rm -f Vagrantfile
#	git checkout Vagrantfile
