
<!-- Establecimiento del modo -->
<cfif isdefined("form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- Consultas --->
<cfif modo neq 'ALTA'>
	<!--- Form --->
	<cfquery name="rsForm" datasource="#session.DSN#">
		select TDid, Usucodigo, ts_rversion
		from RHUsuarioTDeduccion
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
	</cfquery>
</cfif>

<script language="JavaScript1.2" type="text/javascript">
	var popUpWin=0; 
	
	function popUpWindow(URLStr, left, top, width, height)
	{
	  if(popUpWin) {
		if(!popUpWin.closed) popUpWin.close();
	  }
	  popUpWin = open(URLStr, 'popUpWin', 'toolbar=no,location=no,directories=no,status=no,menubar=no,scrollbar=no,resizable=no,copyhistory=yes,width='+width+',height='+height+',left='+left+', top='+top+',screenX='+left+',screenY='+top+'');
	}
	
	function doConlisUsuarios() {
		var w = 650;
		var h = 500;
		var l = (screen.width-w)/2;
		var t = (screen.height-h)/2;
		popUpWindow("ConlisUsuariosTDeduccion.cfm?form=form1&usuario=Usuario&nombre=Nombre&TDid=<cfoutput>#form.TDid#</cfoutput>",l,t,w,h);
	}

</script>


<!--- Javascript --->
<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>


<form name="form1" method="post" action="TipoDeduccionPermiso-SQL.cfm" onSubmit="Javascript: finalizar();">
  <cfoutput>
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><div align="right"><strong><cf_translate  key="LB_Usuario">Usuario</cf_translate>:</strong>&nbsp;</div></td>
      <td>
	  <cfif modo eq 'ALTA'>
		  <input name="Nombre" type="text" value="" tabindex="-1" readonly size="50" maxlength="180">
		  <a href="##"><img src="/cfmx/rh/imagenes/Description.gif" alt="Lista de Usuarios" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisUsuarios();"></a>
		  <input type="hidden" id="Usuario" name="Usuario" value="">
		<cfelse>
			<input type="text"  class="cajasinbordeb" name="Nombrelbl" size="40" maxlength="40" value="<cfoutput>#form.nombre#</cfoutput>">
			<input type="hidden" id="Usuario" name="Usuario" value="<cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo)) neq 0><cfoutput>#form.Usucodigo#</cfoutput></cfif>">
		</cfif>
	  </td>
    </tr>
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">
	<!--- Se pintó los botones a pie porque no tiene sentido que se vea el botón modificar del porlet "/rh/portlets/pBotones.cfm" --->
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
			<cfif not isdefined('modo')>
				<cfset modo = "ALTA">
			</cfif>
			
			<input type="hidden" name="botonSel" value="">
			<input name="txtEnterSI" type="text" size="1" maxlength="1" readonly="true" class="cajasinbordeb">

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
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Eliminar"
			Default="Eliminar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Eliminar"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Nuevo"
			Default="Nuevo"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Nuevo"/>
			
			<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_mensaje"
			Default="¿Está seguro(a) de que desea eliminar el registro?"
			returnvariable="LB_mensaje"/>

			
			<cfif modo EQ "ALTA">
				<input type="submit" name="Alta" value="<cfoutput>#BTN_Agregar#</cfoutput>" onClick="javascript: this.form.botonSel.value = this.name; ">
				<input type="button" name="Limpiar" value="<cfoutput>#BTN_Limpiar#</cfoutput>" onClick="javascript: this.form.botonSel.value = this.name; if (window.limpiar){limpiar()};" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
<!---				<input type="reset" name="Limpiar" value="Limpiar" onClick="javascript: this.form.botonSel.value = this.name">--->
			<cfelse>
				<input type="submit" name="Baja" value="<cfoutput>#BTN_Eliminar#</cfoutput>" onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('<cfoutput>#LB_mensaje#</cfoutput>') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
				<input type="submit" name="Nuevo" value="<cfoutput>#BTN_Nuevo#</cfoutput>" onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
			</cfif>
	</td></tr>
	<tr>
		<td colspan="2" align="center">&nbsp;</td>
	</tr>
	<cfset ts = "">	
	<cfif modo neq "ALTA">
		<cfinvoke 
			component="sif.Componentes.DButils"
			method="toTimeStamp"
			returnvariable="ts">
			<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
		</cfinvoke>
	</cfif>
	<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
  </table>  
  </cfoutput>
  <input type="hidden" id="TDid" name="TDid" value="<cfif isdefined("form.TDid") and len(trim(form.TDid)) neq 0><cfoutput>#form.TDid#</cfoutput></cfif>">
  <input type="hidden" id="TDdescripcion" name="TDdescripcion" value="<cfif isdefined("form.TDdescripcion") and len(trim(form.TDdescripcion)) neq 0><cfoutput>#form.TDdescripcion#</cfoutput></cfif>">
</form>

<script language="JavaScript1.2" type="text/javascript">
	<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_mensaje1"
	Default="Usuario"
	returnvariable="LB_mensaje1"/>
	
	
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("form1");

	function deshabilitarValidacion(){
		objForm.Usuario.required = false;
	}
	
	function habilitarValidacion(){
		objForm.Usuario.required = true;
	}
	
	function finalizar(f){
		objForm.Usuario.obj.disabled = false;
		return true;
	}
	
	function limpiar(){

		objForm.reset();
		}
		
	/*Descriciones*/
	objForm.Usuario.description="<cfoutput>#LB_mensaje1#</cfoutput>";
	
	/*Validaciones en OnBlur*/
	objForm.Usuario.validate = true;
	
	/*Campos Requeridos*/
	habilitarValidacion();
		
	
</script> 
