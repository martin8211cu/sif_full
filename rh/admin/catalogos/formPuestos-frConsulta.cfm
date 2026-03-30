<!--- <cfdump var="#form#"> --->
	
<cfoutput>
<link href="/cfmx/home/menu/menu.css" rel="stylesheet" type="text/css">
<form name="form1">
	<table border="0" cellpadding="2" cellspacing="0">
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr>
			<td width="10%">&nbsp;</td>
			<td colspan="2"  class="menuhead plantillaMenuhead" ><cf_translate key="LB_Consultas">Consultas</cf_translate></td>
		</tr>
		<tr><td colspan="3">&nbsp;</td></tr>
		<tr>	
			<td width="10%">&nbsp;</td>
			<td nowrap align="right">
  			   <a  href="javascript: informacion('<cfoutput>#trim(form.RHPcodigo)#</cfoutput>');" ><img border="0" width="16" height="16" src="/cfmx/rh/imagenes/16x16_flecha_right.gif" ></a>
			</td>
			<td width="81%" nowrap>
   			    <a  class="menutitulo plantillaMenutitulo" href="javascript: informacion('<cfoutput>#trim(form.RHPcodigo)#</cfoutput>');" ><cf_translate key="LB_RequerimientosdePuestos">Requerimientos de Puestos</cf_translate></a>
			</td>
		</tr>
		<tr>	
			<td width="10%">&nbsp;</td>
			<td  align="right"nowrap>
				    <a  href="javascript: informacion2('<cfoutput>#trim(form.RHPcodigo)#</cfoutput>');" ><img border="0" width="16" height="16" src="/cfmx/rh/imagenes/16x16_flecha_right.gif" ></a>
			</td>
			<td width="81%" nowrap>
				<a  class="menutitulo plantillaMenutitulo" href="javascript: informacion2('<cfoutput>#trim(form.RHPcodigo)#</cfoutput>');" ><cf_translate key="LB_ProgresodelPlan">Progreso del Plan</cf_translate></a>
			</td>
		</tr>
		<tr><td colspan="3">&nbsp;</td></tr>
	</table>
</form>
</cfoutput>
<script language="javascript" type="text/javascript">
	function informacion(llave){
		var PARAM  = "/cfmx/rh/sucesion/consultas/PlanSucesion-ConsultaPlanIMP.cfm?RHPcodigo="+ llave
		open(PARAM,'','left=100,top=100,scrollbars=yes,resizable=yes,width=800,height=500')
	}
		function informacion2(llave){
		var PARAM  = "/cfmx/rh/sucesion/operacion/PlanSucesion-paso3.cfm?sel=1&RHPcodigo="+ llave
		open(PARAM,'','left=100,top=100,scrollbars=yes,resizable=yes,width=800,height=500')
	}
</script>