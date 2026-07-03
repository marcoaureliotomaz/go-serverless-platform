# App Structure

Esta pasta concentra a implementacao futura da aplicacao Go.

## Estrutura

- `shared/`: dominio, casos de uso, portas e adaptadores reutilizaveis
- `lambdas/`: entrypoints e bootstrap de cada Lambda
- `test/`: apoio para testes da aplicacao

## Lambdas Previstas

- `create-person`
- `get-person`
- `list-people`
- `update-person`
- `delete-person`

## Regra Importante

Nenhuma logica de negocio deve nascer dentro dos handlers das Lambdas. Os handlers devem apenas adaptar entrada e saida.
