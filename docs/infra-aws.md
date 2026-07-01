# Guia de Infraestrutura AWS

## Objetivo

Orientar a implementacao da infraestrutura minima da POC usando Terraform.

## Componentes Recomendados

- API Gateway HTTP API para exposicao HTTP
- AWS Lambda para execucao da API
- DynamoDB para persistencia
- CloudWatch Logs para logs
- CloudWatch Metrics para metricas nativas
- IAM para controle de acesso
- AWS Systems Manager Parameter Store para configuracoes sensiveis

## Desenho Minimo

```text
Internet
   |
API Gateway
   |
   +--> Lambda CreatePerson
   +--> Lambda GetPerson
   +--> Lambda ListPeople
   +--> Lambda UpdatePerson
   `--> Lambda DeletePerson
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

- HTTP API;
- rotas;
- integracoes com Lambda;
- estagio `dev`;
- logging de acesso, se habilitado.

### `lambda`

Responsavel por:

- funcao;
- runtime e arquitetura;
- variaveis de ambiente;
- permissoes basicas;
- integracao com camadas, se necessario.

Lambdas previstas:

- `create-person`
- `get-person`
- `list-people`
- `update-person`
- `delete-person`

### `dynamodb`

Responsavel por:

- tabela principal;
- billing mode;
- chaves;
- indices;
- TTL quando aplicavel.

Decisoes base:

- item principal com `pk = PERSON#{id}` e `sk = PROFILE`
- item auxiliar para unicidade de CPF

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

- API Gateway HTTP API
- estrategia de nomes com prefixo `poc-person-dev`
- convencao de tags
- ambiente unico `dev`
- gerenciamento de state local para a fase inicial
- regiao `us-east-1`

## Convencoes Recomendadas

- nomear recursos com prefixo consistente;
- usar tags para `project`, `service`, `environment`, `owner` e `managed-by`;
- isolar variaveis por ambiente;
- evitar acoplamento entre modulos por outputs excessivos;
- manter modulos pequenos e explicitos.

## Decisoes Consolidadas

- nome do servico: `person-service`
- prefixo dos recursos: `poc-person-dev`
- regiao AWS: `us-east-1`
- Terraform state: `local`
- API aberta para a primeira versao

## Riscos Frequentes

- permissoes IAM amplas demais;
- tabela DynamoDB modelada por entidade em vez de padrao de acesso;
- mistura de configuracoes de ambiente com modulo reutilizavel;
- observabilidade deixada para o final.
