<!---
	Modificado por Gustavo Fonseca H.
		Fecha: 6-9-2005.
		Motivo: Se valida que "El valor del Socio Hasta debe ser mayor al valor del Socio Desde" (SNnumero).
 --->
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_ISI" default="Incluir saldo inicial" returnvariable="LB_ISI" xmlfile="EstadoCuenta.xml">
<cfinvoke component="sif.Componentes.Translate" method="Translate" key="LB_IncluirAfectacionNC" default="Incluir Afectaciones NC" returnvariable="LB_IncluirAfectacionNC" xmlfile="EstadoCuenta.xml">
<!--- <cf_dump var="#form#"> --->

<cfif isdefined("url.q") AND #url.q# NEQ "">
	<cfset form.q = #url.q#>
</cfif>

<cfif isdefined("url.SaldoI") AND #url.SaldoI# NEQ "">
	<cfset form.SaldoI = #url.SaldoI#>
</cfif>


<cf_templateheader title="SIF - Cuentas por Pagar">
           <cf_web_portlet_start titulo='Integración de Saldos'>
		  	<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfif isdefined("url.q")><cfset form.q=url.q></cfif>
			<form name="form1" method="post" action="" onSubmit="javascript: return setAction();">
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
				  <tr>
					<td class="FileLabel">Tipo:</td>
					<td colspan="1">
						<select name="q">
							<option value="1" <cfif isdefined("form.q") and form.q eq 1>selected</cfif>>Resumido</option>
							<option value="2" <cfif isdefined("form.q") and form.q eq 2>selected</cfif>>Por Documento</option>
						</select>
					</td>

					<td>
					<cfoutput>#LB_ISI#:</cfoutput>
					</td>
					<td>
						<input type="checkbox" name="SaldoI" value="1" <cfif isdefined("form.SaldoI") AND #form.SaldoI# eq 1>checked</cfif>>
					</td>

				  </tr>
				  <tr>
					<td class="FileLabel">Fecha Desde:</td>
					<cfif isdefined("form.Fecha1") AND #form.Fecha1# NEQ "">
						<cfset lvarDate1 = #form.Fecha1#>
					<cfelse>
						<cfset lvarDate1 = #LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#>
					</cfif>
					<td>
						<cf_sifcalendario name="fecha1" value="#lvarDate1#">
					</td>
					<td class="FileLabel">Fecha Hasta:</td>
					<cfif isdefined("form.Fecha2") AND #form.Fecha2# NEQ "">
						<cfset lvarDate2 = #form.Fecha2#>
					<cfelse>
						<cfset lvarDate2 = #LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#>
					</cfif>
					<td>
						<cf_sifcalendario name="fecha2" value="#lvarDate2#">
					</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td class="FileLabel">Socio Desde:</td>
					<cfif isdefined("form.SNCODIGO1") AND #form.SNCODIGO1# NEQ "">
						<cfset lvarSN1 = #form.SNCODIGO1#>
					<cfelse>
						<cfset lvarSN1 = "">
					</cfif>
					<td><cf_sifsociosnegocios2 Proveedores="SI" idquery="#lvarSN1#" SNcodigo="SNcodigo1" SNnombre="SNnombre1" SNnumero="SNnumero1" frame="frSNnombre11"></td>
					<td class="FileLabel">Socio Hasta:</td>
					<cfif isdefined("form.SNCODIGO2") AND #form.SNCODIGO2# NEQ "">
						<cfset lvarSN2 = #form.SNCODIGO2#>
					<cfelse>
						<cfset lvarSN2 = "">
					</cfif>
					<td><cf_sifsociosnegocios2 Proveedores="SI" idquery="#lvarSN2#" SNcodigo="SNcodigo2" SNnombre="SNnombre2" SNnumero="SNnumero2" frame="frSNnombre12"></td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					  <td><cfoutput>#LB_IncluirAfectacionNC#</cfoutput></td>
					  <td><input type="checkbox" name="IncluirAfecNC" checked value="1"  <!--- <cfif isdefined("form.IncluirAfecNC") AND #form.IncluirAfecNC# eq 1>checked</cfif> --->></td>
					  <td colspan="2">&nbsp;</td>
					  <td><cf_botones values="Generar"></td>
				  </tr>
				</table>
			</form>
			<cf_qforms>
			<script language="javascript" type="text/javascript">
				function setAction() {
					var q = document.form1.q.value;
					var retorne = '';
					if (q==1) retorne='EstadoCuentaR.cfm';
					else if (q==2) retorne='EstadoCuentaD.cfm';
					else if (q==3) retorne='EstadoCuentaDD.cfm';
					document.form1.action = retorne;
					document.form1.SNnombre1.disabled=false;
					document.form1.SNnombre2.disabled=false;
					return true;
				}
				objForm.SNnumero1.description = 'Socio Desde';
				objForm.SNnumero2.description = 'Socio Hasta';
				objForm.fecha1.description = 'Fecha1 Desde';
				objForm.fecha2.description = 'Fecha1 Hasta';
				objForm.required('SNnumero1,SNnumero2,fecha1,fecha2');

				function funcGenerar(){
					if (document.form1.SNnumero2.value < document.form1.SNnumero1.value){
						alert('El valor del Socio Hasta debe ser mayor al valor del Socio Desde');
						return false;
					}
				}
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>