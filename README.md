# Vue Storefront on OpenShift

## About

This project contains a version of the [Vue Storefront](https://github.com/DivanteLtd/vue-storefront) deployable on [Red Hat OpenShift Container Platform](https://www.openshift.com/products/container-platform).

## Pre-requistes

### Git client

To checkout the projects from Github, install a git client on RHEL 8 like this:

	yum install -y git

### OpenShift Client (oc)

You can download the OpenShift Client 4.5 [here](https://mirror.openshift.com/pub/openshift-v4/clients/oc/4.5/linux/oc.tar.gz)

### jq

For modification of JSON config files we use jq, install it like this on RHEL 8:

	yum install -y jq

## Installation

The installation of the Vue Storefront consists of the following parts

- Installation of Vue Storefront API for OpenShift
- Cloning of this repository
- Installing Vue Storefront
- Adding labels/annotations for Topology View

The installation of Red Hat OpenShift Container Platform is not part of this project. For a local deployment on your desktop/laptop consider using [Red Hat CodeReady Containers](https://developers.redhat.com/products/codeready-containers/overview).

### Installing Vue Storefront API

Follow the instruction as in [Vue Storefront API](https://github.com/jcordes73/vue-storefront-api-openshift).

### Cloning of the Vue Storefront for OpenShift repository

	git clone https://github.com/jcordes73/vue-storefront-openshift
	cd vue-storefront-openshift

In config/openshift.json you need to change the URL of the Vue Storefront API URL as well as the URL for the images:

	VS_API_URL=http://`oc get route vue-storefront-api -o json | jq .spec.host -r`
	jq ".api.url=\"$VS_API_URL\"" config/openshift.json > config/openshift.json.tmp
	mv config/openshift.json.tmp config/openshift.json
	jq ".images.baseUrl=\"$VS_API_URL/img/\"" config/openshift.json > config/openshift.json.tmp
	mv config/openshift.json.tmp config/openshift.json

### Installing Vue Storefront

	oc new-app https://github.com/jcordes73/vue-storefront-openshift --name vue-storefront --env-file=openshift.env
	oc expose svc vue-storefront

After the container has started adjust the configuration following these steps

	oc create configmap vue-storefront --from-file=config
	oc set volumes deployments vue-storefront --add --name=vue-storefront-config-volume --mount-path=/opt/app-root/src/config -t configmap --configmap-name=vue-storefront

To undo the configuration changes execute the following

	oc set volumes deployments vue-storefront --remove --name=vue-storefront-config-volume
	oc delete cm vue-storefront

### Adding labels/annotations for Topology View

	oc label deployment/vue-storefront app.openshift.io/runtime=nodejs
        oc label deployment/vue-storefront app.kubernetes.io/part-of=vue-storefront
	oc annotate deployment/vue-storefront app.openshift.io/connects-to=vue-storefront-api
	oc annotate bc/vue-storefront app.openshift.io/vcs-uri="https://github.com/jcordes73/vue-storefront-openshift"
	oc annotate deployment/vue-storefront app.openshift.io/vcs-uri="https://github.com/jcordes73/vue-storefront-openshift"
