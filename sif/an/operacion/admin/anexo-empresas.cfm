<cfif isdefined("url.AnexoId") and not isdefined("form.AnexoId")>
	<cfset form.AnexoId = url.AnexoId>
</cfif>
<cfquery name="rsEmpresas" datasource="#session.DSN#">
	select 	a.Ereferencia,
			c.AnexoId, 
			a.Ecodigo,
			a.Elogo,
			a.Enombre
	from Empresa a
		inner join Empresas b
			on a.Ereferencia = b.Ecodigo
		left outer join AnexoEm c
			on b.Ecodigo = c.Ecodigo
			and AnexoId =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.AnexoId#">
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#"> 
</cfquery>
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Empresas'>
	<cfoutput>
		<form name="form1" action="anexo-empresas-sql.cfm" method="post">
			<input type="hidden" name="tab" value="<cfif isdefined("url.tab") and len(trim(url.tab))>#url.tab#</cfif>">
			<input type="hidden" name="AnexoId" value="<cfif isdefined("url.AnexoID") and len(trim(url.AnexoId))>#url.AnexoId#</cfif>">
			<table width="100%" cellpadding="0" cellspacing="0">	
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td>&nbsp;</td>
					<td colspan="3">
						<table width="100%" border="0" align="center" cellpadding="2" cellspacing="2" class="ayuda">				
							<tr><td align="center"><strong>Seleccione las empresas que desea tengan acceso a los anexos especificados</strong></td></tr>
							<tr><td align="center"><strong>Nota: Solo se muestran las empresas que trabajan en la misma base de datos</strong></td></tr>
						</table>
					</td>
					<td>&nbsp;</td>
				</tr>	
				<tr><td width="5">&nbsp;</td></tr>
				<tr>
					<td colspan="5">
					<table width="100%" border="0" cellpadding="2" cellspacing="0">
						<tr><td width="10%">&nbsp;</td></tr>
						<cfloop query="rsEmpresas">
							<cfif rsEmpresas.currentrow eq 1 or rsEmpresas.currentrow mod 2>
								<tr>
									<td width="9%" align="right"><input type="checkbox" name="chk" value="#rsEmpresas.Ereferencia#" id="#rsEmpresas.Ereferencia#" <cfif len(trim(rsEmpresas.AnexoId))>checked</cfif>></td>
									<!--- <td width="10%" align="right"><cf_sifleerimagen autosize="true" border="false"  tabla="Empresa" campo="Elogo" condicion="Ecodigo = #rsEmpresas.Ecodigo#" conexion="#Session.DSN#" imgname="Img#rsEmpresas.Ecodigo#" width="80" height="60"></td>	 --->
									<td width="1%">&nbsp;</td>
									<td width="30%" align="left"><label for="#rsEmpresas.Ereferencia#"><strong>#rsEmpresas.Enombre#</strong></label></td>
							<cfelse>
									
									<td width="9%" align="right"><input type="checkbox" name="chk" value="#rsEmpresas.Ereferencia#" id="#rsEmpresas.Ereferencia#" <cfif len(trim(rsEmpresas.AnexoId))>checked</cfif>></td>
									<!--- <td width="10%" align="right"><cf_sifleerimagen autosize="true" border="false"  tabla="Empresa" campo="Elogo" condicion="Ecodigo = #rsEmpresas.Ecodigo#" conexion="#Session.DSN#" imgname="Img#rsEmpresas.Ecodigo#" width="80" height="60"></td> --->
									<td width="1%">&nbsp;</td>
									<td width="30%" align="left"><label for="#rsEmpresas.Ereferencia#"><strong>#rsEmpresas.Enombre#</strong></label></td>
								</tr>
							</cfif>
						</cfloop>
						<cfif rsEmpresas.RecordCount mod 2 gt 0><!---Cerrado de td y tr cuando es un numero impar de empresas--->
							</td></tr>
						</cfif>
						</table>	
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
				<tr>
					<td colspan="5" align="center">
						<input type="submit" name="btnCambio" value="Modificar">
					</td>
				</tr>
				<tr><td>&nbsp;</td></tr>
			</table>
		</form>
	</cfoutput>
<cf_web_portlet_end>


