# Guia de Observabilidade

## Objetivo

Definir um baseline de observabilidade para a POC desde o primeiro incremento executavel.

Todas as partes e operacoes do sistema devem produzir logs estruturados consultaveis em CloudWatch e/ou Datadog.

## Ferramentas e Papeis

### CloudWatch

Usar para:

- logs da Lambda;
- metricas nativas da AWS;
- alarmes basicos;
- troubleshooting inicial.

### Datadog

Usar para:

- correlacao entre metricas, logs e traces;
- dashboards mais ricos;
- visao consolidada da aplicacao;
- alertas de experiencia operacional.

## Pilares da Observabilidade

### Logs

Padrao recomendado:

- logs estruturados em JSON;
- sem texto solto como formato principal;
- sempre incluir `timestamp`, `level`, `message`, `service`, `environment`, `correlation_id`;
- incluir tambem `operation`, `layer`, `resource_type`, `resource_id`, `outcome`, `duration_ms` quando aplicavel.

Camadas que devem logar:

- entrada HTTP no API Gateway ou adapter Lambda;
- handler ou adapter inbound;
- caso de uso da aplicacao;
- repositorio DynamoDB;
- bootstrap e inicializacao;
- tratamento de erro.

Operacoes obrigatorias com logs:

- create person;
- get person;
- list persons;
- update person;
- delete person.

Evitar:

- logging de dados sensiveis;
- stack traces sem contexto;
- logs duplicados no mesmo fluxo.

### Metricas

Metricas minimas:

- contagem de requisicoes;
- latencia por endpoint;
- taxa de erro;
- duracao da Lambda;
- cold starts, se possivel observar;
- throughput de leitura e escrita no DynamoDB;
- contagem por operacao de CRUD;
- sucesso e falha por operacao.

### Tracing

Objetivo:

- acompanhar a requisicao do API Gateway ate a persistencia;
- identificar gargalos e falhas externas;
- correlacionar `correlation_id` com trace.

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
- dashboard da Lambda;
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
