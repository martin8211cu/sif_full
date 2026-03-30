<cfparam name="action" default="Puestos.cfm">
<cfparam name="modo" default="ALTA">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Cambio")>
			<cfquery name="RHDescPuestoConsulta" datasource="#session.DSN#">
				select 1 
				from RHDescriptivoPuesto a, RHPuestos b 
				where a.Ecodigo = b.Ecodigo and a.RHPcodigo = b.RHPcodigo
				and b.Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
			    and b.RHPcodigo =  '#form.RHPcodigo#'
			</cfquery>
			
			<cfif isdefined("RHDescPuestoConsulta") and RHDescPuestoConsulta.RecordCount GT 0>
				<cfquery name="RHPuestoObtenerCodigo" datasource="#session.DSN#">
					select RHPcodigo 
					from RHPuestos
                    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	                and RHPcodigo ='#form.RHPcodigo#'
				</cfquery>
				
				<cf_dbtimestamp
					datasource="#session.dsn#"
					table="RHDescriptivoPuesto"
					redirect="SQLPuestos-frmision.cfm"
					timestamp="#form.ts_rversion#"
					field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
					field2="RHPcodigo" type2="char" value2="#RHPuestoObtenerCodigo.RHPcodigo#">

				<cfquery name="RHDescPuestoUpdate" datasource="#session.DSN#">
					update RHDescriptivoPuesto 
					set RHDPmision = <cfqueryparam value="#form.texto#" cfsqltype="cf_sql_longvarchar">,
					 BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and RHPcodigo =  (select RHPcodigo from RHPuestos
                                          where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
										  and RHPcodigo ='#form.RHPcodigo#') 
				</cfquery>
				
				<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
					update RHPuestos 
					set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
						 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and RHPcodigo = '#form.RHPcodigo#' 
				</cfquery>
			<cfelse>
			    <cfquery name="RHPuestoObtenerCodigo" datasource="#session.DSN#">
					select RHPcodigo 
					from RHPuestos
                    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer"> 
	                and RHPcodigo ='#form.RHPcodigo#'
				</cfquery>
			    
				<cfquery name="RHDescPuestoInsert" datasource="#session.DSN#">
					insert into RHDescriptivoPuesto
						(RHPcodigo, Ecodigo, BMusuario, BMfecha, RHDPmision)
					values(
						<cfqueryparam value="#RHPuestoObtenerCodigo.RHPcodigo#" cfsqltype="cf_sql_char">,
						<cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,
						<cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">,
						<cfqueryparam value="#form.texto#" cfsqltype="cf_sql_longvarchar">)
				</cfquery>
				
				<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
					update RHPuestos 
					set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
						 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
					where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
						and RHPcodigo = '#form.RHPcodigo#' 
				</cfquery>				
				
			</cfif>


			<cfset modo = 'CAMBIO'>
		</cfif>
	<cfcatch type="any">
		<cfinclude template="/sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>	

<cfoutput>
<form action="#action#" method="post" name="sql">
	<input name="sel"    type="hidden" value="1">
	<input name="o" type="hidden" value="2">
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