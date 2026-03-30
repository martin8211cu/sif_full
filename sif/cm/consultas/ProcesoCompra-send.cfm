<cfquery datasource="asp">
    insert into SMTPQueue (	SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml, SMTPcc, SMTPbcc)
    values ( <cfqueryparam cfsqltype="cf_sql_varchar" 		value="gestion@soin.co.cr">,
             <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.SMTPdestinatario#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.SMTPasunto#">,
             <cfqueryparam cfsqltype="cf_sql_longvarchar" 	value="#form.DFtexto#">, 1,
             <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.SMTPcc#">,
             <cfqueryparam cfsqltype="cf_sql_varchar" 		value="#form.SMTPbcc#">)
</cfquery>

<script language="javascript" type="text/javascript">
	alert('Correo Enviado con Éxito');
	window.close();
</script>