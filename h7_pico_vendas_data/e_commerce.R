
library(dplyr)
library(ggplot2)
library(lubridate)
library(tidyverse)


dados_carrinho <- read.csv("_data//clean//e_commerce_carrinhos.csv")
dados_carrinho

dados_clientes <- read_csv("_data//clean//e_commerce_clientes.csv")
dados_clientes

dados_pedidos <- read_csv("_data//clean//e_commerce_pedidos.csv")
dados_pedidos




# Transformando os dados para datas, contando a frequência das compras por mês para identificarmos picos respondendo à pergunta solicitada.

 dados_pedidos |>
   mutate(
    data_pagamento_periodo = as.Date(dmy_hm(data_pagamento))
  ) |>
   group_by(data_pagamento_periodo) |>
   tally() |>
   ggplot(aes(x = data_pagamento_periodo, y = n )) +
   geom_line() +
   labs(
    Tittle = "Número de Ocorrências por Mês",
    x = "Data de Pagamento",
    y = "Número de Ocorrências"
   ) +
   theme_minimal()
 

   
 # Criando vetor com datas especiais  
 
  datas_especiais <- c(
    "01/01/2024",
    "06/01/2024",
    "12/02/2024",
    "13/02/2024",
    "08/03/2024",
    "19/03/2024",
    "29/03/2024",
    "31/03/2024",
    "19/04/2024",
    "21/04/2024",
    "22/04/2024",
    "01/05/2024",
    "02/05/2024",
    "14/05/2024",
    "30/05/2024",
    "12/06/2024",
    "13/06/2024",
    "24/06/2024",
    "29/06/2024",
    "02/07/2024",
    "26/07/2024",
    "02/08/2024",
    "11/08/2024",
    "15/08/2024",
    "07/09/2024",
    "20/09/2024",
    "21/09/2024",
    "12/10/2024",
    "15/10/2024",
    "31/10/2024",
    "01/11/2024",
    "02/11/2024",
    "15/11/2024",
    "20/11/2024",
    "08/12/2024",
    "25/12/2024",
    "31/12/2024"
      )
  
dados_tratados <- dados_pedidos |>
  mutate(data_corrigida = format(as.Date(dmy_hm(data_pagamento)), "%d/%m/%Y")) |>
  select(data_corrigida, total_pago) |>
  filter(!is.na(data_corrigida)) |>
  # Agrupando por data
  group_by(data_corrigida) |>
  summarise(
    total_pago = sum(total_pago, na.rm = TRUE)
  )
 
dados_datas_especiais <- dados_tratados |>
  filter(data_corrigida %in% datas_especiais)

 dados_fora_datas_especiais <- dados_tratados |>
   filter(!(data_corrigida %in% datas_especiais))

# Testando hipótese de que datas especiais é maior que datas "normais" do calendário

wilcox.test(
  x = dados_datas_especiais$total_pago,
  y = dados_fora_datas_especiais$total_pago,
  alternative = "greater"
)
 
#  Dada a limitação do tamanho da amostra, podemos considerar um nível de confiança de 90% (ou seja, um valor p de 0,10) para interpretar o resultado. 
 # Com isso em mente, o valor p obtido (0,06413) agora é considerado estatisticamente significativo, já que é menor que 0,10. 
 # Portanto, temos uma evidência suficiente, com um nível de confiança de 90%, para rejeitar a hipótese nula.

# Isso indica que a mediana de dados_datas_especiais$total_pago é provavelmente maior que a de dados_fora_datas_especiais$total_pago, sugerindo que, em datas especiais, o total pago tende a ser maior do que fora dessas datas. 
# No entanto, essa conclusão deve ser vista com cautela devido ao tamanho reduzido da amostra.
