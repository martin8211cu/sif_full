<cfif isdefined("Url.persona") and not isdefined("Form.persona")>
	<cfparam name="Form.persona" default="#Url.persona#">
</cfif> 

<cfif isdefined("form.persona")>
	<cfparam name="Form.persona" default="#form.persona#">
</cfif> 
<cfif isdefined("Url.o") and not isdefined("Form.o")>
	<cfparam name="Form.o" default="#Url.o#">
</cfif> 


<script language="JavaScript" type="text/javascript" src="../../js/calendar.js" >//</script>
<script language="JavaScript" type="text/javascript" src="../../js/utilesMonto.js">//</script>
<script language="JavaScript" type="text/javascript" src="js/formAlumno.js">//</script> 
<form action="SQLAgregaEncar.cfm" method="post" id="formAgregaEncar" name="formAgregaEncar">
	<cfoutput>
	<input name="Ecodigo" id="Ecodigo" type="hidden" value=""> 
	<input name="persona" type="hidden" value="<cfif isdefined("form.persona")>#form.persona#</cfif>"> 
	<input name="tab" type="hidden" value="<cfif isdefined("Form.tab")>#form.tab#</cfif>"> 
	<input name="Pagina" type="hidden" value="<cfif isdefined('form.Pagina')>#form.Pagina#</cfif>">
	<input name="form_Ecodigo" id="form_Ecodigo" value="<cfif modo NEQ 'ALTA'><cfoutput>#rsform_Ecodigo.Ecodigo#</cfoutput></cfif>" type="hidden">
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
	<input type="hidden" name="NoMatr" value="<cfif isdefined("Form.NoMatr")>#Form.NoMatr#</cfif>">
	</cfoutput>		
								

  <table width="100%" border="0" cellpadding="0" cellspacing="0">
    <tr> 
		<cfif isdefined("form.persona") and form.persona NEQ "">
        <td>&nbsp;</td>
        <td align="center" class="tituloAlterno">Asociar 
          encargado </td>			
		<cfelse>
		   
        <td colspan="2" align="center" class="tituloAlterno">Asociar 
          encargado </td>
		</cfif>	
    </tr>
    <tr> 
      <td align="right" width="28%"><strong>Nombre:&nbsp;</strong></td>
 		<td>
			<cfset ArrayEncag=ArrayNew(1)>
						<cf_conlis title="Lista de Encargados"
							campos = "EEcodigo,persona,NombreEncar" 
							desplegables = "N,N,S" 
							size = "0,0,50"
							tabla="Encargado a inner join PersonaEducativo b on b.persona=a.persona"
							ValuesArray="#ArrayEncag#"
							columnas="EEcodigo, a.persona, (Pnombre + ' ' + Papellido1 + ' ' + Papellido2) as NombreEncar, Pid as PidEncar, 
									  Pnacimiento as FechaNacEncar, Pdireccion as PdireccionEncar"
							filtro=" CEcodigo = #Session.Edu.CEcodigo#
									and EEcodigo not in (
														Select a.EEcodigo
														from EncargadoEstudiante a, Alumnos b
														where a.CEcodigo=#Session.Edu.CEcodigo#
																and b.persona=	#form.persona#
																and a.CEcodigo=b.CEcodigo
																and a.Ecodigo=b.Ecodigo )"							
							desplegar="NombreEncar,PidEncar"
							asignar="EEcodigo,NombreEncar,PdireccionEncar,PidEncar,FechaNacEncar"
							etiquetas="Nombre,Identificaci&oacute;n"
							filtrar_por="(Pnombre + ' ' + Papellido1 + ' ' + Papellido2),Pid"
							formatos="S,S,S"
							asignarformatos="S,S,S,S,D"
							align="left,left"
							modificables="N,N,N"
							conexion="#session.Edu.DSN#"
							form = "formAgregaEncar"
							tabindex="1">
		</td>
     </tr>
    <tr> 
      <td align="right"><strong>Direcci&oacute;n:&nbsp;</strong></td>
      <td><input name="PdireccionEncar" readonly="true" type="text" id="PdireccionEncar" tabindex="-1" size="60" maxlength="80"></td>
    </tr>
    <tr> 
      <td align="right"><strong>Identificaci&oacute;n:&nbsp;</strong></td>
      <td><input name="PidEncar" readonly="true" type="text" id="PidEncar" tabindex="-1" size="50" maxlength="50"></td>
    </tr>
    <tr> 
      <td align="right" width="28%"><strong>Fecha de Nac.:&nbsp;</strong></td>
      <td><input name="FechaNacEncar" readonly="true" type="text" id="FechaNacEncar" tabindex="-1" size="25" maxlength="25"></td>
    </tr>
    <tr> 
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr> 
	  <cfif isdefined("form.persona") and form.persona NEQ "">
		<td colspan="2" align="center">
			<cf_botones names="Agregar,Limpiar" values="Agregar,Limpiar" tabindex="1">
		  </td>
      <cfelse>
  		<td colspan="2" align="center" class="SubTitulo">
          ** Seleccione un alumno de la lista inferior ** 
	    </td>
	   </cfif> 
    </tr>
  </table>
</form>

<script language="JavaScript" type="text/javascript" >
//---------------------------------------------------------------------	
	function doConlis() {
		//var vPersona = document.getElementById("persona");
		//alert(vPersona);
		popUpWindow("conlisEncar.cfm?form=formAgregaEncar"
					+"&NombreEncar=NombreEncar"
					+"&EEcodigo=EEcodigo"
					//+"&persona=" + vPersona.value 
					+"&persona=" + document.formAgregaEncar.persona.value 
					+"&PdireccionEncar=PdireccionEncar"
					+"&PidEncar=PidEncar"
					+"&FechaNacEncar=FechaNacEncar"
					+"&Ecodigo=Ecodigo",250,200,650,350);
	} 
</script> 

