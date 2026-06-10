# GRUPO 9 - GETWAITTIME() E SRTF
---
* Integrantes
    * Felipe Fernandes Morotti  12421BCC063
    * Giovana de Almeida Faria  12421BCC023
    * Gustavo Henrique Alves Santos  12411BCC090
    * Mateus Costa Felix  12411BCC036
    * João Gabriel Ribeiro Viana  12411BCC099

---
# Descrição
Este trabalho consiste na implementação de duas modificações no sistema operacional educacional XV6: a criação da chamada de sistema getwaittime() e a substituição do escalonador original pelo algoritmo SRTF (Shortest Remaining Time First).
A syscall getwaittime() permite que um processo consulte quanto tempo ficou aguardando a CPU na fila de prontos. Para isso, um contador foi adicionado ao PCB de cada processo e incrementado a cada tick do timer enquanto o processo permanece no estado RUNNABLE. A função retorna esse valor acumulado diretamente ao programa de usuário.
O escalonador SRTF substitui o Round Robin original do XV6, passando a priorizar sempre o processo com menor tempo restante de execução. Por ser preemptivo, ele pode interromper um processo em execução quando um mais curto estiver disponível, o que minimiza o tempo médio de espera do sistema — tornando a métrica retornada pela getwaittime() mais relevante e observável na prática.
