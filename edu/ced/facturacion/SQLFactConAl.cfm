<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_FactConceptosAlumno" datasource="#Session.Edu.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
				if not exists ( select 1 from FactConceptosAlumno 
					where FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
					  and CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
					  and Ecodigo =  <cfqueryparam value="#form.Ecodigo#" cfsqltype="cf_sql_numeric">
				)
				begin
					insert into FactConceptosAlumno (CEcodigo, Ecodigo, FCid, FCAmontobase,FCAdescuento,
							FCAmontores,FCAperiodicidad,FCfechainicio,FCfechafin,FCmesinicio,FCmesfin)
					values(
						<cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#Form.Ecodigo#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">,
						<cfqueryparam value="#form.FCAmontobase#" cfsqltype="cf_sql_money">,
						<cfqueryparam value="#form.FCAdescuento#" cfsqltype="cf_sql_float">,					
						<cfqueryparam value="#Form.FCAmontores#" cfsqltype="cf_sql_money">,
						<cfqueryparam value="#form.FCAperiodicidad#" cfsqltype="cf_sql_char">,
						convert( datetime, <cfqueryparam value="#form.FCfechainicio#" cfsqltype="cf_sql_varchar">, 103 ),
						convert( datetime, <cfqueryparam value="#form.FCfechafin#" cfsqltype="cf_sql_varchar">, 103 ),						
						<cfqueryparam value="#Form.FCmesinicio#" cfsqltype="cf_sql_numeric">,						
						<cfqueryparam value="#Form.FCmesfin#" cfsqltype="cf_sql_numeric">						
						)
				end	
				else 
					select 1
				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
	
				delete from FactConceptosAlumno
				where FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo  = <cfqueryparam value="#Form.Ecodigo#" cfsqltype="cf_sql_numeric">
				  and CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">

				<cfset modo="BAJA">
			<cfelseif isdefined("Form.Cambio")>
				update FactConceptosAlumno set
					FCAmontobase = <cfqueryparam value="#Form.FCAmontobase#" cfsqltype="cf_sql_money">,
					FCAdescuento = <cfqueryparam value="#Form.FCAdescuento#" cfsqltype="cf_sql_float">,
					FCAmontores = <cfqueryparam value="#Form.FCAmontores#" cfsqltype="cf_sql_money">,
					FCAperiodicidad = <cfqueryparam value="#Form.FCAperiodicidad#" cfsqltype="cf_sql_char">,
					FCfechainicio = convert( datetime, <cfqueryparam value="#form.FCfechainicio#" cfsqltype="cf_sql_varchar">, 103 ),
					FCfechafin = convert( datetime, <cfqueryparam value="#form.FCfechafin#" cfsqltype="cf_sql_varchar">, 103 ),						
					FCmesinicio = <cfqueryparam value="#Form.FCmesinicio#" cfsqltype="cf_sql_numeric">,						
					FCmesfin = <cfqueryparam value="#Form.FCmesfin#" cfsqltype="cf_sql_numeric">					
				where FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
				  and Ecodigo  = <cfqueryparam value="#Form.Ecodigo#" cfsqltype="cf_sql_numeric">
				  and CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
				  <cfset modo="CAMBIO">
			</cfif>
			set nocount off
		</cfquery>
	<cfcatch type="any">
		<cfinclude template="../../errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
</cfif>
<form action="../facturacion/FactConAl.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="FCid" type="hidden" value="<cfif isdefined("Form.FCid")><cfoutput>#Form.FCid#</cfoutput></cfif>">
	<input name="Ecodigo" type="hidden" value="<cfif isdefined("Form.Ecodigo")><cfoutput>#Form.Ecodigo#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
	
	
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


