<!---
	Creado por: Ana Villavicencio
	Fecha: 18-06-2006.
	Se creo para direccionarlo al reporte de Estado de cuenta.
 --->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha hasta','/sif/generales.xml')>
<cfset LB_Formato = t.Translate('LB_Formato','Formato','/sif/generales.xml')>
<cfset LB_SocioDesde = t.Translate('LB_SocioDesde','Socio Desde')>
<cfset LB_SocioHasta = t.Translate('LB_SocioHasta','Socio Hasta')>
<cfset LB_EstadoCta = t.Translate('LB_EstadoCta','Estado de Cuenta')>

<script language="JavaScript" src="../../js/fechas.js"></script>
<cfif isdefined("url.q")><cfset form.q=url.q></cfif>
<cf_templateheader title="SIF - Cuentas por Pagar">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start titulo='#LB_EstadoCta#'>
	<cfflush interval="120">
    	<cfoutput>
		<form name="form1" method="get" action="../reportes/Estado_Cuenta_ClienteCP.cfm">
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="FileLabel">#LB_Fecha_Desde#:</td>
				<td>
					<cf_sifcalendario name="fechaDes" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#" tabindex="1">
				</td>
				<td class="FileLabel">#LB_Fecha_Hasta#:</td>
				<td>
					<cf_sifcalendario name="fechaHas" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
				</td>
				<td>
					#LB_Formato#:&nbsp;
					<select name="Formato" id="Formato" tabindex="1">
						<!--- <option value="1">FLASHPAPER</option> --->
						<option value="2">PDF</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="FileLabel">#LB_SocioDesde#:</td>
				<td><cf_sifsociosnegocios2 Proveedores="SI" SNcodigo="SNcodigo1" SNnombre="SNnombre1" SNnumero="SNnumero1" frame="frSNnombre11" tabindex="1"></td>
				<td class="FileLabel">#LB_SocioHasta#:</td>
				<td><cf_sifsociosnegocios2 Proveedores="SI" SNcodigo="SNcodigo2" SNnombre="SNnombre2" SNnumero="SNnumero2" frame="frSNnombre12" tabindex="1"></td>
				<td><cf_botones values="Generar" names="Generar" tabindex="1"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
		</form>
		<cf_qforms>
		<script language="javascript" type="text/javascript">
			objForm.fechaDes.description = '#LB_Fecha_Desde#';
			objForm.fechaHas.description = '#LB_Fecha_Hasta#';
			objForm.required('fechaDes,fechaHas');

			function funcGenerar(){
				if ((new Number(document.form1.SNnumero2.value) != 0) && (new Number(document.form1.SNnumero1.value) != 0)){
					if (document.form1.SNnumero2.value < document.form1.SNnumero1.value){
						<cfset Msg_ValorSocHasta = t.Translate('Msg_ValorSocHasta','El valor del Socio Hasta debe ser mayor al valor del Socio Desde')>
						alert('#Msg_ValorSocHasta#');
						return false;
					}
				}
				else {
					<cfset Msg_DebeSumSoc = t.Translate('Msg_DebeSumSoc','Debe de suministrar ambos Socios, por favor')>
					alert('#Msg_DebeSumSoc#');
					return false;
				}
				if (datediff(document.form1.fechaDes.value, document.form1.fechaHas.value) < 0)
					{
						<cfset Msg_FecHastaMayorDesde = t.Translate('Msg_FecHastaMayorDesde','La Fecha Hasta debe ser mayor a la Fecha Desde')>
						alert ('#Msg_FecHastaMayorDesde#');
						return false;
					}
				}
		</script>
    	</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>