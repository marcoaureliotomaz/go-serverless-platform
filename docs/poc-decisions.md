# Decisoes Consolidadas da POC

## Objetivo

Registrar em um unico lugar as decisoes finais tomadas para a POC, servindo como referencia rapida para arquitetura, contrato, persistencia, observabilidade e infraestrutura.

## Dominio e Escopo

- entidade principal unica: `Person`
- operacoes da POC: `create`, `get`, `list`, `update`, `delete`
- listagem faz parte do escopo inicial
- API aberta para simplificar a primeira versao
- ambiente inicial unico: `dev`

## Modelo da Entidade `Person`

### Campos obrigatorios no create

- `name`
- `cpf`
- `birth_date`
- `active`
- `salary`

### Campos opcionais no create

- `age`
- `tags`
- `contacts`
- `address`
- `metadata`

### Campos retornados em responses

- `id`
- `name`
- `cpf`
- `birth_date`
- `active`
- `salary`
- `age`
- `tags`
- `contacts`
- `address`
- `metadata`
- `created_at`
- `updated_at`
- `deleted`
- `deleted_at`

### Estruturas auxiliares

#### `contacts`

Lista de objetos com:

- `type`
- `value`

#### `address`

Objeto com:

- `street`
- `number`
- `district`
- `zip_code`
- `city`
- `state`
- `complement`

#### `metadata`

Objeto com pelo menos:

- `external_id`

#### `tags`

- lista livre de strings

## Regras de Negocio

- `id` e gerado no caso de uso com `UUID`
- `cpf` e unico
- `cpf` nao pode ser alterado no update
- `name` e obrigatorio
- `name` deve ter tamanho minimo de 3 caracteres
- `age`, quando informada, deve ser maior ou igual a `0`
- `salary` deve ser maior ou igual a `0`
- `birth_date` e obrigatoria
- `birth_date` deve usar formato `YYYY-MM-DD`
- `birth_date` nao pode estar no futuro
- `active` e obrigatorio

## Regras de Atualizacao e Exclusao

- `PUT /v1/people/{id}` faz atualizacao total
- cliente pode alterar apenas campos de negocio
- campos de auditoria e controle nao sao editaveis pelo cliente
- exclusao e logica
- delete logico usa `deleted` e `deleted_at`
- registro deletado nao pode ser atualizado
- registro com `active=false` pode ser atualizado

## Regras de Consulta

- `GetPerson` pode retornar registro deletado
- `ListPeople` por padrao exclui deletados
- `include_deleted=true` retorna deletados e nao deletados
- busca por nome deve ser por prefixo
- listagem deve suportar filtro por `active`
- listagem deve suportar ordenacao por `created_at`
- `page_size` maximo da listagem: `10`

## Endpoints

- `POST /v1/people`
- `GET /v1/people/{id}`
- `GET /v1/people`
- `PUT /v1/people/{id}`
- `DELETE /v1/people/{id}`

## Query Params da Listagem

- `page_size`
- `cursor`
- `name_prefix`
- `active`
- `sort_order`
- `include_deleted`

## Status HTTP

- `201` para create
- `200` para get, list e update
- `204` para delete
- `400` para payload invalido
- `404` para nao encontrado
- `409` para conflito de CPF
- `500` para erro interno

## Arquitetura e Casos de Uso

### Casos de uso principais

- `CreatePerson`
- `GetPerson`
- `ListPeople`
- `UpdatePerson`
- `DeletePerson`

### Portas de saida

- `PersonRepository`
- `Logger`
- `Metrics`
- `Tracer`
- `Clock`
- `IDGenerator`

## Persistencia DynamoDB

- tabela unica
- item principal:
  - `pk = PERSON#{id}`
  - `sk = PROFILE`
- item auxiliar para unicidade de CPF:
  - `pk = CPF#{cpf}`
  - `sk = UNIQUE`
- listagem deve priorizar modelagem correta de DynamoDB
- busca por nome deve seguir prefixo, nao `contains`
- estrategia de aprendizado para prefix search:
  - materializacao controlada de prefixes em DynamoDB
  - uso de indice auxiliar para consulta por prefixo
  - documentacao explicita do tradeoff entre custo de escrita e flexibilidade de leitura

## Observabilidade

### Logs obrigatorios

- `timestamp`
- `level`
- `message`
- `service`
- `environment`
- `correlation_id`
- `operation`
- `layer`
- `outcome`
- `duration_ms`
- `person_id`
- `error_code`

### Niveis de log

- `INFO`
- `WARN`
- `ERROR`

### Camadas obrigatorias com log

- adapter HTTP/Lambda
- use case
- repository
- bootstrap

### Regras de CPF em logs

- sempre mascarado
- nunca completo

### Metricas obrigatorias

- `person_create_total`
- `person_get_total`
- `person_list_total`
- `person_update_total`
- `person_delete_total`
- `person_conflict_cpf_total`
- `person_error_total`
- `person_logical_delete_total`
- `person_operation_duration_ms`

### Traces

- 1 trace por requisicao HTTP
- spans para adapter, use case e repository

## Infraestrutura AWS

- API Gateway: `HTTP API`
- Lambda: `1 Lambda por operacao`
- nome do servico: `person-service`
- prefixo AWS: `poc-person-dev`
- regiao AWS: `us-east-1`
- Terraform state: `local`
- configuracoes sensiveis: `Parameter Store`

### Lambdas previstas

- `create-person`
- `get-person`
- `list-people`
- `update-person`
- `delete-person`

### Tags obrigatorias

- `project`
- `service`
- `environment`
- `owner`
- `managed-by`

## Estrategia de Implementacao

### Ordem das fatias

1. `create`
2. `get`
3. `list`
4. `update`
5. `delete`

### Ordem interna de cada fatia

1. contrato
2. use case
3. portas
4. repositorio
5. lambda adapter
6. observabilidade
7. testes

### Ondas de entrega

#### Primeira onda

- `create`
- `get`

#### Segunda onda

- `list`
- `update`
- `delete`

### Shared Core minimo

- sim

## Evolucao Futura

Kubernetes entra apenas como trilha futura, em cenarios como:

- workloads de longa duracao
- controle fino de runtime
- sidecars
- multiplos componentes persistentes
- necessidades que nao se encaixem bem em Lambda
