<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<cfoutput><html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Resultado</title>

#'<'#script type="text/javascript">
#'<'#!--
<cftry>
<cfquery datasource="#session.dsn#" name="saldo">
	select p.TJdsaldo, pp.prefijo, pp.recargable, pp.precio, pp.Miso4217, p.TJpassword
	from ISBprepago p
		left join ISBprefijoPrepago pp
			on pp.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and p.TJlogin like rtrim(pp.prefijo) || '%'
	where p.TJlogin = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.tj#">
	  and p.TJpassword = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.pw#">
</cfquery>
<cfset saldoTime = 'N/D'>

<cfif saldo.RecordCount is 0>
	<cflock name="saci_gestion_recarga_saldo" timeout="10" throwontimeout="no">
		<cfset CreateObject("java", "java.lang.Thread").sleep(1000)>
	</cflock>
	alert('La contraseña no corresponde a la tarjeta indicada');
<cfelseif saldo.recargable neq 1>
	alert('La tarjeta no es recargable. (serie #HTMLEditFormat(saldo.prefijo)#)');
<cfelseif Len(saldo.TJdsaldo)>
	<cfset saldoTime = TimeFormat(DateAdd('s', saldo.TJdsaldo, CreateTime(0, 0, 0)), 'H:mm:ss')>
	<cfif saldo.TJdsaldo GE 86400*2>
		<cfset saldoTime = Int(saldo.TJdsaldo / 86400) & ' días, ' & saldoTime>
	<cfelseif saldo.TJdsaldo GE 86400>
		<cfset saldoTime = '1 día, ' & saldoTime>
	</cfif>
</cfif>
	window.parent.setSaldo('# JSStringFormat( saldoTime ) #', '# JSStringFormat( NumberFormat(saldo.precio, ',0.00') ) #' , '# JSStringFormat( saldo.Miso4217 ) #' );
<cfcatch type='any'>
	alert('#JSStringFormat(cfcatch.Message)# #JSStringFormat(cfcatch.Detail)#');
</cfcatch>
</cftry>
//-->
</script>

</head>

<body>
OK #Now()#<br />
'# HTMLEditFormat( saldoTime ) #', '# HTMLEditFormat( NumberFormat(saldo.precio, ',0.00') ) #' , '# HTMLEditFormat( saldo.Miso4217 ) #'

</body>
</html></cfoutput>
