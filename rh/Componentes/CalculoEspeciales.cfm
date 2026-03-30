<!---ljimenez inicio realiza el calculo de cargas que se calculan despues del calculo de la renta. --->

<cfif CalendarioPagos.CPnodeducciones EQ 0>
		<cfquery datasource="#Arguments.datasource#" name="DeduccionesEspeciales">
			select distinct b.TDid 
			from DeduccionesCalculo a, DeduccionesEmpleado b, FDeduccion f, TDeduccion t
			where a.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and b.Did = a.Did
			  and f.TDid = b.TDid
			  and t.TDid = b.TDid
			  and coalesce(t.TDdrenta,0) = 1
		</cfquery>
        
		<cfloop query="DeduccionesEspeciales">
			<cfquery datasource="#Arguments.datasource#" name="formula">
				select FDformula, FDcfm
				from FDeduccion
				where TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#DeduccionesEspeciales.TDid#">
			</cfquery>
            
			
			<cfif len(trim(formula.FDcfm))>
				<cfinclude template="#trim(formula.FDcfm)#">
				<!---<strong><cfdump var="#formula.FDcfm#"></strong>--->
			<cfelse>
				<cfif Len(Trim(formula.FDformula))>
					<cfset sqlscript = formula.FDformula>
					<cfset sqlscript = Replace(sqlscript, '@RCNid'  , Arguments.RCNid, 'all')>
					<cfset sqlscript = Replace(sqlscript, '@TDid'   , DeduccionesEspeciales.TDid, 'all')>
					<cfset sqlscript = Replace(sqlscript, '@minimo' , minimo, 'all')>
					<cfset sqlscript = Replace(sqlscript, '@Ecodigo', #Session.Ecodigo#, 'all')>
		
					<cfquery datasource="#Arguments.datasource#">
						# PreserveSingleQuotes( sqlscript )#
					</cfquery>
				</cfif>
			</cfif>	
		</cfloop>
	<!--- Fin de calculo de Deducciones Especiales --->

<!---	
		<!--- Si el valor de la deduccion a rebajar es mayor que el saldo, se toma el valor del saldo --->
		<cfquery datasource="#Arguments.datasource#">
			update DeduccionesCalculo 
				set DCinteres = 0.00,
				DCvalor = coalesce((
					select a.Dsaldo
					from SalarioEmpleado d, DeduccionesEmpleado a 
					where DeduccionesCalculo.RCNid = d.RCNid
					  and DeduccionesCalculo.DEid = d.DEid
				
					  and d.SEcalculado = 0
					  <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
					  and a.Did = DeduccionesCalculo.Did
					  and a.DEid = DeduccionesCalculo.DEid
					  and a.Dcontrolsaldo > 0
					  and a.Dsaldo < DeduccionesCalculo.DCvalor),0.00)
			where DeduccionesCalculo.RCNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.RCNid#">
			  and exists (select 1
					from SalarioEmpleado d, DeduccionesEmpleado a 
					where DeduccionesCalculo.RCNid = d.RCNid
					  and DeduccionesCalculo.DEid = d.DEid
				
					  and d.SEcalculado = 0
					  <cfif IsDefined('Arguments.pDEid')> and d.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pDEid#"></cfif>
					  and a.Did = DeduccionesCalculo.Did
					  and a.DEid = DeduccionesCalculo.DEid
					  and a.Dcontrolsaldo > 0
					  and a.Dsaldo < DeduccionesCalculo.DCvalor)
		</cfquery> --->

		<cfquery datasource="#Arguments.datasource#">
			update DeduccionesCalculo set DCvalor = round(DCvalor,2)
				where RCNid = #Arguments.RCNid#
			<cfif IsDefined('Arguments.pDEid')> and DEid = #Arguments.pDEid#</cfif>
		</cfquery>
</cfif>


<!---
<cfquery datasource="#Arguments.datasource#" name="x">
   select *
   from DeduccionesCalculo 
      where RCNid = #Arguments.RCNid#
    <cfif IsDefined('Arguments.pDEid')> and DEid = #Arguments.pDEid#</cfif>
</cfquery>

<cf_dump var ="#x#">
--->

<!---ljimenez fin del calculo de deducciones que se calculan despues del calculo de la renta.--->