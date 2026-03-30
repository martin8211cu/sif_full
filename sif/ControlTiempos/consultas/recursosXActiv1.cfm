<!-- InstanceBegin template="/Templates/LMenu03.dwt.cfm" codeOutsideHTMLIsLocked="false" --><cf_template template="#session.sitio.template#">
	<script  language="JavaScript" src="/cfmx/sif/js/DHTMLMenu/stm31.js"></script>

	<cf_templatearea name="title">
		<!-- InstanceBeginEditable name="titulo" --> 
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <tr class="area"> 
          <td width="220" rowspan="2" valign="middle"><cfinclude template="/sif/ControlTiempos/portlets/pEmpresas2.cfm"></td>
          <td width="50%"> 
            <div align="center"><span class="superTitulo"><font size="5">Control de Tiempos</font></span></div></td>
        </tr>
        <tr class="area"> 
          <td width="50%" valign="bottom" nowrap> 
            <cfinclude template="/sif/ControlTiempos/jsMenuCT.cfm" ></td>
        </tr>
        <tr> 
          <td></td>
          <td></td>
        </tr>
      </table>
      <!-- InstanceEndEditable -->
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
		<br>
	
		<table width="100%" cellpadding="2" cellspacing="0">
			<tr>
				<td width="1%" valign="top">
					<!-- InstanceBeginEditable name="menu" -->
						<cfinclude template="/sif/menu.cfm">
					<!-- InstanceEndEditable -->
				</td>
			
				<td valign="top">
					<!-- InstanceBeginEditable name="mantenimiento" -->	
		<cf_web_portlet border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Recursos por Actividad">
	 
			<cfquery name="rsRecursosXActiv" datasource="#session.DSN#" >
				Select a.Usuario, 
					sum(b.CTThoras) horas
				from CTReporteTiempos a, 
					CTTiempos b
				where a.CTRcodigo = b.CTRcodigo
					and a.CTRfecha >= 	'20030109'
					and a.CTRfecha <= '20030612'
					and b.CTAcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CTAcodigo#">
					and b.CTPcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.CTPcodigo#">
				group by a.Usuario
			</cfquery>		  
			
			
			<cfdump var="#rsRecursosXActiv#">
		
		</cf_web_portlet>
	<!-- InstanceEndEditable -->
				</td>	
			</tr>
		</table>	
	</cf_templatearea>
</cf_template><!-- InstanceEnd -->