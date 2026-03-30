<!--- 
	Creado por: Ana Villavicencio
	Fecha: 26 de enero del 2006
	Motivo: Nuevo reporte de histórico de una plaza presupuestaria. 
 --->
<form name="form1" method="get" action="HistoricoPlazaP.cfm">
<table width="100%" border="0" cellpadding="2" cellspacing="2" class="areaFiltro" align="center">
	<tr><td colspan="4">&nbsp;</td></tr>
 	<tr>
		<td width="37%" align="right"><strong><cf_translate  key="LB_PlazaDesde">Plaza desde</cf_translate>:&nbsp;</strong></td>
		<td colspan="3"><cf_rhplazapresupuestaria id="RHPPidD" codigo="RHPPcodigoD" descripcion="RHPPdescripcionD"></td>
	</tr>
 	<tr>
		<td align="right"><strong><cf_translate  key="LB_PlazaHasta">Plaza hasta</cf_translate>:&nbsp;</strong></td>
		<td colspan="3"><cf_rhplazapresupuestaria id="RHPPidH" codigo="RHPPcodigoH" descripcion="RHPPdescripcion"></td>
	</tr>
 	<tr>
		<td align="right"><strong><cf_translate  key="LB_FechaDesde">Fecha desde</cf_translate>:&nbsp;</strong></td>
		<td><cf_sifcalendario name="FechaD"></td>
		<td width="5%" align="center"><strong><cf_translate  key="LB_Hasta">Hasta</cf_translate>:&nbsp;</strong></td>
		<td width="42%"><cf_sifcalendario name="FechaH"></td>
	</tr>
	<tr>
		<td align="right"><strong><cf_translate  key="LB_Formato">Formato</cf_translate>:&nbsp;</strong></td>
		<td colspan="3">
			<select name="formato">
				<option value="flashpaper"><cf_translate  key="CMB_Formato">Flashpaper</cf_translate></option>
				<option value="pdf"><cf_translate  key="CMB_PDF">PDF</cf_translate></option>
				<option value="excel"><cf_translate  key="CMB_Excel">Excel</cf_translate></option>
			</select>
		</td>
	</tr>
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
	
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Consultar"
	Default="Consultar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Consultar"/>
	
	<tr><td nowrap align="center" colspan="10"><cf_botones exclude="Alta,Baja,Cambio,Limpiar" include="#BTN_Consultar#,#BTN_Limpiar#"></td></tr>
</table>
</form>
<cf_qforms>
 <script language="JavaScript" type="text/javascript">
	// Valida el rango entre la fecha de desde y la fecha de hasta del filtro
	
    <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_LaFechaHastaNoPuedeSerMenorQueLaFechaDesde"
	Default="La fecha hasta no puede ser menor que la fecha desde"
	returnvariable="MSG_LaFechaHastaNoPuedeSerMenorQueLaFechaDesde"/>	
	
	function __isRangoFechas() {
		if (this.required) {
			var a = this.obj.form.FechaD.value.split("/");
			var ini = new Date(parseInt(a[2], 10), parseInt(a[1], 10)-1, parseInt(a[0], 10));
			var b = this.obj.form.FechaH.value.split("/");
			var fin = new Date(parseInt(b[2], 10), parseInt(b[1], 10)-1, parseInt(b[0], 10));
			var dif = ((fin-ini)/86400000.0)+1;	// diferencia en días
			if (new Number(dif) < 0) {
				this.error = "<cfoutput>#MSG_LaFechaHastaNoPuedeSerMenorQueLaFechaDesde#</cfoutput>";
			}
		}
	}
	
	_addValidator("isRangoFechas", __isRangoFechas);

   <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaDesde"
	Default="Fecha desde"
	returnvariable="MSG_FechaDesde"/>	

   <cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_FechaHasta"
	Default="Fecha hasta"
	returnvariable="MSG_FechaHasta"/>		
	
	objForm.FechaD.required = true;
	objForm.FechaD.description = "<cfoutput>#MSG_FechaDesde#</cfoutput>";
	objForm.FechaH.required = true;
	objForm.FechaH.description = "<cfoutput>#MSG_FechaHasta#</cfoutput>";
	objForm.FechaH.validateRangoFechas();
	
</script>  