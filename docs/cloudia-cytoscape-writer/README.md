# Cloudia CytoScape Writer Plugin

The Cloudia CytoScape Writer Plugin converts collected cloud information to a network
diagrams created by [Cytoscape.js](https://github.com/cytoscape/cytoscape.js)

This page describes how to visualize network environments using the `cytoscape_generate`
and `webserver` commands, and assumes you have already configured your account
and collected the metadata about it.

The network visualization will only show VPC resources, ie. those things with a
Security Group attached to it.  It can show EC2, RDS, ELB (original and v2),
Redshift, ElasticSearch, ECS, Lambda, and VPC Endpoints (ie. the Gateway
Endpoints for S3 and DynamoDB, and PrivateLink).  This will NOT show your S3
buckets. It will ONLY show the Gateway Endpoint to the S3 service if you
created one (your AWS account does not have one by default).  Again, only
Lambdas and others resources that are inside a VPC will be shown.  The edges
shown are only based on the ingress rules of the Security Groups, and not the
resource policy, or Network ACLs, or Route Tables.

## cytoscape_generate the data

This step converts the collected AWS data into a format that can be displayed
in the browser by generating a `web/data.json` file.

```
python cloudia-aws-reader.py cytoscape_generate --account my_account
```

There are a number of filtering options that can be applied here to reduce the
number of nodes and edges.  This will help the diagram look better, by removing
some of its complexity, and is also needed for large environments that will not
render.

The most useful filtering options:
* `--regions`: Restrict the diagram to a set regions, ex. `us-east-1,us-east-2`
* `--vpc-ids` and `--vpc-names`: Restrict the diagram to a set of VPCs.
* `--tags`: Filter by tags, for example `--tags Env=Prod --tags
  Env=Test,Name=Bastion` will filter to all resources tagged with a key `Env`
  that has value `Prod`, or where `Env=Test` and `Name=Bastion`. In this way, a
  the tags in a set are AND'd, and the tag sets are OR'd.
* `--collapse-by-tag`: This is very useful to provide a tag name, and all nodes
  with that tag will be reduced to a single displayed node.

The other filtering options are:
* `--internal-edges` (default) and `--no-internal-edges`: When you only care
  about showing what is publicly accessible, use `--no-internal-edges`.
* `--inter-rds-edges` and `--no-inter-rds-edges` (default): By default, any
  communication paths between RDS nodes are not shown, as this is unlikely to be
  of interest. To display them, use `--inter-rds-edges`.
* `--read-replicas` (default) and `--no-read-replicas`: By default, RDS read
  replica nodes are shown. You can ignore them by using `--no-read-replicas`.
* `--azs` (default) and `--no-azs`: Availability zones are shown by default.
  To ignore them, use `--no-azs`.
* `--no-collapse-asgs`: By default, auto-scaling groups are collapsed to a
  single node.  This flag causes all instances to be shown instead.


## Run a webserver

You can host the `web` directory with your webserver of choice, or just run:

```
python cloudia.py webserver
```

Using the UI
============

Mouse actions
-------------
- Pan and zoom can be done with the UI controls, or arrow keys and -/+ keys.
- Clicking on a node selects it (background turns yellow).  Double-clicking a
  node makes its deleted neighbors visible again.
- Unselect a node by clicking on a new one, or holding shift and clicking on
  the selected node again.
- Holding down shift can be used to select multiple nodes. Holding shift,
  clicking, and dragging over an area, selects all nodes that overlap that area.
- Click on a node and drag it to move it around.

![](images/command_icons.png)

Commands
--------
- Delete (d): Select a node and click the eye with a slash through it to delete (ie. hide) it. Click the eye to undelete (unhide) all deleted nodes.   All nodes connected to a deleted node will get a black border. If you double-click on a node with a black border, its deleted neighbors will be undeleted.

![](images/deleted_node.png)

- Highlight (h): Select a node and click the symbol of the connected nodes to highlight the neighbors of a node. Click the inverse symbol to unhighlight the neighbors.  Highlight neighbors makes it easier to see which nodes are connected.

![](images/highlight_neighbors.png)

- Collapse all: Click the icon of the arrows pointed toward each other to collapse all nodes.  Click the symbol of the arrows pointed away to uncollapse all collapsed node.

![](images/collapsed_node.png)

- Collapse (c/e): The "minus" symbol will collapse a node, and the "plus"
  symbol will expand it.
- Randomize layout (r): The hammer symbol will randomly layout the diagram in a
  new way.
- Save image: The camera symbol will save a high resolution image of the
  diagram. This is helpful when your diagram has many nodes such that you must be
  zoomed out, so a screenshot would not get the same level of detail.
- Import/Export: This will save the layout as a json file that you can then
  upload. This is helpful if you've moved nodes or made other changes and wish to
  "save" your work. Re-opening saved files does have some bugs.

When you first start, the initial layout is never ideal.  We use what is
believed to be the best layout algorithm for compound node diagrams,
[CoSE](https://github.com/cytoscape/cytoscape.js-cose-bilkent), but this will
still require manual editing by moving nodes around.

Here is the layout you'll likely see initially when you view the demo:
![Initial layout](images/initial_layout.png "Initial layout")

Licenses
--------
- cytoscape.js: MIT
  https://github.com/cytoscape/cytoscape.js/blob/master/LICENSE
- cytoscape.js-qtip: MIT
  https://github.com/cytoscape/cytoscape.js-qtip/blob/master/LICENSE
- cytoscape.js-grid-guide: MIT
  https://github.com/iVis-at-Bilkent/cytoscape.js-grid-guide
- cytoscape.js-panzoom: MIT
  https://github.com/cytoscape/cytoscape.js-panzoom/blob/master/LICENSE
- jquery: JS Foundation
  https://github.com/jquery/jquery/blob/master/LICENSE.txt
- jquery.qtip: MIT
  https://github.com/qTip2/qTip2/blob/master/LICENSE
- cytoscape-navigator: MIT
  https://github.com/cytoscape/cytoscape.js-navigator/blob/c249bd1551c8948613573b470b30a471def401c5/bower.json#L24
- cytoscape.js-autopan-on-drag: MIT
  https://github.com/iVis-at-Bilkent/cytoscape.js-autopan-on-drag
- font-awesome: MIT
  http://fontawesome.io/
- FileSave.js: MIT
  https://github.com/eligrey/FileSaver.js/blob/master/LICENSE.md
- circular-json: MIT
  https://github.com/WebReflection/circular-json/blob/master/LICENSE.txt
- rstacruz/nprogress: MIT
  https://github.com/rstacruz/nprogress/blob/master/License.md
- mousetrap: Apache
  https://github.com/ccampbell/mousetrap/blob/master/LICENSE
- akkordion MIT
  https://github.com/TrySound/akkordion/blob/master/LICENSE
