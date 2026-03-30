<cfparam name="action" default="HomologarPuestos.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="rsvalida" datasource="#session.DSN#">
            	select RHPcodigo 
					from RHPuestosH 
					where 	RHPcodigoH  =   <cfqueryparam value="#ucase(trim(form.RHPcodigoH))#" cfsqltype="cf_sql_char">
                    and  	Ecodigo  	= 	<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
            </cfquery>
            <cfif rsvalida.recordCount GT 0>
                <cfinvoke component="sif.Componentes.Translate"
                    method="Translate"
                    Key="El_Puesto_ya_se_encuentra_asociado "
                    Default="El Puesto ya se encuentra asociado a un puesto propuesto"
                    returnvariable="El_Puesto_ya_se_encuentra_asociado"/>				
                
                <cfthrow message="#El_Puesto_ya_se_encuentra_asociado#">
			</cfif>
            
            <cftransaction>
				<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
					insert into RHPuestosH ( RHPcodigo, RHPcodigoH, Ecodigo, BMUsucodigo, BMfechaalta)
								 values ( <cfqueryparam value="#ucase(trim(form.RHPcodigo))#" cfsqltype="cf_sql_char">,
										  <cfqueryparam value="#ucase(trim(form.RHPcodigoH))#" cfsqltype="cf_sql_char">,
										  <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
										  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
										  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp"><!--- getdate()--->
										)
				</cfquery>
			</cftransaction>
		<cfelseif isdefined("form.AccionAEjecutar") and len(trim(form.AccionAEjecutar)) and trim(form.AccionAEjecutar) eq 'BORRAR' >
			<cftransaction>
				<cfquery name="ABC_RHPcodigoH" datasource="#session.DSN#">
					delete 
					from RHPuestosH 
					where 	RHPcodigo 	=   <cfqueryparam value="#ucase(trim(form.RHPcodigo))#" cfsqltype="cf_sql_char">
					and 	RHPcodigoH  =   <cfqueryparam value="#ucase(trim(form.RHPcodigoD))#" cfsqltype="cf_sql_char">
                    and  	Ecodigo  	= 	<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
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
	<input name="RHPcodigo" type="hidden" value="#form.RHPcodigo#">
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