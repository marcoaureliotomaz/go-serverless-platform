# Fases de Construcao do Servico

## Objetivo

Organizar a construcao da POC como um plano executavel de trabalho, com fases, tarefas e subtarefas. Cada item descreve funcao, contexto, motivo, motivacao e necessidade de implementacao.

## Como Usar Este Documento

- seguir as fases na ordem recomendada;
- usar cada tarefa como unidade de planejamento;
- validar os criterios de saida de cada fase antes de avancar;
- evitar iniciar codigo antes das definicoes estruturais obrigatorias.

## Estado Atual das Definicoes

As fases deste documento ja foram percorridas e consolidadas para esta POC. As decisoes finais estao registradas em [Decisoes Consolidadas da POC](poc-decisions.md).

Resumo do que foi fechado:

- dominio `Person`
- CRUD completo com listagem
- `HTTP API`
- `1 Lambda por operacao`
- DynamoDB com tabela unica
- unicidade de `cpf`
- observabilidade obrigatoria em todas as operacoes
- `person-service` em `us-east-1`
- Terraform com state local na fase inicial

## Fase 0 - Fundacao da POC

### Tarefa 0.1 - Consolidar o escopo funcional

Funcao:

- definir exatamente o que a POC vai entregar.

Contexto:

- sem um escopo fechado, a POC tende a crescer e perder foco tecnico.

Motivo:

- o servico precisa validar CRUD, tabela unica, observabilidade e arquitetura hexagonal sem se dispersar em requisitos paralelos.

Motivacao:

- reduzir retrabalho e discussoes tardias sobre o que deveria ou nao fazer parte da primeira entrega.

Necessidade de implementar:

- esta tarefa e obrigatoria para impedir que infraestrutura, dominio e API sejam desenhados para cenarios diferentes.

Subtarefas:

- confirmar que o dominio da POC sera `Person`;
- confirmar que a POC tera apenas CRUD e listagem;
- confirmar que a persistencia sera em tabela unica;
- confirmar que logs, metricas e traces sao obrigatorios em todas as operacoes.

### Tarefa 0.2 - Definir criterios de sucesso da POC

Funcao:

- estabelecer o que caracteriza a POC como concluida.

Contexto:

- uma POC sem criterios objetivos pode parecer funcional, mas continuar tecnicamente incompleta.

Motivo:

- o time precisa saber quando o servico validou arquitetura, cloud e observabilidade de forma suficiente.

Motivacao:

- proteger o projeto de prolongamento indefinido e facilitar aceite tecnico.

Necessidade de implementar:

- sem isso, nao ha base solida para priorizar tarefas nem para encerrar a fase documental.

Subtarefas:

- definir quais endpoints precisam existir;
- definir o minimo de logs, metricas e traces;
- definir quais operacoes DynamoDB precisam ser exercitadas;
- definir quais artefatos Terraform sao obrigatorios.

## Fase 1 - Definicao do Contrato da API

### Tarefa 1.1 - Definir os endpoints do CRUD

Funcao:

- estabelecer a superficie publica do servico.

Contexto:

- a API REST sera o ponto de entrada principal da POC via API Gateway.

Motivo:

- os casos de uso internos e a modelagem de requests dependem de um contrato claro.

Motivacao:

- evitar implementacao orientada por tentativa e erro no handler HTTP ou Lambda adapter.

Necessidade de implementar:

- sem endpoints definidos, nao e possivel fechar payloads, validacoes ou observabilidade por operacao.

Subtarefas:

- definir `POST /v1/people`;
- definir `GET /v1/people/{id}`;
- definir `GET /v1/people`;
- definir `PUT /v1/people/{id}`;
- definir `DELETE /v1/people/{id}`.

### Tarefa 1.2 - Definir payloads de request e response

Funcao:

- formalizar a estrutura de dados trafegada pela API.

Contexto:

- a POC exige atributos de tipos variados para validar serializacao, validacao e persistencia.

Motivo:

- o contrato precisa refletir dados reais o suficiente para testar comportamento com tipos heterogeneos.

Motivacao:

- impedir que a modelagem fique simplista a ponto de nao validar o uso de DynamoDB e observabilidade em cenarios reais.

Necessidade de implementar:

- payloads detalhados sao pre-requisito para dominio, adaptadores e persistencia.

Subtarefas:

- definir campos obrigatorios e opcionais;
- definir tipos simples, listas, mapas e objetos aninhados;
- definir formato de datas;
- definir campos de auditoria;
- definir padrao de resposta de sucesso.

Decisoes fechadas nesta fase:

- obrigatorios no create: `name`, `cpf`, `birth_date`, `active`, `salary`
- update total
- delete logico
- listagem com `page_size`, `cursor`, `name_prefix`, `active`, `sort_order` e `include_deleted`

### Tarefa 1.3 - Definir erros e semantica HTTP

Funcao:

- padronizar como a API comunica falhas e resultados esperados.

Contexto:

- o servico tera validacoes de entrada, conflitos de unicidade e cenarios de nao encontrado.

Motivo:

- os consumidores da API precisam receber respostas coerentes e previsiveis.

Motivacao:

- melhorar rastreabilidade e facilitar logs, alarmes e dashboards.

Necessidade de implementar:

- sem isso, a camada HTTP fica inconsistente e dificulta troubleshooting.

Subtarefas:

- definir erros `400`, `404`, `409` e `500`;
- definir formato do corpo de erro;
- definir como `correlation_id` sera retornado;
- definir quando usar `201`, `200` e `204`.

## Fase 2 - Modelagem do Dominio e Arquitetura Hexagonal

### Tarefa 2.1 - Modelar a entidade `Person`

Funcao:

- transformar o contrato externo em um modelo de dominio coerente.

Contexto:

- a POC usa um dominio simples, mas precisa lidar com tipos de dados diversos.

Motivo:

- o modelo interno nao deve ser uma copia cega do payload HTTP.

Motivacao:

- garantir que o dominio continue evoluivel e desacoplado de transporte e persistencia.

Necessidade de implementar:

- sem entidade bem definida, os casos de uso viram apenas roteamento de campos.

Subtarefas:

- definir atributos de negocio da pessoa;
- definir invariantes basicas;
- definir campos obrigatorios e opcionais no dominio;
- definir como tratar unicidade funcional, se houver.

### Tarefa 2.2 - Definir casos de uso da aplicacao

Funcao:

- estabelecer as operacoes que orquestram as regras do servico.

Contexto:

- a arquitetura hexagonal exige separar regras de negocio de IO e infraestrutura.

Motivo:

- create, get, list, update e delete devem existir como unidades explicitas da camada de aplicacao.

Motivacao:

- deixar claro onde ficam validacoes, logs de negocio e interacoes com portas.

Necessidade de implementar:

- sem casos de uso definidos, a logica tende a escapar para handlers ou repositorios.

Subtarefas:

- definir `CreatePerson`;
- definir `GetPerson`;
- definir `ListPeople`;
- definir `UpdatePerson`;
- definir `DeletePerson`.

### Tarefa 2.3 - Definir portas de entrada e saida

Funcao:

- explicitar os contratos entre a aplicacao e o mundo externo.

Contexto:

- a POC precisa manter dominio desacoplado de Lambda, DynamoDB, CloudWatch e Datadog.

Motivo:

- repositorio, logger, metricas e tracing devem ser consumidos como abstracoes.

Motivacao:

- facilitar teste, manutencao e substituicao de adaptadores.

Necessidade de implementar:

- sem portas, a arquitetura hexagonal vira apenas organizacao de pastas.

Subtarefas:

- definir contrato do repositorio de pessoas;
- definir contrato de observabilidade;
- definir contrato de clock ou geracao de timestamps, se necessario;
- definir contrato de id generator, se necessario.

Decisoes fechadas nesta fase:

- portas de saida: `PersonRepository`, `Logger`, `Metrics`, `Tracer`, `Clock`, `IDGenerator`
- item deletado nao pode ser atualizado
- item com `active=false` pode ser atualizado

## Fase 3 - Modelagem da Persistencia em Tabela Unica

### Tarefa 3.1 - Definir o item da tabela unica

Funcao:

- estabelecer como `Person` sera persistida no DynamoDB.

Contexto:

- a POC pede uma unica tabela com atributos de varios tipos de dados.

Motivo:

- a modelagem fisica precisa estar alinhada aos padroes de acesso reais da API.

Motivacao:

- evitar retrabalho de chave, atributos e indices depois que o repositorio comecar a ser implementado.

Necessidade de implementar:

- sem isso, o time corre o risco de modelar por entidade e nao por acesso.

Subtarefas:

- definir `pk`;
- definir `sk`;
- definir atributo `entity_type`;
- mapear campos simples;
- mapear listas e mapas;
- definir campos de auditoria.

### Tarefa 3.2 - Definir padroes de acesso

Funcao:

- listar exatamente como a tabela sera consultada e modificada.

Contexto:

- DynamoDB exige que a modelagem seja guiada por operacoes concretas.

Motivo:

- o CRUD precisa ser suportado sem improviso na camada de persistencia.

Motivacao:

- reduzir risco de adicionar GSI desnecessario ou chave inadequada.

Necessidade de implementar:

- sem padroes de acesso definidos, a modelagem da tabela unica fica superficial.

Subtarefas:

- definir leitura por `id`;
- definir listagem;
- definir atualizacao;
- definir exclusao;
- decidir se `cpf` exige acesso dedicado;
- decidir se a listagem exigira ordenacao ou paginacao.

Decisoes fechadas nesta fase:

- `pk = PERSON#{id}`
- `sk = PROFILE`
- item auxiliar para unicidade de `cpf`
- busca por nome por prefixo

### Tarefa 3.3 - Definir estrategia de consistencia e auditoria

Funcao:

- orientar comportamento tecnico das operacoes de persistencia.

Contexto:

- mesmo em POC, conflitos, timestamps e rastreabilidade precisam ser tratados.

Motivo:

- create e update podem depender de controles de unicidade e versao logica.

Motivacao:

- preparar o servico para observabilidade e diagnostico de problemas desde o inicio.

Necessidade de implementar:

- sem essa tarefa, o repositorio pode nascer tecnicamente funcional, mas operacionalmente cego.

Subtarefas:

- definir como registrar `created_at` e `updated_at`;
- definir comportamento para item inexistente;
- definir comportamento para conflito;
- definir o minimo de informacao de auditoria persistida ou logada.

## Fase 4 - Observabilidade Transversal

### Tarefa 4.1 - Definir padrao de logs estruturados

Funcao:

- estabelecer um formato unico para logs do servico.

Contexto:

- o usuario definiu que todas as partes e operacoes devem possuir logs visiveis no CloudWatch e/ou Datadog.

Motivo:

- sem padrao unico, os logs perdem valor diagnostico e nao se correlacionam bem.

Motivacao:

- acelerar troubleshooting e leitura operacional da POC.

Necessidade de implementar:

- tarefa obrigatoria para toda a cadeia de API, dominio, repositorio e bootstrap.

Subtarefas:

- definir campos obrigatorios do log;
- definir niveis de log;
- definir `correlation_id`;
- definir `operation`, `layer`, `outcome` e `duration_ms`;
- definir regras para nao logar dados sensiveis.

### Tarefa 4.2 - Definir eventos de log por camada

Funcao:

- especificar onde e quando logar dentro do fluxo.

Contexto:

- o servico tera adaptadores de entrada, casos de uso e repositorio, e todos precisam participar da rastreabilidade.

Motivo:

- a simples existencia de um logger nao garante cobertura operacional suficiente.

Motivacao:

- permitir leitura ponta a ponta de uma requisicao individual.

Necessidade de implementar:

- sem esta tarefa, a equipe tende a logar apenas erro final e perder contexto intermediario.

Subtarefas:

- definir logs no recebimento da requisicao;
- definir logs de validacao;
- definir logs no inicio e fim de cada caso de uso;
- definir logs no repositorio;
- definir logs de erro com classificacao adequada.

### Tarefa 4.3 - Definir metricas, traces e dashboards

Funcao:

- transformar comportamento tecnico em sinais observaveis.

Contexto:

- CloudWatch e Datadog serao usados como base de observabilidade complementar.

Motivo:

- logs sozinhos nao bastam para leitura rapida de saude e tendencia.

Motivacao:

- permitir que a POC seja avaliada tambem do ponto de vista operacional.

Necessidade de implementar:

- sem metricas e dashboards, o servico fica mais dificil de analisar sob carga, falha ou degradacao.

Subtarefas:

- definir metricas por endpoint;
- definir metricas por operacao de CRUD;
- definir tracing da requisicao;
- definir dashboards minimos;
- definir alertas basicos.

Decisoes fechadas nesta fase:

- logs com `timestamp`, `level`, `message`, `service`, `environment`, `correlation_id`, `operation`, `layer`, `outcome`, `duration_ms`, `person_id` e `error_code`
- CPF sempre mascarado
- 1 trace por requisicao HTTP

## Fase 5 - Infraestrutura AWS e Terraform

### Tarefa 5.1 - Definir estrutura Terraform

Funcao:

- organizar como a infraestrutura sera descrita e mantida.

Contexto:

- a POC depende de API Gateway, Lambda, DynamoDB, IAM e observabilidade.

Motivo:

- a infraestrutura precisa ser reproduzivel e legivel para o time.

Motivacao:

- reduzir configuracao manual e facilitar evolucao do servico.

Necessidade de implementar:

- sem estrutura clara, o Terraform tende a virar um bloco unico dificil de manter.

Subtarefas:

- definir pasta `modules`;
- definir pasta `envs`;
- definir convencoes de variaveis;
- definir convencoes de outputs;
- definir estrategia de estado remoto.

### Tarefa 5.2 - Definir recursos minimos da POC

Funcao:

- fechar a lista exata de componentes AWS que suportarao o servico.

Contexto:

- a POC precisa de runtime, exposicao HTTP, persistencia e observabilidade.

Motivo:

- o desenho precisa refletir o caso de uso real do CRUD.

Motivacao:

- evitar provisionamento excessivo ou lacunas de runtime e monitoramento.

Necessidade de implementar:

- sem esta definicao, o time pode provisionar recursos desconectados do fluxo principal.

Subtarefas:

- definir API Gateway;
- definir Lambda;
- definir DynamoDB;
- definir IAM;
- definir CloudWatch Logs;
- definir parametros ou segredos necessarios;
- definir integracao com Datadog.

Decisoes fechadas nesta fase:

- `HTTP API`
- `1 Lambda por operacao`
- `person-service`
- prefixo `poc-person-dev`
- `us-east-1`
- `Parameter Store`

### Tarefa 5.3 - Definir seguranca minima da infraestrutura

Funcao:

- garantir baseline operacional aceitavel para a POC.

Contexto:

- mesmo um servico simples pode expor dados pessoais e configuracoes sensiveis.

Motivo:

- o cadastro de pessoas exige atencao basica a protecao de dados e acesso.

Motivacao:

- evitar que a POC valide apenas funcionalidade, ignorando controles minimos.

Necessidade de implementar:

- sem isso, a POC pode nascer com IAM excessivo, segredos expostos ou logs inadequados.

Subtarefas:

- definir privilegios minimos;
- definir tratamento de segredos;
- definir politica para dados pessoais em logs;
- definir tags e ownership dos recursos.

## Fase 6 - Estrategia de Implementacao do Codigo

### Tarefa 6.1 - Definir ordem de implementacao interna

Funcao:

- estabelecer a sequencia em que o codigo sera construido quando a fase de implementacao comecar.

Contexto:

- o projeto nao deve comecar por handlers ou Terraform isoladamente.

Motivo:

- a ordem certa reduz acoplamento e ajuda a validar a arquitetura durante a construcao.

Motivacao:

- manter velocidade com coerencia tecnica.

Necessidade de implementar:

- sem uma ordem clara, a equipe tende a construir pela borda e remendar o dominio depois.

Subtarefas:

- implementar primeiro dominio e casos de uso;
- implementar depois portas;
- implementar depois adaptadores;
- integrar observabilidade desde a primeira operacao;
- integrar infraestrutura de forma incremental.

### Tarefa 6.2 - Definir fatias verticais de entrega

Funcao:

- transformar o CRUD em incrementos menores e verificaveis.

Contexto:

- entregar tudo de uma vez dificulta depuracao e mascara falhas de arquitetura.

Motivo:

- cada operacao deve validar uma parte do desenho.

Motivacao:

- aumentar previsibilidade e facilitar demonstracao de progresso.

Necessidade de implementar:

- sem fatias, a POC pode ficar muito tempo sem fluxo fim a fim executavel.

Subtarefas:

- primeira fatia: create person com logs e persistencia;
- segunda fatia: get person com logs e leitura;
- terceira fatia: list people com paginacao basica;
- quarta fatia: update person com rastreabilidade;
- quinta fatia: delete person com confirmacao e logs finais.

Decisoes fechadas nesta fase:

- primeira onda: `create` e `get`
- segunda onda: `list`, `update` e `delete`
- shared core minimo: sim

## Fase 7 - Preparacao para Evolucao

### Tarefa 7.1 - Definir limites da abordagem Lambda

Funcao:

- registrar quando o servico deixaria de ser um bom candidato para runtime serverless puro.

Contexto:

- Kubernetes faz parte da visao futura, mas nao da primeira entrega.

Motivo:

- a POC deve deixar claro em quais cenarios a arquitetura precisaria evoluir.

Motivacao:

- transformar a POC em base de decisao arquitetural futura.

Necessidade de implementar:

- sem essa analise, Kubernetes fica citado apenas como tecnologia adjacente sem criterio tecnico.

Subtarefas:

- definir sinais de limites de Lambda;
- definir cenarios de longa duracao;
- definir cenarios de controle fino de runtime;
- definir implicacoes para observabilidade e deploy.

### Tarefa 7.2 - Documentar proxima etapa de maturidade

Funcao:

- indicar como a POC pode evoluir para um servico mais robusto.

Contexto:

- apos validar CRUD, observabilidade e IaC, o servico pode servir de base para expansao.

Motivo:

- a equipe precisa saber o que ficara fora da POC e qual seria o passo seguinte.

Motivacao:

- evitar que a documentacao termine apenas no MVP tecnico.

Necessidade de implementar:

- sem esse fechamento, o conhecimento produzido pela POC fica incompleto como referencia de plataforma.

Subtarefas:

- listar melhorias de autenticacao;
- listar melhorias de testes;
- listar melhorias de CI/CD;
- listar melhorias de governanca;
- listar criterios para futura trilha Kubernetes.

## Ordem Recomendada das Fases

1. Fase 0 - Fundacao da POC
2. Fase 1 - Definicao do Contrato da API
3. Fase 2 - Modelagem do Dominio e Arquitetura Hexagonal
4. Fase 3 - Modelagem da Persistencia em Tabela Unica
5. Fase 4 - Observabilidade Transversal
6. Fase 5 - Infraestrutura AWS e Terraform
7. Fase 6 - Estrategia de Implementacao do Codigo
8. Fase 7 - Preparacao para Evolucao

## Resultado Esperado

Ao concluir estas fases, o time deve ter:

- um plano coerente de construcao do servico;
- clareza sobre o por que de cada bloco tecnico;
- sequencia segura para iniciar implementacao;
- rastreabilidade entre API, dominio, persistencia, cloud e observabilidade.
