<!---************************************--->
<!--- actualiza el estado del concurso   --->
<!---************************************--->
 <cfif isdefined("Form.BOTONSEL") and(Form.BOTONSEL eq "Finalizar")>
	 <cftransaction>
		 <cf_dbtimestamp
				 datasource="#session.dsn#"
				 table="RHConcursos"
				 redirect="RegistroConcursantes.cfm"
				 timestamp="#form.ts_rversion#"
				 field1="Ecodigo" type1="numeric" value1="#session.Ecodigo#"
 				 field2="RHCconcurso" type2="numeric" value2="#Form.RHCconcurso#">
			<cfquery name="updatePruebas" datasource="#Session.DSN#">
				 update RHConcursos  set 
				 RHCestado = 60
				 where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				   and RHCconcurso = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHCconcurso#">
			</cfquery>
	</cftransaction>
	<cfset paso = 0> 
	<form name="form1" method="post" action="RegistroConcursantes.cfm">
		<input type="hidden"       name="paso" value="<cfoutput>#paso#</cfoutput>">
	</form>
	<script language="javascript1.2" type="text/javascript">
		document.form1.submit();
	</script>
</cfif>	

