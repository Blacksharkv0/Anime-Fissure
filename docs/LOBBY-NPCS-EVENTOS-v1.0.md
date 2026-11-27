# Anime Fissure — Lobby multiversal: funções, NPCs e Praça de Eventos v1.1

**Data:** 26/11/2026 · **Estado:** protótipos 3D e painéis de consulta publicados no GitHub, ainda sem playtest confirmado em Roblox Studio. Nenhuma evolução, raid, reroll ou evento foi ativado.

## Direção aprovada da arquitetura

O lobby é um ponto de encontro entre universos. Cada NPC terá **uma especialização única**, evitando duplicidade de interfaces.

| Personagem | Papel definitivo | Local | Situação real do código |
|---|---|---|---|
| **Vergil (Virgil no código)** | Summon (e Warp, se esse fluxo vier a ser conectado) | Estação existente à esquerda, x≈233,z≈−2 | Summon protótipo já existente, não alterado |
| **Dante** (*Devil May Cry*) | **Index universal das unidades**: personagens, raridades, mundos e origem, sem posse falsa | Arquivo dos Caçadores, ao lado do Vergil, x247,z−8 | NPC estático + interface de Index com 8 registros oficiais de catálogo; coleção pessoal não conectada |
| **Edward Elric** | Loja/crafting alquímico, orbes e materiais | Oficina existente à direita, x≈301,z≈−8 | Alquimia com crafting bloqueado; NÃO administra relíquias |
| **Gilgamesh** | **TODAS as relíquias**, equipamento, aprimoramento da própria relíquia e reroll de relíquias | Salão da Babilônia, anexo direito, NPC x≈356,z≈20 | Catálogo universal somente leitura |
| **Whis** (*Dragon Ball Super*) | **Evolução de TODOS os personagens**, independentemente de anime ou de material consumido | Santuário da Ascensão, x≈290,z≈33 | NPC estático + painel, sem evolução ativa |
| **Kisuke Urahara** (*Bleach*) | **Traits das unidades**, bônus de Traits e reroll exclusivo de Traits | Laboratório das Aptidões, x≈230,z≈33 | NPC estático + painel, sem reroll ativo |
| **Sung Jinwoo** (*Solo Leveling*) | **Desafios e raids permanentes**, portais, requisitos e equipes | Portão dos Caçadores, x≈281,z≈−30 | NPC estático + painel, sem raids ativas |
| **Anfitrião sazonal** | Acesso ao conteúdo **temporário** do evento do mês (quando existir) | **Praça central**, x≈270,6,z≈8 | Palco rotativo com preview EXCLUSIVO do Studio |

**Story Mode** permanece no Portal das Fissuras em x260,z−38; não passa por Jinwoo nem Escanor. **Jinwoo** apresenta raids/desafios permanentes. O NPC de **evento** apresenta missões/raids do evento sazonal enquanto estiver ativo.

### Distinção crítica: evolução x relíquias x Traits

- Ainz evolui **com Whis**, inclusive se a receita vier a consumir os cinco anéis de Overlord; anéis podem ser visualizados/equipados/geridos por **Gilgamesh**.
- Shalltear, Albedo, unidades futuras de Naruto/JJK/Dragon Ball etc. **evoluem no mesmo local de Whis**.
- Um **anel** é uma relíquia. A relíquia também pode ser material de evolução de unidade. Gilgamesh não executa a evolução da personagem.
- Aprimorar **a própria relíquia** e rerollar **a relíquia** ficam com Gilgamesh; rerollar **Trait da unidade** fica com Urahara.
- A oficina de Edward continua dedicada à **alquimia e orbes**, sem inventário/crafting ativo.
- Os bônus dos cinco anéis em unidades que NÃO sejam Ainz permanecem inalterados.

## A praça central dos eventos

Palco compacto e central **ligeiramente à direita do corredor principal**: centro x270,6,z8, pedestal de 10×10 studs. A faixa x265,6…275,6 preserva o corredor central (termina em x265,25) e evita tocar a oficina de Edward (começa em x276). Alguns ornamentos são não colidentes.

- **Sem evento anunciado**: holograma neutro e placa **PRÓXIMO EVENTO**.
- **Exemplo do criador — Nanatsu/ Escanor**: há uma prévia com NPC estático e letreiro "EXEMPLO • NANATSU • NÃO ATIVO" **somente no Roblox Studio**. Nenhuma raid, tempo mensal, item ou recompensa foi ativado.
- **Com evento real no futuro**: arte, NPC, título e portal de evento serão inseridos por configuração aprovada; validação de data de início/fim e habilitação de conteúdo deve vir de um serviço seguro no servidor. Não ativar automaticamente só porque o calendário chegou a certo mês.
- Depois do evento, NPC e decoração temporários deixam a praça, que continua disponível para a próxima temporada.
- Os jogadores exploram a praça e consultam o painel; tocar em "Raid" sem backend não entra em nenhuma partida.

**Mais exemplos futuros (não aprovados):** personagens de JJK, Naruto e outros animes podem ocupar o espaço; não predefinir calendário real nem drops.

## Estética por estação

### Whis — Santuário da Ascensão
Arquitetura celestial em pérola, azul angelical e lilás; anéis em luz suave, cajado e plataformas circulares. Visual do NPC é **Parts estáticas temporárias**, não um rig animável de Whis.

### Urahara — Laboratório das Aptidões
Oficina verde-negra com chapéu listrado, runas de habilidade e painel para listar Traits. Diferenciar claramente da alquimia vermelha de Edward e da sala dourada de Gilgamesh.

### Jinwoo — Portão dos Caçadores
Arco negro com energia violeta e azul, identidade visual de masmorra. Raid permanente e desafio exigem contrato de stage/party e validação real, sem reutilizar indevidamente a única arena da beta.

### Praça sazonal — Anfitrião rotativo
Halo azul + dourado e espaço livre para NPC/props temáticos. O visual permanente é neutro; a arte do evento só substitui o centro quando houver evento real. Preview do Escanor no Studio usa tons solares sem afirmar que Nanatsu está ativo.

## Experiência do jogador

1. O jogador chega em `LobbySpawn` na praça.
2. O **Portal das Fissuras** oferece a história disponível.
3. À esquerda: Vergil (Summon), **Dante (Index)** e Urahara (Traits).
4. À direita: Edward (Alquimia), Whis (Evolução), Salão da Babilônia/Gilgamesh (Relíquias).
5. Perto do portal: Jinwoo (Desafios e Raids).
6. No centro: a **Praça dos Eventos**, que muda de anfitrião entre temporadas.
7. Toque ou tecla **E** perto do NPC exibe sua interface de consulta. A ativação de funcionalidades incompletas continua bloqueada.

## Código publicado

- `src/shared/LobbyServiceConfig.luau`: mapa/posições, nomes, funções, estado desabilitado; `CurrentEventId=nil`, `DevelopmentEventPreviewId=NANATSU_ESCANOR`.
- `src/server/LobbyServiceBuilder.luau`: 3 estações 3D e o palco central, pilares, partes decorativas, NPCs estáticos e `ProximityPrompt`.
- `src/server/LobbyServiceStations.server.luau`: instancia no `FissureLobby` e valida distância, saúde e lobby antes de `OpenServiceInfo:FireClient`.
- `src/client/LobbyServiceStationsUI.client.luau`: UI responsiva por função, somente leitura e sem botões de evolução, raid, reroll ou recompensas.
- `src/server/LobbyServiceStationsSmokeTest.server.luau`: testa quatro estações, exclusividade, evento inativo, rotas e NPCs pré-existentes.
- `src/client/BetaLobby.client.luau`: guia do lobby atualizado com mentores e praça.
- `src/client/RelicRingGallery.client.luau`: Gilgamesh mostra **APRIMORAR RELÍQUIAS** no lugar de **EVOLUIR PERSONAGENS**.

## Outros pontos possivelmente esquecidos (não construídos nesta entrega)

1. **Coleção / Decks salvos**: possuir, ordenar, travar e selecionar suas seis unidades; importante para conectar Evolução/Traits/Relíquias. O **Index do Dante já existe** como enciclopédia de todas as unidades registradas, mas **não representa posse**.
2. **Missões diárias e semanais**: desafios curtos e recompensas; podem ter um mural separado de Raids.
3. **Recompensas de login, conquistas e códigos**: para retenção, com dados persistentes, controles de abuso e UI clara.
4. **Ranking e progresso**: nível da conta, vitórias, coleção, histórico de raids e títulos; priorizar depois das mecânicas básicas.
5. **Passe de evento**: exclusivo do evento sazonal, se aprovado; não ativar passe/loja ou recompensas sem definição do jogo.

Não multiplicar NPCs sem necessidade: coleção/decks pode entrar no HUD global, missões diárias num mural, ranking numa placa. O lobby deve continuar transitável e legível no mobile.

## Checklist de teste

- [ ] Build GitHub Actions verde e arquivo `.rbxlx` aberto em Studio.
- [ ] Virgil, Edward, Gilgamesh, portal Story e spawn permanecem no lugar.
- [ ] Whis, Urahara, Jinwoo e **Dante** têm pedestais e prompts visíveis no PC/gamepad/mobile.
- [ ] Escanor aparece como **EXEMPLO NÃO ATIVO** apenas no Studio; fora dele, praça neutra.
- [ ] Praça de evento não bloqueia o corredor nem sobrepõe Edward.
- [ ] Cada estação abre um painel informativo, **sem alterações de itens, moedas ou unidades**.
- [ ] As abas do Gilgamesh não oferecem mais evolução de personagens.
- [ ] Output deve mostrar `LOBBY SERVICE NETWORK SMOKE OK`.
- [ ] FPS e colisões conferidos no Device Emulator do Roblox.

**Direitos de terceiros:** Whis, Kisuke Urahara, Sung Jinwoo, Gilgamesh, Edward, Virgil, Escanor e outras referências pertencem a seus respectivos criadores/titulares. Modelos de laboratório não autorizam uso comercial dessas marcas; antes de publicar publicamente, verificar licenças ou trocar por NPCs originais com funções equivalentes.

## Index do Dante — criado em 27/11/2026

**Função diferente de Vergil**: Vergil invoca, Dante mostra **o arquivo de unidades**. Atualmente o Index lê `OverlordUnitRoster.luau` (6 personagens) e `CapsuleUnitConfig.luau` (2 versões), com raridade, universo, método planejado de obtenção e status, sem assumir que o jogador possui qualquer uma delas. Um personagem cadastrado no Index **não está automaticamente disponível no Summon**, especialmente Ainz e Capsule Corp.

**Lugar**: `Vector3.new(247,0,-8)`, aproximadamente ao lado leste do stand do Vergil, no vão entre a borda x237,5 da estação de Summon e a borda x254,75 do corredor central. Planta e colisão final pendentes de playtest.

**Arte**: Dante de *Devil May Cry*, versão estilizada 3D de Parts (protótipo estático), casaco vermelho, cabelos prateados, arma nas costas, núcleo/livro vermelho de registros, ao lado do irmão Vergil. O menu usa vinho/ô-nix/rubi, com filtros Todos, Overlord e Dragon Ball.

**Código**:
- `src/shared/UnitIndexCatalog.luau`: catálogo seguro de unidades de todos os mundos, sem inventário, raridade ou banner inventados.
- `src/shared/LobbyServiceConfig.luau`: quarta estação `Index`, `NPC="Dante"`.
- `src/server/LobbyServiceBuilder.luau`: stand 3D e NPC de Dante no lobby.
- `src/client/DanteUnitIndex.client.luau`: Index somente leitura, acionado por interação validada no servidor.
- `src/client/LobbyServiceStationsUI.client.luau`: não abre a janela genérica quando a interação for com Dante.
- `src/server/DanteUnitIndexSmokeTest.server.luau`: oito unidades e exclusão de posse fictícia, mantendo Jinwoo como responsável pelas raids.
- `src/server/LobbyServiceStationsSmokeTest.server.luau`: verifica **quatro NPCs de serviço + palco de evento**, posição e exclusividade.

**Raids e desafios não foram esquecidos**: **Sung Jinwoo** continua no Portão dos Caçadores, para desafios e raids permanentes. O personagem rotativo da Praça dos Eventos apresenta exclusivamente a raid do seu evento, quando existir.

**Dante** é o sétimo NPC fixo: Vergil, Dante, Edward, Gilgamesh, Whis, Urahara e Jinwoo; além do oitavo **posto sazonal** sem personagem fixo.

**Limitações**: modelos de NPC ainda procedurais/estáticos; Index não demonstra unidade possuída ou descoberta e não concede unidades. O sistema de Coleção/Decks segue futuro e separado.
