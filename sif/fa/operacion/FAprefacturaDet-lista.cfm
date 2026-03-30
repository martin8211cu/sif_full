<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Tipo" default="Tipo" returnvariable="LB_Tipo" xmlfile="FAprefacturaDet-lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descripcion" default="Descripci&oacute;n" returnvariable="LB_Descripcion" xmlfile="FAprefacturaDet-lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_DescripcionAlterna" default="Descripcion Alterna" returnvariable="LB_DescripcionAlterna" xmlfile="FAprefacturaDet-lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_PrecioUnitario" default="Precio Unitario" returnvariable="LB_PrecioUnitario" xmlfile="FAprefacturaDet-lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Descuento" default="Descuento" returnvariable="LB_Descuento" xmlfile="FAprefacturaDet-lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_IEPS" default="IEPS" returnvariable="LB_IEPS" xmlfile="FAprefacturaDet-lista.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_Total" default="Total" returnvariable="LB_Total" xmlfile="FAprefacturaDet-lista.xml">

<!--- Filtro para la lista
<cfinclude template="cotizaciones-filtro.cfm">--->
<cfquery name="rsDetCotiz" datasource="#session.dsn#">
	Select 	Linea,
			cd.IDpreFactura,
			ce.FAX04CVD,
			case TipoLinea
				when 'A' then 'Articulo'
				when 'S' then 'Servicio'
			end TipoLinea,
			case TipoLinea
				when 'A' then cd.Aid
				when 'S' then cd.Cid
			end codArtServ,
			Descripcion,
            Descripcion_Alt,
			Cantidad,
			PrecioUnitario,
			FAMontoIEPSLinea,
			cd.DescuentoLinea,
			TotalLinea
	from FAPreFacturaD cd
		inner join FAPreFacturaE ce
			on ce.Ecodigo=cd.Ecodigo
				and ce.IDpreFactura=cd.IDpreFactura

		left outer join Articulos a
			on a.Ecodigo=cd.Ecodigo
				and a.Aid=cd.Aid

		left outer join Conceptos c
			on c.Ecodigo=cd.Ecodigo
				and c.Cid=cd.Cid
	where cd.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and cd.IDpreFactura=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDpreFactura#">
</cfquery>
<cfinvoke
	component="sif.Componentes.pListas"
	method="pListaQuery"
	returnvariable="pListaRet">
		<cfinvokeargument name="query" value="#rsDetCotiz#"/>
		<cfinvokeargument name="desplegar" value="TipoLinea, Descripcion, Descripcion_Alt, PrecioUnitario, DescuentoLinea, FAMontoIepsLinea, TotalLinea"/>
		<cfinvokeargument name="etiquetas" value="#LB_Tipo#,#LB_Descripcion#, #LB_DescripcionAlterna#, #LB_PrecioUnitario#, #LB_Descuento#, #LB_IEPS#, #LB_Total#"/>
		<cfinvokeargument name="formatos" value="V, S, S, M, M, M, M, S"/>
		<cfinvokeargument name="align" value="left, left, left, rigth, rigth, rigth, rigth, rigth"/>
		<cfinvokeargument name="ajustar" value="N, N, N, N, N, N, N, N"/>
		<cfinvokeargument name="irA" value="FAprefactura.cfm"/>
		<cfinvokeargument name="showLink" value="true">
		<cfinvokeargument name="keys" value="Linea"/>
		<cfinvokeargument name="showemptylistmsg" value="true"/>
</cfinvoke>