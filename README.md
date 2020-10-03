oc new-project galaxy-prod
oc new-app https://github.com/jcordes73/vue-storefrontend-openshift --strategy=docker
oc expose svc vue-storefrontend-openshift
