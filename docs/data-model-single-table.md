# Modelo da Tabela Unica

## Objetivo

Definir a direcao da modelagem DynamoDB para a POC de CRUD de pessoas.

## Estrategia

Usar uma unica tabela para persistir os registros da entidade `Person`.

Mesmo com apenas uma entidade principal na POC, a tabela deve ser desenhada de forma que permita futura extensao.

## Item Conceitual

Estrutura sugerida:

- `pk`: `PERSON#{id}`
- `sk`: `PROFILE`
- `entity_type`: `PERSON`
- `id`: string
- `name`: string
- `document`: string
- `age`: number
- `active`: boolean
- `birth_date`: string
- `salary`: number
- `tags`: list
- `contacts`: list
- `address`: map
- `metadata`: map
- `created_at`: string
- `updated_at`: string

## Padroes de Acesso da POC

Minimos:

- criar uma pessoa;
- buscar uma pessoa por `id`;
- listar pessoas;
- atualizar uma pessoa;
- deletar uma pessoa.

Desejavel validar tambem:

- busca por `document`, se esse campo for tratado como unico;
- ordenacao simples por data de criacao em cenarios de listagem.

## Consideracoes de Modelagem

- definir `pk` e `sk` explicitamente, mesmo na POC;
- evitar desenhar indices sem caso de uso claro;
- priorizar padroes de acesso reais;
- manter campos de auditoria desde o inicio;
- garantir compatibilidade com atributos heterogeneos.

## Logs Obrigatorios na Persistencia

Cada operacao no repositorio deve registrar:

- operacao executada;
- chave logica do item;
- resultado;
- duracao;
- erro, quando existir;
- correlation id.

Nao registrar:

- payload completo com dados sensiveis;
- stack trace sem contexto;
- dumps integrais desnecessarios do item.
