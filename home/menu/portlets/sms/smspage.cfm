<cf_template>
<cf_templatearea name="title">Inicio</cf_templatearea>
<cf_templatearea name="body">

	<table width="955"  border="0" cellspacing="2" cellpadding="0">

		<tr>
			<td width="162" valign="top">
				<!--- AGENDA - INI --->
				<cf_web_portlet titulo="Agenda" skin="portlet" width="164">
					<form action="../agenda/agenda.cfm" name="calform">
						<cf_calendario form="calform" includeForm="no" name="fecha" fontSize="10" onChange="document.getElementById('pendientes').src='/cfmx/home/menu/portlets/agenda/lista_hoy-form.cfm?fecha='+escape(dmy)">
					</form>
				</cf_web_portlet>
				<br>
				<!--- AGENDA - FIN --->
	
				<!--- HOY - INI --->
				<cf_web_portlet titulo="Pendientes para hoy" skin="portlet" width="164">
					<cfinclude template="../agenda/lista-hoy.cfm">
				</cf_web_portlet>
				<!--- HOY - FIN --->
			</td>
			
			<td width="631" valign="top">
			 
				<!--- SMS - INI --->
				<cf_web_portlet titulo="SMS" skin="portlet" width="164" >
					<table border="0" width="162">
						<tr><td><cfinclude template="sms.cfm"></td></tr>
					</table>
				</cf_web_portlet> 
			
			</td>
	
			<td width="162" valign="top">
	
			<br>
				<cf_web_portlet titulo="Autogestión" skin="portlet" width="164" >
					<table border="0" width="162" cellpadding="0" cellspacing="0">
						<tr><td width="91"><a href="../../../../plantillas/autogestion/index.cfm"><img src="../chica.jpg" alt="Autogesti&oacute;n" width="91" height="130" border="0"></a></td>
						<td width="71" valign="top">
						Le permite organizar y controlar sus propios beneficios desde su puesto de trabajo.
						</td>
						</tr>
					</table>
				</cf_web_portlet>
				<!--- SMS - FIN --->
			</td>
		</tr>
		
		<tr><td colspan="3">&nbsp;</td></tr>
	</table>

</cf_templatearea>
</cf_template>