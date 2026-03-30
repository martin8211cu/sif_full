<cf_template>
<cf_templatearea name="title">Inicio</cf_templatearea>
<cf_templatearea name="body">

	<cfinclude template="../../portal_control.cfm">

	<table width="955"  border="0" cellspacing="0" cellpadding="0">
		<tr>
			<td width="162">&nbsp;</td>
			<td width="631">&nbsp;</td>
			<td width="162">&nbsp;</td>
		</tr>

		<tr>
			<!--- PORTLETS IZQUIERDA --->
			<td valign="top">
				<cf_web_portlet titulo="Horario de la Agenda" skin="portlet" width="164">
					<form action="portlets/agenda/agenda.cfm" name="calform">
						<cf_calendario form="calform" includeForm="no" name="fecha" fontSize="10" onChange="document.getElementById('pendientes').src='/cfmx/home/menu/portlets/agenda/lista_hoy-form.cfm?fecha='+escape(dmy)">
					</form>
				</cf_web_portlet>
				<br>
	
				<cf_web_portlet titulo="Pendientes para hoy" skin="portlet" width="164">
					<cfinclude template="lista-hoy.cfm">
				</cf_web_portlet>
			</td>
	
			<!--- CONTENIDO DE LA PAGINA --->
			<td valign="top"><cfinclude template="Horario-form.cfm"></td>

			<!--- PORTLETS DERECHA --->
			<td valign="top">
				<cf_web_portlet titulo="Resumen financiero"skin="portlet" width="164" >
				<table width="162"  border="0" cellspacing="0" cellpadding="2">
					<tr>
						<td width="75" class="tituloListas">&nbsp;</td>
						<td width="43" align="right" class="tituloListas">Val</td>
						<td width="44" align="right" class="tituloListas">Ant</td>
						<td width="40" align="right" class="tituloListas">Var.</td>
					</tr>
	
					<tr class="listaNon">
						<td ><div ><a href="javascript:void(0)"> Liquidez </a></div></td>
						<td align="right" ><div ><a href="javascript:void(0)">1.80</a></div></td>
						<td align="right" nowrap ><a href="javascript:void(0)">1.78</a></td>
						<td align="right" nowrap >+2.24%</td>
					</tr>
	
					<tr class="listaPar">
						<td ><div ><a href="javascript:void(0)">Q.Ratio</a></div></td>
						<td align="right" ><div ><a href="javascript:void(0)" title="Revisar acci&oacute;n RH">1.04</a></div></td>
						<td align="right" nowrap ><a href="javascript:void(0)">1.04</a></td>
						<td align="right" nowrap >-</td>
					</tr>
				
					<tr class="listaNon">
						<td><div ><a href="javascript:void(0)">Segur</a></div></td>
						<td align="right"  ><div ><a href="javascript:void(0)" title="Almuerzo con clientes">3.00</a></div></td>
						<td align="right" nowrap ><a href="javascript:void(0)">3.10</a></td>
						<td align="right" nowrap >-</td>
					</tr>
	
					<tr class="listaPar">
						<td><div  ><a href="javascript:void(0)">Rentab</a></div></td>
						<td align="right" ><div ><a href="javascript:void(0)">110%</a></div></td>
						<td align="right" nowrap ><a href="javascript:void(0)">115%</a></td>
						<td align="right" nowrap >-4.34%</td>
					</tr>
	
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
	
					<tr>
						<td colspan="4"><a href="javascript:void(0)">Personalizar...</a></td>
					</tr>
		
					<tr>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
				</table>
				</cf_web_portlet>
				<br>
	
				<cf_web_portlet titulo="Alguna otra cosa" skin="portlet" width="164" >
					<table border="0" width="162"><tr><td> Aqui va algo más</td></tr></table>
				</cf_web_portlet>
			</td>
		</tr>
	
		<tr>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
			<td>&nbsp;</td>
		</tr>
	</table>

</cf_templatearea>
</cf_template>
