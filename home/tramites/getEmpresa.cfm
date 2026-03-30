<cfquery name="getEmpresa" datasource="asp" maxrows="1">
	select ce.CEcodigo, ce.LOCIdioma, e.Ecodigo as EcodigoSDC, e.Ereferencia as Ecodigo
	from CuentaEmpresarial ce 
		inner join Empresa e
			on e.CEcodigo = ce.CEcodigo
	where ce.CEaliaslogin like '%tramites%'
</cfquery>
