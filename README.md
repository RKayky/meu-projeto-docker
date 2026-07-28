# Projeto Docker e CI/CD - To-Do App

Este repositório contém a conteinerização de uma aplicação To-Do (Node.js) e seu banco de dados (MySQL), juntamente com a configuração de um pipeline de Integração Contínua (CI) utilizando o GitHub Actions.

## 🚀 Tecnologias Utilizadas
* **Docker:** Criação da imagem da aplicação via `Dockerfile`.
* **Docker Compose:** Orquestração dos serviços (`app` e `db`), redes e volumes.
* **GitHub Actions:** Pipeline automatizado para validação do Compose, build, deploy temporário e smoke test (CRUD).
* **Node.js & MySQL:** Stack da aplicação.

## 🛠️ Como Executar o Projeto Localmente

1. Clone este repositório:
   ```bash
   git clone [https://github.com/RKayky/meu-projeto-docker.git](https://github.com/RKayky/meu-projeto-docker.git)
   cd meu-projeto-docker
