# Irei explicar o que e Padrao Shell:
O shell padrão, também conhecido como shell de login, é o programa de linha de comando que é executado automaticamente quando um usuário faz login no sistema operacional.

O shell padrão é responsável por fornecer uma interface de usuário para interagir com o sistema operacional, permitindo que o usuário execute comandos, scripts, navegue no sistema de arquivos, etc.

Alguns dos shells padrão mais comuns em sistemas Linux/Unix incluem:

- Bash (Bourne-Again SHell): Este é o shell padrão na maioria das distribuições Linux e é amplamente utilizado devido à sua poderosa sintaxe de script e recursos avançados.

- Zsh (Z Shell): Este é um shell moderno e extensível, que é compatível com o Bash e oferece recursos adicionais, como completamento de comandos, histórico de comandos aprimorado e integração com plugins.

- Fish (Friendly Interactive SHell): Este é um shell com foco em usabilidade e interatividade, com uma sintaxe mais amigável e recursos de autocompleção avançados.

- Tcsh (TENEX C Shell): Este é uma versão aprimorada do shell C original, com recursos adicionais, como completamento de comandos e histórico de comandos.

Ao definir o shell padrão usando o comando useradd -D -s, você está determinando qual será o shell de login padrão para todos os novos usuários criados no sistema. Isso garante que os usuários tenham um ambiente de shell consistente e personalizado de acordo com suas preferências.

Os usuários podem, posteriormente, alterar seu shell padrão usando o comando chsh (change shell) se desejarem usar um shell diferente do padrão.

Link para leitura sobre o que e o padrao shell:

    https://www.datacamp.com/pt/blog/what-is-shell

    https://www.tecmint.com/change-a-users-default-shell-in-linux/#:~:text=Bash%20(%2Fbin%2Fbash),Linux%20using%20a%20nologin%20shell.