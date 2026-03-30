<cfinclude template="../../Utiles/sifConcat.cfm">

<cfquery name="qry_cvAprobada" datasource="#Session.dsn#">
	select CVaprobada, CVestado, CPPid
	from CVersion
	where Ecodigo = #session.ecodigo#
		and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
</cfquery>
<cfquery name="qry_cvp" datasource="#Session.dsn#">
	select CPcuenta, CVPorigen
	from CVPresupuesto
	where Ecodigo = #session.ecodigo#
	and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
	and CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
</cfquery>

<cfif qry_cvp.CVPorigen EQ "">
	<cfset LvarEtapa = qry_cvAprobada.CVestado>	
<cfelse>
	<cfset LvarEtapa = "-1">
</cfif>

<cfparam name="modocambio" type="boolean" default="#isdefined('form.Mcodigo') and len(form.Mcodigo)#">
<cfif modocambio>
	<cfquery name="qry_cvfms" datasource="#session.dsn#">
		select m.Mcodigo, m.Miso4217 #_Cat# ' - ' #_Cat# m.Mnombre as Mnombre
		from Monedas m
		where m.Ecodigo = #session.ecodigo#
			and m.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery>
	<cfquery name="qry_cvfm" datasource="#session.dsn#">
		select Mcodigo, 
				CVFMmontoBase, 
				CVFMajusteUsuario, (CVFMmontoBase+CVFMajusteUsuario)			as CVFMversionUsuario,
				CVFMajusteFinal,   (CVFMmontoBase+CVFMajusteUsuario+CVFMajusteFinal) 	as CVFMversionFinal,
				ts_rversion
		from CVFormulacionMonedas
		where Ecodigo = #session.ecodigo#
			and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
			and CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
			and CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCano#">
			and CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCmes#">
			and Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
			and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">
	</cfquery>
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" artimestamp="#qry_cvfm.ts_rversion#" returnvariable="ts">
<cfelse>
	<cfquery name="qry_cvfms" datasource="#session.dsn#">
		select m.Mcodigo, m.Miso4217 #_Cat# ' - ' #_Cat# m.Mnombre as Mnombre
		from Monedas m
		where m.Ecodigo = #session.ecodigo#
			and not exists
				( 
					select 1
					from CVFormulacionMonedas f
					where f.Ecodigo = #session.ecodigo#
						and f.CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVid#">
						and f.CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
						and f.CPCano = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCano#">
						and f.CPCmes = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPCmes#">
						and f.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
					  	and f.Mcodigo = m.Mcodigo
				)
	</cfquery>
	<cfif qry_cvfms.recordcount EQ 0>
		<cfexit>
	</cfif>
</cfif>

<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<script language="javascript">
	function sbSumar()
	{
		var LvarBaseM = parseFloat(qf(document.getElementById("CVFMmontoBase").value));
		var LvarAjusteU = parseFloat(qf(document.getElementById("CVFMajusteUsuario").value));
		var LvarAjusteF = parseFloat(qf(document.getElementById("CVFMajusteFinal").value));
		var LvarVersionU = LvarBaseM + LvarAjusteU;
		var LvarVersionF = LvarVersionU + LvarAjusteF;
		document.getElementById("CVFMversionUsuario").value = fm(LvarVersionU,2);
		document.getElementById("CVFMversionFinal").value = fm(LvarVersionF,2);
	}
	function nfm(Valor)
	{
		if (Valor < 0)
			return '-' + fm(Math.abs(Valor),2);
		else
			return fm(Valor,2);
	}
</script>
<table width="30%"
	style="border:solid 1px;"
	align="center" border="0" cellspacing="0" cellpadding="0" summary="Control de Versiones de Presupuesto">
	<tr><td class="subTitulo" align="center">Monto Solicitado por Moneda</td></tr>
	<tr><td>&nbsp;</td></tr>
	<tr>
    <td valign="top" align="center">
			<form action="versiones_sql.cfm" method="post" name="form1" 
				onSubmit="this.CVFMmontoBase.value=qf(this.CVFMmontoBase);this.CVFMajusteUsuario.value=qf(this.CVFMajusteUsuario);this.CVFMajusteFinal.value=qf(this.CVFMajusteFinal);">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0">
					<tr>
						<td align="right"><strong>Moneda&nbsp;:&nbsp;</strong></td>
						<td>
						<cfif modocambio>
							<input type="hidden" name="Mcodigo" value="<cfoutput>#qry_cvfms.Mcodigo#</cfoutput>">
							<cfoutput>#qry_cvfms.Mnombre#</cfoutput>
						<cfelse>
							<select name="Mcodigo">
								<cfoutput query="qry_cvfms">
								<option value="#Mcodigo#">#Mnombre#</option>
								</cfoutput>
							</select>
						</cfif>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Monto Solicitado Base&nbsp;:&nbsp;</strong></td>
						<td><input name="CVFMmontoBase" id="CVFMmontoBase" 
									type="text" size="20" maxlength="18"
									value="<cfif modocambio><cfoutput>#LSCurrencyFormat(qry_cvfm.CVFMmontoBase,'none')#</cfoutput><cfelse>0.00</cfif>" 
								<cfif LvarEtapa EQ  0>
									style="text-align:right;"
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,2); sbSumar();"  
									onKeyUp="if(snumber(this,event,2,true)){ if(Key(event)=='13') {this.blur();}}" 
								<cfelse>
									readonly="yes" style="text-align:right; border:none;" 
									tabindex="-1"
								</cfif>
							>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Ajuste Usuario&nbsp;:&nbsp;</strong></td>
						<td><input name="CVFMajusteUsuario" id="CVFMajusteUsuario" 
									type="text" size="20" maxlength="18" 
									value="<cfif modocambio><cfoutput>#LSCurrencyFormat(qry_cvfm.CVFMajusteUsuario,'none')#</cfoutput><cfelse>0.00</cfif>" 
								<cfif LvarEtapa EQ  1>
									style="text-align:right;"
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,2); sbSumar();"  
									onKeyUp="if(snumber(this,event,2,true)){ if(Key(event)=='13') {this.blur();}}" 
								<cfelse>
									readonly="yes" style="text-align:right; border:none;" 
									tabindex="-1"
								</cfif>
							>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Monto Solicitado Usuario&nbsp;:&nbsp;</strong></td>
						<td><input name="CVFMversionUsuario" id="CVFMversionUsuario" 
									type="text" size="20" maxlength="18" 
									value="<cfif modocambio><cfoutput>#LSCurrencyFormat(qry_cvfm.CVFMversionUsuario,'none')#</cfoutput><cfelse>0.00</cfif>" 
									readonly="yes" style="text-align:right; border:none;" 
									tabindex="-1"
							>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Ajuste Final&nbsp;:&nbsp;</strong></td>
						<td><input name="CVFMajusteFinal" id="CVFMajusteFinal" 
									type="text" size="20" maxlength="18" 
									value="<cfif modocambio><cfoutput>#LSCurrencyFormat(qry_cvfm.CVFMajusteFinal,'none')#</cfoutput><cfelse>0.00</cfif>" 
								<cfif LvarEtapa EQ  2>
									style="text-align:right;"
									onFocus="this.value=qf(this); this.select();" 
									onBlur="javascript: fm(this,2); sbSumar();"  
									onKeyUp="if(snumber(this,event,2,true)){ if(Key(event)=='13') {this.blur();}}" 
								<cfelse>
									readonly="yes" style="text-align:right; border:none;" 
									tabindex="-1"
								</cfif>
							>
						</td>
					</tr>
					<tr>
						<td align="right"><strong>Monto Solicitado Final&nbsp;:&nbsp;</strong></td>
						<td><input name="CVFMversionFinal" id="CVFMversionFinal" 
									type="text" size="20" maxlength="18" 
									value="<cfif modocambio><cfoutput>#LSCurrencyFormat(qry_cvfm.CVFMversionFinal,'none')#</cfoutput><cfelse>0.00</cfif>" 
									readonly="yes" style="text-align:right; border:none;" 
									tabindex="-1"
							>
						</td>
					</tr>
				</table>
				<br>
				<cfif isdefined('qry_cv') and qry_cvAprobada.CVaprobada NEQ 1>
					<cf_botones sufijo="Moneda" modocambio="#modocambio#" include="Regresar" includeValues="Regresar">
				</cfif>								
				<br>
				
                <input type="hidden" name="ts_rversion" value="<cfif isdefined("ts")><cfoutput>#ts#</cfoutput></cfif>">				
              	<input type="hidden" name="CVid" value="<cfif isdefined("form.CVid")><cfoutput>#form.CVid#</cfoutput></cfif>">
				<input type="hidden" name="Cmayor" value="<cfif isdefined("form.Cmayor")><cfoutput>#form.Cmayor#</cfoutput></cfif>">
				<input type="hidden" name="CVPcuenta" value="<cfif isdefined("form.CVPcuenta")><cfoutput>#form.CVPcuenta#</cfoutput></cfif>">
				<input type="hidden" name="CPCano" value="<cfif isdefined("form.CPCano")><cfoutput>#form.CPCano#</cfoutput></cfif>">
				<input type="hidden" name="CPCmes" value="<cfif isdefined("form.CPCmes")><cfoutput>#form.CPCmes#</cfoutput></cfif>">
				<input type="hidden" name="Ocodigo" value="<cfif isdefined("form.Ocodigo")><cfoutput>#form.Ocodigo#</cfoutput></cfif>">
				<input type="hidden" name="BajaMonedaEsp" value="false">
			</form>
		</td>
  </tr>
</table>
<!--- QFORMS --->
