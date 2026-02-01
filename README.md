# Kubectl Plugins

A collection of kubectl plugins.

## ctx

Interactively select a context to use.

**Requirements**

`bash` `kubectl` `gum`

**Installation**

```bash
curl -o ~/.local/bin/kubectl-ctx https://codeberg.org/cayne/kubectl-plugins/raw/branch/main/kubectl-ctx
chmod +x ~/.local/bin/kubectl-ctx
```

**Usage**

```bash
kubectl ctx
```

## ns

Interactively select a namespace to use.

**Requirements**

`bash` `kubectl` `gum`

**Installation**

```bash
curl -o ~/.local/bin/kubectl-ns https://codeberg.org/cayne/kubectl-plugins/raw/branch/main/kubectl-ns
chmod +x ~/.local/bin/kubectl-ns
```

**Usage**

```bash
kubectl ns
```

## use

Interactively select a context and namespace to use.

**Requirements**

`bash` `kubectl` `gum`

**Installation**

```bash
curl -o ~/.local/bin/kubectl-use https://codeberg.org/cayne/kubectl-plugins/raw/branch/main/kubectl-use
chmod +x ~/.local/bin/kubectl-use
```

**Usage**

```bash
kubectl use
```

## createsecret

Interactively create a generic secret.

**Requirements**

`bash` `kubectl` `gum`

**Installation**

```bash
curl -o ~/.local/bin/kubectl-createsecret https://codeberg.org/cayne/kubectl-plugins/raw/branch/main/kubectl-createsecret
chmod +x ~/.local/bin/kubectl-createsecret
```

**Usage**

```bash
kubectl createsecret
```

## create-cnpg-role-secret

Interactively create a CNPG (CloudNativePG) role secret with SCRAM-SHA-256 password hashing.

Creates a secret with the following format:
```yaml
apiVersion: v1
kind: Secret
metadata:
  name: <secret-name>
  namespace: <namespace>
  labels:
    cnpg.io/reload: "true"
type: Opaque
data:
  username: <base64-encoded-username>
  password: <base64-encoded-scram-sha-256-hash>
```

**Requirements**

`bash` `kubectl` `gum` [`scram-sha-256`](https://github.com/supercaracal/scram-sha-256) `base64`

**Installation**

```bash
curl -o ~/.local/bin/kubectl-create_cnpg_role_secret https://codeberg.org/cayne/kubectl-plugins/raw/branch/main/kubectl-create_cnpg_role_secret
chmod +x ~/.local/bin/kubectl-create_cnpg_role_secret
```

**Usage**

```bash
kubectl create-cnpg-role-secret
```

**Configuration**

Optionally create a config file to set a prefix for secret names:

```bash
mkdir -p ~/.config/kubectl-create_cnpg_role_secret
echo 'PREFIX=cnpg-role-' > ~/.config/kubectl-create_cnpg_role_secret/config
```

With this config, if you enter `alice` as the secret name, the resulting secret will be named `cnpg-role-alice`.
