## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

# Generate a key
openssl req -newkey rsa:2048 -nodes -keyout key.pem -x509 -days 365 -out cert.pem
 
# Import key in your vault
az keyvault key import   --vault-name "kv-c2-b5269844"   --name cmk-storage-imported   --pem-file "/home/labuser-03/key.pem"
 
KEY_ID=$(az keyvault key show --vault-name $KEYVAULT_NAME --name cmk-storage-imported --query "key. Kid" -o tsv)

## ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
