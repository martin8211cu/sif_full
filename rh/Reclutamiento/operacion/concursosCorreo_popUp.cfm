<!--- Se incluye una lista de concursantes internos y externos --->
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_interno"
Default="Int."
returnvariable="LB_interno">
	
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Externo"
Default="Ext."
returnvariable="LB_Externo">

<cfset t=createobject("component","sif.Componentes.Translate")>
<cf_translatedata tabla="RHConcursos" col="RHCdescripcion" name="get" returnvariable="LvarRHCdescripcion">

<cfif isdefined ('form.RHCconcurso') and not isdefined('url.RHCconcurso')>
	<cfset url.RHCconcurso=form.RHCconcurso>
</cfif>
<cfquery name="rsConc" datasource="#session.dsn#">
	select RHCconcurso,RHCcodigo,#LvarRHCdescripcion# as RHCdescripcion from RHConcursos where RHCconcurso=#url.RHCconcurso#
</cfquery>
<cfquery name="rsLista" datasource="#session.DSN#">							
	select a.RHCPid, b.DEidentificacion as identificacion,case a.RHCPtipo when 'I' then '#LB_interno#' else '#LB_Externo#' end as tipo,
			{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(', ',b.DEnombre)})})})} as Nombre,
		   a.DEid, a.RHOid, a.RHCdescalifica, a.RHCrazondeacalifica, a.RHCPtipo, a.RHCPpromedio, a.RHCevaluado,a.RHCdescalifica 
	from RHConcursantes a, DatosEmpleado b
	where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCconcurso#">
	and b.DEid = a.DEid
	and b.Ecodigo = a.Ecodigo
	<cfif isdefined ('form.radio') and form.radio eq 'D'>
	and a.RHCdescalifica=1
	</cfif>
	<cfif isdefined ('form.radio') and form.radio eq 'C'>
	and a.RHCdescalifica=0
	</cfif>
	union
	select a.RHCPid, b.RHOidentificacion as identificacion, case a.RHCPtipo when 'I' then '#LB_interno#' else '#LB_Externo#' end as tipo,
			{fn concat(b.RHOapellido1,{fn concat(' ',{fn concat(b.RHOapellido2,{fn concat(', ',b.RHOnombre)})})})} as Nombre,
		   a.DEid, a.RHOid, a.RHCdescalifica, a.RHCrazondeacalifica, a.RHCPtipo, a.RHCPpromedio, a.RHCevaluado,a.RHCdescalifica 
	from RHConcursantes a, DatosOferentes b
	where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCconcurso#">
	and b.RHOid = a.RHOid
	and b.Ecodigo = a.Ecodigo
	<cfif isdefined ('form.radio') and form.radio eq 'D'>
	and a.RHCdescalifica=1
	</cfif>
	<cfif isdefined ('form.radio') and form.radio eq 'C'>
	and a.RHCdescalifica=0
	</cfif>
	order by 2, 3
</cfquery>

<cf_templatecss>


<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Key="LB_InformacionDelConcurso" Default="Información del Concurso" returnvariable="LB_InformacionDelConcurso">
<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Key="LB_Estimada" Default="Estimada" returnvariable="LB_Estimada">
<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Key="LB_AdministradorDelPortal" Default="Administrador del Portal" returnvariable="LB_AdministradorDelPortal">
<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Key="LB_Estimado" Default="Estimado(a)" returnvariable="LB_Estimado">
<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Key="LB_Calificado" Default="Calificado" returnvariable="LB_Calificado">
<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Key="LB_Descalificado" Default="Descalificado" returnvariable="LB_Descalificado">
    
    
<form name="formC" action="concursosCorreo_popUp.cfm" method="post">
<cfoutput>
<cfif isdefined ('url.RHCconcurso')>
<input type="hidden" name="RHCconcurso" value="#url.RHCconcurso#" />
</cfif>
	<table width="100%">
		<tr class="listaPar">
			<td align="center">
				<strong><cf_translate key="MSG_SeleccioneGrupoDeseaEnviarCorreo">Seleccione al grupo que desea enviar el correo</cf_translate></strong>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="radio" name="radio" value="T" /><cf_translate key="LB_Todos" xmlFile="/rh/generales.xml">Todos</cf_translate>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="radio" name="radio" value="D" /><cf_translate key="LB_Descalificados">Descalificados</cf_translate>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="radio" name="radio" value="C" /><cf_translate key="LB_Calificados">Calificados</cf_translate>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">
				<input type="submit" name="Enviar" value="<cf_translate key="LB_EnviarCorreos" xmlFile="/rh/generales.xml">Enviar Correos</cf_translate> " />
			</td>
		</tr>
	</table>


<cfinvoke component="sif.Componentes.Translate" method="Translate" 
	Key="MSG_PorFavorNoRespondaEsteCorreo" Default="Por favor no responda este correo ya que se envío de manera automática, si desea información al respecto comuniquese con el encargado de Reclutamiento y Selección" returnvariable="MSG_PorFavorNoRespondaEsteCorreo">

<cfif isdefined('form.Enviar')>
	<cfif isdefined ('form.radio') and len(trim(form.radio)) gt 0>
			<cfloop query="rsLista">
				<cfif len(trim(rsLista.DEid)) gt 0>
					<cfquery name="correo" datasource="#session.dsn#">
						select DEemail from DatosEmpleado where DEid=#rsLista.DEid#
					</cfquery>
					
					<cfif len(trim(correo.DEemail)) gt 0>
						<cfset email_subject = "#LB_InformacionDelConcurso#:#rsConc.RHCconcurso#-#rsConc.RHCdescripcion#">
						<cfset email_from = "#LB_AdministradorDelPortal#">
						<cfset email_to = '#correo.DEemail#'>
						<cfset email_cc = ''>
						
						<cfsavecontent variable="email_body">
						<html>
						<head></head>
						<body>
							<!---Cuerpo del correo--->
								<cfquery name="rsDE" datasource="#session.dsn#">
									select b.DEidentificacion as identificacion,case a.RHCPtipo when 'I' then '#LB_interno#' else '#LB_Externo#' end as tipo,
										{fn concat(b.DEapellido1,{fn concat(' ',{fn concat(b.DEapellido2,{fn concat(', ',b.DEnombre)})})})} as Nombre,
										   a.DEid, a.RHOid, a.RHCdescalifica, a.RHCrazondeacalifica, a.RHCPtipo, a.RHCPpromedio, a.RHCevaluado,a.RHCdescalifica,case a.RHCdescalifica when 0 then '#LB_Calificado#' else '#LB_Descalificado#' end as estado,
										   '#LB_Estimado#' as etiqueta
									from RHConcursantes a
                                    	inner join DatosEmpleado b
                                        	on b.DEid = a.DEid
                                            and b.Ecodigo = a.Ecodigo
									where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCconcurso#">
									and b.DEid=#rsLista.DEid#									
									<cfif form.radio eq 'D'>
										and a.RHCdescalifica=1
									</cfif>
									<cfif form.radio eq 'C'>
										and a.RHCdescalifica=0
									</cfif>
								</cfquery>
								<table>
								<cfoutput>
									<tr bgcolor="CCCCCC">
										<td bgcolor="CCCCCC" align="center"><strong>#LB_InformacionDelConcurso#</strong></td>
									</tr>
									<tr>
										<td><strong>#rsDE.etiqueta#: </strong>#rsDE.Nombre#</td></br>
									</tr>
									<tr>
										<td>
											<cfif rsDE.RHCdescalifica  eq 0>
											#t.translate('MSG_Anuncio_uno','Se le informa que se realizo de manera satisfactoria su inscripción al concurso')#:<strong> #rsConc.RHCconcurso#-#rsConc.RHCdescripcion#</strong> </br>
											#MSG_PorFavorNoRespondaEsteCorreo#
											<cfelse>
											#t.translate('MSG_Anuncio_dos','Se le informa que su aplicación al concurso')#:<strong> #rsConc.RHCconcurso#-#rsConc.RHCdescripcion#</strong> #t.translate('MSG_quedaDescalificada','queda descalificada')# </br>
											#t.translate('MSG_Anuncio_tres','Dicha descalificación se dio por motivo')#:#rsDE.RHCrazondeacalifica#</br>
											#t.translate('MSG_Anuncio_cuatro','Este mensaje es generado automáticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje')#. </br>
											#t.translate('MSG_Anuncio_cinco','Si desea información al respecto comuniquese con el encargado de Reclutamiento y Selección')#
											</cfif>
										</td>
									</tr>
								</cfoutput>
								</table>
							<!------>
						</body>
						</html>
						</cfsavecontent>
						
						<cfquery datasource="minisif">
						insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
						</cfquery>
					</cfif>
				</cfif>
				<cfif len(trim(rsLista.identificacion)) gt 0 and len(trim(rsLista.DEid)) eq 0>

					<cfquery name="correo" datasource="#session.dsn#">
						select RHOemail from DatosOferentes where RHOidentificacion='#rsLista.identificacion#'
					</cfquery>
					
					<cfif len(trim(correo.RHOemail)) gt 0>
						<cfset email_subject = "#LB_InformacionDelConcurso#:#rsConc.RHCconcurso#-#rsConc.RHCdescripcion#">
						<cfset email_from = "#LB_AdministradorDelPortal#">
						<cfset email_to = '#correo.RHOemail#'>
						<cfset email_cc = ''>
						
						<cfsavecontent variable="email_body">
						<html>
						<head></head>
						<body>
							<!---Cuerpo del correo--->
								<cfquery name="rsOF" datasource="#session.dsn#">
									select a.RHCPid, b.RHOidentificacion as identificacion, case a.RHCPtipo when 'I' then '#LB_interno#' else '#LB_Externo#' end as tipo,
										{fn concat(b.RHOapellido1,{fn concat(' ',{fn concat(b.RHOapellido2,{fn concat(', ',b.RHOnombre)})})})} as Nombre,
									   a.DEid, a.RHOid, a.RHCdescalifica, a.RHCrazondeacalifica, a.RHCPtipo, a.RHCPpromedio, a.RHCevaluado,case a.RHCdescalifica when 0 then '#LB_Calificado#' else '#LB_Descalificado#' end as estado,
									    '#LB_Estimado#' as etiqueta
									from RHConcursantes a, DatosOferentes b
									where a.RHCconcurso = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHCconcurso#">
									and b.RHOid = a.RHOid
									and b.RHOidentificacion='#rsLista.identificacion#'
									and b.Ecodigo = a.Ecodigo
									<cfif form.radio eq 'D'>
										and a.RHCdescalifica=1
									</cfif>
									<cfif form.radio eq 'C'>
										and a.RHCdescalifica=0
									</cfif>
								</cfquery>
								
								<table>
								<cfoutput>
									<tr bgcolor="CCCCCC">
										<td bgcolor="CCCCCC" align="center"><strong>#LB_InformacionDelConcurso#</strong></td>
									</tr>
									<tr>
										<td><strong>#rsOF.etiqueta#: </strong>#rsOF.Nombre#</td></br>
									</tr>
									<tr>
										<td>
											<cfif rsOF.RHCdescalifica eq 0>
											#t.translate('MSG_Anuncio_uno','Se le informa que se realizo de manera satisfactoria su inscripción al concurso')#:<strong> #rsConc.RHCconcurso#-#rsConc.RHCdescripcion#</strong> </br>
											#MSG_PorFavorNoRespondaEsteCorreo#
											<cfelse>
											#t.translate('MSG_Anuncio_dos','Se le informa que su aplicación al concurso')#:<strong> #rsConc.RHCconcurso#-#rsConc.RHCdescripcion#</strong> #t.translate('MSG_quedaDescalificada','queda descalificada')# </br>
											#t.translate('MSG_Anuncio_tres','Dicha descalificación se dio por motivo')#:#rsDE.RHCrazondeacalifica#</br>
											#t.translate('MSG_Anuncio_cuatro','Este mensaje es generado automáticamente por el sistema de Recursos Humanos. Por favor no responda a este mensaje')#. </br>
											#t.translate('MSG_Anuncio_cinco','Si desea información al respecto comuniquese con el encargado de Reclutamiento y Selección')#
											</cfif>
										</td>
									</tr>
								</cfoutput>
								</table>
							<!------>
						</body>
						</html>
						</cfsavecontent>
						
						<cfquery datasource="minisif">
						insert into SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
						values (
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_from#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value='#email_to#'>,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_subject#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#email_body#">, 1)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
	</cfif>
	<script language="JavaScript1.2">
	if (window.opener.funcfiltro) {window.opener.funcfiltro()}
	window.close();
</script>
</cfif>
</cfoutput>
</form>
