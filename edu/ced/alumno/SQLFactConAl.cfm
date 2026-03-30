<cfif isdefined("form.Alta") or isdefined("form.Cambio")>
	<cfquery name="ABC_FactConceptosAlumno" datasource="#Session.Edu.DSN#">
		select 1 from FactConceptosAlumno 
			where CEcodigo = <cfqueryparam value="#Session.Edu.CEcodigo#" cfsqltype="cf_sql_numeric">
			  and Ecodigo = <cfqueryparam value="#Form.Ecodigo#" cfsqltype="cf_sql_numeric">
			  and FCid = <cfqueryparam value="#Form.FCid#" cfsqltype="cf_sql_numeric">
			  and (convert(datetime, <cfqueryparam value="#form.FCfechainicio#" cfsqltype="cf_sql_varchar">, 103) between FCfechainicio and FCfechafin  or 
			  	   convert(datetime, <cfqueryparam value="#form.FCfechafin#" cfsqltype="cf_sql_varchar">, 103) between FCfechainicio and FCfechafin)
		<cfif isdefined("form.Cambio")>
			  and FCAid != <cfqueryparam value="#Form.FCAid#" cfsqltype="cf_sql_numeric"> 
		</cfif> 
	</cfquery>		  
	<cfif ABC_FactConceptosAlumno.RecordCount GT 0>
		<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=No puede incluir este concepto. La fecha esta dentro de un periodo Inválido." addtoken="no">
		<cfabort>
	</cfif>
</cfif>

<cfif not isdefined("Form.Nuevo")>
	<cftry>
		<cfquery name="ABC_FactConceptosAlumno" datasource="#Session.Edu.DSN#">
			set nocount on
			<cfif isdefined("Form.Alta")>
				set nocount on
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
				set nocount off

				<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
				delete from FactConceptosAlumno
				where FCAid = <cfqueryparam value="#Form.FCAid#" cfsqltype="cf_sql_numeric">
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
				where FCAid = <cfqueryparam value="#Form.FCAid#" cfsqltype="cf_sql_numeric">
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
<form action="alumno.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
	<input name="FCid" type="hidden" value="<cfif isdefined("Form.FCid")><cfoutput>#Form.FCid#</cfoutput></cfif>">
	<input name="FCAid" type="hidden" value="<cfif isdefined("Form.FCAid")><cfoutput>#Form.FCAid#</cfoutput></cfif>">
	<input name="Ecodigo" type="hidden" value="<cfif isdefined("Form.Ecodigo")><cfoutput>#Form.Ecodigo#</cfoutput></cfif>">
	<input name="persona" type="hidden" value="<cfif isdefined("Form.persona")><cfoutput>#Form.persona#</cfoutput></cfif>">
	<input name="o" type="hidden" value="<cfif isdefined("Form.o")><cfoutput>#Form.o#</cfoutput></cfif>">
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
	<!--- Campos del filtro para la lista de alumnos --->
	<cfif isdefined("Form.fRHnombre")>
		<input type="hidden" name="fRHnombre" value="<cfoutput>#Form.fRHnombre#</cfoutput>">
	</cfif>		   
	<cfif isdefined("Form.FNcodigo")>
		 <input type="hidden" name="FNcodigo" value="<cfoutput>#Form.FNcodigo#</cfoutput>">
	</cfif>		
	<cfif isdefined("Form.filtroRhPid")>
		 <input type="hidden" name="filtroRhPid" value="<cfoutput>#Form.filtroRhPid#</cfoutput>">
	</cfif>		
	<cfif isdefined("Form.FGcodigo")>
		<input type="hidden" name="FGcodigo" value="<cfoutput>#Form.FGcodigo#</cfoutput>">
	</cfif>
	<cfif isdefined("Form.NoMatr")>
		<input type="hidden" name="NoMatr" value="<cfoutput>#Form.NoMatr#</cfoutput>">
	</cfif>		  		  
	<cfif isdefined("Form.FAretirado")>
		<input type="hidden" name="FAretirado" value="<cfoutput>#Form.FAretirado#</cfoutput>">
	</cfif>
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


