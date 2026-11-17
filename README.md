# Não Pode

Jogo de festa para celular: o seu time precisa adivinhar a palavra da carta, e você não pode falar as cinco palavras proibidas.

As cartas tratam de temas sociais atuais. Assim, o grupo conversa sobre esses temas enquanto joga.

Projeto prático da disciplina de Desenvolvimento de Software.

## Tema e problema social

Temas como reciclagem, saúde mental, SUS, acessibilidade e direitos humanos aparecem pouco nas conversas do dia a dia. O jogo leva esses temas para um momento de lazer: para explicar uma palavra sem usar as proibidas, o jogador precisa entender o conceito.

São 3 baralhos, com 72 cartas cada:

| Baralho | Exemplos de cartas |
|---|---|
| Sustentabilidade e mobilidade | Reciclagem, Pegada de carbono, Ciclovia, Saneamento básico |
| Saúde | Vacina, SUS, Saúde mental, Primeiros socorros |
| Cidadania e inclusão | Acessibilidade, Libras, Fake news, Direitos humanos |

## Como jogar

1. Dois times jogam em turnos. Quem explica segura o celular.
2. Explique a palavra da carta sem falar as palavras proibidas.
3. Arraste a carta:
   - **para a direita**: o time acertou, +1 ponto;
   - **para a esquerda**: alguém falou uma proibida, -1 ponto;
   - **para cima ou para baixo**: pula a carta, sem pontos. O número de pulos por turno é limitado.

   Os botões Acertou, Errou e Pular fazem o mesmo.
4. Quando o tempo acaba, o turno passa para o outro time.
5. Depois das rodadas, o time com mais pontos vence.

## Funcionalidades

- **Cadastro e login** com email e senha (Firebase Authentication), com validação dos campos e mensagens de erro (por exemplo, email já usado, senha fraca, sem conexão).
- **Tela inicial**, com acesso a Jogar, Como jogar, Perfil e Configurações.
- **Partida**: nomes dos times, tempo por turno, número de rodadas e pulos por turno.
- **Turno**: barra de tempo, carta com as proibidas, gestos de arrastar, sons, vibração e aviso de acerto.
- **Resumo do turno** e **placar**, com o vencedor no fim da partida.
- **Perfil**: mostra nome e email e permite editar o nome.
- **Configurações**: tema (Sistema, Claro ou Escuro), baralho da partida e saída da conta (logout).
- **Como jogar**: tutorial com as regras.
- **Identidade**: nome "Não Pode", ícone próprio e o mascote Psiu, um balão de fala com boca de zíper.

Limite conhecido: o tema e o baralho escolhidos voltam ao padrão quando o app fecha.

## Tecnologias

- Flutter (testado com 3.47.2) e Dart (SDK `^3.13.2`)
- [Firebase Authentication](https://firebase.google.com/docs/auth/flutter/start) (`firebase_core`, `firebase_auth`)
- [`flutter_animate`](https://pub.dev/packages/flutter_animate): animações
- [`audioplayers`](https://pub.dev/packages/audioplayers): efeitos sonoros

## Como executar

Pré-requisitos: Flutter instalado e um aparelho Android ou um emulador.

```sh
git clone git@github.com:mcoldibelli/nao-pode.git
cd nao-pode
flutter pub get
flutter run
```

A configuração do Firebase já está no repositório (`lib/firebase_options.dart` e `android/app/google-services.json`). Não é preciso configurar nada para rodar. O login precisa de internet.

### Gerar o APK

```sh
flutter build apk --release
```

O arquivo fica em `build/app/outputs/flutter-apk/app-release.apk`.

O build de release usa a chave de debug (`android/app/build.gradle.kts`). Isso serve para instalar e avaliar o app, mas não para publicar na Play Store.

### Testes

```sh
flutter test
```

O teste `test/jogo_test.dart` escolhe um baralho, joga uma partida inteira e confere o vencedor, no tema claro e no escuro.

## Estrutura do código

```
lib/
├── main.dart          # inicia o Firebase, o tema e escolhe login ou tela inicial
├── domain/            # regras do jogo, sem telas: Partida, Time, Carta, Baralho, Resultado
├── data/              # baralhos (cartas) e chamadas ao Firebase Authentication
└── ui/                # telas e componentes visuais
    ├── estilo.dart    # cores, tema claro/escuro, botão e cartão do app
    ├── psiu.dart      # mascote, desenhado com CustomPainter
    ├── carta_arrastavel.dart  # carta com os gestos de arrastar
    ├── sons.dart      # efeitos sonoros
    └── tela_*.dart    # uma tela por arquivo
assets/
├── fonts/             # Fredoka e Nunito (licença OFL)
└── sons/              # efeitos sonoros em WAV
```

## Créditos

- Fontes [Fredoka](https://fonts.google.com/specimen/Fredoka) e [Nunito](https://fonts.google.com/specimen/Nunito), sob a SIL Open Font License. As licenças estão em `assets/fonts/`.
- Os efeitos sonoros foram gerados por um script próprio (ondas senoidais e ruído). Não usam material de terceiros.
