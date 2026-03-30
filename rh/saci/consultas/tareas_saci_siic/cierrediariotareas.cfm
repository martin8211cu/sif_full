<cf_templateheader title="Cierre Diario de Tareas">
	<cf_web_portlet_start titulo="Cierre Diario de Tareas">
	
		<script language="javascript" type="text/javascript">
			function consultando(){
				document.form1.action = "cierrediariotareas.cfm";
				document.form1.consulta.value = 1;
				if(validaFiltros(document.form1))
					document.form1.submit();
			}
			function exportar(){
				document.form1.action = "exportarMsjVend-sql.cfm";
				document.form1.consulta.value = 2;
				if(validaFiltros(document.form1))
					document.form1.submit();
			}			
			function validaFiltros(f){
				if(f.fechaIni.value != '' && f.fechaFin.value != ''){
					if(!rangoFechas(f.fechaIni.value,f.fechaFin.value)){
						return false;
					}
				}
				
				return true;
			}
		</script>

		<cfoutput>
			<script language="javascript" type="text/javascript" src="../../../sif/js/utilesMonto.js">//</script>
			<form method="get" name="form1" action="cierrediariotareas-sql.cfm" onSubmit="javascript: return validaFiltros(this);">
				<input type="hidden" name="consulta" value="0">
				
				<table width="94%" border="0" cellspacing="0" cellpadding="0" align="center">
					<tr>
						<td valign="top">
							<table width="100%"  border="0" cellspacing="2" cellpadding="0">
								<td align="right"><strong>Fecha Inicial:</strong></td>
								<td>
									<cfif isdefined("url.fechaIni") and len(trim(url.fechaIni))>								
										<cfset vfechaIni = LSDateFormat(url.fechaIni,'dd/mm/yyyy')>
									<cfelse>
										<cfset vfechaIni = ''>
									</cfif>									
									<cf_sifcalendario  tabindex="1" form="form1" name="fechaIni" value="#vfechaIni#">								
								</td>
							  	<td align="right"><strong>Tipo Tarea:</strong></td>
								<td><select name="TipoTarea">
                                  <option value="Q" <cfif isdefined('url.TipoTarea') and url.TipoTarea EQ 'Q'> selected</cfif>>Cambio de Paquete</option>
                                  <option value="B" <cfif isdefined('url.TipoTarea') and url.TipoTarea EQ 'B'> selected</cfif>>Retiro de Usuarios</option>
                                </select></td>
							  </tr>				
							  <tr>
								<td width="20%" align="right"><strong>Fecha Final:</strong></td>
								<td>
									<cfif isdefined("url.fechaFin") and len(trim(url.fechaFin))>								
										<cfset vfechaFin = LSDateFormat(url.fechaFin,'dd/mm/yyyy')>
									<cfelse>
										<cfset vfechaFin = ''>
									</cfif>									
									<cf_sifcalendario  tabindex="1" form="form1" name="fechaFin" value="#vfechaFin#">									
								</td>
						      	<td align="right"><strong>Estado:</strong></td>
								<td><select name="EstadoTarea">
                                  <option value="H" <cfif isdefined('url.EstadoTarea') and url.EstadoTarea EQ 'H'> selected</cfif>>Tareas Cumplidas</option>
								  <option value="P" <cfif isdefined('url.EstadoTarea') and url.EstadoTarea EQ 'P'> selected</cfif>>Tareas Pendientes</option>               
                                </select></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							  </tr>
							  <!---<tr>
								<td align="right"><strong>Formato:</strong></td>
								<td><select name="formato">
                                  <option value="1">Flash Paper</option>
                                  <option value="2">Adobe PDF</option>
                                  <option value="3">Microsoft Excel</option>
                                </select></td>
								<td>&nbsp;</td>
								<td>&nbsp;</td>
							  </tr>--->
							  <tr>
								<td></td>
							  </tr>
							  <tr>
								<td colspan="4" align="center">
									<input type="button" onClick="javascript: consultando();" value="Consultar" name="Consultar">
									<!---<input type="submit" value="Reporte" name="Reporte">--->				
									<!---<input type="button" onClick="javascript: exportar();" value="Exportar" name="Exportar">--->
								</td>
							  </tr>
							</table>
					  </td>
					</tr>
				</table>
			</form>
		</cfoutput>
		<cfif isdefined('url.consulta') and url.consulta EQ '1'>
			<hr>
			<cfinclude template="cierrediariotareas-lista.cfm">
		</cfif>			
	<cf_web_portlet_end> 
<cf_templatefooter>
