<!--- 
	Modificado por Gustavo Fonseca H.
		Fecha: 6-9-2005.
		Motivo: Se valida que "El valor del Socio Hasta debe ser mayor al valor del Socio Desde" (SNnumero).
 --->

<cf_templateheader title="SIF - Cuentas por Cobrar">
           <cf_web_portlet_start titulo='Integración de Saldos'>
		  	<cfinclude template="../../portlets/pNavegacion.cfm">
			<cfif isdefined("url.q")><cfset form.q=url.q></cfif>
			<form name="form1" method="post" action="" onSubmit="javascript: return setAction();">
				<table width="98%" align="center" border="0" cellspacing="0" cellpadding="0" class="AreaFiltro">
				  <tr>
					<td class="FileLabel">Tipo:</td>
					<td colspan="4">
						<select name="q" tabindex="1">
							<option value="1" <cfif isdefined("url.q") and url.q eq 1>selected</cfif>>Resumido</option>
<!--- 
							<option value="2" <cfif isdefined("url.q") and url.q eq 2>selected</cfif>>Por Documento</option>
							<option value="3" <cfif isdefined("url.q") and url.q eq 3>selected</cfif>>Movimiento de Documento</option>
 --->						
 						</select>
					</td>
				  </tr>
				  <tr>
					<td class="FileLabel">Fecha Desde:</td>
					<td>
						<cf_sifcalendario name="fecha1" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#" tabindex="1">
					</td>
					<td class="FileLabel">Fecha Hasta:</td>
					<td>
						<cf_sifcalendario name="fecha2" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
					</td>
					<td>&nbsp;</td>
				  </tr>
				  <tr>
					<td class="FileLabel">Socio Desde:</td>
					<td><cf_sifsociosnegocios2 SNcodigo="SNcodigo1" SNnombre="SNnombre1" SNtiposocio="C" SNnumero="SNnumero1" frame="frSNnombre11" tabindex="1"></td>
					<td class="FileLabel">Socio Hasta:</td>
					<td><cf_sifsociosnegocios2 SNcodigo="SNcodigo2" SNnombre="SNnombre2" SNtiposocio="C" SNnumero="SNnumero2" frame="frSNnombre12" tabindex="1"></td>
					<td><cf_botones values="Generar" tabindex="1"></td>
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
				objForm.fecha1.description = 'Fecha1 Desde';
				objForm.fecha2.description = 'Fecha1 Hasta';
				objForm.required('fecha1,fecha2');
				
				function funcGenerar(){ 

					if ((new Number(document.form1.SNnumero2.value) != 0) && (new Number(document.form1.SNnumero1.value) != 0)){		
						if (document.form1.SNnumero2.value < document.form1.SNnumero1.value){
							alert('El valor del Socio Hasta debe ser mayor al valor del Socio Desde');
							return false;
						}
					}
					else {
						alert('Debe de suministrar ambos Socios, por favor');
						return false;
					}
				}
			</script>
		<cf_web_portlet_end>
	<cf_templatefooter>