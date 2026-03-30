
<cfset listaCod= ArrayNew(1)>
<cfif isdefined("form.Usucodigo") and  len(trim(form.Usucodigo)) NEQ 0 >
	<cfset codigos=form.Usucodigo>
	<cfset listaCod=codigos.split(',')>
</cfif>


<table border="0" width="100%"  cellspacing="0" cellpadding="0">
<tr>
<td>&nbsp;</td>
<td>
<fieldset>
	<legend>B&uacute;squeda de Usuarios</legend>
	<cfoutput>
	<form action="" method="post" name="formBusquedaUsucodigo">
    <input type="hidden" name="Usucodigo" value="<cfif isdefined("form.Usucodigo") and  len(trim(form.Usucodigo)) NEQ 0 >#form.Usucodigo#</cfif>">
	<table border="0" width="100%"  cellspacing="0" cellpadding="0" class="AreaFiltro">
		  <tr>
			<td nowrap><strong>Login</strong></td>
			<td nowrap><strong>Nombre Usuario</strong></td>
			<td nowrap>&nbsp;</td>
		  </tr>
		  <tr>
			<td nowrap><input name="fUsulogin" type="text"></td>
			<td nowrap><input name="fUsunombre" type="text"></td>
			<td nowrap><input name="btnBuscar" type="submit" value="Buscar"></td>
		  </tr>
		 </table>
	</form>
	</cfoutput>
		<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
		<cfquery name="rsGetUsucodigo" datasource="asp">
			select distinct a.Usucodigo, a.Usulogin, Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre as Usunombre
			from Usuario a 
				inner join DatosPersonales info
				on a.datos_personales = info.datos_personales
				inner join vUsuarioProcesos b
				on a.Usucodigo = b.Usucodigo
				inner join Empresa c
				on b.Ecodigo = c.Ecodigo
				and c.Ereferencia = #session.Ecodigo#
				and c.CEcodigo = #session.CEcodigo#
			where a.Utemporal = 0
				and a.Uestado = 1
			<cfif (isdefined("form.fUsulogin") and len(trim(form.fUsulogin)))>
				and upper(a.Usulogin) like '%#Ucase(form.fUsulogin)#%'
			</cfif>
			<cfif (isdefined("form.fUsunombre") and len(trim(form.fUsunombre)))>
				and upper(Papellido1 #_Cat# ' ' #_Cat# Papellido2 #_Cat# ' ' #_Cat# Pnombre) like '%#Ucase(form.fUsunombre)#%'
			</cfif>
			order by a.Usulogin
		</cfquery>
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td width="5px" class="titulolistas">&nbsp;</td>
        <td width="20px"class="titulolistas"></td>
		<td width="45px" class="titulolistas"><strong>Login</strong></td>
		<td class="titulolistas"><strong>Nombre Usuario</strong></td>
	  </tr>
	 </table>
	<div style="overflow:auto; height: 320; width:350px; margin:0;">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <cfif rsGetUsucodigo.recordcount>
	  <cfoutput query="rsGetUsucodigo">
	  	<tr class="<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>"
			onmouseover="this.className='listaParSel';" 
			onmouseout="this.className='<cfif CurrentRow Mod 2 EQ 0>listaNon<cfelse>listaPar</cfif>';">
		<td width="5px"></td>
        <td width="30px">
        <input type="checkbox" value="#rsGetUsucodigo.Usucodigo#" id="id#rsGetUsucodigo.Usucodigo#" name="n#rsGetUsucodigo.Usucodigo#" onclick="javascript:addCodUs('#rsGetUsucodigo.Usucodigo#');"  /> </td>
		<td width="45px">#Usulogin#</td>
		<td >#Usunombre#</td>
	  </tr></cfoutput>
	  <cfelse>
	  <tr><td align="center" colspan="2"><strong>-- No se encontr&oacute; ning&uacute;n resultado --</strong></td></tr>
	  </cfif>
	</table>
	</div>
</fieldset>
</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td>&nbsp;</td>
<td>&nbsp;</td>
</tr>
<tr>
<td>&nbsp;</td>
<td align="center">    
	<cfoutput>
        <form action="exportar_User-form-SQL.cfm" method="post" name="formFoundUsucodigo" onsubmit="javascript:return validacion();">
            <input type="hidden" name="Usucodigo" value="<cfif isdefined("form.Usucodigo") and  len(trim(form.Usucodigo)) NEQ 0 >#form.Usucodigo#</cfif>">
             Formato:<select name="format" id="format">
             <option value="html">Texto</option>  
            	<option value="excel">Excel</option>                              
            </select><br /><br />
            <input type="submit" value="Exportar Permisos" />
            
        </form>
    </cfoutput>
</td>
<td>&nbsp;</td>
</tr>
</table>
<script>
function addCodUs(codUs)
{
	if(document.getElementById('id'+codUs).checked)
	{
		
		var element=document.getElementById("row"+codUs);
		if(document.getElementById("row"+codUs) !=null)
		{
			getElementByClass("row"+codUs,"");
			//document.formFoundUsucodigo.Usucodigo.value=document.formFoundUsucodigo.Usucodigo.value.split(","+codUs).join("");//para no repetir el codigo
			document.formFoundUsucodigo.Usucodigo.value+=","+codUs;//para exportar
			document.formBusquedaUsucodigo.Usucodigo.value+=","+codUs;//para buscar
			document.getElementById("id"+codUs).checked = 1;
		}else{
			alert("El usuario no tiene permisos asociados");
			document.getElementById("id"+codUs).checked = 0;
		}
		
	}else{
		var varRem=document.formFoundUsucodigo.Usucodigo.value;
		varRem=varRem.split(","+codUs).join("");//string.split(".").join(",");---///.replace(","+codUs);
		document.formFoundUsucodigo.Usucodigo.value=varRem;//para exportar para buscar
		document.formBusquedaUsucodigo.Usucodigo.value=varRem;//para buscar
		getElementByClass("row"+codUs,"none" );
	}
	
	var varRemd=document.formFoundUsucodigo.Usucodigo.value;
	
	if(varRemd!=null && varRemd!="")
	{
		document.getElementById("demo").style.display="none";
	}else{
		document.getElementById("demo").style.display="";
	}
}

var allHTMLTags = new Array();

function getElementByClass(theClass,disp ) 
{	
var allHTMLTags=document.getElementsByTagName("div");
	for (i=0; i<allHTMLTags.length; i++) {

		if (allHTMLTags[i].className==theClass) {
			allHTMLTags[i].style.display=disp;
		}
	}
}

function validacion()
{
	var varRem=document.formFoundUsucodigo.Usucodigo.value;
	if(varRem!=null && varRem!="")
	{
		return true;
	}else{
		alert('No se han Seleccionado Usuarios para Exportar');
		return false;
	}
	return false;
}
function mostrarPerf(codUs)
{
	if(document.getElementById('id'+codUs)!=null)//checkear si existen chek
	{
		document.getElementById("id"+codUs).checked = 1;		
	}
	if(document.getElementById("row"+codUs) !=null)//mostrar permisos si estan seleccionados
	{
		getElementByClass("row"+codUs,"");
		document.getElementById("demo").style.display="none";
	}
}
</script>
