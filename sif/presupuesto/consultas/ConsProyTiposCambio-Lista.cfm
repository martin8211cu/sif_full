<cfif isdefined("url.FCPCano") and len(url.FCPCano) and not isdefined("form.FCPCano")><cfset form.FCPCano = url.FCPCano></cfif>
<cfif isdefined("url.FCPCmes") and len(url.FCPCmes) and not isdefined("form.FCPCmes")><cfset form.FCPCmes = url.FCPCmes></cfif>
<cfif isdefined("url.FMcodigo") and len(url.FMcodigo) and not isdefined("form.FMcodigo")><cfset form.FMcodigo = url.FMcodigo></cfif>
<cfset navegacion = "">
<cfif isdefined("form.FCPCano") and len(form.FCPCano)><cfset Navegacion = "&FCPCano="&form.FCPCano></cfif>
<cfif isdefined("form.FCPCmes") and len(form.FCPCmes)><cfset Navegacion = "&FCPCmes="&form.FCPCmes></cfif>
<cfif isdefined("form.FMcodigo") and len(form.FMcodigo)><cfset Navegacion = "&FMcodigo="&form.FMcodigo></cfif>
<cfquery name="lista" datasource="#session.dsn#">
	select a.CPCano, a.CPCmes, ' ' as mes, a.Mcodigo, b.Mnombre, a.CPTipoCambioCompra, a.CPTipoCambioVenta
	from CPTipoCambioProyectadoMes a inner join Monedas b on a.Ecodigo = b.Ecodigo and a.Mcodigo = b.Mcodigo
	where a.Ecodigo = #session.ecodigo#
	<cfif isdefined("form.FCPCano") and len(form.FCPCano)>
			and a.CPCano = <cfqueryparam value="#form.FCPCano#" cfsqltype="cf_sql_integer">
	</cfif>
	<cfif isdefined("form.FCPCmes") and len(form.FCPCmes)>
			and a.CPCmes = <cfqueryparam value="#form.FCPCmes#" cfsqltype="cf_sql_integer">
	</cfif>
	<cfif isdefined("form.FMcodigo") and len(form.FMcodigo)>
			and a.Mcodigo = <cfqueryparam value="#form.FMcodigo#" cfsqltype="cf_sql_integer">
	</cfif>
</cfquery>
<cfset meses = convertMes(lista,'CPCmes','mes')>
<cfinvoke component='sif.Componentes.pListas'	method='pListaQuery' returnvariable='pListaRet'>
	<cfinvokeargument name='query' value='#lista#'>
	<cfinvokeargument name='cortes' value='Mnombre'>
	<cfinvokeargument name='desplegar' value='CPCano, mes, CPTipoCambioCompra, CPTipoCambioVenta'>
	<cfinvokeargument name='etiquetas' value='Año, Mes, TC.Compra, TC.Venta'>
	<cfinvokeargument name='formatos' value='S, S, M, M'>
	<cfinvokeargument name='align' value='left, left, right, right'>
	<cfinvokeargument name='ajustar' value='S'>
	<cfinvokeargument name='navegacion' value='#Navegacion#'>
	<cfinvokeargument name="showLink" value="false">
	<cfinvokeargument name="width" value="70%">
</cfinvoke>