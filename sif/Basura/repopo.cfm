<cfquery datasource="minisif" name="xxx">


SELECT    Empresas.Ecodigo, Empresas.Edescripcion AS Nombre, Monedas.Mnombre
FROM      dbo.Empresas, dbo.Monedas 
WHERE     dbo.Monedas.Mcodigo = dbo.Empresas.Mcodigo
  AND     dbo.Monedas.Ecodigo = dbo.Empresas.Ecodigo
order by Ecodigo desc
</cfquery>
<cfreport template="repopo.cfr" format="flashpaper" query="xxx" />
