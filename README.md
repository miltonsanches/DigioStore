## README do Projeto DigioStore

**Projeto DigioStore**: Este projeto é uma showcase de desenvolvimento iOS usando Swift, focado em demonstrar boas práticas de programação, incluindo testes unitários e de UI. O objetivo é ilustrar a aplicação de técnicas modernas e metodologias robustas no contexto de um app comercial simulado.

### Arquitetura

- **MVVM-C (Model-View-ViewModel-Coordinator)**: Escolhida para promover escalabilidade, manutenibilidade e testabilidade. A separação de responsabilidades e a navegação desacoplada permitem adaptações e manutenção simplificadas. **

### Implementação Técnica

- **AppDelegate com Coordinator**: O `AppDelegate` foi modificado para usar um Coordinator, centralizando a lógica de navegação para melhor gerenciamento dos fluxos e facilitando alterações sem grandes impactos no código.

- **UIKit**: Adotamos o UIKit para construir a interface do usuário, aproveitando seu amplo suporte e integração profunda com o ecossistema iOS.

- **URLSession para acesso à internet**: Utilizamos `URLSession.shared.dataTask` para todas as operações de rede devido à sua eficiência e suporte a operações assíncronas, além de configurações flexíveis de rede.

- **Codable e Equatable no model**: Implementados para facilitar a manipulação de dados e permitir comparações diretas entre instâncias, essenciais para atualizações de UI e lógicas de negócios.

- **Download de imagens**: Optamos pela `URLSession` compartilhada para downloads de imagens, utilizando configurações padrão de cache e rede.

- **AutoLayout com NSLayoutConstraint.activate([])**: O uso de `NSLayoutConstraint.activate([])` para ativar múltiplas constraints simultaneamente melhora a performance e a manutenibilidade do layout.

### Configurações Específicas

- **Projeto**: `DigioStore.xcodeproj`.
- **Remoção do Main.storyboard**: Optamos por remover o `Main.storyboard` para utilizar uma abordagem baseada inteiramente em código, que oferece maior controle e flexibilidade sobre os componentes da UI.
- **NSAppTransportSecurity**: No arquivo `Info.plist`, adicionamos `NSAppTransportSecurity` com `NSAllowsArbitraryLoads` setado como `YES` para permitir requisições de rede sem restrições, facilitando o desenvolvimento e testes em fases iniciais.
- **fetchData com completion**: Implementado com um callback `@escaping` para garantir que a UI possa ser atualizada assim que os dados da rede estiverem disponíveis, suportando operações assíncronas eficientes.

### Como Executar o Projeto

1. **Clone o repositório** do projeto.
2. **Abra** o arquivo `DigioStoreApp.xcodeproj` usando o Xcode.
3. **Selecione um dispositivo** ou simulador.
4. **Execute o projeto** pressionando `Cmd + R`.


### Testes Unitários

Garantimos a integridade de cada componente através de testes unitários rigorosos, utilizando MockDigioStoreViewModel para simular interações de rede. Isso permite verificação detalhada da lógica de negócios e manipulação de dados, crucial para a estabilidade do aplicativo.

Execução de Testes Unitários:

• No Xcode: Abra o painel Test Navigator.
• Escolha a suite de testes: ViewControllerTests.
• Execute: Comando Cmd + U.

#### Exemplo de Teste: `configureSpotlight`
Este teste valida se o método `configureSpotlight` configura corretamente os elementos da UI com base nos dados fornecidos. Ele verifica a quantidade de elementos no `spotlightStackView` e assegura que as propriedades de cada elemento estão corretas, refletindo a precisão e a integridade da renderização da UI.

#### Execução do Teste

Para executar o teste unitário:
1. **Abra o Projeto**: No Xcode, acesse o painel de teste.
2. **Selecione os Teste**: Escolha a suite de testes `ViewControllerTests`.
3. **Execute os Teste**: Utilize o atalho `Cmd + U` ou clique no botão de play ao lado do nome do teste no Xcode.

Essa seção condensa a justificativa e a implementação dos testes unitários, mantendo foco na execução e na importância prática para o desenvolvimento e manutenção do projeto DigioStore.

### Teste de UI: Verificação Inicial da Tela

Teste de UI testInitialSpotlightLoad: Foca em validar a carga e exibição corretas dos elementos na tela inicial, assegurando que os usuários têm uma experiência imersiva desde o primeiro uso. Verifica especificamente se elementos como imagens e textos são carregados e exibidos corretamente, simulando uma interação real do usuário. Para isso inclusive simulam interações do usuário, como toques e swipes. São feitas capturas das telas para comparação durante o teste.

#### Executando o Teste de UI:
1. **Abra o projeto no Xcode.**
2. **Selecione o esquema de testes** de UI no menu de esquemas do Xcode.
3. **Execute o teste utilizando o atalho** Cmd + U ou através do painel de teste no Xcode.

Este teste é essencial para confirmar que os componentes visuais e dinâmicos da interface do usuário estão funcionando como esperado, validando assim a integridade do fluxo de dados até a apresentação final ao usuário.

### Conclusão

Este projeto não só segue mas também define padrões elevados para desenvolvimento de software iOS, com um forte foco em escalabilidade e manutenibilidade. Continuaremos a integrar novas práticas e ferramentas para manter a relevância e eficácia do DigioStore.
# DigioStore
# DigioStore
