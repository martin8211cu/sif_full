<cfparam name="action" default="listaAjuste.cfm">

<!---  Se va a aplicar un documento?? --->
<cfif isdefined("form.btnAplicar") >
	<cftry>
		<cfstoredproc procedure="IN_AjusteInventario" datasource="#session.DSN#">
			<cfprocparam cfsqltype="cf_sql_integer" dbvarname="@ID"      value="#form.EAid#" type="in">
			<cfprocparam cfsqltype="cf_sql_integer" dbvarname="@Ecodigo" value="#Session.Ecodigo#" type="in">
			<cfprocparam cfsqltype="cf_sql_varchar" dbvarname="@usuario" value="#Session.usuario#" type="in">
			<cfprocparam cfsqltype="cf_sql_char"    dbvarname="@debug"   value="N" type="in">
		</cfstoredproc>
		<cfcatch type="database">
			<cfset params = "errType=0&errMsg=" & UrlEncodedFormat(cfcatch.Detail)>
			<cflocation addtoken="no" url="../../errorPages/BDerror.cfm?#params#">
			<cfabort>
		</cfcatch>
	</cftry>
	
	<cflocation addtoken="no" url="listaAjuste.cfm">

</cfif>

<cfif not isdefined("form.btnNuevoD")>

	<cftry>
		<cfquery name="ABC_Ajuste" datasource="#session.DSN#">
			
			<!--- Caso 1: Agregar Encabezado --->
			<cfif isdefined("Form.btnAgregarE")>

				set nocount on
				insert EAjustes ( Aid, EAdescripcion, EAdocumento, EAfecha, EAusuario )
							 values ( <cfqueryparam value="#Form.Aid#" 			 cfsqltype="cf_sql_numeric">,
									  <cfqueryparam value="#Form.EAdescripcion#" cfsqltype="cf_sql_varchar">,
									  <cfqueryparam value="#Form.EAdocumento#"   cfsqltype="cf_sql_char">, 
									  convert( datetime, <cfqueryparam value="#Form.EAfecha#" cfsqltype="cf_sql_varchar">, 103 ),
									  <cfqueryparam value="#session.usuario#"    cfsqltype="cf_sql_varchar">
									)
				select @@identity as id
				set nocount off				

				<cfset modo="CAMBIO">
				<cfset action = "Ajustes.cfm">
				
			<!--- Caso 2: Borrar un Encabezado de Requisicion --->
			<cfelseif isdefined("Form.btnBorrarE")>
				
				delete DAjustes
				where EAid = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
				
				delete EAjustes
				where EAid    = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">

				  <cfset modo="ALTA">
				  
			<!--- Caso 3: Agregar Detalle de Requisicion y opcionalmente modificar el encabezado --->
			<cfelseif isdefined("Form.btnAgregarD")>
			
				insert DAjustes ( EAid, Aid, DAcantidad, DAcosto, DAtipo )
							 values ( <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">,
									  <cfqueryparam value="#Form.aAid#" cfsqltype="cf_sql_numeric">,
									  <cfqueryparam value="#Replace(Form.DAcantidad,',','','all')#" cfsqltype="cf_sql_float">,
									  convert(money, <cfqueryparam value="#Form.DAcosto#" cfsqltype="cf_sql_varchar">),
									  <cfqueryparam value="#Form.DAtipo#"  cfsqltype="cf_sql_integer">
									)

				<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->
				<cfif #form.EAdescripcion# NEQ #form.bdEAdescripcion# or 
					  #form.EAfecha# NEQ #form.bdEAfecha# or 
					  #form.Aid# NEQ #form.bdAid# or 
					  #form.EAdocumento# NEQ #form.bdEAdocumento# >

							update EAjustes
							set EAdescripcion = <cfqueryparam value="#Form.EAdescripcion#" cfsqltype="cf_sql_varchar">,
								Aid           = <cfqueryparam value="#Form.Aid#"           cfsqltype="cf_sql_integer">,
								EAdocumento   = <cfqueryparam value="#Form.EAdocumento#"   cfsqltype="cf_sql_char">,
								EAfecha       = convert( datetime, <cfqueryparam value="#Form.EAfecha#"       cfsqltype="cf_sql_varchar">, 103 )
							where EAid      = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
							  and timestamp = convert(varbinary,#lcase(Form.timestamp)#)
				</cfif>
				<cfset modo="CAMBIO">
				<cfset action = "Ajustes.cfm">

			<!--- Caso 4: Modificar Detalle de Requisicion y opcionalmente modificar el encabezado --->			
			<cfelseif isdefined("Form.btnCambiarD")>

				update DAjustes
				set Aid    = <cfqueryparam value="#Form.aAid#" cfsqltype="cf_sql_numeric">, 
				DAcantidad = <cfqueryparam value="#Replace(Form.DAcantidad,',','','all')#" cfsqltype="cf_sql_float">,
				DAcosto    = convert(money, <cfqueryparam value="#Form.DAcosto#" cfsqltype="cf_sql_varchar">),
				DAtipo     = <cfqueryparam value="#Form.DAtipo#" cfsqltype="cf_sql_integer">
				where EAid      = <cfqueryparam value="#Form.EAid#"    cfsqltype="cf_sql_numeric">
				  and DALinea   = <cfqueryparam value="#Form.DAlinea#" cfsqltype="cf_sql_numeric">
				  and timestamp = convert(varbinary,#lcase(Form.dtimestamp)#)

				<!--- Modificar Encabezado, unicamente si se modifico alguno de los campos --->
				<cfif #form.EAdescripcion# NEQ #form.bdEAdescripcion# or 
					  #form.EAfecha# NEQ #form.bdEAfecha# or 
					  #form.Aid# NEQ #form.bdAid# or
					  #form.EAdocumento# NEQ #form.bdEAdocumento# >

							update EAjustes
							set EAdescripcion = <cfqueryparam value="#Form.EAdescripcion#" cfsqltype="cf_sql_varchar">,
								Aid           = <cfqueryparam value="#Form.Aid#"       cfsqltype="cf_sql_integer">,
								EAdocumento   = <cfqueryparam value="#Form.EAdocumento#"   cfsqltype="cf_sql_char">,								
								EAfecha       = convert( datetime, <cfqueryparam value="#Form.EAfecha#"       cfsqltype="cf_sql_varchar">, 103 )
							where EAid      = <cfqueryparam value="#Form.EAid#" cfsqltype="cf_sql_numeric">
							  and timestamp = convert(varbinary,#lcase(Form.timestamp)#)
				</cfif>
				<cfset modo="CAMBIO">
				<cfset action = "Ajustes.cfm">
				
			<!--- Caso 5: Borrar detalle de Requisicion --->
			<cfelseif isdefined("Form.btnBorrarD")>
	
				delete DAjustes
				where EAid      = <cfqueryparam value="#Form.EAid#"    cfsqltype="cf_sql_numeric">
				  and DALinea   = <cfqueryparam value="#Form.DAlinea#" cfsqltype="cf_sql_numeric">
	
				<cfset modo="CAMBIO">
				<cfset action = "Ajustes.cfm">

			</cfif>
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
<cfelse>
	<cfset action = "Ajustes.cfm" >
	<cfset modo   = "CAMBIO" >
</cfif>	

<cfif isdefined("form.EAid") AND form.EAid EQ "" >
	<cfset form.EAid = "#ABC_Ajuste.id#">
</cfif>


<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="EAid"   type="hidden" value="<cfif isdefined("Form.EAid")>#form.EAid#</cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")>#Form.Pagina#</cfif>">
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>