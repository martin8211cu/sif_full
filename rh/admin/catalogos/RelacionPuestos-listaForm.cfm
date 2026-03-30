<cfif isdefined("Url.HYERVfecha") and not isdefined("Form.HYERVfecha")>
	<cfset Form.HYERVfecha = Url.HYERVfecha>
</cfif>
<cfif isdefined("Url.HYERVfechaalta") and not isdefined("Form.HYERVfechaalta")>
	<cfset Form.HYERVfechaalta = Url.HYERVfechaalta>
</cfif>
<cfif isdefined("Url.Usuario") and not isdefined("Form.Usuario")>
	<cfset Form.Usuario = Url.Usuario>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario NEQ "-1">
	<cfset a = ListToArray(Form.Usuario, '|')>
	<cfset filtro = " and a.Usucodigo = " & a[1]>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & Form.Usuario>
<cfelseif not (isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1")>
	<cfset Form.Usuario = Session.Usucodigo>
	<cfset filtro = " and a.Usucodigo = " & Session.Usucodigo>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & Form.Usuario>
<cfelseif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & "-1">
</cfif>

<cfif isdefined("Form.HYERVfecha") and Len(Trim(Form.HYERVfecha)) NEQ 0>
<!---<cfset filtro = filtro & " and a.HYERVfecha = convert(datetime, '" & Form.HYERVfecha & "', 103)" >--->
<!---	<cfset filtro = filtro & " and CPdesde >= " & lsparsedatetime(form.fCPdesde) & "">--->
	<cfset filtro = filtro & " and a.HYERVfecha = " & lsparsedatetime(Form.HYERVfecha) & " " >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HYERVfecha=" & Form.HYERVfecha>
</cfif>
<cfif isdefined("Form.HYERVfechaalta") and Len(Trim(Form.HYERVfechaalta)) NEQ 0>
<!---<cfset filtro = filtro & " and convert(datetime, convert(varchar, a.HYERVfechaalta, 103), 103) = convert(datetime, '" & Form.HYERVfechaalta & "', 103)" >--->
	<cfset filtro = filtro & "and a.HYERVfechaalta >" & LSParseDateTime(LSDATEFORMAT(Form.HYERVfechaalta,"DD/MM/YYYY"))  >
	<cfset filtro = filtro & "and a.HYERVfechaalta <" &  dateadd("d",+1, LSParseDateTime(LSDATEFORMAT(Form.HYERVfechaalta,"DD/MM/YYYY")) ) >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "HYERVfechaalta=" & Form.HYERVfechaalta>
</cfif>

<!--- Lista de Usuarios que han registrado valoraciones de puestos --->
<cfquery name="rsUsuariosRegistro" datasource="#Session.DSN#">
	select distinct Usucodigo
	from HYERelacionValoracion
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsUsuarios" datasource="asp">
	select u.Usucodigo as Codigo,
			{fn concat(d.Pnombre, {fn concat(' ', {fn concat(d.Papellido1, {fn concat(' ', d.Papellido2)})})})} as Nombre
	from Usuario u, DatosPersonales d
	<cfif rsUsuariosRegistro.recordCount GT 0>
	where u.Usucodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" separator="," value="#ValueList(rsUsuariosRegistro.Usucodigo, ',')#">)
	<cfelse>
	where u.Usucodigo = 0
	</cfif>
	and u.datos_personales = d.datos_personales
</cfquery> 

<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//utiles</script>
<script language="javascript" type="text/javascript">
	function funcNuevo() {
		document.listaAumentos.HYERVID.VALUE = "";
	}
</script>

<cfoutput>
<form name="filtroAumentos" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0; ">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="tituloListas">
  <tr> 
    <td class="fileLabel"><cf_translate key="LB_FechaDeVigencia">Fecha de Vigencia</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_FechaDeRegistro">Fecha de Registro</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_UsuarioQueRegistro">Usuario que Registr&oacute;</cf_translate></td>
    <td class="fileLabel">&nbsp;</td>
  </tr>
  <tr>
    <td>
		<cfif isdefined("Form.HYERVfecha")>
			<cfset fechadesde = Form.HYERVfecha>
		<cfelse>
			<cfset fechadesde = "">
		</cfif>
		<cf_sifcalendario name="HYERVfecha" form="filtroAumentos" value="#fechadesde#" tabindex="1">
	</td>
    <td>
		<cfif isdefined("Form.HYERVfechaalta")>
			<cfset fechareg = Form.HYERVfechaalta>
		<cfelse>
			<cfset fechareg = "">
		</cfif>
		<cf_sifcalendario name="HYERVfechaalta" form="filtroAumentos" value="#fechareg#" tabindex="1">
	</td>
    <td>
	  <select name="Usuario" tabindex="1">
		  <option value="-1" <cfif Form.Usuario EQ "-1">selected</cfif>>(<cf_translate key="LB_Todos" XmlFile="/rh/generales.xml">Todos</cf_translate>)</option>
		<cfloop query="rsUsuarios">
		  <option value="#rsUsuarios.Codigo#" <cfif Form.Usuario EQ rsUsuarios.Codigo>selected</cfif>>#rsUsuarios.Nombre#</option>
		</cfloop>
	  </select>
	</td>
	<td align="center">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Filtrar"
			Default="Filtrar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Filtrar"/>
	
		<input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#" tabindex="1">
	</td>
  </tr>
</table>
</form>
</cfoutput>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="border-bottom: 1px solid black"><strong><cf_translate key="LB_ListaDeRelacionesDeValoracionDePuestos">Lista de Relaciones de Valoración de Puestos</cf_translate>: </strong></td>
  </tr>
  <tr>
    <td>
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="LB_Descripcion"
			Default="Descripci&oacute;n"
			XmlFile="/rh/generales.xml"
			returnvariable="LB_Descripcion"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_FechaDeVigencia"
				Default="Fecha de Vigencia"
				returnvariable="LB_FechaDeVigencia"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="LB_FechaDeRegistro"
				Default="Fecha de Registro"
				returnvariable="LB_FechaDeRegistro"/>
			<cfinvoke component="sif.Componentes.Translate"
				method="Translate"
				Key="MSG_NoHayNigunaRelacionDeValoracionDePuestosPendientePorAaplicar"
				Default="No hay niguna relación de valoración de puestos pendiente por aplicar"
				returnvariable="MSG_NoHayNigunaRelacionDeValoracionDePuestosPendientePorAaplicar"/>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="HYERelacionValoracion a"/>
<!---		<cfinvokeargument name="columnas" value="HYERVid, HYERVdescripcion, convert(varchar, HYERVfecha, 103) as fvigencia, HYERVestado, Usucodigo, convert(varchar, HYERVfechaalta, 103) as fregistro"/>--->
			<cfinvokeargument name="columnas" value="HYERVid, HYERVdescripcion, HYERVfecha as fvigencia, HYERVestado, Usucodigo, HYERVfechaalta as fregistro"/>
			<cfinvokeargument name="desplegar" value="HYERVdescripcion, fvigencia, fregistro"/>
			<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_FechaDeVigencia#, #LB_FechaDeRegistro#"/>
			<cfinvokeargument name="formatos" value="V,D,D"/>
			<cfinvokeargument name="filtro" value=" a.Ecodigo = #Session.Ecodigo# 
													#filtro#
													and a.HYERVestado = 0
													order by a.HYERVfecha, a.HYERVfechaalta"/>
			<cfinvokeargument name="align" value="left, center, center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="botones" value="Nuevo"/>
			<cfinvokeargument name="irA" value="RelacionPuestos-listaSql.cfm"/>
			<cfinvokeargument name="keys" value="HYERVid"/>
			<cfinvokeargument name="MaxRows" value="0"/>
			<cfinvokeargument name="formName" value="listaAumentos"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
			<cfinvokeargument name="EmptyListMsg" value="-- #MSG_NoHayNigunaRelacionDeValoracionDePuestosPendientePorAaplicar# --"/>
		</cfinvoke>
	</td>
  </tr>
</table>
