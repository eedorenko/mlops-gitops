export REPO_URL=https://github.com/KraftHeinz-Org/factory-platform-gitops_CI-9232
export REPO_BRANCH=dev

total_query="kubernetesconfigurationresources | where type == 'microsoft.kubernetesconfiguration/fluxconfigurations' | where properties.gitRepository.url == ""'""$REPO_URL""'"" | where properties.gitRepository.repositoryRef.branch == ""'""$REPO_BRANCH""'"""


clusters=$(az graph query -q "$total_query" | jq '.data' )

# get an array of maps (cluster name, resource group) from ids e.g. 
# /subscriptions/6ca47c48-389f-4041-a52d-57d85d2b111e/resourceGroups/RG_CI-9460_POC_001/providers/Microsoft.Kubernetes/ConnectedClusters/k3sdevcluster005/providers/Microsoft.KubernetesConfiguration/FluxConfigurations/k3sdevcluster005-dev-gitops -> k3sdevcluster005
# and .properties.resourceGroup -> RG_CI-9460_POC_001
# clusters=$(echo $clusters | jq -r '.[] | .id' | awk -F'/' '{print $NF}' | awk -F'-' '{print $1}')
clusters=$(echo $clusters | jq -r '.[]')




for i in "${clusters[@]}"
do
    # echo $i
    cluster_name=$(echo $i| jq .id | awk -F'/' '{print $NF}' | awk -F'-' '{print $1}')
    cluster_type=$(echo $i| jq .id | awk -F'/' '{print $8}')
    resource_group=$(echo $i| jq .resourceGroup)
    subscriptionId=$(echo $i| jq .subscriptionId)    
    statuses=$(echo $i | jq '.properties.statuses[]')
    for status in "${statuses[@]}"
    do
        
        kind=$(echo $status | jq -r '.kind')
        echo $kind
        if [ $kind == "GitRepository" ]; then
            echo "Yes"
            name_of_flux_config=$(echo $status| jq .name)
            az k8s-configuration flux show --resource-group $resource_group --cluster-name $cluster_name --cluster-type $cluster_type --name $name_of_flux_config
        fi
    done

    # # iterate over statuses array
    # for status in $(echo $i | jq '.properties.statuses[]'); do
    # echo $status
    # #   echo $status | jq .kind
    #     # if [ $(echo $status | jq -r '.kind') == "GitRepository" ]; then
    #     #     name_of_flux_config=$(echo $status| jq .name)
    #     #     az k8s-configuration flux show --resource-group $resource_group --cluster-name $cluster_name --cluster-type $cluster_type --name $name_of_flux_config --subscription $subscriptionId
    #     # fi  
    # done

    


    # az k8s-configuration flux show --resource-group $resource_group --cluster-name $cluster_name --cluster-type $cluster_type
    
    #  --name $name_of_flux_config --subscription $subscriptionId
done
