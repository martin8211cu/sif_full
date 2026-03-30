<!--- Asignación el valor a la variable modo --->
<cfset modo="ALTA">
<cfif isdefined("Form.DEid") and len(trim("Form.DEid")) NEQ 0 and Form.DEid gt 0 >
    <cfset modo="CAMBIO">
</cfif>
<cfinclude template="/rh/expediente/catalogos/asociados-etiquetas.cfm">
<cfparam name="modoD" default="ALTA">
<cfif isdefined("Form.DIEMid") and len(trim("Form.DIEMid")) NEQ 0 and Form.DIEMid gt 0 >
    <cfset modoD="CAMBIO">
</cfif>
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
<cfquery name="rsDireccionActual" datasource="#Session.DSN#">
	select 	distinct DEdireccion
	from DatosEmpleado
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	<cfif Session.cache_empresarial EQ 0>
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	</cfif>
</cfquery>
<cfif not isdefined('form.DIEMtipo')>
	<cfset form.DIEMtipo = rsDireccion.DIEMtipo>
</cfif>
<cfif not isdefined('form.Ppais')>
	<cfset form.Ppais = rsDireccion.Ppais>
</cfif>
<!--- Pintado de la Pantalla --->
<!---<cfset Ppais = "CR">--->
<cfoutput>
<form name="formDir" method="post" action="direcciones-sql.cfm" style="margin:0; " onsubmit="return fnValidarDireccion(this.DirIni.value);">
	<table width="100%" cellpadding="2" cellspacing="0" border="0">
		<tr>
			<td class="#Session.preferences.Skin#_thcenter" style="padding-left: 5px;">#LB_Direccion# #rsEncabEmpleado.nombreEmpl#</td>
		</tr>

		<tr>
			<td>
				<table width="100%" border="0" cellspacing="0" cellpadding="2" align="center">
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
						<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetListadoDist" returnvariable="rsDistribuciones">
							<cfinvokeargument name="NGid" 		value="#rsNiveles.NGid#">
						</cfinvoke>
						<cfinvoke component="asp.Geografica.componentes.DistribucionGeografica" method="fnGetNiveles" returnvariable="rsSubNivel">
							<cfinvokeargument name="Ppais" 		value="#form.Ppais#">
							<cfinvokeargument name="NGidPadre"    value="#rsNiveles.NGid#">
						</cfinvoke>
						<tr>
							<td nowrap="nowrap"><strong>#rsNiveles.NGDescripcion#:</strong>&nbsp;</td>
							<td nowrap="nowrap">
								<cf_conlis
								campos="C#rsNiveles.NGcodigo#DGid,C#rsNiveles.NGcodigo#DGcodigo,C#rsNiveles.NGcodigo#DGDescripcion"
								desplegables="N,S,S"
								modificables="N,S,N"
								size="0,10,40"
								title="Lista de #rsNiveles.NGDescripcion#"
								tabla="DistribucionGeografica"
								columnas="DGid as C#rsNiveles.NGcodigo#DGid,DGcodigo as C#rsNiveles.NGcodigo#DGcodigo,DGDescripcion as C#rsNiveles.NGcodigo#DGDescripcion"
								filtro="NGid = #rsNiveles.NGid# order by DGcodigo"
								desplegar="C#rsNiveles.NGcodigo#DGcodigo,C#rsNiveles.NGcodigo#DGDescripcion"
								filtrar_por="DGcodigo,DGDescripcion"
								etiquetas="Código, Descripción"
								formatos="S,S"
								align="left,left"
								asignar="C#rsNiveles.NGcodigo#DGid,C#rsNiveles.NGcodigo#DGcodigo,C#rsNiveles.NGcodigo#DGDescripcion"
								asignarformatos="S,S, S"
								showEmptyListMsg="true"
								EmptyListMsg="-- No se encontraron Países --"
								tabindex="1"
								form="formDir"
								funcion="fnCambiarDistribucion('C#rsNiveles.NGcodigo#','#rsNiveles.Ppais#')"
								onchange="fnCambiarDistribucion('C#rsNiveles.NGcodigo#','#rsNiveles.Ppais#')"
								conexion = "asp">
								<input type="hidden" id="C#rsNiveles.NGcodigo#Ref" name="C#rsNiveles.NGcodigo#Ref" value="C#rsSubNivel.NGcodigo#"/>
								<input type="hidden" id="DirIni" name="DirIni" value="C#rsNiveles.NGcodigo#"/>
							</td>
						</tr>
						<tr><td nowrap="nowrap" colspan="2">&nbsp;</td></tr>
						<cfif rsNiveles.cantSubNiveles gt 0>
							<cfset fnGetHijos(rsNiveles.Ppais,rsNiveles.NGid,rsNiveles.NGcodigo)>
						</cfif>
						<tr>
							<td nowrap="nowrap"><strong>Otros Detalles:</strong>&nbsp;</td>
							<td nowrap="nowrap"><textarea id="DIEMdestalles" name="DIEMdestalles" cols="100" rows="1" onkeydown="if(this.value.length >= 100){return false; }">#rsDireccion.DIEMdestalles#</textarea></td>
						</tr>
						<tr><td nowrap="nowrap" colspan="2">&nbsp;</td></tr>
						<tr>
							<td nowrap="nowrap"><strong>Código Postal:</strong>&nbsp;</td>
							<td nowrap="nowrap"><input readonly="true"type="text" id="DIEMapartado" name="DIEMapartado" size="100" maxlength="50" value="#rsDireccion.DIEMapartado#"/></td>
						</tr>
						<tr>
							<td nowrap="nowrap" align="center" colspan="2">
								<input type="submit" id="Guardar" name="Guardar" class="btnGuardar" value="Guardar"/>
								<input type="hidden" id="DGid" name="DGid" value="#rsDireccion.DGid#"/>
							</td>
						</tr>
						<script language="javascript1.2" type="text/javascript">
							function fnCambiarDistribucion(codigo,Ppais) {
								obj = document.getElementById(codigo+'DGid');
								valor = obj.value;
								ref = document.getElementById(codigo+"Ref");
								urlA = "direcciones-iframe.cfm?Action=Apartado&Ppais="+Ppais+"&id="+valor;
								while(ref && ref.value.length > 1){
									document.getElementById(ref.value+"DGid").value = "";
									document.getElementById(ref.value+"DGcodigo").value = "";
									document.getElementById(ref.value+"DGDescripcion").value = "";
									ref = document.getElementById(ref.value+"Ref");
								}
								codValor = document.getElementById(codigo+'DGcodigo').value;
								if(codValor.replace(/^\s+|\s+$/gi,'').length > 0){
									document.getElementById("DGid").value = valor;
								}else{
									ref = document.getElementById(codigo+"RefPadre");
									if(ref){
										document.getElementById("DGid").value = document.getElementById(ref.value+"DGid").value;
									}else
										document.getElementById("DGid").value = "";
								}
								if(valor.replace(/^\s+|\s+$/gi,'').length > 0)
									document.getElementById("DIEMapartado").value = fnAjax(urlA);
								else
									document.getElementById("DIEMapartado").value = "";
							}

							function fnAjax(url){
								var xml = null;
								 try{
									 xml = new ActiveXObject("Microsoft.XMLHTTP");
								 }catch(expeption){
									 xml = new XMLHttpRequest();
								 }
								 xml.open("GET",url, false);
								 xml.send(null);
								 return xml.responseText.replace(/^\s+|\s+$/gi,'');
							}

							var direccionArray = new Array() ;
							function obtenerDireccion(codigo){
								direccionArray = new Array() ;
								direccion = document.getElementById(codigo+"DGDescripcion");
								if(direccion && direccion.value.length > 0)
									direccionArray.unshift(direccion.value);
								else
									return false;
								ref = document.getElementById(codigo+"Ref");
								while(ref && ref.value.length > 1){
									direccion = document.getElementById(ref.value+"DGDescripcion");
									if(direccion && direccion.value.length > 0)
										direccionArray.unshift(direccion.value);
									else
										return false;
									ref = document.getElementById(ref.value+"Ref");
								}
							}

							function fnValidarDireccion(DirIni){
								if(document.formDir.DIEMtipo.value != '0')
									return true;
								obtenerDireccion(DirIni);
								dir = document.formDir.DIEMdestalles.value;
								for( i = 0; i < direccionArray.length; i++){
									if(i == 0 && dir.replace(/^\s+|\s+$/gi,'').length > 0)
										dir = dir + ", ";
									else if(i != 0)
										dir = dir + ", ";
									dir = dir + rtrim(direccionArray[i]);
								}
								dir = dir + ", C.P.: " + rtrim(document.formDir.DIEMapartado.value);
								if(dir == "#rsDireccionActual.DEdireccion#")
									return true;
								if(confirm("La Dirección ha cambiado desea actualizarla la dirección en 'Datos Empleado'?\n  Actual: " + document.formDir.direccion.value +"\n  Nueva: "+ dir)){
									document.formDir.direccion.value = dir;
									document.formDir.CambiarDir.value = "1";
								}
								return true;
							}
							<cfif len(trim(rsDireccion.DGid)) gt 0 and rsDireccion.Ppais eq form.Ppais>
								<cfset fnGetPadre(form.Ppais,rsDireccion.DGid)>
								for( i = 0; i < direccionArray.length; i++){
									codigo = direccionArray[i][0];
									document.getElementById(codigo+"DGid").value = direccionArray[i][1];
									document.getElementById(codigo+"DGcodigo").value = direccionArray[i][2];
									document.getElementById(codigo+"DGDescripcion").value = direccionArray[i][3];
								}
							</cfif>

							function ltrim(s) {
								return s.replace(/^\s+/, "");
							}

							function rtrim(s) {
								return s.replace(/\s+$/, "");
							}

						</script>
					</cfif>
				</table>
				<input id="DEid" 	   name="DEid" 		 type="hidden" value="<cfif isdefined("form.DEid")>#form.DEid#</cfif>">
				<input id="direccion"  name="direccion"  type="hidden" value="<cfif isdefined("rsDireccionActual")>#rsDireccionActual.DEdireccion#</cfif>">
				<input id="CambiarDir" name="CambiarDir" type="hidden" value="0">
				<cfif modoD eq 'CAMBIO'>
					<input id="DIEMid" name="DIEMid" type="hidden" value="#rsDireccion.DIEMid#">
				</cfif>

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
				<cf_conlis
				campos="C#rsSubNiveles.NGcodigo#DGid,C#rsSubNiveles.NGcodigo#DGcodigo,C#rsSubNiveles.NGcodigo#DGDescripcion"
				desplegables="N,S,S"
				modificables="N,S,N"
				size="0,10,40"
				title="Lista de #rsNiveles.NGDescripcion#"
				tabla="DistribucionGeografica"
				columnas="DGid as C#rsSubNiveles.NGcodigo#DGid,DGcodigo as C#rsSubNiveles.NGcodigo#DGcodigo,DGDescripcion as C#rsSubNiveles.NGcodigo#DGDescripcion"
				filtro="DGidPadre = $C#Arguments.RefPadre#DGid,numeric$ order by DGcodigo"
				desplegar="C#rsSubNiveles.NGcodigo#DGcodigo,C#rsSubNiveles.NGcodigo#DGDescripcion"
				filtrar_por="DGcodigo,DGDescripcion"
				etiquetas="Código, Descripción"
				formatos="S,S"
				align="left,left"
				asignar="C#rsSubNiveles.NGcodigo#DGid,C#rsSubNiveles.NGcodigo#DGcodigo,C#rsSubNiveles.NGcodigo#DGDescripcion"
				asignarformatos="S,S, S"
				showEmptyListMsg="true"
				EmptyListMsg="-- No se encontraron Países --"
				tabindex="1"
				form="formDir"
				funcion="fnCambiarDistribucion('C#rsSubNiveles.NGcodigo#','#rsSubNiveles.Ppais#')"
				onchange="fnCambiarDistribucion('C#rsSubNiveles.NGcodigo#','#rsSubNiveles.Ppais#')"
				conexion = "asp">
				<input type="hidden" id="C#rsSubNiveles.NGcodigo#Ref" name="C#rsSubNiveles.NGcodigo#Ref" value="C#rsSubNivel.NGcodigo#"/>
				<input type="hidden" id="C#rsSubNiveles.NGcodigo#RefPadre" name="C#rsSubNiveles.NGcodigo#RefPadre" value="C#Arguments.RefPadre#"/>
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
		direccionArray.unshift(new Array('C#rsPadreDist.NGcodigo#','#rsPadreDist.DGid#','#rsPadreDist.DGcodigo#','#rsPadreDist.DGDescripcion#'));
		<cfif len(trim(rsPadreDist.DGidPadre)) gt 0>
			<cfset fnGetPadre(rsPadreDist.Ppais,rsPadreDist.DGidPadre)>
		</cfif>
	</cfloop>
</cffunction>



