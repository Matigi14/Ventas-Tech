/*CONSULTA 1*/
--Vista base del proyecto (INNER JOIN)
-- Mostrar todas las tablas que se indicaran luego en el POWER BI
SELECT 
    v.IDVenta,
    v.FechaVenta,
    c.IDCLiente,
    c.Nombre AS NombreCliente,
    p.IDProducto,
    p.NombreProducto,
    p.IDCategoria,
    v.Cantidad,
    v.PrecioUnitario,
    (v.Cantidad * v.PrecioUnitario) AS TotalVenta,
    t.IDTerritorio,
    t.Pais
FROM dbo.Ventas AS v
INNER JOIN Clientes AS c 
    ON v.IDCliente = c.IDCLiente
INNER JOIN Productos AS p 
    ON v.IDProducto = p.IDProducto
INNER JOIN Territorio AS t 
    ON v.IDTerritorio = t.IDTerritorio
-- Se detecta que todos los clientes son de Argentina y los productos 5 y 6 se compraron una sola vez

/*CONSULTA 2*/
--Clientes sin ventas (LEFT JOIN)
-- Identificar que clientes aun no han realizado alguna compra
SELECT 
    c.Nombre,
    c.Email,
    c.FechaRegistro
FROM dbo.Clientes AS c
LEFT JOIN dbo.Ventas AS v 
    ON v.IDCliente = c.IDCliente
WHERE v.IDCliente IS NULL;
-- Se detecta que los cinco clientes han realizado al menos una compra de cualquier producto

/*CONSULTA 3*/
--Productos sin ventas (LEFT JOIN)
--Identificar que producto no se han comprado 
SELECT
    P.NombreProducto,
    p.IDCategoria,
    p.Precio
FROM dbo.Productos AS p
LEFT JOIN dbo.Ventas AS v
    ON p.IDProducto = v.IDProducto
    WHERE v.IDProducto IS NULL;
-- Todos los productos tienen al menos una compra
/*CONSULTA 4*/
-- Consolidado por canal (UNION ALL)
-- Realizar uniones entre tablas sin desperdiciar datos duplicados
SELECT canal, SUM(total) AS total_canal
FROM (
    SELECT v.FechaVenta, v.Cantidad * v.PrecioUnitario AS total, 'Online' AS canal
    FROM dbo.Ventas AS v 
    WHERE v.IDCliente =3
    UNION ALL
    SELECT v.FechaVenta, v.Cantidad * v.PrecioUnitario AS total, 'Presencial' AS canal
    FROM dbo.Ventas AS v
    WHERE v.IDCliente >3 
) AS consolidado
GROUP BY canal; 

-- se detecta que hay mas compras presenciales que via online.