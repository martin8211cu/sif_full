<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<cfoutput>#pNavegacion#</cfoutput>
		<cfif isdefined("url.SNcodigo") and len(trim(url.SNcodigo)) and not isdefined("form.SNcodigo")>
			<cfset form.SNcodigo = url.SNcodigo>
		</cfif>
		<cfif isdefined("url.id_direccion") and len(trim(url.id_direccion)) and not isdefined("form.id_direccion")>
			<cfset form.id_direccion = url.id_direccion>
		</cfif>
		<cfif isdefined("url.tabs") and len(trim(url.tabs)) and not isdefined("form.tabs")>
			<cfset form.tabs = url.tabs>
		</cfif>
		<cfif isdefined("url.SNLCid") and len(trim(url.SNLCid)) and not isdefined("form.SNLCid")>
			<cfset form.SNLCid = url.SNLCid>
		</cfif>
		<cfif isdefined("url.SNCat") and url.SNCat eq 1>
			<cfset form.SNCat = url.SNCat>
		</cfif>
		
		
		
<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
	<cfquery name="rsSocios" datasource="#Session.DSN#" >
		select yo.SNplazoentrega,yo.SNplazocredito,rtrim(yo.LOCidioma) as LOCidioma,yo.Ecodigo, yo.SNcodigo, yo.SNidentificacion,yo.SNidentificacion2, yo.SNtiposocio, yo.SNnombre, yo.SNdireccion,
		 yo.CSNid, yo.GSNid, yo.ESNid, yo.DEidEjecutivo, yo.DEidVendedor, yo.DEidCobrador, yo.SNnombrePago,
		 yo.SNtelefono, yo.SNFax, yo.SNemail, yo.SNFecha, yo.SNtipo, yo.SNvencompras, yo.SNvenventas, yo.SNinactivo, coalesce (yo.ZCSNid,-1) as ZCSNid,
		 yo.Mcodigo, yo.SNmontoLimiteCC, yo.SNdiasVencimientoCC, yo.SNdiasMoraCC, yo.SNdocAsociadoCC,
		 coalesce(yo.SNactivoportal, 0) as SNactivoportal, yo.SNnumero, yo.ts_rversion, yo.Ppais, yo.SNcertificado, yo.SNcodigoext, yo.cuentac,
		 yo.id_direccion, yo.SNidPadre, padre.SNcodigo as SNcodigoPadre, yo.SNid, yo.SNidCorporativo, 
		 coalesce (yo.EcodigoInclusion, yo.Ecodigo) as EcodigoInclusion, einc.Edescripcion	 as EnombreInclusion,
		 yo.esIntercompany,yo.Intercompany,yo.TESRPTCid,yo.TESRPTCidCxC
		from SNegocios yo
			left join SNegocios padre
				on yo.SNidPadre = padre.SNid
			left join Empresas einc
				on einc.Ecodigo = coalesce (yo.EcodigoInclusion, yo.Ecodigo)
		where yo.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and yo.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
		order by yo.SNnombre asc
	</cfquery>
</cfif>




<table width="100%" border="0" cellspacing="1" cellpadding="1">
  <tr>
	<td>
			
		<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
			<table align="right" cellpadding="2" cellspacing="3" border="0">
				<tr>
					<td nowrap="nowrap"><strong>Socio de Negocios:</strong></td>
					<td nowrap="nowrap"><cfoutput>#HTMLEditFormat(rsSocios.SNnombre)#</cfoutput></td>
					
					<td nowrap="nowrap"><strong>Identificaci&oacute;n:</strong></td>
					<td nowrap="nowrap"><cfoutput>#HTMLEditFormat(rsSocios.SNidentificacion)#</cfoutput></td>
					
				</tr>
				<tr>
					<td nowrap="nowrap"><strong>N&uacute;mero de Socio:</strong></td>
					<td nowrap="nowrap"><cfoutput>#rsSocios.SNnumero#</cfoutput></td>
					
					<td nowrap="nowrap"><strong>Correo:</strong></td>
					<td nowrap="nowrap"><cfoutput>#rsSocios.SNemail#</cfoutput></td>
				</tr>
			</table>
		</cfif>
			
	</td>
	<td>
		<table width="100%" align="left" cellpadding="0" cellspacing="0" border="0">
			<tr>
				<td align="right"><a href="listaSocios_Direcciones.cfm">Seleccionar un Socio</a></td>
				<td align="right"><a href="listaSocios_Direcciones.cfm"><img alt="Seleccionar un Socio"  border="0" src="/cfmx/sif/imagenes/find.small.png"></a></td>

				<td nowrap="nowrap" align="right"><a href="Socios.cfm?SNcodigo=<cfoutput>#form.SNcodigo#</cfoutput>">Datos del Socio</a></td>
				<td nowrap="nowrap" align="right"><a href="Socios.cfm?SNcodigo=<cfoutput>#form.SNcodigo#</cfoutput>"><img alt="Datos del Socio"  border="0" src="../../imagenes/Documentos2.gif"></a></td>
			</tr>
			<cfif isdefined("form.SNcodigo") and len(trim(form.SNcodigo))>
				<cfquery name="rsTipoSocio" datasource="#session.DSN#">
					select SNtiposocio
					from SNegocios
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigo#">
				</cfquery>
				<cfif rsTipoSocio.recordcount EQ 1 and rsTipoSocio.SNtiposocio eq 'C' or rsTipoSocio.SNtiposocio eq 'A'>
					<tr>
						<td align="right"><a href="../../cc/consultas/analisisSocio.cfm?SNcodigo=<cfoutput>#form.SNcodigo#</cfoutput>&Ocodigo_F=-1&CatSocDir=1">Consultar Saldo del Socio</a></td>
						<td align="right"><a href="../../cc/consultas/analisisSocio.cfm?SNcodigo=<cfoutput>#form.SNcodigo#</cfoutput>&Ocodigo_F=-1&CatSocDir=1"><img alt="Consultar Saldo del Socio"  border="0" src="/cfmx/sif/imagenes/SP_D.gif"></a></td>

						<td>&nbsp;</td>
						<td>&nbsp;</td>
					</tr>
				</cfif>
			</cfif>
		</table>
	</td>
  </tr>
</table>		

		<table>
			<tr>
				<td align="center" valign="top" height="600">
					<cfparam name="form.tabs" default="1">
					<cf_tabs width="99%">
							<cf_tab text="Direcci&oacute;n" selected="#form.tabs eq 1#">
								 <cfinclude template="formSociosDireccion.cfm">
							</cf_tab>
						<cfif Len(form.id_direccion)>
							<cf_tab text="Clasificación" selected="#form.tabs eq 2#">
								 <cfinclude template="SociosClasifDireccion.cfm">
							</cf_tab>
							<cf_tab text="Límite de Crédito Adicional" selected="#form.tabs eq 3#">
								 <cfinclude template="SociosLimCredAdic.cfm">
							</cf_tab>
							<cf_tab text="Contactos" selected="#form.tabs eq 4#">
								 <cfinclude template="ContactosxDireccion.cfm">
							</cf_tab>
						</cfif>
					</cf_tabs>
				</td>
			</tr>
			<tr>
				<td>&nbsp;</td>
			</tr>
		</table>

		<cf_web_portlet_end>	
<cf_templatefooter>