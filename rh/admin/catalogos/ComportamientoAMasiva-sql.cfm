<cfif not isdefined("form.btnNuevo")>
	<!--- Inserción a la tabla RHTAccionMasiva --->
	<cfif isdefined("form.Alta")>
		<cftransaction>
			<cfquery name="rsInsert" datasource="asp">
				insert into ComportamientoAMasiva (CAMAcodigo, CAMdescripcion, CAMcomponente, 
							CAMcempresa, CAMctiponomina, CAMcregimenv, CAMcoficina, CAMcdepto, 
							CAMcplaza, CAMcpuesto, CAMccomp, CAMcsalariofijo, CAMccatpaso, 
							CAMcjornada, CAMidliquida, BMUsucodigo)
				values (<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CAMAcodigo#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CAMdescripcion#">, 
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CAMcomponente#">, 
						<cfif isdefined("form.CAMcempresa")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMctiponomina")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMcregimenv")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMcoficina")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMcdepto")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMcplaza")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMcpuesto")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMccomp")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMcsalariofijo")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMccatpaso")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMcjornada")>1<cfelse>0</cfif>, 
						<cfif isdefined("form.CAMidliquida")>1<cfelse>0</cfif>, 
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> 
				)			
				<cf_dbidentity1 datasource="asp">
			</cfquery>
			<cf_dbidentity2 name="rsInsert" datasource="asp">
			<cfset Form.CAMid = rsInsert.identity>
		</cftransaction>
	
	<cfelseif isdefined("form.Cambio") and isdefined("Form.CAMid") and Len(Trim(Form.CAMid))>
		<cfquery name="rsUpdate" datasource="asp">
			update ComportamientoAMasiva set
				CAMAcodigo = <cfqueryparam value="#Form.CAMAcodigo#" cfsqltype="cf_sql_varchar">, 
				CAMdescripcion = <cfqueryparam value="#Form.CAMdescripcion#" cfsqltype="cf_sql_varchar">, 
				CAMcomponente = <cfqueryparam value="#Form.CAMcomponente#" cfsqltype="cf_sql_varchar">, 
				CAMcempresa = <cfif isdefined("form.CAMcempresa")>1<cfelse>0</cfif>, 
				CAMctiponomina = <cfif isdefined("form.CAMctiponomina")>1<cfelse>0</cfif>, 
				CAMcregimenv = <cfif isdefined("form.CAMcregimenv")>1<cfelse>0</cfif>, 
				CAMcoficina = <cfif isdefined("form.CAMcoficina")>1<cfelse>0</cfif>, 
				CAMcdepto = <cfif isdefined("form.CAMcdepto")>1<cfelse>0</cfif>, 
				CAMcplaza = <cfif isdefined("form.CAMcplaza")>1<cfelse>0</cfif>, 
				CAMcpuesto = <cfif isdefined("form.CAMcpuesto")>1<cfelse>0</cfif>, 
				CAMccomp = <cfif isdefined("form.CAMccomp")>1<cfelse>0</cfif>, 
				CAMcsalariofijo = <cfif isdefined("form.CAMcsalariofijo")>1<cfelse>0</cfif>, 
				CAMccatpaso = <cfif isdefined("form.CAMccatpaso")>1<cfelse>0</cfif>, 
				CAMcjornada = <cfif isdefined("form.CAMcjornada")>1<cfelse>0</cfif>, 
				CAMidliquida = <cfif isdefined("form.CAMidliquida")>1<cfelse>0</cfif>,
				BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#"> 
			where CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CAMid#">
		</cfquery>
	
	<cfelseif isdefined("form.Baja") and isdefined("Form.CAMid") and Len(Trim(Form.CAMid))>
		<cfquery name="rsDel" datasource="asp">
			delete from ComportamientoAMasiva
			where CAMid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CAMid#">
		</cfquery>
		
	</cfif>
</cfif>

<cfset params = "">
<cfif isdefined("Form.CAMid") and Len(Trim(Form.CAMid)) and not isdefined("Form.Baja") and not isdefined("Form.Nuevo")>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "RHTAid=" & Form.CAMid>
</cfif>
<cfif isdefined("Form.PageNum_lista") and Len(Trim(Form.PageNum_lista))>
	<cfset params = params & Iif(Len(Trim(params)), DE("&"), DE("?")) & "PageNum_lista=" & Form.PageNum_lista>
</cfif>
<cflocation url="ComportamientoAMasiva.cfm#params#">