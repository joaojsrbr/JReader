<p align="center">
  <img alt="GitHub language count" src="https://img.shields.io/github/languages/count/AlexBorgesDev/anr.svg" />
  <img alt="GitHub top language" src="https://img.shields.io/github/languages/top/AlexBorgesDev/anr.svg" />
  <img alt="Package License" src="https://img.shields.io/github/license/AlexBorgesDev/anr.svg" />
</p>

# com_joaojsrbr_reader

com_joaojsrbr_reader é uma aplicação mobile feita com Flutter. Onde você pode encontrar e ler mangás, manhwa, manhua, novels e webtoons, tendo seu histórico de leitura e favoritos salvos na nuvem, através do Firebase.

> Aplicativo não testado em sistemas IOS.

## Funcionalidades

- Contas Individuais - Google
- Leitura
- Pesquisa
- Favoritos
- Capítulos lidos
- Leitura offline - Download de capítulos

## Livros

Nenhum dos livros encontrados estão armazenados em servidor próprio. Todos eles são obtidos de diversos sites através de **web scraping**.

## Screenshots

<p>
  <img width="24.5%" src="./.github/Screenshot_20220617-103218.png" />
  <img width="24.5%" src="./.github/Screenshot_20220617-103236.png" />
  <img width="24.5%" src="./.github/Screenshot_20220617-103256.png" />
  <img width="24.5%" src="./.github/Screenshot_20220617-104201.png" />
</p>

## Instalação

Clone o projeto

```bash
git clone https://github.com/AlexBorgesDev/com_joaojsrbr_reader.git
```

Vá para o diretório do projeto

```bash
cd com_joaojsrbr_reader
```

Instale as dependências

```bash
flutter pub get
```

Este aplicativo utiliza o **Firebase**. Para configura-lo, é so seguir os passos da [documentação oficial](https://firebase.google.com/docs/flutter/setup?hl=pt-br&platform=android).

Apos configurar o firebase, é so rodar o app com o comando

```bash
flutter run --multidex
```

## Licença

[MIT](./LICENSE)
