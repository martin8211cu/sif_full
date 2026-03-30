<cfset modo = "ALTA">	
	<cfif isdefined("form.CMTPAid") and len(trim(form.CMTPAid)) and isdefined("form.CMTPid") and len(trim(form.CMTPid))>            	
			<cfset modo = "CAMBIO">
			<cfif modo neq 'ALTA'>
				<cfquery name="data" datasource="#session.DSN#">
				   select CMTPid,CMTPAid,CMTPAdescripcionActividad,CMTPAduracion
					 from CMTPActividades
					where  CMTPAid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.CMTPAid)#">
					and CMTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#trim(form.CMTPid)#">
				</cfquery>
			</cfif>
	</cfif>
	<cfif isdefined('form.LvarReset')>
	   <cfset modo = "ALTA">	
	</cfif>	

	<cfif isdefined("form.CMTPid") and len(trim(form.CMTPid))>		
			<form style="margin:0;" name="form2" action="TiposActividadesProcesos-sql.cfm" method="post">
				<table align="center" width="100%" cellpadding="2" cellspacing="0" border="0" > 
						<cfif isdefined("form.CMTPAid") and len(trim(form.CMTPAid))>
								<input type="hidden" name="CMTPAid" value="<cfoutput>#form.CMTPAid#</cfoutput>"/> 
						</cfif>			
				             <input type="hidden" name="CMTPid" value="<cfoutput>#data.CMTPid#</cfoutput>"/> 
						<tr>
								<td nowrap align="right"><strong>Descripción: </strong></td>
								<td nowrap>
									<input type="text" name="CMTPDAdescripcion" size="50" maxlength="80" value="<cfif modo neq 'ALTA'><cfoutput>#data.CMTPAdescripcionActividad#</cfoutput></cfif>">
								</td>
						</tr>
						<tr>
								<td nowrap align="right"><strong>Duración estimada en días: </strong></td>
								<td nowrap>
								   <cfif modo neq 'ALTA'>
								      <cfset LvarValue= data.CMTPAduracion>
								<cfelse>
								      <cfset LvarValue= 0>
								</cfif>
								    <cf_inputNumber name="CMTPAduracion"  value="#LvarValue#" enteros="5" decimales="0" negativos="false" comas="no">
								</td>
						</tr>
						<tr>
								<td nowrap colspan="2" align="center">
									<cfinclude template="../../portlets/pBotones.cfm">
							   </td>
						</tr>
			   </table> 	
			</form>
			<cf_qforms form="form2" objForm="objForm2">
				<cf_qformsRequiredField name="CMTPAduracion" description="Duración en días" form="form2">
				<cf_qformsRequiredField name="CMTPDAdescripcion" description="Descripción" form="form2">
			</cf_qforms>
			
</cfif>