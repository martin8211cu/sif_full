<!--- Expediente --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="Direccion"
	Default="Dirección"
	Idioma="#session.Idioma#"
	returnvariable="vDireccion"/>

<cf_web_portlet_start titulo="#vDireccion#">

<cfquery name="rsDireccion" datasource="#Session.DSN#">
	select de.DIEMid, de.DEid, de.DGid, de.DIEMdestalles, de.DIEMapartado, de.DIEMtipo, de.Ecodigo, ng.Ppais
	from DEmpleado de
		left outer join <cf_dbdatabase table="DistribucionGeografica" datasource="asp"> dg
			inner join <cf_dbdatabase table="NivelGeografico" datasource="asp"> ng
				on ng.NGid = dg.NGid
			on dg.DGid = de.DGid
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	<cfif isdefined('form.DIEMtipo') and len(trim(form.DIEMtipo))>
	  and DIEMtipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DIEMtipo#">
	</cfif>
</cfquery>
<cfif not isdefined('form.DIEMtipo')>
	<cfset form.DIEMtipo = rsDireccion.DIEMtipo>
</cfif>
<cfif not isdefined('form.Ppais')>
	<cfset form.Ppais = rsDireccion.Ppais>
</cfif>
<cfoutput>
<form name="formDir" method="post" action="expediente-globalcons.cfm?DEid=#url.DEid#&o=#url.o#" style="margin:0; " onsubmit="fnValidarDir(this.DirIni.value);">
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
					<!--- Línea No. 2 --->
					<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetPaises" returnvariable="rsPaises">
						<cfinvokeargument name="IsConfig" 	value="true">
					</cfinvoke>
					<tr><td colspan="2">
						<fieldset><legend>Escoja la configuraci&oacute;n:</legend>
						<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
							<tr>
								<td nowrap="nowrap"><strong>Tipo:</strong></td>
								<td nowrap="nowrap">
									<select id="DIEMtipo" name="DIEMtipo" onchange="if(this.value != -1 && this.form.Ppais.value != -1){this.form.submit();}">	
										<option value="-1">--Seleccione--</option>
										<option value="0" <cfif isdefined('form.DIEMtipo') and form.DIEMtipo eq '0'>selected</cfif>>Residencial</option>
										<option value="1" <cfif isdefined('form.DIEMtipo') and form.DIEMtipo eq '1'>selected</cfif>>Nacimiento</option>
									</select>
								</td>
								<td nowrap="nowrap"><strong>Pa&iacute;s:</strong></td>
								<td nowrap="nowrap">
									<select id="Ppais" name="Ppais" onchange="if(this.value != -1 && this.form.DIEMtipo.value != -1){this.form.submit();}">	
										<option value="-1">--Seleccione--</option>
										<cfloop query="rsPaises">
											<option value="#rsPaises.Ppais#" <cfif isdefined('form.Ppais') and form.Ppais eq rsPaises.Ppais>selected</cfif>>#rsPaises.Pnombre#</option>
										</cfloop>
									</select>
								</td>
							</tr>
						</table>
						</fieldsets>
					</td></tr>
					<cfif isdefined('form.Ppais') and len(trim(form.Ppais))>
						<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetNiveles" returnvariable="rsNiveles">
							<cfinvokeargument name="Conexion" 	value="asp">
							<cfinvokeargument name="getRaiz" 	value="true">
							<cfinvokeargument name="Ppais" 		value="#form.Ppais#">
						</cfinvoke>
						<tr><td nowrap="nowrap" colspan="2">&nbsp;</td></tr>
						<cfloop query="rsNiveles">
							<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetListadoDist" returnvariable="rsDistribuciones">
								<cfinvokeargument name="NGid" 		value="#rsNiveles.NGid#">
							</cfinvoke>
							<tr>
								<td nowrap="nowrap"><strong>#rsNiveles.NGDescripcion#:</strong>&nbsp;</td>
								<td nowrap="nowrap">
									<select id="#rsNiveles.NGcodigo#" name="#rsNiveles.NGcodigo#" disabled="disabled">
										<option value="-1">--No Suministrado--</option>
									</select>
								</td>
							</tr>
							<tr><td nowrap="nowrap" colspan="2">&nbsp;</td></tr>
							<cfif rsNiveles.cantSubNiveles gt 0>
								<cfset fnGetHijos(rsNiveles.Ppais,rsNiveles.NGid,rsNiveles.NGcodigo)>
							</cfif>
						</cfloop>
						<tr>
							<td nowrap="nowrap"><strong>Otros Detalles:</strong>&nbsp;</td>
							<td nowrap="nowrap"><textarea id="DIEMdestalles" name="DIEMdestalles" cols="100" rows="1" readonly>#rsDireccion.DIEMdestalles#</textarea></td>
						</tr>
						<tr><td nowrap="nowrap" colspan="2">&nbsp;</td></tr>
						<tr>
							<td nowrap="nowrap"><strong>Apartado Postal:</strong>&nbsp;</td>
							<td nowrap="nowrap"><input type="text" id="DIEMapartado" name="DIEMapartado" size="100" maxlength="50" value="#rsDireccion.DIEMapartado#" readonly/></td>
						</tr>

						<script language="javascript1.2" type="text/javascript">
							var direccionArray = new Array() ;
							<cfif len(trim(rsDireccion.DGid))>
								<cfset fnGetPadre(form.Ppais,rsDireccion.DGid)>
								for( i = 0; i < direccionArray.length; i++){
									obj = document.getElementById(direccionArray[i][0]);
									try{
										obj.add(new Option(direccionArray[i][1], direccionArray[i][2]), null) //add new option to end of "sample"
									}catch(e){ //in IE, try the below version instead of add()
										obj.add(new Option(direccionArray[i][1], direccionArray[i][2])) //add new option to end of "sample"
									}
									obj.value = direccionArray[i][2];
								}
							</cfif>
						</script>
					</cfif>
				</table>
				<input id="DEid" 	   name="DEid" 		 type="hidden" value="<cfif isdefined("form.DEid")>#form.DEid#</cfif>">
				<input id="modo" name="modo" type="hidden" value="<cfif isdefined("modo")><cfoutput>#modo#</cfoutput></cfif>">
			</td>
		</tr>
	</table>
</form>
</cfoutput>
<cffunction name="fnGetHijos" access="private" output="true">
  	<cfargument name='Ppais'	type='string' 	required='true'>
	<cfargument name='NGid'		type='numeric' 	required='true'>
	<cfargument name='RefPadre'	type='string' 	required='true'>
	
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetNiveles" returnvariable="rsSubNiveles">
		<cfinvokeargument name="Ppais" 		value="#Arguments.Ppais#">
		<cfinvokeargument name="NGidPadre"    value="#Arguments.NGid#">
	</cfinvoke>
	<cfloop query="rsSubNiveles">
		<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetNiveles" returnvariable="rsSubNivel">
			<cfinvokeargument name="Ppais" 		value="#Ppais#">
			<cfinvokeargument name="NGidPadre"    value="#rsSubNiveles.NGid#">
		</cfinvoke>
		<tr>
			<td nowrap="nowrap"><strong>#rsSubNiveles.NGDescripcion#:</strong>&nbsp;</td>

			<td nowrap="nowrap">
				<select id="#rsSubNiveles.NGcodigo#" name="#rsSubNiveles.NGcodigo#" disabled="disabled">	
					<option value="-1">--No Suministrado--</option>
				</select>
			</td>
		</tr>
		<tr><td nowrap="nowrap" colspan="2">&nbsp;</td></tr>
		<cfif rsSubNiveles.cantSubNiveles gt 0>
			<cfset fnGetHijos(rsSubNiveles.Ppais,rsSubNiveles.NGid,rsSubNiveles.NGcodigo)>
		</cfif>
	</cfloop>
</cffunction>
<cffunction name="fnGetPadre" access="private" output="true">
  	<cfargument name='Ppais'	type='string' 	required='true'>
	<cfargument name='DGid'		type='numeric' 	required='true'>
	
	<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetListadoDist" returnvariable="rsPadreDist">
		<cfinvokeargument name="Ppais" 		value="#Arguments.Ppais#">
		<cfinvokeargument name="DGid"   	value="#Arguments.DGid#">
	</cfinvoke>
	<cfloop query="rsPadreDist">
		direccionArray.unshift(new Array('#rsPadreDist.NGcodigo#','#rsPadreDist.DGDescripcion#', '#rsPadreDist.DGid#'));
		<cfif len(trim(rsPadreDist.DGidPadre)) gt 0>
			<cfset fnGetPadre(rsPadreDist.Ppais,rsPadreDist.DGidPadre)>
		</cfif>
	</cfloop>
</cffunction>
<cf_web_portlet_end>
