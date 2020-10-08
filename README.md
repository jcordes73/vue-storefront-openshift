# Vue Storefront on OpenShift

## About

This project contains a version of the [Vue Storefront](https://github.com/DivanteLtd/vue-storefront) deployable on [Red Hat OpenShift Container Platform](https://www.openshift.com/products/container-platform).

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

In config/openshift.json you need to change the URL of the Vue Storefront API URL:

	VS_API_URL=http://`oc get route vue-storefront -o json | jq .spec.host -r`
	jq ".api.url=\"$VS_API_URL\"" config/openshift.json > config/openshift.json.tmp
	mv config/openshift.json.tmp config/openshift.json


### Installing Vue Storefront

	oc new-app https://github.com/jcordes73/vue-storefront-openshift --name vue-storefront --env-file=openshift.env
	oc expose svc vue-storefront

In case you want to adjust the configuration follow these steps

	oc create configmap vue-storefront --from-file=config
        oc set volumes deployments vue-storefront --add --overwrite=true --name=vue-storefront-config-volume --mount-path=/opt/app-root/src/config -t configmap --configmap-name=vue-storefront

To undo the configuration changes execute the following

        oc set volumes deploymentes vue-storefront --remove --name=vue-storefront-config-volume
	oc delete cm vue-storefront

### Adding labels/annotations for Topology View

	oc label deployment/vue-storefront app.openshift.io/runtime=nodejs
	oc annotate deployment/vue-storefront app.openshift.io/connects-to=vue-storefront-api
        oc annotate bc/vue-storefront app.openshift.io/vcs-uri="https://github.com/jcordes73/vue-storefront-openshift"
	oc annotate deployment/vue-storefront app.openshift.io/vcs-uri="https://github.com/jcordes73/vue-storefront-openshift"
