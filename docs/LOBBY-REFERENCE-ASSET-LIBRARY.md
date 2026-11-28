# Lobby Reference Project — biblioteca de modelos e benchmark
Data: 27/11/2026. Pesquisa pública de guias e catálogos; não foram extraídos arquivos de experiências alheias. Nenhum asset abaixo foi inserido, inspecionado no Studio ou comprado.
## Referências
- Anime Expeditions: https://allthings.how/anime-expeditions-robloxs-upcoming-anime-tower-defense-game/ — cidade, água, árvores, arquitetura, áreas identificáveis.
- Anime Vanguards: https://allthings.how/anime-vanguards-on-roblox-how-to-get-and-equip-units/ — atalhos de áreas e invocação.
- ASTD X: https://progameguides.com/roblox/all-star-tower-defense-x-mission-npc-locations/ — NPCs junto a marcos arquitetônicos, jardins e fonte.
- Anime Adventures: https://allthings.how/how-to-get-shinobi-awakened/ — painel de unidades na área Summon.
- Anime Defenders: https://animedefenders.fandom.com/wiki/Traits — proximidade entre serviços relacionados.
- TDS: https://tds.wiki/w/Main_Lobby — áreas de descanso, modos, eventos e decoração.
## Candidatos Creator Store
| ID | Pacote | Uso | Estado |
|---|---|---|---|
| 6933438443 | Synty Nature Pack | vegetação, pedras | candidato |
| 6933556508 | Synty City Pack | fachadas, ruas, parques | candidato |
| 6934021345 | Synty Dungeon Pack: Cave & Castle Interiors | arcos, runas, interiores, Babilônia | candidato |
| 6432306802 | Forest Pack (Roblox) | árvores, plantas, pedras | alternativa |
| 6370681139 | City Props Pack (Roblox) | postes, bancos, vasos | alternativa |
| 137359325549586 | PBR Modular Sci-Fi Kit | painéis e arquitetura futurista | avaliar autor, licença, custo e desempenho |
| 119500909260565 | Japanese temple by DAV | santuário japonês | avaliar autor, licença, custo e desempenho |
Links: https://create.roblox.com/store/asset/{ID} (substituir pelo ID).
Alternativas externas: https://quaternius.com/packs/modularscifimegakit (CC0); https://kenney.nl/assets/nature-kit (CC0); https://baziliqgames.itch.io/japanese-town (verificar licença e preço, não redistribuir como asset independente).
## Integração
1. Em arquivo separado Baseplate, no modo Edit, adquirir os pacotes autorizados pelo proprietário via Toolbox/Creator Store. Nunca baixar mapa extraído de jogo protegido.
2. Inspecionar árvore de objetos, remover scripts, módulos, remotes, prompts e outros elementos que não sejam arte. Verificar dependências de malhas e texturas e permissões do jogo final. Selecionar apenas peças úteis, não importar pacote inteiro para o lobby.
3. Criar biblioteca de modelos estáticos com pivôs coerentes, nomes descritivos e escala em studs; registrar autor, URL, licença, data, versão, triângulos, partes, dependências, uso e teste.
4. Exportar seleção como .rbxmx ou .rbxm para avaliação e integração Rojo. Não usar require(assetId), carregamento remoto em produção ou scripts de terceiros.
5. Substituir exclusivamente arte decorativa por setor, mantendo IDs, remotes, prompts, piso e rotas funcionais. Não alterar economia, progressão, eventos ou combate.
6. Medir FPS/memória PC e mobile e verificar carregamento, colisão e luz. NPCs com visual de anime exigem modelos próprios ou autorização de direitos correspondente.
Fontes de segurança: https://create.roblox.com/docs/production/creator-store ; https://github.com/Roblox/creator-docs/blob/main/content/en-us/scripting/security/third-party-vulnerabilities.md
## Ordem proposta
A: natureza Synty; B: arquitetura Synty City/Dungeon; C: identidade sci-fi (somente se compatível); D: testar um distrito inteiro (Vergil + Dante); E: expandir após aprovação visual. Preservar versão 0.3.5 como base. Não incluir candidatos sem aprovação de licença e revisão.

## Fissure City Reborn 0.3.6 — primeiro estágio implementado
- Biblioteca ServerStorage/LobbyAssetLibrary mapeada via Rojo em assets/lobby. Ainda vazia, sem modelos externos efetivamente importados.
- Slots GardenTree (12 cópias, até 3 BaseParts cada) e SakuraTree (16 cópias, até 8 BaseParts cada), pelo menos uma malha. Escala e pivô normalizados e colisão desativada. Na falta de modelo aprovado, continua o cenário procedural.
- Para importar: abrir Baseplate separado em modo Edit; Toolbox > Creator Store > Synty Nature Pack (6933438443); selecionar individualmente uma árvore com as permissões adequadas. Executar tools/StudioAssetIntake.luau na Command Bar depois de preencher SLOT, SOURCE, CREATOR, LICENSE e confirmar direitos. Conferir visual e malhas/texturas no Studio; exportar a seleção preparada como GardenTree.rbxmx ou SakuraTree.rbxmx e entregar para integração em assets/lobby. Não executar Play com pacote bruto.
- Não confundir validação estrutural com garantia de segurança, licença ou desempenho; testar aparência e permissões em experiência de teste. Exportar apenas se a licença permite armazenar/compartilhar no repositório; caso contrário manter importação na experiência autorizada. Não publicar modelos de personagens sem direitos.
- Próxima fase: piloto arquitetônico Vergil + Dante após receber modelos revisados. Não substituir fachadas por assets ainda não escolhidos ou disponíveis.
