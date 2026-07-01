# Guia de Infraestrutura AWS

## Objetivo

Orientar a implementacao da infraestrutura minima da POC usando Terraform.

## Componentes Recomendados

- API Gateway para exposicao HTTP
- AWS Lambda para execucao da API
- DynamoDB para persistencia
- CloudWatch Logs para logs
- CloudWatch Metrics para metricas nativas
- IAM para controle de acesso
- AWS Systems Manager Parameter Store ou Secrets Manager para segredos

## Desenho Minimo

```text
Internet
   |
API Gateway
   |
Lambda
   |
   +--> DynamoDB
   +--> CloudWatch
   `--> Datadog
```

## Estrutura Terraform Recomendada

```text
infra/terraform/
|-- modules/
|   |-- api-gateway/
|   |-- lambda/
|   |-- dynamodb/
|   |-- iam/
|   `-- observability/
`-- envs/
    `-- dev/
```

## Modulos Esperados

### `api-gateway`

Responsavel por:

- API HTTP ou REST, conforme decisao final;
- rotas;
- integracoes com Lambda;
- estagios;
- logging de acesso, se habilitado.

### `lambda`

Responsavel por:

- funcao;
- runtime e arquitetura;
- variaveis de ambiente;
- permissoes basicas;
- integracao com camadas, se necessario.

### `dynamodb`

Responsavel por:

- tabela principal;
- billing mode;
- chaves;
- indices;
- TTL quando aplicavel.

### `iam`

Responsavel por:

- roles e policies minimas para Lambda;
- permissoes explicitas para DynamoDB, logs e parametros.

### `observability`

Responsavel por:

- log groups;
- retencao;
- integracoes complementares;
- parametros de observabilidade.

## Decisoes a Fechar Antes do Terraform

- API Gateway HTTP API ou REST API
- estrategia de nomes dos recursos
- convencao de tags
- ambiente unico da POC ou multiplos ambientes
- gerenciamento de estado remoto

## Convencoes Recomendadas

- nomear recursos com prefixo consistente;
- usar tags para `project`, `environment`, `owner` e `cost-center`;
- isolar variaveis por ambiente;
- evitar acoplamento entre modulos por outputs excessivos;
- manter modulos pequenos e explicitos.

## Riscos Frequentes

- permissoes IAM amplas demais;
- tabela DynamoDB modelada por entidade em vez de padrao de acesso;
- mistura de configuracoes de ambiente com modulo reutilizavel;
- observabilidade deixada para o final.
