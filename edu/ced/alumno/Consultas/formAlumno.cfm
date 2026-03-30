<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfparam name="Form.persona" default="#Url.persona#">
</cfif> 

<cfif isdefined("form.persona")>
	<cfparam name="Form.persona" default="#form.persona#">
</cfif> 

<cfif isdefined("Url.modo") and not isdefined("Form.modo")>
	<cfparam name="Form.modo" default="#Url.modo#">
</cfif>			

<cfif isdefined("Form.Cambio")>
	<cfset modo="CAMBIO">
<cfelse>
	<cfif not isdefined("Form.modo")>
		<cfset modo="ALTA">
	<cfelseif Form.modo EQ "CAMBIO">
		<cfset modo="CAMBIO">
	<cfelse>
		<cfset modo="ALTA">
	</cfif>
</cfif>

<!--- 1. Form  --->
<cfif modo EQ "CAMBIO" >
	<cfquery datasource="#Session.Edu.DSN#" name="rsForm">
		Select convert(varchar,a.persona) as persona, 
		       convert(varchar,a.CEcodigo) as CEcodigo, 
			   a.Pnombre, Papellido1, Papellido2, a.Ppais, 
			   b.Pnombre, a.TIcodigo, TInombre, Pid, 
			   convert(varchar,Pnacimiento,103) Pnacimiento, Psexo, 
			   Pemail1, Pemail2, Pdireccion, Pcasa, 
			   Pfoto, PfotoType, PfotoName, Pemail1validado, 
			   convert(varchar,d.PRcodigo) as PRcodigo, Aretirado,
			   isnull(Gdescripcion,'sin grado asociado') as Gdescripcion,
			   e.autorizado
		from PersonaEducativo a, Pais b, TipoIdentificacion c, Alumnos d, Estudiante e, Promocion f, Grado g
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.CEcodigo=d.CEcodigo
			and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			and a.Ppais=b.Ppais
			and a.TIcodigo=c.TIcodigo
			and a.persona=d.persona
			and d.Ecodigo=e.Ecodigo
			and d.PRcodigo=f.PRcodigo
			and f.Gcodigo=g.Gcodigo		
	</cfquery>
	
	<!--- Para cargar en memoria el codigo del estudiante "Ecodigo" por si se retira o no --->
	<cfquery datasource="#Session.Edu.DSN#" name="rsform_Ecodigo">
		Select convert(varchar,a.Ecodigo) as Ecodigo
		from Alumnos a, Estudiante b
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
			and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#persona#">
			and a.persona=b.persona
			and a.Ecodigo=b.Ecodigo
	</cfquery>	
</cfif>

<!--- Para el combo de tipos de Identificacion  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsTipoIdentif">
	select TIcodigo,TInombre from TipoIdentificacion
</cfquery>

<!---  Para el combo de paises  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsPaises">
	select Ppais,Pnombre from Pais 
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsPromo">
	select convert(varchar,PRcodigo) as PRcodigo,(PRdescripcion + ': ' + Gdescripcion) as PRdescripcion 
	from Nivel b, Grado c, Promocion  a
	where b.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and a.PRactivo=1
		and b.Ncodigo=c.Ncodigo
		and a.Gcodigo=c.Gcodigo
		and a.Ncodigo=c.Ncodigo
		and a.Gcodigo=c.Gcodigo
	order by b.Norden,c.Gorden,a.PRcodigo
</cfquery>

<script type="text/javascript">
function Retirar() {
	 var msg = "Al retirar el alumno, que no tenga mas hermanos, tanto él como sus encargados, se les revoca el acceso al expediente estudiantil."+
		" Para rectivar nuevamente los usuarios, será necesario seguir el proceso de activar Alumnos Retirados. Desea retirarlo?"
	
	if (formAlumno.Aretirado.checked == true) {	 
		if (confirm(msg)) {
			formAlumno.Aretirado.checked = true;
		} else {
			 formAlumno.Aretirado.checked = false;
		}
	}
}

</script>
<!--- ------------------------------------------------------------------------------- --->
<link href="../../../css/edu.css" rel="stylesheet" type="text/css">
		<h2 class="tab">Alumno</h2>
		<form action="SQLAlumno.cfm" method="post" enctype="multipart/form-data" id="formAlumno" name="formAlumno">
		   <input name="persona" id="persona" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.persona#</cfoutput></cfif>" type="hidden"> 
		   
		   <input name="MODO" id="MODO" value="<cfoutput>#modo#</cfoutput>" type="hidden">
   		   <input name="form_Ecodigo" id="form_Ecodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsform_Ecodigo.Ecodigo#</cfoutput></cfif>" type="hidden">
		   <!--- Campos del filtro para la lista de alumnos --->
			  <cfif isdefined("Form.fRHnombre")>
				 <input type="hidden" name="fRHnombre" value="<cfoutput>#Form.fRHnombre#</cfoutput>">
			  </cfif>		   
			  <cfif isdefined("Form.FNcodigo")>
				 <input type="hidden" name="FNcodigo" value="<cfoutput>#Form.FNcodigo#</cfoutput>">
			  </cfif>		
			  <cfif isdefined("Form.filtroRhPid")>
				 <input type="hidden" name="filtroRhPid" value="<cfoutput>#Form.filtroRhPid#</cfoutput>">
			  </cfif>		
			  <cfif isdefined("Form.FGcodigo")>
				 <input type="hidden" name="FGcodigo" value="<cfoutput>#Form.FGcodigo#</cfoutput>">
			  </cfif>
			  <cfif isdefined("Form.NoMatr")>
				 <input type="hidden" name="NoMatr" value="<cfoutput>#Form.NoMatr#</cfoutput>">
			  </cfif>		  		  
			  <cfif isdefined("Form.FAretirado")>
				 <input type="hidden" name="FAretirado" value="<cfoutput>#Form.FAretirado#</cfoutput>">
			  </cfif>
      <table width="100%" border="0" cellpadding="0" cellspacing="0">
        <cfif modo EQ 'CAMBIO'>
          <tr> 
            <td colspan="5" class="tituloAlterno"> 
              Modificaci&oacute;n de Alumno </td>
          </tr>
          <tr> 
            <td colspan="5" class="tituloAlterno"> 
              Grado: <cfoutput>#rsForm.Gdescripcion#</cfoutput> </td>
          </tr>
          <cfelse>
          <tr> 
            <td colspan="5" class="tituloAlterno"> 
              Ingreso de Alumno </td>
          </tr>
        </cfif>
        <tr> 
          <td width="25%" rowspan="6" valign="middle" align="center"> <table width="108" height="159" border="1">
              <tr> 
                <td width="102" align="center" valign="middle"> <cfif modo NEQ 'ALTA'>
                    <cfif Len(rsForm.Pfoto) EQ 0>
                      Fotograf&iacute;a no disponible 
                      <cfelse>
                      <!--- <img src="/Upload/DownloadServlet/PersonaEducacionFoto?persona=<cfoutput>#rsForm.persona#</cfoutput>" alt='<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pnombre#  #rsForm.Papellido1#  #rsForm.Papellido2#</cfoutput></cfif>' align="middle" width="109" height="154" border="0">	 --->
					  <cf_Educleerimagen Tabla="PersonaEducativo" ruta="/cfmx/edu/Utiles/sifleerimagencont.cfm" Campo="Pfoto" Condicion="persona=#rsForm.persona#" Conexion="#Session.Edu.DSN#" autosize="false" width="109" height="154"> 
                    </cfif>
                    <cfelse>
                    Fotograf&iacute;a </cfif> 
				</td>
              </tr>
            </table></td>
          <td width="16%" class="subTitulo">Nombre*</td>
          <td width="20%" class="subTitulo">Primer Apellido *</td>
          <td width="29%" class="subTitulo">Segundo Apellido*</td>
          <td width="10%" class="subTitulo" align="center">Retirado</td>
        </tr>
        <tr> 
          <td><input name="Pnombre" type="text" id="Pnombre" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pnombre#</cfoutput></cfif>"></td>
          <td><input name="Papellido1" type="text" id="Papellido1" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Papellido1#</cfoutput></cfif>"></td>
          <td><input name="Papellido2" type="text" id="Papellido2" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Papellido2#</cfoutput></cfif>"></td>
          <td align="center"><input name="Aretirado" type="checkbox" id="Aretirado"  onClick="javascript: Retirar();" value="Aretirado" <cfif modo NEQ 'ALTA' and #rsForm.Aretirado# EQ '1'>checked</cfif>></td>
        </tr>
        <tr> 
          <td class="subTitulo">Identificaci&oacute;n*</td>
          <td class="subTitulo">Tipo Identificaci&oacute;n</td>
          <td class="subTitulo">Sexo</td>
          <td align="center" class="subTitulo">Autorizado</td>
        </tr>
        <tr> 
          <td><input name="Pid" type="text" id="Pid" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pid#</cfoutput></cfif>"></td>
          <td><select name="TIcodigo" id="TIcodigo">
              <cfoutput query="rsTipoIdentif"> 
                <cfif modo EQ 'CAMBIO' and #rsForm.TIcodigo# EQ #rsTipoIdentif.TIcodigo#>
                  <option value="#rsTipoIdentif.TIcodigo#" selected>#rsTipoIdentif.TInombre#</option>
                  <cfelse>
                  <option value="#rsTipoIdentif.TIcodigo#">#rsTipoIdentif.TInombre#</option>
                </cfif>
              </cfoutput> </select> </td>
          <td><select name="Psexo" id="Psexo">
              <cfif modo EQ 'CAMBIO' and #rsForm.Psexo# EQ 'M'>
                <option value="M" selected>Masculino</option>
                <cfelse>
                <option value="M">Masculino</option>
              </cfif>
              <cfif modo EQ 'CAMBIO' and #rsForm.Psexo# EQ 'F'>
                <option value="F" selected>Femenino</option>
                <cfelse>
                <option value="F">Femenino</option>
              </cfif>
            </select></td>
          <td align="center"><input name="autorizado" type="checkbox" id="autorizado" value="1" <cfif modo NEQ 'ALTA' and rsForm.autorizado EQ '1'>checked<cfelseif modo EQ 'ALTA'>checked</cfif>></td>
        </tr>
        <tr> 
          <td class="subTitulo"><font size="1">Fecha de Nacimiento</font></td>
          <td colspan="3" class="subTitulo">Direcci&oacute;n*</td>
        </tr>
        <tr> 
          <td> <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
            <input name="Pnacimiento" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif isdefined("form.Pnacimiento")><cfoutput>#rsForm.Pnacimiento#</cfoutput><cfelse><cfoutput>#DateFormat(Now(),'DD/MM/YYYY')#</cfoutput></cfif>" size="12" maxlength="10" >
            <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.formAlumno.Pnacimiento');"> 
            </a> </td>
          <td colspan="3"><input name="Pdireccion" onFocus="this.select()" type="text" id="Pdireccion" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pdireccion#</cfoutput></cfif>" size="70" maxlength="255"></td>
        </tr>
        <tr> 
          <td class="subTitulo">Ruta de Imagen</td>
          <td class="subTitulo">Tel&eacute;fono Casa*</td>
          <td class="subTitulo">Mail Principal*</td>
          <td colspan="2" class="subTitulo">Mail Secundario* 
		  	<!---
            <cfinvoke component="edu.Componentes.eduHelp"  method="Ayuda">
              <cfinvokeargument name="nombre" value="imAyuda"/>
              <cfinvokeargument name="imagen" value="0"/>
              <cfinvokeargument name="tipo" value="1"/>
              <cfinvokeargument name="titulo" value="Ayuda para Alumnos"/>
              <cfinvokeargument name="Acodigo" value="#GetFileFromPath(GetTemplatePath())#"/>
              <cfinvokeargument name="Iid" value="2"/>
            </cfinvoke>
			--->
		  </td>
        </tr>
        <tr> 
          <td><input type="file" name="Pfoto" ></td>
          <td><input name="Pcasa" type="text" id="Pcasa" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pcasa#</cfoutput></cfif>"></td>
          <td><input name="Pemail1" type="text" id="Pemail1"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pemail1#</cfoutput></cfif>" size="30"></td>
          <td colspan="2"><input name="Pemail2" type="text" id="Pemail22"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pemail2#</cfoutput></cfif>" size="30"></td>
        </tr>
        <tr> 
          <td class="subTitulo">Pa&iacute;s</td>
          <td class="subTitulo">Promoci&oacute;n</td>
          <td align="center" valign="middle">&nbsp;</td>
          <td colspan="2" rowspan="2" align="center" valign="bottom"> 
            <!-- Alta -->
            <cfif modo EQ 'ALTA'>
              <input type="button"  name="btnLimpiar"  value="Limpiar" onClick="javascript: limpiar()" >
              <input name="btnAgregar" type="submit" id="btnAgregar" onClick="javascript: setBtn(this);" value="Agregar" >
              <input name="btnBuscar" type="submit" id="btnBuscar" value="Buscar" onClick="javascript: setBtn(this); deshabilitarValidacion()">
              <cfelse>
              <!-- Cambio -->
              <input type="submit" name="btnCambiar" id="btnCambiar"  value="Cambiar" onClick="javascript: setBtn(this); habilitarValidacion();" >
              <input type="submit" name="btnBorrar"   id="btnBorrar" value="Borrar" onClick="javascript: setBtn(this); deshabilitarValidacion(); return confirm('Esta seguro(a) que desea borrar esta persona?')" >
              <input name="btnNuevo" type="submit" id="btnNuevo" value="Nuevo alumno" onClick="javascript: setBtn(this); deshabilitarValidacion();">
            </cfif> </td>
        </tr>
        <tr> 
          <td>
		      <select name="Ppais" id="select">
			  <cfoutput query="rsPaises">
                  <option value="#Ppais#" <cfif (modo EQ "CAMBIO" and rsForm.Ppais EQ rsPaises.Ppais) or (modo EQ "ALTA" and rsPaises.Ppais EQ "CR")>selected</cfif>>#Pnombre#</option>
              </cfoutput>
			  </select>
		  </td>
          <td colspan="2"><select name="PRcodigo" id="select3">
              <cfoutput query="rsPromo"> 
                <cfif modo EQ 'CAMBIO' and #rsForm.PRcodigo# EQ #rsPromo.PRcodigo#>
                  <option value="#rsPromo.PRcodigo#" selected>#rsPromo.PRdescripcion#</option>
                  <cfelse>
                  <option value="#rsPromo.PRcodigo#">#rsPromo.PRdescripcion#</option>
                </cfif>
              </cfoutput> </select></td>
        </tr>
        <tr> 
          <td>&nbsp;</td>
          <td>&nbsp; </td>
          <td>&nbsp; </td>
          <td colspan="2"></td>
        </tr>
        <tr> 
          <td colspan="5" align="center" class="subTitulo"><cfif modo EQ 'ALTA'>
              Nota: Las b&uacute;squedas funcionan para campos con un (*) 
              <cfelse>
              &nbsp;</cfif></td>
        </tr>
      </table>  
	  </form>
<!--- 			<table width="100%" border="0">
			  <tr>
 				<td valign="top">
					<!--- <cfinclude template="../formAgregaEncar.cfm"> --->
				</td> 
				<td valign="top">
					<cfif modo EQ 'CAMBIO'>
						<!--- <cfinclude template="../listaEncarAsoc.cfm"></td> --->
					<cfelse>
						&nbsp;
					</cfif>
			  </tr>
			</table>
 --->



<script language="JavaScript" type="text/javascript" src="../../../js/calendar.js" >//</script>
<script language="JavaScript" type="text/javascript" src="../../../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="../js/formAlumno.js">//</script> 
<script language="JavaScript" src="../../../js/qForms/qforms.js">//</script>
<script language="JavaScript" type="text/JavaScript">
	// specify the path where the "/qforms/" subfolder is located
	qFormAPI.setLibraryPath("../../js/qForms/");
	// loads all default libraries
	qFormAPI.include("*");
</script> 
 
 
<script language="JavaScript" type="text/javascript" >
//------------------------------------------------------------------------------------------						
	function deshabilitarValidacion() {
		objForm.Pnombre.required = false;
		objForm.Pid.required = false;	
		objForm.Papellido1.required = false;			
		objForm.Ppais.required = false;			
		objForm.PRcodigo.required = false;					
	}
//------------------------------------------------------------------------------------------						
	function habilitarValidacion() {
		objForm.Pnombre.required = true;
		objForm.Pid.required = true;
		objForm.Papellido1.required = true;								
		objForm.Ppais.required = true;			
		objForm.PRcodigo.required = true;							
	}	
	
//------------------------------------------------------------------------------------------							
	function __isRetirado() {
		if (btnSelected("btnCambiar")||btnSelected("btnAgregar")) {
			if (!confirm("Esta seguro (a) que desea retirar al alumno ?"))
				//this.obj.form.checked = false;
				this.reset();
		}
		
		
/*		if (btnSelected("btnBorrar")) {
			// Valida que el Grado no tenga dependencias con otros.
			var msg = "";
			//alert(new Number(this.obj.form.HayHorarioGuia.value)); 
			if (new Number(this.obj.form.HayDependencias.value) > 0) {
				msg = msg + this.obj.form.HayDependencias.value + " alumno (s)"
			}
			if (msg != ""){
				this.error = "Usted no puede eliminar la promoción '" + this.obj.form.PRdescripcion.value + "' porque ésta tiene asociado (s): " + msg + ", si todavía desea borrarla, borre primero las asociaciones";
				this.obj.form.PRdescripcion.focus();
			}
		}
*/		
	}	
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	_addValidator("isRetirado", __isRetirado);
	objForm = new qForm("formAlumno");	
//------------------------------------------------------------------------------------------					
	<cfif modo EQ "ALTA">
		objForm.Pnombre.required = true;
		objForm.Pnombre.description = "nombre";
		objForm.Pid.required = true;
		objForm.Pid.description = "Identificación";		
		objForm.Papellido1.required = true;
		objForm.Papellido1.description = "Primer Apellido";
		objForm.Ppais.required = true;
		objForm.Ppais.description = "País";
		objForm.PRcodigo.required = true;
		objForm.PRcodigo.description = "Promoción";		
		objForm.Aretirado.validateRetirado();
	<cfelse>
		objForm.Pnombre.required = true;
		objForm.Pnombre.description = "nombre";																	
		objForm.Pid.required = true;
		objForm.Pid.description = "Identificación";		
		objForm.Papellido1.required = true;
		objForm.Papellido1.description = "Primer Apellido";
		objForm.Ppais.required = true;
		objForm.Ppais.description = "País";
		objForm.PRcodigo.required = true;
		objForm.PRcodigo.description = "Promoción";				
		objForm.Aretirado.validateRetirado();
	</cfif> 
</script>

