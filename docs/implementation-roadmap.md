# Roadmap de Implementacao

## Estrategia

Implementar por fatias verticais pequenas, sempre validando arquitetura e operacao ao mesmo tempo. A POC deve evitar comecar por infraestrutura pesada sem um caso de uso minimo claro.

## Fase 0 - Preparacao

Objetivo:

- alinhar escopo, dominio inicial e criterios de sucesso.

Entregaveis:

- documentos deste repositorio refinados;
- confirmacao do CRUD de pessoas como caso de uso da POC;
- definicao do endpoint inicial;
- definicao dos ambientes minimos, por exemplo `dev`.

## Fase 1 - Contrato da API

Objetivo:

- definir a superficie REST antes da implementacao.

Entregaveis:

- lista de endpoints do CRUD de pessoas;
- payloads de request e response;
- codigos de erro;
- estrategia de versionamento;
- convencoes de idempotencia e paginacao, se aplicavel.

Decisoes a fechar:

- JSON como formato padrao;
- nomenclatura de recursos;
- formato de correlation id.

## Fase 2 - Modelagem Hexagonal

Objetivo:

- estabilizar o desenho interno da aplicacao.

Entregaveis:

- definicao da entidade `Person`;
- casos de uso;
- portas de entrada;
- portas de saida;
- fronteiras entre dominio e adaptadores.

Saida esperada:

- um diagrama simples de fluxo;
- contratos internos suficientes para iniciar codigo sem retrabalho estrutural.

## Fase 3 - Infraestrutura Base em AWS

Objetivo:

- preparar o esqueleto de cloud via Terraform.

Entregaveis:

- estado remoto definido;
- estrutura de modulos;
- API Gateway;
- Lambda;
- IAM minimo necessario;
- DynamoDB;
- log groups;
- variaveis por ambiente.

Atencao:

- manter privilegios minimos;
- evitar recursos desnecessarios para a POC.

## Fase 4 - Persistencia com DynamoDB

Objetivo:

- fechar a modelagem de dados antes de implementar o repositorio.

Entregaveis:

- definicao de tabela unica;
- chave primaria;
- estrategia de acesso;
- indices secundarios apenas se necessarios;
- TTL se fizer sentido;
- politicas de retencao.

Pergunta obrigatoria:

- quais operacoes de CRUD e listagem a API precisa responder de fato?

## Fase 5 - Observabilidade

Objetivo:

- tornar o comportamento da POC visivel desde o inicio.

Entregaveis:

- padrao de log estruturado;
- metricas minimas;
- tracing distribuido;
- convencao de tags;
- dashboards iniciais;
- alertas basicos.

Obrigatorio nesta fase:

- garantir logs em create, get, list, update e delete;
- garantir logs nos adaptadores HTTP, casos de uso e repositorio;
- garantir que CloudWatch e Datadog recebam eventos suficientes para troubleshooting.

## Fase 6 - Seguranca Basica

Objetivo:

- garantir baseline aceitavel para a POC.

Entregaveis:

- gestao de segredos;
- politica IAM minima;
- estrategia de variaveis sensiveis;
- decisao sobre autenticacao da API, mesmo que simplificada.

## Fase 7 - Trilha Kubernetes

Objetivo:

- documentar como e quando migrar ou complementar o runtime.

Entregaveis:

- criterios para sair de Lambda em certos fluxos;
- desenho alvo em K8s;
- impacto em observabilidade;
- impacto em deploy e operacao.

## Ordem Recomendada de Execucao

1. Refinar escopo e dominio.
2. Fechar contrato REST.
3. Fechar desenho hexagonal.
4. Desenhar modelo da pessoa e da tabela unica no DynamoDB.
5. Estruturar Terraform base.
6. Implementar observabilidade transversal.
7. Documentar trilha Kubernetes.
8. So entao comecar geracao de codigo.

## Definition of Done da Etapa de Documentacao

- endpoints definidos;
- dominio inicial de pessoas escolhido;
- estrutura do repositorio aprovada;
- stack AWS minima definida;
- estrategia de observabilidade definida;
- criterios de uso de Kubernetes documentados.
