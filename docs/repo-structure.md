# Estrutura Sugerida do Repositorio

## Objetivo

Organizar o repositorio de forma que aplicacao, infraestrutura e documentacao evoluam sem mistura de responsabilidades.

## Estrutura de Alto Nivel

```text
/
|-- README.md
|-- docs/
|   |-- architecture/
|   |-- adrs/
|   |-- diagrams/
|   |-- runbooks/
|   `-- ...
|-- app/
|   |-- shared/
|   |   |-- domain/
|   |   |-- application/
|   |   |-- ports/
|   |   `-- adapters/
|   |-- lambdas/
|   |   |-- create-person/
|   |   |-- get-person/
|   |   |-- list-people/
|   |   |-- update-person/
|   |   `-- delete-person/
|   `-- test/
|-- infra/
|   |-- terraform/
|   |   |-- modules/
|   |   `-- envs/
|   `-- policies/
|-- deploy/
|   |-- lambda/
|   `-- kubernetes/
`-- scripts/
```

## Detalhamento

### `docs/`

Centraliza:

- visao arquitetural;
- ADRs;
- roadmap;
- runbooks;
- decisoes operacionais.

### `app/`

Reservado para a implementacao futura da API em Go.

Sugestao conceitual:

- `shared/domain/`: entidades e regras;
- `shared/application/`: casos de uso;
- `shared/ports/`: interfaces de entrada e saida;
- `shared/adapters/`: implementacoes reutilizaveis de persistencia e observabilidade;
- `lambdas/<operacao>/`: adaptador de entrada e bootstrap de cada Lambda.

Racional:

- a POC fechou `1 Lambda por operacao`;
- ao mesmo tempo, tambem fechou `shared core minimo`;
- essa estrutura aproxima mais o repositorio de um caso real de mercado serverless, onde cada funcao tem entrypoint proprio, mas reaproveita dominio e aplicacao.

### `infra/terraform/`

Reservado para:

- modulos reutilizaveis;
- composicao por ambiente;
- providers;
- variaveis;
- outputs.

### `deploy/lambda/`

Pode conter futuramente:

- definicoes de empacotamento;
- convencoes de runtime;
- documentacao de release.

### `deploy/kubernetes/`

Deve comecar apenas com documentacao e manifestos de referencia quando a trilha evolutiva for enderecada.

### `scripts/`

Reservado para automacoes auxiliares, sem misturar logica da aplicacao.

## Convencoes Recomendadas

- Um unico dominio pequeno para a primeira entrega
- Nomes de diretorio orientados a responsabilidade
- Separacao clara entre codigo da app e IaC
- Nada de logica de negocio dentro de handlers
- Uma Lambda por operacao com shared core reaproveitavel
- Nada de Terraform espalhado fora de `infra/`
