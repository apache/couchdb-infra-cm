CouchDB Infrastructure Config Management
===

This repository contains Ansible scripts for managing our VM testing
infrastructure.

Setup
---

    $ python3 -m venv venv
    $ source venv/bin/activate
    $ pip install -r requirements.txt

On BigSur Mac may have to do:

    $ env LDFLAGS="-L$(brew --prefix openssl@1.1)/lib" CFLAGS="-I$(brew --prefix openssl@1.1)/include" pip install -r requirements.txt

Provisioning VMs
---

The basic steps to provisioning a new Jenkins agent node are:

1. Provision new VM using https://cloud.ibm.com
2. Run `./tools/gen-config`
3. Create the agent in Jenkins (copying an existing node is easiest)
4. Encrypt the Jenkins secret using `ansible-vault`
5. Store the new secret in the appropriate `host_vars/hostname.yml` file
6. Run `ansible-playbook ci_agents.yml`

Node names should follow this pattern:

```
couchdb-worker-$arch-$osname-$zone-$node_id
```

I.e.:

```
couchdb-worker-x86-64-debian-dal-1-01
```

Bastion VMs
---

There should be a single bastion VM setup for each subnet. We just use the
cheapest cx2-2x4 instance for these nodes so that we can jump to the other
hosts.

Provisioning a bastion VM is much the same as for a ci_agent though should
happen much more rarely. Currently the assumption is that each subnet has
exactly one bastion. The `./tools/gen-config` script will complain if this
assumption is violated so it should be obvious if we get this wrong. It will
also complain if we have a subnet that is missing a bastion box.

The steps for provisioning a new bastion box are:

1. Provision the VM using https://cloud.ibm.com
2. Run `./tools/gen-config`
2. Include the generated `ssh.cfg` in `~/.ssh/config` file
3. Run `ansible-playbook bastions.yml`

Bastion names should follow this pattern:

```
couchdb-bastion-$arch-$osname-$zone-$node_id
```

I.e.,

```
couchdb-bastion-x86-64-debian-dal-1-01
```


Running `./tools/gen-config`
---

Create a `~/.couchdb-infra-cm.cfg` file that contains the following options:

    [ibmcloud.<environment>]
    api_key = <REDACTED>
    api_url = https://us-south.iaas.cloud.ibm.com/v1
    crn = crn:v1:...
    instance_id = 123-abc...

    [extra.<instancename>]
    ip_addr = x.y.z.w
    arch = s390x
    num_cpus = 4
    ram = 8

`<environment>` is a tag used to differentiate multiple environments. It allows
fetching instances from more than one IBM Cloud accounts. If `api_url` is
provided, it will be used to fetch VPC instances. By default is uses
`"https://us-south.iaas.cloud.ibm.com/v1"`. The `crn` field will be added as a
`CRN: <crn>` header if provided. `instance_id` is used only by the `power`
environment. (See `Power Instances` section for more details).

`extra.<instancename>` can be an extra unmanaged manually added instance which
is not discoverable via cloud.ibm.com with an API key.

The `tools/gen-config` script can then be used to generate our `production`
inventory and `ssh.cfg` configuration:

    $ ./tools/gen-config

This script requires access to the `https://cloud.ibm.com` account that hosts
the VMs so not everyone will be able to run this script. However this is only
important when provisioning new nodes. Modifying ansible scripts and apply
changes to existing nodes can be done by any CouchDB PMC member that's been
added to the CI nodes via this repository.

Running Ansible Playbooks
---

    $ ansible-playbook bastions.yml
    $ ansible-playbook ci_agents.yml

Running Ad Hoc Commands
---

    % ansible -i production ci_agents -a "sudo sv restart jenkins"
    % ansible -v -i production ci_agents -a "sudo apt list --upgradable"
    % ansible -v -i production ci_agents -a "sudo unattended-upgrade -v"


Useful Commands:
---

(Assuming the generated `ssh.cfg` was included in `~/.ssh/config`)

If you want to ssh directly to a node, you can do:

```bash
$ ssh $hostname
```

I.e.,

```bash
$ ssh couchdb-worker-x86-64-debian-dal-1-01
```


