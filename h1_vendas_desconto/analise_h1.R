# Carregar pacotes
library(readr)
library(dplyr)

# Importando datasets
df_pedidos <- read_csv(file ="_data/clean/e_commerce_pedidos.csv")

# Visualização geral do dataset
head(df_pedidos)

# Deixando apenas os pedidos efetivados
df_pedidos_efetivados <- df_pedidos %>% 
  filter(is.na(data_cancelamento)) %>% 
  filter(!is.na(data_pagamento))

# Excluindo colunas que não serão utilizadas
df_pedidos_clean <- df_pedidos %>% 
  select(c("numero_pedido", "status", 
           "pagamento", "produto", "quantidade", "total",
           "total_pago", "total_produtos", "total_desconto",
           "total_custo", "total_juros", "total_frete",
           "total_item", "parcelamento", "id_cliente"  ))

df_pedidos_efetivados <- df_pedidos_efetivados %>% 
  select(c("numero_pedido", 
           "pagamento", "produto", "quantidade", "total",
           "total_pago", "total_produtos", "total_desconto",
           "total_custo", "total_juros", "total_frete",
           "total_item", "parcelamento", "id_cliente"  ))

# Tranformando numero do pedido em caracter
df_pedidos_clean$numero_pedido <- as.character(df_pedidos_clean$numero_pedido)

df_pedidos_efetivados$numero_pedido <- as.character(df_pedidos_efetivados$numero_pedido)

#####################################################################################
### H1 - Há uma maior quantidade de vendas devido a ações de desconto progressivo ###
#####################################################################################

# Criando variável de desconto progressivo
df_pedidos_clean <- df_pedidos_clean %>%
  mutate(desconto_progressivo = if_else(quantidade > 1 & total_desconto > 0, "Sim", "Não"))

df_pedidos_efetivados <- df_pedidos_efetivados %>%
  mutate(desconto_progressivo = if_else(quantidade > 1 & total_desconto > 0, "Sim", "Não"))

# Contando a quantidade de itens vendidos com e sem desconto progressivo
quant_descprog_clean <- df_pedidos_clean %>%
  group_by(desconto_progressivo) %>%
  summarise(qtd_itens = sum(quantidade))

quant_descprog_efetivados <- df_pedidos_efetivados %>%
  group_by(desconto_progressivo) %>%
  summarise(qtd_itens = sum(quantidade))

total_itens_clean <- sum(df_pedidos_clean$quantidade)
total_itens_efetivados <- sum(df_pedidos_efetivados$quantidade)

# Contando itens vendidos com e sem desconto progressivo
qtd_com_desconto_clean <- quant_descprog_clean$qtd_itens[
  quant_descprog_clean$desconto_progressivo == "Sim"]
qtd_sem_desconto_clean <- quant_descprog_clean$qtd_itens[
  quant_descprog_clean$desconto_progressivo == "Não"]

qtd_com_desconto_efetivados <- quant_descprog_efetivados$qtd_itens[
  quant_descprog_efetivados$desconto_progressivo == "Sim"]
qtd_sem_desconto_efetivados <- quant_descprog_efetivados$qtd_itens[
  quant_descprog_efetivados$desconto_progressivo == "Não"]

# Realizando o teste qui-quadrado

# df_pedidos_clean
resultado_test_clean <- prop.test(
  x = c(qtd_com_desconto_clean, qtd_sem_desconto_clean), 
  n = c(total_itens_clean, total_itens_clean))

print(resultado_test_clean)

# df_pedidos_efetivados
resultado_test_efetivados <- prop.test(
  x = c(qtd_com_desconto_efetivados, qtd_sem_desconto_efetivados), 
  n = c(total_itens_efetivados, total_itens_efetivados))

print(resultado_test_efetivados)









