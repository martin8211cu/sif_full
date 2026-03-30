<cfparam name="action" default="Factores.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
				insert into RHFactores ( Ecodigo, RHFcodigo, RHFdescripcion,RHFponderacion,Puntuacion, BMUsucodigo, BMfechaalta)
				 values ( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						  <cfqueryparam value="#ucase(trim(form.RHFcodigo))#" cfsqltype="cf_sql_char">,
						  <cfqueryparam value="#form.RHFdescripcion#" cfsqltype="cf_sql_varchar">,
						  <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHFponderacion, ',', '', 'all')#">,
						  <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.Puntuacion, ',', '', 'all')#">,
						  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!--- getdate()--->
						)
			</cfquery>
		<cfelseif isdefined("form.Cambio")>
			<cftransaction>
				<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
					update RHFactores
					set RHFcodigo  = <cfqueryparam value="#ucase(trim(form.RHFcodigo))#" cfsqltype="cf_sql_char">,
					RHFdescripcion = <cfqueryparam value="#form.RHFdescripcion#" cfsqltype="cf_sql_varchar">,
					RHFponderacion = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.RHFponderacion, ',', '', 'all')#">,
					Puntuacion     = <cfqueryparam cfsqltype="cf_sql_float" value="#Replace(form.Puntuacion, ',', '', 'all')#">,
					BMUsucodigo    = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfechaalta    = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
					where Ecodigo  = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and RHFid      = <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
				</cfquery>
				<cfif PuntuacionActual neq #Replace(form.Puntuacion, ',', '', 'all')#>
					<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
						update RHGrados
						set RHGporcvalorfactor  = 0
						where  RHFid      = <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
					</cfquery>
					<cfinvoke
						Component= "rh.Componentes.RH_CalculoGrados"
						method="CalculoGrados">
						<cfinvokeargument name="RHFid" value="#form.RHFid#"/>	
					</cfinvoke>
				</cfif>
			</cftransaction>
		    <cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Baja")>
			<cfquery name="ABC_RHGrados" datasource="#session.DSN#">
				delete 
				from RHGrados 
				where RHFid = <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
			</cfquery>
			<cfquery name="ABC_Puestos_deleteB" datasource="#session.DSN#">
				delete from RHFactores
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHFid =  <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
			</cfquery>			
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="RHFid" type="hidden" value="#form.RHFid#"></cfif>
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