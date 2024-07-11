# Gerenciando processos:
- ps - vc consegue visualizar os processos que estão rodando. Ate os processos conhecidos como processo zumbi/mortos.

- sleep (numero) - é uma forma de exibir a linha de comando do terminal após algum tempo.

- sleep (numero) & - Executa o comando sleep, mas deixa o terminal livre. Esse processo é chamado de background. No caso, feito esse comando em seguida colocar o comando ps, será mostrado que o processo sleep está sendo executado.

- kill (Número do PID que pode ser visto pelo ps) - Ele mata literalmente o processamento, ou seja, encerra, dá um freio bruto. Esse comando serve para casos em que o sistema operacional que vc está rodando está muito lento e serve para conseguir tirar algum processamento desnecessário que esteja rodando.