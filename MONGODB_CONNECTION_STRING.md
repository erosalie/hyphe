# MongoDB Connection String Support

This feature allows Hyphe to connect to external MongoDB databases using connection strings, making it easy to use with MongoDB Atlas, Amazon DocumentDB, and other hosted MongoDB services.

## Quick Start

### Option 1: Environment Variable

Set the `HYPHE_MONGODB_CONNECTION_STRING` environment variable:

```bash
export HYPHE_MONGODB_CONNECTION_STRING="mongodb+srv://username:password@cluster.mongodb.net/hyphe"
```

### Option 2: Docker Compose

Add to your `docker-compose.yml`:

```yaml
services:
  backend:
    environment:
      - HYPHE_MONGODB_CONNECTION_STRING=mongodb+srv://username:password@cluster.mongodb.net/hyphe
  crawler:
    environment:
      - HYPHE_MONGODB_CONNECTION_STRING=mongodb+srv://username:password@cluster.mongodb.net/hyphe
```

### Option 3: External MongoDB Docker Compose

Use the provided `docker-compose.external-mongo.yml` for deployments without a local MongoDB container:

```bash
HYPHE_MONGODB_CONNECTION_STRING="mongodb+srv://user:pass@cluster.mongodb.net/hyphe" docker-compose -f docker-compose.external-mongo.yml up
```

## Connection String Examples

### MongoDB Atlas
```
mongodb+srv://username:password@cluster.mongodb.net/hyphe
```

### Amazon DocumentDB
```
mongodb://username:password@docdb-cluster.cluster-xyz.us-east-1.docdb.amazonaws.com:27017/hyphe?ssl=true&retryWrites=false
```

### Local MongoDB with Auth
```
mongodb://username:password@localhost:27017/hyphe
```

### Replica Set
```
mongodb://user:pass@host1:27017,host2:27017,host3:27017/hyphe?replicaSet=myReplicaSet
```

## Backward Compatibility

Existing environment variables continue to work:
- `HYPHE_MONGODB_HOST`
- `HYPHE_MONGODB_PORT`
- `HYPHE_MONGODB_DBNAME`

If both connection string and individual settings are provided, the connection string takes precedence.

## Configuration Priority

1. `HYPHE_MONGODB_CONNECTION_STRING` (highest priority)
2. `HYPHE_MONGODB_HOST` + `HYPHE_MONGODB_PORT` environment variables
3. Configuration file settings (lowest priority)

## Troubleshooting

### Connection Issues
- Ensure your connection string is properly URL-encoded
- Verify network connectivity to your MongoDB service
- Check that your MongoDB user has appropriate permissions
- For Atlas, ensure your IP is whitelisted

### SSL/TLS
Many hosted MongoDB services require SSL. Include `ssl=true` in your connection string:
```
mongodb://user:pass@host:27017/hyphe?ssl=true
```

### Authentication Database
If your user is in a different authentication database:
```
mongodb://user:pass@host:27017/hyphe?authSource=admin
```