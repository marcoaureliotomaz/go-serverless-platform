# Modelo da Tabela Unica

## Objetivo

Definir a direcao da modelagem DynamoDB para a POC de CRUD de pessoas.

## Estrategia

Usar uma unica tabela para persistir os registros da entidade `Person`.

Mesmo com apenas uma entidade principal na POC, a tabela deve ser desenhada de forma que permita futura extensao.

## Decisoes Fechadas

- chave principal do item de pessoa:
  - `pk = PERSON#{id}`
  - `sk = PROFILE`
- unicidade de CPF com item auxiliar
- listagem priorizando modelagem correta para DynamoDB
- busca por nome por prefixo
- delete logico com `deleted` e `deleted_at`
- estrategia escolhida para aprendizado:
  - materializar prefixes de nome relevantes
  - consultar prefixos via indice auxiliar

## Nome Conceitual da Tabela

Sugestao:

- `poc-person-dev-table`

## Item Principal da Pessoa

### Estrutura

- `pk`: `PERSON#{id}`
- `sk`: `PROFILE`
- `entity_type`: `PERSON`
- `id`: string
- `name`: string
- `name_prefix`: string normalizada para busca
- `cpf`: string
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
- `deleted`: boolean
- `deleted_at`: string ou nulo

### Exemplo de item principal

```json
{
  "pk": "PERSON#550e8400-e29b-41d4-a716-446655440000",
  "sk": "PROFILE",
  "entity_type": "PERSON",
  "id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Maria da Silva",
  "name_prefix": "maria da silva",
  "cpf": "12345678909",
  "age": 34,
  "active": true,
  "birth_date": "1990-05-10",
  "salary": 5500.75,
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

## Item Auxiliar de Unicidade de CPF

### Estrutura

- `pk`: `CPF#{cpf}`
- `sk`: `UNIQUE`
- `entity_type`: `PERSON_CPF_UNIQUE`
- `person_id`: string
- `created_at`: string

### Exemplo de item auxiliar

```json
{
  "pk": "CPF#12345678909",
  "sk": "UNIQUE",
  "entity_type": "PERSON_CPF_UNIQUE",
  "person_id": "550e8400-e29b-41d4-a716-446655440000",
  "created_at": "2026-07-01T10:00:00Z"
}
```

## Padroes de Acesso da POC

### 1. Create person

Objetivo:

- criar uma pessoa garantindo unicidade de CPF.

Itens envolvidos:

- item principal da pessoa;
- item auxiliar de CPF.

Implicacao:

- o create deve considerar escrita consistente dos dois itens.

### 2. Get person por `id`

Objetivo:

- buscar uma pessoa diretamente pela chave principal.

Chave:

- `pk = PERSON#{id}`
- `sk = PROFILE`

Observacao:

- pode retornar item deletado.

### 3. List people

Objetivo:

- listar pessoas com paginacao, filtro por `active`, busca por prefixo de nome, ordenacao por `created_at` e opcao de incluir deletados.

Desafio:

- esse e o acesso mais sensivel da POC.

### 4. Update person

Objetivo:

- atualizar todos os campos de negocio permitidos.

Observacoes:

- `cpf` nao pode mudar;
- item deletado nao pode ser atualizado;
- `updated_at` deve ser renovado.

### 5. Delete person

Objetivo:

- marcar item com delete logico.

Observacoes:

- atualizar `deleted = true`;
- atualizar `deleted_at`;
- manter o item principal para auditoria e rastreabilidade.

## Estrategia de Listagem

Como a POC prioriza modelagem correta para DynamoDB, a listagem nao deve depender de `scan` como caminho principal.

### Requisitos da listagem

- paginacao por cursor
- filtro por `active`
- busca por prefixo de nome
- ordenacao por `created_at`
- filtro de deletados

### Abordagem recomendada

Usar atributos auxiliares e indice voltado a listagem.

Sugestao conceitual:

- `gsi1pk`: valor fixo para agregacao de pessoas
- `gsi1sk`: combinacao orientada a ordenacao e filtro

Exemplo conceitual:

- `gsi1pk = PERSON`
- `gsi1sk = ACTIVE#{active}#DELETED#{deleted}#CREATED_AT#{created_at}#NAME#{name_prefix}#ID#{id}`

Observacao importante:

- esta composicao e uma direcao conceitual;
- a implementacao final pode ajustar o formato para acomodar melhor os padroes reais de query;
- dependendo da consulta, pode ser preferivel mais de um indice em vez de um unico indice sobrecarregado.

## Indices Conceituais

### GSI para listagem principal

Objetivo:

- suportar ordenacao, filtro por `active` e exclusao logica.

Sugestao:

- `gsi1pk = PERSON`
- `gsi1sk = CREATED_AT#{created_at}#ID#{id}`

Possivel uso:

- listar pessoas por data de criacao;
- paginar com cursor;
- aplicar filtro adicional em memoria apenas se o custo estiver aceitavel para a POC.

### GSI para busca por prefixo de nome

Objetivo:

- suportar busca por prefixo de nome de forma mais aderente ao DynamoDB sem vender uma simplicidade falsa.

Direcao de mercado:

- DynamoDB puro nao oferece busca textual rica nativamente;
- para prefix search real, times costumam escolher entre:
  - materializar prefixes relevantes;
  - simplificar o comportamento de busca;
  - usar um mecanismo dedicado de busca quando a necessidade cresce.

Recomendacao escolhida para esta POC:

- manter a busca por prefixo como requisito funcional da API;
- implementar uma estrategia explicita de prefix indexing;
- usar essa parte da POC como estudo real de tradeoff em DynamoDB.

### Estrategia escolhida

Direcao:

- manter um atributo normalizado de nome, por exemplo `name_search = mariadasilva`;
- materializar prefixes relevantes desse valor;
- indexar esses prefixes em item ou estrutura auxiliar para consulta.

Exemplo conceitual de prefixes materializados para `Maria`:

- `M`
- `MA`
- `MAR`
- `MARI`
- `MARIA`

Exemplo conceitual para `Maria da Silva` normalizado:

- `M`
- `MA`
- `MAR`
- `MARI`
- `MARIA`
- `MARIAD`
- `MARIADA`
- `MARIADAS`

### Modelo conceitual de prefix item

Opcao educativa recomendada:

- criar item auxiliar por prefixo relevante

Exemplo:

```json
{
  "pk": "NAMEPREFIX#MAR",
  "sk": "PERSON#550e8400-e29b-41d4-a716-446655440000",
  "entity_type": "PERSON_NAME_PREFIX",
  "person_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Maria da Silva",
  "created_at": "2026-07-01T10:00:00Z",
  "active": true,
  "deleted": false
}
```

Consulta esperada:

- o cliente envia `name_prefix=MAR`
- a aplicacao normaliza o prefixo
- a busca consulta `pk = NAMEPREFIX#MAR`
- a ordenacao e continuidade da pagina usam `sk`

### Por que esta e a opcao com mais aprendizado

- mostra como DynamoDB exige modelagem por acesso;
- evidencia o custo de escrita adicional para ganhar velocidade de leitura;
- ensina por que requisitos simples de busca mudam o desenho da tabela;
- aproxima a POC de dilemas reais de mercado sem introduzir uma stack de busca separada cedo demais.

Observacao:

- esta abordagem aumenta escrita e complexidade;
- para a POC, isso tem valor pedagogico porque mostra um caso real de tradeoff em DynamoDB;
- se o custo de implementacao ficar alto demais, a alternativa honesta e documentar a busca por prefixo como simplificada na primeira versao.

### GSI para filtro por `active`

Objetivo:

- reduzir complexidade da listagem quando o filtro por status for frequente.

Sugestao:

- `gsi3pk = ACTIVE#{active}`
- `gsi3sk = CREATED_AT#{created_at}#ID#{id}`

Observacao:

- a POC nao precisa obrigatoriamente criar todos os GSIs sugeridos;
- o importante nesta fase e explicitar quais acessos podem exigir indice dedicado;
- em contexto real de mercado, a combinacao de filtros pode levar o time a reduzir escopo de query ou introduzir outra capacidade de busca.

## Cursor de Paginacao

### Objetivo

- permitir paginacao segura e coerente com DynamoDB.

### Direcao

- usar `LastEvaluatedKey` serializado em base64 como `next_cursor`.

### Exemplo conceitual

```json
{
  "page_size": 10,
  "next_cursor": "eyJwayI6IlBFUlNPTiM1NTBlODQwMC1lMjliLTQxZDQtYTcxNi00NDY2NTU0NDAwMDAifQ=="
}
```

## Regras de Consulta

- `GetPerson` pode retornar item deletado
- `ListPeople` por padrao exclui deletados
- `include_deleted=true` retorna deletados e nao deletados
- `page_size` maximo da POC: `10`
- busca por nome deve usar prefixo

## Sequencia Tecnica Recomendada para Implementar Prefix Search

### Passo 1 - Normalizar o nome

Objetivo:

- gerar um valor consistente para indexacao.

Exemplo:

- entrada: `Maria da Silva`
- valor normalizado: `MARIADASILVA`

### Passo 2 - Definir politica de materializacao

Objetivo:

- limitar o custo da estrategia.

Recomendacao para a POC:

- materializar prefixes a partir do inicio do nome normalizado;
- definir um tamanho maximo razoavel de prefixos para estudo, por exemplo entre 2 e 8 caracteres;
- evitar materializacao infinita para nao inflar demais a escrita.

Exemplo:

- `MA`
- `MAR`
- `MARI`
- `MARIA`
- `MARIAD`
- `MARIADA`
- `MARIADAS`

### Passo 3 - Criar itens auxiliares de prefixo

Objetivo:

- permitir query direta por prefixo.

Direcao:

- cada prefixo relevante gera um item auxiliar.

Exemplo conceitual:

```json
{
  "pk": "NAMEPREFIX#MARI",
  "sk": "ACTIVE#true#DELETED#false#CREATED_AT#2026-07-01T10:00:00Z#PERSON#550e8400-e29b-41d4-a716-446655440000",
  "entity_type": "PERSON_NAME_PREFIX",
  "person_id": "550e8400-e29b-41d4-a716-446655440000",
  "name": "Maria da Silva",
  "active": true,
  "deleted": false,
  "created_at": "2026-07-01T10:00:00Z"
}
```

### Passo 4 - Definir reflexo de update e delete

Objetivo:

- impedir divergencia entre item principal e itens auxiliares.

Regras:

- create deve escrever os itens auxiliares necessarios;
- update de `name` deve recriar os itens de prefixo;
- update de `active` deve refletir no atributo ou chave de consulta adotada;
- delete logico deve impedir que o item continue aparecendo na listagem padrao.

### Passo 5 - Definir estrategia de query

Objetivo:

- suportar busca por prefixo com ordenacao e filtro.

Direcao sugerida:

- consultar pelo `pk` do prefixo;
- usar `sk` para ordenar por `created_at` e refletir `active` e `deleted`;
- aplicar `page_size` e cursor de DynamoDB normalmente.

### Passo 6 - Medir o tradeoff

Objetivo:

- tornar o aprendizado explicito.

O que observar:

- quantos itens extras cada pessoa gera;
- impacto no create e update;
- impacto na manutencao do delete logico;
- beneficio de leitura frente ao custo de escrita.

## Consistencia e Auditoria

### `created_at`

- definido na criacao

### `updated_at`

- atualizado em toda alteracao de negocio

### `deleted_at`

- preenchido apenas no delete logico

### Conflito de CPF

- deve resultar em erro funcional equivalente a `409 Conflict`

## Consideracoes de Modelagem

- definir `pk` e `sk` explicitamente, mesmo na POC;
- usar item auxiliar para garantir unicidade de `cpf`;
- evitar desenhar indices sem caso de uso claro;
- priorizar padroes de acesso reais;
- manter campos de auditoria desde o inicio;
- garantir compatibilidade com atributos heterogeneos.

## Riscos e Tradeoffs

- busca por prefixo de nome ainda exige estrategia cuidadosa de indice;
- materializacao de prefixes aumenta custo e quantidade de itens escritos;
- combinar todos os filtros em um unico indice pode aumentar complexidade;
- excesso de GSIs cedo demais pode deixar a POC mais pesada que o necessario;
- a implementacao deve equilibrar corretude de DynamoDB com simplicidade de estudo;
- esse e um bom ponto de aprendizado real: DynamoDB funciona muito bem quando os acessos sao claros, mas busca mais flexivel exige desenho adicional ou outra ferramenta.

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
