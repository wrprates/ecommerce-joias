
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
   
 # O gráfico mostra um pico de vendas no mês de Junho, onde comemoramos o dia dos namorados, dando o insight de que datas comemorativas estão ligadas a vendas de determinados produtos.
   
 
