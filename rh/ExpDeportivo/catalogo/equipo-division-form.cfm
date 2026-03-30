<!-- Establecimiento del modo -->

<cfif isdefined("form.EDid")>
	<cfset modo="ALTA">
<cfelseif not isdefined("Form.modo")>
		<cfset modo="ALTA">
<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
<cfelse>
		<cfset modo="ALTA">
</cfif>

<!--- <cfif isdefined("form.modo") and form.modo eq "CAMBIO">
	<cfset modo="CAMBIO">
</cfif> --->
<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="CMB_Seleccionar"
Default="Seleccionar"
XmlFile="/rh/ExpDeportivo/generales.xml"
returnvariable="CMB_Seleccionar"/>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_DeseaEliminarElDetalle"
	Default="Desea Eliminar el Detalle"
	returnvariable="MSG_DeseaEliminarElDetalle"/>
<!--- Consultas --->

	<!--- Form --->
<cfif isdefined('form.EDid')>
	<cfquery name="rsForm" datasource="#Session.DSN#">
				select Edescripcion
				from Equipo
				where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDid#">
	</cfquery>
	<cfquery name="rsLista" datasource="#session.DSN#">
				select a.EDid, a.EDvid, a.TEid, a.ts_rversion, b.TEdescripcion, b.TEcodigo, c.EDid
				from EquipoDivision a 
				inner join DivisionEquipo b on
				a.TEid = b.TEid
				inner join Equipo c on 
				a.EDid=c.EDid
				where a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.EDid#">									
	</cfquery>
</cfif>		
						

<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	function validar(f){
		f.obj.TEid.disabled = false;
		f.obj.EDid.disabled = false;
		return true;
	}

	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
		//carga el mantenimiento del detalle
	function fnCargaDetalle(EDid, EDvid, TEid, ts){
		objForm.TEid.obj.value = TEid;
		objForm.Cambio.obj.disabled = false;
		objForm.Alta.obj.disabled = true;
		objForm.modo.obj.value = 'CAMBIO';
	}
	function Borrar(EDvid, TEid){
		if (confirm('¿<cfoutput>#MSG_DeseaEliminarElDetalle#</cfoutput>?')){
			objForm.borrarDetalle.obj.value='TRUE';
			objForm.TEid.obj.value = TEid;			
			objForm.EDvid.obj.value= EDvid;
			deshabilitarValidacion();
			return true;
		}
		 else
			return false;	
	}

</script>

<form name="form1" method="post" action="equipo-division-sql.cfm" onSubmit="return validar(this);"><!---  --->

  <cfoutput> 
	  <table width="100%" border="0" cellspacing="0" cellpadding="0">
		<tr><td colspan="2">&nbsp;</td></tr> 
		<tr> 
		  <td align="right"><cf_translate key="LB_Equipo" XmlFile="/rh/ExpDeportivo/generales.xml">Equipo</cf_translate>:&nbsp;</td>
		  <td>
<input type="text" name="Edescripcion" id="Edescripcion" tabindex="1" value="<cfif isdefined('form.EDid')>#rsForm.Edescripcion#</cfif>" maxlength="80" size="40" readonly='true'	onFocus="javascript:this.select();"> 
<input type="hidden" name="EDid" id="EDid" value="<cfif isdefined('form.EDid')>#form.EDid#</cfif>"> 
		  </td>
		</tr>
		  <td align="right" nowrap><cf_translate key="LB_Division" XmlFile="/rh/ExpDeportivo/generales.xml">Divisi&oacute;n</cf_translate>:&nbsp;</td>
		  <td><cf_division></td>
		</tr>
		<tr><td>&nbsp;</td></tr>
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

<!---	<cfif not isdefined("request.pBotones.NoCambio")>--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Modificar"
	Default="Modificar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Modificar"/>

	<input tabindex="#tabindex#" type="submit" name="Cambio" disabled value="#BTN_Modificar#" onClick="javascript: this.form.botonSel.value = this.name"/>
</cfoutput></td>
		</tr>
	
		<cfset ts = "">	
		<cfif modo neq "ALTA">
			<cfinvoke 
				component="sif.Componentes.DButils"
				method="toTimeStamp"
				returnvariable="ts">
				<cfinvokeargument name="arTimeStamp" value="#rsLista.ts_rversion#"/>
			</cfinvoke>
		</cfif>
	   <input type="hidden" name="EDvid" value="<cfif isdefined('rsLista.EDvid')>#rsLista.EDvid#</cfif>">
	 	<cfif isdefined("url.popup") and url.popup eq "s">
		<input type="hidden" name="popup" value="s">
		</cfif>
  </cfoutput>

<cfif isdefined('form.EDid')>
<cfoutput>
		<tr><td colspan="2">&nbsp;</td></tr>
		<tr align="center"> 
			<td colspan="2" align="center">
				<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
					<tr>
						<td>
							<fieldset><legend><cf_translate key="LB_Valores">Divisiones</cf_translate></legend>
								<table width="95%" border="0" cellspacing="0" cellpadding="0"align="center">
									<tr bgcolor="FAFAFA"> 
										<td width="1%" nowrap>&nbsp;</td>
										<td  nowrap><b>
									  <cf_translate key="LB_Codigo" XmlFile="/rh/generales.xml">C&oacute;digo</cf_translate></b></td>
										<td nowrap><b>
									  <cf_translate key="LB_Division" XmlFile="/rh/generales.xml">Divisi&oacute;n</cf_translate></b></td>
								  </tr>
								  <input type="hidden" name="borrarDetalle" value="">
								<tr> <td>&nbsp;</td></tr>													
									<cfif isdefined('rsLista.EDvid') and rsLista.EDvid GT 0>
									<cfloop query="rsLista"> 
										<cfset ts = "">
										<cfinvoke
										component="sif.Componentes.DButils"
										method="toTimeStamp"
										returnvariable="ts">
										<cfinvokeargument name="arTimeStamp" value="#ts_rversion#"/>
										</cfinvoke>
									
										<tr>
										
										<input type="hidden" name="ts_rversion" value="#ts#">
										<input type="hidden" name="TEcodigo" value="#rsLista.TEcodigo#">
										<input type="hidden" name="TEdescripcion" value="#rsLista.TEdescripcion#">
										


										
											<td nowrap>&nbsp;</td>
											<td nowrap><a href="javascript: fnCargaDetalle('#EDid#', '#EDvid#', '#TEid#', '#ts#');">#TEcodigo#</a></td>
											<td nowrap><a href="javascript: fnCargaDetalle('#EDid#', '#EDvid#', '#TEid#', '#ts#');">#TEdescripcion#</a></td>
											<td width="7%" nowrap>	
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
												<input  name="btnBorrar#EDvid#" type="image" alt="#LB_EliminarElemento#" onClick="javascript: return Borrar('#EDvid#', '#TEid#')" src="/cfmx/rh/imagenes/Borrar01_T.gif" width="16" height="16"></td>
										</tr>
									</cfloop>
								<cfelse>
									
											<tr>
												<td nowrap colspan="5" align="center" class="fileLabel"><cf_translate key="LB_NoExistenDivisiones">No existen divisiones</cf_translate></td>
											</tr>
										
										</cfif>
									 </cfoutput>
									<tr>
										<td nowrap colspan="5">&nbsp;</td>
									</tr>
								</table>
							</fieldset>							</td>	
					</tr>
				</table>			</td>
		</tr></table>  
	</cfif>
	<cfif modo NEQ 'ALTA'>
	<cfset ts = "">	
	
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsLista.ts_rversion#"/>
		</cfinvoke>

	</cfif>
  </table>  
 
</form>



<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Equipo"
	Default="Equipo"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_Equipo"/>
	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="MSG_Division"
	Default="División"
	XmlFile="/rh/ExpDeportivo/generales.xml"
	returnvariable="MSG_Division"/>

<script language="JavaScript1.2" type="text/javascript">
	<cfif modo NEQ 'ALTA'>
		document.form1.Edescripcion.focus();
	<cfelse>
		document.form1.TEid.focus();
	</cfif>

	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");
	<cfoutput>
		objForm.TEid.required = true;
		objForm.TEid.description="#MSG_Division#";
		objForm.Edescripcion.required = true;
		objForm.Edescripcion.description="#MSG_Equipo#";
	</cfoutput>

	function deshabilitarValidacion(){
		objForm.TEid.required = false;
		objForm.Edescripcion.required = false;
	}

</script>
