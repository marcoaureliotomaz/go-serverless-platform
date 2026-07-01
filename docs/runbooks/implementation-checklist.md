# Checklist de Implementacao

## Antes de Gerar Codigo

- escopo da POC validado
- caso de uso inicial de CRUD de pessoas definido
- decisoes consolidadas registradas em documentacao
- endpoints iniciais definidos
- payloads e erros documentados
- fluxo principal da requisicao entendido
- fronteiras da arquitetura hexagonal definidas
- estrategia DynamoDB documentada
- stack Terraform minima definida
- baseline de observabilidade definido
- papel de Kubernetes documentado

## Antes de Subir Infraestrutura

- naming convention definida
- tags obrigatorias definidas
- estrategia de estado remoto definida
- variaveis de ambiente mapeadas
- segredos classificados
- permissoes IAM minimas revisadas

## Antes de Liberar a Primeira Execucao

- logs estruturados definidos
- metricas minimas definidas
- correlacao de requests definida
- tratamento de erro padronizado
- logs obrigatorios em create, get, list, update e delete definidos
- logs em adapter, caso de uso e repositorio definidos
- Lambdas por operacao definidas
- dashboard inicial planejado
- criterios de aceite da POC revisados
