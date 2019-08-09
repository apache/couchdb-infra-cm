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
