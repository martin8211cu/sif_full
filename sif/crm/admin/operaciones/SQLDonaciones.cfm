<cfparam name="action" default="Donaciones.cfm">
<cfparam name="modo" default="CAMBIO">
<cfparam name="dmodo" default="ALTA">

<cfif not isdefined("form.NuevoD")>

	<cftry>
		<cfquery name="ABC_Donacion" datasource="#session.DSN#">
		set nocount on
			<!--- Caso 1: Agregar Encabezado --->
			<cfif isdefined("form.AltaE")>
				insert CRMEDonacion ( CRMEDcodigo, CRMEDdescripcion, CRMEid, CRMEDfecha, CEcodigo, Ecodigo )
				values ( <cfqueryparam value="#form.CRMEDcodigo#" cfsqltype="cf_sql_char">,
						 <cfqueryparam value="#form.CRMEDdescripcion#" cfsqltype="cf_sql_varchar">,
				         <cfqueryparam value="#form.CRMEid#" cfsqltype="cf_sql_numeric">, 
						 convert( datetime, <cfqueryparam value="#form.CRMEDfecha#" cfsqltype="cf_sql_varchar">, 103 ),
						 <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#session.Ecodigo#"  cfsqltype="cf_sql_integer">
					   )
				select @@identity as id

			<!--- Caso 2: Borrar un Encabezado de Requisicion --->
			<cfelseif isdefined("form.BajaE")>
				delete from CRMDDonacion
				where CRMEDid = <cfqueryparam value="#form.CRMEDid#" cfsqltype="cf_sql_numeric">
				and CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
				and Ecodigo = <cfqueryparam value="#session.Ecodigo#"   cfsqltype="cf_sql_integer">
				
				delete from CRMEDonacion
				where CRMEDid = <cfqueryparam value="#form.CRMEDid#" cfsqltype="cf_sql_numeric">
				and CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
				and Ecodigo = <cfqueryparam value="#session.Ecodigo#"   cfsqltype="cf_sql_integer">

				<cfset action = "listaDonaciones.cfm">
				<cfset modo="ALTA">
				  
			<!--- Caso 3: Agregar Detalle de Solicitud y opcionalmente modificar el encabezado --->
			<cfelseif isdefined("form.AltaD")>
			
				insert CRMDDonacion ( CRMEDid, CRMEid, CRMDDdescripcion, CRMDDtipopago, CRMDmonto, CEcodigo, Ecodigo)
				values ( <cfqueryparam value="#form.CRMEDid#" cfsqltype="cf_sql_numeric">, 
						 <cfqueryparam value="#form.CRMEid2#" cfsqltype="cf_sql_numeric">, 
						 <cfqueryparam value="#form.CRMDDdescripcion#" cfsqltype="cf_sql_varchar">,
				         <cfqueryparam value="#form.CRMDDtipopago#" cfsqltype="cf_sql_char">, 
				         <cfqueryparam value="#form.CRMDmonto#" cfsqltype="cf_sql_money">, 
						 <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">,
						 <cfqueryparam value="#session.Ecodigo#"  cfsqltype="cf_sql_integer">
					   )

				<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->
				update CRMEDonacion
				set CRMEDcodigo = <cfqueryparam value="#form.CRMEDcodigo#" cfsqltype="cf_sql_char">,
				    CRMEDdescripcion = <cfqueryparam value="#form.CRMEDdescripcion#" cfsqltype="cf_sql_varchar">,
				    CRMEid          = <cfqueryparam value="#form.CRMEid#" cfsqltype="cf_sql_numeric">, 
					CRMEDfecha       = convert( datetime, <cfqueryparam value="#form.CRMEDfecha#" cfsqltype="cf_sql_varchar">, 103 )
				where CRMEDid  = <cfqueryparam value="#form.CRMEDid#" cfsqltype="cf_sql_numeric">
				  and CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
				  and Ecodigo  = <cfqueryparam value="#session.Ecodigo#"   cfsqltype="cf_sql_integer">

			<!--- Caso 4: Modificar Detalle de Requisicion y opcionalmente modificar el encabezado --->			
			<cfelseif isdefined("form.CambioD")>
				update CRMDDonacion
				set CRMEid           = <cfqueryparam value="#form.CRMEid2#" cfsqltype="cf_sql_numeric">, 
					CRMDDdescripcion = <cfqueryparam value="#form.CRMDDdescripcion#" cfsqltype="cf_sql_varchar">,
				    CRMDDtipopago    = <cfqueryparam value="#form.CRMDDtipopago#" cfsqltype="cf_sql_char">, 
				    CRMDmonto        = <cfqueryparam value="#form.CRMDmonto#" cfsqltype="cf_sql_money"> 
				where CRMDDid = <cfqueryparam value="#form.CRMDDid#" cfsqltype="cf_sql_numeric">
				  and CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
				  and Ecodigo = <cfqueryparam value="#session.Ecodigo#"   cfsqltype="cf_sql_integer">

				update CRMEDonacion
				set CRMEDcodigo = <cfqueryparam value="#form.CRMEDcodigo#" cfsqltype="cf_sql_char">,
					CRMEDdescripcion = <cfqueryparam value="#form.CRMEDdescripcion#" cfsqltype="cf_sql_varchar">,
				    CRMEid          = <cfqueryparam value="#form.CRMEid#" cfsqltype="cf_sql_numeric">, 
					CRMEDfecha       = convert( datetime, <cfqueryparam value="#form.CRMEDfecha#" cfsqltype="cf_sql_varchar">, 103 )
				where CRMEDid  = <cfqueryparam value="#form.CRMEDid#" cfsqltype="cf_sql_numeric">
				  and CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
				  and Ecodigo  = <cfqueryparam value="#session.Ecodigo#"   cfsqltype="cf_sql_integer">

				<cfset dmodo = "CAMBIO">
				
			<!--- Caso 5: Borrar detalle de Requisicion --->
			<cfelseif isdefined("Form.BajaD")>
				delete from CRMDDonacion
				where CRMDDid = <cfqueryparam value="#form.CRMDDid#" cfsqltype="cf_sql_numeric">
				and CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype="cf_sql_numeric">
				and Ecodigo = <cfqueryparam value="#session.Ecodigo#"   cfsqltype="cf_sql_integer">

				<cfset action = "Donaciones.cfm">
			</cfif>
			set nocount off				
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset action = "Donaciones.cfm" >
</cfif>	

<cfif not isdefined("form.CRMEDid") >
	<cfset form.CRMEDid = "#ABC_Donacion.id#">
</cfif>

<cfoutput>
<form action="#action#"    method="post" name="sql">
	<input name="modo"     type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="CRMEDid"  type="hidden" value="<cfif isdefined("form.CRMEDid")>#Form.CRMEDid#</cfif>">
	<cfif dmodo neq 'ALTA' >
		<input name="CRMDDid"  type="hidden" value="<cfif isdefined("Form.CRMDDid")>#Form.CRMDDid#</cfif>">
	</cfif>
	<input name="Pagina"   type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>