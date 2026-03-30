<!---------
	Creado por: Ana Villavicencio
	Fecha de modificación: 05 de julio del 2005
	Motivo:	Se agregó un nuevo botón para listar nuevas solicitudes a agregar en la orden de pago
		paso = 3
----------->
<cfinvoke key="LB_Titulo" default="Ordenes de Pago"	returnvariable="LB_Titulo"	method="Translate"
component="sif.Componentes.Translate"  xmlfile="ordenesPago.xml"/>

<cf_navegacion name="PASO" default="0" navegacion="">
<cf_navegacion name="TESOPid" navegacion="">

<cfif isdefined("Session.Menues")>
	<cfif isdefined("Session.Menues.SPCODIGO") and Session.Menues.SPCODIGO EQ "TOP_001">
		<cfset Session.Tesoreria.ordenesPagoIrLista = "">
	</cfif>
</cfif>

<cfset GvarDetalleGrande = false>
<!----<cfif form.PASO EQ "10">
	<cfquery datasource="#session.dsn#" name="rsDetalle">
		select count(1) cantidad
		  from TESdetallePago dp
		 where dp.TESOPid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESOPid#">
	</cfquery>
	<cfset GvarDetalleGrande = (rsDetalle.cantidad GT 50)>
	<cfif GvarDetalleGrande>
		<cf_templatecss>
		<cf_templateheader title="#LB_Titulo#">
		<cfinclude template="ordenesPago_form.cfm">
		<cf_templatefooter>
		<cfabort>
	</cfif>
</cfif>--->

<cf_templateheader title="#LB_Titulo#">
	<cfif form.PASO EQ 0>
	  <cfinclude template="ordenesPago_lista.cfm">
	  <cfelseif form.PASO EQ 10>
		<cfinclude template="ordenesPago_form.cfm">
	<cfelseif form.PASO EQ 11>
		<cfinclude template="ordenesPago_manual.cfm">
	<cfelseif form.PASO EQ 1>
		<cfinclude template="ordenesPago_lista1Sel.cfm">
	<cfelseif form.PASO EQ 2>
		<cfinclude template="ordenesPago_lista2Gen.cfm">
	<cfelseif form.PASO EQ 3>
		<cfinclude template="ordenesPago_listaSolic.cfm">
</cfif>
<cf_templatefooter>

