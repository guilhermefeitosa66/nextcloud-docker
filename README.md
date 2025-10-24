# Nextcloud Docker Local

Configuração do Nextcloud usando Docker Compose com MariaDB e Redis.

## Requisitos

- Docker
- Docker Compose

## Instalação e Uso

### 1. Configurar variáveis de ambiente

Copie o arquivo `.env.example` para `.env` e edite com suas configurações:

```bash
cp .env.example .env
nano .env
```

**IMPORTANTE:** Altere todas as senhas e o caminho `NEXTCLOUD_DATA_PATH` antes de iniciar!

### 2. Iniciar os containers

```bash
make up
```

### 3. Acessar o Nextcloud

Abra o navegador e acesse:

```
http://localhost:8080
```

Faça login com as credenciais definidas no arquivo `.env`.

## Comandos Úteis

Para ver todos os comandos disponíveis:
```bash
make help
```

### Gerenciamento de containers
```bash
make up          # Iniciar containers
make down        # Parar containers
make restart     # Reiniciar containers
make ps          # Ver status dos containers
```

### Logs
```bash
make logs        # Ver logs de todos os serviços
make logs-app    # Logs apenas do Nextcloud
make logs-db     # Logs apenas do MariaDB
make logs-redis  # Logs apenas do Redis
```

### Manutenção
```bash
make update            # Atualizar imagens e reiniciar
make backup            # Fazer backup dos dados
make clean             # Remover tudo (DESTRUTIVO)
make shell-app         # Abrir shell no container
make fix-permissions   # Corrigir permissões
```

## Estrutura

- **app**: Container do Nextcloud (porta 8080)
- **db**: Container do MariaDB (banco de dados)
- **redis**: Container do Redis (cache)

## Volumes

- **NEXTCLOUD_DATA_PATH**: Dados do Nextcloud (arquivos, apps, configurações) - definido no `.env`
- **db_data**: Dados do banco de dados MariaDB (volume Docker)

## Problemas Comuns

### Porta 8080 já está em uso

Edite o arquivo `docker-compose.yml` e altere a porta:

```yaml
ports:
  - "8081:80"  # ou outra porta disponível
```

### Erro de permissões

```bash
make fix-permissions
```
