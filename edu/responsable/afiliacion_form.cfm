<cfinvoke 
 component="edu.Componentes.usuarios"
 method="get_usuario_by_cod"
 returnvariable="usr">
	<cfinvokeargument name="consecutivo" value="#Session.Edu.CEcodigo#"/>
	<cfinvokeargument name="sistema" value="edu"/>
	<cfinvokeargument name="Usucodigo" value="#Session.Edu.Usucodigo#"/>
	<cfinvokeargument name="Ulocalizacion" value="#Session.Ulocalizacion#"/>
	<cfinvokeargument name="roles" value="edu.encargado"/>
</cfinvoke>

<cfquery datasource="#Session.Edu.DSN#" name="rsHijosAfiliados">
	select g.Pnombre + ' ' + g.Papellido1 + ' ' + g.Papellido2 as Nombre, 
		   isnull(e.CAimpreso, -1) as CAimpreso, 
		   isnull(e.CArecibido, -1) as CArecibido, 
		   isnull(e.CAenviada, -1) as CAenviada, 
		   convert(varchar, f.Usucodigo) as Usucodigo, f.Ulocalizacion, f.Usulogin, 
		   convert(varchar, c.Ecodigo) as Ecodigo, 
		   case when f.Usucodigo is null then -1 else convert(smallint, f.Usutemporal) end as Usutemporal
	from Encargado a, EncargadoEstudiante b, Estudiante c, Alumnos d, ContratoAdhesion e, Usuario f, PersonaEducativo g
	<!--- MODIFICADO POR YU 10 Agosto 2005 --->
	<!---
	where a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.Usucodigo#">
	and a.Ulocalizacion = <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
	--->
	where a.EEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#usr.num_referencia#">
	and a.EEcodigo = b.EEcodigo
	and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and b.Ecodigo = c.Ecodigo
	and c.Ecodigo = d.Ecodigo
	and d.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and d.Aretirado = 0
	and d.Ecodigo *= e.CAauxid
	and e.CAusertype= 'Estudiante'
	and e.CAambito = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and c.Usucodigo *= f.Usucodigo
	and c.Ulocalizacion *= f.Ulocalizacion
	and c.persona = g.persona
	order by 1
</cfquery>

<script language="JavaScript" type="text/javascript">
	function doAction(ctl) {
		var accion = ctl.value.split("$")[0];
		var divcorreo = document.getElementById("divcorreo_"+ctl.value.split("$")[1]+"_"+ctl.value.split("$")[2]);
		if (accion == 0) {
			divcorreo.style.display = "";
		} else {
			divcorreo.style.display = "none";
		}
	}
</script>

<cfif rsHijosAfiliados.recordCount GT 0>
  <form name="formAfiliacion" action="/jsp/sdc/adm/usu/Afiliacion.jsp" method="post">
  <table align="center" width="95%" border="0" style="padding-left: 10px; padding-right: 10px" cellspacing="0" cellpadding="2">
    <tr> 
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr> 
        <td colspan="4" style="font-size: 12pt"><b>A trav&eacute;s de este proceso 
          usted puede crear una cuenta de acceso al portal para su(s) hijo(s), 
          reenviar el usuario y la contrase&ntilde;a en caso de no haberla recibido 
          o revocarle el acceso al portal a su(s) hijo(s). Escoja la operaci&oacute;n 
          que desea realizar</b></td>
    </tr>
    <tr> 
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr> 
        <td width="15%" style="border-bottom: solid #000000 1px "><strong>Operaci&oacute;n</strong></td>
      <td width="40%" style="border-bottom: solid #000000 1px "><strong>Alumno</strong></td>
      <td width="30%" style="border-bottom: solid #000000 1px ">&nbsp;</td>
      <td width="15%" style="border-bottom: solid #000000 1px "><strong>Estado</strong></td>
    </tr>
    <cfloop query="rsHijosAfiliados">
      <cfoutput> 
        <tr> 
          <td <cfif CurrentRow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> width="10%"> 
            <select name="accion" onChange="javascript: doAction(this);">
              <option value="-1$#Session.Edu.CEcodigo#$#Ecodigo#">(Ninguna acci&oacute;n)</option>
			  <cfif Usutemporal EQ -1>
              <option value="0$#Session.Edu.CEcodigo#$#Ecodigo#">Generar y enviar usuario y contrase&ntilde;a</option>
			  <cfelseif Usutemporal EQ 0>
              <option value="1$#Session.Edu.CEcodigo#$#Ecodigo#">Revocar acceso al portal</option>
			  </cfif>
			  <cfif Usutemporal NEQ -1>
              <option value="2$#Session.Edu.CEcodigo#$#Ecodigo#">Reenv&iacute;o de usuario y contrase&ntilde;a</option>
			  </cfif>
            </select>
          </td>
          <td <cfif CurrentRow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> width="30%" nowrap>#Nombre#</td>
          <td <cfif CurrentRow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> width="40%" nowrap>
				<cfif Usulogin NEQ "">Usuario: #Usulogin#</cfif>
				<div id="divcorreo_#Session.Edu.CEcodigo#_#Ecodigo#" style="display: none">
					E-mail: <input type="text" name="email_#Session.Edu.CEcodigo#_#Ecodigo#" size="40" maxlength="50" value="">
				</div>
		  </td>
          <td <cfif CurrentRow mod 2>class="listaPar"<cfelse>class="listaNon"</cfif> width="20%" nowrap>
		  	<cfif Usutemporal EQ -1>
				Sin Contrato
			<cfelseif Usutemporal EQ 1>
				Usuario Temporal
			<cfelse>
				Usuario Activo
			</cfif>
		  </td>
        </tr>
      </cfoutput> 
    </cfloop>
    <tr>
      <td colspan="4" style="border-top: solid #000000 1px ">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4" align="center"> 
        <input name="btnEjecutar" type="submit" id="btnEjecutar" value="Aceptar">
      </td>
    </tr>
    <tr>
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4" style="text-decoration: underline; font-size: 12pt"><b>migestion.net para 
        estudiantes!!</b></td>
    </tr>
    <tr>
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4"> Los estudiantes encontrar&aacute;n en <strong>migestion.net 
        - Expediente Estudiantil</strong>, la principal herramienta a utilizar 
        en su proceso formativo, lo que le permite tener: </td>
    </tr>
    <tr> 
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr valign="middle">
      <td colspan="4"><img src="../Imagenes/marca.gif" width="8" height="15"> 
        Disponibilidad del Programa de Estudios</td>
    </tr>
    <tr valign="middle">
      <td colspan="4"><img src="../Imagenes/marca.gif" width="8" height="15"> 
        Posibilidad de realizar foros de discusi&oacute;n y estudio</td>
    </tr>
    <tr valign="middle">
      <td colspan="4"><img src="../Imagenes/marca.gif" width="8" height="15"> 
        Consulta de calificaciones, actividades, noticias, etc.</td>
    </tr>
    <tr valign="middle">
      <td colspan="4"><img src="../Imagenes/marca.gif" width="8" height="15"> 
        Comunicaci&oacute;n directa con los profesores... y mucho m&aacute;s...</td>
    </tr>
    <tr>
      <td colspan="4">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="4" align="right">&nbsp;</td>
    </tr>
  </table>
</form>
</cfif>
