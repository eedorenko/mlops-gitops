# GH_TOKEN=
# GH_URL=https://api.github.com/repos/eedorenko/mlops-gitops/actions/workflows/ci.yml/dispatches

# curl -L \
#   -X POST \
#   -H "Accept: application/vnd.github+json" \
#   -H "Authorization: Bearer $GH_TOKEN" \
#   -H "X-GitHub-Api-Version: 2022-11-28" \
# $GH_URL \
# -d '{"ref":"main","inputs":{"model_name":"Model","model_version":"2"}}'  



az ml model list  -n test-model  -w kraft-ml -g hello-world-rg -r 1 | jq '.[0].version'

az ad sp create-for-rbac --name kraft-ml --role contributor --scopes /subscriptions/7be1b9e7-57ca-47ff-b5ab-82e7ccb8c611 --sdk-auth 

