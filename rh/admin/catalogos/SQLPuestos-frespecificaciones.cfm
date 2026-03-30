<cfparam name="action" default="Puestos.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfquery name="ABC_Puestos" datasource="#session.DSN#">
			<cfif isdefined("form.Cambio")>
				if exists (
					select 1 
					from RHDescriptivoPuesto 
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
				  		and RHPcodigo =  <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">
				)
				
					update RHDescriptivoPuesto 
					set RHDPespecificaciones = <cfqueryparam value="#form.texto#" cfsqltype="cf_sql_longvarchar">,
					BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and RHPcodigo =  <cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">
						and ts_rversion = convert(varbinary,#iif(len(trim(Form.ts_rversion)) gt 0,DE(lcase(Form.ts_rversion)),0)#)
				
				else
				
					insert RHDescriptivoPuesto
					(
						RHPcodigo, Ecodigo, BMusuario, BMfecha, RHDPespecificaciones
					)
					values(
						<cfqueryparam value="#form.RHPcodigo#" cfsqltype="cf_sql_char">,
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#form.texto#" cfsqltype="cf_sql_longvarchar">
					)
				  
				<cfset modo = 'CAMBIO'>
				  
			</cfif>
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="sel"    type="hidden" value="1">
	<input name="o" type="hidden" value="4">
	<input name="modo"   type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif modo eq 'CAMBIO'><input name="RHPcodigo" type="hidden" value="#form.RHPcodigo#"></cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>