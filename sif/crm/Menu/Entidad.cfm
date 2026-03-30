<cfquery name="rsEntidades" datasource="CRM">
	select convert(varchar,CRMEid) as CRMEid, CRMEnombre + ' ' + CRMEapellido1 + ' ' + CRMEapellido2 as Nombre_Completo, convert(varchar,Usucodigo) as Usucodigo, Ulocalizacion
	from CRMEntidad
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	and <cf_dbfunction name="now"> between CRMEfechaini and CRMEfechafin
</cfquery>

<br>
	<cf_web_portlet titulo="Entidad" border="true">
		<table border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td colspan="3">&nbsp;&nbsp;&nbsp;</td>
		  </tr>
		  <tr>
			<td>&nbsp;&nbsp;&nbsp;</td>
			<td valign="center">
				<cfif (rsEntidades.Recordcount gt 0)>
				  <form name="formEntidad" method="post" action="index.cfm">
					<select name="EntidadSel" onChange="javascript: document.formEntidad.submit();">
						<option value=""> Niguno </option>
						<cfoutput query="rsEntidades">
							<option value="#CRMEid#" 
							<cfif 
								(  		(isDefined("Form.EntidadSel")) 
									and (len(trim(Form.EntidadSel)) gt 0) 
									and (Form.EntidadSel eq rsEntidades.CRMEid)
								)
								or 
								(  		(not isDefined("Form.EntidadSel")) 
									and (isDefined("Session.Usucodigo")) 
									and (len(trim(Session.Usucodigo)) gt 0) 
									and (Session.Usucodigo eq rsEntidades.Usucodigo)
								)
								>
								selected
							</cfif>
							>#Nombre_Completo#</option>
						</cfoutput>
					</select>
				  </form> 
				 <cfelse>
				 	No se encontraron Entidades.
				 </cfif>				 
			</td>
			<td>&nbsp;&nbsp;&nbsp;</td>
		  </tr>
		</table>
	</cf_web_portlet>
<br>

