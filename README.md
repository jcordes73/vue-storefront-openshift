# Vue Storefront on OpenShift

## About

This project contains a version of the [Vue Storefront](https://github.com/DivanteLtd/vue-storefront) deployable on [Red Hat OpenShift Container Platform](https://www.openshift.com/products/container-platform).

## Installation

The installation of the Vue Storefront consists of the following parts

- Installation of Vue Storefront API for OpenShift
- Cloning of this repository
- Installing Vue Storefront
- Adding labels/annotations for Topology View
- Installing Magento

The installation of Red Hat OpenShift Container Platform is not part of this project. For a local deployment on your desktop/laptop consider using [Red Hat CodeReady Containers](https://developers.redhat.com/products/codeready-containers/overview).

### Installing Vue Storefront API

Follow the instruction as in [Vue Storefront API](https://github.com/jcordes73/vue-storefront-api-openshift).

### Cloning of the Vue Storefront for OpenShift repository

	git clone https://github.com/jcordes73/vue-storefront-openshift
	cd vue-storefront-openshift

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

	oc label bc/vue-storefront app.openshift.io/runtime=nodejs
	oc label deployment/vue-storefront app.openshift.io/runtime=nodejs
	oc annotate bc/vue-storefront app.openshift.io/connects-to=vue-storefront-api
	oc annotate deployment/vue-storefront app.openshift.io/connects-to=vue-storefront-api
	oc annotate bc/vue-storefront app.openshift.io/vcs-uri="https://github.com/jcordes73/vue-storefront-openshift"
	oc annotate deployment/vue-storefront app.openshift.io/vcs-uri="https://github.com/jcordes73/vue-storefront-openshift"

### Installing Magento

Installing Magento requires multiple steps:

- Installing MariaDB
- Installing the Magento 2 container

To deploy MariaDB 10.3 on execute the following

	oc new-app registry.redhat.io/rhel8/mariadb-103 --name mariadb -e MYSQL_DATABASE="bn_magento" -e MYSQL_USER="bn_magento" -e MYSQL_PASSWORD="pass"
	oc label deployment/mariadb app.openshift.io/runtime=mariadb

As the Magento 2 container (bitnami/magento) uses elevated priviliges, you need to grant an anyuid policy as a cluster-admin to service-accounts in the project like this

	oc adm policy add-scc-to-user anyuid -z deployer
	oc adm policy add-scc-to-user anyuid -z default

Now you can deploy the Magento 2 container

        oc new-app php:7.3~https://github.com/jcordes73/magento2#2.3 --name magento
	oc annotate deployment magento app.openshift.io/connects-to=vue-storefront-api,mariadb
