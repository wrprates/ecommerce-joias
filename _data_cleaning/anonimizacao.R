# Carregar as bibliotecas necessárias
library(readxl)
library(dplyr)

# Carregar e processar dados de "e_commerce_carrinhos"
e_commerce_carrinhos <- read_excel("./_data/raw/e_commerce_carrinhos.xlsx")

# Selecionar colunas específicas para descartar do dataframe
e_commerce_carrinhos <- e_commerce_carrinhos %>% 
  select(
    -nome_cliente,
    -email_cliente,
    -telefone_cliente,
    -marcas,
    -servico_entrega,
    -link_compra
  )

# Imprimir os nomes das colunas restantes no dataframe
print(colnames(e_commerce_carrinhos))

# Exportar o dataframe para um arquivo CSV com codificação UTF-8
write.csv(e_commerce_carrinhos, "./_data/clean/e_commerce_carrinhos.csv", row.names = TRUE, fileEncoding = "UTF-8")

# Carregar e processar dados de "e_commerce_pedidos"
e_commerce_pedidos <- read_excel("./_data/raw/e_commerce_pedidos.xlsx")

# Selecionar colunas específicas para descartar do dataframe
e_commerce_pedidos <- e_commerce_pedidos %>%
  select(
    -cliente,
    -cliente_email,
    -cliente_telefone,
    -cliente_document,
    -entrega,
    -entrega_destinatario,
    -entrega_endereco,
    -entrega_numero,
    -entrega_complemento,
    -codigo_rastreamento,
    -url_rastreamento,
    -ip,
    -id_transacao_gateway,
    -cod_barras_boleto,
    -cupom
  )

# Imprimir os nomes das colunas restantes no dataframe
print(colnames(e_commerce_pedidos))

# Exportar o dataframe para um arquivo CSV com codificação UTF-8
write.csv(e_commerce_pedidos, "./_data/clean/e_commerce_pedidos.csv", row.names = TRUE, fileEncoding = "UTF-8")

# Carregar e processar dados de "e_commerce_clientes"
e_commerce_clientes <- read_excel("./_data/raw/e_commerce_clientes.xlsx")

# Selecionar colunas específicas para descartar do dataframe
e_commerce_clientes <- e_commerce_clientes %>%
  select(
    -nome,
    -razao_social,
    -primeiro_nome,
    -ultimo_nome,
    -email,
    -cnpj,
    -cpf,
    -marcas_compradas,
    -telefone_ddd,
    -telefone_numero,
    -telefone_com_ddd,
    -numero,
    -complemento,
    -ip
  )

# Imprimir os nomes das colunas restantes no dataframe
print(colnames(e_commerce_clientes))

# Exportar o dataframe para um arquivo CSV com codificação UTF-8
write.csv(e_commerce_clientes, "./_data/clean/e_commerce_clientes.csv", row.names = TRUE, fileEncoding = "UTF-8")
