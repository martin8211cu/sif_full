<cfif form.REP EQ 'L'>
	<cfif isdefined("form.CUENTAIDLIST") and len(trim(form.CUENTAIDLIST)) gt 0>
		<cfset cuentalista ="#form.CUENTAIDLIST#"> 	
	<cfelse>
		<script language="JavaScript">
			alert('Error debe agregar las cuentas a la lista ')
			document.location = "../reportes/cmn_SaldosAsientoCuentasPL.cfm";
		</script>	
	</cfif>		
<cfelse>
	<cfset cuentalista ="#trim(form.CUENTASLIST)#">
</cfif>

<cfquery name="rsPrimeraCuenta" datasource="#session.Conta.dsn#">
	select min(CGM1IM) as Cuenta 
	from CGM001 
	where CGM1CD is null
</cfquery>

<cfquery name="rsLongCuenta" datasource="#session.Conta.dsn#">
	select datalength(convert(varchar, CGM1IM)) as Long 
	from CGM001 
	where CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsPrimeraCuenta.Cuenta#">
	  and CGM1CD is null
</cfquery>

<cfset long = #rsLongCuenta.Long#>

<cfset VerificaCuentas = ListToarray(cuentalista)>
<cfset rangovalido=0>

<cfif pmam eq "PM">
	<cfset Hora=Hora + 12>
	<cfset horaactual = timeformat(CreateTime(Hora,Minutos,0),"HH:mm:ss")>
<cfelse>
	<cfset horaactual = timeformat(CreateTime(Hora,Minutos,0),"HH:mm:ss")>
</cfif>

<cfif form.REP EQ 'R'>
	
	<cfset cuenta = "#VerificaCuentas[1]#">
	<cfset cMayor1 = mid(cuenta,1,long)>
		
	<cfset cuenta = "#VerificaCuentas[2]#">
	<cfset cMayor2 = mid(cuenta,1,long)>
	
	<!--- Verifica si dentro de las cuentas escogidas alguna no cumple --->
	<cfquery name="rsCuentas" datasource="#session.Conta.dsn#">
	Select CGM1IM 
	from CGM001 
	where CGM1CD is null
	and CGM1IM between <cfqueryparam cfsqltype="cf_sql_varchar" value="#cMayor1#"> 
			       and <cfqueryparam cfsqltype="cf_sql_varchar" value="#cMayor2#">
	</cfquery>
	
	<cfoutput query="rsCuentas">	
	
		<cfset cuenta = #CGM1IM#>
	
		<!--- Obtiene los rangos de hora segun la cuenta --->
		<cfquery name="rsVerifica" datasource="#session.Conta.dsn#">
		Select HORAini, HORAfin
		from tbl_horariosrep
		where CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cuenta#">
		</cfquery>
	
		<!--- Valida la hora actual contra los rangos de horas definidos --->
		<cfloop query="rsVerifica">
			<cfset horasys_ini=#dateformat(HORAini,"HH:mm:ss")#>
			<cfset horasys_fin=#dateformat(HORAfin,"HH:mm:ss")#>
		
			<cfif horasys_ini lte horaactual and horasys_fin gte horaactual>
				<cfset rangovalido=1>
			</cfif>		
		</cfloop>
		
	</cfoutput>	
	
	<!--- Obtiene los rangos de hora segun la cuenta 
	<cfquery name="rsVerifica1" datasource="#session.Conta.dsn#">
	Select HORAini, HORAfin
	from tbl_horariosrep
	where CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cMayor2#">
	</cfquery>--->
	
	<!--- Valida la hora actual contra los rangos de horas definidos 
	<cfoutput query="rsVerifica1">
		<cfset horasys_ini=#timeformat(HORAini,"HH:mm:ss")#>
		<cfset horasys_fin=#timeformat(HORAfin,"HH:mm:ss")#>
		
		<cfif horasys_ini lte horaactual and horasys_fin gte horaactual>
			<cfset rangovalido=1>
		</cfif>		
				
	</cfoutput>			--->	
				
<cfelse>	
				
	<!--- CUANDO EL REPORTE ES DE TIPO 1 (UNA CUENTA ) 0 3 (LISTA DE CUENTAS)--->
	<cfloop index="i"  from="1" to="#ArrayLen(VerificaCuentas)#">
			
		<cfset arreglo = listtoarray(VerificaCuentas[i],"¶")>	
		<cfset cuenta = "#arreglo[1]#">
		<cfset cMayor = mid(cuenta,1,long)>
												
		<!--- Verifica si dentro de las cuentas escogidas alguna no cumple --->

		<!--- Obtiene los rangos de hora segun la cuenta --->
		<cfquery name="rsVerifica" datasource="#session.Conta.dsn#">
		Select HORAini, HORAfin
		from tbl_horariosrep
		where CGM1IM = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cMayor#">
		</cfquery>
						
		<!--- Valida la hora actual contra los rangos de horas definidos --->
		<cfoutput query="rsVerifica">
			<cfset horasys_ini=#timeformat(HORAini,"HH:mm:ss")#>
			<cfset horasys_fin=#timeformat(HORAfin,"HH:mm:ss")#>
									
			<cfif horasys_ini lte horaactual and horasys_fin gte horaactual>
				<cfset rangovalido=1>
			</cfif>
					
		</cfoutput>		
		
		<cfif rangovalido eq 1><cfbreak></cfif>
				
	</cfloop>
	
</cfif>

<cfif rangovalido eq 1>

	<script>
	alert("No es posible generar el archivo porque una de las cuentas seleccionadas tiene restricciones de ejecucion a esta hora. Puede generar el archivo con una hora superior a las 3:30 P.M.")
	<cfif form.REP EQ 'L'>
		document.location = "../reportes/cmn_SaldosAsientoCuentasPL.cfm";
	<cfelse>
		document.location = "../reportes/cmn_SaldosRangoCuentasPL.cfm";
	</cfif>	
	</script>
	<cfabort>
	
</cfif>