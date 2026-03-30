<cfset Competencia = #form.idcompetencia# >
<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
	<cfset RHOid    = #form.RHOid# >
<cfelse>
	<cfset DEid    = #form.DEid# >
</cfif>

<cfset Tipo        = #form.tipo#>

<cfset Fdesde = #finicio#>

<cfif Nuevo eq 'S'>
	<cfif isdefined("RHCompetenciasEmpleadoInsert.identity")>
		<cfset RegActual = #RHCompetenciasEmpleadoInsert.identity#>
	</cfif>
<cfelse>
	<cfset RegActual = #validaInsert.RHCEid#>
</cfif>

<!---<cfif Form.RHCEfhasta eq ''>
		<cfset Fhasta = CreateDate(6100, 01, 01)>
<cfelse>
	<cfset Fhasta = CreateDate(ListGetAt(ffinal, 3, '/'), ListGetAt(ffinal, 2, '/'), ListGetAt(ffinal, 1, '/'))>
</cfif>--->

<cfset Fhasta = #ffinal#>

<!--- busca si hay más de un registro para la competencia --->
<cfquery name="CantREG" datasource="#session.DSN#">
	select RHCEid from RHCompetenciasEmpleado
	where  idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Competencia#">
	and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and  tipo    = <cfqueryparam cfsqltype="cf_sql_char" value="#Tipo#">
	<cfif isdefined("RHOid") and len(trim(RHOid))>
		and  RHOid    = <cfqueryparam cfsqltype="cf_sql_integer" value="#RHOid#">
	<cfelse>
		and  DEid    = <cfqueryparam cfsqltype="cf_sql_integer" value="#DEid#">
	</cfif>	
</cfquery>
<cfif CantREG.recordcount gt 1>
	<cfquery name="rsFechaTrabajo" datasource="#session.DSN#">
		select min(RHCEfhasta) as fechatrab
		from RHCompetenciasEmpleado 
		<cfif isdefined("RHOid") and len(trim(RHOid))>
			where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#">
		<cfelse>
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
		</cfif>	
		and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#"> between RHCEfhasta and RHCEfdesde
		and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		and  tipo    = <cfqueryparam cfsqltype="cf_sql_char" value="#Tipo#">
		and  idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Competencia#">
		and  RHCEid !=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#RegActual#"> 
 	</cfquery>

 	<cfif rsFechaTrabajo.recordcount gt 0 and len(trim(rsFechaTrabajo.fechatrab)) >
		<cfset FechaTrab = rsFechaTrabajo.fechatrab>
		<cfquery name="rsRango1" datasource="#session.DSN#">
			select  RHCEid 
			from RHCompetenciasEmpleado 
			<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
				where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#">
			<cfelse>
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			</cfif>				
			and RHCEfhasta =  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#FechaTrab#">		
			and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and  tipo    = <cfqueryparam cfsqltype="cf_sql_char" value="#Tipo#">
			and  idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Competencia#">
			and  RHCEid !=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#RegActual#">
		</cfquery>
		<cfset Rango1 = rsRango1.RHCEid>
        
		<cfquery name="updCOMP" datasource="#session.DSN#">
			update RHCompetenciasEmpleado 
				set RHCEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-1,Fdesde)#">
			where RHCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Rango1#">
		</cfquery>	
		<cfquery name="rsFechaTrabajo2" datasource="#session.DSN#">
			select min(RHCEfdesde) as fechatrab
			from RHCompetenciasEmpleado 
			<cfif isdefined("form.RHOid") and len(trim(form.RHOid))>
				where RHOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RHOid#">
			<cfelse>
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DEid#">
			</cfif>	
			and  RHCEfhasta >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Fdesde#">
			and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and  tipo    = <cfqueryparam cfsqltype="cf_sql_char" value="#Tipo#">
			and  idcompetencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Competencia#">
			and  RHCEid not in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#RegActual#">,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Rango1#">)  
		</cfquery>
		<cfif rsFechaTrabajo2.recordcount gt 0 and rsFechaTrabajo2.fechatrab neq ''>
			<cfset FechaTrab = rsFechaTrabajo2.fechatrab>
			<cfquery name="updCOMP" datasource="#session.DSN#">
				update RHCompetenciasEmpleado 
					set RHCEfhasta = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('d',-1,FechaTrab)#">
				where RHCEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#RegActual#">
			</cfquery>	
		</cfif>	
	</cfif>
</cfif>


