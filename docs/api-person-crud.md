# Contrato da API de Pessoas

## Objetivo

Definir a superficie funcional da POC antes da implementacao.

## Recurso Principal

- `Person`

## Endpoints Minimos

### `POST /v1/people`

Responsabilidade:

- criar uma pessoa.

### `GET /v1/people/{id}`

Responsabilidade:

- consultar uma pessoa por identificador.

### `GET /v1/people`

Responsabilidade:

- listar pessoas;
- suportar paginacao simples quando necessario.

### `PUT /v1/people/{id}`

Responsabilidade:

- atualizar integralmente uma pessoa.

### `DELETE /v1/people/{id}`

Responsabilidade:

- remover uma pessoa.

## Payload Conceitual da Pessoa

Campos sugeridos para validar tipos de dados diversos:

- `id`: string
- `name`: string
- `document`: string
- `age`: integer
- `active`: boolean
- `birth_date`: string
- `salary`: decimal
- `tags`: array de strings
- `contacts`: array de objetos
- `address`: objeto
- `metadata`: mapa flexivel
- `created_at`: string
- `updated_at`: string

## Regras Funcionais Minimas

- `id` deve ser unico
- `name` e obrigatorio
- `document` deve ser unico se for adotado como identificador funcional
- `age` nao pode ser negativa
- `salary` nao pode ser negativa
- `tags` e `contacts` podem ser vazios
- `metadata` pode ser opcional

## Respostas Esperadas

- `201` para criacao bem sucedida
- `200` para consulta, listagem e atualizacao
- `204` para exclusao
- `400` para payload invalido
- `404` para pessoa nao encontrada
- `409` para conflito de unicidade
- `500` para erro interno

## Logs Obrigatorios por Endpoint

Cada endpoint deve gerar ao menos:

- log de inicio da operacao;
- log de validacao com resultado;
- log de persistencia com resultado;
- log final de sucesso ou falha;
- correlacao por `correlation_id`.
