# EcoQuest

> Recicle. Aprenda. Salve o planeta.

Projeto Integrador — UNIVAG 2026

---

## ⬇️ Download do APK

### APK mais recente (pronto para instalar)

**[👉 Clique aqui para baixar o APK](https://github.com/JezerRch/Eco-quest/releases/latest)**

> O APK executável fica na aba **[Releases](https://github.com/JezerRch/Eco-quest/releases)** do repositório — sempre a versão mais recente no topo.

**Importante:** compartilhe o APK via **Google Drive ou OneDrive**. Enviar pelo WhatsApp ou Telegram pode corromper o arquivo e causar erro de instalação.

---

## Localização do APK gerado localmente

Se você clonou o repositório e gerou o APK manualmente via `flutter build apk --release`, o arquivo estará em:

```
build/app/outputs/flutter-apk/app-release.apk
```

---

## Como gerar um novo APK (via GitHub Actions)

1. Acesse a aba **[Actions](https://github.com/JezerRch/Eco-quest/actions)** do repositório
2. Selecione o workflow **EcoQuest — Publicar APK**
3. Clique em **Run workflow**
4. Preencha a versão (ex: `1.2.0`) e a descrição
5. Aguarde o build finalizar
6. O APK estará disponível em **[Releases](https://github.com/JezerRch/Eco-quest/releases)**

---

## Como gerar o APK localmente

```bash
git clone https://github.com/JezerRch/Eco-quest.git
cd Eco-quest
flutter pub get
flutter build apk --release
```

O APK ficará em `build/app/outputs/flutter-apk/app-release.apk`.

---

## Funcionalidades

- 7 fases temáticas: Praia, Floresta, Cidade, Escola, Rio, Usina e Reserva
- Mecânica de arrastar ou tocar para classificar resíduos
- Cronômetro por questão com barra de tempo visual
- Sistema de vidas e conquistas
- Ranking global de jogadores
- Loja de temas visuais
- Firebase Firestore para dados em tempo real

---

## Tecnologias

- Flutter (Dart)
- Firebase Core + Cloud Firestore
- SharedPreferences
- GitHub Actions (CI/CD)
