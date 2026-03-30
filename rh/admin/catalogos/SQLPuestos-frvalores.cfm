<cfparam name="action" default="Puestos.cfm">
<cfparam name="modo" default="CAMBIO">

<cfif not isdefined("form.btnNuevo")>
	<cftry>
		<cfif isdefined("form.Cambio")>
			<cfquery name="RHRHPuestosUpdate" datasource="#session.DSN#">
				update RHPuestos 
				set  BMusumod = <cfqueryparam value="#session.usucodigo#" cfsqltype="cf_sql_numeric">,
					 BMfechamod = <cfqueryparam value="#now()#" cfsqltype="cf_sql_timestamp">
				where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer">
					and RHPcodigo = '#form.RHPcodigo#' 
			</cfquery>
			<cfquery name="RHValPuestoDel" datasource="#session.DSN#">
				delete from RHValoresPuesto
				where RHPcodigo = '#form.RHPcodigo#'
				  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>			
			<cfif isdefined("form.RHCGidList") and len(trim(form.RHCGidList)) gt 0>
				<cfset arrayKeys = ListToArray(form.RHCGidList)>
				<cfloop from="1" to="#ArrayLen(arrayKeys)#" index="i">
					<cfset datos = ListToArray(arrayKeys[i],'|')>
					<cfquery name="RHValPuestoConsulta" datasource="#session.DSN#">
						select 1
						from RHValoresPuesto
						where RHPcodigo = '#form.RHPcodigo#'
						  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and RHECGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">
						  and RHDCGid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[2]#">
					</cfquery>
					<cfif isdefined("RHValPuestoConsulta") and RHValPuestoConsulta.RecordCount Eq 0>
						<cfquery name="RHValPuestoInsert" datasource="#session.DSN#">
							insert into RHValoresPuesto
							(RHPcodigo, Ecodigo, RHECGid, RHDCGid,RHVPtipo)
							values(<cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigo#">,
								   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
								   <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[1]#">,
								   <cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[2]#">,
								   <cfif datos[3] neq '00'>
								   	<cfqueryparam cfsqltype="cf_sql_numeric" value="#datos[3]#">
								   <cfelse>
								    null
								   </cfif>)
								   
						</cfquery>
					</cfif>

				</cfloop>

			</cfif>
	
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
	<input name="o" type="hidden" value="7">
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