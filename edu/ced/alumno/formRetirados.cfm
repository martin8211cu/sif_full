<cfif isdefined("form.persona")>

<cfquery datasource="#Session.Edu.DSN#" name="rsForm">
	Select convert(varchar,a.persona) as persona, a.Ecodigo,
	convert(varchar,a.CEcodigo) as CEcodigo, pe.Pnombre, pe.Papellido1, pe.Papellido2, 
	pe.Ppais, pe.TIcodigo, TInombre, Pid, 
	convert(varchar,Pnacimiento,103) Pnacimiento, Psexo, Pemail1, Pemail2, 
	Pdireccion, Pcasa, Pfoto, PfotoType, PfotoName, Pemail1validado
	from PersonaEducativo pe, TipoIdentificacion ti, Alumnos a
	where a.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
		and a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Ecodigo#">
		and pe.TIcodigo=ti.TIcodigo
		and a.persona=pe.persona
</cfquery>

<cfquery datasource="#Session.Edu.DSN#" name="rsPromociones">
	Select distinct PRcodigo=convert(varchar,pr.PRcodigo),
	PRdescripcion = pr.PRdescripcion + ' : ' + g.Gdescripcion, 
	SPEcodigo=convert(varchar,pv.SPEcodigo), convert(varchar,pr.Gcodigo)
	from Promocion pr, Nivel n, Grado g, PeriodoVigente pv
	where n.CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Edu.CEcodigo#">
	and pr.Gcodigo = g.Gcodigo
	and pr.Ncodigo = n.Ncodigo
	and pr.Ncodigo = pv.Ncodigo
	and pr.PEcodigo = pv.PEcodigo
	and pr.PRactivo = 1
	order by n.Norden,g.Gorden
</cfquery>

<form action="SQLRetirados.cfm" method="post" id="formAlumno" name="formAlumno">
<input name="persona" id="persona" value="<cfoutput>#rsForm.persona#</cfoutput>" type="hidden"> 
<input name="Ecodigo" id="Ecodigo" value="<cfoutput>#rsForm.Ecodigo#</cfoutput>" type="hidden"> 

<table width="100%" border="0" cellpadding="0" cellspacing="0">
<tr> 
  <td width="25%" rowspan="8" valign="middle" align="center">
	<table width="108" height="159" border="1">
    <tr> 
    <td width="102" align="center" valign="middle">
    	<cfif Len(rsForm.Pfoto) EQ 0>
        Fotograf&iacute;a no disponible 
        <cfelse>
		<!---
        <img src="/Upload/DownloadServlet/PersonaEducacionFoto?persona=<cfoutput>#rsForm.persona#</cfoutput>" 
			alt='<cfoutput>#rsForm.Pnombre#  #rsForm.Papellido1#  #rsForm.Papellido2#</cfoutput>' 
			align="middle" width="109" height="154" border="0">	
		--->
	    <cf_LoadImage tabla="PersonaEducativo" columnas="Pfoto as contenido, persona as codigo" condicion="persona=#rsForm.persona#" imgname="Foto" width="109" height="154" alt="#rsForm.Pnombre#  #rsForm.Papellido1#  #rsForm.Papellido2#">
        </cfif>
	</td>
    </tr>
    </table>
  </td>
  <td width="16%" class="subTitulo">Nombre</td>
  <td width="20%" class="subTitulo">Primer Apellido</td>
  <td width="29%" class="subTitulo">Segundo Apellido</td>
</tr>
<tr> 
  <td><cfoutput>#rsForm.Pnombre#</cfoutput></td>
  <td><cfoutput>#rsForm.Papellido1#</cfoutput></td>
  <td><cfoutput>#rsForm.Papellido2#</cfoutput></td>
</tr>
<tr> 
  <td class="subTitulo">Identificaci&oacute;n</td>
  <td class="subTitulo">Tipo Identificaci&oacute;n</td>
  <td class="subTitulo">Sexo</td>
</tr>
<tr> 
  <td><cfoutput>#rsForm.Pid#</cfoutput></td>
  <td><cfoutput>#rsForm.TInombre#</cfoutput></td>
  <td><cfoutput>#rsForm.Psexo#</cfoutput></td>
</tr>
<tr> 
  <td class="subTitulo"><font size="1">Fecha de Nacimiento</font></td>
  <td colspan="2" class="subTitulo">Direcci&oacute;n</td>
</tr>
<tr>
  <td><cfoutput>#rsForm.Pnacimiento#</cfoutput></td>
  <td colspan="2"><cfoutput>#rsForm.Pdireccion#</cfoutput></td>
</tr>
<tr>
	<td colspan="3"><hr></td>
</tr>
<tr>
  <td colspan="3">
  <input type="checkbox" name="checkActivar" id="checkActivar" 
  	value="1" onClick="javascript: cargarPromociones();">&nbsp;Activar&nbsp;&nbsp;
  <span id="divPromocion">
  <strong>Promoci&oacute;n</strong>&nbsp;
    <select name="PRcodigo">
	<cfoutput query="rsPromociones">
		<option value="#rsPromociones.PRcodigo#">#rsPromociones.PRdescripcion#</option>
	</cfoutput>
	</select>&nbsp;&nbsp;
  <input type="submit" name="btnAceptar" id="btnAceptar" 
  	value="Aceptar" onClick="javascript: setBtn(this);">
  </span>
  </td>
</tr>
</table>		
</form>

<script type="text/javascript">
function cargarPromociones() {
	if (formAlumno.checkActivar.checked) {
		parentPromocion.insertBefore(spanPromocion,nextPromocion);
	} else {
		parentPromocion.removeChild(spanPromocion);
	}
}

var spanPromocion = document.getElementById("divPromocion");
var parentPromocion = spanPromocion.parentNode;
var nextPromocion = spanPromocion.nextSibling;
spanPromocion.parentNode.removeChild(spanPromocion);
</script>

</cfif>