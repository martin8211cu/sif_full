	<cfif isdefined("url.cboGrupos") and not isdefined("form.cboGrupos")>
		<cfset form.cboGrupos = url.cboGrupos>
	</cfif>
    
    <cfif isdefined("url.MaxRows") and not isdefined("form.MaxRows")>
    	<cfset form.MaxRows = url.MaxRows>
    </cfif>

	<cf_templateheader title="Contabilidad General">

		<!--- Verifica los permisos del usuario --->
		<cfquery name="rsPermisos" datasource="#session.DSN#">
			Select a.*
			from PCReglaGrupo a
					inner join PCUsuariosReglaGrp b
							 on a.PCRGid = b.PCRGid
							and a.Ecodigo = b.Ecodigo
			where b.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#"> 
		</cfquery>
	
		<cfquery name="rsMyUser" datasource="#session.DSN#">
		Select Usulogin
		from Usuario
		where Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
		</cfquery>
		<cfset LvarUsuario = rsMyUser.Usulogin>	

		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo="Mantenimiento de Reglas">

		<cfif isdefined("Url.PageNum_lista") and Len(Trim(Url.PageNum_lista))>
			<cfparam name="Form.PageNum_lista" default="#Url.PageNum_lista#">
		</cfif>
		<cfif isdefined("Url.PCRid") and Len(Trim(Url.PCRid))>
			<cfparam name="Form.PCRid" default="#Url.PCRid#">
		</cfif>
		<!--- En este caso si se puede enviar Cmayor en blanco --->
		<cfif isdefined("Url.filtro_OficodigoM")>
			<cfparam name="Form.filtro_OficodigoM" default="#Url.filtro_OficodigoM#">
		</cfif>
		<cfif isdefined("Url.filtro_Cmayor")>
			<cfparam name="Form.filtro_Cmayor" default="#Url.filtro_Cmayor#">
		</cfif>
		<cfif isdefined("Url.filtro_PCRregla")>
			<cfparam name="Form.filtro_PCRregla" default="#Url.filtro_PCRregla#">
		</cfif>
		<cfif isdefined("Url.filtro_PCRvalida")>
			<cfparam name="Form.filtro_PCRvalida" default="#Url.filtro_PCRvalida#">
		</cfif>
		<cfif isdefined("Url.filtro_PCRdesde")>
			<cfparam name="Form.filtro_PCRdesde" default="#Url.filtro_PCRdesde#">
		</cfif>
		<cfif isdefined("Url.filtro_PCRhasta")>
			<cfparam name="Form.filtro_PCRhasta" default="#Url.filtro_PCRhasta#">
		</cfif>
		<cfif isdefined("url.RetTipos")>
			<cfparam name="Form.RetTipos" default="#Url.RetTipos#">
		</cfif>

	
		<cfinclude template="../../portlets/pNavegacionCG.cfm">

		<cfif rsPermisos.recordcount eq 0>

			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <tr><td>&nbsp;</td></tr>
			  <tr>
				<td>
					
					<table width="60%" class="ayuda" align="center">
						<tr>
							<td align="center">
								<p align="center">
								El Usuario <strong><cfoutput>#LvarUsuario#</cfoutput></strong> no tiene permiso de accesar grupos de reglas contables. <br>Por favor contacte al administrador en caso de requerirlos.
								</p>
							</td>	
						</tr>						
						<tr>
							<td align="center">
								<input type="button" name="Regresar" value="Regresar" onClick="javascript: location.href = '../../../sif/cg/MenuCG.cfm?Sub26';">
							</td>
						</tr>
					</table>					
					
				</td>
			  </tr>
			  <tr><td>&nbsp;</td></tr>
			</table>		
		
		<cfelse>

			<cfif not isdefined("btnElegirGrp")>

				<table width="100%" border="0" cellspacing="0" cellpadding="0">
				  <tr><td>&nbsp;</td></tr>
				  <tr>
					<td>
						
						<form method="post" name="form1" action="AdminReglas.cfm">
						<table width="60%" class="ayuda" align="center">
							<tr>
								<td align="center">
									<p align="center">
									Grupos permitidos para el usuario: <strong><cfoutput>#LvarUsuario#</cfoutput></strong><br><br>
									Seleccione un grupo para poder incluir reglas:
									</p>
									<select name="cboGrupos">
									<cfoutput query="rsPermisos">
										<option value="#rsPermisos.PCRGid#">#rsPermisos.PCRGDescripcion#</option>
									</cfoutput>
									</select>									
								</td>	
							</tr>						
							<tr>
								<td align="center">
									<input type="submit" name="btnElegirGrp" value="Agregar Reglas">
								</td>
							</tr>
						</table>
						</form>
						
					</td>
				  </tr>
				  <tr><td>&nbsp;</td></tr>
				</table>		


			<cfelse>
			
				<cfset LvarGrp = "">
				<cfif isdefined("form.cboGrupos")>
					<cfset LvarGrp = form.cboGrupos>
				</cfif>
				<cfif LvarGrp eq "">
					<table width="100%" border="0" cellspacing="0" cellpadding="0">
					  <tr>
						<td align="center">
							<strong>Es necesario elegir un grupo.</strong>
						</td>
					  </tr>
					</table>				
				<cfelse>
					<table width="100%" border="0" cellspacing="0" cellpadding="0">						   
					  <tr>
						<td>
							<cfinclude template="AdminReglas-form.cfm">
						</td>
					  </tr>
					  <tr>
						<td>
							<cfinclude template="AdminReglas-lista.cfm">
						</td>
					  </tr>
					</table>
				</cfif>
				
			</cfif>
			
		</cfif>
		<cf_web_portlet_end>
				
	<cf_templatefooter>


