# Dev Environment

Composicao do ambiente `dev` da POC.

## Objetivo

Centralizar a configuracao do ambiente inicial da POC e compor os modulos Terraform que suportarao a infraestrutura AWS.

## Decisoes Consolidadas

- regiao: `us-east-1`
- prefixo: `poc-person-dev`
- nome do servico: `person-service`
- state local na fase inicial
- API aberta na primeira versao

## Modulos Compostos

- `iam`
- `dynamodb`
- `lambda`
- `api-gateway`
- `observability`

## DynamoDB Nesta Fase

Nesta etapa, o ambiente `dev` ja declara explicitamente a configuracao base da tabela DynamoDB da POC:

- `billing_mode = PAY_PER_REQUEST`
- chave principal:
  - `hash_key = pk`
  - `range_key = sk`
- `point_in_time_recovery = true`
- `ttl = false`
- `deletion_protection = false`

## GSIs Planejados

- `gsi1_list_by_created_at`
- `gsi2_name_prefix`
- `gsi3_active_by_created_at`

## Valor desta Fase

Esta fase nao fecha toda a infraestrutura da POC, mas fecha a fundacao do ambiente `dev` com foco em:

- composicao de modulos;
- naming consistente;
- tags padrao;
- estrutura inicial do DynamoDB;
- visibilidade das decisoes tecnicas do ambiente.
