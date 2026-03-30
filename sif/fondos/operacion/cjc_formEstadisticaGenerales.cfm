<cfinclude template="encabezadofondos.cfm">
<link href="/cfmx/sif/fondos/css/estilos.css" rel="stylesheet" type="text/css">


<table width="100%" border="0" >	
<tr>
	<td  align="center" colspan="2" >

			<form name="form1" action="cjc_formEstadisticaGenerales.cfm" method="post">
			<table width="100%" border="0" cellpadding="2" cellspacing="0">
				<tr>
					<td align="left" colspan="10">
					
					
						<table border='0' cellspacing='0' cellpadding='0' width='100%'>
						<tr>
							<td class="barraboton">&nbsp;
								<a id ="ACEPTAR" href="javascript:document.form1.submit();" onmouseover="overlib('Generar reporte',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Consultar'; return true;" onmouseout="nd();"></span><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Consultar&nbsp;</span></a>
								<a id ="LIMPIAR" href="javascript:document.location = '../operacion/cjc_EstadisticaGenerales.cfm';window.parent.frm_reporte.location = '../operacion/cjc_sqlRLiquidacionesDetalladas.cfm'" onmouseover="overlib('Limpiar filtros',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Limpiar'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Limpiar&nbsp;</span></a>
								<a id ="Printit" href="javascript:Printit();" onmouseover="overlib('Imprimir',WIDTH,100,RIGHT,ABOVE, SNAPX, 10, SNAPY, 10,FGCOLOR, '#FFFFFF', BGCOLOR, '#333333'); window.status='Imprimir'; return true;" onmouseout="nd();"><span class="LeftNavOff" buttonType=LeftNav>&nbsp;Imprimir&nbsp;</span></a>
							</td>
							<td class=barraboton>
								<p align=center><font color='#FFFFFF'><b> </b></font></p>
							</td>
						</tr>
						</table>					
						<input type="hidden" id="btnFiltrar" name="btnFiltrar">
						
					</td>
				</tr>									
				<tr>					
					<td align="left">Fecha Inicial</td>
					<td > 
						<cfif isdefined("INI_FECHAINI")>
							<cfset F_INICIAL = #INI_FECHAINI#>
						<cfelse>
							<cfset F_INICIAL = "">
						</cfif>
						<cf_CJCcalendario  tabindex="1" name="INI_FECHAINI" form="form1"  value="#F_INICIAL#">
					</td>											
				</tr>	
				<tr>
					<td width="16%" align="left">Fecha Final</td>
					<td width="84%"> 
						<cfif isdefined("FIN_FECHAFIN")>
							<cfset F_FINAL = #FIN_FECHAFIN#>
						<cfelse>
							<cfset F_FINAL = "">
						</cfif>
						<cf_CJCcalendario  tabindex="1" name="FIN_FECHAFIN" form="form1"  value="#F_FINAL#">
					</td>											
				</tr>				
				<tr>
					<td width="16%" align="left">Reportes</td>
					<td width="84%"> 
						<select name="treporteesp">
						<option value="1">Indicadores Generales</option>
						<option value="2">Cantidad de Documentos por caja y por digitador</option>
						<option value="3">Cantidad de Documentos (antes 7am y despues 5pm) por caja y por digitador</option>
						<option value="4">Documentos Pendientes de aplicar por caja y por digitador</option>
						<option value="5">Documentos de digitador por día,fondo,hora y horas que dedico a un registro</option>												
						</select>
					</td>																
				</tr>						
			</table>			
			</form>
	</td>		
</tr>		
</table>


<!---********************** --->
<!---** AREA DE SCRIPTS  ** --->
<!---********************** --->
<cfif isdefined("btnFiltrar")>
	
	<script>		
		var param="";
		<cfif isdefined("INI_FECHAINI") and len(INI_FECHAINI)>			
			param = param + "&INI_FECHAINI='<cfoutput>#INI_FECHAINI#</cfoutput>'"			
		</cfif>
		<cfif isdefined("FIN_FECHAFIN") and len(FIN_FECHAFIN)>			
			param = param + "&FIN_FECHAFIN='<cfoutput>#FIN_FECHAFIN#</cfoutput>'"
		</cfif>
		window.parent.frm_reporte.location = "../operacion/cjc_sqlEstadisticaGenerales.cfm?btnFiltrar=1" + param;
		
	</script>

</cfif>


<script language="JavaScript1.2" type="text/javascript">
function Printit() {
	window.parent.frm_reporte.focus();
	window.parent.frm_reporte.print();
}
</script> 