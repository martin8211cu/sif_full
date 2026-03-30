<cfoutput>
<form name="formOri" method="post" action="../operacion/autorizacionNRP-sql.cfm" onsubmit="return fnValidar(this);">
<input type="hidden" name="CPNRPnum"	value="#form.CPNRPnum#" />
<input type="hidden" name="tipo"		value="TRASLADO" />
<input type="hidden" name="tab"			value="4" />
<input type="hidden" name="CPPid"		value="#rsNRPmeses.CPPid#">
<input type="hidden" name="CPCano"		value="#rsNRPmeses.CPCano#">
<input type="hidden" name="CPCmes"		value="#rsNRPmeses.CPCmes#">
<cf_navegacion name="CPNRPTsecuencia" default="-1">
<cfif url.CPNRPTsecuencia EQ -1>
	<cfset modoTR = 'ALTA'>
<cfelse>
	<cfset modoTR = 'CAMBIO'>
</cfif>
<cfquery name="rsTrasladoCta" datasource="#Session.DSN#">
	select	a.CPNRPnum, a.CPNRPTsecuencia, 
			<cf_dbfunction name="to_char" args="a.CPCano" datasource="#session.DSN#">
			#_Cat#'-'#_Cat#
			case a.CPCmes 
				when 1 then 'ENE' 
				when 2 then 'FEB' 
				when 3 then 'MAR' 
				when 4 then 'ABR' 
				when 5 then 'MAY' 
				when 6 then 'JUN' 
				when 7 then 'JUL' 
				when 8 then 'AGO' 
				when 9 then 'SET' 
				when 10 then 'OCT' 
				when 11 then 'NOV' 
				when 12 then 'DIC' 
				else '' 
			end as Mes,
			o.Ocodigo, o.Oficodigo,
			b.CPcuenta, b.CPformato, b.CPdescripcion,
			CPNRPTmonto
	from 	CPNRPtrasladoOri a
				left join CPresupuesto b
					 on b.CPcuenta = a.CPcuenta
					and b.Ecodigo  = a.Ecodigo
				left join Oficinas o
					 on o.Ecodigo = a.Ecodigo
					and o.Ocodigo = a.Ocodigo
	where	a.Ecodigo = #Session.Ecodigo# 
	  and 	a.CPNRPnum = #Form.CPNRPnum#
	  and	a.CPNRPTsecuencia = #form.CPNRPTsecuencia#
</cfquery>
<table width="100%" border="0">
	<tr>
		<td colspan="4" style="border-bottom:solid 1px ##CCCCCC">
			Cuenta Origen de Traslado de Presupuesto
		</td>
	</tr>
	<tr>
		<td align="right" width="160">
			Mes:&nbsp;
		</td>
		<td align="left">
			<cfif modoTR EQ "CAMBIO">
				#rsTrasladoCta.Mes#
				</td>
				<td align="right">
					<strong>Prioridad:&nbsp;</strong>
				</td>
				<td>
					<input type="hidden" name="CPNRPTsecuencia_Ant" value="#rsTrasladoCta.CPNRPTsecuencia#">
					<cf_inputnumber name="CPNRPTsecuencia" enteros="8" decimales="0" value="#rsTrasladoCta.CPNRPTsecuencia#">
			<cfelse>
				#rsNRPmeses.Mes#
			</cfif>
		</td>
	</tr>
	<tr>
		<td align="right" width="160">
			Cuenta:&nbsp;
		</td>
		<td align="left" colspan="3">
			<cfinclude template="conlis_CPcuenta.cfm">
		</td>
	</tr>
	<tr>
		<td align="right" width="160">
			Descripción:&nbsp;
		</td>
		<td align="left" colspan="3">
			<input name="CPdescripcion" size="75"
				readonly tabindex="-1"
				style="border:solid 1px ##CCCCCC"
				value="<cfif rsTrasladoCta.CPcuenta neq "">#rsTrasladoCta.CPdescripcion#</cfif>"
			/>
		</td>
	</tr>
	<tr>
		<td align="right" width="160">
			Oficina:&nbsp;
		</td>
		<td align="left" colspan="3">
			<cf_conlis title="Lista de Oficinas"
				campos = "Ocodigo, Oficodigo, Odescripcion" 
				desplegables = "N,S,S" 
				modificables = "N,S,N" 
				size = "0,10,60"
				tabla="Oficinas"
				columnas="Ocodigo, Oficodigo, Odescripcion"
				filtro="Ecodigo = #Session.Ecodigo# order by Oficodigo"
				desplegar="Oficodigo, Odescripcion"
				etiquetas="C&oacute;digo, Descripci&oacute;n"
				formatos="S,S"
				align="left,left"
				asignar="Ocodigo, Oficodigo, Odescripcion"
				asignarformatos="S,S,S"
				showEmptyListMsg="true"
				debug="false"
				tabindex="1"
				form="formOri"
				funcion="funcOcodigo"
				traerInicial	= "#rsTrasladoCta.Ocodigo NEQ ''#"
				traerFiltro		= "Ocodigo = #rsTrasladoCta.Ocodigo#"
			>
		</td>
	</tr>
	<tr>
		<td align="right" width="160">
			Tipo&nbsp;Control:&nbsp;
		</td>
		<td align="left">
			<input name="CPCPtipoControl" 
				readonly tabindex="-1"
				style="border:solid 1px ##CCCCCC"
			/>
		</td>
		<td align="right">
			Calculo&nbsp;Control:&nbsp;
		</td>
		<td align="left">
			<input name="CPCPcalculoControl" 
				readonly tabindex="-1"
				style="border:solid 1px ##CCCCCC"
			/>
		</td>
	</tr>
	<tr>
		<td align="right" width="160">
			Disponible:&nbsp;
		</td>
		<td align="left">
			<input name="CPCdisponible" size="22"
				readonly tabindex="-1"
				style="border:solid 1px ##CCCCCC"
			/>
		</td>
		<td align="right">
			Monto:&nbsp;
		</td>
		<td align="left">
			<cf_inputnumber name="CPNRPTmonto" enteros="15" decimales="2" value="#rsTrasladoCta.CPNRPTmonto#">
		</td>
	</tr>
	<tr>
		<td align="right" colspan="4">
			<cf_botones modo="#modoTR#" sufijo="TR">
		</td>
	</tr>
</table>
</form>
</cfoutput>
<script>
	function funcOcodigo(f)
	{
		if ((document.formOri.Ocodigo.value != "") && (document.formOri.CPcuenta.value != ""))
			trae_formOri_CPformato(true);
	}
	function fnValidar(f)
	{
		if (f.botonSelTR.value == "AltaTR" || f.botonSelTR.value == "CambioTR")
		{
			if (f.CPcuenta.value == "")
			{
				alert("La Cuenta de Presupuesto es Obligatoria");
				return false;
			}
			if (f.Ocodigo.value == "")
			{
				alert("La Oficina es Obligatoria");
				return false;
			}
			if (f.CPNRPTmonto.value == "")
			{
				alert("El Monto a Trasladar es Obligatorio");
				return false;
			}
			var CPCdisponible	= parseFloat(qf(f.CPCdisponible.value));
			var CPNRPTmonto		= parseFloat(qf(f.CPNRPTmonto.value));
			if (CPNRPTmonto > CPCdisponible)
			{
				alert('El Monto a Trasladar (' + CPNRPTmonto + ') no debe superar el Disponible (' + CPCdisponible + ') de la cuenta');
				return false;
			}
			return true;
		}
	}
</script>