# Guia de Observabilidade

## Objetivo

Definir um baseline de observabilidade para a POC desde o primeiro incremento executavel.

Todas as partes e operacoes do sistema devem produzir logs estruturados consultaveis em CloudWatch e/ou Datadog.

## Ferramentas e Papeis

### CloudWatch

Usar para:

- logs das Lambdas;
- metricas nativas da AWS;
- alarmes basicos;
- troubleshooting inicial.

### Datadog

Usar para:

- correlacao entre metricas, logs e traces;
- dashboards mais ricos;
- visao consolidada da aplicacao;
- alertas de experiencia operacional.

## Decisoes Fechadas

- logs estruturados obrigatorios em todas as operacoes
- metricas obrigatorias por operacao de CRUD
- 1 trace por requisicao HTTP
- spans minimos para adapter, use case e repository
- CPF sempre mascarado e nunca completo em logs

## Pilares da Observabilidade

### Logs

Padrao obrigatorio:

- logs estruturados em JSON;
- sem texto solto como formato principal;
- sempre incluir `timestamp`, `level`, `message`, `service`, `environment`, `correlation_id`;
- incluir obrigatoriamente `operation`, `layer`, `outcome`, `duration_ms`, `person_id` e `error_code` quando aplicavel.

Campos recomendados por log:

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

Camadas que devem logar:

- adapter HTTP/Lambda;
- caso de uso da aplicacao;
- repositorio DynamoDB;
- bootstrap e inicializacao;
- tratamento de erro.

Niveis de log:

- `INFO`
- `WARN`
- `ERROR`

Regras de dados sensiveis:

- nunca logar CPF completo;
- sempre mascarar CPF quando for realmente necessario logar contexto funcional;
- nao logar payload integral sem necessidade;
- nao logar stack trace sem contexto de erro.

### Metricas

Metricas obrigatorias:

- `person_create_total`
- `person_get_total`
- `person_list_total`
- `person_update_total`
- `person_delete_total`
- `person_conflict_cpf_total`
- `person_error_total`
- `person_logical_delete_total`
- `person_operation_duration_ms`

### Tracing

Objetivo:

- acompanhar a requisicao do API Gateway ate a persistencia;
- identificar gargalos e falhas externas;
- correlacionar `correlation_id` com trace.

Formato minimo:

- 1 trace por requisicao HTTP;
- spans para adapter, use case e repository.

## Matriz por Camada

### Adapter HTTP/Lambda

Responsavel por:

- receber o evento HTTP;
- extrair e propagar `correlation_id`;
- medir duracao da requisicao;
- traduzir request/response;
- registrar resultado HTTP.

Logs minimos:

- inicio da requisicao;
- fim da requisicao;
- status HTTP retornado;
- erro de parse ou adaptacao, quando existir.

Metricas relacionadas:

- total da operacao;
- duracao da operacao;
- erro da operacao.

Tracing:

- abrir trace principal;
- criar span do adapter.

### Use Case

Responsavel por:

- validar entrada;
- aplicar regras de negocio;
- orquestrar portas de saida.

Logs minimos:

- inicio do caso de uso;
- resultado da validacao;
- resultado final de negocio;
- classificacao de conflito ou nao encontrado, quando aplicavel.

Metricas relacionadas:

- sucesso por operacao;
- falha por operacao;
- conflito de CPF, quando aplicavel.

Tracing:

- criar span do caso de uso;
- marcar erros funcionais quando existirem.

### Repository

Responsavel por:

- interagir com DynamoDB;
- registrar operacoes de persistencia;
- medir duracao das chamadas ao banco.

Logs minimos:

- operacao executada;
- chave logica consultada ou alterada;
- sucesso ou falha;
- duracao da operacao.

Metricas relacionadas:

- erros de persistencia;
- duracao de operacoes de persistencia;
- contagem de delete logico.

Tracing:

- criar span do repositorio;
- registrar detalhes tecnicos da operacao sem expor dados sensiveis.

### Bootstrap

Responsavel por:

- inicializar dependencias;
- carregar configuracao;
- reportar falhas de inicializacao.

Logs minimos:

- inicio da inicializacao;
- componentes carregados;
- falha de bootstrap, quando existir.

Tracing:

- opcional para bootstrap na POC;
- obrigatorio apenas se o fluxo de inicializacao ficar relevante para troubleshooting.

## Matriz por Operacao

### Create person

Objetivo operacional:

- garantir rastreabilidade completa do fluxo de criacao e da validacao de unicidade do CPF.

Logs obrigatorios:

- recebimento da requisicao;
- validacao do payload;
- geracao do `id`;
- verificacao de unicidade do CPF;
- escrita do item principal;
- escrita do item auxiliar de CPF;
- resposta final de sucesso ou falha.

Metricas obrigatorias:

- `person_create_total`
- `person_operation_duration_ms`
- `person_conflict_cpf_total`, quando houver conflito
- `person_error_total`, quando houver erro

Tracing minimo:

- span `http.adapter.create_person`
- span `usecase.create_person`
- span `repository.check_cpf_unique`
- span `repository.put_person`
- span `repository.put_cpf_unique`

### Get person

Objetivo operacional:

- garantir leitura por chave principal com visibilidade de sucesso, nao encontrado ou item deletado.

Logs obrigatorios:

- recebimento da requisicao;
- validacao do identificador;
- leitura no repositorio;
- classificacao de encontrado ou nao encontrado;
- resposta final.

Metricas obrigatorias:

- `person_get_total`
- `person_operation_duration_ms`
- `person_error_total`, quando houver erro

Tracing minimo:

- span `http.adapter.get_person`
- span `usecase.get_person`
- span `repository.get_person`

### List people

Objetivo operacional:

- garantir visibilidade do acesso mais sensivel da POC.

Logs obrigatorios:

- recebimento da requisicao com query params relevantes;
- validacao de `page_size`, `sort_order`, `active` e `include_deleted`;
- estrategia de consulta escolhida;
- retorno da pagina e do cursor;
- resposta final.

Metricas obrigatorias:

- `person_list_total`
- `person_operation_duration_ms`
- `person_error_total`, quando houver erro

Tracing minimo:

- span `http.adapter.list_people`
- span `usecase.list_people`
- span `repository.list_people`

### Update person

Objetivo operacional:

- rastrear atualizacao total com validacao de regras de negocio.

Logs obrigatorios:

- recebimento da requisicao;
- validacao do payload;
- leitura do estado atual;
- verificacao de restricoes de update;
- escrita da atualizacao;
- resposta final.

Metricas obrigatorias:

- `person_update_total`
- `person_operation_duration_ms`
- `person_error_total`, quando houver erro

Tracing minimo:

- span `http.adapter.update_person`
- span `usecase.update_person`
- span `repository.get_person`
- span `repository.update_person`

### Delete person

Objetivo operacional:

- rastrear a exclusao logica ponta a ponta.

Logs obrigatorios:

- recebimento da requisicao;
- leitura do item atual;
- marcacao de `deleted` e `deleted_at`;
- resposta final sem corpo.

Metricas obrigatorias:

- `person_delete_total`
- `person_logical_delete_total`
- `person_operation_duration_ms`
- `person_error_total`, quando houver erro

Tracing minimo:

- span `http.adapter.delete_person`
- span `usecase.delete_person`
- span `repository.get_person`
- span `repository.logical_delete_person`

## Formato Conceitual de Log

Exemplo:

```json
{
  "timestamp": "2026-07-01T10:00:00Z",
  "level": "INFO",
  "message": "create person request completed",
  "service": "person-service",
  "environment": "dev",
  "correlation_id": "c8f2f0a5-7b09-4e0b-a92a-2d773b3dc001",
  "operation": "create_person",
  "layer": "usecase",
  "outcome": "success",
  "duration_ms": 42,
  "person_id": "550e8400-e29b-41d4-a716-446655440000",
  "error_code": null
}
```

## Convencoes de Tagging

Tags sugeridas:

- `service`
- `env`
- `version`
- `team`
- `domain`

## Dashboards Iniciais

Criar pelo menos:

- dashboard da API;
- dashboard das Lambdas por operacao;
- dashboard do DynamoDB;
- dashboard do CRUD de pessoas;
- dashboard executivo simples da POC.

## Alertas Basicos

- aumento de erro 5xx;
- latencia acima do limite definido;
- falhas repetidas da Lambda;
- throttling no DynamoDB;
- falha recorrente em qualquer operacao do CRUD;
- ausencia de trafego quando isso for sinal de problema.

## Perguntas que a Observabilidade Deve Responder

- Qual endpoint falhou?
- Em qual ambiente?
- Qual foi a latencia?
- A falha foi na regra de negocio, persistencia ou integracao?
- Houve impacto concentrado em uma chave de acesso do DynamoDB?
- Qual operacao de CRUD falhou?
