# Go Serverless Platform POC

Esta POC foi desenhada para estudar um caso real de mercado: como construir uma API REST em Go, orientada a arquitetura hexagonal, executando em AWS com abordagem serverless, observabilidade forte e modelagem DynamoDB guiada por padroes de acesso.

O dominio escolhido e propositalmente simples: um CRUD de pessoas. O valor da POC nao esta no negocio em si, e sim nos tradeoffs tecnicos que ela permite exercitar:

- `HTTP API` + `Lambda`
- `1 Lambda por operacao`
- `Go` com arquitetura hexagonal
- `Terraform` como fonte de verdade da infraestrutura
- `DynamoDB` com tabela unica
- `CloudWatch` + `Datadog` para logs, metricas e traces
- busca por prefixo em DynamoDB como caso real de modelagem
- trilha futura para `Kubernetes`, sem desviar o foco da primeira entrega

## O Que Esta Sendo Validado

Esta POC busca responder de forma pratica:

- como organizar uma API em Go sem acoplar dominio a AWS;
- como modelar um CRUD de pessoas em tabela unica no DynamoDB;
- como lidar com unicidade de `cpf`;
- como tratar busca por prefixo em DynamoDB sem esconder a complexidade;
- como subir infraestrutura reproduzivel com Terraform;
- como tornar o servico observavel desde a primeira operacao executavel.

## Decisoes Centrais da POC

- dominio unico: `Person`
- operacoes: `create`, `get`, `list`, `update`, `delete`
- `id` gerado no caso de uso com `UUID`
- `cpf` unico
- delete logico com `deleted` e `deleted_at`
- API aberta na primeira versao
- ambiente inicial unico: `dev`
- `HTTP API`
- `1 Lambda por operacao`
- nome do servico: `person-service`
- prefixo AWS: `poc-person-dev`
- regiao AWS: `us-east-1`
- Terraform state local na fase inicial
- `Parameter Store` para configuracoes sensiveis

## Valor de Aprendizado

Esta POC foi intencionalmente empurrada para um terreno que gera aprendizado real, e nao apenas uma implementacao facil:

- a busca por nome foi mantida como **prefix search**;
- DynamoDB nao foi tratado como banco "magico";
- a documentacao assume o custo real de modelagem para suportar esse acesso;
- observabilidade foi tratada como requisito desde o inicio, e nao como acabamento.

Isso faz com que a POC tenha valor para estudo de:

- arquitetura serverless de mercado;
- modelagem por padrao de acesso em DynamoDB;
- tradeoffs entre custo de escrita e eficiencia de leitura;
- desacoplamento entre dominio, adaptadores e infraestrutura;
- operacao observavel de APIs em AWS.

## Mapa da Documentacao

### Para entender a POC rapidamente

- [Decisoes Consolidadas da POC](docs/poc-decisions.md)
- [Escopo da POC](docs/poc-scope.md)
- [Visao de Arquitetura](docs/architecture/overview.md)

### Para entender o comportamento funcional

- [Contrato da API de Pessoas](docs/api-person-crud.md)
- [Modelo da Tabela Unica](docs/data-model-single-table.md)

### Para executar a construcao

- [Backlog Completo da POC](docs/backlog.md)
- [Fases de Construcao](docs/construction-phases.md)
- [Roadmap de Implementacao](docs/implementation-roadmap.md)
- [Checklist de Implementacao](docs/runbooks/implementation-checklist.md)

### Para infraestrutura e operacao

- [Guia de Infraestrutura AWS](docs/infra-aws.md)
- [Guia de Observabilidade](docs/observability.md)
- [Estrutura Sugerida do Repositorio](docs/repo-structure.md)
- [ADR 0001 - Estrategia de Arquitetura](docs/adrs/0001-architecture-strategy.md)

## Como Navegar Neste Repositorio

Se voce quer entender o projeto em ordem pratica:

1. Leia [Decisoes Consolidadas da POC](docs/poc-decisions.md)
2. Leia [Contrato da API de Pessoas](docs/api-person-crud.md)
3. Leia [Modelo da Tabela Unica](docs/data-model-single-table.md)
4. Leia [Guia de Observabilidade](docs/observability.md)
5. Execute o trabalho a partir de [Backlog Completo da POC](docs/backlog.md)

## Estado Atual

Neste estagio, o repositorio esta focado em definicao arquitetural, sequencia de implementacao e documentacao de apoio.

- nenhum codigo foi gerado ainda;
- a POC esta estruturada para iniciar implementacao com menos ambiguidade;
- os tradeoffs principais ja foram documentados.

## Resultado Esperado

Ao final da POC, o time deve ter clareza sobre:

- como estruturar uma API REST em Go com arquitetura hexagonal;
- como implementar um CRUD de pessoas em tabela unica;
- como expor a API via API Gateway e Lambda;
- como provisionar a infraestrutura com Terraform;
- como persistir dados em DynamoDB;
- como observar a solucao com CloudWatch e Datadog;
- como reconhecer quando a arquitetura serverless continua adequada e quando outra abordagem passa a fazer sentido.
