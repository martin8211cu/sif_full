<cfif not isdefined("Form.Nuevo")>
	<cfif isdefined("Form.Alta")>
		<cfquery name="rsEscalas" datasource="#Session.DSN#">
			select RHEid 
			from RHEscalas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and RHEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHEid#">
		</cfquery>

		<cfif rsEscalas.RecordCount LTE 0>
			<cfif isdefined("form.RHEdefault")>
				<cfquery name="update" datasource="#Session.DSN#">
					update RHEscalas 
					set RHEdefault = 0 
					where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				</cfquery>
			 </cfif>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into RHEscalas (Ecodigo, RHEid, RHEdescripcion, RHEdefault)
					values ( <cfqueryparam cfsqltype="cf_sql_integer"  value="#session.Ecodigo#"> , 
							 <cfqueryparam cfsqltype="cf_sql_integer"  value="#form.RHEid#"> , 
							 <cfqueryparam cfsqltype="cf_sql_char"     value="#Form.RHEdescripcion#">, 
							 <cfif isdefined("form.RHEdefault")>
							 	1
							 <cfelse>
							 	0
							 </cfif>
							 
					)
			 </cfquery>
			<cfset modo="ALTA">
		<cfelse>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="MSG_error"
			Default="El registro que desea insertar ya existe."
			returnvariable="MSG_error"/>		
			<cf_throw message="#MSG_error#" errorcode="8005">
			
		</cfif>
			
	<cfelseif isdefined("Form.Baja")>
		<cfquery name="delete" datasource="#Session.DSN#">
			delete from RHEscalas
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
				and RHEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHEid#" >
		</cfquery>
		<cfset modo="BAJA">

	<cfelseif isdefined("Form.Cambio")>
		<cfif isdefined("form.RHEdefault")>
			<cfquery name="update" datasource="#Session.DSN#">
				update RHEscalas 
				set RHEdefault = 0 
				where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
				and RHEid != <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHEid#" >
			</cfquery>
		</cfif>
		<cf_dbtimestamp datasource="#session.dsn#"
			table="RHEscalas"
			redirect="RHEscalas.cfm"
			timestamp="#form.ts_rversion#"				
			field1="Ecodigo" 
			type1="integer" 
			value1="#session.Ecodigo#"
			field2="RHEid" 
			type2="integer" 
			value2="#form.RHEid#"
			>
			

		<cfquery name="update" datasource="#Session.DSN#">
			update RHEscalas 
			set RHEdescripcion = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHEdescripcion#">,
			<cfif isdefined("form.RHEdefault")>
				RHEdefault = 1
			 <cfelse>
				RHEdefault = 0
			 </cfif>			 
			where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
			  and RHEid = <cfqueryparam value="#Form.RHEid#" cfsqltype="cf_sql_integer">
		</cfquery>
		<cfset modo="CAMBIO">
	</cfif>
</cfif>

<form action="Escalas.cfm" method="post" name="sql">
</form>

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>

