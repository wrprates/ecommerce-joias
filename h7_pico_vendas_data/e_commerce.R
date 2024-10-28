library(readr)
library(dplyr)
install.packages("ggplot2")
library(ggplot2)
library(lubridate)
install.packages("tidyverse")
library(tidyverse)

dados_carrinho <- read.csv("C://Users//ferna//Documents//ecommerce-joias//_data//clean//e_commerce_carrinhos.csv")
dados_carrinho

dados_clientes <- read.csv("C://Users//ferna//Documents//ecommerce-joias//_data//clean//e_commerce_clientes.csv")
dados_clientes


dados_pedidos <- read.csv("C://Users//ferna//Documents//ecommerce-joias//_data//clean//e_commerce_pedidos.csv")
dados_pedidos


#Transformando dados em uma tibble, Data Frame
str(dados_pedidos)
dados_pedidos <- as_tibble(dados_pedidos)
class(dados_pedidos)

# Transformando colunas em datas
str(dados_pedidos)
names(dados_pedidos)
dados_pedidos$data <- as.Date(dados_pedidos$data, format = "%d, %m, %y")
class(dados_pedidos_data)
class(dados_pedidos$data_pagamento)
dados_pedidos$data_pagamento <- as.Date(dados_pedidos$data_pagamento, format = "%d, %m, %y")
class(dados_pedidos$data_pagamento)



dados_filtrados <- dados_pedidos %>%
  filter(status != "Cancelado" & status != "Aguardando pagamento")

contagem_pedidos <- dados_filtrados %>%
  count(status)
print(contagem_pedidos)
names(contagem_pedidos)

frequencia_vendas_por_data <- dados_filtrados %>%
  count(data_pagamento)
names(frequencia_vendas_por_data)





library(ggplot2)


ggplot(frequencia_vendas_por_data, aes(x = data_pagamento, y = n )) + 
  geom_line(color = "steelblue") +
  labs(
    title = "Histograma de Vendas",
    x = "Número de Vendas",
    y = "Frequência"
  ) +
  theme_minimal()



view(contagem_pedidos)
view(frequencia_vendas_por_data)
