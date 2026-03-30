<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_ErrorParamPeriodo = t.Translate('LB_ErrorParamPeriodo','No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_ErrorParamMes = t.Translate('LB_ErrorParamPeriodo','No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_IntroduzcaPlaca = t.Translate('LB_IntroduzcaPlaca','Introduzca una placa para ver sus saldos','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_placa = t.Translate('LB_placa','Placa','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_buscar = t.Translate('LB_buscar','Buscar','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_ValorAdq = t.Translate('LB_ValorAdq','Valor Adq.','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_ValorMej = t.Translate('LB_ValorMej','Valor Mej.','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_ValorRev = t.Translate('LB_ValorRev','Valor Rev.','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_DepAcumAdq = t.Translate('LB_DepAcumAdq','Dep. Acum. Adq.','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_DepAcumMej = t.Translate('LB_DepAcumMej','Dep. Acum. Mej.','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_DepAcumRev = t.Translate('LB_DepAcumRev','Dep. Acum. Rev.','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_ValorLibros = t.Translate('LB_ValorLibros','Valor Libros','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_ValorRescate = t.Translate('LB_ValorRescate','Valor de Rescate','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_Depreciacion = t.Translate('LB_Depreciacion','Depreciaci&oacute;n','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_Depreciable = t.Translate('LB_Depreciable','Depreciable','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_FechaIniDepr = t.Translate('LB_FechaIniDepr','Fecha Ini. Depr.','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_VidaUtil = t.Translate('LB_VidaUtil','Vida Util','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_SaldoVidaUtil = t.Translate('LB_SaldoVidaUtil','Saldo Vida util','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_Revaluable = t.Translate('LB_Revaluable','Revaluable','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_FechaIniRev = t.Translate('LB_FechaIniRev','Fecha Ini. Rev.','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_ActivoDuplicado = t.Translate('LB_ActivoDuplicado','El Activo Está Duplicado','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_ActivoRetirado = t.Translate('LB_ActivoRetirado','El Activo Está Retirado','/commons/widgets/publico/MenuAF-principal.xml')>
<cfset LB_ActivoNoExiste = t.Translate('LB_ActivoNoExiste','El Activo No Existe','/commons/widgets/publico/MenuAF-principal.xml')>

<cfquery name="rsPeriodo" datasource="#session.dsn#">
	select Pvalor as value 
		from Parametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
				and Pcodigo = 50
</cfquery>
<cfquery name="rsMes" datasource="#session.dsn#">
	select Pvalor as value 
		from Parametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> 
				and Pcodigo = 60
</cfquery>
<cfif len(trim(rsPeriodo.value)) eq 0>
	<cf_errorCode	code = "50031" msg = "#LB_ErrorParamPeriodo#">
<cfelse>
	<cfset Intvar_Periodo = rsPeriodo.value>
</cfif>
<cfif len(trim(rsMes.value)) eq 0>
	<cf_errorCode	code = "50032" msg = "#LB_ErrorParamMes#">
<cfelse>
	<cfset Intvar_Mes = rsMes.value>
</cfif>
<!--- Formulario de Consulta de Saldos de Activos Fijos --->
<cfsavecontent variable="LvarQueryForm_SaldosActivos">
	<cfif isdefined("url.form_format") and len(trim(url.form_format)) and ListFindNoCase('html,flash',url.form_format)>
		<cfset session.menuaf.form_format = url.form_format>
	</cfif>
	<cfparam name="session.menuaf.form_format" default="html"><!--- Para hacerlo para flash falta ver como pintar la tabla con los resultados --->
	<cfparam name="form.placa" default="">
	<cfform height="350" width="350" id="form1" name="form1" method="post" action="MenuAF.cfm" format="#session.menuaf.form_format#" timeout="60" >

		<div class="container">
			<div class="row">
				<div class="centered"> 
					<cf_web_portlet_start titulo="#LB_IntroduzcaPlaca#" width="90%">
				<div>
			<div>
		<div>

		<cfformgroup type="panel" label="#LB_IntroduzcaPlaca#">
			<table>
				<tr><td><label for="placa"><cfoutput>#LB_placa#</cfoutput></label></td><td>
					<cfinput label="Placa" name="<cfoutput>#LB_placa#</cfoutput>" type="text" id="placa" value="#form.placa#" size="20" />
				</td><td>
					<cfinput type="submit" name="Submit" value="#LB_buscar#" class="btnSiguiente" />
				</td></tr>
			</table>
			<cfif len(trim(form.placa))>
			<cfquery name="rsAFSaldos" datasource="#session.dsn#">
				select Adescripcion,Avalrescate,AFSvutiladq,AFSsaldovutiladq,AFSvaladq, AFSvalmej, AFSvalrev, AFSdepacumadq, AFSdepacummej, AFSdepacumrev, 
					AFSvaladq+ AFSvalmej+ AFSvalrev- AFSdepacumadq- AFSdepacummej- AFSdepacumrev as AFSvallibros,
					Afechainidep,Afechainirev,AFSvutilrev,AFSsaldovutilrev,AFSdepreciable,AFSrevalua
				from Activos a 
					inner join AFSaldos b 
						on b.Ecodigo = a.Ecodigo 
						and a.Aid = b.Aid 
						and b.AFSperiodo = #Intvar_Periodo# 
						and b.AFSmes = #Intvar_Mes#
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and   a.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.placa#">
				and   a.Astatus = 0
			</cfquery>
			<cfif rsAFSaldos.recordcount eq 1>
			<cfoutput>
			<table align="center" width="295">
				<tr><td colspan="2">
					<strong>#rsAFSaldos.Adescripcion#</strong>
				</td></tr>
				<tr><td>Valor Adq.</td><td align="right">
					#LSCurrencyFormat(rsAFSaldos.AFSvaladq,'none')#
				</td></tr>
				<tr><td>Valor Mej.</td><td align="right">
					#LSCurrencyFormat(rsAFSaldos.AFSvalmej,'none')#
				</td></tr>
				<tr><td>Valor Rev.</td><td align="right">
					#LSCurrencyFormat(rsAFSaldos.AFSvalrev,'none')#
				</td></tr>
				<tr><td>Dep. Acum. Adq.</td><td align="right">
					#LSCurrencyFormat(rsAFSaldos.AFSdepacumadq,'none')#
				</td></tr>
				<tr><td>Dep. Acum. Mej.</td><td align="right">
					#LSCurrencyFormat(rsAFSaldos.AFSdepacummej,'none')#
				</td></tr>
				<tr><td>Dep. Acum. Rev.</td><td align="right">
					#LSCurrencyFormat(rsAFSaldos.AFSdepacumrev,'none')#
				</td></tr>
				<tr><td colspan="2"><hr /></td></td>
				<tr><td><strong><cfoutput>#LB_ValorLibros#</cfoutput></strong></td><td align="right">
					<strong>#LSCurrencyFormat(rsAFSaldos.AFSvallibros,'none')#</strong>
				</td></tr>
				<tr><td><cfoutput>#LB_ValorRescate#</cfoutput></td><td align="right">
					#LSCurrencyFormat(rsAFSaldos.Avalrescate,'none')#
				</td></tr>
				<tr><td colspan="2"><hr /></td></td>
				<tr><td colspan="2"><strong><cfoutput>#LB_Depreciacion#</cfoutput></strong></td></td>
				<tr><td><cfoutput>#LB_Depreciable#</cfoutput></td><td align="right">
					#iif(rsAFSaldos.AFSdepreciable eq 1,DE('Sí'),DE('No'))#
				</td></tr>
				<tr><td><cfoutput>#LB_FechaIniDepr#</cfoutput></td><td align="right">
					#LSDateFormat(rsAFSaldos.Afechainidep,'dd/mm/yyyy')#
				</td></tr>
				<tr><td><cfoutput>#LB_VidaUtil#</cfoutput></td><td align="right">
					#rsAFSaldos.AFSvutiladq#
				</td></tr>
				<tr><td><cfoutput>#LB_SaldoVidaUtil#</cfoutput></td><td align="right">
					#rsAFSaldos.AFSsaldovutiladq#
				</td></tr>
				<tr><td colspan="2"><hr /></td></td>
				<tr><td colspan="2"><strong><cfoutput>#LB_Revaluable#</cfoutput></strong></td></td>
				<tr><td><cfoutput>#LB_Revaluable#</cfoutput></td><td align="right">
					#iif(rsAFSaldos.AFSrevalua eq 1,DE('Sí'),DE('No'))#
				</td></tr>
				<tr><td>Fecha Ini. Rev.</td><td align="right">
					#LSDateFormat(rsAFSaldos.Afechainirev,'dd/mm/yyyy')#
				</td></tr>
				<tr><td><cfoutput>#LB_VidaUtil#</cfoutput></td><td align="right">
					#rsAFSaldos.AFSvutilrev#
				</td></tr>
				<tr><td><cfoutput>#LB_SaldoVidaUtil#</cfoutput></td><td align="right">
					#rsAFSaldos.AFSsaldovutilrev#
				</td></tr>
			</table>
			</cfoutput>
			<cfelse>
			<cfquery name="rsAFSaldosDuplicados" datasource="#session.dsn#">
				select 1
				from Activos a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.placa#">
				and a.Astatus = 0
			</cfquery>
			<cfquery name="rsAFSaldosRetirados" datasource="#session.dsn#">
				select 1
				from Activos a
				where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				and a.Aplaca = <cfqueryparam cfsqltype="cf_sql_char" value="#form.placa#">
				and a.Astatus = 60
			</cfquery>
			<table>
			  <tr>
				<td>
					<cfif rsAFSaldosDuplicados.recordcount gt 1>
						<cfoutput>#LB_ActivoDuplicado#</cfoutput>
					<cfelseif rsAFSaldosRetirados.recordcount>
						<cfoutput>#LB_ActivoRetirado#</cfoutput>
					<cfelse>
						<cfoutput>#LB_ActivoNoExiste#</cfoutput>
					</cfif>
				</td>
			  </tr>
			</table>
			</cfif>
			</cfif>
		</cfformgroup>
		<cf_web_portlet_end>
	</cfform>
</cfsavecontent>
<!--- Pintado de los gráficos --->
<cfoutput>
#LvarQueryForm_SaldosActivos#
</cfoutput>

