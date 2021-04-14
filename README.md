# Timestream CfHighlander component

## Parameters

| Name | Use | Default | Global | Type | Allowed Values |
| ---- | --- | ------- | ------ | ---- | -------------- |
| EnvironmentName | Tagging | dev | true | String
| EnvironmentType | Tagging | development | true | String | ['development','production']

## Configuration

### Table Management

You are able to manage the creation of tables within your Timestream database via the config file using the following syntax:

```yaml
tables:
  -
    name: MyTable
    memory_store_retention: 5
    magnetic_store_retention: 7
```

At a minimum for each table, the `name` key must be provided. If you wish to set retention properties you can using `memory_store_retention` and `magnetic_store_retention` but they must be set together (this is an AWS requirement)
### Encryption Configuration

Encryption is turned on by default on your Timestream database, and cannot be turned off. AES-256 encryption is the encryption algorithm used.

By default if you don't provide a key, Timestream creates and uses a `alias/aws/timestream` key in your account. If you wish to provide your own KMS key for encryption you can specify the ARN by setting the config below:

```yaml
kms_key_id: arn:aws:kms:ap-southeast-2:111111111111:key/12345678-1234-1234-1234-111111111111
```