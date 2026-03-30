<cfset params = "">

<cfif isdefined("Form.Alta")>
	<cftransaction>
		<cfquery name="rsInsert" datasource="#session.DSN#">
			insert into ClasificacionCFuncional
				(Ecodigo, 
				Ocodigo, 
				ACcodigo, 
				ACid, 
				CFid,
				CCFvutil, 
				CCFdepreciable,
				CCFrevalua, 
				CCFtipo, 
				CCFvalorres,
				BMUsucodigo)
			values (<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))> 
						<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,
					<cfelse> 
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACcodigo#">,
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.ACid#">,
					<cfif isdefined("form.CFid") and len(trim(form.CFid))>
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
					<cfelse>
						null,
					</cfif>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CCFvutil#">,
					<cfif isdefined("form.CCFdepreciable") and len(trim(form.CCFdepreciable))> 1 <cfelse> 0	</cfif>,
					<cfif isdefined("form.CCFrevalua") and len(trim(form.CCFrevalua))> 1 <cfelse> 0 </cfif>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCFtipo#">,
					<cfqueryparam cfsqltype="cf_sql_money" value="#form.CCFvalorres#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
			)
			<cf_dbidentity1 datasource="#Session.DSN#">					
		</cfquery>
		<cf_dbidentity2 datasource="#Session.DSN#" name="rsInsert">
	</cftransaction>
 	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "CCFid=" & rsInsert.identity>
	
<cfelseif isdefined("Form.Baja")>
	<cfquery name="rsDelete" datasource="#session.DSN#">
		delete from ClasificacionCFuncional
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CCFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCFid#">
	</cfquery>	
	
<cfelseif isdefined("Form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
					table="ClasificacionCFuncional"
					redirect="ClasificacionCF.cfm"
					timestamp="#form.ts_rversion#"				
					field1="Ecodigo,integer,#session.Ecodigo#"
					field2="CCFid,numeric,#form.CCFid#">

	<cfquery name="rsUpdate" datasource="#session.DSN#">
		update 	ClasificacionCFuncional
		set Ocodigo 		= 	<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))> 
							      	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.Ocodigo#">,
							  	<cfelse> 
								  	null,
							  	</cfif> 
			CFid 			= 	<cfif isdefined("form.CFid") and len(trim(form.CFid))>
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CFid#">,
								<cfelse>
									null,
								</cfif> 
			CCFvutil 		= 	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.CCFvutil#">, 
			CCFdepreciable  = 	<cfif isdefined("form.CCFdepreciable") and len(trim(form.CCFdepreciable))> 1 <cfelse> 0 </cfif>, 
			CCFrevalua  	= 	<cfif isdefined("form.CCFrevalua") and len(trim(form.CCFrevalua))> 1 <cfelse> 0 </cfif>, 
			CCFtipo  		= 	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCFtipo#">, 
			CCFvalorres  	= 	<cfqueryparam cfsqltype="cf_sql_money"   value="#form.CCFvalorres#">
		where Ecodigo 		= 	<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and CCFid 		= 	<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCFid#">
	</cfquery>
 	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "CCFid=" & form.CCFid>
</cfif>

<cfif isdefined("form.Padre_ACid") and len(trim(form.Padre_ACid))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Padre_ACid=" & form.Padre_ACid>
</cfif>
<cfif isdefined("form.Padre_ACcodigo") and len(trim(form.Padre_ACcodigo))>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "Padre_ACcodigo=" & form.Padre_ACcodigo>
</cfif>
<cfif isDefined("form.Pagina3") and len(trim(Form.Pagina3)) and not isDefined("form.Baja")>
	<cfset params = params & iif(len(params),DE("&"),DE("?")) & "PageNum_lista3=" & Form.Pagina3>
<cfelse>1
</cfif>

<cfoutput>
<form action="ClasificacionCF.cfm" method="get" name="sql">
	<cfif isdefined("form.Padre_ACid") and len(trim(form.Padre_ACid))>
		<input type="hidden" name="Padre_ACid" value="#form.Padre_ACid#">
	</cfif>
	<cfif isdefined("form.Padre_ACcodigo") and len(trim(form.Padre_ACcodigo))>
		<input type="hidden" name="Padre_ACcodigo" value="#form.Padre_ACcodigo#">
	</cfif>
	<cfif isDefined("form.Pagina3") and len(trim(Form.Pagina3)) and not isDefined("form.Baja")>
		<input type="hidden" name="PageNum_lista3" value="#form.Pagina3#">
	<cfelse>
		<input type="hidden" name="PageNum_lista3" value="1">
	</cfif>
	<cfif isdefined("Form.Alta")>
		<input type="hidden" name="CCFid" value="#rsInsert.identity#">
	<cfelseif isdefined("Form.Cambio")>
		<input type="hidden" name="CCFid" value="#form.CCFid#">
	</cfif>
</form>
</cfoutput>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>