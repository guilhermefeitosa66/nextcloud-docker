# Nextcloud Docker Local

Configuração do Nextcloud usando Docker Compose com MariaDB e Redis.

## Requisitos

- Docker
- Docker Compose

## Instalação e Uso

### 1. Configurar variáveis de ambiente

Edite o arquivo `.env` e altere as senhas padrão:

```bash
nano .env
```

**IMPORTANTE:** Altere todas as senhas antes de iniciar em produção!

### 2. Iniciar os containers

```bash
docker-compose up -d
```

### 3. Acessar o Nextcloud

Abra o navegador e acesse:

```
http://localhost:8080
```

Faça login com as credenciais definidas no arquivo `.env`:
- Usuário: `admin` (ou o valor de NEXTCLOUD_ADMIN_USER)
- Senha: `adminNextcloud123` (ou o valor de NEXTCLOUD_ADMIN_PASSWORD)

## Comandos Úteis

### Ver logs
```bash
docker-compose logs -f
```

### Parar os containers
```bash
docker-compose down
```

### Parar e remover volumes (CUIDADO: remove todos os dados)
```bash
docker-compose down -v
```

### Reiniciar os containers
```bash
docker-compose restart
```

### Atualizar o Nextcloud
```bash
docker-compose pull
docker-compose up -d
```

## Estrutura

- **app**: Container do Nextcloud (porta 8080)
- **db**: Container do MariaDB (banco de dados)
- **redis**: Container do Redis (cache)

## Volumes

- `nextcloud_data`: Dados do Nextcloud (arquivos, apps, configurações)
- `db_data`: Dados do banco de dados MariaDB

## Backup

Para fazer backup dos dados:

```bash
docker run --rm -v nextcloud_nextcloud_data:/data -v $(pwd):/backup ubuntu tar czf /backup/nextcloud-backup.tar.gz /data
docker run --rm -v nextcloud_db_data:/data -v $(pwd):/backup ubuntu tar czf /backup/db-backup.tar.gz /data
```

## Problemas Comuns

### Porta 8080 já está em uso

Edite o arquivo `docker-compose.yml` e altere a porta:

```yaml
ports:
  - "8081:80"  # ou outra porta disponível
```

### Erro de permissões

```bash
docker-compose exec app chown -R www-data:www-data /var/www/html
```
