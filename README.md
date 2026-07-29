# Atividade Docker + CI — Ryan Kayky Marques Rolins Bastos

Atividade prática do **Módulo 11 — DevOps e Cloud Computing** da Capacitação em Desenvolvimento Full Stack (iTeam), abordando containerização com Docker, orquestração com Docker Compose e Integração Contínua utilizando GitHub Actions.

**Aluno:** Ryan Kayky Marques Rolins Bastos  
**Turma:** Noturno  
**Data:** 28/07/2026  
**Aplicação utilizada:** `docker/getting-started-app` (To-Do em Node.js)

---

# 1. Como executar o projeto

## Pré-requisitos

- Docker Desktop (Windows/macOS) ou Docker Engine (Linux)
- Docker Compose v2

Clone o repositório:

```bash
git clone https://github.com/RKayky/meu-projeto-docker.git
cd getting-started-docker
```

Crie o arquivo de variáveis de ambiente:

```bash
cp .env.example .env
```

Suba toda a aplicação:

```bash
docker compose up -d --build
```

O Docker irá:

- construir a imagem da aplicação;
- iniciar o container da aplicação;
- iniciar o container do banco MySQL;
- criar automaticamente a rede Docker;
- criar automaticamente o volume de persistência.

É possível acompanhar o status dos containers com:

```bash
docker compose ps
```

Aguarde até que o serviço **db** esteja com status **healthy**.

Depois, acesse:

```
http://localhost:3000
```

A aplicação permitirá:

- criar tarefas;
- marcar tarefas como concluídas;
- excluir tarefas.

Todos os dados ficam armazenados no banco MySQL através do volume nomeado.

Para parar a aplicação:

```bash
docker compose down
```

Para remover também os dados persistidos:

```bash
docker compose down -v
```

---

# 2. Dockerfile Multi-stage

## Imagem utilizada

(https://github.com/RKayky/meu-projeto-docker/blob/main/Prints/print01.png)

node:20-alpine
```

## Estágios

O Dockerfile foi dividido em dois estágios:

### Builder

Neste estágio são instaladas todas as dependências da aplicação utilizando:

```bash
npm ci --omit=dev
```

Após isso, somente os arquivos necessários são copiados para a imagem final.

### Estágio Final

A imagem final contém apenas:

- código-fonte;
- dependências necessárias;
- usuário não-root (`node`).

Nenhuma ferramenta de compilação ou cache do npm permanece na imagem.

## Usuário

A aplicação é executada utilizando o usuário:

```
node
```

Isso reduz riscos de segurança por impedir que o container seja executado como root.

## Tamanho da imagem

A imagem final possui aproximadamente:

```
58 MB
```

### Vantagens do Multi-stage

- imagem menor;
- menos vulnerabilidades;
- download mais rápido;
- menor consumo de armazenamento;
- menor superfície de ataque.

### Print 1

**docker build + docker images**

```
docs/imagens/print1.png
```

### Print 2

**Aplicação em execução**

```
docs/imagens/print2.png
```

---

# 3. Volumes e Persistência

Durante os testes foram utilizados dois cenários.

## Sem volume

Quando o container era removido, todos os dados eram perdidos.

## Com volume

Foi utilizado um volume nomeado.

Container individual:

```
todo-db
```

Docker Compose:

```
todo-mysql-data
```

Nesse caso, os dados permaneceram mesmo após recriar os containers.

## Diferença entre os comandos

### docker compose down

- remove containers;
- remove redes;
- mantém os volumes.

Os dados continuam armazenados.

### docker compose down -v

- remove containers;
- remove redes;
- remove volumes.

Todos os dados são apagados.

### Print 3

Sem volume

```
docs/imagens/print3.png
```

### Print 4

Com volume

```
docs/imagens/print4.png
```

---

# 4. Rede Docker

Foi criada uma rede nomeada:

```
todo-net
```

Nela estão conectados:

- app
- db

O banco MySQL não possui porta publicada para o host.

Somente a aplicação possui acesso ao banco através da rede interna do Docker.

Dessa forma:

- aumenta a segurança;
- evita acesso externo ao banco;
- reduz superfície de ataque.

## Resolução de nomes

Os containers conseguem se comunicar utilizando apenas seus nomes.

Exemplo:

```
mysql
```

ou

```
db
```

Isso ocorre porque o Docker mantém um DNS interno responsável por traduzir o nome do container para seu endereço IP.

### Print 5

```
docs/imagens/print5-1.png
docs/imagens/print5-2.png
```

### Print 6

Consulta realizada no banco:

```sql
SELECT * FROM todo_items;
```

Imagem:

```
docs/imagens/print6.png
```

---

# 5. Docker Compose

O arquivo `compose.yaml` é responsável por iniciar toda a aplicação.

## Serviços

- app
- db

## Rede

```
todo-net
```

## Volume

```
todo-mysql-data
```

## Healthcheck

Foi configurado no serviço do MySQL utilizando:

```
mysqladmin ping
```

## depends_on

O serviço da aplicação somente inicia após o banco ficar saudável:

```yaml
condition: service_healthy
```

## Variáveis de ambiente

As informações sensíveis são armazenadas em:

```
.env
```

Esse arquivo não é versionado.

Foi disponibilizado um modelo:

```
.env.example
```

### Print 7

```
docs/imagens/print7.png
```

---

# 6. Integração Contínua (GitHub Actions)

Workflow localizado em:

```
.github/workflows/ci.yml
```

## Gatilhos

- push
- pull_request

## Etapas executadas

1. valida o compose;
2. realiza o build da imagem;
3. inicia a aplicação;
4. aguarda a aplicação responder;
5. executa um smoke test;
6. remove toda a infraestrutura.

O smoke test verifica se a API consegue criar uma tarefa corretamente.

Mesmo que algum passo falhe, o workflow executa:

```bash
docker compose down -v
```

para limpar o ambiente.

### Print 8

```
docs/imagens/print8.png
```

---

# 7. Quebra proposital do CI

Para demonstrar o funcionamento da Integração Contínua, foi realizada uma alteração proposital no Dockerfile.

Foi alterado:

```dockerfile
CMD ["node", "src/index.js"]
```

para

```dockerfile
CMD ["node", "src/indexx.js"]
```

Como esse arquivo não existe, o container encerrava imediatamente após iniciar.

O erro apresentado foi:

```
Error: Cannot find module '/app/src/indexx.js'
```

O build da imagem foi concluído normalmente, porém o workflow falhou na etapa responsável por aguardar a aplicação responder.

Após identificar o erro através dos logs do GitHub Actions, o caminho correto foi restaurado para:

```dockerfile
CMD ["node", "src/index.js"]
```

e um novo commit corrigiu o problema.

## Pull Request

Substitua abaixo pelo link do seu Pull Request:

```
https://github.com/RKayky/meu-projeto-docker/pull/1
```

### Print 9

```
docs/imagens/print9.png
```

---

# 8. Dificuldades encontradas

## Execução como usuário não-root

Ao executar a aplicação utilizando o usuário `node`, ocorreu um erro de permissão (`EACCES`) porque a aplicação precisava escrever no diretório utilizado para armazenamento.

A solução foi criar o diretório e ajustar sua propriedade antes da troca para o usuário não-root.

---

## Diferença entre container e Docker Compose

Durante os testes houve confusão entre containers iniciados manualmente (`docker run`) e containers criados pelo Docker Compose.

Isso mostrou que ambos utilizam imagens semelhantes, porém possuem nomes e gerenciamento diferentes.

---

## Persistência de volumes

Ao reutilizar um volume nomeado, tarefas antigas continuavam aparecendo.

Foi possível compreender que volumes nomeados permanecem no sistema até serem removidos explicitamente.

---

## Falha inesperada no CI

Mesmo após modificar apenas arquivos de documentação, o pipeline apresentou falha.

Após analisar os logs, foi identificado que a dependência nativa `sqlite3` estava sendo recompilada devido à indisponibilidade do binário pré-compilado.

Esse problema reforçou a importância da análise dos logs antes de assumir que o erro foi causado pela última alteração realizada.

---

# 9. Checklist

- [x] Dockerfile Multi-stage
- [x] `.dockerignore`
- [x] Execução sem usuário root
- [x] Volume nomeado com persistência
- [x] Rede Docker nomeada
- [x] Banco não exposto ao host
- [x] Docker Compose funcionando
- [x] `.env` ignorado pelo Git
- [x] `.env.example` versionado
- [x] GitHub Actions funcionando
- [x] Pull Request com quebra proposital documentado
- [x] Todos os prints adicionados ao README

---

## Autor

**Ryan Kayky Marques Rolins Bastos**

Capacitação em Desenvolvimento Full Stack — iTeam

Módulo 11 — DevOps e Cloud Computing

2026
