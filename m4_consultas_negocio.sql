/*Consulta 1*/

SELECT
		COUNT (Cantidad) AS CantidadDePedidos,
		SUM (Cantidad*PrecioUnitario) AS TotalFacturado,
		AVG (Cantidad) AS TicketPromedio		
FROM dbo.Ventas
GROUP BY MONTH(FechaVenta);

/*Consulta 2*/

SELECT TOP 5
			IDProducto,
			SUM(Cantidad) AS CantidadVendida,
			SUM(Cantidad*PrecioUnitario) AS TotalFacturado
FROM dbo.Ventas
GROUP BY IDProducto
ORDER BY TotalFacturado DESC;


/*Consulta 3*/
SELECT
		IDCliente,
		SUM (Cantidad) AS CantidadPedidos,
		SUM (Cantidad*PrecioUnitario) AS TotalGastado
FROM dbo.Ventas
GROUP BY IDCliente
HAVING COUNT (*)>1;

/*Consulta 4*/
WITH VentasPorMes AS (
    SELECT 
        FORMAT(FechaVenta, 'yyyy-MM') AS Mes,
        SUM(Cantidad*PrecioUnitario) AS TotalFacturado
    FROM dbo.Ventas
    GROUP BY FORMAT(FechaVenta, 'yyyy-MM')
)
SELECT 
    Mes,
    TotalFacturado,
    CASE 
        WHEN TotalFacturado >= AVG(TotalFacturado) OVER () THEN 'Por encima'
        ELSE 'Por debajo'
    END AS EstadoVsPromedio
FROM VentasPorMes
ORDER BY Mes;

