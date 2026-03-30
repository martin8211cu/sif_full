<cf_templateheader title="Aprobación de la Formulación Presupuestaria">
	  <cf_web_portlet_start titulo="Generando el reporte de incobrables." style="cursor:wait">
			<cfinclude template="/sif/portlets/pNavegacion.cfm">
			<br>
			<cf_web_portlet_start width="60%" titulo="Reporte en proceso, favor esperar...">
			<cfoutput>
				<table border="0" align="center">
					<tr>
						<td >
							<strong>Fecha y hora:</strong>
						</td>
						<td align="center">
							<strong>ESTADO:</strong>
						</td>
					</tr>
					<tr>
						<td colspan="2" align="center">
							<input type="text" disabled id="hora" style="width:200px;border:none; background-color:##FFFFFF; text-align:center">
						</td>
                        <td>Procesando...</td>
					</tr>
				</table>
			</cfoutput>
			<cf_web_portlet_end>
			<BR>
            <iframe name="ifrRefrescar" style="cursor:wait" frameborder="0" src="QPassRIncobrables_Refresh.cfm" width="0" height="0">
			</iframe>
			<div align="center">
				<input type="button" value="Refrescar" onClick="document.ifrRefrescar.location.reload();">
			</div>
			<BR>
			
        
		<cflock scope="session" type="exclusive" timeout="5" throwontimeout="yes">
			<cfif session.Reporte.QPIncobrable EQ 0>
				<!--- <cfoutput>#session.Reporte.QPIncobrable#</cfoutput>&nbsp; --->
				<cfset session.Reporte.QPIncobrable = 1>
                <!--- <cfoutput>#session.Reporte.QPIncobrable#</cfoutput> --->
				<cfoutput>
					<iframe name="ifrSQL" style="cursor:wait" frameborder="1" width="0" height="0" src="QPassRIncobrables_form.cfm?fechadesde=#form.fechadesde#&fechahasta=#form.fechahasta#&Generar=1"></iframe>
				</cfoutput>
			</cfif>
		</cflock>
	  <cf_web_portlet_end>
<cf_templatefooter>
