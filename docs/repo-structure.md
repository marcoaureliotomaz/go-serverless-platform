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
|   |-- cmd/
|   |-- internal/
|   |   |-- domain/
|   |   |-- application/
|   |   |-- ports/
|   |   `-- adapters/
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

- `cmd/`: pontos de entrada da aplicacao;
- `internal/domain/`: entidades e regras;
- `internal/application/`: casos de uso;
- `internal/ports/`: interfaces de entrada e saida;
- `internal/adapters/`: implementacoes HTTP, AWS e persistencia.

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
- Nada de Terraform espalhado fora de `infra/`
