<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN">
<html>
<cfparam name="form.hash" type="string" default="">
<cfparam name="form.IBid" type="numeric" default="0">
<head>
<title>Cancelar importaci&oacute;n</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
</head>

<body style="margin:0">
Cancelando proceso...<br>
<cfif Len(form.hash) EQ 0 or form.IBid EQ 0>
	<script type="text/javascript">
		alert("Operación inválida: \r\n No viene el número de operación por cancelar.");
	</script>
<cfelse>
	<cfquery datasource="sifcontrol" name="cancelar">
		update IBitacora
		set IBcancelada = 1
		where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IBid#">
		  and IBhash = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hash#">
		  and IBcompletada = 0
	</cfquery>
	<cfquery datasource="sifcontrol" name="razon">
		select IBcompletada, IBcancelada
		from IBitacora
		where IBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IBid#">
		  and IBhash = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hash#">
	</cfquery>
	<cfif razon.RecordCount EQ 0>
		<script type="text/javascript">
			alert("Operación inválida: \r\n El proceso no se encontró.");
		</script>
	<cfelseif razon.IBcompletada EQ 1>
		<script type="text/javascript">
			alert("Operación inválida: \r\n El proceso ya había finalizado.");
		</script>
	<cfelseif razon.IBcancelada NEQ 1>
		<script type="text/javascript">
			alert("Operación inválida: \r\n El proceso no se pudo detener.");
		</script>
	<cfelse>
		<script type="text/javascript">
			alert("Operación cancelada por el usuario.");
		</script>
	</cfif>
</cfif>
Listo.

</body>
</html>
