<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>
<cfset LvarIniciales=false>
<cfset LvarMcodigo="">

<cfif modo NEQ 'ALTA'>
	<cfquery datasource="#Session.DSN#" name="rsHtipocambio">
		select a.MIGFCid,
				a.Mcodigo,
				a.Periodo,
				a.Mes,
				a.FechaAlta,
				a.Factor,
				b.Mnombre,
				a.Pfecha
		from MIGFactorconversion a
			inner join  MIGMonedas b
				on a.Mcodigo=b.Mcodigo
		where a.MIGFCid=#form.MIGFCid#
		and a.Mcodigo=#form.Mcodigo#
		and a.Ecodigo =#Session.Ecodigo#
	</cfquery>
	<cfset LvarIniciales=true>
	<cfset LvarMcodigo=rsHtipocambio.Mcodigo>

</cfif>
<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select Mcodigo from Empresas where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>
<form action="SQLHtipocambio.cfm" method="post" name="form1" onSubmit="return validar(this);">
	<cfif modo EQ 'CAMBIO'>
		<cfif rsHtipocambio.Mes LT 10>
			<cfset LvarPerMes=#rsHtipocambio.Periodo#&0&#rsHtipocambio.Mes#>
		<cfelse>
			<cfset LvarPerMes=#rsHtipocambio.Periodo#&#rsHtipocambio.Mes#>
		</cfif>
		<cfoutput>
		<input type="hidden" id="Periodo" name="Periodo" value="#LvarPerMes#" />
		</cfoutput>
	</cfif>
  <table align="center">
		<tr valign="baseline">
      		<td nowrap align="right">Moneda:&nbsp;</td>
      		<td>
			<cfif MODO EQ "ALTA">
				<cf_conlis title="Lista de Monedas"
						campos = "Mcodigo,Miso4217,Msimbolo"
						desplegables = "N,S,S"
						modificables = "N,S,S"
						tabla="MIGMonedas"
						columnas="Mcodigo,Miso4217,Msimbolo"
						filtro="Ecodigo=#session.Ecodigo#"
						desplegar="Miso4217,Msimbolo"
						etiquetas="ISO,Simbolo"
						formatos="S,S"
						align="left,left"
						traerInicial="#LvarIniciales#"
						traerFiltro="Mcodigo=#LvarMcodigo#"
						filtrar_por="Miso4217,Msimbolo"
						tabindex="1"
						fparams="Mcodigo"
						/>
			<cfelse><cfoutput>
				<input type="text" name="Mnombre" value="#rsHtipocambio.Mnombre#"  size="30" maxlength="30" readonly="readonly" tabindex="1">
				<input type="hidden" name="Mcodigo" value="#rsHtipocambio.Mcodigo#">
				<input type="hidden" name="MIGFCid"  id="MIGFCid" value="#form.MIGFCid#" /></cfoutput>
			</cfif>

			</td>
    	</tr>
    	<tr>
			<td align="right">Fecha:&nbsp;</td>
			<td colspan="2" valign="top"><cfset fechadoc = LSDateFormat(Now(),'dd/mm/yyyy')>
				<cfif modo NEQ 'ALTA'>
					<cfset fechadoc = LSDateFormat(rsHtipocambio.Pfecha,'dd/mm/yyyy') >
				</cfif>
				<cf_sifcalendario form="form1" value="#fechadoc#" name="Pfecha" tabindex="1">
			</td>
		</tr>


    	<tr valign="baseline">
      		<td nowrap align="right">Factor:&nbsp;</td>
      		<td>
			<cfif modo NEQ 'ALTA'>
				<cf_inputNumber name="Factor"  value="#rsHtipocambio.Factor#" enteros="18" decimales="4" negativos="false" comas="no">
			<cfelse>
				<cf_inputNumber name="Factor"  value="" enteros="18" decimales="4" negativos="false" comas="no">
			</cfif>

			</td>
    	</tr>
		<tr valign="baseline">
			<cfset tabindex = 1>
			<td colspan="2" align="right" nowrap><cfinclude template="../portlets/pBotones.cfm"></td>
		</tr>
  </table>

</form>

<script type="text/javascript">
function validar(formulario)	{
	if (!btnSelected('Nuevo',document.form1) && !btnSelected('Baja',document.form1) && !btnSelected('Importar',document.form1)){
		var error_input;
		var error_msg = '';
	<cfif modo EQ 'ALTA'>
		if (formulario.Mcodigo.value == "") {
			error_msg += "\n - La Moneda no puede quedar en blanco.";
			error_input = formulario.Mcodigo;
		}

		Codigo = document.form1.Pfecha.value;
		Codigo = Codigo.replace(/(^\s*)|(\s*$)/g,"");
		if (Codigo.length==0){
			error_msg += "\n - La Fecha no puede quedar en blanco.";
			error_input = formulario.Pfecha;
		}
	</cfif>
		desp = document.form1.Factor.value;
		desp = desp.replace(/(^\s*)|(\s*$)/g,"");
		if (desp.length==0){
			error_msg += "\n - El Factor no puede quedar en blanco.";
			error_input = formulario.Factor;
		}


		// Validacion terminada
		if (error_msg.length != "") {
			alert("Por favor revise los siguiente datos:"+error_msg);
			return false;
		}
}
}
</script>
