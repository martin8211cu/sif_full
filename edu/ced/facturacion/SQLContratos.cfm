<cfset action = "Contratos.cfm">
<!--- Rodolfo Jimenez Jara, Soluciones Integrales S.A., Costa Rica, America Central, 26/06/2003 --->

 <cfif not isdefined("form.btnNuevoD") and  not isdefined("form.btnNuevoE")>
	<cftry>
		<cfset modo="CAMBIO">
		<cfquery name="ABC_Contratos" datasource="#Session.Edu.DSN#">
			set nocount on
			<!--- Caso 1: Agregar Encabezado --->
			<cfif isdefined("Form.btnAgregarE")>
				set nocount on
				if not exists ( select 1 from ContratoEdu 
					where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
					  and rtrim(ltrim(CEcontrato)) = <cfqueryparam value="#Form.CEcontrato#" cfsqltype="cf_sql_char">
				)
				begin 
					insert ContratoEdu (CEcontrato,CEcodigo,CEdescripcion,CEcuenta,CEtitular)
						values (<cfqueryparam cfsqltype="cf_sql_char" value="#form.CEcontrato#">,
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEdescripcion#">,
								<cfqueryparam cfsqltype="cf_sql_char" value="#form.CEcuenta#" >,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CEtitular#" >
								)
					set nocount off
				end
				else
					select 1
					<cfset modoDet="ALTA">
					<cfset modo="ALTA">
			<!--- Caso 1.1: Cambia Encabezado --->
			<cfelseif isdefined("Form.btnCambiarE") >
				update ContratoEdu
				set CEdescripcion = <cfqueryparam value="#form.CEdescripcion#" cfsqltype="cf_sql_varchar">,
				CEcuenta = <cfqueryparam value="#form.CEcuenta#" cfsqltype="cf_sql_char">,
				CEtitular = <cfqueryparam value="#form.CEtitular#" cfsqltype="cf_sql_varchar">
				where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
				  and CEcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CEcontrato#">

				<cfset modo="CAMBIO">  
				<cfset modoDet="ALTA">
			
			<!--- Caso 2: Borrar un Encabezado  --->
			
			<cfelseif isdefined("Form.btnBorrarE")>			
				<cfif isdefined("Form.CEcontrato") AND Form.CEcontrato NEQ "" >
					
					Update Alumnos
					set CEcontrato = null
					where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
					  and CEcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CEcontrato#">
					
					delete ContratoEdu 
					where CEcontrato=<cfqueryparam value="#form.CEcontrato#" cfsqltype="cf_sql_char">				
					  and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
					  
					<cfset action = "listaContratos.cfm">
					<cfset modo = "ALTA">
					<cfset modoDet="ALTA">
				</cfif>
				<!--- Caso 3: Agregar Detalle de MAAtributo y opcionalmente modificar el encabezado --->
			<cfelseif isdefined("Form.btnAgregarD")>
				update ContratoEdu
				set CEdescripcion = <cfqueryparam value="#form.CEdescripcion#" cfsqltype="cf_sql_varchar">,
				CEcuenta = <cfqueryparam value="#form.CEcuenta#" cfsqltype="cf_sql_char">,
				CEtitular = <cfqueryparam value="#form.CEtitular#" cfsqltype="cf_sql_varchar">
				where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
				  and CEcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CEcontrato#">
				
			
				<cfif isdefined("Form.CEcontrato") AND Form.CEcontrato NEQ "" >
					Update Alumnos
					set CEcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CEcontrato#">
					where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
				
					<cfset modoDet="ALTA">
				</cfif>
			<cfelseif isdefined("Form.btnBorrarD")>
				update ContratoEdu
				set CEdescripcion = <cfqueryparam value="#form.CEdescripcion#" cfsqltype="cf_sql_varchar">,
				CEcuenta = <cfqueryparam value="#form.CEcuenta#" cfsqltype="cf_sql_char">,
				CEtitular = <cfqueryparam value="#form.CEtitular#" cfsqltype="cf_sql_varchar">
				where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
				  and CEcontrato = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CEcontrato#">

				Update Alumnos
				set CEcontrato = null
				where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ecodigo#">
				<cfset modoDet="ALTA">
			</cfif>
			set nocount off					
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>		
<cfelseif isdefined("form.btnNuevoD") and not  isdefined("form.btnNuevoE")>
		<cfset modo    = "CAMBIO">
		<cfset modoDet = "ALTA">
<cfelseif isdefined("form.btnNuevoE")>
  		<cfset modo    = "ALTA">
		<cfset modoDet = "ALTA">
</cfif>

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">
	<cfif modo  NEQ "ALTA">
		<input name="CEcontrato" type="hidden" value="<cfif isdefined("form.CEcontrato")>#Form.CEcontrato#</cfif>">
	</cfif>
	<cfif modoDet EQ "CAMBIO">
		<!--- <input name="CEcontrato" type="hidden" value="<cfif isdefined("form.CEcontrato")>#Form.CEcontrato#</cfif>"> --->
		<input name="Ecodigo" type="hidden" value="<cfif modoDet EQ "CAMBIO">#Form.Ecodigo#</cfif>">
	</cfif>
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
		