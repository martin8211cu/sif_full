<!---<cf_dump var ="#form#">--->
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>

<!-- Establecimiento del modo -->

<cfif isdefined("url.alta") and url.alta eq "s">
	<cfset modo="ALTA">
<cfelseif not isdefined("Form.modo")>
		<cfset modo="ALTA">
<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
<cfelse>
		<cfset modo="ALTA">
</cfif>
							
	
<!--- Consultas --->
<cfif modo EQ 'ALTA' and isdefined('form.DEid')>

<cfquery name="rsPersona" datasource="#Session.DSN#">
	<!--- select {fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ', ')}, DEnombre) } as nombreEmpl, DEid
	from EDPersonas
	where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#"> --->
		select {fn concat({fn concat({fn concat({fn concat(a.DEapellido1, ' ')}, a.DEapellido2)}, ', ')}, a.DEnombre) } as nombreEmpl, 
		b.EDPparentesco, b.EDPfamiliar, b.EDPaid, b.ts_rversion, a.DEid
		from EDPersonas a left outer join
		EDParentesco b on
		a.DEid=b.DEid
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
	
</cfquery>

<cfelseif modo NEQ 'ALTA' and isdefined ('form.DEid')>

<cfquery name="rsPersona" datasource="#Session.DSN#">
		select {fn concat({fn concat({fn concat({fn concat(a.DEapellido1, ' ')}, a.DEapellido2)}, ', ')}, a.DEnombre) } as nombreEmpl, 		        b.DEid, b.EDPparentesco, b.EDPfamiliar, b.EDPaid, b.ts_rversion 
		from EDPersonas a inner join
		EDParentesco b on
		a.DEid=b.DEid
		where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
</cfquery>



</cfif>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarElDetalle"
	Default="Desea Eliminar el Detalle"
	returnvariable="MSG_DeseaEliminarElDetalle"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");

	//carga el mantenimiento del detalle
	function fnCargaDetalle(fDEid, EDPaid, EDPparentesco, EDPfamiliar, EDPfamiliares, ts){
		objForm.fDEid.obj.value = fDEid;
		objForm.EDPaid.obj.value = EDPaid;
		objForm.EDPparentesco.obj.selectedIndex = EDPparentesco - (-1);
		objForm.DEnombre.obj.value = EDPfamiliares;
		objForm.DEid.obj.value = EDPfamiliar;
		objForm.dtimestamp.obj.value = ts;
		objForm.Cambio.obj.disabled = false;
		objForm.Alta.obj.disabled = true;
		objForm.modo.obj.value = 'CAMBIO';
	}
	function Borrar(EDPaid){
		if (confirm('¿<cfoutput>#MSG_DeseaEliminarElDetalle#</cfoutput>?')){
			objForm.borrarDetalle.obj.value='TRUE';
			objForm.EDPaid.obj.value= EDPaid;
			deshabilitarValidacion();
			return true;
		}
		 else
			return false;	
	}

	//-->
</script>

<form name="form1" method="post" action="familiares-sql.cfm">
	<cfoutput>
	
	<table width="100%" border="0" cellspacing="0" cellpadding="0">
    	<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
		<td nowrap align="right"><cf_translate key="LB_Persona" XmlFile="/rh/generales.xml">Persona</cf_translate>:&nbsp;</td>
		<td nowrap> <input name="nombreEmpl" type="text" readonly="true" size="40" value="<cfif isdefined('form.DEid')>#rsPersona.nombreEmpl#</cfif>"> </td> 
					
		</tr>
		<tr> 
			<td nowrap align="right"><cf_translate key="LB_Familiar" XmlFile="/rh/generales.xml">Familiar</cf_translate>:&nbsp;</td>
		  <td nowrap><cf_EDpersonas></td>
			</tr>
		<tr> 
			<td nowrap align="right"><cf_translate key="LB_Parentesco" XmlFile="/rh/generales.xml">Parentesco</cf_translate>:&nbsp;</td>
			<td nowrap><select name="EDPparentesco" id="EDPparentesco">
		  			  <option value=""><cf_translate key="LB_Seleccionar">Seleccionar</cf_translate></option>
					  <option value="0" <cfif modo NEQ 'ALTA' and rsPersona.EDPparentesco EQ 0> selected</cfif>><cf_translate key="LB_Hermano">Hermano(a)</cf_translate></option>
					  <option value="1" <cfif modo NEQ 'ALTA' and rsPersona.EDPparentesco EQ 1> selected</cfif>><cf_translate key="LB_Esposo">Esposo(a)</cf_translate></option>
					  <option value="2" <cfif modo NEQ 'ALTA' and rsPersona.EDPparentesco EQ 2> selected</cfif>><cf_translate key="LB_Primo">Primo(a)</cf_translate></option>
					  <option value="3" <cfif modo NEQ 'ALTA' and rsPersona.EDPparentesco EQ 3> selected</cfif>><cf_translate key="LB_Hermanastro">Hermanastro(a)</cf_translate></option>
					  <option value="4" <cfif modo NEQ 'ALTA' and rsPersona.EDPparentesco EQ 4> selected</cfif>><cf_translate key="LB_MedioHermano">Medio Hermano(a)</cf_translate></option>
					  <option value="5" <cfif modo NEQ 'ALTA' and rsPersona.EDPparentesco EQ 5> selected</cfif>><cf_translate key="LB_Tio">Tio(a)</cf_translate></option>
					  <option value="6" <cfif modo NEQ 'ALTA' and rsPersona.EDPparentesco EQ 6> selected</cfif>><cf_translate key="LB_PadreMadre">Padre/Madre</cf_translate></option>
					  <option value="7" <cfif modo NEQ 'ALTA' and rsPersona.EDPparentesco EQ 6> selected</cfif>><cf_translate key="LB_Sobrino">Sobrino</cf_translate></option>
					  <option value="8" <cfif modo NEQ 'ALTA' and rsPersona.EDPparentesco EQ 6> selected</cfif>><cf_translate key="LB_Hijo(a)">Hijo(a)</cf_translate></option>
					</select></td>
		</tr>
		
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr>
			<td nowrap colspan="2" align="center">
				<cfset tabindex="1">
				<cf_templatecss>

<script language="JavaScript" type="text/javascript">
	// Funciones para Manejo de Botones
	botonActual = "";

	function setBtn(obj) {
		botonActual = obj.name;
	}
	function btnSelected(name, f) {
		if (f != null) {
			return (f["botonSel"].value == name)
		} else {
			return (botonActual == name)
		}
	}
</script>

<input type="hidden" name="botonSel" value="" tabindex="-1" >

<input name="txtEnterSI" tabindex="-1" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb"  style="visibility:hidden;">
<cfoutput>

<cfif not isdefined("tabindex")>
	<cfset tabindex="-1">
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Agregar"
	Default="Agregar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Agregar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Limpiar"
	Default="Limpiar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Limpiar"/>
	<input tabindex="#tabindex#" type="submit" name="Alta" value="#BTN_Agregar#" onClick="javascript: this.form.botonSel.value = this.name">
	<input tabindex="#tabindex#" type="reset" name="Limpiar" value="#BTN_Limpiar#" onClick="javascript: this.form.botonSel.value = this.name">

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>

	<input tabindex="#tabindex#" type="submit" name="Cambio" disabled value="#BTN_Modificar#" onClick="javascript: this.form.botonSel.value = this.name;">

</cfoutput></td>
		</tr>
		
<cfif isdefined('form.DEid')>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr align="center"> 
			<td colspan="2" align="center">
				<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
					<tr>
						<td>
							<fieldset><legend><cf_translate key="LB_Familiares">Familiares</cf_translate></legend>
								<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
									<tr bgcolor="FAFAFA"> 
										<td width="10%" nowrap>&nbsp;</td>
										<td width="44%" nowrap><b>
									  <cf_translate key="LB_Familiar" XmlFile="/rh/generales.xml">Familiar</cf_translate></b></td>
										<td width="36%" nowrap><b>
									  <cf_translate key="LB_Parentesco" XmlFile="/rh/generales.xml">Parentesco</cf_translate></b></td>
									<tr> 
									
										<td colspan "3">&nbsp;</td>
									</tr>
									
									<input type="hidden" name="EDPaid" value="<cfif modo EQ 'ALTA' and isdefined('rsPersona.EDPaid')><cfoutput>#rsPersona.EDPaid#</cfoutput></cfif>">
									<input type="hidden" name="EDPfamiliar" value="<cfif modo EQ 'ALTA' and isdefined('rsPersona.EDPfamiliar')><cfoutput>#rsPersona.EDPfamiliar#</cfoutput></cfif>">
									<input type="hidden" name="borrarDetalle" value="">
											<input type="hidden" name="dtimestamp" value="">
								<input name="fDEid" type="hidden" readonly="true" size="40" value="#rsPersona.DEid#">
																				</td>
									</tr>
									
									<cfif isdefined ('rsPersona.EDPaid') and rsPersona.EDPaid GT 0>
									<cfloop query="rsPersona"> 
										<cfset ts = "">
										<cfinvoke
										component="sif.Componentes.DButils"
										method="toTimeStamp"
										returnvariable="ts">
										<cfinvokeargument name="arTimeStamp" value="#ts_rversion#"/>
										</cfinvoke>
									<input type="hidden" name="ts_rversion" value="#ts#">
									<cfquery name="rsLista" datasource="#Session.DSN#">
										select DEid,{fn concat({fn concat({fn concat({fn concat(DEapellido1, ' ')}, DEapellido2)}, ', ')}, 					                                         DEnombre) } as nombreEmpl from EDPersonas
										where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPersona.EDPfamiliar#">									
									</cfquery>
									<cfset EDPfamiliares = rsLista.nombreEmpl>
									<cfquery name ="rsFamiliar" datasource="#Session.DSN#">
										select EDPparentesco
										from EDParentesco
										where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsPersona.DEid#">
										and EDPfamiliar = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsLista.DEid#">
									</cfquery>
									<cfif	rsFamiliar.EDPparentesco EQ 0>	
										<cfset Nombre_Parentesco = "Hermano">
									<cfelseif rsFamiliar.EDPparentesco EQ 1>
										<cfset Nombre_Parentesco = "Esposo(a)" >
									<cfelseif	rsFamiliar.EDPparentesco EQ 2>
										<cfset Nombre_Parentesco = "Primo(a)">
									<cfelseif	rsFamiliar.EDPparentesco EQ 3>
										<cfset Nombre_Parentesco = "Hermanastro(a)">
									<cfelseif	rsFamiliar.EDPparentesco EQ 4>
										<cfset Nombre_Parentesco = "Medio Hermano(a)">
									<cfelseif	rsFamiliar.EDPparentesco EQ 5>	
										<cfset Nombre_Parentesco = "Tio(a)">
									<cfelseif	rsFamiliar.EDPparentesco EQ 6>	
										<cfset Nombre_Parentesco = "Padre/Madre">
									<cfelseif	rsFamiliar.EDPparentesco EQ 7>	
										<cfset Nombre_Parentesco = "Sobrino(a)">
										<cfelseif	rsFamiliar.EDPparentesco EQ 8>	
										<cfset Nombre_Parentesco = "Hijo(a)">
									</cfif>							
										
									<cfset EDPparentesco = "rsFamiliar.EDPparentesco">

									
										<tr> 
											<td nowrap>&nbsp;</td>
											<td nowrap><a href="javascript: fnCargaDetalle('#rsPersona.DEid#', '#EDPaid#', '#EDPparentesco#', '#EDPfamiliar#', '#EDPfamiliares#', '#ts#');">#rsLista.nombreEmpl#</a></td>
											<td nowrap><a href="javascript: fnCargaDetalle('#rsPersona.DEid#', '#EDPaid#', '#EDPparentesco#', '#EDPfamiliar#', '#EDPfamiliares#', '#ts#');">#Nombre_Parentesco#</a></td>
										
											
											<td width="10%" nowrap>	
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_EliminarElemento"
													Default="Eliminar elemento"
													returnvariable="LB_EliminarElemento"/>
												<cfinvoke component="sif.Componentes.Translate"
													method="Translate"
													Key="LB_EditarElemento"
													Default="Editar elemento"
													returnvariable="LB_EditarElemento"/>
												<input  name="btnBorrar#EDPaid#" type="image" alt="#LB_EliminarElemento#" onClick="javascript: return Borrar('#EDPaid#')" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16"> 
										</td>
										</tr>
										</cfloop>
									<cfelse>
									
											<tr>
												<td nowrap colspan="5" align="center" class="fileLabel"><cf_translate key="LB_NoExistenDetalles">No existen detalles</cf_translate></td>
											</tr>
										</cfif>
									</cfif> 
									<tr>
										<td nowrap colspan="5">&nbsp;</td>
									</tr>
								</table>
							</fieldset>						</td>	
					</tr>
				</table>			</td>
		</tr>

<cfif modo NEQ 'ALTA'>
	<cfset ts = "">	
	
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsPersona.ts_rversion#"/>
		</cfinvoke>

	<tr>
		<td>
			<!---<input type="hidden" name="DEid" value="#rsPersona.DEid#">--->		</td>
	</tr>
	</cfif> 
  </table>  
  </cfoutput>
</form>


<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Familiar"
	Default="Familiar"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Familiar"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Parentesco"
	Default="Parentesco"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Parentesco"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Persona"
	Default="Persona"
	XmlFile="/rh/generales.xml"
	returnvariable="MSG_Persona"/>

<script language="JavaScript1.2" type="text/javascript">

	<cfif isdefined('rsPersona.EDPaid')>
		document.form1.DEid.focus();
	<cfelse>
		document.form1.fDEid.focus();
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.DEid.required = true;
		objForm.DEid.description="#MSG_Familiar#";
		objForm.fDEid.required = true;
		objForm.fDEid.description="#MSG_Persona#";
		objForm.EDPparentesco.required = true;
		objForm.EDPparentesco.description="#MSG_Parentesco#";
	</cfoutput>

	function deshabilitarValidacion(){
		objForm.fDEid.required = false;
		objForm.EDPparentesco.required = false;
		objForm.DEnombre.required = false;
	}
	
</script>