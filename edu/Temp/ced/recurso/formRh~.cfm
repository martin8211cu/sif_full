<!-- Establecimiento del modo -->
<!--- <cfdump var="#form#"> ---> 

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


<!--- Consultas --->

<!--- 1. Form  --->
<cfif modo EQ "CAMBIO" >
	<cfquery datasource="#Session.DSN#" name="rsForm">
		Select convert(varchar,persona) as persona, convert(varchar,CEcodigo) as CEcodigo, a.Pnombre, Papellido1, Papellido2, a.Ppais, b.Pnombre, a.TIcodigo, TInombre, Pid, convert(varchar,Pnacimiento,103) Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Pfoto, PfotoType, PfotoName, Pemail1validado
		from PersonaEducativo a, Pais b, TipoIdentificacion c
		where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
		and persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
		and a.Ppais=b.Ppais
		and a.TIcodigo=c.TIcodigo
	</cfquery>
	
	<!---  Para el check de Asistente  --->
	<cfquery datasource="#Session.DSN#" name="rsAsist">
		Select convert(varchar,Acodigo) as Acodigo from Asistente
		where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	</cfquery>	
	
	<!---  Para el check de Staff o Docente  --->
	<cfquery datasource="#Session.DSN#" name="rsStaff">
		Select convert(varchar,Splaza) as Splaza from Staff
		where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
			and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	</cfquery>
	
	<!---  Para el check de Encargado  --->
	<cfquery datasource="#Session.DSN#" name="rsEncar">
		Select convert(varchar,EEcodigo) as EEcodigo from Encargado
		where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
	</cfquery>	

	<!---  Para el check de Director  --->
	<cfquery datasource="#Session.DSN#" name="rsDirec">
		Select convert(varchar,Dcodigo) as Dcodigo, convert(varchar,Ncodigo) as Ncodigo from Director
		where persona=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.persona#">
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


<!---  Para el combo de Niveles  --->
<cfquery datasource="#Session.DSN#" name="rsNivel">
	select convert(varchar,Ncodigo) as Ncodigo,Ndescripcion
	from Nivel
	where CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
</cfquery>

<!--- ------------------------------------------------------------------------------- --->

<form action="SQLRh.cfm" method="post" enctype="multipart/form-data" id="formRH" name="formRH">
   <input name="persona" id="persona" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.persona#</cfoutput></cfif>" type="hidden"> 
   <input name="MODO" id="MODO" value="<cfoutput>#modo#</cfoutput>" type="hidden">    

  <table width="100%" border="0">
    <tr> 
      <td colspan="5" class="tituloAlterno"> <cfif modo EQ 'CAMBIO'>
          Modificacion de Recurso Humano 
          <cfelse>
          Ingreso de Recurso Humano </cfif> </td>
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
      <td width="13%" class="subTitulo">Nombre*</td>
      <td width="16%" class="subTitulo">Primer Apellido *</td>
      <td width="29%" class="subTitulo">Segundo Apellido*</td>
      <td width="22%" valign="top" align="center" class="subTitulo">Tipos</td>
    </tr>
    <tr> 
      <td><input name="Pnombre" type="text" id="Pnombre" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pnombre#</cfoutput></cfif>"></td>
      <td><input name="Papellido1" type="text" id="Papellido1" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Papellido1#</cfoutput></cfif>"></td>
      <td><input name="Papellido2" type="text" id="Papellido2" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Papellido2#</cfoutput></cfif>"></td>
      <td width="22%" rowspan="4" > <table width="100%" border="0">
          <tr> 
            <td><input name="Acodigo" type="checkbox" id="Acodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsAsist.Acodigo#</cfoutput></cfif>"  <cfif modo NEQ 'ALTA' and #rsAsist.Acodigo# NEQ "">checked</cfif>> 
            </td>
            <td colspan="2">Asistente</td>
          </tr>
          <tr> 
            <td> <input name="EEcodigo" type="checkbox" id="EEcodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsEncar.EEcodigo#</cfoutput></cfif>" <cfif modo NEQ 'ALTA' and #rsEncar.EEcodigo# NEQ "">checked</cfif>> 
            </td>
            <td colspan="2">Encargado</td>
          </tr>
          <tr> 
            <td><input name="Splaza" type="checkbox" id="Splaza" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsStaff.Splaza#</cfoutput></cfif>" <cfif modo NEQ 'ALTA' and #rsStaff.Splaza# NEQ "">checked</cfif>> 
            </td>
            <td>Docente</td>
            <td width="67%" rowspan="2"> <div style="display: ;" id="verNiveles"> 
                <table width="100%" border="0">
                  <tr class="subTitulo"> 
                    <td class="subTitulo">Nivel</td>
                  </tr>
                  <tr> 
                    <td><select name="Ncodigo" id="Ncodigo">
                        <cfoutput query="rsNivel"> 
                          <cfif modo NEQ 'ALTA' >
                            <cfif #rsDirec.Ncodigo# EQ #rsNivel.Ncodigo#>
                              <option value="#rsNivel.Ncodigo#" selected>#rsNivel.Ndescripcion#</option>
                              <cfelse>
                              <option value="#rsNivel.Ncodigo#">#rsNivel.Ndescripcion#</option>
                            </cfif>
                            <cfelse>
                            <option value="#rsNivel.Ncodigo#">#rsNivel.Ndescripcion#</option>
                          </cfif>
                        </cfoutput> </select></td>
                  </tr>
                </table>
              </div></td>
          </tr>
          <tr> 
            <td width="11%"><input name="Dcodigo" type="checkbox" id="Dcodigo" onClick="javascript: Nivel(this)" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsDirec.Dcodigo#</cfoutput></cfif>" <cfif modo NEQ 'ALTA' and #rsDirec.Dcodigo# NEQ "">checked</cfif>></td>
            <td width="22%"> Director</td>
          </tr>
        </table></td>
    </tr>
    <tr> 
      <td class="subTitulo">Identificaci&oacute;n*</td>
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
      <td class="subTitulo">Direcci&oacute;n*</td>
      <td class="subTitulo">&nbsp;</td>
    </tr>
    <tr> 
      <td> <a href="#" onMouseOut="MM_swapImgRestore()" onMouseOver="MM_swapImage('Calendar1','','/cfmx/edu/Imagenes/date_d.gif',1)"> 
        <input name="Pnacimiento" onFocus="this.select()" type="text" onBlur="javascript: onblurdatetime(this)" value="<cfif isdefined("form.Pnacimiento")><cfoutput>#rsForm.Pnacimiento#</cfoutput><cfelse><cfoutput>#DateFormat(Now(),'DD/MM/YYYY')#</cfoutput></cfif>" size="12" maxlength="10" >
        <img src="/cfmx/edu/Imagenes/date_d.gif" alt="Calendario" name="Calendar1" width="11" height="11" border="0" id="Calendar1" onClick="javascript:showCalendar('document.formRH.Pnacimiento');"> 
        </a> </td>
      <td colspan="3"><input name="Pdireccion" onFocus="this.select()" type="text" id="Pdireccion" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pdireccion#</cfoutput></cfif>" size="105" maxlength="255"> 
      </td>
    </tr>
    <tr> 
      <td class="subTitulo">Ruta de Imagen</td>
      <td class="subTitulo">Tel&eacute;fono Casa*</td>
      <td class="subTitulo">Mail Principal*</td>
      <td class="subTitulo">Mail Secundario*</td>
      <td class="subTitulo">Pa&iacute;s</td>
    </tr>
    <tr> 
      <td><input type="file" name="Pfoto" ></td>
      <td><input name="Pcasa" type="text" id="Pcasa" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pcasa#</cfoutput></cfif>"></td>
      <td><input name="Pemail1" type="text" id="Pemail1"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pemail1#</cfoutput></cfif>" size="30"></td>
      <td><input name="Pemail2" type="text" id="Pemail22"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pemail2#</cfoutput></cfif>" size="30"></td>
      <td valign="top"><select name="Ppais" id="select2">
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
    <tr> 
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td>&nbsp;</td>
      <td valign="top">&nbsp;</td>
    </tr>
    <tr> 
      <td colspan="5" align="center"> 
        <!-- Alta -->
        <cfif modo EQ 'ALTA'>
          <input type="button"  name="btnLimpiar"  value="Limpiar" onClick="javascript: limpiar()" >
          <input name="btnAgregar" type="submit" id="btnAgregar" onClick="javascript: setBtn(this);" value="Agregar" >
          <input name="btnBuscar" type="submit" id="btnBuscar" value="Buscar" onClick="javascript: setBtn(this); deshabilitarValidacion()">
          <cfelse>
          <!-- Cambio -->
          <input type="submit" name="btnCambiar" id="btnCambiar"  value="Cambiar" onClick="javascript: setBtn(this); habilitarValidacion()" >
          <input type="submit" name="btnBorrar"   id="btnBorrar" value="Borrar" onClick="javascript: setBtn(this); deshabilitarValidacion(); return confirm('Esta seguro(a) que desea borrar esta persona?')" >
          <input type="submit" name="btnNuevo"   id="btnNuevo" value="Nueva Persona" onClick="javascript: setBtn(this);deshabilitarValidacion()" >
          <input type="button"  name="btnLimpiar"   value="Limpiar"  onClick="javascript: limpiar()" >
        </cfif> </td>
    </tr>
    <tr> 
      <td colspan="5" align="center" class="subTitulo">
		<cfif modo EQ 'ALTA'>
          Nota: Las b&uacute;squedas funcionan para campos con un (*) 
        <cfelse>
          &nbsp;
		</cfif>	  
	  </td>
    </tr>
  </table>  
 </form>
 
<script language="JavaScript" type="text/javascript" src="../../js/calendar.js" >//</script>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="js/formRh.js">//</script> 
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
		objForm.Ncodigo.required = false;
		objForm.Pid.required = false;
		objForm.Papellido1.required = false;								
		objForm.Ppais.required = false;			
	}
//------------------------------------------------------------------------------------------						
	function habilitarValidacion() {
		objForm.Pnombre.required = true;
		objForm.Ncodigo.required = true;
		objForm.Pid.required = true;
		objForm.Papellido1.required = true;								
		objForm.Ppais.required = true;			
			
	}	
//------------------------------------------------------------------------------------------						
	qFormAPI.errorColor = "#FFFFCC";
	objForm = new qForm("formRH");
//------------------------------------------------------------------------------------------					
	<cfif modo EQ "ALTA">
		objForm.Pnombre.required = true;
		objForm.Pnombre.description = "nombre";
		objForm.Ncodigo.required = true;
		objForm.Ncodigo.description = "nivel";								
		objForm.Pid.required = true;
		objForm.Pid.description = "Identificación";		
		objForm.Papellido1.required = true;
		objForm.Papellido1.description = "Primer Apellido";
		objForm.Ppais.required = true;
		objForm.Ppais.description = "País";		
	<cfelse>
		objForm.Pnombre.required = true;
		objForm.Pnombre.description = "nombre";								
		objForm.Ncodigo.required = true;
		objForm.Ncodigo.description = "nivel";		
		objForm.Pid.required = true;
		objForm.Pid.description = "Identificación";		
		objForm.Papellido1.required = true;
		objForm.Papellido1.description = "Primer Apellido";
		objForm.Ppais.required = true;
		objForm.Ppais.description = "País";		
	</cfif> 
//------------------------------------------------------------------------------------------		
	inicio();
</script>
