<cfset Action = "Clasificacion.cfm">
<!--- MODO en que se regresa al form --->
<cfif isDefined("form.btnLista")>
	<cflocation url="Clasificacion-lista.cfm">
	<cfabort>
</cfif>

<cfset MODO = "ALTA">
<!--- si viene definido el boton de nuevo regresa al form en modo ALTA --->
<cfif not (isDefined("form.Nuevo") or isDefined("form.DNuevo"))>
			<cfif isDefined("form.Alta")>
				<cftransaction>			
					<cfquery name="ABC_Clasificacion" datasource="#Session.DSN#">
						insert into PCClasificacionE(CEcodigo ,PCCEcodigo, PCCEdescripcion ,PCCEempresa, PCCEactivo,   BMUsucodigo)	
						values(<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCCEcodigo#">, 
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCCEdescripcion#">, 
								<cfif isDefined("form.PCCEempresa")>1<cfelse>0</cfif>, 
								<cfif isDefined("form.PCCEactivo")>1<cfelse>0</cfif>, 
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
							 )
						 <cf_dbidentity1 datasource="#Session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_Clasificacion">
				</cftransaction>
				<cfset Form.PCCEclaid = ABC_Clasificacion.identity>
				<!--- Define Volver al form en MODO CAMBIO --->
				<cfset MODO = "CAMBIO">
				
			<cfelseif (isDefined("form.Cambio") or isDefined("form.DCambio") or isDefined("form.DAlta"))  and isDefined("form.PCCEclaid") and len(trim(form.PCCEclaid)) gt 0>
				<!--- REALIZA LA ACTUALIZACION DEL ENCABEZADO --->
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="PCClasificacionE" 
					redirect="#Action#"
					timestamp="#form.ts_rversion#"
					field1="PCCEclaid,numeric,#form.PCCEclaid#">
				
				<cftransaction>
					<cfquery name="C_Clasificacion" datasource="#Session.DSN#">
						update PCClasificacionE
						set CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">, 
							PCCEcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCCEcodigo#">, 
							PCCEdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCCEdescripcion#">, 
							PCCEempresa = <cfif isDefined("form.PCCEempresa")>1<cfelse>0</cfif>, 
							PCCEactivo = <cfif isDefined("form.PCCEactivo")>1<cfelse>0</cfif> ,
							BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
						where PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaid#">
					</cfquery>
				</cftransaction>
				<cfset MODO = "CAMBIO">
				
			<cfelseif isDefined("form.Baja")  and isDefined("form.PCCEclaid") and len(trim(form.PCCEclaid)) gt 0>
				<cftransaction>
					<cfquery name="B1_Clasificacion" datasource="#Session.DSN#">
						delete 
						from PCClasificacionD
						where PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaid#">
					</cfquery>
					
					<cfquery name="B2_Clasificacion" datasource="#Session.DSN#">
						delete from PCClasificacionE
						where PCCEclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaid#">
					</cfquery>
				</cftransaction>
				
				<cfset Action = "Clasificacion-lista.cfm">
			</cfif>

			<cfif isDefined("form.DAlta") and isDefined("form.PCCEclaid") and len(trim(form.PCCEclaid)) gt 0>
				<cftransaction>
					<cfquery name="A_Clasificacion" datasource="#Session.DSN#">
						insert into PCClasificacionD(PCCEclaid, Ecodigo, PCCDactivo, PCCDvalor, PCCDdescripcion, Usucodigo)
						values ( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCEclaid#">,
								 <cfif isdefined("form.PCCEempresa")><cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"><cfelse>null</cfif>,
								 <cfif (isDefined("form.PCCDactivo"))>1<cfelse>0</cfif>,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCCDvalor#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCCDdescripcion#">,
								 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
						)
						<cf_dbidentity1 name="A_Clasificacion" datasource="#Session.DSN#">
					</cfquery>
					<cf_dbidentity2 name="A_Clasificacion" datasource="#Session.DSN#">
				
				</cftransaction>

				<cfset MODO = "CAMBIO">
				
			<cfelseif isDefined("form.DCambio") and isDefined("form.PCCDclaid") and len(trim(form.PCCDclaid)) gt 0>
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="PCClasificacionD" 
					redirect="#Action#"
					timestamp="#form.dtimestamp#"
					field1="PCCDclaid,numeric,#form.PCCDclaid#">			
			
				<cftransaction>
					<cfquery name="C_PCClasificacionD" datasource="#Session.DSN#">
						update PCClasificacionD
						set PCCDactivo 	   = <cfif (isDefined("form.PCCDactivo"))>1<cfelse>0</cfif>, 
							PCCDvalor 	   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCCDvalor#">, 
							PCCDdescripcion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.PCCDdescripcion#">, 
							Usucodigo      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
							Ecodigo        = <cfif isdefined("form.PCCEempresa")><cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"><cfelse>null</cfif>
						where PCCDclaid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCDclaid#">				
					</cfquery>

				</cftransaction>
				
				<cfset MODO = "CAMBIO">
				
			<cfelseif isDefined("form.DBaja") and isDefined("form.PCCDclaid") and len(trim(form.PCCDclaid)) gt 0>
				<cftransaction>
					<cfquery name="B_PCClasificacionD" datasource="#Session.DSN#">
						delete from PCClasificacionD
						where PCCDclaid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCCDclaid#">
					</cfquery>
				</cftransaction>
				
				<cfset MODO = "CAMBIO">
			</cfif>

</cfif>

<cfif isDefined("form.DNuevo")>
	<cfset MODO = "CAMBIO">
</cfif>

<form action="<cfoutput>#Action#</cfoutput>" method="post" name="form1">
	<cfoutput>
	<cfif MODO EQ "CAMBIO">
	<input name="PCCEclaid" type="hidden" value="#form.PCCEclaid#">
	</cfif>
	</cfoutput>
</form>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>