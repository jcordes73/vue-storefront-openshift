#Vue Storefront on OpenShift

##About

This project contains a version of the [Vue Storefront](https://github.com/DivanteLtd/vue-storefront) deployable on [Red Hat OpenShift Container Platform](https://www.openshift.com/products/container-platform).

##Installation

The installation of the Vue Storefront consists of the following parts

- Installation of Vue Storefront API for OpenShift
- Cloning of this repository
- Installing Vue Storefront

The installation of Red Hat OpenShift Container Platform is not part of this project. For a local deployment on your desktop/laptop consider using [Red Hat CodeReady Containers](https://developers.redhat.com/products/codeready-containers/overview).

###Installing Vue Storefront API

Follow the instruction as in [Vue Storefront API](://github.com/jcordes73/vue-storefront-openshift-api).

###Cloning of the Vue Storefront for OpenShift repository

	git clone https://github.com/jcordes73/vue-storefront-openshift
        cd vue-storefront-openshift

###Installing Vue Storefront API

	oc new-app https://github.com/jcordes73/vue-storefront-openshift --name vue-storefront --env-file=default.env
	oc expose svc vue-storefront
