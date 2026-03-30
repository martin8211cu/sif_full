
<cfset action = "AFIndicesFiscales.cfm">
<cfset params = "">

<cfif IsDefined("form.AFFperiodo")>
	<cfset params = AddParam(params,'AFFperiodo',form.AFFperiodo)>
</cfif>

<cfif IsDefined("form.filter")>
	<cfset params = AddParam(params,'filter',form.filter)>
</cfif>
<!---<cf_dump var ="#form#">--->
<cffunction name="AddParam" returntype="string">
	<cfargument name="params" type="string" required="yes">
	<cfargument name="paramname" type="string" required="yes">
	<cfargument name="paramvalue" type="string" required="yes">
	<cfset separador = iif(len(trim(arguments.params)),DE('&'),DE('?'))>
	<cfset nuevoparam = arguments.paramname & '=' & arguments.paramvalue>
	<cfreturn arguments.params & separador & nuevoparam>
</cffunction>

<!--- SQL de AFIndicesFiscales *** Índices de Depreciacion Fiscal --->

<cfif isdefined("form.AltaIndice")>

	<cfquery name="rstemp" datasource="#session.dsn#">
		insert into AFIndicesFiscales (Ecodigo, AFFperiodo, AFFMes, AFFindice, AFFfecha, AFFusuario)
		values ( <cf_jdbcquery_param value="#session.Ecodigo#" cfsqltype="cf_sql_integer">,	
        		 <cf_jdbcquery_param value="#form.AFFperiodo#" cfsqltype="cf_sql_integer">,
                 <cf_jdbcquery_param value="#form.AFFMes#" 	cfsqltype="cf_sql_integer">,
        		 <cf_jdbcquery_param value="#form.AFFindice#" 	cfsqltype="cf_sql_float">,
        		 <cf_dbfunction name="to_date" args="#now()#">,
                 <cf_jdbcquery_param value="#Session.Usuario#" 	cfsqltype="cf_sql_varchar">
                )
	</cfquery>

<!--- ******************************************************************************************************** --->		

<!--- Baja Individual de Un Índice asi como de la multi-selección desde la lista --->
<cfelseif isdefined("form.BotonSel") and form.BotonSel eq "btnEliminar">
	<cftransaction action="begin">
		<cfloop collection="#Form#" item="i">
			<cfif FindNoCase("chkHijo_", i) NEQ 0 and Form[i] NEQ 0>
				<cfset MM_columns = ListToArray(form[i],",")>
					<cfif isdefined('MM_columns') and ArrayLen(MM_columns) GT 0>
						<cfset j = ArrayLen(MM_columns)>
						<cfloop index = "k" from = "1" to = #j#>
							<cfset LvarLista = ListToArray(MM_columns[k],"|")>
							<cfset LvarAFFperiodo = ListToArray(LvarLista[1],"|")>
							<cfset LvarAFFMes = ListToArray(LvarLista[2],"|")>
							<cfquery datasource="#session.dsn#">
                                delete from AFIndicesFiscales
                                where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
                                    and AFFperiodo = <cfqueryparam value="#LvarAFFperiodo[1]#" cfsqltype="cf_sql_integer">
                                    and AFFMes = <cfqueryparam value="#LvarAFFMes[1]#" cfsqltype="cf_sql_integer">
							</cfquery>
							<cfset j = j - 1>
						</cfloop>	
					</cfif>
			</cfif>
		</cfloop>
	</cftransaction>
	<cfset params = AddParam(params,'AFFMes',form.AFFMes)>
	
<!--- ******************************************************************************************************** --->	

<!---Cambia Individual  de Un Índice *** Implica dar de Alta un Índice --->
<cfelseif isdefined("form.CambioIndice")>   	
	<cfquery name="rstemp" datasource="#Session.DSN#">
		update AFIndicesFiscales set
			AFFindice = <cfqueryparam value="#Form.AFFindice#" cfsqltype="cf_sql_float">
		where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and AFFperiodo = <cfqueryparam value="#Form.AFFperiodo#" cfsqltype="cf_sql_integer">
			and AFFMes = <cfqueryparam value="#Form.AFFMes#" cfsqltype="cf_sql_integer">
			and ts_rversion = convert(varbinary,#lcase(Form.ts_rversion)#)
	</cfquery>	  
	<cfset params = "">
</cfif>

<cfset params = trim(params)>

<cflocation url="#action##params#">