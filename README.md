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

Then simply run the script which will dump the current inventory to stdout. Redirect the output to whatever filename you so desire.

Provisioning a Node
---

First, create a new VM of the desired type using whatever means necessary to have root SSH access along with a public IP address (or at least, some method that can be configured into Ansible though you're on your own at this point).

Then run:

    ansible-playbook -i W.X.Y.Z, provision.yml

*Note:* Make sure to include the trailing comma (,) in the -i argument or you'll get an error about not being able to parse the inventory.

Once this has run and you have updated the `production` inventory file (See the section above on generating inventory files) in this directory you can then run:

    ansible-playbook -i production ci_agents.yml

And the node will be configured as a new CI agent.