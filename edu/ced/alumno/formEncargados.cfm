<!-- Establecimiento del modo -->

<cfif isdefined("Url.personaEncar") and not isdefined("Form.personaEncar")>
	<cfparam name="Form.personaEncar" default="#Url.personaEncar#">
</cfif> 
<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfparam name="Form.persona" default="#Url.persona#">
</cfif> 
<cfif isdefined("Url.tab") and not isdefined("Form.tab")>
	<cfparam name="Form.tab" default="#Url.tab#">
</cfif> 
<cfif isdefined("Url.EcodigoEst") and not isdefined("Form.EcodigoEst")>
	<cfparam name="Form.EcodigoEst" default="#Url.EcodigoEst#">
</cfif> 
<cfset modo="ALTA">
<cfif isdefined("Form.personaEncar") and form.personaEncar NEQ "">
	<cfset modo="CAMBIO">
</cfif>
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL SQL--->		
<cfif isdefined("url.Pagina") and len(trim(url.Pagina))>
	<cfset form.Pagina = url.Pagina>
</cfif>	
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA NAVEGACION--->
<cfif isdefined("url.PageNum_Lista") and len(trim(url.PageNum_Lista))>
	<cfset form.Pagina = url.PageNum_Lista>
</cfif>					
<!--- VARIABLE DE PAGINA PARA CUANDO VIENE DEL CLICK EN LA LISTA--->
<cfif isdefined("form.PageNum") and len(trim(form.PageNum))>
	<cfset form.Pagina = form.PageNum>
</cfif>
<!--- Consultas --->

<!--- 1. Form  --->
<cfif modo EQ "CAMBIO" >
	<cfquery datasource="#Session.Edu.DSN#" name="rsForm">
		Select convert(varchar,a.persona) as personaEncar, a.CEcodigo, a.Pnombre, Papellido1, Papellido2, a.Ppais, b.Pnombre, a.TIcodigo, TInombre, Pid, convert(varchar,Pnacimiento,103) Pnacimiento, Psexo, Pemail1, Pemail2, Pdireccion, Pcasa, Poficina, Pcelular, Pfax, Ppagertel, Ppagernum, Pfoto, PfotoType, PfotoName, Pemail1validado 
		from PersonaEducativo a
		inner join Encargado d
		   on a.persona = d.persona
		inner join TipoIdentificacion c
		   on a.TIcodigo = c.TIcodigo
		inner join Pais b
		   on a.Ppais = b.Ppais
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		  and a.persona  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.personaEncar#">
	</cfquery>
</cfif>

<!--- Para el combo de tipos de Identificacion  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsTipoIdentif">
	select TIcodigo,TInombre 
	from TipoIdentificacion
</cfquery>

<!---  Para el combo de paises  --->
<cfquery datasource="#Session.Edu.DSN#" name="rsPaises">
	select Ppais,Pnombre from Pais 
</cfquery>

<!--- ------------------------------------------------------------------------------- --->

<form action="SQLEncargados.cfm" method="post" enctype="multipart/form-data" id="form1" name="form1">
	<cfoutput>
   <input name="personaEncar" id="personaEncar" value="<cfif modo NEQ 'ALTA'>#rsForm.personaEncar#</cfif>" type="hidden"> 
   <input name="persona" id="persona" value="#form.persona#" type="hidden">    
   <input name="tab" id="tab" value="<cfif isdefined("form.tab")>#form.tab#</cfif>" type="hidden">    
   <input name="EcodigoEst" id="EcodigoEst" value="#form.EcodigoEst#" type="hidden">    
<!--- Campos del filtro para la lista de alumnos --->
	<cfif isdefined("Form.Filtro_Estado")>
		<input type="hidden" name="Filtro_Estado" value="#Form.Filtro_Estado#">
	</cfif>		   
	<cfif isdefined("Form.Filtro_Grado")>
		<input type="hidden" name="Filtro_Grado" value="#Form.Filtro_Grado#">
	</cfif>		
	<cfif isdefined("Form.Filtro_Ndescripcion")>
		<input type="hidden" name="Filtro_Ndescripcion" value="#Form.Filtro_Ndescripcion#">
	</cfif>		
	<cfif isdefined("Form.Filtro_Nombre")>
		<input type="hidden" name="Filtro_Nombre" value="#Form.Filtro_Nombre#">
	</cfif>
	<cfif isdefined("Form.Filtro_Pid")>
		<input type="hidden" name="Filtro_Pid" value="#Form.Filtro_Pid#">
	</cfif>
	<cfif isdefined("Form.HFiltro_Estado")>
		<input type="hidden" name="HFiltro_Estado" value="#Form.HFiltro_Estado#">
	</cfif>		   
	<cfif isdefined("Form.HFiltro_Grado")>
		<input type="hidden" name="HFiltro_Grado" value="#Form.HFiltro_Grado#">
	</cfif>		
	<cfif isdefined("Form.HFiltro_Ndescripcion")>
		<input type="hidden" name="HFiltro_Ndescripcion" value="#Form.HFiltro_Ndescripcion#">
	</cfif>		
	<cfif isdefined("Form.HFiltro_Nombre")>
		<input type="hidden" name="HFiltro_Nombre" value="#Form.HFiltro_Nombre#">
	</cfif>
	<cfif isdefined("Form.HFiltro_Pid")>
		<input type="hidden" name="HFiltro_Pid" value="#Form.HFiltro_Pid#">
	</cfif>
	<input type="hidden" name="NoMatr" value="<cfif isdefined("Form.NoMatr")>#Form.NoMatr#</cfif>">
	<input name="Pagina" type="hidden" value="#form.Pagina#">
	</cfoutput>

  <table width="100%" border="0">
    <tr> 
      <td colspan="4" class="tituloAlterno"> <cfif modo EQ 'CAMBIO'>
          Modificaci&oacute;n de Encargado 
          <cfelse>
          Ingreso de Encargado </cfif> </td>
    </tr>
    <tr> 
      <td width="20%" rowspan="14" valign="top" align="center"> <table width="108" height="159" border="1">
          <tr> 
            <td width="102" align="center" valign="middle"> <cfif modo NEQ 'ALTA'>
                <cfif Len(rsForm.Pfoto) EQ 0>
                  Fotograf&iacute;a no disponible 
                  <cfelse>
                  <!--- <img src="/Upload/DownloadServlet/PersonaEducacionFoto?persona=<cfoutput>#rsForm.personaEncar#</cfoutput>" alt='<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pnombre#  #rsForm.Papellido1#  #rsForm.Papellido2#</cfoutput></cfif>' align="middle" width="109" height="154" border="0">	 --->
				  <cf_LoadImage tabla="PersonaEducativo" columnas="Pfoto as contenido, persona as codigo" condicion="persona=#rsForm.personaEncar#" imgname="Foto" width="109" height="154" alt="#rsForm.Pnombre#  #rsForm.Papellido1#  #rsForm.Papellido2#">
                </cfif>
                <cfelse>
                Fotograf&iacute;a </cfif> </td>
          </tr>
        </table></td>
      <td width="13%"><strong>Nombre</strong></td>
      <td width="16%"><strong>Primer Apellido</strong></td>
      <td width="29%"><strong>Segundo Apellido</strong></td>
    </tr>
    <tr> 
      <td><input name="Pnombre" type="text" id="Pnombre" onFocus="this.select()" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pnombre#</cfoutput></cfif>"></td>
      <td><input name="Papellido1" type="text" id="Papellido1" onFocus="this.select()" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Papellido1#</cfoutput></cfif>"></td>
      <td><input name="Papellido2" type="text" id="Papellido2" onFocus="this.select()" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Papellido2#</cfoutput></cfif>"></td>
    </tr>
    <tr> 
      <td><strong>Identificaci&oacute;n</strong></td>
      <td><strong>Tipo Identificaci&oacute;n</strong></td>
      <td><strong>Sexo</strong></td>
    </tr>
    <tr> 
      <td><input name="Pid" type="text" id="Pid" onFocus="this.select()" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pid#</cfoutput></cfif>"></td>
      <td><select name="TIcodigo" id="TIcodigo" tabindex="1">
          <cfoutput query="rsTipoIdentif"> 
            <cfif modo EQ 'CAMBIO' and #rsForm.TIcodigo# EQ #rsTipoIdentif.TIcodigo#>
              <option value="#rsTipoIdentif.TIcodigo#" selected>#rsTipoIdentif.TInombre#</option>
              <cfelse>
              <option value="#rsTipoIdentif.TIcodigo#">#rsTipoIdentif.TInombre#</option>
            </cfif>
          </cfoutput> </select> </td>
      <td><select name="Psexo" id="Psexo" tabindex="1">
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
      <td><strong>Fecha de Nacimiento</strong></td>
      <td colspan="2"><strong>Direcci&oacute;n</strong></td>
    </tr>
    <tr> 
      <td>
	  	<cfif isdefined('rsForm.Pnacimiento') and LEN(TRIM(rsForm.Pnacimiento))>
			<cfset fecha= rsForm.Pnacimiento>
		<cfelse>
			<cfset fecha= LSDateFormat(Now(),'dd/mm/yyyy')>
		</cfif>
	  	<cf_sifcalendario name="Pnacimiento" value="#fecha#" tabindex="1">
	</td>
      <td colspan="2"><input name="Pdireccion" onFocus="this.select()" type="text" id="Pdireccion" tabindex="1" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pdireccion#</cfoutput></cfif>" size="70" maxlength="255"></td>
    </tr>
    <tr> 
      
      <td><strong>Tel&eacute;fono Casa</strong></td>
      <td><strong>Tel&eacute;fono Oficina</strong></td>
      <td><strong>Tel&eacute;fono Celular</strong></td>
	  
    </tr>
    <tr> 
      
      <td><input name="Pcasa" type="text" tabindex="1" id="Pcasa" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pcasa#</cfoutput></cfif>"></td>
      <td><input name="Poficina" type="text" tabindex="1" id="Poficina" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Poficina#</cfoutput></cfif>"></td>
      <td><input name="Pcelular" src="../../Imagenes/delete.small.png" type="text" tabindex="1" onFocus="this.select()" id="Pcelular" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pcelular#</cfoutput></cfif>"></td>
    	
	</tr>
    <tr> 
		 <td><strong>Fax</strong></td>
      <td><strong>Tel&eacute;fono Pager</strong></td>
      <td><strong>N&uacute;mero Pager</strong></td>
    </tr>
    <tr> 
		<td> <input name="Pfax" type="text" id="Pfax2" tabindex="1" onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pfax#</cfoutput></cfif>"></td>
      <td><input name="Ppagertel" type="text" id="Ppagertel" tabindex="1"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Ppagertel#</cfoutput></cfif>"></td>
      <td><input name="Ppagernum" type="text" onFocus="this.select()" tabindex="1" id="Ppagernum" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Ppagernum#</cfoutput></cfif>"></td>
    </tr>
	<tr>
		<td><strong>Mail Principal</strong></td>
      <td colspan="2"><strong>Mail Secundario</strong></td>
	</tr>
	<tr>
		      <td><input name="Pemail1" type="text" id="Pemail1" tabindex="1"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pemail1#</cfoutput></cfif>" size="30"></td>
      <td colspan="2"><input name="Pemail2" type="text" id="Pemail2" tabindex="1"  onFocus="this.select()" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsForm.Pemail2#</cfoutput></cfif>" size="30"></td>

	</tr>
    <tr> 
      <td><strong>Pa&iacute;s</strong></td>
	  <td colspan="2"><strong>Ruta de Imagen</strong></td>
    </tr>
    <tr> 

      <td><select name="Ppais" id="select2" tabindex="1">
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
		 		<td><input type="file" name="Pfoto" ></td>
    </tr>
	<tr>
		 <td colspan="4" align="center"> 
		 <cfset Lvar_regresa="alumno.cfm?Pagina=#form.Pagina#&persona=#form.Persona#&tab=#form.tab#&Filtro_Estado=#form.Filtro_Estado#&Filtro_Grado=#form.Filtro_Grado#&Filtro_Ndescripcion=#form.Filtro_Ndescripcion#&Filtro_Nombre=#form.Filtro_nombre#&filtro_Pid=#form.Filtro_Pid#">
		 <cf_botones modo="#modo#" Regresar="#Lvar_regresa#" exclude="Baja" tabindex="1">
         </td>
	</tr>
  </table>  
 </form>
 
<script language="JavaScript" type="text/javascript" src="../../js/calendar.js" >//</script>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>


<cf_qforms>
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
