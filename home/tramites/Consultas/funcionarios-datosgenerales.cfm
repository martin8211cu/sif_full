<cfif isdefined("Form.id_inst") and Len(Trim(Form.id_inst)) and isdefined("Form.id_funcionario") and Len(Trim(Form.id_funcionario))>
	<cfquery name="rsDatos" datasource="#session.tramites.dsn#">
		select a.id_inst, a.id_funcionario, a.ts_rversion, 
			   b.id_persona, b.id_tipoident, b.id_direccion, b.identificacion_persona, b.nombre || ' ' || b.apellido1 || ' ' || b.apellido2 as nombre_completo, 
			   b.nacimiento, b.sexo, b.casa, b.oficina, b.celular, b.fax, b.pagertel, b.pagernum, b.email1, b.email2, b.web, b.foto, 
			   b.firma, b.nacionalidad, b.extranjero, b.ts_rversion,
			   c.codigo_inst, c.nombre_inst, c.codigo_inst || ' - ' || c.nombre_inst as institucion,
			   d.codigo_tipoident, d.nombre_tipoident
		from TPFuncionario a
			inner join TPPersona b
				on b.id_persona = a.id_persona
			inner join TPInstitucion c
				on c.id_inst = a.id_inst
			inner join TPTipoIdent d
				on d.id_tipoident = b.id_tipoident
		where a.id_inst = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_inst#">
		and a.id_funcionario = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.id_funcionario#">
	</cfquery>

	<cfset ts = ""> 
	<cfinvoke component="sif/Componentes/DButils" method="toTimeStamp" arTimeStamp="#rsDatos.ts_rversion#" returnvariable="ts">
	</cfinvoke>

	<cfinclude template="/home/tramites/getEmpresa.cfm">
	
	<!--- Persona tiene usuario asociado --->
	<cfquery name="usuario" datasource="asp">
		select Usucodigo
		from UsuarioReferencia
		where llave = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatos.id_persona#">
		and STabla = 'TPPersona'
	</cfquery>
	<cfset correo = '' >
	<cfset login = '' >
	<cfif usuario.recordcount gt 0 >
		<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
		<cfset usuario = sec.getUsuarioByRef(rsDatos.id_persona, getEmpresa.EcodigoSDC, 'TPPersona') >
		<cfset correo = usuario.Pemail1 >
		<cfset login = usuario.Usulogin >
	</cfif>

	<cfoutput>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		  <tr>
		    <td valign="top" align="center">
				<table width="520" cellpadding="2" cellspacing="0" align="center">
				  <cfif not (isdefined("session.tramites.id_funcionario") and session.tramites.id_funcionario EQ form.id_funcionario)>
				  <tr>
					<td valign="top" align="center">
						<img src="../public/logo_inst.cfm?id_inst=#rsDatos.id_inst#&amp;ts=#ts#" height="80" id="logo_inst_preview">
					</td>
					<td valign="middle">
						<font size="3"><strong>#rsDatos.nombre_inst#</strong></font>
					</td>
				  </tr>
				  </cfif>
				  <tr>
					<td valign="top" align="center">
						<cfif Len(rsDatos.foto) GT 1>
							<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="tsurl">
								<cfinvokeargument name="arTimeStamp" value="#rsDatos.ts_rversion#"/>
							</cfinvoke>
							<img src="/cfmx/home/tramites/Operacion/gestion/foto_persona.cfm?s=#URLEncodedFormat(rsDatos.id_persona)#&amp;ts=#tsurl#" width="78" height="90" border="0" align="middle">
						<cfelse>
							<img src="/cfmx/home/public/not_avail.gif" width="78" height="90" border="0" align="middle">
					  	</cfif>
					</td>
					<td valign="top">
						<table width="100%" cellpadding="2" cellspacing="0" border="0">
							<tr>
							  <td>
							  	#rsDatos.nombre_tipoident# #rsDatos.identificacion_persona#
							  </td>
							</tr>
							<tr>
							  <td>#rsDatos.nombre_completo#</td>
							</tr>
							<tr>
							  <td>
							  	<cfif len(trim(rsDatos.id_direccion))>
								  <cf_tr_direccion key="#rsDatos.id_direccion#" action="display">
								</cfif>
							  </td>
							</tr>
							<tr>
							  <td>#correo#</td>
							</tr>
						</table>
					</td>
				  </tr>
				</table>
			</td>
	      </tr>
		  <tr>
			<td>&nbsp;</td>
		  </tr>
		</table>
	</cfoutput>
	
</cfif>
