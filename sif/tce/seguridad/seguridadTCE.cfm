<cf_templateheader title="Usuarios Autorizados para Conciliar">
	<cf_web_portlet_start _start titulo="Usuarios que pueden procesar Conciliaci&oacute;n">

		<cf_navegacion name="Usucodigo" default="" navegacion="">

		<table width="100%" align="center" border="0">
			<tr>
				<td valign="top" align="center" width="50%">
					<cfinclude template="seguridadTCE_list.cfm">
				</td>
				<td valign="top" align="center" width="50%">
                	<table cellpadding="0" cellspacing="0" width="100%">
                    <tr>
                    	<td>
							<cfinclude template="seguridadTCE_form.cfm">                        
                        </td>
                    </tr>   
                    <tr>
                    	<td>
                        	<br />
							<cfinclude template="seguridadTCE_Detalle.cfm">                        
                        </td>
                    </tr>                                        
                    </table>

				</td>
			</tr>
		</table>
	<cf_web_portlet_start _end>
<cf_templatefooter>

