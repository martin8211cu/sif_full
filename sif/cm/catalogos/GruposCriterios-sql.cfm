<cfset modo = "ALTA">
<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="insert" datasource="#Session.DSN#">
			insert into GruposCriteriosCM( Ecodigo, GCcritdesc )
			values ( <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">,
					 <cfqueryparam value="#Form.GCcritdesc#" cfsqltype="cf_sql_varchar">
			       )
		</cfquery>		   
			<cfset modo="ALTA">
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="deleted" datasource="#session.DSN#">
			delete from CriteriosGrupoCM
			where GCcritid = <cfqueryparam value="#Form.GCcritid#" cfsqltype="cf_sql_numeric">
		</cfquery>

		<cfquery name="delete" datasource="#Session.DSN#">
			delete from GruposCriteriosCM
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			and GCcritid = <cfqueryparam value="#Form.GCcritid#"   cfsqltype="cf_sql_numeric">
		</cfquery>  
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>
		<cf_dbtimestamp datasource="#session.dsn#"
			 			table="GruposCriteriosCM"
			 			redirect="GruposCriterios.cfm"
			 			timestamp="#form.ts_rversion#"
						field1="GCcritid" 
						type1="numeric" 
						value1="#form.GCcritid#"
						field2="Ecodigo" 
						type2="integer" 
						value2="#session.Ecodigo#"
						>

		<cfquery name="update" datasource="#Session.DSN#">
			update GruposCriteriosCM set
				   GCcritdesc = <cfqueryparam value="#Form.GCcritdesc#" cfsqltype="cf_sql_varchar">
			where Ecodigo  = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and GCcritid = <cfqueryparam value="#Form.GCcritid#"   cfsqltype="cf_sql_numeric">
		</cfquery> 
		<cfset modo="CAMBIO">

	<cfelseif isdefined("form.action") >
		<cfquery name="critAct" datasource="#session.DSN#">
			select coalesce(sum(CGpeso),0) as totalPesos
			from CriteriosGrupoCM 
			where GCcritid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GCcritid#">
		</cfquery>
		
		<cfquery name="existe" datasource="#session.DSN#">
			select CCid, CGpeso
			from CriteriosGrupoCM 
			where GCcritid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GCcritid#">
			and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
		</cfquery>	
		
		<cfset modo="CAMBIO">
		<cfif len(trim(form.action)) eq 0>
			<cfif existe.RecordCount eq 0>
				<cfif isdefined('critAct') and critAct.recordCount GT 0 and critAct.totalPesos LT 100>
					<cfif isdefined('form.CGpeso') and form.CGpeso NEQ '' and ((critAct.totalPesos + form.CGpeso) LTE 100)>
						<cfquery name="insert" datasource="#session.DSN#">
							insert into CriteriosGrupoCM(GCcritid, CCid, CGpeso)
							values( <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GCcritid#">,
									<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">,
									<cfqueryparam cfsqltype="cf_sql_float" value="#form.CGpeso#">
								  )
						</cfquery>
					<cfelse>
						<cf_errorCode	code = "50260" msg = "La suma de los pesos para los criterios por grupo debe ser menor o igual a 100">
					</cfif>
				<cfelseif isdefined('critAct') and critAct.recordCount GT 0 and critAct.totalPesos EQ 100 and isdefined('form.CGpeso') and form.CGpeso NEQ ''>
					<cf_errorCode	code = "50260" msg = "La suma de los pesos para los criterios por grupo debe ser menor o igual a 100">
				</cfif>
			<cfelse>
				<cfif isdefined('critAct') and critAct.recordCount GT 0 and critAct.totalPesos LTE 100 >
					<cfset cantResta = critAct.totalPesos - existe.CGpeso>
					<cfif isdefined('form.CGpeso') and form.CGpeso NEQ ''>
						<cfset newTot = cantResta + form.CGpeso>						
						
						<cfif newTot GT 100>
							<cf_errorCode	code = "50260" msg = "La suma de los pesos para los criterios por grupo debe ser menor o igual a 100">
						<cfelse>
							<cfquery name="update" datasource="#session.DSN#">
								update CriteriosGrupoCM
								set CGpeso = <cfqueryparam cfsqltype="cf_sql_float" value="#form.CGpeso#">
								where GCcritid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GCcritid#">
								and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
							</cfquery>							
						</cfif>
					</cfif>
				</cfif>
			</cfif>
		<cfelseif trim(form.action) eq 'update'>
			<cfif isdefined('critAct') 
				and critAct.recordCount GT 0 
				and critAct.totalPesos LTE 100>
					<cfset cantResta = critAct.totalPesos - existe.CGpeso>
					<cfif isdefined('form.CGpeso') and form.CGpeso NEQ ''>
						<cfset newTot = cantResta + form.CGpeso>						
						
						<cfif newTot GT 100>
							<cf_errorCode	code = "50260" msg = "La suma de los pesos para los criterios por grupo debe ser menor o igual a 100">
						<cfelse>
							<cfquery name="update" datasource="#session.DSN#">
								update CriteriosGrupoCM
								set CGpeso = <cfqueryparam cfsqltype="cf_sql_float" value="#form.CGpeso#">
								where GCcritid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GCcritid#">
								and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
							</cfquery>						
						</cfif>
					</cfif>
			</cfif>		
		<cfelseif trim(form.action) eq 'delete'>
			<cfquery name="delete" datasource="#session.DSN#">
				delete from CriteriosGrupoCM
				where GCcritid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.GCcritid#">
				and CCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CCid#">
			</cfquery>
		</cfif>
	</cfif>
</cfif>

<cfoutput>
<form action="GruposCriterios.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<input name="GCcritid" type="hidden" value="<cfif isdefined("Form.GCcritid") and modo neq 'ALTA'>#Form.GCcritid#</cfif>">
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>


