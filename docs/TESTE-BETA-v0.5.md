# Anime Fissure — Checklist da Beta v0.5

**Status:** alterações enviadas à branch `main`; testes dentro do Roblox Studio ainda pendentes.

## O que mudou

- `src/client/NPCDialogue.client.luau`: nova janela de conversa responsiva para Virgil e Edward.
- `src/server/NPCResidents.server.luau`: `E` / toque / controle abre o diálogo, e só uma escolha válida, recente e próxima ao NPC abre o sistema existente.
- O backend do Summon, Tickets, inventário e as regras de alquimia **não foram alterados**.

## Como abrir a beta

1. Abra o repositório `Blacksharkv0/Anime-Fissure`.
2. Em **Actions → Anime Fissure - Build Beta**, escolha a execução mais recente da branch `main`.
3. **Se a execução estiver verde**, baixe o artefato `AnimeFissure-Beta` e extraia `AnimeFissure-Beta.rbxlx`.
4. Abra o arquivo no Roblox Studio e clique em **Play**. Não use o arquivo v0.4 antigo para verificar a v0.5.

## Teste rápido no PC

- [ ] Virgil aparece à esquerda, em local acessível.
- [ ] Ao usar `E` no Virgil, aparece a conversa de Virgil, não o HUD diretamente.
- [ ] `AGORA NÃO` e `X` fecham a conversa sem tirar Tickets.
- [ ] `ABRIR SUMMON` abre o sistema de invocação existente.
- [ ] Em Studio, o saldo de teste começa com **25 Tickets**; após um summon válido cai pelo custo do banner.
- [ ] A revelação da unidade funciona e o resultado aparece na coleção do Summon.
- [ ] Edward aparece em frente à bancada, em local acessível.
- [ ] Ao usar `E` no Edward, aparece a conversa do alquimista.
- [ ] `EXPLORAR OFICINA` abre a oficina com o Index de relíquias.
- [ ] A oficina **não** permite transmutação sem backend de materiais.
- [ ] Distanciar-se do NPC antes de clicar no botão de ação não abre o sistema.
- [ ] Entrar na arena fecha a conversa e impede interação.

## Teste mobile/controle

- [ ] O prompt permite tocar no NPC.
- [ ] A janela cabe na tela sem cortar botões.
- [ ] Os botões de conversa funcionam por toque.
- [ ] No controle, o botão indicado no prompt abre a conversa; **B** tenta fechar a janela.

## Se algo falhar

Anote **qual NPC**, a **etapa do clique**, e envie uma imagem da tela e das mensagens em **View → Output** no Roblox Studio.

> Observação: um build concluído no GitHub não substitui teste funcional no Roblox Studio.
