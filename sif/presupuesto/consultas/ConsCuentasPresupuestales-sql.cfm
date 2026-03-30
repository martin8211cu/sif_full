<cfset LarrCuentas  = ListToarray(cuentaidlist)>
<cfswitch expression="#form.ID_REPORTE#">
	<cfcase value="2"><!---2 - CP x RANGO            --->
	<cfset cuentadesde  = Mid(trim(LarrCuentas[1]),1,4)> 
	<cfset cuentahasta  = Mid(trim(LarrCuentas[2]),1,4)>
	<cfset FormatoDesde = listtoarray(LarrCuentas[1],"|")>	
	<cfset FormatoDesde = FormatoDesde[1]>
	<cfset FormatoHasta = listtoarray(LarrCuentas[2],"|")>	
	<cfset FormatoHasta = FormatoHasta[1]>
	<cfquery name="rsCuentasP" datasource="#session.dsn#">
		select CPcuenta, Cmayor, CPformato, CPdescripcion, CPdescripcionF
		from CPresupuesto
		where Ecodigo =   #session.Ecodigo#  
		  and  Cmayor     >=	<cfqueryparam value="#cuentadesde#" cfsqltype="cf_sql_char">
		  and  Cmayor     <=	<cfqueryparam value="#cuentahasta#" cfsqltype="cf_sql_char">
		  and  CPformato   >=	<cfqueryparam value="#trim(FormatoDesde)#" cfsqltype="cf_sql_varchar">
		  and  CPformato   <=  <cfqueryparam value="#trim(FormatoHasta)#" cfsqltype="cf_sql_varchar">
		  and  CPmovimiento <> 'N'
		  order by Cmayor, CPformato
	</cfquery>
	</cfcase>
	
	<cfcase value="3"><!---3 - CP x LISTA DE CUENTAS --->
		<cf_dbtemp name="CtasPresupuesto_v1" returnvariable="CtasP">
			<cf_dbtempcol name="CPcuenta"  		type="numeric">
			<cf_dbtempcol name="Cmayor"     	type="char(4)">
			<cf_dbtempcol name="CPformato"  	type="char(100)">
			<cf_dbtempcol name="CPdescripcion"  type="varchar(80)">
			<cf_dbtempcol name="CPdescripcionF" type="varchar(80)">
			
			<cf_dbtempkey cols="CPcuenta">
		</cf_dbtemp>
		<cfset cuentalista = CuentaidList>
		<cfset LarrCuentas = ListToarray(cuentalista)>	
		<cfset Pcuentas = "">
		<cfloop index="i"  from="1" to="#ArrayLen(LarrCuentas)#">
			<cfset arreglo = listtoarray(LarrCuentas[i],"|")>	
			<cfset cuenta = "#arreglo[1]#">
			<cfset cMayor = mid(cuenta,1,4)>
			<cfquery datasource="#session.dsn#">
				insert into #CtasP# (CPcuenta, Cmayor, CPformato, CPdescripcion, CPdescripcionF)
				select distinct CPcuenta, Cmayor, CPformato, CPdescripcion, CPdescripcionF
				from CPresupuesto
				where Ecodigo =  #session.Ecodigo# 
					and Cmayor =      	<cfqueryparam value="#trim(cMayor)#"  cfsqltype="cf_sql_char">
					and CPformato like 	<cfqueryparam value="#trim(cuenta)#%" cfsqltype="cf_sql_varchar">
					and CPmovimiento <> 'N'
			</cfquery>
		</cfloop>
		<cfquery name="rsCuentasP" datasource="#session.dsn#">
			select CPcuenta, Cmayor, CPformato, CPdescripcion, CPdescripcionF
			from #CtasP#
			order by Cmayor, CPformato
		</cfquery>
		<cfquery datasource="#session.dsn#">
			delete from #CtasP#
		</cfquery>
	</cfcase>
</cfswitch>
<cfquery name="rsEmpresa" datasource="#Session.DSN#">
	select Edescripcion 
	from Empresas
	where Ecodigo = #Session.Ecodigo#
</cfquery>
<cfset ctaMayor = "">
<cf_htmlReportsHeaders 
	title="Catalogo de Cuentas Presupuestales" 
	filename="Cuentas_Presupuestales_#session.Usucodigo#_#dateformat(now(),'ddmmyyyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls"
	irA="/cfmx/sif/presupuesto/consultas/ConsCuentasPresupuestales.cfm" 
	>
<cf_templatecss>
<cfflush interval="64">
<table width="100%"  border="0" cellspacing="1" cellpadding="1">
	<tr>
		<td colspan="3" align="center"><strong><font size="4"><cfoutput>#rsEmpresa.Edescripcion#</cfoutput></font></strong></td>
	</tr>
	<tr>
		<td colspan="3" align="center"><strong><font size="3">Cat&aacute;logo de Cuentas Presupuestales</font></strong></td>
	</tr>
	<cfswitch expression="#form.ID_REPORTE#">
		<cfcase value="2"><!---2 - CP x RANGO            --->
			<tr>
				<td colspan="3" align="center"><strong>Cuenta Inicial:</strong>&nbsp;<cfoutput>#FormatoDesde#</cfoutput>&nbsp;<strong>&nbsp;Cuenta Final:</strong>&nbsp;<cfoutput>#FormatoHasta#</cfoutput></td>
			</tr>
		</cfcase>
		<cfcase value="3"><!---3 - CP x LISTA DE CUENTAS --->
			<tr>
				<td colspan="3" align="center"><strong>Lista de cuentas:</strong></td>
			</tr>
			<tr>
				<td colspan="3" align="center">
				<cfloop index="i"  from="1" to="#ArrayLen(LarrCuentas)#">
					<cfset arreglo = listtoarray(LarrCuentas[i],"|")>	
					<cfset cuenta = "#arreglo[1]#">
					<cfoutput>#cuenta#</cfoutput><br>
				</cfloop>
				</td>
			</tr>
		</cfcase>
	</cfswitch>
	<tr>
		<td width="30%">Usuario:<cfoutput>#Session.Usuario#</cfoutput></td>
		<td width="49%" >&nbsp;</td>
		<td width="21%" nowrap>Fecha: <cfoutput>#DateFormat(Now(),'DD/MM/YYYY')# #TimeFormat(Now(),'medium')#</cfoutput></td>
	</tr>
	<tr bgcolor="#0099CC" >
		<!---<td nowrap><font color="#FFFFFF"><strong>Cuenta Mayor</strong></font></td>--->
		<td nowrap><font color="#FFFFFF"><strong>Cuenta Presupuesto</strong></font></td>
		<td nowrap colspan="2"><strong><font color="#FFFFFF">Descripción</font></strong></td>
	</tr>
	<cfset Lvarcontador = 0>
	<cfset ctaMayor = "">
	<cfoutput query="rsCuentasP"> 
		<!---<cfif rsCuentasP.Cmayor neq ctaMayor>
			<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>">
				<td nowrap>#rsCuentasP.Cmayor#</td>
				<td nowrap>&nbsp;</td>
				<td nowrap>&nbsp;</td>
			</tr>
			<cfset ctaMayor = rsCuentasP.Cmayor>
			<cfset Lvarcontador += 1>
		</cfif>--->
		<tr class="<cfif Lvarcontador mod 2>listaPar<cfelse>listaNon</cfif>">
			<td nowrap>#rsCuentasP.CPformato#</td>
			<td nowrap colspan="2">#rsCuentasP.CPdescripcion#</td>
		</tr>
		<cfset Lvarcontador += 1>
		<cfflush>
	</cfoutput>
	<tr><td colspan="3" align="center">&nbsp;</td></tr>
	<tr>
		<td colspan="3" align="center">---------- FIN DEL REPORTE ----------</td>
	</tr>
</table>