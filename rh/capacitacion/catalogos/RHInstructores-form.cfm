<!--- VARIABLES DE TRADUCCION --->

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_RecursosHumanos"
	Default="Recursos Humanos"
	XmlFile="/rh/generales.xml"
	returnvariable="LB_RecursosHumanos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_MantenimientoDeInstructores"
	Default="Mantenimiento de Instructores"
	returnvariable="LB_MantenimientoDeInstructores"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Telefono"
	Default="Tel&eacute;fono"
	returnvariable="LB_Telefono"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Primer_Apellido"
	Default="Primer Apellido"
	returnvariable="LB_Primer_Apellido"/>	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_CorreoElectronico"
	Default="Correo electr&oacute;nico"
	returnvariable="LB_CorreoElectronico"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ApartadoPostal"
	Default="Apartado Postal"
	returnvariable="LB_ApartadoPostal"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Direccion"
	Default="Dirección Física"
	returnvariable="LB_Direccion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_IntructorExterno"
	Default="Instructor Externo"
	returnvariable="LB_IntructorExterno"/>
	
	
<!--- FIN VARIABLES DE TRADUCCION --->
<cfparam name="url.RHIid" default="">
	<cfquery datasource="#session.dsn#" name="data">
		select 
			RHIid,NTIcodigo,
			RHIidentificacion,RHInombre,
			RHIapellido1,RHIapellido2,
			RHItelefono,RHIemail,RHIexterno,
			ts_rversion,RHIapartado,RHIdir
		from  RHInstructores
		where RHIid   =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHIid#" null="#Len(url.RHIid) Is 0#">
		and   Ecodigo =  <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	</cfquery>

<cfoutput>
<cfquery name="rsTipoIdent" datasource="#Session.DSN#">
	select NTIcodigo, NTIdescripcion, NTImascara
	from NTipoIdentificacion
	where Ecodigo = #Session.Ecodigo#
	<cfif data.RecordCount>
		and NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#data.NTIcodigo#"> 
	</cfif>
	order by NTIcodigo
</cfquery>

<form action="RHInstructores-apply.cfm"  method="post" name="form1" id="form1">
<input type="hidden" name="RHIid" value="<cfif data.RecordCount>#HTMLEditFormat(data.RHIid)#</cfif>">
<input type="submit"  value="Aid" name="BorrarDet" id="BorrarDet" style="display:none"/>
<input type="submit"  value="RHCAid" name="BorrarDetArea" id="BorrarDetArea" style="display:none"/>
	<input type="hidden" name="borrarItem" value="">
		<input type="hidden" name="borrarItem2" value="">
<!---<cfif isdefined ('url.RHIid') and len(trim(url.RHIid)) gt 0 and not isdefined('form.RHIid')>
	<input type="hidden" name="RHIid" value="#url.RHIid#" />
</cfif>--->
	<table width="100%" border="0">
		<tr>
			<td width="32%" valign="top" align="right"><strong>
			<cf_translate  key="LB_Tipo">Tipo</cf_translate>
			:</strong></td>
			<td width="68%" valign="top">
					<cfif data.RecordCount>
						#rsTipoIdent.NTIdescripcion#
						<input type="hidden" name="NTIcodigo" value="<cfif data.RecordCount>#HTMLEditFormat(data.NTIcodigo)#</cfif>">
					<cfelse>
						<select name="NTIcodigo" id="select">
							<cfloop query="rsTipoIdent">
								<option value="#rsTipoIdent.NTIcodigo#">#rsTipoIdent.NTIdescripcion#</option>
							</cfloop>
						</select>	
					</cfif>
								
			</td>
		</tr>
		<tr>
			<td width="32%" valign="top" align="right"><strong><cf_translate  key="LB_IIdentifiacion">Identificaci&oacute;n</cf_translate>:</strong></td>
			<td width="68%" valign="top">
					<cfif data.RecordCount>
						#HTMLEditFormat(data.RHIidentificacion)#
						<input name="RHIidentificacion" id="RHIidentificacion" type="hidden" value="#HTMLEditFormat(data.RHIidentificacion)#">
					<cfelse>
						<input name="RHIidentificacion" id="RHIidentificacion" type="text" value="" maxlength="60" size="45" onfocus="this.select()"  >
					</cfif>
			</td>
		</tr>		
		<tr>
			<td valign="top" align="right"><strong><cf_translate  key="LB_Nombre">Nombre</cf_translate>:</strong></td>
			<td valign="top">
              <input name="RHInombre" id="RHInombre" type="text" value="<cfif data.RecordCount>#HTMLEditFormat(data.RHInombre)#</cfif>" maxlength="100" size="45"onFocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong><cf_translate  key="LB_Primer_Apellido">Primer Apellido</cf_translate>:</strong></td>
			<td valign="top">
              <input name="RHIapellido1" id="RHIapellido1" type="text" value="<cfif data.RecordCount>#HTMLEditFormat(data.RHIapellido1)#</cfif>" maxlength="80" size="45"onFocus="this.select()"  >
			</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong><cf_translate  key="LB_Primer_Apellido">Segundo Apellido</cf_translate>:</strong></td>
			<td valign="top">
              <input name="RHIapellido2" id="RHIapellido2" type="text" value="<cfif data.RecordCount>#HTMLEditFormat(data.RHIapellido2)#</cfif>" maxlength="80" size="45"onFocus="this.select()"  >
			</td>
		</tr>
		
		
		<tr>
			<td valign="top" align="right"><strong>#LB_Telefono#:</strong></td>
			<td valign="top">
				<input name="RHItelefono" id="RHItelefono" type="text" value="<cfif data.RecordCount>#HTMLEditFormat(data.RHItelefono)#</cfif>" maxlength="60"  size="45"onfocus="this.select()"  >
			</td>
		</tr>

		<tr>
			<td valign="top" align="right"><strong>#LB_CorreoElectronico#:</strong></td>
			<td valign="top">
				<input name="RHIemail" id="RHIemail" type="text" value="<cfif data.RecordCount>#HTMLEditFormat(data.RHIemail)#</cfif>" maxlength="255"   size="45"onfocus="this.select()">
			</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>#LB_ApartadoPostal#:</strong></td>
			<td valign="top">
				<input name="RHIapartado" id="RHIapartado" type="text" value="<cfif data.RecordCount>#HTMLEditFormat(data.RHIapartado)#</cfif>" maxlength="255"   size="45"onfocus="this.select()">
			</td>
		</tr>
		<tr>
			<td valign="top" align="right"><strong>#LB_Direccion#:</strong></td>
			<td valign="top">
				<input name="RHIdir" id="RHIdir" type="text" value="<cfif data.RecordCount>#HTMLEditFormat(data.RHIdir)#</cfif>" maxlength="255"   size="45"onfocus="this.select()">
			</td>
		</tr>
		<tr>
			<td></td>
			<td colspan="2" valign="top">
				<input name="RHIexterno" tabindex="1" type="checkbox" value="1" <cfif data.RHIexterno EQ 1>checked</cfif>>
				<label for="RHIexterno">#LB_IntructorExterno#</label>
			</td>
		</tr>
		<tr>
		<tr>
			<td colspan="2" class="formButtons">
				<cfif data.RecordCount>
					<cf_botones modo='CAMBIO' include="Servicios,Areas">
				<cfelse>
					<cf_botones modo='ALTA'>
				</cfif>
			</td>
		</tr>
	</cfoutput>
	<cfif isdefined ('url.Serv') and url.Serv eq 1>
		<tr>
			<td nowrap="nowrap" colspan="2">
				<table border="0">
					<tr>
						<td align="right"><strong>Servicios:</strong></td>
						<td>
							<cfquery name="rsServ" datasource="#session.dsn#">
								select RHTSid,RHTScodigo,RHTSdescripcion from RHTiposServ where Ecodigo=#session.Ecodigo#
							</cfquery>
							<select name="RHTSid" id="RHTSid">
									<cfif rsServ.RecordCount>
										<cfoutput query="rsServ">
											<option value="#rsServ.RHTSid#">#rsServ.RHTScodigo#-#rsServ.RHTSdescripcion#</option>									
										</cfoutput>
									</cfif>                       
							</select>		<!--- <cfif modo neq "ALTA" and rsServ.RHTSid  eq rsForm.CCHid> selected="selected" </cfif>--->		
						</td>
						<td>
							<cf_botones names="AgregarDet" values="Agregar">
						</td>
					</tr>
					<tr>
						<cf_dbfunction name="OP_concat" returnvariable="_Cat">
						<cf_dbfunction name="to_char"	args="s.RHTSid"         returnvariable="RHTSid">
						<cfset EL	= '<a href="javascript: borraDet(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
						<cfset EL	= replace(EL,"'","''","ALL")>
						<cfset EL	= replace(EL,"AAAA","' #_Cat# #RHTSid#  #_Cat# '","ALL")>
						<cfquery name="rsServxInst" datasource="#session.dsn#">
							select '#PreserveSingleQuotes(EL)#' as eli,s.RHTSid,si.RHIid,s.RHTScodigo,s.RHTSdescripcion
								from RHTiposServxInst si
									inner join RHTiposServ s
									on s.RHTSid=si.RHTSid
									and s.Ecodigo=si.Ecodigo
							where RHIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHIid#" null="#Len(url.RHIid) Is 0#">
						</cfquery>
						<cfoutput>
						<cfif rsServxInst.RecordCount NEQ 0>
									<cfloop query="rsServxInst">
										<tr <cfif rsServxInst.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td width="40%">#rsServxInst.RHTScodigo#</td>
											<td width="10%">#rsServxInst.RHTSdescripcion#</td>
											<td width="5%" style="cursor:pointer;" align="right">
												<img src="/cfmx/rh/imagenes/Borrar01_S.gif" onClick="javascript: funcBorrarItem2('#rsServxInst.RHTSid#');" >
											</td>
											
										</tr>
									</cfloop>
								<cfelse>
									<tr><td colspan="4" align="center">----- <b>No se encontraron registros</b> -----</td></tr>
								</cfif>
						</cfoutput>
					<!---	<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#rsServxInst#"
						desplegar="RHTScodigo,RHTSdescripcion,eli"
						etiquetas="Código, Descripción,Eliminar"
						formatos="S,S,S"
						align="left,left,left"
						ira="RHInstructores.cfm"
						form_method="get"
						keys="RHTSid"
						filtrar_automatico="true"
						mostrar_filtro="false"	
						MaxRows="10"
						/>--->		
					</tr>
				</table>
			</td>
		</tr>
	</cfif>
		<cfif isdefined ('url.Areas') and url.Areas eq 1>
		<tr>
			<td nowrap="nowrap" colspan="2">
				<table border="0">
					<tr>
						<td align="right"><strong>&Aacute;reas:</strong></td>
						<td>
							<cfquery name="rsArea" datasource="#session.dsn#">
								select RHACid,RHACcodigo,RHACdescripcion from RHAreasCapacitacion where Ecodigo=#session.Ecodigo#
							</cfquery>
							<select name="RHACid" id="RHACid">
									<cfif rsArea.RecordCount>
										<cfoutput query="rsArea">
											<option value="#rsArea.RHACid#">#rsArea.RHACcodigo#-#rsArea.RHACdescripcion#</option>									
										</cfoutput>
									</cfif>                       
							</select>		<!--- <cfif modo neq "ALTA" and rsServ.RHTSid  eq rsForm.CCHid> selected="selected" </cfif>--->		
						</td>
						<td>
							<cf_botones names="AgregarDetArea" values="Agregar">
						</td>
					</tr>
					
					<tr>
						<cf_dbfunction name="OP_concat" returnvariable="_Cat">
						<cf_dbfunction name="to_char"	args="s.RHACid"         returnvariable="RHACid">
						<cfset EL	= '<a href="javascript: borraDetArea(AAAA);"><img border="0" src="/cfmx/sif/imagenes/Borrar01_S.gif"></a>'>
						<cfset EL	= replace(EL,"'","''","ALL")>
						<cfset EL	= replace(EL,"AAAA","' #_Cat# #RHACid#  #_Cat# '","ALL")>
						<cfquery name="rsServxInst" datasource="#session.dsn#">
							select '#PreserveSingleQuotes(EL)#' as eli,s.RHACid,si.RHIid,s.RHACcodigo,s.RHACdescripcion
								from RHAreasxInst si
									inner join RHAreasCapacitacion s
									on s.RHACid=si.RHACid
									and s.Ecodigo=si.Ecodigo
							where RHIid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RHIid#" null="#Len(url.RHIid) Is 0#">
						</cfquery>
						<cfoutput>
						<cfif rsServxInst.RecordCount NEQ 0>
									<cfloop query="rsServxInst">
										<tr <cfif rsServxInst.CurrentRow MOD 2>class="listaNon"<cfelse>class="listaPar"</cfif>>
											<td width="40%">#rsServxInst.RHACcodigo#</td>
											<td width="10%">#rsServxInst.RHACdescripcion#</td>
											<td width="5%" style="cursor:pointer;" align="right">
												<img src="/cfmx/rh/imagenes/Borrar01_S.gif" onClick="javascript: funcBorrarItem('#rsServxInst.RHACid#');" >
											</td>
											
										</tr>
									</cfloop>
								<cfelse>
									<tr><td colspan="4" align="center">----- <b>No se encontraron registros</b> -----</td></tr>
								</cfif>
						</cfoutput>
				<!---		<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
						query="#rsServxInst#"
						desplegar="RHACcodigo,RHACdescripcion,eli"
						etiquetas="Código, Descripción,Eliminar"
						formatos="S,S,S"
						align="left,left,left"
						ira="RHInstructores.cfm"
						form_method="get"
						keys="RHACid"
						filtrar_automatico="true"
						mostrar_filtro="false"	
						MaxRows="10"
						index="2"
						/>		--->
					</tr>
				</table>
			</td>
		</tr>
	</cfif>
	<cfoutput>
	</table>
	<cfset ts = "">
		<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp"
			artimestamp="#data.ts_rversion#" returnvariable="ts">
		</cfinvoke>
	<input type="hidden" name="ts_rversion" value="#ts#">
</form>
<cf_qforms>
<script type="text/javascript">
	objForm.NTIcodigo.required = true;
	objForm.NTIcodigo.description="#LB_Identificacion#";			
		
	objForm.RHIidentificacion.required= true;
	objForm.RHIidentificacion.description="#LB_Identificacion#";	

	objForm.RHInombre.required= true;
	objForm.RHInombre.description="#LB_Nombre#";	
	
	objForm.RHIapellido1.required= true;
	objForm.RHIapellido1.description="#LB_Primer_Apellido#";	
	
	function habilitarValidacion(){
		objForm.NTIcodigo.required = true;
		objForm.RHIidentificacion.required= true;
		objForm.RHInombre.required = true;
		objForm.RHIapellido1.required= true;
		
	}
	
	function deshabilitarValidacion(){
		objForm.NTIcodigo.required = false;
		objForm.RHIidentificacion.required= false;
		objForm.RHInombre.required = false;
		objForm.RHIapellido1.required= false;

	}	
	
	function Valida(){
		return confirm('¿Está seguro(a) de que desea eliminar el registro?')
	}
	

	function funcBorrarm(RHTSid){		
		if (Valida()){
			document.form1.borrarItem.value = RHTSid;
			document.form1.BorrarDet.click();
		}			
	}
	
		function funcBorrarItem2(RHACid){	
			if(confirm('¿Está seguro(a) de que desea eliminar el registro?')){
			document.form1.borrarItem2.value = RHACid;
			document.form1.submit();
		}	
		}
	
	function funcBorrarItem(RHACid){	
	if(confirm('¿Está seguro(a) de que desea eliminar el registro?')){
			document.form1.borrarItem.value = RHACid;
			document.form1.submit();
		}	
		}
		<!---if (Valida()){alert(RHACid);
			document.form1.BorrarDetArea.value = RHACid;
			document.form1.submit();
			alert('click');
		}			
	}--->
	
</script>

</cfoutput>


