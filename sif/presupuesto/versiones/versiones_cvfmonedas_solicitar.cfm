<script language="javascript" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
<cfparam name="form.CVPcuenta" default="-2">
<cfif form.CVPcuenta EQ -2><cfreturn></cfif>

<style>
	.Totales 
	{ 
		background-color: #CCCCCC;
	}
</style>

<cfquery name="qry_cv" datasource="#Session.dsn#">
	select Ecodigo, CVid, CVtipo, CVdescripcion, CPPid, CVaprobada, CVestado, ts_rversion
	from CVersion
	where Ecodigo = #session.ecodigo#
	and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
</cfquery>

<cfquery name="qry_cvp" datasource="#Session.dsn#">
	select CPcuenta, CVPorigen
	from CVPresupuesto
	where Ecodigo = #session.ecodigo#
	and CVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.cvid#">
	and CVPcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CVPcuenta#">
</cfquery>

<cfif qry_cvp.CVPorigen EQ "">
	<cfset LvarEtapa = qry_cv.CVestado>	
<cfelse>
	<cfset LvarEtapa = "-1">
</cfif>

<cfif not IsNumeric(form.Mcodigo)>
	<cfthrow message="El valor de form Mcodigo no es numérico">
</cfif>
<cfif not IsNumeric(form.Ocodigo)>
	<cfthrow message="El valor de form Ocodigo no es numérico">
</cfif>
<cfif not IsNumeric(form.cvid)>
	<cfthrow message="El valor de form cvid no es numérico">
</cfif>
<cfif not isValid("string", form.Cmayor)>
	<cfthrow message="El valor de form Cmayor no es caracter">
</cfif>
<cfif not IsNumeric(form.cvpcuenta)>
	<cfthrow message="El valor de form cvpcuenta no es numérico">
</cfif>

<cfquery name="qry_lista" datasource="#session.dsn#">
 	select 	#form.Mcodigo# 	as Mcodigo, 
			#form.Ocodigo# 	as Ocodigo, 
			#form.CVid# 		as CVid, 
			'#form.Cmayor#' 	as Cmayor, 
			#form.CVPcuenta#	as CVPcuenta, 
			m.CPCano, m.CPCmes, 
			case m.CPCmes
				when 1 then 'Ene'
				when 2 then 'Feb'
				when 3 then 'Mar'
				when 4 then 'Abr'
				when 5 then 'May'
				when 6 then 'Jun'
				when 7 then 'Jul'
				when 8 then 'Ago'
				when 9 then 'Sep'
				when 10 then 'Oct'
				when 11 then 'Nov'
				when 12 then 'Dic'
			end as Mes,
			coalesce(a.CVFMmontoBase,0)		as montoBase, 
			coalesce(a.CVFMajusteUsuario,0)	as AjusteU,
			coalesce(a.CVFMajusteFinal,0) 	as AjusteF,
			case 
				when coalesce(a.CVFMtipoCambio,0) <> 0 
					then coalesce((a.CVFMmontoBase+a.CVFMajusteUsuario+a.CVFMajusteFinal)*a.CVFMtipoCambio,0)
					else 0
			end as colonesSolicitado, 
			<cfif qry_cv.CVtipo EQ "2">
			coalesce((a.CVFMmontoBase+a.CVFMajusteUsuario+a.CVFMajusteFinal) - a.CVFMmontoAplicar,0) as montoActual,
			case 
				when coalesce(a.CVFMtipoCambio,0) <> 0 
					then coalesce(((a.CVFMmontoBase+a.CVFMajusteUsuario+a.CVFMajusteFinal) - a.CVFMmontoAplicar)*a.CVFMtipoCambio,0)
					else 0
			end as colonesActual,
			coalesce(a.CVFMmontoAplicar,0) as montoModificar,
			case 
				when coalesce(a.CVFMtipoCambio,0) <> 0 
					then coalesce(a.CVFMmontoAplicar*a.CVFMtipoCambio,0)
					else 0
			end as colonesModificar,
			</cfif>
			coalesce(a.CVFMtipoCambio,
						case 
							when rtrim(my.Ctipo) in ('A','G')
								then p.CPTipoCambioVenta
								else p.CPTipoCambioCompra
						end
					)
			as TipoCambio
	from CVersion v, CVMayor my, CPmeses m
		left outer join CPTipoCambioProyectadoMes p
			on p.Ecodigo = m.Ecodigo
		   and p.CPCano  = m.CPCano
		   and p.CPCmes  = m.CPCmes
		   and p.Mcodigo = #form.Mcodigo#
		left outer join CVFormulacionMonedas a
			 on a.Ecodigo 	= m.Ecodigo
			and a.CVid 		= #form.cvid#
			and a.CPCano 	= m.CPCano
			and a.CPCmes 	= m.CPCmes
			and a.CVPcuenta = #form.CVPcuenta#
			and a.Ocodigo 	= #form.Ocodigo#
			and a.Mcodigo 	= #form.Mcodigo#
	where v.Ecodigo 	= #session.ecodigo#
	  and v.CVid 		= #form.CVid#
	  and m.Ecodigo 	= v.Ecodigo
	  and m.CPPid 		= v.CPPid
	  and my.Ecodigo 	= v.Ecodigo
	  and my.CVid 		= v.CVid
	  and my.Cmayor 	= '#form.Cmayor#'
	order by m.CPCano, m.CPCmes
</cfquery>
<form name="lista5" action="versiones_sql.cfm" method="post">
<table width="99%"align="center" border="0" cellspacing="0" cellpadding="0" summary="Control de Versiones de Presupuesto">
<tr><td class="subTitulo" align="center">Lista de Montos Solicitados por Mes</td></tr>
<tr><td>
<cfoutput>
	<input type="hidden" name="CVid" id="CVid" value="#form.CVid#">
	<input type="hidden" name="CPPid" id="CPPid" value="#form.CPPid#">
	<input type="hidden" name="Cmayor" id="Cmayor" value="#form.Cmayor#">
	<input type="hidden" name="CVPcuenta" id="CVPcuenta" value="#form.CVPcuenta#">
	<input type="hidden" name="Ocodigo" id="Ocodigo" value="#form.Ocodigo#">
	<input type="hidden" name="Mcodigo" id="Mcodigo" value="#form.Mcodigo#">
	<input type="hidden" name="btnMonedas" id="btnMonedas" value="yes">
<table align="center" width="50%" cellpadding="0" cellspacing="0" border="0">
	<tr>
		<td class="tituloListas">
			<strong>Año</strong>
		</td>
		<td class="tituloListas">
			<strong>Mes</strong>
		</td>
		<td class="tituloListas" align="right">
			<strong>Version<BR>Base<BR>#LvarMnombreSolicitud#</strong>
		</td>
		<td class="tituloListas" align="right">
			<strong>Ajuste<BR>Usuario<BR>#LvarMnombreSolicitud#</strong>
		</td>
		<td class="tituloListas" align="right">
			<strong>Version<BR>Usuario<BR>#LvarMnombreSolicitud#</strong>
		</td>
		<td class="tituloListas" align="right">
			<strong>Ajuste<BR>Final<BR>#LvarMnombreSolicitud#</strong>
		</td>
		<td class="tituloListas" align="right">
			<strong>Monto Final<BR>Solicitado<BR>#LvarMnombreSolicitud#</strong>
		</td>
	<cfif form.Mcodigo NEQ LvarMcodigoEmpresa>
		<cfif qry_cv.CVtipo EQ "2">
		<td class="tituloListas" align="right">
			<strong>Formulaciones<BR>Aprobadas<BR>#LvarMnombreSolicitud#</strong>
		</td>
		<td class="tituloListas" align="right">
			<strong>Modificación<BR>Solicitada<BR>#LvarMnombreSolicitud#</strong>
		</td>
		</cfif>
		<td class="tituloListas" align="right">
			<strong>Tipo<BR>Cambio<BR>Proy.</strong>
		</td>
		<td class="tituloListas" align="right">
			<strong>Monto Final<BR>Solicitado<BR>#LvarMnombreEmpresa#</strong>
		</td>
	</cfif>
	<cfif qry_cv.CVtipo EQ "2">
		<td class="tituloListas" align="right">
			<strong>Formulaciones<BR>Aprobadas<BR>#LvarMnombreEmpresa#</strong>
		</td>
		<td class="tituloListas" align="right">
			<strong>Modificación<BR>Solicitada<BR>#LvarMnombreEmpresa#</strong>
		</td>
	</cfif>
	</tr>
</cfoutput>
	<cfset LvarActualM_Total =0>
	<cfset LvarActualL_Total =0>
	<cfoutput query="qry_lista">
	<tr <cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>>
		<td>
			#CPCano#
		</td>
		<td>
			#Mes#
		</td>
		<cfif LvarAuxAnoMes LTE CPCano*100+CPCmes>
			<cfif qry_cv.CVtipo EQ "2">
				<cfif montoBase eq "">
					<cfset qry_lista.montoBase = MontoActual>
					<cfset qry_lista.ColonesSolicitado = ColonesActual>
					<cfset qry_lista.ColonesModificar = 0>
				</cfif>
			<cfelse>
				<cfif montoBase eq "">
					<cfset qry_lista.MontoBase = 0>
					<cfset qry_lista.ColonesSolicitado = 0>
				</cfif>
			</cfif>
			<td align="right">
				<input 	type="text" name="MontoM_#CPCano#_#CPCmes#" id="MontoM_#CPCano#_#CPCmes#"
						value="#lsCurrencyformat(MontoBase,'none')#"
						size="20"
					<cfif not LvarVinculada and LvarEtapa EQ  0>
						style="text-align:right;"
						onFocus="this.value=qf(this); this.select();" 
						onBlur="javascript: fm(this,2); sbSumar(#CPCano#,#CPCmes#);"  
						onKeyUp="if(snumber(this,event,2,true)){ if(Key(event)=='13') {this.blur();}}" 
					<cfelse>
						readonly="yes" style="text-align:right; border:none;" 
						tabindex="-1"
						<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
					</cfif>
				>
			</td>
			<td align="right">
				<input 	type="text" name="AjusteU_#CPCano#_#CPCmes#" id="AjusteU_#CPCano#_#CPCmes#" 
						value="#lsCurrencyformat(AjusteU,'none')#"
						size="20"
					<cfif not LvarVinculada and LvarEtapa EQ  1>
						style="text-align:right;" 
						onFocus="this.value=qf(this); this.select();" 
						onBlur="javascript: fm(this,2); sbSumar(#CPCano#,#CPCmes#);"  
						onKeyUp="if(snumber(this,event,2,true)){ if(Key(event)=='13') {this.blur();}}" 
					<cfelse>
						readonly="yes" style="text-align:right; border:none;" 
						tabindex="-1"
						<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
					</cfif>
				>
			</td>
			<td align="right">
				<input 	type="text" name="VersionU_#CPCano#_#CPCmes#" id="VersionU_#CPCano#_#CPCmes#" 
						value="#lsCurrencyformat(MontoBase+AjusteU,'none')#"
						size="20"
						readonly="yes" style="text-align:right; border:none;" 
						tabindex="-1"
						<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
				>
			</td>
			<td align="right">
				<input 	type="text" name="AjusteF_#CPCano#_#CPCmes#" id="AjusteF_#CPCano#_#CPCmes#" 
						value="#lsCurrencyformat(AjusteF,'none')#"
						size="20"
					<cfif not LvarVinculada and LvarEtapa EQ  2>
						style="text-align:right;" 
						onFocus="this.value=qf(this); this.select();" 
						onBlur="javascript: fm(this,2); sbSumar(#CPCano#,#CPCmes#);"  
						onKeyUp="if(snumber(this,event,2,true)){ if(Key(event)=='13') {this.blur();}}" 
					<cfelse>
						readonly="yes" style="text-align:right; border:none;" 
						tabindex="-1"
						<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
					</cfif>
				>
			</td>
			<td align="right">
				<input 	type="text" name="VersionF_#CPCano#_#CPCmes#" id="VersionF_#CPCano#_#CPCmes#" 
						value="#lsCurrencyformat(MontoBase+AjusteU+AjusteF,'none')#"
						size="20"
						readonly="yes" style="text-align:right; border:none;" 
						tabindex="-1"
						<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
				>
			</td>
		<cfelse>
			<cfif qry_cv.CVtipo EQ "2">
				<cfset qry_lista.MontoBase = MontoActual>
				<cfset qry_lista.ColonesSolicitado = ColonesActual>
				<cfset qry_lista.ColonesModificar = 0>
			<cfelse>
				<cfset qry_lista.MontoBase = 0>
				<cfset qry_lista.ColonesSolicitado = 0>
			</cfif>
			<td align="right">
				<input 	type="text" name="MontoM_#CPCano#_#CPCmes#" id="MontoM_#CPCano#_#CPCmes#" 
						value="#lsCurrencyformat(MontoBase,'none')#"
						readonly="yes" style="text-align:right; border:none;" 
						tabindex="-1"
						size="20"
						<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
				>
			</td>
			<td align="right">
				<input 	type="text" name="AjusteU_#CPCano#_#CPCmes#" id="AjusteU_#CPCano#_#CPCmes#" 
						value="#lsCurrencyformat(AjusteU,'none')#"
						readonly="yes" style="text-align:right; border:none;" 
						tabindex="-1"
						size="20"
						<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
				>
			</td>
			<td align="right">
				<input 	type="text" name="VersionU_#CPCano#_#CPCmes#" id="VersionU_#CPCano#_#CPCmes#" 
						value="#lsCurrencyformat(MontoBase+AjusteU,'none')#"
						readonly="yes" style="text-align:right; border:none;" 
						tabindex="-1"
						size="20"
						<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
				>
			</td>
			<td align="right">
				<input 	type="text" name="AjusteF_#CPCano#_#CPCmes#" id="AjusteF_#CPCano#_#CPCmes#" 
						value="#lsCurrencyformat(AjusteF,'none')#"
						readonly="yes" style="text-align:right; border:none;" 
						tabindex="-1"
						size="20"
						<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
				>
			</td>
			<td align="right">
				<input 	type="text" name="VersionF_#CPCano#_#CPCmes#" id="VersionF_#CPCano#_#CPCmes#" 
						value="#lsCurrencyformat(MontoBase+AjusteU+AjusteF,'none')#"
						readonly="yes" style="text-align:right; border:none;" 
						tabindex="-1"
						size="20"
						<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
				>
			</td>
		</cfif>
		</td>
	<cfif form.Mcodigo NEQ LvarMcodigoEmpresa>
		<cfif qry_cv.CVtipo EQ "2">
		<td align="right">
			<input 	type="text" name="ActualM_#CPCano#_#CPCmes#" id="ActualM_#CPCano#_#CPCmes#" 
					value="#lsCurrencyformat(MontoActual,'none')#" 
					readonly="yes" style="text-align:right; border:none;" 
					tabindex="-1"
					size="20"
					<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
			>
			<cfset LvarActualM_Total = LvarActualM_Total + MontoActual>
		</td>
			
		<td align="right">
			<input 	type="text" name="CambioM_#CPCano#_#CPCmes#" id="CambioM_#CPCano#_#CPCmes#" 
					value="#lsCurrencyformat(montoModificar,'none')#" 
					readonly="yes" style="text-align:right; border:none;" 
					tabindex="-1"
					size="20"
					<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
			>
		</td>
		</cfif>
		<td align="right">
			<input 	type="text" name="TC_#CPCano#_#CPCmes#" id="TC_#CPCano#_#CPCmes#" 
					value="#lsCurrencyformat(tipoCambio,'none')#" 
					readonly="yes" style="text-align:right; border:none; <cfif tipoCambio EQ 0>color:##FF0000</cfif>" 
					tabindex="-1"
					size="8"
					<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
			>
		</td>
		<td align="right">
			<input 	type="text" name="MontoL_#CPCano#_#CPCmes#" id="MontoL_#CPCano#_#CPCmes#" 
					value="#lsCurrencyformat(ColonesSolicitado,'none')#" 
					readonly="yes" style="text-align:right; border:none;" 
					tabindex="-1"
					size="20"
					<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
			>
		</td>
	</cfif>
		<cfif qry_cv.CVtipo EQ "2">
		<td align="right">
			<input 	type="text" name="ActualL_#CPCano#_#CPCmes#" id="ActualL_#CPCano#_#CPCmes#" 
					value="#lsCurrencyformat(colonesActual,'none')#" 
					readonly="yes" style="text-align:right; border:none;" 
					tabindex="-1"
					size="20"
					<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
			>
			<cfset LvarActualL_Total = LvarActualL_Total + colonesActual>
		</td>
		<td align="right">
			<input 	type="text" name="CambioL_#CPCano#_#CPCmes#" id="CambioL_#CPCano#_#CPCmes#" 
					value="#lsCurrencyformat(colonesModificar,'none')#" 
					readonly="yes" style="text-align:right; border:none;" 
					tabindex="-1"
					size="20"
					<cfif qry_lista.currentRow mod 2 EQ 0>class="listaPar"<cfelse>class="listaNon"</cfif>
			>
		</td>
		</cfif>
	</tr>
	</cfoutput>
	<tr>
		<td class="Totales" colspan="2">
			<strong>Total Solicitado</strong>
		</td>
		<td class="Totales" align="right">
			<input 	type="text" name="MontoM_Total" id="MontoM_Total"
					value="0.00" 
					readonly="yes" style="text-align:right; border:none; font-weight:100;" 
					tabindex="-1"
					size="20"
					class="Totales" 
			>
		</td>
		<td class="Totales" align="right">
			<input 	type="text" name="AjusteU_Total" id="AjusteU_Total"
					value="0.00" 
					readonly="yes" style="text-align:right; border:none; font-weight:100;" 
					tabindex="-1"
					size="20"
					class="Totales" 
			>
		</td>
		<td class="Totales" align="right">
			<input 	type="text" name="VersionU_Total" id="VersionU_Total"
					value="0.00" 
					readonly="yes" style="text-align:right; border:none; font-weight:100;" 
					tabindex="-1"
					size="20"
					class="Totales" 
			>
		</td>
		<td class="Totales" align="right">
			<input 	type="text" name="AjusteF_Total" id="AjusteF_Total"
					value="0.00" 
					readonly="yes" style="text-align:right; border:none; font-weight:100;" 
					tabindex="-1"
					size="20"
					class="Totales" 
			>
		</td>
		<td class="Totales" align="right">
			<input 	type="text" name="VersionF_Total" id="VersionF_Total"
					value="0.00" 
					readonly="yes" style="text-align:right; border:none; font-weight:100;" 
					tabindex="-1"
					size="20"
					class="Totales" 
			>
		</td>
	<cfif form.Mcodigo NEQ LvarMcodigoEmpresa>
		<cfif qry_cv.CVtipo EQ "2">
		<td class="Totales" align="right">
			<cfoutput>#lsCurrencyformat(LvarActualM_Total,'none')#</cfoutput>
		</td>
		<td class="Totales" align="right">
			<input 	type="text" name="CambioM_Total" id="CambioM_Total"
					value="0.00" 
					readonly="yes" style="text-align:right; border:none; font-weight:100;" 
					tabindex="-1"
					size="20"
					class="Totales" 
			>
		</td>
		</cfif>
		<td class="Totales" align="right">&nbsp;</td>
		<td class="Totales" align="right">
			<input 	type="text" name="MontoL_Total" id="MontoL_Total"
					value="0.00" 
					readonly="yes" style="text-align:right; border:none; font-weight:100;" 
					tabindex="-1"
					size="20"
					class="Totales" 
			>
		</td>
	</cfif>
		<cfif qry_cv.CVtipo EQ "2">
		<td class="Totales" align="right">
			<cfoutput>#lsCurrencyformat(LvarActualL_Total,'none')#</cfoutput>
		</td>
		<td class="Totales" align="right">
			<input 	type="text" name="CambioL_Total" id="CambioL_Total"
					value="0.00" 
					readonly="yes" style="text-align:right; border:none; font-weight:100;" 
					tabindex="-1"
					size="20"
					class="Totales" 
			>
		</td>
		</cfif>
	</tr>
	<tr><td>&nbsp;</td></tr>
</table>
</td></tr></table>
</form>
<script language="javascript" type="text/javascript">
	function funcEliminar(mcodigo){
		document.form1.Mcodigo.value=mcodigo;
		document.form1.BajaMonedaEsp.value=true;
		document.form1.submit();
		document.lista5.nosubmit=true;
	}
	function funcCambiar(){
	<cfoutput query="qry_lista">
		document.getElementById("MontoM_#CPCano#_#CPCmes#").value=qf(document.getElementById("MontoM_#CPCano#_#CPCmes#").value);
		document.getElementById("AjusteU_#CPCano#_#CPCmes#").value=qf(document.getElementById("AjusteU_#CPCano#_#CPCmes#").value);
		document.getElementById("AjusteF_#CPCano#_#CPCmes#").value=qf(document.getElementById("AjusteF_#CPCano#_#CPCmes#").value);
	</cfoutput>
		document.lista5.submit();
		return false;
	}
	function sbSumar(ano, mes){
		if (ano > 0) {
			var LvarBaseM = parseFloat(qf(document.getElementById("MontoM_" + ano + "_" + mes).value));
			var LvarAjusteU = parseFloat(qf(document.getElementById("AjusteU_" + ano + "_" + mes).value));
			var LvarAjusteF = parseFloat(qf(document.getElementById("AjusteF_" + ano + "_" + mes).value));
			var LvarVersionU = LvarBaseM + LvarAjusteU;
			var LvarVersionF = LvarVersionU + LvarAjusteF;
			document.getElementById("VersionU_" + ano + "_" + mes).value = nfm(LvarVersionU);
			document.getElementById("VersionF_" + ano + "_" + mes).value = nfm(LvarVersionF);
	<cfif form.Mcodigo NEQ LvarMcodigoEmpresa>
		<cfif qry_cv.CVtipo EQ "2">
			var LvarActualM = parseFloat(qf(document.getElementById("ActualM_" + ano + "_" + mes).value));
			var LvarCambioM = LvarVersionF - LvarActualM;
			document.getElementById("CambioM_" + ano + "_" + mes).value = nfm(LvarCambioM);
		</cfif>
			var LvarTipoCambio = parseFloat(qf(document.getElementById("TC_" + ano + "_" + mes).value));
			var LvarFinalL = LvarVersionF*LvarTipoCambio;
			document.getElementById("MontoL_" + ano + "_" + mes).value = fm(LvarFinalL,2);
	<cfelse>
			var LvarFinalL = LvarVersionF;
	</cfif>
	<cfif qry_cv.CVtipo EQ "2">
			var LvarActualL = parseFloat(qf(document.getElementById("ActualL_" + ano + "_" + mes).value));
			var LvarCambioL = LvarFinalL - LvarActualL;
			document.getElementById("CambioL_" + ano + "_" + mes).value = nfm(LvarCambioL);
	</cfif>
		}
		var LvarFaltaTipoCambio = false;
		var LvarBaseM_Total = 0;
		var LvarAjusteU_Total = 0;
		var LvarAjusteF_Total = 0;
		var LvarVersionU_Total = 0;
		var LvarVersionF_Total = 0;
	<cfif form.Mcodigo NEQ LvarMcodigoEmpresa>
		<cfif qry_cv.CVtipo EQ "2">
		var LvarCambioM_Total = 0;
		</cfif>
		var LvarFinalL_Total = 0;
	</cfif>
		<cfif qry_cv.CVtipo EQ "2">
		var LvarCambioL_Total = 0;
		</cfif>
	<cfoutput query="qry_lista">
		LvarBaseM 			= parseFloat(qf(document.getElementById("MontoM_#CPCano#_#CPCmes#").value));
		LvarBaseM_Total 	+= LvarBaseM;
		LvarAjusteU 		= parseFloat(qf(document.getElementById("AjusteU_#CPCano#_#CPCmes#").value));
		LvarAjusteU_Total 	+= LvarAjusteU;
		LvarAjusteF 		= parseFloat(qf(document.getElementById("AjusteF_#CPCano#_#CPCmes#").value));
		LvarAjusteF_Total 	+= LvarAjusteF;
		LvarVersionU 		= parseFloat(qf(document.getElementById("VersionU_#CPCano#_#CPCmes#").value));
		LvarVersionU_Total 	+= LvarVersionU;
		LvarVersionF 		= parseFloat(qf(document.getElementById("VersionF_#CPCano#_#CPCmes#").value));
		LvarVersionF_Total 	+= LvarVersionF;
		<cfif form.Mcodigo NEQ LvarMcodigoEmpresa>
			<cfif qry_cv.CVtipo EQ "2">
			LvarCambioM_Total += parseFloat(qf(document.lista5.CambioM_#CPCano#_#CPCmes#.value));
			</cfif>
			if ((LvarAjusteF != 0) && (document.lista5.TC_#CPCano#_#CPCmes#.value == "0.00"))
			{
				LvarFaltaTipoCambio = true;
			}
			else
				LvarFinalL_Total += parseFloat(qf(document.lista5.MontoL_#CPCano#_#CPCmes#.value));
		</cfif>
		<cfif qry_cv.CVtipo EQ "2">
			LvarCambioL_Total += parseFloat(qf(document.lista5.CambioL_#CPCano#_#CPCmes#.value));
		</cfif>
	</cfoutput>
		document.getElementById("MontoM_Total").value = nfm(LvarBaseM_Total,2);
		document.getElementById("AjusteU_Total").value = nfm(LvarAjusteU_Total,2);
		document.getElementById("AjusteF_Total").value = nfm(LvarAjusteF_Total,2);
		document.getElementById("VersionU_Total").value = nfm(LvarVersionU_Total,2);
		document.getElementById("VersionF_Total").value = nfm(LvarVersionF_Total,2);
	<cfif form.Mcodigo NEQ LvarMcodigoEmpresa>
		<cfif qry_cv.CVtipo EQ "2">
		document.getElementById("CambioM_Total").value = nfm(LvarCambioM_Total,2);
		</cfif>
		if (LvarFaltaTipoCambio)
			document.getElementById("MontoL_Total").value = '???';
		else
			document.getElementById("MontoL_Total").value = nfm(LvarFinalL_Total,2);
	</cfif>
		<cfif qry_cv.CVtipo EQ "2">
		if (LvarFaltaTipoCambio)
			document.getElementById("CambioL_Total").value = '???';
		else
			document.getElementById("CambioL_Total").value = nfm(LvarCambioL_Total,2);
		</cfif>
		return false;
	}
	function nfm(Valor)
	{
		if (Valor < 0)
			return '-' + fm(Math.abs(Valor),2);
		else
			return fm(Valor,2);
	}
	sbSumar(0,0);
</script>