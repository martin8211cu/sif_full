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
		select UCCid ,Cconcepto,Usucodigo,UCCpermiso,ts_rversion
		from UsuarioConceptoContableE 
		where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		  and Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Usucodigo#">
		  and Cconcepto = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cconcepto#">
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
		popUpWindow("ConlisUsuariosCCPermisos.cfm?form=form1&usuario=Usuario&nombre=Nombre&Cconcepto=<cfoutput>#form.Cconcepto#</cfoutput>",l,t,w,h);
	}
</script>

<!--- Javascript --->
<SCRIPT src="/cfmx/sif/js/qForms/qforms.js"></SCRIPT>
<script language="JavaScript1.2" type="text/javascript">
	<!--//
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("/cfmx/sif/js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
	//-->
</script>
<cfset ts = "">	
<cfif modo neq "ALTA">
	<cfinvoke component="sif.Componentes.DButils" method="toTimeStamp" returnvariable="ts">
		<cfinvokeargument name="arTimeStamp" value="#rsForm.ts_rversion#"/>
	</cfinvoke>
	<cfset form.UCCid = rsForm.UCCid>
	<cfif ListFind("1,3,5,7,9,11,13,15",rsForm.UCCpermiso)>
		<cfset PERMISO1 = true>
	</cfif>
	<cfif ListFind("2,3,6,7,10,11,14,15",rsForm.UCCpermiso)>
		<cfset PERMISO2 = true>
	</cfif>		
	<cfif ListFind("4,5,6,7,12,13,14,15",rsForm.UCCpermiso)>
		<cfset PERMISO3 = true>
	</cfif>	
	<cfif listfind("8,9,10,11,12,13,14,15",rsForm.UCCpermiso)>
		<cfset PERMISO4 = true>
	</cfif>		
	
</cfif>  
<!---
NUNCA REALIZAR ESTA CLASE DE PROGAMACION, COLOCAR EN SU LUGAR 4 BIT EN BASE DE DATOS.

Visualizar Imprimir (1,3,5,7,9,11,13,15)
Agregar y modificar (2,3,6,7,10,11,14,15)
Aplicar 			(4,5,6,7,12,13,14,15)
Borrar 				(8,9,10,11,12,13,14,15)

(1)-          "Visualizar Imprimir"
(2)-          "Agregar y modificar"
(3)-(1+2)     "Visualizar Imprimir" y "Agregar y modificar"
(4)-          "Aplicar"
(5)-(1+4)     "Visualizar Imprimir" y "Aplicar"
(6)-(2+4)     "Agregar y modificar" y "Aplicar"
(7)-(1-2+4)   "Visualizar Imprimir" y "Agregar y modificar" y "Aplicar"
(8)			  "Borrar"
(9)- (1+8)    "Visualizar Imprimir" y "Borrar"
(10)-(2+8)    "Agregar y modificar" y "Borrar"
(11)-(1+2+8)  "Visualizar Imprimir" y "Agregar y modificar" y "Borrar"
(12)-(4+8)    "Aplicar" y "Borrar"
(13)-(1+4+8)  "Visualizar Imprimir" y "Aplicar" y "Borrar"
(14)-(2+4+8)  "Agregar y modificar" + "Aplicar" + "Borrar"
(15)-(1+2+4+8)"Visualizar Imprimir" y "Agregar y modificar" y "Aplicar" y "Borrar"

--->
<form name="form1" method="post" action="ConceptoContablePermiso-SQL.cfm" onSubmit="Javascript: finalizar();">
  <cfoutput>
	
  <table width="100%" border="0" cellspacing="0" cellpadding="0">
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
    </tr>
    <tr> 
      <td><div align="right">&nbsp;<strong>Usuario:</strong>&nbsp;</div></td>
      <td>
	  <cfif modo eq 'ALTA'>
		  <input name="Nombre" type="text" value="" tabindex="-1" readonly size="50" maxlength="180">
		  <a href="##"><img src="/cfmx/sif/imagenes/Description.gif" alt="Lista de Usuarios" name="imagen" width="18" height="14" border="0" align="absmiddle" onClick="javascript:doConlisUsuarios();"></a>
		  <input type="hidden" id="Usuario" name="Usuario" value="">
		<cfelse>
			<input type="text"  class="cajasinbordeb" name="Nombrelbl" size="40" maxlength="40" value="<cfoutput>#form.nombre#</cfoutput>">
			<input type="hidden" id="Usuario" name="Usuario" value="<cfif isdefined("form.Usucodigo") and len(trim(form.Usucodigo)) neq 0><cfoutput>#form.Usucodigo#</cfoutput></cfif>">
		</cfif>
	  </td>
    </tr>
	<tr> 
      <td><div align="right">&nbsp;<strong>Permisos:</strong>&nbsp;</div></td>
      <td>
			<input type="checkbox"  <cfif isdefined("PERMISO1")>checked</cfif> name="PERMISO1" value="1">&nbsp;Visualizar/Imprimir
	  </td>
    </tr>
	<tr> 
      <td>&nbsp;</td>
      <td>
			<input type="checkbox" <cfif isdefined("PERMISO2")>checked</cfif> name="PERMISO2" value="2">&nbsp;Agregar y Modificar
	  </td>
    </tr>	
	<tr> 
      <td>&nbsp;</td>
      <td>
			<input type="checkbox" <cfif isdefined("PERMISO3")>checked</cfif> name="PERMISO3" value="4">&nbsp;Aplicar
	  </td>
    </tr>
	<tr> 
      <td>&nbsp;</td>
      <td>
			<input type="checkbox" <cfif isdefined("PERMISO4")>checked</cfif> name="PERMISO4" value="8">&nbsp;Borrar
	  </td>
    </tr>	
	<tr><td colspan="2">&nbsp;</td></tr>
	<tr><td colspan="2" align="center">
	<!--- Se pintó los botones a pie porque no tiene sentido que se vea el botón modificar del porlet "/sif/portlets/pBotones.cfm" --->
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
				function Atras() {
					location.href =  "ConceptoContableE.cfm?Cconcepto=#Form.Cconcepto#&modo=cambio";
				}
			</script>
			<cfif not isdefined('modo')>
				<cfset modo = "ALTA">
			</cfif>
			<input name="botonSel"	 type="hidden" value="">
			<input name="txtEnterSI" type="text" 	size="1" maxlength="1" readonly="true" class="cajasinbordeb">
			<input name="Regresar"	 type="button"  value="Regresar" 	class="btnAnterior" onClick="javascript: Atras();">
			<cfif modo EQ "ALTA">
				<input type="submit" name="Alta" 	value="Agregar"	 	class="btnGuardar" onClick="javascript: this.form.botonSel.value = this.name; ">
				<input type="button" name="Limpiar" value="Limpiar" 	class="btnLimpiar" onClick="javascript: this.form.botonSel.value = this.name; if (window.limpiar){limpiar()};" <cfif isDefined("Botones.TabIndex")>tabindex="<cfoutput>#Botones.TabIndex#</cfoutput>"</cfif>>
			<cfelse>
				<input type="submit" name="Cambio" 	value="Cambio" 		class="btnGuardar"	onClick="javascript: this.form.botonSel.value = this.name; ">
				<input type="submit" name="Baja" 	value="Eliminar" 	class="btnEliminar"	onclick="javascript: this.form.botonSel.value = this.name; if ( confirm('¿Está seguro(a) de que desea eliminar el registro?') ){ if (window.deshabilitarValidacion) deshabilitarValidacion(); return true; }else{ return false;}">
				<input type="submit" name="Nuevo" 	value="Nuevo" 		class="btnNuevo"	onClick="javascript: this.form.botonSel.value = this.name; if (window.deshabilitarValidacion) deshabilitarValidacion(); ">
			</cfif>
	</td></tr>
	<tr>
		<td colspan="2" align="center">&nbsp;</td>
	</tr>

	<tr><td><input type="hidden" name="ts_rversion" value="<cfif modo NEQ 'ALTA'><cfoutput>#ts#</cfoutput></cfif>"></td></tr>
  </table>  
  </cfoutput>
  <input type="hidden" id="UCCid" name="UCCid" value="<cfif isdefined("form.UCCid") and len(trim(form.UCCid)) neq 0><cfoutput>#form.UCCid#</cfoutput></cfif>">
  <input type="hidden" id="Cconcepto" name="Cconcepto" value="<cfif isdefined("form.Cconcepto") and len(trim(form.Cconcepto)) neq 0><cfoutput>#form.Cconcepto#</cfoutput></cfif>">
  <input type="hidden" id="Cdescripcion" name="Cdescripcion" value="<cfif isdefined("form.Cdescripcion") and len(trim(form.Cdescripcion)) neq 0><cfoutput>#form.Cdescripcion#</cfoutput></cfif>">
</form>

<script language="JavaScript1.2" type="text/javascript">

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
	objForm.Usuario.description="Usuario";
	
	/*Validaciones en OnBlur*/
	objForm.Usuario.validate = true;
	
	/*Campos Requeridos*/
	habilitarValidacion();
</script> 