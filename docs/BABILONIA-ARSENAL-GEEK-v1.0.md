# Anime Fissure — Salão da Babilônia | Arsenal Geek v1.0

**Data:** 26/11/2026. **Status:** primeira versão 3D procedural publicada no GitHub; Roblox Studio e build real ainda não executados/confirmados nesta sessão.

## Objetivo artístico

O Salão da Babilônia deve parecer o lugar onde **milhares de tesouros de diferentes universos** poderiam existir. A primeira versão já apresenta **11 portais dourados** em semicírculo vertical atrás de um Gilgamesh de laboratório estático, mais **cinco vitrines de anéis** e arquitetura própria.

O foco é a **sensação de escala**, não usar meshes externas. Cada portal é uma moldura dourada com três camadas geométricas luminosas, um disco translúcido, arma estilizada e detalhe de cor. Toda geometria é feita com Parts originais.

## 11 armas e suas referências culturais

**No jogo, os nomes e modelos são composições originais, sem logotipos ou cópias 1:1.** A referência geek abaixo serve apenas de orientação de arte para formas reconhecíveis.

| Estilo interno | Aparência implantada | Homenagem de linguagem visual |
|---|---|---|
| HeroBlade | Espada esmeralda/prateada com guarda dourada | Lâminas heroicas como Master Sword — Zelda |
| TitanGreatblade | Espadão retangular enorme, industrial | Buster Sword — Final Fantasy VII |
| KeyScepter | Arma alongada com dentes de chave | Keyblade — Kingdom Hearts |
| StarSabre | Feixe de plasma azul e cabo tecnológico | Sabres de luz — Star Wars |
| MoonGreatsword | Espada de cristal azul e núcleo luminoso | Espadas lunares — Dark Souls / Elden Ring |
| OniKatana | Katana fina com brilho carmesim | Nichirin e outras katanas icônicas de animes |
| FrostAxe | Machado largo com energia gelada | Leviathan Axe — God of War |
| CursedGreatblade | Espadão escuro com espinhos e alma violeta | Frostmourne — Warcraft |
| CelestialSpear | Lança longa com pontas douradas | Lanças divinas da mitologia e fantasia |
| RuneStaff | Cajado com cristal e dentes místicos | Cajados de grandes magos de RPG |
| DualHookBlades | Duas lâminas curvas presas por conceito a correntes | Armas duplas de caçadores de demônios |

**Nota de direitos:** as franquias citadas pertencem aos respectivos titulares; são referências para a direção artística, não assets licenciados. Para lançamento público, evitar réplicas identificáveis sem autorização, ou substituir por designs autorais totalmente distintos.

## Geometria e mapa

O salão foi **transferido para um anexo** da praça atual porque a área direita original já abriga Edward e a Oficina de Alquimia.

- Centro do anexo: X347, Z19. 
- Ponte do lobby original até o anexo: perto de X318, Z20.
- Rei dos Tesouros / mestre do catálogo: X356, Z20, olhando para a entrada.
- Portais em X374, Y12–24, com diferentes posições Z, atrás do NPC.
- Cinco vitrines com os modelos completos: Magic Power, físico, SPA, Range e Restrição.
- Decorações de mármore/ônix, colunas, piso quadriculado, inscrições douradas e rubis.
- Apenas piso, paredes e bases necessárias colidem; as armas e os portais não bloqueiam o jogador.

## Animação e interação

- `BabylonHallVFX.client.luau`: pulsa levemente os discos de ouro com TweenService no cliente. Ao entrar na arena ou afastar câmera, deixa de executar a animação. No touch, limita a quatro discos animados; no PC, até nove.
- `GilgameshNPC.RelicMasterInteraction.BabylonRelicPrompt`: usar **E no PC**, **X no gamepad** ou toque no prompt para abrir catálogo de relíquias.
- `RelicRingGallery.client.luau`: deixou de ser exclusivo do Studio, mostra os cinco anéis num ViewportFrame local **somente de leitura**, sem grants, gold, fake inventory ou consumo. Também pode abrir pelo botão no lobby.
- O **Gilgamesh atual é estático** e feito com Parts. Ainda não há R15 premium, animações faciais ou cena de evolução real.

## Arquivos envolvidos

- `src/server/BabylonHallBuilder.luau`: toda a decoração, 11 estilos de armas e as vitrines.
- `src/server/BabylonHall.server.luau`: espera o lobby existente e monta o anexo sem removê-lo.
- `src/client/BabylonHallVFX.client.luau`: brilho de portais otimizado por distância.
- `src/client/RelicRingGallery.client.luau`: NPC abre o catálogo visual em PC/mobile/gamepad.
- `src/server/BabylonHallSmokeTest.server.luau`: testes no Studio de 11 portais, 5 anéis, ponte, segurança e presença do NPC.
- `.github/workflows/build-beta.yml`: exige presença dos scripts e integração.

## Checklist de teste no Studio

1. Acesse https://github.com/Blacksharkv0/Anime-Fissure/actions e confirme a última build verde da main. Abra o arquivo .rbxlx gerado.
2. Inicie **Play**. Do spawn, entre pela ponte dourada à direita.
3. Confira que **Edward, Virgil, a oficina e o Portal das Missões** não foram movidos nem obstruídos.
4. Observe os 11 portais com armas diferentes atrás de Gilgamesh, as 5 vitrines e o chão/colunas.
5. Aproximando-se do NPC, use **E**, **X** ou toque e veja o **catálogo 3D**; as recompensas permanecem desligadas.
6. Inspecione as áreas em PC e com o Device Emulator do Roblox para Android e, se necessário, reduza quantidade de luzes/portais.
7. Procure no Output: `BABYLON HALL SMOKE OK`.
8. Se alguma arma atravessar parede ou o NPC parecer muito geométrico, ajuste o modelo/rig; essa é ainda uma versão **procedural**.

**Próxima camada de acabamento (não entregue ainda):** corpo premium R15 com detalhes refinados, animação de mão/expressões, abertura interativa dos portais, decoração de teto com relevos e catálogo definitivo com abas Equipar/Evoluir/Reroll após inventário real.
