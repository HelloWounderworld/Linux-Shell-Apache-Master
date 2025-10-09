# Exercício 04

Um administrador deseja experimentar parâmetros diferentes para o módulo do kernel "bluetooth" sem reiniciar o sistema. No entanto, qualquer tentativa de descarregar o módulo com "modprobe -r bluetooth" resulta no seguinte erro:

    modprobe: FATAL: Module bluetooth is in use.

Qual a possível causa desse erro?

## Resposta

Provavelmente, a causa do erro estaria no fato de o modulo kernel "bluetooth" ela estar ativa. No caso, poderia verificar pelo "dmesg" para disgnosticar o motivo dela estar ativa e, somente identificado algo ativo nela, daria para tentar desativar a funcionalidade dela pelo terminal para, somente depois disso, conseguir descarregar o modulo. Provavelmente, o modulo carregado, nao tem como ser descarregado, se o dispositivo em si, estiver em uso ou ativo.
