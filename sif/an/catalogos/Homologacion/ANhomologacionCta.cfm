<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Titulo" 	default="Homologaci&oacute;n de Cuentas" 
returnvariable="LB_Titulo" xmlfile="ANhomologacionCta.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_TipoH" 	default="Tipo de Homologaci&oacute;n" 
returnvariable="LB_TipoH" xmlfile="ANhomologacionCta.xml"/>
<cf_templateheader title="#LB_Titulo#">
	<cf_web_portlet_start titulo="#LB_Titulo#">
		<cfinclude template="/home/menu/pNavegacion.cfm">
		<cfif isdefined("url.ver")>
			<cfinclude template="ANhomologacionCFinancieras.cfm">
		<cfelse>
			<table width="100%" border="0" cellspacing="0" cellpadding="0">		
				<tr>
					<td>
						<cf_navegacion name="url.ANHid">
						<cf_navegacion name="ANHCid">
						<cfquery name="rsSQL" datasource="#session.dsn#">
							select 
								ANHcodigo,
								ANHdescripcion
							from
								ANhomologacion
							where Ecodigo	= #session.Ecodigo#
							  and ANHid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ANHid#">
						</cfquery>
						<cfoutput>
						<table>
							<tr>
								<td  valign="top"><strong>#LB_TipoH#:</strong>&nbsp;</td>
								<td  valign="top">#rsSQL.ANHcodigo# - #rsSQL.ANHdescripcion#</td>
							</tr>	
						</table>
						</cfoutput>
					</td>
				</tr>
				<tr>
					<cfparam name="ANHid" default="#url.ANHid#">
					<td  valign="top" width="55%"><cfinclude template="ANhomologacionCta-lista.cfm"></td>
					<td  valign="top" width="45%"><cfinclude template="ANhomologacionCta-form.cfm"></td>
				</tr>
			</table>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
