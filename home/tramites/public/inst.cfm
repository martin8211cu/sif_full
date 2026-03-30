<cfif isdefined("session.tramites.id_inst") and len(session.tramites.id_inst) and isNumeric(session.tramites.id_inst)>
	<cfquery name="rsInstitucion" datasource="#session.tramites.dsn#">
		select nombre_inst, logo_inst, ts_rversion
		from TPInstitucion
		where id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.tramites.id_inst#">
	</cfquery>
	<cfif rsInstitucion.recordcount>
		<cfoutput>
			<table border="0" width="100%" style="background-color:##cccccc;border:1px solid ##999999; padding:4px; border-bottom: 2px solid ##333333; border-right: 2px solid ##333333">
			  <tr>
				<td valign="middle">&nbsp;
					<cfif Len(rsInstitucion.logo_inst) gt 1>
						<cfinvoke 
						 component="sif.Componentes.DButils"
						 method="toTimeStamp"
						 returnvariable="tsurl">
							<cfinvokeargument name="arTimeStamp" value="#rsInstitucion.ts_rversion#"/>
						</cfinvoke>
						<img src="/cfmx/home/tramites/public/logo_inst.cfm?id_inst=#session.tramites.id_inst#&amp;ts=#tsurl#" border="0" width="146" height="59">
					</cfif>
				</td>
				<td style="font-size: 22px;" nowrap valign="middle">
					<strong>#rsInstitucion.nombre_inst#</strong>
				</td>
			  </tr>
			</table>
		</cfoutput>
	</cfif>
</cfif>