# Carregar as bibliotecas necessárias
library(readxl)
library(dplyr)
library(digest)

# Função para anonimizar email e criar id_cliente
anonymize_email <- function(email_column) {
  sapply(email_column, function(x) digest(x, algo = "sha256"))
}

# Carregar e processar dados de "e_commerce_carrinhos"
e_commerce_carrinhos <- read_excel("./_data/raw/e_commerce_carrinhos.xlsx")

# Anonimizar email_cliente e criar a coluna id_cliente
e_commerce_carrinhos <- e_commerce_carrinhos %>%
  mutate(id_cliente = anonymize_email(email_cliente))

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

# Anonimizar cliente_email e criar a coluna id_cliente
e_commerce_pedidos <- e_commerce_pedidos %>%
  mutate(id_cliente = anonymize_email(cliente_email))

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
    -entrega_rua,
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

# Anonimizar email e criar a coluna id_cliente
e_commerce_clientes <- e_commerce_clientes %>%
  mutate(id_cliente = anonymize_email(email))

# Selecionar colunas específicas para descartar do dataframe
e_commerce_clientes <- e_commerce_clientes %>%
  mutate(non_na_count = rowSums(!is.na(e_commerce_clientes))) %>%
  group_by(cpf) %>%
  arrange(desc(non_na_count)) %>%
  slice_head(n = 1) %>%
  ungroup() %>%
  select(
    -id,
    -nome,
    -razao_social,
    -primeiro_nome,
    -ultimo_nome,
    -email,
    -cnpj,
    -marcas_compradas,
    -telefone_ddd,
    -telefone_numero,
    -telefone_com_ddd,
    -numero,
    -complemento,
    -ip,
    -utm_source,
    -utm_campaign,
    -rua,
    -cpf,
    -non_na_count
  )

# Imprimir os nomes das colunas restantes no dataframe
print(colnames(e_commerce_clientes))

# Exportar o dataframe para um arquivo CSV com codificação UTF-8
write.csv(e_commerce_clientes, "./_data/clean/e_commerce_clientes.csv", row.names = TRUE, fileEncoding = "UTF-8")