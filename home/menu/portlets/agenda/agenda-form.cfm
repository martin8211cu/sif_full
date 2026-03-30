	<cfset ComponenteAgenda = CreateObject("Component", "home.Componentes.Agenda")>
	<cfset CodigoAgenda = ComponenteAgenda.MiAgenda() >
	<cfset CitasParaHoy = ComponenteAgenda.ListarCitas(CodigoAgenda, LSParseDateTime(url.fecha), true)>
	<cfset Info = ComponenteAgenda.InfoAgenda(CodigoAgenda)>

	<cf_templatecss>
	<link type="text/css" rel="stylesheet" href="agenda.css">

	<table width="100%"  border="0" cellspacing="2" cellpadding="0">
    	<tr><td ><cfoutput><div class="tituloListas"><cf_translate  key="LB_Agenda_para_el_dia">Agenda para el día</cf_translate> #url.fecha#</div></cfoutput></td></tr>
		<tr>
      		<td valign="top">
				<cfif CitasParaHoy.RecordCount>
					<table width="100%" border="0" cellpadding="2" cellspacing="0">
						<cfoutput query="CitasParaHoy">
							<cfset LvarFecha = CitasParaHoy.Inicio >
							<tr class='<cfif CitasParaHoy.currentRow mod 2>citaParma<cfelse>citaNonma</cfif>'>
								<td width="2" valign="top">&nbsp;</td>
								<td width="87" valign="top">#LSTimeFormat( Inicio, 'HH:MM' )# - #LSTimeFormat( Final, 'HH:MM' )#</td>
								<td width="3" valign="top">&nbsp;</td>
								<td width="322" valign="top" style="padding:0px;spacing:0px;" >
									<form name="form#CurrentRow#" method="post" action="" style="margin:0 ">
										<textarea class="citaNormal" onFocus="window.parent.citaFocus(this)" rows="1" cols="1"
											name="cita-#trim(CitasParaHoy.Cita)#-#Hour(LvarFecha)#:#Minute(LvarFecha)#-#CitasParaHoy.CurrentRow#"
											style="height:1.3em"
											onBlur="window.parent.citaBlur(this);<cfif isdefined("URL.AUTO")>window.parent.refrescar()</cfif>"
											onMouseMove="window.parent.citaMove(this);"
											onMouseOut="window.parent.citaOut(this);"
											onChange="window.parent.citaChange(this);" >#Texto#</textarea>
										<input type="hidden" name="fecha"	 value="#url.fecha#">
									</form>	
								</td>
								<td width="2" valign="top">&nbsp;</td>
								<td width="68" valign="top"></td>
								
								<td valign="top"></td>
							</tr>
						</cfoutput>
					</table>
				<cfelse>
					== <cf_translate  key="LB_No_hay_entradas_registradas">No hay entradas registradas</cf_translate> ==
				</cfif>
			</td>
    	</tr>
	</table>
