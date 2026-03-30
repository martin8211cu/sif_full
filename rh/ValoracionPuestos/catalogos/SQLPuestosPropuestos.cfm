<cfparam name="action" default="PuestosPropuestos.cfm">
<cfparam name="modo" default="ALTA">
<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Alta")>
			<cfquery name="ABC_Puestos_insert" datasource="#session.DSN#">
				insert into RHPuestos (Ecodigo,RHPcodigo,RHPdescpuesto,RHPropuesto,RHPactivo,BMusuario,BMfecha)
				 values ( <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						  <cfqueryparam value="#ucase(trim(form.RHPcodigo))#" cfsqltype="cf_sql_char">,
						  <cfqueryparam value="#form.RHPdescpuesto#" cfsqltype="cf_sql_varchar">,
						  1,
						  0,
						  <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
						  <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
						)
			</cfquery>
		<cfelseif isdefined("form.Cambio")>
			<cftransaction>
				<cfquery name="ABC_Puestos_update" datasource="#session.DSN#">
					update RHPuestos
					set 
					RHPdescpuesto  = <cfqueryparam value="#form.RHPdescpuesto#" cfsqltype="cf_sql_varchar">,
					BMusuario      = <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfecha        = <cfqueryparam value="#Now()#" cfsqltype="cf_sql_timestamp">
					where Ecodigo  = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and RHPcodigo  = <cfqueryparam value="#ucase(trim(form.RHPcodigo))#" cfsqltype="cf_sql_char">
				</cfquery>
			</cftransaction>
		    <cfset modo = 'CAMBIO'>
		<cfelseif isdefined("form.Baja")>
			<cftransaction>
				<cfquery name="ABC_RHPcodigoH" datasource="#session.DSN#">
					delete 
					from RHPuestosH 
					where 	RHPcodigo 	=   <cfqueryparam value="#ucase(trim(form.RHPcodigo))#" cfsqltype="cf_sql_char">
                    and  	Ecodigo  	= 	<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
                <cfquery name="ABC_Puestos_deleteB" datasource="#session.DSN#">
					delete from RHPuestos
                	where Ecodigo  = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
                	and RHPcodigo  = <cfqueryparam value="#ucase(trim(form.RHPcodigo))#" cfsqltype="cf_sql_char">
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
	<cfif modo eq 'CAMBIO'><input name="RHPcodigo" type="hidden" value="#form.RHPcodigo#"></cfif>
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