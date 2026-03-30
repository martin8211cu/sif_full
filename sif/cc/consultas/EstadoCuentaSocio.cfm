<!--- 
	Creado por: Ana Villavicencio
	Fecha: 14-06-2006.
	Se creo para direccionarlo al reporte de Estado de cuenta.	
--->
<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
<cfset LB_TituloH = t.Translate('LB_TituloH','SIF - Cuentas por Cobrar')>
<cfset TIT_EdoCue = t.Translate('TIT_EdoCue','Estado de Cuenta')>
<cfset LB_Fecha_Desde = t.Translate('LB_Fecha_Desde','Fecha Desde','/sif/generales.xml')>
<cfset LB_Fecha_Hasta = t.Translate('LB_Fecha_Hasta','Fecha Hasta','/sif/generales.xml')>
<cfset LB_Formato 	= t.Translate('LB_Formato','Formato:','/sif/generales.xml')>
<cfset LB_Socio_Desde = t.Translate('LB_Socio_Desde','Socio Desde')>
<cfset LB_Socio_Hasta = t.Translate('LB_Socio_Hasta','Socio Hasta')>
<cfset MSG_AmbosSocio = t.Translate('MSG_AmbosSocio','Debe de suministrar ambos Socios, por favor')>
<cfset MSG_FechasLim = t.Translate('MSG_FechasLim','La Fecha Hasta debe ser mayor a la Fecha Desde')>
<cfset MSG_SociosLim = t.Translate('MSG_SociosLim','El valor del Socio Hasta debe ser mayor al valor del Socio Desde')>


<script language="JavaScript" src="../../js/fechas.js"></script>
<cfif isdefined("url.q")><cfset form.q=url.q></cfif>
<cf_templateheader title="#LB_TituloH#">
	<cfinclude template="../../portlets/pNavegacion.cfm">
	<cf_web_portlet_start titulo='#TIT_EdoCue#'>
	<form name="form1" method="get" action="../reportes/Estado_Cuenta_Cliente.cfm">
		<cfoutput>
		<table width="100%" align="center" border="0" cellspacing="0" cellpadding="0" class="tituloListas">
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td class="FileLabel">#LB_Fecha_Desde#:</td>
				<td>
					<cf_sifcalendario name="fechaIni" value="#LSDateFormat(CreateDate(Year(Now()),Month(Now()),01),'dd/mm/yyyy')#" tabindex="1">
				</td>
				<td class="FileLabel">#LB_Fecha_Hasta#:</td>
				<td>
					<cf_sifcalendario name="fechaFin" value="#LSDateFormat(Now(),'dd/mm/yyyy')#" tabindex="1">
				</td>
				<td>
					#LB_Formato#&nbsp;
					<select name="Formato" id="Formato" tabindex="1">
						<option value="1">FLASHPAPER</option>
						<option value="2">PDF</option>
					</select>
				</td>
			</tr>
			<tr>
				<td class="FileLabel">#LB_Socio_Desde#:</td>
				<td><cf_sifsociosnegocios2 SNcodigo="SNcodigo1" SNtiposocio="C" SNnombre="SNnombre1" SNnumero="SNnumero1" frame="frSNnombre11" tabindex="1"></td>
				<td class="FileLabel">#LB_Socio_Hasta#:</td>
				<td><cf_sifsociosnegocios2 SNcodigo="SNcodigo2" SNtiposocio="C" SNnombre="SNnombre2" SNnumero="SNnumero2" frame="frSNnombre12" tabindex="1"></td>
				<td><cf_botones values="Generar" names="Generar" tabindex="1"></td>
			</tr>
			<tr><td>&nbsp;</td></tr>
		</table>
        </cfoutput>
	</form>
	<cf_qforms>
    <cfoutput>
	<script language="javascript" type="text/javascript">
		objForm.fechaIni.description = '#LB_Fecha_Desde#';
		objForm.fechaFin.description = '#LB_Fecha_Hasta#';
		objForm.required('fechaIni,fechaFin');
		
		function funcGenerar(){ 
			if ((new Number(document.form1.SNnumero2.value) != 0) && (new Number(document.form1.SNnumero1.value) != 0)){		
				if (document.form1.SNnumero2.value < document.form1.SNnumero1.value){
					alert('#MSG_SociosLim#');
					return false;
				}
			}
			else {
				alert('#MSG_AmbosSocio#');
				return false;
			}
			if (datediff(document.form1.fechaIni.value, document.form1.fechaFin.value) < 0) 
				{	
						alert ('#MSG_FechasLim#');
						return false;
				} 
		}
	</script>
    </cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>