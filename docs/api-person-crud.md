# Contrato da API de Pessoas

## Objetivo

Definir a superficie funcional da POC antes da implementacao.

## Recurso Principal

- `Person`

## Decisoes Fechadas

- `id` gerado no caso de uso com `UUID`
- campo unico funcional: `cpf`
- update total em `PUT /v1/people/{id}`
- delete logico com `deleted` e `deleted_at`
- listagem com paginacao, filtro por `active`, busca por nome por prefixo, ordenacao por `created_at` e filtro de deletados

## Endpoints

- `POST /v1/people`
- `GET /v1/people/{id}`
- `GET /v1/people`
- `PUT /v1/people/{id}`
- `DELETE /v1/people/{id}`

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

### Campos retornados em response

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

## Estruturas Auxiliares

### `contacts`

Lista de objetos com:

- `type`
- `value`

Exemplo:

```json
[
  {
    "type": "email",
    "value": "maria.silva@example.com"
  }
]
```

### `address`

Objeto com:

- `street`
- `number`
- `district`
- `zip_code`
- `city`
- `state`
- `complement`

Exemplo:

```json
{
  "street": "Rua das Flores",
  "number": "123",
  "district": "Centro",
  "zip_code": "60000-000",
  "city": "Fortaleza",
  "state": "CE",
  "complement": "Apto 302"
}
```

### `metadata`

Objeto com:

- `external_id`

Exemplo:

```json
{
  "external_id": "crm-001"
}
```

## Regras Funcionais

- `id` e gerado pela aplicacao
- `cpf` deve ser valido
- `cpf` deve ser unico
- `cpf` nao pode ser alterado no update
- `name` e obrigatorio
- `name` deve ter no minimo 3 caracteres
- `age`, quando informada, deve ser maior ou igual a `0`
- `salary` deve ser maior ou igual a `0`
- `birth_date` e obrigatoria
- `birth_date` deve estar em formato `YYYY-MM-DD`
- `birth_date` nao pode ser futura
- `active` e obrigatorio
- `tags` e `contacts` podem ser vazios
- `metadata` pode ser opcional
- registro deletado nao pode ser atualizado
- registro com `active=false` pode ser atualizado

## Query Params de `GET /v1/people`

- `page_size`
- `cursor`
- `name_prefix`
- `active`
- `sort_order`
- `include_deleted`

## Regras da Listagem

- `page_size` maximo: `10`
- `name_prefix` usa busca por prefixo
- `sort_order` aceita `asc` e `desc`
- `include_deleted=false` por padrao
- `include_deleted=true` retorna deletados e nao deletados

Observacao tecnica importante:

- a busca por prefixo e mantida como requisito da API;
- em DynamoDB, ela sera tratada com estrategia explicita de prefix indexing;
- isso faz parte do valor de aprendizado da POC.

## Endpoints Detalhados

### `POST /v1/people`

Responsabilidade:

- criar uma pessoa.

#### Request body

```json
{
  "name": "Maria da Silva",
  "cpf": "12345678909",
  "birth_date": "1990-05-10",
  "active": true,
  "salary": 5500.75,
  "age": 34,
  "tags": [
    "vip",
    "newsletter"
  ],
  "contacts": [
    {
      "type": "email",
      "value": "maria.silva@example.com"
    }
  ],
  "address": {
    "street": "Rua das Flores",
    "number": "123",
    "district": "Centro",
    "zip_code": "60000-000",
    "city": "Fortaleza",
    "state": "CE",
    "complement": "Apto 302"
  },
  "metadata": {
    "external_id": "crm-001"
  }
}
```

#### Response `201`

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Maria da Silva",
  "cpf": "12345678909",
  "birth_date": "1990-05-10",
  "active": true,
  "salary": 5500.75,
  "age": 34,
  "tags": [
    "vip",
    "newsletter"
  ],
  "contacts": [
    {
      "type": "email",
      "value": "maria.silva@example.com"
    }
  ],
  "address": {
    "street": "Rua das Flores",
    "number": "123",
    "district": "Centro",
    "zip_code": "60000-000",
    "city": "Fortaleza",
    "state": "CE",
    "complement": "Apto 302"
  },
  "metadata": {
    "external_id": "crm-001"
  },
  "created_at": "2026-07-01T10:00:00Z",
  "updated_at": "2026-07-01T10:00:00Z",
  "deleted": false,
  "deleted_at": null
}
```

### `GET /v1/people/{id}`

Responsabilidade:

- consultar uma pessoa por identificador.

#### Response `200`

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Maria da Silva",
  "cpf": "12345678909",
  "birth_date": "1990-05-10",
  "active": true,
  "salary": 5500.75,
  "age": 34,
  "tags": [
    "vip",
    "newsletter"
  ],
  "contacts": [
    {
      "type": "email",
      "value": "maria.silva@example.com"
    }
  ],
  "address": {
    "street": "Rua das Flores",
    "number": "123",
    "district": "Centro",
    "zip_code": "60000-000",
    "city": "Fortaleza",
    "state": "CE",
    "complement": "Apto 302"
  },
  "metadata": {
    "external_id": "crm-001"
  },
  "created_at": "2026-07-01T10:00:00Z",
  "updated_at": "2026-07-01T10:00:00Z",
  "deleted": false,
  "deleted_at": null
}
```

Observacao:

- este endpoint pode retornar item deletado.

### `GET /v1/people`

Responsabilidade:

- listar pessoas;
- suportar paginacao;
- filtrar por `active`;
- buscar por prefixo de nome;
- ordenar por `created_at`;
- opcionalmente incluir deletados.

#### Query params de exemplo

```text
GET /v1/people?page_size=10&name_prefix=Ma&active=true&sort_order=desc&include_deleted=false
```

#### Response `200`

```json
{
  "items": [
    {
      "id": "550e8400-e29b-41d4-a716-446655440000",
      "name": "Maria da Silva",
      "cpf": "12345678909",
      "birth_date": "1990-05-10",
      "active": true,
      "salary": 5500.75,
      "age": 34,
      "tags": [
        "vip",
        "newsletter"
      ],
      "contacts": [
        {
          "type": "email",
          "value": "maria.silva@example.com"
        }
      ],
      "address": {
        "street": "Rua das Flores",
        "number": "123",
        "district": "Centro",
        "zip_code": "60000-000",
        "city": "Fortaleza",
        "state": "CE",
        "complement": "Apto 302"
      },
      "metadata": {
        "external_id": "crm-001"
      },
      "created_at": "2026-07-01T10:00:00Z",
      "updated_at": "2026-07-01T10:00:00Z",
      "deleted": false,
      "deleted_at": null
    }
  ],
  "page_size": 10,
  "next_cursor": "eyJwayI6IlBFUlNPTiM1NTBlODQwMC1lMjliLTQxZDQtYTcxNi00NDY2NTU0NDAwMDAifQ=="
}
```

### `PUT /v1/people/{id}`

Responsabilidade:

- atualizar integralmente uma pessoa.

#### Request body

```json
{
  "name": "Maria da Silva Souza",
  "cpf": "12345678909",
  "birth_date": "1990-05-10",
  "active": true,
  "salary": 6200.00,
  "age": 35,
  "tags": [
    "vip",
    "premium"
  ],
  "contacts": [
    {
      "type": "email",
      "value": "maria.souza@example.com"
    }
  ],
  "address": {
    "street": "Rua das Flores",
    "number": "456",
    "district": "Aldeota",
    "zip_code": "60100-000",
    "city": "Fortaleza",
    "state": "CE",
    "complement": "Casa"
  },
  "metadata": {
    "external_id": "crm-001"
  }
}
```

#### Response `200`

```json
{
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Maria da Silva Souza",
  "cpf": "12345678909",
  "birth_date": "1990-05-10",
  "active": true,
  "salary": 6200.00,
  "age": 35,
  "tags": [
    "vip",
    "premium"
  ],
  "contacts": [
    {
      "type": "email",
      "value": "maria.souza@example.com"
    }
  ],
  "address": {
    "street": "Rua das Flores",
    "number": "456",
    "district": "Aldeota",
    "zip_code": "60100-000",
    "city": "Fortaleza",
    "state": "CE",
    "complement": "Casa"
  },
  "metadata": {
    "external_id": "crm-001"
  },
  "created_at": "2026-07-01T10:00:00Z",
  "updated_at": "2026-07-01T11:00:00Z",
  "deleted": false,
  "deleted_at": null
}
```

Observacoes:

- atualizacao total;
- nao aceita alteracao de `id`, `created_at`, `updated_at`, `deleted` e `deleted_at`;
- `cpf` deve permanecer o mesmo valor da pessoa.

### `DELETE /v1/people/{id}`

Responsabilidade:

- remover logicamente uma pessoa.

#### Response `204`

- sem corpo de resposta.

## Respostas de Erro

### `400 Bad Request`

```json
{
  "error_code": "VALIDATION_ERROR",
  "message": "cpf invalido",
  "correlation_id": "c8f2f0a5-7b09-4e0b-a92a-2d773b3dc001"
}
```

### `404 Not Found`

```json
{
  "error_code": "PERSON_NOT_FOUND",
  "message": "pessoa nao encontrada",
  "correlation_id": "c8f2f0a5-7b09-4e0b-a92a-2d773b3dc001"
}
```

### `409 Conflict`

```json
{
  "error_code": "CPF_ALREADY_EXISTS",
  "message": "cpf ja cadastrado",
  "correlation_id": "c8f2f0a5-7b09-4e0b-a92a-2d773b3dc001"
}
```

### `500 Internal Server Error`

```json
{
  "error_code": "INTERNAL_ERROR",
  "message": "erro interno ao processar a requisicao",
  "correlation_id": "c8f2f0a5-7b09-4e0b-a92a-2d773b3dc001"
}
```

## Logs Obrigatorios por Endpoint

Cada endpoint deve gerar ao menos:

- log de inicio da operacao;
- log de validacao com resultado;
- log de persistencia com resultado;
- log final de sucesso ou falha;
- correlacao por `correlation_id`.
