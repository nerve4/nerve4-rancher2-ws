# Rancher 2.7 - Setup Authentication Provider - Keycloak (OIDC).

TEST / LAB environment only. DO NOT USE IT IN PRODUCTION! :)

## Summary

configure-keycloak-oidc)

[configure-keycloak-oidc](https://ranchermanager.docs.rancher.com/how-to-guides/new-user-guides/authentication-permissions-and-global-configuration/authentication-config/configure-keycloak-oidc)
[understand OpenId](https://keycloak.discourse.group/t/keycloack-and-rancher-oidc-configuration/16950/5)
[keycloak](https://www.keycloak.org/)


## Prerequisites

- On Rancher, Keycloak (SAML) is disabled.
- You must have a Keycloak IdP Server configured.
- In Keycloak, create a new OIDC client, with the settings below


## Install keycloak v20.0.3 on docker

```
docker run -p 8080:8080 \
  -e KEYCLOAK_ADMIN=admin \
  -e KEYCLOAK_ADMIN_PASSWORD=password123 \
  quay.io/keycloak/keycloak:20.0.3 \
  start-dev
```

## Create a new OIDC client

| Setting        | Value           |
| ------------- |:-------------:|
| Client type      | openid connect |
| Client ID     | <CLIENT_ID> (e.g. rancher) |
| Name          | <CLIENT_NAME> (e.g. rancher) |
| Client authentication          | ON |
| Authentication flow          | Standard flow |
|           | Direct access grants |
| Valid Redirect URI      | https://yourRancherHostURL/verify-auth |


## Create a new "Groups Mapper" with the settings below.

| Setting        | Value           |
| ------------- |:-------------:|
| Name     | Groups Mapper |
| Mapper Type     | Group Membership |
| Token Claim Name     | groups |
| Add to ID token     | OFF |
| Add to access token     | OFF |
| Add to user info     | ON |


## Create a new "Client Audience" with the settings below

| Setting        | Value           |
| ------------- |:-------------:|
| Name     | Client Audience |
| Mapper Type     | Audience |
| Included Client Audience     | <CLIENT_NAME> |
| Add to access token     | ON |


## Create a new "Groups Path" with the settings below.

| Setting        | Value           |
| ------------- |:-------------:|
| Name     | Group Path |
| Mapper Type     | Group Membership |
| Token Claim Name     | full_group_path |
| Full group path    | ON |
| Add to user info    | ON |
