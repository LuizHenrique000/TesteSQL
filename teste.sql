-- Vendedores ativos ordenados por nome e salário

SELECT id_vendedor, nome, salario
FROM vendedores
WHERE inativo = false
ORDER BY nome ASC, salario DESC;

-- Vendedores com salário acima da média

SELECT id_vendedor, nome, salario
FROM vendedores
WHERE salario > (SELECT AVG(salario) FROM vendedores)
ORDER BY salario DESC;

-- Resumo por cliente

SELECT 
    c.id_cliente AS id,
    c.razao_social,
    COALESCE(SUM(p.valor_total), 0) AS total
FROM 
    clientes c
LEFT JOIN 
    pedido p ON c.id_cliente = p.id_cliente
    AND p.data_emissao IS NOT NULL
GROUP BY 
    c.id_cliente, c.razao_social
ORDER BY 
    total DESC;

-- Situação por pedido

SELECT 
    id_pedido AS id,
    valor_total AS valor,
    TO_CHAR(data_emissao, 'DD/MM/YYYY') AS data,
    CASE
        WHEN data_cancelamento IS NOT NULL THEN 'CANCELADO'
        WHEN data_faturamento IS NOT NULL THEN 'FATURADO'
        ELSE 'PENDENTE'
    END AS situacao
FROM 
    pedido
ORDER BY 
    id;

-- Produtos mais vendidos

SELECT 
    ip.id_produto,
    SUM(ip.quantidade) AS quantidade_vendida,
    SUM(ip.preco_praticado * ip.quantidade) AS total_vendido,
    COUNT(DISTINCT ip.id_pedido) AS pedidos,
    COUNT(DISTINCT p.id_cliente) AS clientes
FROM 
    itens_pedido ip
JOIN 
    pedido p ON ip.id_pedido = p.id_pedido
GROUP BY 
    ip.id_produto
ORDER BY 
    quantidade_vendida DESC,
    total_vendido DESC
LIMIT 1;