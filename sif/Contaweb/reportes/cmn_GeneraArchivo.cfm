<cfif form.REP EQ 'L'>
	<cfif isdefined("form.CUENTAIDLIST") and len(trim(form.CUENTAIDLIST)) gt 0>
		<cfset cuentalista = form.CUENTAIDLIST>
	<cfelse>
		<script language="JavaScript">
			alert('Error debe agregar las cuentas a la lista ')
			document.location = "../reportes/cmn_SaldosAsientoCuentasPL.cfm";
		</script>
	</cfif> 
	<cfif isdefined("form.LIST_SEGMENTO") and len(trim(form.LIST_SEGMENTO)) gt 1>
	<cfelse>
		<script language="JavaScript">
			alert('Error debe seleccionar algún segmento ')
			document.location = "../reportes/cmn_SaldosAsientoCuentasPL.cfm";
		</script>
	</cfif> 	
</cfif>

<cfinclude template="ValidaRangosdehoraPL.cfm">

<cfset strSEGMENTO ="">
<cfset Hora ="">
<cfset LarrSEGMENTO= ListToarray(form.LIST_SEGMENTO)>
<cfloop index="i"  from="1" to="#ArrayLen(LarrSEGMENTO)#">
	<cfset strSEGMENTO = "#strSEGMENTO#" & "'" & "#LarrSEGMENTO[i]#" & "'">
	<cfif "#i#" neq "#ArrayLen(LarrSEGMENTO)#">
		<cfset strSEGMENTO = strSEGMENTO & ",">
	</cfif>	
</cfloop>

<cftransaction>
	<cftry>
	<cfquery datasource="#session.Conta.dsn#"  name="sql" >	
		insert  tbl_archivoscf (usuario,fechasolic,periodo,mesini,mesfin,fechaejec,horaejecuta,minejecuta,tpoarch,origen,status,listcuenta,nivel,listsegmento)
		values (
			<cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(session.usuario)#">,
			getdate(),
			<cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.ANOINICIAL)#">,
			<cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.MESINICIAL)#">,
			<cfif form.TIPOARCHIVO EQ 1  or  form.TIPOARCHIVO EQ 2> 
				<cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.MESINICIAL)#">,
			<cfelse>
				<cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.MESFINAL)#">,
			</cfif>
			<cfif isdefined ("form.ENLINEA")>
				datepart(HH,getdate()),
				datepart(MI,getdate()),
			<cfelse>
				<cfif trim(form.PMAM) eq "PM" and form.HORA LT 12 >
					<cfset Hora =trim(form.HORA)+12>
					convert(datetime, convert(varchar, getdate(), 112)  +' ' + right( '00' + convert(varchar, #Hora#) , 2) +':' + right( '00' + convert(varchar, #trim(form.MINUTOS)#) , 2)+ ':00'),
					<cfqueryparam  cfsqltype="cf_sql_integer"  value="#Hora#">,
				<cfelse>
				    <cfset Hora =trim(form.HORA)>
					convert(datetime, convert(varchar, getdate(), 112)  +' ' + right( '00' + convert(varchar, #Hora#) , 2) +':' + right( '00' + convert(varchar, #trim(form.MINUTOS)#) , 2)+ ':00'),
					<cfqueryparam  cfsqltype="cf_sql_integer"  value="#Hora#">,
				</cfif>
				<cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.MINUTOS)#">,
			</cfif>
			<cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.TIPOARCHIVO)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.REP)#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="P">,
			<cfif trim(form.REP) eq "R">
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CUENTASLIST)#">,
				<cfqueryparam  cfsqltype="cf_sql_integer"  value="#trim(form.NivelDetalle)#">,
	
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CUENTAIDLIST)#">,
				null,
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#PreserveSingleQuotes(strSEGMENTO)#">
		)
		select @@identity as llave
	</cfquery>
	<cfset llave =  #sql.llave#>
	<cfquery datasource="#session.Conta.dsn#"  name="sql" >	
		update  tbl_archivoscf set 
			nombrearc = <cfqueryparam cfsqltype="cf_sql_varchar"  value="#trim(session.usuario)#_">+convert(varchar,idarchivo)+'.txt'
		where  
			idarchivo = #llave# 
	</cfquery>
	<cfcatch type="any">
		<script language="JavaScript">
		var  mensaje = "<cfoutput>#trim(cfcatch.Detail)#</cfoutput>"
		mensaje = mensaje.substring(40,300)
		alert(mensaje)
		history.back()
		</script>
		<cfabort>
	</cfcatch>
	</cftry>	
</cftransaction>
<!--- <cfif isdefined ("form.ENLINEA")>
	  <cflocation url="../task/cmn_CreaArchivo.cfm?IRALISTA=S&LLAVE=#llave#&USER=#trim(session.usuario)#">

<cfelse> --->
<cfif trim(form.REP) eq "R">
	<cflocation url="cmn_SaldosRangoCuentasPL.cfm">
<cfelse>
	<cflocation url="cmn_SaldosAsientoCuentasPL.cfm">
</cfif>
<!--- </cfif>
 --->
