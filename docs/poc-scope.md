# Escopo da POC

## Objetivo

Validar uma arquitetura de API REST em Go orientada a dominio, implantada em AWS com abordagem serverless, observabilidade integrada e caminho claro para evolucao hibrida com Kubernetes.

## Perguntas que a POC deve responder

- A equipe consegue manter uma API em Go usando arquitetura hexagonal sem acoplamento direto a AWS?
- O modelo Lambda + API Gateway atende ao fluxo principal da API com simplicidade operacional?
- Terraform consegue descrever toda a infraestrutura minima da POC de forma reproduzivel?
- DynamoDB atende o caso de uso inicial sem complexidade excessiva de modelagem?
- CloudWatch e Datadog entregam visibilidade suficiente para troubleshooting e metricas de negocio?
- Kubernetes deve fazer parte da POC executavel ou apenas da trilha de evolucao arquitetural?

## Escopo Incluido

- CRUD completo de pessoas
- Tabela unica para persistencia
- Atributos com tipos de dados variados
- Definicao de bounded context inicial da API
- Contrato REST inicial
- Arquitetura hexagonal para aplicacao Go
- Infraestrutura AWS minima via Terraform
- Execucao principal em Lambda
- Exposicao via API Gateway
- Persistencia em DynamoDB
- Logs, metricas e tracing com CloudWatch e Datadog
- Estrategia de seguranca basica para a POC
- Direcionamento de evolucao para Kubernetes

## Definicoes Ja Fechadas

- API aberta para a primeira versao
- `HTTP API`
- `1 Lambda por operacao`
- ambiente unico `dev`
- observabilidade obrigatoria com logs, metricas e traces
- `cpf` unico
- delete logico

## Escopo Nao Incluido

- Autenticacao complexa com multiplos provedores
- CI/CD completo com multiplos ambientes produtivos
- Multi-account avancado
- Estrategias completas de disaster recovery
- FinOps detalhado
- Plataforma interna multi-tenant completa

## Caso de Uso da POC

A POC sera um cadastro de pessoas com operacoes CRUD completas.

As operacoes minimas sao:

- criar pessoa;
- consultar pessoa por identificador;
- listar pessoas;
- atualizar pessoa;
- remover pessoa.

## Modelo Conceitual da Pessoa

A entidade de pessoa deve conter atributos variados para validar serializacao, validacao e persistencia. Exemplo de tipos a contemplar:

- `id`: string
- `name`: string
- `age`: number
- `active`: boolean
- `birth_date`: string em formato de data
- `salary`: number decimal
- `tags`: lista de strings
- `contacts`: lista de objetos
- `address`: mapa ou objeto aninhado
- `metadata`: mapa flexivel

O objetivo nao e maximizar complexidade de negocio. O objetivo e forcar a POC a lidar com tipos heterogeneos de dados no fluxo inteiro.

O importante nao e o negocio em si, mas validar:

- create, read, update e delete;
- serializacao de tipos simples e complexos;
- rastreabilidade ponta a ponta;
- tratamento de erro;
- organizacao do dominio;
- implantacao repetivel.

## Criterios de Sucesso

- A API expoe endpoints REST minimos e coerentes
- A API cobre o CRUD completo de pessoas
- A aplicacao esta organizada em portas e adaptadores
- A infraestrutura sobe por Terraform sem passos manuais frageis
- A aplicacao registra logs estruturados em todas as operacoes e camadas relevantes
- Metricas e traces podem ser consultados
- Existe documentacao suficiente para um novo dev continuar a implementacao
