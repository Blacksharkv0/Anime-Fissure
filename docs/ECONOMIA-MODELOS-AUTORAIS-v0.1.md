# Anime Fissure — Economy Model Lab v0.2 (25/11/2026)

## Referência visual aprovada
Usamos a prancha de quatro ícones aprovada pelo criador: **Fissure Gems**, **Gold**, **Trait Reroll** e **Relic Trait**. A meta é reproduzir as silhuetas, cores e linguagem de energia da arte conceitual em Roblox 3D.

### O que está efetivamente programado
| Item | Modelo v0.2 | VFX de preview |
|---|---|---|
| Gemas da Fissura | Duas massas facetadas azul/violeta, fragmentos isolados, fecho metálico e rachadura em zigue-zague | Faíscas de rift, partículas orbitais e pulso azul |
| Gold | Disco 3D grosso com duas faces, aro trabalhado, gravação de símbolo angular e ornamento similar a louros | Cintilação dourada e faíscas suaves |
| Núcleo de Reescrita | Corpo mecânico hexagonal, trilho interno, disco central, braços e dentes externos | Linhas de energia giratórias e brilho ciano |
| Selo de Ressonância | Aros octogonais, glifos geométricos feitos em peças, quatro pontas e cristal violeta/laranja | Trilhas arcanas e partículas violetas/alaranjadas |

O material visual foi feito com **Part, WedgePart, Cylinder, Glass, Metal e Neon**, incluindo gravuras geométricas que **simulam textura de superfície**. Não é um arquivo MeshPart UV-mapeado ou textura PBR importada. A imagem conceitual é mais detalhada que esses protótipos de geometria Roblox, mas agora os modelos têm muito mais camadas e animação local.

### Arquivos
- `src/shared/EconomyVisualConfig.luau`: nomes, IDs e cores, ainda `VisualOnly`.
- `src/shared/EconomyItemModelBuilder.luau`: modelos 3D detalhados v0.2 com API `Build(id)` e `BuildAll(parent)`.
- `src/client/EconomyItemVFX.luau`: controlador de brilho, linhas de energia, pulsos e faíscas locais.
- `src/client/EconomyModelGallery.client.luau`: interface `GEMAS & ITENS`, rotação, zoom e botão `VFX ON/OFF`.
- `src/server/EconomyModels.server.luau`: templates gerados **só no Studio**.
- `src/server/EconomyModelSmokeTest.server.luau`: teste de existência de peças e detalhes, sem colisões nem arquivos externos.
- `.github/workflows/build-beta.yml`: valida presença dos arquivos e gera `.rbxlx` via Rojo.

### Como testar no Roblox Studio
1. Acesse https://github.com/Blacksharkv0/Anime-Fissure/actions e confira a **última execução verde** da workflow **Anime Fissure - Build Beta** na branch `main`.
2. Baixe `AnimeFissure-Beta`, abra o `.rbxlx` no Roblox Studio e inicie **Play**.
3. No lobby, clique **◇ GEMAS & ITENS** (abaixo de **MODELOS OVERLORD**).
4. Selecione os quatro recursos, **gire com arraste**, alterne **AUTO ON/OFF**, use **+/-** para zoom e **VFX ON/OFF** para comparar com e sem efeitos.
5. Abra **View → Output** e procure `ECONOMY MODEL SMOKE OK`, além de quaisquer erros vermelhos relacionados a EconomyItemModelBuilder, EconomyItemVFX ou EconomyModelGallery.
6. Teste **Device Emulator** em landscape e portrait; confira se os VFX continuam legíveis e se não há lentidão.
7. Capture prints com **VFX ON** e **VFX OFF** para compararmos com a prancha de referência.

### Limites e economia protegida
- **Nenhuma** Gem, Gold ou token de reroll foi concedido, vendido ou consumido.
- Summon continua com **SummonTickets**, sem trocar o banner, chances ou preços.
- Os modelos ainda são **prévia apenas no Studio**, não itens colecionáveis de jogadores.
- As animações e brilhos são **efeitos locais do ViewportFrame**, sem processamento de dano e sem efeitos em outros clientes.
- A v0.2 foi publicada no GitHub e revisada estaticamente. **Não foi executado Play no Roblox Studio nem confirmada a build verde por esta interação**.
- Uma versão final ainda poderá precisar de **meshes/UVs e texturas PBR próprias** para atingir o nível de detalhe da ilustração 2D aprovada.
