export RESOURCE_GROUP="rg-agentic-ai-hack"
export LOCATION="swedencentral"
export ENV_NAME="containerapp-hackaton"
az containerapp env create --name $ENV_NAME --resource-group $RESOURCE_GROUP --location $LOCATION

APP_NAME="claim-manager-app"
az containerapp create --name $APP_NAME --resource-group $RESOURCE_GROUP \
--environment $ENV_NAME --image $ACR_NAME.azurecr.io/claim-manager:latest \
--cpu 0.5 --memory 1.0Gi --min-replicas 1 --max-replicas 1 \
--ingress 'external' --target-port 8000 \
--registry-server $ACR_NAME.azurecr.io \
--registry-username $ACR_USERNAME --registry-password $ACR_PASSWORD \
--env-vars COSMOS_ENDPOINT="$COSMOS_ENDPOINT" COSMOS_KEY="$COSMOS_KEY" \
AI_FOUNDRY_PROJECT_ENDPOINT="$AI_FOUNDRY_PROJECT_ENDPOINT" AZURE_OPENAI_DEPLOYMENT_NAME="$AZURE_OPENAI_DEPLOYMENT_NAME" \
AZURE_OPENAI_KEY="$AZURE_OPENAI_KEY" AZURE_OPENAI_ENDPOINT="$AZURE_OPENAI_ENDPOINT" \
CLAIM_REV_AGENT_ID="$CLAIM_REV_AGENT_ID" \
RISK_ANALYZER_AGENT_ID="$RISK_ANALYZER_AGENT_ID" \
POLICY_CHECKER_AGENT_ID="$POLICY_CHECKER_AGENT_ID" 

az containerapp identity assign \
--name $APP_NAME \
--resource-group $RESOURCE_GROUP \
--system-assigned

PRINCIPAL_ID=$(az containerapp identity show \
--name $APP_NAME \
--resource-group $RESOURCE_GROUP \
--query principalId --output tsv)

az role assignment create \
--assignee $PRINCIPAL_ID \
--role "Cognitive Services User" \
--scope "/subscriptions/$SUBSCRIPTION_ID/resourceGroups/$RESOURCE_GROUP"