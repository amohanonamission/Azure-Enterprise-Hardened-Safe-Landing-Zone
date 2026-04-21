# One-click deployment script
#!/bin/sh

az login
az deployment sub create --location centralindia --template-file main.bicep --parameters parameters.json
