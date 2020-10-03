**Installation**

For installation of vue-storefront on OpenShift Container Platform login with a user and execute the following commands

	oc new-project galaxy-prod
	oc new-app https://github.com/jcordes73/vue-storefront-openshift --name vue-storefront
	oc expose svc vue-storefront
