<cfparam name="action" default="Grados.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cftransaction>
				<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
					insert into RHGrados ( RHFid, RHGcodigo, RHGdescripcion,RHGporcvalorfactor, BMUsucodigo, BMfechaalta)
								 values ( <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#ucase(trim(form.RHGcodigo))#" cfsqltype="cf_sql_char">,
										  <cfqueryparam value="#form.RHGdescripcion#" cfsqltype="cf_sql_varchar">,
										  0,
										  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!--- getdate()--->
										)
				</cfquery>
				<cfinvoke
					Component= "rh.Componentes.RH_CalculoGrados"
					method="CalculoGrados">
					<cfinvokeargument name="RHFid" value="#form.RHFid#"/>	
				</cfinvoke>
			</cftransaction>
		<cfelseif isdefined("form.Cambio")>
			
			<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
				update RHGrados
				set RHGcodigo  = <cfqueryparam value="#ucase(trim(form.RHGcodigo))#" cfsqltype="cf_sql_char">,
				RHGdescripcion = <cfqueryparam value="#form.RHGdescripcion#" cfsqltype="cf_sql_varchar">,
				BMUsucodigo    = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
				BMfechaalta    = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!---getdate()--->
				where  RHFid      = <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
				and RHGid      = <cfqueryparam value="#form.RHGid#" cfsqltype="cf_sql_numeric">
			</cfquery>
		    <cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Baja")>
			<cftransaction>
				<cfquery name="ABC_RHGrados" datasource="#session.DSN#">
					delete 
					from RHGrados 
					where RHFid = <cfqueryparam value="#form.RHFid#" cfsqltype="cf_sql_numeric">
					and RHGid      = <cfqueryparam value="#form.RHGid#" cfsqltype="cf_sql_numeric">
				</cfquery>
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
			</cftransaction>
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
	<input name="RHFid" type="hidden" value="#form.RHFid#">
	<cfif modo eq 'CAMBIO'><input name="RHGid" type="hidden" value="#form.RHGid#"></cfif>
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