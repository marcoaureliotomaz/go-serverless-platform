# Backlog Completo da POC

## Objetivo

Transformar a documentacao da POC em um plano executavel de trabalho, com sequencia clara, dependencias, criterios de pronto e foco em entrega incremental.

## Como Ler Este Backlog

- `Epico`: agrupamento grande de trabalho
- `Historia`: unidade funcional ou tecnica relevante
- `Tarefas`: atividades objetivas para implementar a historia
- `Dependencias`: o que precisa existir antes
- `Pronto quando`: criterio de encerramento

## Ordem Recomendada de Execucao

1. Fundacao documental e estrutural
2. Infraestrutura AWS e Terraform
3. Shared core e arquitetura Go
4. Observabilidade transversal minima
5. Primeira onda: `create` e `get`
6. Segunda onda: `list`, `update` e `delete`
7. Dashboards, testes e fechamento da POC

## Epico 1 - Fundacao do Projeto

### Historia 1.1 - Consolidar documentacao base

Descricao:

- garantir que o time tenha uma base unica e coerente para iniciar implementacao.

Tarefas:

- revisar `poc-decisions.md`
- revisar `api-person-crud.md`
- revisar `data-model-single-table.md`
- revisar `observability.md`
- revisar `infra-aws.md`
- validar que README aponta para os documentos corretos

Dependencias:

- nenhuma

Pronto quando:

- todos os documentos refletirem as decisoes finais da POC

### Historia 1.2 - Definir estrutura fisica do repositorio para implementacao

Descricao:

- preparar a organizacao de diretorios para app, Terraform e deploy.

Tarefas:

- criar estrutura conceitual de `app/`
- criar estrutura conceitual de `infra/terraform/`
- criar estrutura conceitual de `deploy/`
- definir como organizar shared core e Lambdas
- validar aderencia com arquitetura hexagonal

Dependencias:

- Historia 1.1

Pronto quando:

- existir uma estrutura aprovada para inicio de codigo e IaC

## Epico 2 - Infraestrutura AWS e Terraform

### Historia 2.1 - Estruturar projeto Terraform

Descricao:

- preparar a base do Terraform para gerenciar a infraestrutura da POC.

Tarefas:

- estruturar `modules/`
- estruturar `envs/dev/`
- definir provider AWS
- definir regiao `us-east-1`
- definir convencoes de variaveis
- definir convencoes de outputs
- configurar state local

Dependencias:

- Historia 1.2

Pronto quando:

- existir organizacao Terraform pronta para receber recursos

### Historia 2.2 - Provisionar tabela DynamoDB

Descricao:

- provisionar a tabela unica da POC.

Tarefas:

- definir nome da tabela
- definir chave principal
- definir billing mode
- definir atributos de suporte
- definir GSIs minimos da POC
- definir estrategia de materializacao de prefixes para busca por nome
- definir tags do recurso

Dependencias:

- Historia 2.1
- definicoes de `data-model-single-table.md`

Pronto quando:

- a tabela estiver descrita no Terraform de forma coerente com os acessos previstos

### Historia 2.3 - Provisionar HTTP API

Descricao:

- expor o servico via API Gateway HTTP API.

Tarefas:

- criar HTTP API
- definir rotas do CRUD
- definir integracao com Lambdas
- definir stage `dev`
- definir permissao de invocacao

Dependencias:

- Historia 2.1
- definicoes de `api-person-crud.md`

Pronto quando:

- a API estiver descrita no Terraform com todas as rotas principais

### Historia 2.4 - Provisionar Lambdas da POC

Descricao:

- descrever as cinco Lambdas da aplicacao.

Tarefas:

- definir Lambda `create-person`
- definir Lambda `get-person`
- definir Lambda `list-people`
- definir Lambda `update-person`
- definir Lambda `delete-person`
- definir variaveis de ambiente
- definir timeout e memoria iniciais

Dependencias:

- Historia 2.1
- Historia 2.3

Pronto quando:

- todas as Lambdas previstas estiverem descritas no Terraform

### Historia 2.5 - Provisionar IAM e Parameter Store

Descricao:

- garantir seguranca minima e configuracao centralizada.

Tarefas:

- criar role base das Lambdas
- definir permissao minima para DynamoDB
- definir permissao minima para CloudWatch
- definir permissao minima para Parameter Store
- definir parametros de configuracao da POC

Dependencias:

- Historia 2.1
- Historia 2.4

Pronto quando:

- IAM e configuracoes sensiveis estiverem descritos no Terraform com privilegios minimos

## Epico 3 - Shared Core e Arquitetura Go

### Historia 3.1 - Definir shared core minimo

Descricao:

- preparar os elementos compartilhados entre as Lambdas.

Tarefas:

- definir dominio `Person`
- definir contratos comuns
- definir estruturas de erro
- definir utilitarios de `Clock`
- definir utilitarios de `IDGenerator`
- definir componentes comuns de observabilidade

Dependencias:

- Historia 1.2
- definicoes de `poc-decisions.md`

Pronto quando:

- existir desenho claro do que sera compartilhado entre as Lambdas

### Historia 3.2 - Definir portas e casos de uso

Descricao:

- formalizar a camada de aplicacao da arquitetura hexagonal.

Tarefas:

- definir `PersonRepository`
- definir `Logger`
- definir `Metrics`
- definir `Tracer`
- definir `CreatePerson`
- definir `GetPerson`
- definir `ListPeople`
- definir `UpdatePerson`
- definir `DeletePerson`

Dependencias:

- Historia 3.1

Pronto quando:

- os contratos centrais da aplicacao estiverem fechados

### Historia 3.3 - Definir adaptadores base

Descricao:

- estabelecer adaptadores de entrada e saida antes das operacoes.

Tarefas:

- definir adapter Lambda inbound
- definir repositorio DynamoDB
- definir logger estruturado
- definir emissor de metricas
- definir tracer

Dependencias:

- Historia 3.2
- Historia 2.2

Pronto quando:

- o esqueleto dos adaptadores estiver definido

## Epico 4 - Observabilidade Transversal

### Historia 4.1 - Implementar baseline de logs estruturados

Descricao:

- garantir que a POC nasca observavel desde a primeira operacao executavel.

Tarefas:

- implementar formato padrao de log
- propagar `correlation_id`
- definir mascaramento de CPF
- padronizar `operation`, `layer`, `outcome`, `duration_ms`
- validar logs em todas as Lambdas previstas

Dependencias:

- Historia 3.3

Pronto quando:

- o baseline de logs estiver pronto para ser reutilizado por qualquer operacao

### Historia 4.2 - Implementar baseline de metricas e traces

Descricao:

- garantir visibilidade operacional minima desde a primeira onda.

Tarefas:

- implementar emissao de metricas por operacao
- implementar metricas de erro
- implementar metricas de conflito de CPF
- implementar metricas de delete logico
- implementar 1 trace por requisicao HTTP
- implementar spans por camada

Dependencias:

- Historia 4.1

Pronto quando:

- metricas e traces base estiverem prontas para uso nas operacoes

## Epico 5 - Primeira Onda: Create e Get

### Historia 5.1 - Implementar `CreatePerson`

Descricao:

- entregar a primeira fatia vertical da POC.

Tarefas:

- fechar contrato de entrada de create
- implementar validacoes de create
- gerar UUID no use case
- validar unicidade de CPF
- persistir item principal
- persistir item auxiliar de CPF
- retornar response `201`
- emitir logs, metricas e trace

Dependencias:

- Historia 3.3
- Historia 4.1
- Historia 4.2
- Historia 2.2
- Historia 2.4

Pronto quando:

- a operacao create funcionar ponta a ponta com observabilidade

### Historia 5.2 - Implementar `GetPerson`

Descricao:

- entregar a segunda fatia da primeira onda.

Tarefas:

- fechar contrato de entrada de get
- validar identificador
- buscar por `pk/sk`
- retornar item existente
- tratar item nao encontrado
- permitir retorno de item deletado
- emitir logs, metricas e trace

Dependencias:

- Historia 5.1

Pronto quando:

- a operacao get funcionar ponta a ponta com observabilidade

### Historia 5.3 - Validar primeira onda em AWS

Descricao:

- provar que create e get funcionam no ambiente `dev`.

Tarefas:

- aplicar Terraform da infraestrutura minima
- publicar Lambdas da primeira onda
- validar rotas HTTP
- validar escrita e leitura reais no DynamoDB
- validar logs no CloudWatch
- validar logs, metricas e traces no Datadog

Dependencias:

- Historia 5.1
- Historia 5.2
- Epico 2

Pronto quando:

- create e get estiverem executando em AWS com observabilidade valida

## Epico 6 - Segunda Onda: List, Update e Delete

### Historia 6.1 - Implementar `ListPeople`

Descricao:

- entregar o acesso mais sensivel da POC.

Tarefas:

- fechar query params finais
- implementar paginacao por cursor
- implementar filtro por `active`
- implementar filtro `include_deleted`
- implementar busca por prefixo de nome
- implementar estrategia de prefix indexing definida para DynamoDB
- implementar ordenacao por `created_at`
- emitir logs, metricas e trace

Subtarefas tecnicas recomendadas:

- definir regra de normalizacao de nome para busca
- definir ate quantos prefixes serao materializados por pessoa
- definir estrutura dos itens auxiliares de prefixo
- definir como itens de prefixo refletirao `active` e `deleted`
- definir chave de consulta para prefix search
- definir ordem de escrita dos itens de prefixo no create
- definir atualizacao dos itens de prefixo no update quando `name` mudar
- definir impacto do delete logico nos itens de prefixo
- definir estrategia de consulta combinando prefixo, status e exclusao logica
- definir comportamento do cursor na listagem por prefixo
- validar custo conceitual de escrita adicional por pessoa
- documentar limites da estrategia para nomes longos

Dependencias:

- Historia 5.3
- definicoes de `data-model-single-table.md`

Pronto quando:

- listagem funcionar com cursor, filtros e observabilidade
- a estrategia de prefix indexing estiver implementada e documentada

### Historia 6.2 - Implementar `UpdatePerson`

Descricao:

- entregar atualizacao total com regras de negocio consolidadas.

Tarefas:

- validar payload de update
- carregar estado atual
- impedir alteracao de CPF
- impedir update de item deletado
- permitir update de item `active=false`
- atualizar `updated_at`
- retornar response `200`
- emitir logs, metricas e trace

Dependencias:

- Historia 5.3

Pronto quando:

- update funcionar ponta a ponta e respeitar todas as regras definidas

### Historia 6.3 - Implementar `DeletePerson`

Descricao:

- entregar exclusao logica da entidade.

Tarefas:

- carregar item atual
- marcar `deleted = true`
- preencher `deleted_at`
- retornar `204 No Content`
- emitir logs, metricas e trace

Dependencias:

- Historia 5.3

Pronto quando:

- delete logico funcionar ponta a ponta e influenciar consultas e listagem

### Historia 6.4 - Validar segunda onda em AWS

Descricao:

- provar que list, update e delete funcionam no ambiente `dev`.

Tarefas:

- publicar Lambdas da segunda onda
- validar listagem com filtros
- validar update com regras de negocio
- validar delete logico
- validar impacto do delete em get e list
- validar observabilidade das tres operacoes

Dependencias:

- Historia 6.1
- Historia 6.2
- Historia 6.3

Pronto quando:

- a segunda onda estiver operando em AWS com comportamento esperado

## Epico 7 - Dashboards e Operacao

### Historia 7.1 - Criar dashboards e alertas basicos

Descricao:

- facilitar leitura operacional da POC.

Tarefas:

- criar dashboard da API
- criar dashboard das Lambdas
- criar dashboard do DynamoDB
- criar dashboard do CRUD
- criar alertas basicos de erro e latencia

Dependencias:

- Historia 6.4

Pronto quando:

- houver visualizacao operacional minima da POC

## Epico 8 - Testes e Qualidade

### Historia 8.1 - Cobrir regras de negocio com testes

Descricao:

- validar o comportamento dos casos de uso.

Tarefas:

- testar validacao de create
- testar conflito de CPF
- testar get inexistente
- testar update proibido de item deletado
- testar delete logico
- testar listagem com filtros

Dependencias:

- Epicos 5 e 6

Pronto quando:

- regras principais estiverem protegidas por testes automatizados

### Historia 8.2 - Validar integracao fim a fim

Descricao:

- garantir que a POC funciona de ponta a ponta no ambiente `dev`.

Tarefas:

- executar fluxo create -> get
- executar fluxo update -> get
- executar fluxo list
- executar fluxo delete -> get
- validar logs, metricas e traces em cada fluxo

Dependencias:

- Historia 8.1
- Epico 7

Pronto quando:

- os fluxos principais estiverem validados no ambiente real

## Epico 9 - Fechamento da POC

### Historia 9.1 - Revisar aderencia aos criterios da POC

Descricao:

- verificar se a POC cumpriu os objetivos definidos.

Tarefas:

- revisar escopo
- revisar arquitetura
- revisar observabilidade
- revisar persistencia
- revisar infraestrutura
- revisar comportamento do CRUD

Dependencias:

- Epicos 5, 6, 7 e 8

Pronto quando:

- a POC puder ser considerada tecnicamente validada

### Historia 9.2 - Documentar proximos passos

Descricao:

- fechar a POC com direcionamento de evolucao.

Tarefas:

- registrar limites da abordagem Lambda
- registrar quando Kubernetes passa a fazer sentido
- registrar melhorias de autenticacao
- registrar melhorias de CI/CD
- registrar melhorias de governanca
- registrar evolucoes de busca e observabilidade

Dependencias:

- Historia 9.1

Pronto quando:

- a POC estiver encerrada com trilha clara de evolucao

## Primeira Execucao Recomendada

Se voce for iniciar a implementacao agora, a melhor ordem pratica e:

1. Epico 1
2. Historia 2.1
3. Historia 3.1
4. Historia 3.2
5. Historia 3.3
6. Historia 4.1
7. Historia 4.2
8. Historia 2.2
9. Historia 2.3
10. Historia 2.4
11. Historia 2.5
12. Historia 5.1
13. Historia 5.2
14. Historia 5.3

## Resultado Esperado

Ao seguir este backlog, voce deve conseguir:

- construir a POC com sequencia controlada;
- reduzir retrabalho;
- validar arquitetura, AWS e observabilidade de forma incremental;
- concluir a POC com criterio tecnico claro.
