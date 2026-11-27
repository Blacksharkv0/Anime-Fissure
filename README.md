# Anime Fissure — Monster Demo

Tower Defense cooperativo de anime para Roblox, com interface Anime Arcade (PC e mobile).

## Abrir a demo

1. Abra [Build Beta](https://github.com/Blacksharkv0/Anime-Fissure/actions/workflows/build-beta.yml).
2. Escolha a execução bem-sucedida mais recente da branch `main` e confirme o commit correspondente. Se a última alteração ainda estiver compilando, não confunda uma execução antiga com a versão nova.
3. Baixe o artifact **AnimeFissure-Beta**, extraia o arquivo `AnimeFissure-Beta.rbxlx` e abra no Roblox Studio.
4. Aperte Play e use **DIAGNÓSTICO DO LOBBY**. Siga o [roteiro de testes da Monster Demo](docs/DEMO-MONSTRA-QOL-27-11-2026.md).

## O que testar

- Lobby: Vergil (Summon), Dante (Index), Edward (Alquimia), Gilgamesh (Relíquias), Whis (Evolução), Kisuke Urahara (Traits) e Sung Jinwoo (Desafios/Raids).
- Praça de eventos e Salão da Babilônia; modelos procedurais, catálogo e efeitos locais.
- Story: Overlord → Carne Village, Classic/Hard; posicionamento, melhorias, venda confirmada e informações da fase.
- PC e mobile: navegação de NPCs, qualidade de FX, atalhos, posicionamento por toque e tela de resultado.
- Pós-partida: retorno manual ou automático após 30 segundos; se o retorno não concluir, o painel permite tentar novamente. A beta aceita uma partida por sessão Play.

## Escopo real

Esta é uma demo, não uma versão pública final. Evolução, reroll, crafting e raids ainda são informativos; os sistemas persistentes e drops planejados não devem ser confundidos com funcionalidades liberadas. Os modelos são protótipos procedurais. O build Rojo verifica o empacotamento, mas não substitui o teste no Roblox Studio.

## Compilar localmente

Com Rojo 7.5.1 instalado, execute na raiz:

```sh
rojo build default.project.json --output AnimeFissure-Beta.rbxlx
```

Consulte o Output no Studio para os diagnósticos e erros de execução.
