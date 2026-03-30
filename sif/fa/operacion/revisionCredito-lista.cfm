<cfset navegacion = "">
<cfif isdefined("form.fCliente") and len(trim(form.fCliente)) >
	<cfset navegacion = navegacion & "&fCliente=#form.fCliente#">
</cfif>
<cfif isdefined("form.fCedula") and len(trim(form.fCedula)) >
	<cfset navegacion = navegacion & "&fCedula=#form.fCedula#">
</cfif>
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfquery name="rsLista" datasource="#session.DSN#">
	select 	a.VentaID,
			a.nombre_cliente, 
			a.cedula_cliente, 
			a.total_productos,
			a.Ddocumento, 
			coalesce(b.CDlimitecredito - b.CDcreditoutilizado,0) as Disponible,
			a.fecha,
			convert(varchar,a.FVid)#_Cat#' - '#_Cat#c.FVnombre as Vendedor
	from VentaE a
		inner join ClienteDetallista b
			on a.CDid = b.CDid
		inner join FVendedores c
			on a.FVid = c.FVid
	where a.Ecodigo = #session.Ecodigo#
		and estado = 30
		<cfif isdefined("form.fCliente") and len(trim(form.fCliente)) >
			and upper(nombre_cliente) like  upper('%#form.fCliente#%')
		</cfif>
		<cfif isdefined("form.fCedula") and len(trim(form.fCedula)) >
			and upper(cedula_cliente) like  upper('%#form.fCedula#%')
		</cfif>
</cfquery>

<cf_templateheader title="Facturaci&oacute;n - Revisi&oacute;n de Cr&eacute;dito">
	<cfinclude template="../../portlets/pNavegacion.cfm">
		<cf_web_portlet_start titulo="Revisi&oacute;n de Cr&eacute;dito">
			<cfinclude template="revisionCredito-filtro.cfm">

			<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet">
				<cfinvokeargument name="query" 				value="#rsLista#"/>
				<cfinvokeargument name="desplegar" 			value="Vendedor, nombre_cliente, cedula_cliente, fecha, total_productos, Disponible"/>
				<cfinvokeargument name="etiquetas"		 	value="Vendedor, Cliente, C&eacute;dula, Fecha, Monto de la Factura, Cr&eacute;dito Disponible"/>
				<cfinvokeargument name="formatos" 			value="V, V, V, D, M, M"/>
				<cfinvokeargument name="align" 				value="left, left, left, left, right, right"/>
				<cfinvokeargument name="ajustar" 			value="N"/>
				<cfinvokeargument name="irA" 				value="revisionCredito.cfm"/>
				<cfinvokeargument name="showEmptyListMsg" 	value="true"/>
				<cfinvokeargument name="keys" 				value="VentaID"/>
				<cfinvokeargument name="navegacion" 		value="#navegacion#"/>
				<cfinvokeargument name="maxRows" 			value="15"/>
			</cfinvoke>
		<cf_web_portlet_end>
<cf_templatefooter> 