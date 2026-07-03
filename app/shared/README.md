# Shared Core

Esta pasta concentra o shared core minimo da POC.

## Objetivo

Reaproveitar o que e comum entre as Lambdas sem acoplar o dominio a detalhes de infraestrutura.

## Subpastas

- `domain/`: entidades e regras puras
- `application/`: casos de uso
- `ports/`: contratos de entrada e saida
- `adapters/`: implementacoes compartilhadas de persistencia, observabilidade e configuracao
