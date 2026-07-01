# ADR 0001: Estrategia de Arquitetura da POC

## Status

Proposto

## Contexto

E necessario montar uma POC de API REST em Go que valide uso de AWS, Terraform, Lambda, API Gateway, DynamoDB, Datadog, CloudWatch e uma arquitetura hexagonal, sem comecar pela geracao prematura de codigo.

Kubernetes faz parte do direcionamento tecnologico, mas nao deve desviar o foco da entrega inicial.

O caso de uso funcional escolhido para a POC e um CRUD de pessoas com persistencia em tabela unica e observabilidade obrigatoria em todas as operacoes.

## Decisao

Adotar a seguinte estrategia:

- implementar a primeira versao executavel em arquitetura serverless na AWS;
- usar Go como linguagem principal da API;
- estruturar a aplicacao com arquitetura hexagonal;
- usar CRUD de pessoas como fluxo funcional unico da POC;
- usar Terraform como mecanismo de provisionamento;
- usar DynamoDB como persistencia primaria da POC;
- usar tabela unica para validar modelagem com tipos heterogeneos;
- integrar CloudWatch e Datadog como base de observabilidade;
- exigir logs estruturados em todas as operacoes e camadas relevantes;
- tratar Kubernetes como etapa de evolucao arquitetural e nao como runtime principal da primeira entrega.

## Justificativa

- reduz risco operacional inicial;
- maximiza foco em fluxo fim a fim funcional;
- preserva desacoplamento para evolucao futura;
- evita manter dois modelos de runtime ao mesmo tempo na primeira iteracao;
- permite validar dominio, observabilidade e IaC com menor atrito.

## Consequencias

### Positivas

- menor tempo para primeira validacao;
- desenho mais claro de responsabilidades;
- menor chance de acoplamento do dominio a infraestrutura;
- evolucao futura para K8s continua viavel.

### Negativas

- parte do desenho Kubernetes ficara inicialmente apenas documental;
- alguns requisitos de longa duracao ou processamento continuo nao serao validados na primeira fase;
- a equipe precisara disciplina para manter as portas e adaptadores coerentes.

## Alternativas Consideradas

### Fazer tudo em Kubernetes desde o inicio

Rejeitada porque:

- aumenta a carga operacional da POC;
- reduz foco na validacao do fluxo principal;
- adiciona complexidade antes de existir necessidade comprovada.

### Fazer POC sem arquitetura hexagonal

Rejeitada porque:

- tornaria mais facil acoplar HTTP, AWS e persistencia ao nucleo;
- reduziria o valor arquitetural da POC como base futura.

## Proximos Passos

- fechar contrato REST;
- definir caso de uso inicial;
- modelar o dominio e as portas;
- descrever a infraestrutura Terraform minima.
