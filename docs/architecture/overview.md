# Visao de Arquitetura

## Direcao Arquitetural

A POC deve priorizar desacoplamento entre dominio e tecnologia. AWS, Lambda, DynamoDB, Datadog e CloudWatch entram como adaptadores externos, nao como centro do desenho.

O contexto funcional da POC e um CRUD de pessoas persistido em tabela unica.

Decisoes fechadas:

- `HTTP API`
- `1 Lambda por operacao`
- `Person` como unica entidade principal
- `cpf` unico como regra funcional
- delete logico com `deleted` e `deleted_at`

## Arquitetura Alvo

```text
Cliente HTTP
   |
   v
API Gateway
   |
   +--> Lambda CreatePerson
   +--> Lambda GetPerson
   +--> Lambda ListPeople
   +--> Lambda UpdatePerson
   `--> Lambda DeletePerson
            |
            v
      Application / Use Cases
            |
            +--> Domain
            |
            +--> Output Ports
                    |
                    +--> DynamoDB Adapter
                    +--> Observability Adapter
                    `--> Parameter Store / External Adapters
```

## Principios

- O dominio nao conhece AWS SDK, Terraform, Datadog ou detalhes de transporte HTTP.
- Casos de uso orquestram regras de negocio e dependem de interfaces.
- Adaptadores de entrada traduzem HTTP para comandos e queries internos.
- Adaptadores de saida implementam persistencia, observabilidade e integracoes.
- Configuracao e bootstrap ficam fora do nucleo de dominio.

## Camadas Sugeridas

### 1. Domain

Responsavel por:

- entidades, com `Person` como agregado inicial;
- value objects;
- regras de negocio puras;
- contratos conceituais do dominio quando fizer sentido.

Nao deve conter:

- codigo de infraestrutura;
- dependencia de framework web;
- dependencia de provider cloud.

### 2. Application

Responsavel por:

- casos de uso;
- comandos e queries;
- contratos de entrada e saida;
- orquestracao entre dominio e portas.

Casos de uso esperados na POC:

- create person;
- get person;
- list persons;
- update person;
- delete person.

### 3. Adapters Inbound

Responsavel por:

- handlers HTTP;
- mapeamento de requests/responses;
- integracao com API Gateway e Lambda runtime.

### 4. Adapters Outbound

Responsavel por:

- repositorios DynamoDB;
- publishers de metricas;
- integracao com Datadog;
- escrita de logs e traces via mecanismos definidos.

## Estrategia de Persistencia

A persistencia deve usar tabela unica no DynamoDB.

Premissas iniciais:

- a primeira entidade principal da POC e `Person`;
- o padrao de acesso deve ser definido antes do schema fisico;
- a tabela deve acomodar atributos escalares, listas e mapas;
- logs de leitura e escrita devem incluir contexto suficiente para rastreabilidade sem expor dados sensiveis.

Definicoes fechadas:

- item principal com `pk = PERSON#{id}` e `sk = PROFILE`
- item auxiliar para unicidade de `cpf`
- busca por nome por prefixo
- listagem com paginacao, filtro por `active`, ordenacao por `created_at` e filtro de deletados

### 5. Bootstrap

Responsavel por:

- composicao de dependencias;
- leitura de configuracao;
- wiring dos adaptadores.

## Fluxo Principal da Requisicao

1. O cliente chama o endpoint REST.
2. O API Gateway recebe e roteia para a Lambda.
3. O adaptador Lambda traduz o evento para request interno.
4. O caso de uso valida entrada e executa regras.
5. O caso de uso usa portas de saida para persistencia e observabilidade.
6. O adaptador devolve resposta HTTP padronizada.

Cada etapa deve registrar logs estruturados com correlacao de requisicao, resultado da operacao e duracao.

## Posicionamento do Kubernetes

Kubernetes nao deve competir com a primeira entrega serverless da POC. O papel recomendado e de trilha evolutiva:

- futura execucao de workloads stateful ou long-running;
- processamento assincrono nao ideal para Lambda;
- APIs com necessidade de controle fino de runtime;
- padronizacao futura de plataforma hibrida.

Para esta POC:

- Lambdas sao os runtimes principais;
- Kubernetes entra como desenho de evolucao;
- artefatos de K8s podem ser descritos documentalmente, sem implementacao inicial.

## Decisoes Tecnicas Centrais

- REST como contrato de entrada pela simplicidade da POC
- CRUD de pessoas como caso de uso unico da POC
- tabela unica no DynamoDB para validar modelagem flexivel
- `HTTP API` com `1 Lambda por operacao`
- Go pela previsibilidade operacional e cold start geralmente aceitavel
- Lambda + API Gateway para reduzir carga operacional inicial
- DynamoDB para persistencia serverless e elasticidade
- Terraform como fonte de verdade da infraestrutura
- Datadog + CloudWatch para observabilidade complementar

## Riscos Arquiteturais

- modelagem errada de particao no DynamoDB pode comprometer a POC;
- excesso de abstracao cedo demais pode desacelerar;
- observabilidade pode virar acoplamento se entrar no dominio;
- tentar entregar Lambda e Kubernetes ao mesmo tempo tende a diluir foco.
