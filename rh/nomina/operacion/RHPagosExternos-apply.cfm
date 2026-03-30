<cfinvoke component="rh.Componentes.RH_ValidaAcceso" method="validarAcceso">

<cfif IsDefined("form.Alta")>	
	<cfquery datasource="#session.dsn#" name="valido"><!--- valida si el registro que se quiere modificar o eliminar se realiza en la misma fecha--->
			Select 1 
			from RHPagosExternos pe
			where pe.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and pe.DEid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
			and pe.PEXfechaPago=<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSparseDateTime(form.PEXfechapago)#">
	</cfquery>
	<cfif valido.RecordCount GT 0>
			<cfinvoke key="LB_HeadEr" default="No se puede registrar el pago"	 returnvariable="LB_HeadEr" component="sif.Componentes.Translate" method="Translate" />
		<cfinvoke key="LB_TitleEr" default="El pago ya fue ingresado con la fecha indicada"	 returnvariable="LB_TitleEr" component="sif.Componentes.Translate" method="Translate" />
		<cfinvoke key="LB_DetalleErr" default="Existe un pago registrado<br>Al empleado: #form.DENombreCompleto# <br>En la fecha: #form.PEXfechapago#"	 returnvariable="LB_DetalleErr" component="sif.Componentes.Translate" method="Translate" />
		<cflocation url="/cfmx/sif/errorPages/BDerror.cfm?ErrTitle=#LB_HeadEr#&errType=0&ErrMsg=#LB_TitleEr#<br>&ErrDet=#URLEncodedFormat(LB_DetalleErr)#" addtoken="no">
		<cfabort>
	</cfif>
</cfif>

<cfif IsDefined("form.Cambio") >	
<!--- modificado en notepad para incluir el boom --->
	<cfinvoke component="RHPagosExternos"
		method="Cambio" >
		<cfinvokeargument name="PEXid" value="#form.PEXid#">
		<cfinvokeargument name="PEXTid" value="#form.PEXTid#">
		<cfinvokeargument name="DEid" value="#form.DEid#">
		<cfinvokeargument name="PEXmonto" value="#Replace(form.PEXmonto,',','','all')#">
		<cfinvokeargument name="PEXfechaPago" value="#form.PEXfechaPago#">
		<cfinvokeargument name="ts_rversion" value="#form.ts_rversion#">
	</cfinvoke>

	<cflocation url="RHPagosExternos.cfm?PEXid=#URLEncodedFormat(form.PEXid)#">

<cfelseif IsDefined("form.Baja")>

	<cfinvoke component="RHPagosExternos"
		method="Baja" >
		<cfinvokeargument name="PEXid" value="#form.PEXid#">
	</cfinvoke>

<cfelseif IsDefined("form.Alta")>	
	<cfinvoke component="RHPagosExternos" 
		returnvariable="lvarPEXid"
		method="Alta"  >
		<cfinvokeargument name="PEXTid" value="#form.PEXTid#">
		<cfinvokeargument name="DEid" value="#form.DEid#">
		<cfinvokeargument name="PEXmonto" value="#Replace(form.PEXmonto,',','','all')#">
		<cfinvokeargument name="PEXfechaPago" value="#form.PEXfechaPago#">
	</cfinvoke>
	
	<cflocation url="RHPagosExternos.cfm?PEXid=#URLEncodedFormat(lvarPEXid)#">
	
<cfelse>
	<!--- Tratar como form.nuevo --->
</cfif>

<cflocation url="RHPagosExternos.cfm">