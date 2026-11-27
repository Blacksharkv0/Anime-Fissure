# ANIME FISSURE — DEMO MONSTRA / POLIMENTO FINAL (27/11/2026)

**Objetivo:** apresentar hoje a melhor versão testável do lobby, Carne Village e sistemas beta existentes, com operações seguras. A compilação automática usa **Rojo 7.5.1** e gera o arquivo **AnimeFissure-Beta.rbxlx** no GitHub Actions.

## Conteúdo consolidado

O Lobby mantém os **sete NPCs permanentes**: Vergil (Summon), Dante (Index), Edward (Alquimia/Orbes), Gilgamesh (Relíquias universais), Whis (Evolução das unidades), Kisuke Urahara (Traits) e Sung Jinwoo (Desafios/Raids permanentes). Existe uma **praça central de eventos** com a prévia do Escanor **somente no Studio** — não há evento Nanatsu ativo.

**Salão da Babilônia:** anexo ligado ao lobby, com 11 portais de armas geek autorais, cinco modelos de anéis, catálogo universal de relíquias por interação com Gilgamesh. **Não transfere relíquias para Edward**, e Whis continua sendo a única estação de **evolução de personagens**.

**Aparência:** camada extra de acabamento procedural de personagens em Roblox Parts, detalhes faciais, roupas, ornamentos, portas de raids e anéis celestiais; emblema bicolor de irmãos entre Dante e Vergil. Modelos novos continuam **protótipos estáticos** e não equivalem a modelos premium importados e animados de Blender.

## Qualidade de vida acrescentada

1. **NPCs / MAPA**: botão no topo esquerdo do lobby, tecla **M** no PC. Mostra nove destinos reais: Portal Story, Vergil, Dante, Edward, Gilgamesh, Whis, Urahara, Jinwoo e Praça dos Eventos. Selecionar um destino cria um **marcador local sobre o NPC** e mostra a distância aproximada em studs, atualizada enquanto o jogador anda. Não teleporta ou ativa serviços remotamente. Arquivo: src/client/LobbyNavigator.client.luau.
2. **FX PADRÃO / FX LEVE**: controle ao lado do mapa. No celular começa em FX LEVE e pode ser trocado. Diminui brilhos decorativos e quantidade de partes temporárias dos ataques, mantendo a leitura básica dos ataques. **Dano e combate nunca mudam**; atributo local ReducedVFX.
3. **Confirmação de venda**: clicar VENDER abre uma confirmação informando o retorno estimado antes de enviar a venda ao servidor. ESC cancela. Evita perda acidental. Arquivo: src/client/TowerHUD.client.luau.
4. **Atalhos da arena no PC**: teclas **1 a 6** para slots do deck, **Q** para cancelar posicionamento e **U** para melhorar a unidade selecionada quando o upgrade for válido. O servidor autoriza e paga/cobra, não o cliente.
5. **Posicionamento mobile por arrastar e soltar**: ao selecionar uma unidade, segure e arraste o dedo para pré-visualizar a posição **56 px acima do dedo**; solte para solicitar posicionamento no gramado. Evita que o dedo cubra o alvo. Sem alterar restrições do servidor.
6. **ESC / B no controle**: fecha Summon quando não há transação em andamento, Alquimia, Index, Gilgamesh e painéis de mentores. Interfaces ajustadas a telas menores e tema preservado.
7. **Correção de UI antiga**: InterfaceVisualPolish agora reconhece AlchemyWindow do Edward; removidas tentativas de redimensionamento duplicado que disputavam UIScale com as interfaces já responsivas.
8. **Diagnóstico no Studio**: botão DIAGNÓSTICO DO LOBBY, com **13 verificações de presença** de modelos, prompts, portais, vitrines e mapa/FX. Verde significa **modelos carregados**, não funções de inventário ou raids prontas.

## Revisão de código e proteções

- Nenhuma alteração aos preços, status, bônus de anéis, Traits, números de dano, chances de summon, pity ou drop real nesta revisão.
- Reroll, evolução, raids e crafting só são telas informativas até existir inventário persistente e serviço transacional.
- Cinco anéis do Overlord mantêm função dupla: **relíquia equipável em unidades compatíveis** e **material de evolução**; efeitos comuns suprimidos no Ainz.
- **OVL_01 Carne Village** segue a única Story Stage com entrada liberada no servidor, nas dificuldades Classic/Hard. As outras fases aparecem em planejamento, sem se passarem por jogáveis.
- Todos os novos controles de venda, upgrade, posicionamento e NPCs usam as verificações existentes no servidor; a interface não concede itens.
- O arquivo src/server/DemoReleaseSmokeTest.server.luau roda somente no Play do Studio e valida catálogos, NPCs, entrada Story e bloqueios. A CI valida scripts, padrões críticos, e que o .rbxlx realmente inclui os módulos novos.

## Teste de entrega no Roblox Studio

1. Acesse https://github.com/Blacksharkv0/Anime-Fissure/actions/workflows/build-beta.yml e abra o último **Build Beta** da branch main com status verde.
2. Em **Artifacts**, baixe AnimeFissure-Beta e extraia AnimeFissure-Beta.rbxlx.
3. Abra no Roblox Studio e dê **Play**; clique em **DIAGNÓSTICO DO LOBBY** (canto inferior esquerdo). Os **13 indicadores** devem ficar verdes após carregarem.
4. Abra **NPCs / MAPA** ou aperte **M**, escolha Gilgamesh e caminhe seguindo o marcador; depois visite Dante ao lado de Vergil, Edward, Whis, Urahara e Jinwoo.
5. Verifique **FX LEVE** e **FX PADRÃO**, inspecione o Salão da Babilônia, os 11 portais e as cinco vitrines.
6. Entre no **Story Mode: Overlord → Carne Village Classic/Hard**. No **Studio**, se quiser, use o deck de laboratório para testar os modelos Overlord; ele não comprova posse real das unidades.
7. Coloque uma torre, aperte **U** para upgrade quando possível; clique em **VENDER** e **CANCELAR**, certificando-se de que não vendeu. Confirme depois e veja o resultado retornado pelo servidor.
8. No emulador mobile, escolha um slot, **arraste e solte** para testar a prévia deslocada; verifique a interface e o desempenho.
9. Abra **View → Output** e confira as mensagens “DEMO RELEASE SMOKE OK”, “PREMIUM LOBBY ART SMOKE OK”, “DANTE UNIVERSAL INDEX SMOKE OK”, “LOBBY SERVICE NETWORK SMOKE OK”. Qualquer erro no Output deve ser considerado falha a corrigir.

**Limitações honestas:** Rojo compila arquivos mas não executa o jogo. O Play real, física, desempenho do Android, rigging e visual 3D precisam de teste manual. Esta é uma **demo de apresentação e teste**, não o jogo final pronto para lançamento público.

O código está versionado no GitHub. Para recursos que dependem de personagens de terceiros, é necessário revisar os direitos/licenças antes de publicar comercialmente.
