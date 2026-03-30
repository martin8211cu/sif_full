<!--- Filtro para la lista 
<cfinclude template="cotizaciones-filtro.cfm">--->
<cfquery name="rsDetCotiz" datasource="#session.dsn#">
	Select 	Linea,
			periodo,
			<cfqueryparam cfsqltype="cf_sql_char" value="#form.tipoCoti#"> as tipoCoti,	
			cd.NumeroCot,
			ce.FAX04CVD, 
			FAM21NOM,
			case TipoLinea
				when 'A' then 'Articulo'
				when 'S' then 'Servicio'
			end TipoLinea,
			case TipoLinea
				when 'A' then cd.Aid
				when 'S' then cd.Cid
			end codArtServ,
			Descripcion,
			Cantidad,
			PrecioUnitario,
			PorDescuento,
			MonDescuento, 
			TotalLinea
	from FACotizacionesD cd
		inner join FACotizacionesE ce
			on ce.Ecodigo=cd.Ecodigo
				and ce.NumeroCot=cd.NumeroCot
	
		inner join FAM021 v
			on v.Ecodigo=ce.Ecodigo
				and v.FAX04CVD=ce.FAX04CVD
	
		left outer join Articulos a
			on a.Ecodigo=cd.Ecodigo
				and a.Aid=cd.Aid
	
		left outer join Conceptos c
			on c.Ecodigo=cd.Ecodigo
				and c.Cid=cd.Cid
	where cd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and cd.NumeroCot=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NumeroCot#">				
</cfquery>
<cfinvoke 
	component="sif.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsDetCotiz#"/>
		<cfinvokeargument name="desplegar" value="TipoLinea, periodo,Descripcion, PrecioUnitario, MonDescuento, TotalLinea"/>
		<cfinvokeargument name="etiquetas" value="Tipo,Periodo,Descripcion,Precio Unitario, Descuento, Total"/>
		<cfinvokeargument name="formatos" value="V, d, V, M, M, M"/>
		<cfinvokeargument name="align" value="left, left, left, rigth, rigth, rigth"/>
		<cfinvokeargument name="ajustar" value="N, N, N, N, N, N"/>
		<cfinvokeargument name="irA" value="cotizaciones.cfm"/>
		<cfinvokeargument name="keys" value="Linea"/>
		<cfinvokeargument name="showemptylistmsg" value="true"/>
</cfinvoke>