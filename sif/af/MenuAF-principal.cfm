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
	<cf_errorCode	code = "50031" msg = "No se ha definido el parámetro Periodo para los Sistemas Auxiliares! Proceso Cancelado!">
<cfelse>
	<cfset Intvar_Periodo = rsPeriodo.value>
</cfif>
<cfif len(trim(rsMes.value)) eq 0>
	<cf_errorCode	code = "50032" msg = "No se ha definido el parámetro Mes para los Sistemas Auxiliares! Proceso Cancelado!">
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
		<cf_web_portlet_start titulo="Introduzca una placa para ver sus saldos" width="350">
		<cfformgroup type="panel" label="Introduzca una placa para ver sus saldos">
			<table>
				<tr><td><label for="placa">Placa</label></td><td>
					<cfinput label="Placa" name="placa" type="text" id="placa" value="#form.placa#" size="20" />
				</td><td>
					<cfinput type="submit" name="Submit" value="Buscar" class="btnSiguiente" />
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
				<tr><td><strong>Valor Libros</strong></td><td align="right">
					<strong>#LSCurrencyFormat(rsAFSaldos.AFSvallibros,'none')#</strong>
				</td></tr>
				<tr><td>Valor de Rescate</td><td align="right">
					#LSCurrencyFormat(rsAFSaldos.Avalrescate,'none')#
				</td></tr>
				<tr><td colspan="2"><hr /></td></td>
				<tr><td colspan="2"><strong>Depreciaci&oacute;n</strong></td></td>
				<tr><td>Depreciable</td><td align="right">
					#iif(rsAFSaldos.AFSdepreciable eq 1,DE('Sí'),DE('No'))#
				</td></tr>
				<tr><td>Fecha Ini. Depr.</td><td align="right">
					#LSDateFormat(rsAFSaldos.Afechainidep,'dd/mm/yyyy')#
				</td></tr>
				<tr><td>Vida Util</td><td align="right">
					#rsAFSaldos.AFSvutiladq#
				</td></tr>
				<tr><td>Saldo Vida util</td><td align="right">
					#rsAFSaldos.AFSsaldovutiladq#
				</td></tr>
				<tr><td colspan="2"><hr /></td></td>
				<tr><td colspan="2"><strong>Revaluaci&oacute;n</strong></td></td>
				<tr><td>Revaluable</td><td align="right">
					#iif(rsAFSaldos.AFSrevalua eq 1,DE('Sí'),DE('No'))#
				</td></tr>
				<tr><td>Fecha Ini. Rev.</td><td align="right">
					#LSDateFormat(rsAFSaldos.Afechainirev,'dd/mm/yyyy')#
				</td></tr>
				<tr><td>Vida Util</td><td align="right">
					#rsAFSaldos.AFSvutilrev#
				</td></tr>
				<tr><td>Saldo Vida util</td><td align="right">
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
						El Activo Está Duplicado
					<cfelseif rsAFSaldosRetirados.recordcount>
						El Activo Está Retirado
					<cfelse>
						El Activo No Existe
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

