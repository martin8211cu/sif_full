<cftransaction>
<cfif isdefined("Form.BORRAR")  and len(trim(Form.BORRAR)) GT 0> 
	<!---*******************************--->
	<!--- Borra un empleado             --->
	<!---*******************************--->
	<cfquery name="delRHEmpleadosPlan" datasource="#Session.DSN#">
		delete from RHEmpleadosPlan
			where RHPcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
			and   Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and   DEid       = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEid#">
	</cfquery>
<cfelseif isdefined("Form.ALTA")  and len(trim(Form.ALTA)) GT 0> 

	<!---*******************************--->
	<!--- agrega un participante        --->
	<!---*******************************--->
		<cfquery name="busempleado" datasource="#Session.DSN#">
			select DEid
			from RHEmpleadosPlan
			where RHPcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">
			and   Ecodigo    =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
			and   DEid       = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEid#">
		</cfquery>
	<cfif busempleado.recordcount eq 0>
		<cfquery name="insRHEmpleadosPlan" datasource="#Session.DSN#">
			insert into RHEmpleadosPlan               
			(	RHPcodigo,  
				Ecodigo,
				DEid,
				BMUsucodigo,
				fechaalta
			)
			values (
				<cfqueryparam cfsqltype="cf_sql_char" value="#Form.RHPcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Form.DEid#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Usucodigo#">,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#NOW()#">
			)
		</cfquery>	
	<cfelse>
		<script language="javascript" type="text/javascript">
			alert("Este Candidato ya fue agregado");
		</script>
	</cfif>		
</cfif>
</cftransaction>
