
<cfset action = "Edificios.cfm">
<cfif not isdefined("form.btnNuevoD") and not isdefined("form.btnNuevoE")>
	<cftry>
		<cfset modo="CAMBIO">
		<cfquery name="ABC_Edificios" datasource="#Session.DSN#">
			set nocount on
			<!--- Caso 1: Agregar Encabezado --->
	
			<cfif isdefined("Form.btnAgregarE")>
				declare @EDcodigo numeric
				
				insert Edificio (Ecodigo, EDnombre, EDcodificacion, EDprefijo,  Scodigo)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EDnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EDcodificacion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.EDprefijo#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Scodigo#">)
														
					select @EDcodigo = @@identity
					
				select @EDcodigo as id
				<!--- <cfset action = "CicloLectivo.cfm"> --->
				<cfset modo="ALTA">
				<cfset modoDet="ALTA">
			
			<!--- Caso 1.1: Cambia Encabezado --->
			<cfelseif isdefined("Form.btnCambiarE")>
				  
				update Edificio
				set EDnombre = <cfqueryparam value="#form.EDnombre#" cfsqltype="cf_sql_varchar">
				   	,EDcodificacion = <cfqueryparam value="#form.EDcodificacion#" cfsqltype="cf_sql_varchar">
				   	,EDprefijo = <cfqueryparam value="#form.EDprefijo#" cfsqltype="cf_sql_varchar">
					,Scodigo = <cfqueryparam value="#form.Scodigo#" cfsqltype="cf_sql_numeric">
				where EDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDcodigo#">
				  and ts_rversion = convert(varbinary,#lcase(form.timestampE)#)	  
				  
				<cfset modoDet="ALTA">
			
			<!--- Caso 2: Borrar un Encabezado del Edificio --->
			<cfelseif isdefined("Form.btnBorrarE")>			
				<cfif isdefined("Form.EDcodigo") AND Form.EDcodigo NEQ "" >
				  	delete Aula
					where EDcodigo = <cfqueryparam value="#form.EDcodigo#" cfsqltype="cf_sql_numeric">

					delete Edificio 
					where EDcodigo=<cfqueryparam value="#form.EDcodigo#" cfsqltype="cf_sql_numeric">
					  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">				
					
					<cfset modoDet="ALTA">									
					<cfset action = "Edificios.cfm">

				</cfif>
			<!--- Caso 3: Agregar Detalle de Edificios y opcionalmente modificar el encabezado --->
			<cfelseif isdefined("Form.btnAgregarD")>
			
				update Edificio
				set EDnombre = <cfqueryparam value="#form.EDnombre#" cfsqltype="cf_sql_varchar">
				   	,EDcodificacion = <cfqueryparam value="#form.EDcodificacion#" cfsqltype="cf_sql_varchar">
				   	,EDprefijo = <cfqueryparam value="#form.EDprefijo#" cfsqltype="cf_sql_varchar">
					,Scodigo = <cfqueryparam value="#form.Scodigo#" cfsqltype="cf_sql_numeric">
				where EDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDcodigo#">
				  and ts_rversion = convert(varbinary,#lcase(form.timestampE)#)	  
			
				insert Aula (Ecodigo, AUnombre, AUcodificacion, EDcodigo, AUcapacidad)
					values (<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AUnombre#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.AUcodificacion_text#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#form.AUcapacidad_text#">)
							
				<cfset modoDet="ALTA">									
				<cfset action = "Edificios.cfm">
											
			<!--- Caso 4: Modificar Detalle del Edificios y modificar el encabezado --->			
			<cfelseif isdefined("Form.btnCambiarD")>
					  
					update Edificio
					set EDnombre = <cfqueryparam value="#form.EDnombre#" cfsqltype="cf_sql_varchar">
						,EDcodificacion = <cfqueryparam value="#form.EDcodificacion#" cfsqltype="cf_sql_varchar">
						,EDprefijo = <cfqueryparam value="#form.EDprefijo#" cfsqltype="cf_sql_varchar">
						,Scodigo = <cfqueryparam value="#form.Scodigo#" cfsqltype="cf_sql_numeric">
					where EDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDcodigo#">
					  and ts_rversion = convert(varbinary,#lcase(form.timestampE)#)	  
					  
					update Aula 
					set AUnombre = <cfqueryparam value="#form.AUnombre#" cfsqltype="cf_sql_varchar">,
					 	AUcodificacion = <cfqueryparam value="#form.AUcodificacion_text#" cfsqltype="cf_sql_varchar">,
						AUcapacidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.AUcapacidad_text#">
					where EDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDcodigo#">
					  and AUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AUcodigo#">
					  and ts_rversion = convert(varbinary,#lcase(form.timestampD)#) 
					
				<cfset modoDet="CAMBIO">				
				
			<!--- Caso 5: Borrar detalle de tabla de Evaluacion --->
			<cfelseif isdefined("Form.btnBorrarD")>
				delete Aula
				where EDcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.EDcodigo#">
					  and AUcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.AUcodigo#">
					  and ts_rversion = convert(varbinary,#lcase(form.timestampD)#) 
				
				
				<cfset modoDet="ALTA">
				
												
			</cfif>					
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/educ/errorpages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>		
<cfelse>
	<cfif isdefined("form.btnNuevoE")>
		<cfset modo = "ALTA" >
		<cfset modoDet = "ALTA">
	<cfelseif isdefined("form.btnNuevoD")>
		<cfset modo = "CAMBIO" >
		<cfset modoDet = "ALTA">
	</cfif>
</cfif>

<cfif isdefined("Form.btnAgregarE")>
	<cfset form.EDcodigo_alta = "#ABC_Edificios.id#">
</cfif>

<cfoutput>

<form action="#action#" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="modoDet" type="hidden" value="<cfif isdefined("modoDet")>#modoDet#</cfif>">

	<cfif modo eq "CAMBIO">
		<input name="EDcodigo"  type="hidden" value="<cfif isdefined("Form.btnAgregarE")>#Form.EDcodigo_alta#<cfelse>#Form.EDcodigo#</cfif>">
		<input name="Scodigo"  type="hidden" value="<cfif isdefined("Form.Scodigo")>#Form.Scodigo#</cfif>">
	</cfif>
	<cfif modoDet eq "CAMBIO">
		<input name="AUcodigo"  type="hidden" value="<cfif isdefined("Form.AUcodigo")>#Form.AUcodigo#</cfif>">
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
