CouchDB Infrastructure Config Management
===

This repository contains Ansible scripts for managing our VM testing infrastructure.

Setup
---

    $ virtualenv venv
    $ source venv/bin/activate
    $ pip install -r requirements.txt


Generating Inventory Listings
---

Create a `~/.couchdb-infra-cm.cfg` file that contains the following options:

    [ibmcloud]
    api_key = <REDACTED>

The `tools/gen-inventory` script can then be used to generate our `production`
inventory file:

    $ ./tools/gen-inventory > production

Setting up CI workers for Jenkins
---

Once the a new VM has been added into the `production` inventory whoever
provisioned the VM will need to execute the first Ansible run so that
the CouchDB infra group has access (where infra group is defined as
the list of GitHub users in `roles/common/tasks/main.yml`).

    $ ansible-playbook -i production ci_agents.yml

Once this playbook finishes the new VM should be configured to be usable
as a Jenkins agent.


Configuring Jenkins
---

Once Ansible has run against a new VM configuring it as an agent in
Jenkins is fairly straightforward. You can just copy an existing node's
configuration and update the SSH host IP address.