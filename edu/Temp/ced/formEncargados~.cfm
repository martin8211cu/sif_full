<!-- Establecimiento del modo -->

<cfif isdefined("Url.personaEncar") and not isdefined("Form.personaEncar")>
	<cfparam name="Form.personaEncar" default="#Url.personaEncar#">
</cfif> 
<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfparam name="Form.persona" default="#Url.persona#">
</cfif> 
<cfif isdefined("Url.Ecodigo") and not isdefined("Form.Ecodigo")>
	<cfparam name="Form.Ecodigo" default="#Url.Ecodigo#">
</cfif> 
<cfif isdefined("Url.modo") and not isdefined("Form.modo")>
	<cfparam name="Form.modo" default="#Url.modo#">
</cfif>	

<!---
 <cfdump var="#form#">
  <cfdump var="#url#">
  ---> 
  
<cfif isdefined("Form.personaEncar") and form.personaEncar NEQ "">
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

<!--- Consultas --->

<!--- 1. Form  --->
<cfif modo EQ "CAMBIO" >
	<cfquery datasource="#Session.DSN#" name="rsForm">
		Select convert(varchar,a.persona) as personaEncar, a.CEcodigo, a.Pnombre, Papellido1, Papellido2, a.Ppais, b.Pnombre, a.TIcodigo, TInombre, Pid, convert(varchar,Pnacimiento,103) Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Pfoto, PfotoType, PfotoName, Pemail1validado
		from PersonaEducativo a, Pais b, TipoIdentificacion c, Encargado d
		where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and a.persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.personaEncar#">
		and a.Ppais=b.Ppais
		and a.TIcodigo=c.TIcodigo
		and a.persona=d.persona	
	</cfquery>
</cfif>

<!--- Para el combo de tipos de Identificacion  --->
<cfquery datasource="#Session.DSN#" name="rsTipoIdentif">
	select TIcodigo,TInombre from TipoIdentificacion
</cfquery>

<!---  Para el combo de paises  --->
<cfquery datasource="#Session.DSN#" name="rsPaises">
	select Ppais,Pnombre from Pais 
</cfquery>

<!--- ------------------------------------------------------------------------------- --->

<form action="SQLEncargados.cfm" method="post" enctype="multipart/form-data" id="formEncargado" name="formEncargado">
   <input name="personaEncar" id="personaEncar" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.personaEncar#</cfoutput></cfif>" type="hidden"> 
   <input name="persona" id="persona" value="<cfoutput>#form.persona#</cfoutput>" type="hidden">    
   <input name="Ecodigo" id="Ecodigo" value="<cfoutput>#form.Ecodigo#</cfoutput>" type="hidden">    
   <input name="MODO" id="MODO" value="<cfoutput>#modo#</cfoutput>" type="hidden">    

  <table width="100%" border="0">
    <tr> 
      <td colspan="4" class="tituloAlterno"> <cfif modo EQ 'CAMBIO'>
          Modificaci&oacute;n de Encargado 
          <cfelse>
          Ingreso de Encargado </cfif> </td>
    </tr>
    <tr> 
      <td width="20%" rowspan="6" valign="middle" align="center"> <table width="108" height="159" border="1">
          <tr> 
            <td width="102" align="center" valign="middle"> <cfif modo NEQ 'ALTA'>
                <cfif Len(rsForm.Pfoto) EQ 0>
                  Fotograf&iacute;a no disponible 
                  <cfelse>
                  <img src="/Upload/DownloadServlet/PersonaEducacionFoto?persona=<cfoutput>#rsForm.persona#</cfoutput>" alt='<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pnombre#  #rsForm.Papellido1#  #rsForm.Papellido2#</cfoutput></cfif>' align="middle" width="109" height="154" border="0">	
                </cfif>
                <cfelse>
                Fotograf&iacute;a </cfif> </td>
          </tr>
        </table></td>
      <td width="13%" class="subTitulo">Nombre</td>
      <td width="16%" class="subTitulo">Primer Apellido</td>
      <td width="29%" class="subTitulo">Segundo Apellido</td>
    </tr>
    <tr> 
      <td><input name="Pnombre" type="text" id="Pnombre" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pnombre#</cfoutput></cfif>"></td>
      <td><input name="Papellido1" type="text" id="Papellido1" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Papellido1#</cfoutput></cfif>"></td>
      <td><input name="Papellido2" type="text" id="Papellido2" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Papellido2#</cfoutput></cfif>"></td>
    </tr>
    <tr> 
      <td class="subTitulo">Identificaci&oacute;n</td>
      <td class="subTitulo">Tipo Identificaci&oacute;n</td>
      <td class="subTitulo">Sexo</td>
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
    </tr>
    <tr> 
      <td class="subTitulo"><font size="1">Fecha de Nacimiento</font></td>
      <td class="subTitulo">Direcci&oacute;n</td>
      <td class="subTitulo">&nbsp;</td>
    </tr>
    <tr> 
      <td> 
        <!---  <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
        <input name="Pnacimiento" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif isdefined("form.Pnacimiento")><cfoutput>#rsForm.Pnacimiento#</cfoutput><cfelse><cfoutput>#DateFormat(Now(),'DD/MM/YYYY')#</cfoutput></cfif>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.formEncargado.Pnacimiento');"> 
        </a> --->
        <a href="#"> 
        <input name="Pnacimiento" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfoutput><cfif modo NEQ 'ALTA'>#rsForm.Pnacimiento#<cfelse>#DateFormat(Now(),'DD/MM/YYYY')#</cfif></cfoutput>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.formEncargado.Pnacimiento');"> 
        </a> </td>
      <td colspan="2"><input name="Pdireccion" onFocus="this.select()" type="text" id="Pdireccion" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pdireccion#</cfoutput></cfif>" size="70" maxlength="255"></td>
    </tr>
    <tr> 
      <td class="subTitulo">Ruta de Imagen</td>
      <td class="subTitulo">Tel&eacute;fono Casa</td>
      <td class="subTitulo">Mail Principal</td>
      <td class="subTitulo">Mail Secundario</td>
    </tr>
    <tr> 
      <td><input type="file" name="Pfoto" ></td>
      <td><input name="Pcasa" type="text" id="Pcasa" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pcasa#</cfoutput></cfif>"></td>
      <td><input name="Pemail1" type="text" id="Pemail1"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pemail1#</cfoutput></cfif>" size="30"></td>
      <td><input name="Pemail2" type="text" id="Pemail22"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pemail2#</cfoutput></cfif>" size="30"></td>
    </tr>
    <tr> 
      <td class="subTitulo">Pa&iacute;s</td>
      <td colspan="3" rowspan="2" align="center" valign="middle"> 
        <!-- Alta -->
        <cfif modo EQ 'ALTA'>
          <input type="button"  name="btnLimpiar"  value="Limpiar" onClick="javascript: limpiar()" >
          <input name="btnAgregar" type="submit" id="btnAgregar" onClick="javascript: setBtn(this);" value="Agregar" >
          <cfelse>
          <!-- Cambio -->
          <input type="submit" name="btnCambiar" id="btnCambiar"  value="Cambiar" onClick="javascript: setBtn(this); habilitarValidacion();" >
          <input name="btnNuevo" type="submit" id="btnNuevo" value="Nuevo Encargado" onClick="javascript: setBtn(this); deshabilitarValidacion();">
        </cfif> <input name="btnRegresa" type="submit" id="btnRegresa" value="Regresar" onClick="javascript: setBtn(this); deshabilitarValidacion();">	
      </td>
    </tr>
    <tr> 
      <td><select name="Ppais" id="select">
          <cfoutput query="rsPaises"> 
            <cfif modo EQ 'CAMBIO' and #rsForm.Ppais# EQ #rsPaises.Ppais#>
              <option value="#rsPaises.Ppais#" selected>#rsPaises.Pnombre#</option>
              <cfelse>
              <cfif #rsPaises.Ppais# EQ 'CR'>
                <option value="#rsPaises.Ppais#" selected>#rsPaises.Pnombre#</option>
                <cfelse>
                <option value="#rsPaises.Ppais#">#rsPaises.Pnombre#</option>
              </cfif>
            </cfif>
          </cfoutput> </select></td>
    </tr>
  </table>  
 </form>
 
<script language="JavaScript" type="text/javascript" src="../../js/calendar.js" >//</script>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="js/formEncargado.js">//</script> 
<script language="JavaScript" src="../../js/qForms/qforms.js">//</script>
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
	}
//------------------------------------------------------------------------------------------						
	function habilitarValidacion() {
		objForm.Pnombre.required = true;	
		objForm.Pid.required = true;
		objForm.Papellido1.required = true;								
		objForm.Ppais.required = true;		
	}	
//------------------------------------------------------------------------------------------						
	function RegresaEncAlumno() {
		alert('Regresa');
	}		
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formEncargado");	
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
	<cfelse>
		objForm.Pnombre.required = true;
		objForm.Pnombre.description = "nombre";																					
		objForm.Pid.required = true;
		objForm.Pid.description = "Identificación";				
		objForm.Papellido1.required = true;
		objForm.Papellido1.description = "Primer Apellido";
		objForm.Ppais.required = true;
		objForm.Ppais.description = "País";
	</cfif> 
//------------------------------------------------------------------------------------------		
</script>
