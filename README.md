# Go Serverless Platform POC

Este repositorio sera usado para uma POC de plataforma serverless em Go com foco em:

- API REST
- Go
- AWS
- Terraform
- Lambda
- API Gateway
- Kubernetes
- DynamoDB
- Datadog
- CloudWatch
- Arquitetura Hexagonal

Nenhum codigo foi gerado neste estagio. O objetivo atual e definir a arquitetura, a sequencia de implementacao e os documentos de apoio para execucao da POC.

## Documentacao

- [Escopo da POC](docs/poc-scope.md)
- [Visao de Arquitetura](docs/architecture/overview.md)
- [Contrato da API de Pessoas](docs/api-person-crud.md)
- [Modelo da Tabela Unica](docs/data-model-single-table.md)
- [Fases de Construcao](docs/construction-phases.md)
- [Estrutura Sugerida do Repositorio](docs/repo-structure.md)
- [Roadmap de Implementacao](docs/implementation-roadmap.md)
- [Guia de Infraestrutura AWS](docs/infra-aws.md)
- [Guia de Observabilidade](docs/observability.md)
- [ADR 0001 - Estrategia de Arquitetura](docs/adrs/0001-architecture-strategy.md)

## Resultado Esperado da POC

Ao final da POC, o time deve ter clareza sobre:

- como estruturar uma API REST em Go com arquitetura hexagonal;
- como implementar um CRUD de pessoas em tabela unica;
- como expor a API via API Gateway e Lambda;
- como provisionar a infraestrutura com Terraform;
- como persistir dados em DynamoDB;
- como observar a solucao com CloudWatch e Datadog;
- como posicionar Kubernetes na evolucao da plataforma.
