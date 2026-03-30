<!---<cf_dump var="#url#">--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Activos"
	xmlfile="/sif/rh/generales.xml"	
	Default="Activos"
	returnvariable="vActivos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Inactivos"
	xmlfile="/sif/rh/generales.xml"	
	Default="Inactivos"
	returnvariable="vInactivos"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Todos"
	xmlfile="/sif/rh/generales.xml"	
	Default="Todos"
	returnvariable="vTodos"/>			
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	key="LB_Estado"
	xmlfile="/sif/rh/generales.xml"	
	Default="Estado"
	returnvariable="vEstado"/>

<html>
<head>
<title><cf_translate key="LB_ListadeEmpleados">Lista de Empleados</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>


<cfif isdefined("Url.DSN") and not isdefined("Form.DSN")>
	<cfparam name="Form.DSN" default="#Url.DSN#">
</cfif>
<cfif isdefined("session.DSN") and not isdefined("form.DSN")>
	<cfparam name="Form.DSN" default="#session.DSN#">
</cfif>

<cfif isdefined("Url.Ecodigo") and not isdefined("Form.Ecodigo")>
	<cfparam name="Form.Ecodigo" default="#Url.Ecodigo#">
</cfif>
<cfif isdefined("session.Ecodigo") and not isdefined("form.Ecodigo")>
	<cfparam name="Form.Ecodigo" default="#session.Ecodigo#">
</cfif>


<cfif isdefined("Url.f") and not isdefined("Form.f")>
	<cfparam name="Form.f" default="#Url.f#">
</cfif>
<cfif isdefined("Url.p1") and not isdefined("Form.p1")>
	<cfparam name="Form.p1" default="#Url.p1#">
</cfif>
<cfif isdefined("Url.p2") and not isdefined("Form.p2")>
	<cfparam name="Form.p2" default="#Url.p2#">
</cfif>
<cfif isdefined("Url.p3") and not isdefined("Form.p3")>
	<cfparam name="Form.p3" default="#Url.p3#">
</cfif>
<cfif isdefined("Url.p4") and not isdefined("Form.p4")>
	<cfparam name="Form.p4" default="#Url.p4#">
</cfif>
<cfif isdefined("Url.p5") and not isdefined("Form.p5")>
	<cfparam name="Form.p5" default="#Url.p5#">
</cfif>

<cfif isdefined("Url.shid") and not isdefined("Form.shid")>
	<cfparam name="Form.shid" default="#Url.shid#">
</cfif>
<cfif isdefined("Url.tarjeta") and not isdefined("Form.tarjeta")>
	<cfparam name="Form.tarjeta" default="#Url.tarjeta#">
</cfif>
<cfif isdefined("Url.valus") and not isdefined("Form.valus")>
	<cfparam name="Form.valus" default="#Url.valus#">
</cfif>
<cfif isdefined("Url.valcomp") and not isdefined("Form.valcomp")>
	<cfparam name="Form.valcomp" default="#Url.valcomp#">
</cfif>
<cfif isdefined("Url.valemp") and not isdefined("Form.valemp")>
	<cfparam name="Form.valemp" default="#Url.valemp#">
</cfif>
<cfif isdefined("Url.valasoc") and not isdefined("Form.valasoc")>
	<cfparam name="Form.valasoc" default="#Url.valasoc#">
</cfif>
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.NTIcodigo") and not isdefined("Form.NTIcodigo")>
	<cfparam name="Form.NTIcodigo" default="#Url.NTIcodigo#">
</cfif>
<cfif isdefined("Url.CFid") and not isdefined("Form.CFid")>
	<cfparam name="Form.CFid" default="#Url.CFid#">
</cfif>
<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.Ftarjeta") and not isdefined("Form.Ftarjeta")>
	<cfparam name="Form.Ftarjeta" default="#Url.Ftarjeta#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>
<cfif isdefined("Url.estadoFiltro") and not isdefined("Form.estadoFiltro")>
	<cfparam name="Form.estadoFiltro" default="#Url.estadoFiltro#">
</cfif>
<cfif isdefined("Url.FuncJSalCerrar") and not isdefined("Form.FuncJSalCerrar")>
	<cfparam name="Form.FuncJSalCerrar" default="#Url.FuncJSalCerrar#">
</cfif>

<cfif isdefined("Url.JefeDEid") and not isdefined("Form.JefeDEid")>
	<cfparam name="Form.JefeDEid" default="#Url.JefeDEid#">
</cfif>

<script language="JavaScript" type="text/javascript">
function trim(dato) {
	dato = dato.replace(/^\s+|\s+$/g, '');
	return dato;
}

function Asignar(id, tipo, ced, emp, usucodigo) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Form.f#.#Form.p1#.value = id;
		window.opener.document.#Form.f#.#Form.p3#.value = trim(ced);
		window.opener.document.#Form.f#.#Form.p4#.value = emp;
		if (window.opener.document.#Form.f#.#Form.p2#.options != null) {
			for (var i = 0; i < window.opener.document.#Form.f#.#Form.p2#.options.length; i++) {
				if (window.opener.document.#Form.f#.#Form.p2#.options[i].value == tipo) {
					window.opener.document.#Form.f#.#Form.p2#.options.selectedIndex = i;
				}
			}
		}
		
		if (usucodigo != null) {
			if (window.opener.document.#Form.f#.#Form.p5#) window.opener.document.#Form.f#.#Form.p5#.value = usucodigo;
		}

		if (window.opener.funcDEid){ window.opener.funcDEid(); }
		var funcName = 'window.opener.func'+id;
		if (eval(funcName)){ eval(funcName)(); }
		<cfif isdefined('form.FuncJSalCerrar') and len(trim(form.FuncJSalCerrar))>
			window.opener.#form.FuncJSalCerrar#;
		</cfif>
		</cfoutput>

		window.close();
	}
}
</script>

<cfset navegacion = "">
<cfif isdefined("Form.shid") and Len(Trim(Form.shid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "shid=" & Form.shid>
</cfif>
<cfif isdefined("Form.tarjeta") and Len(Trim(Form.tarjeta)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "tarjeta=" & Form.tarjeta>
</cfif>
<cfif isdefined("Form.valus") and Len(Trim(Form.valus)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "valus=" & Form.valus>
</cfif>
<cfif isdefined("Form.valcomp") and Len(Trim(Form.valcomp)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "valcomp=" & Form.valcomp>
</cfif>
<cfif isdefined("Form.valemp") and Len(Trim(Form.valemp)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "valemp=" & Form.valemp>
</cfif>
<cfif isdefined("Form.valasoc") and Len(Trim(Form.valasoc)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "valasoc=" & Form.valasoc>
</cfif>
<cfif isdefined("Form.DEid") and Len(Trim(Form.DEid)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
</cfif>
<cfif isdefined("Form.NTIcodigo") and Len(Trim(Form.NTIcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "NTIcodigo=" & Form.NTIcodigo>
</cfif>
<!--- El centro funcional puede ir vacio --->
<cfif isdefined("Form.CFid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CFid=" & Form.CFid>
</cfif>
<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
</cfif>
<cfif isdefined("Form.Ftarjeta") and Len(Trim(Form.Ftarjeta)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ftarjeta=" & Form.Ftarjeta>
</cfif>
<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
</cfif>
<cfif isdefined("Form.estadoFiltro") and Len(Trim(Form.estadoFiltro)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "estadoFiltro=" & Form.estadoFiltro>
</cfif>

<cfif isdefined("Form.f")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f=" & Form.f>
</cfif>
<cfif isdefined("Form.p1")>


	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p1=" & Form.p1>
</cfif>
<cfif isdefined("Form.p2")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p2=" & Form.p2>
</cfif>
<cfif isdefined("Form.p3")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p3=" & Form.p3>
</cfif>
<cfif isdefined("Form.p4")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p4=" & Form.p4>
</cfif>
<cfif isdefined("Form.p5")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p5=" & Form.p5>
</cfif>
<!----------------------------------------->
<cfif isdefined("Form.DSN")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DSN=" & Form.DSN>
</cfif>

<cfif isdefined("Form.Ecodigo")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ecodigo=" & Form.Ecodigo>
</cfif>
<cfif isdefined("form.FuncJSalCerrar") and len(trim("Form.FuncJSalCerrar"))>
	<cfset navegacion = navegacion & "&FuncJSalCerrar=#Form.FuncJSalCerrar#">
</cfif>
<cfif isdefined("form.JefeDEid") and len(trim("Form.JefeDEid"))>
	<cfset navegacion = navegacion & "&JefeDEid=#Form.JefeDEid#">
</cfif>



<cfoutput>
<form name="filtroEmpleado" method="post" action="#CurrentPage#">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="p3" value="#Form.p3#">
<input type="hidden" name="p4" value="#Form.p4#">
<input type="hidden" name="p5" value="#Form.p5#">
<input type="hidden" name="shid" value="<cfif isdefined("Form.shid")>#Form.shid#</cfif>">
<input type="hidden" name="valus" value="<cfif isdefined("Form.valus")>#Form.valus#</cfif>">
<input type="hidden" name="valcomp" value="<cfif isdefined("Form.valcomp")>#Form.valcomp#</cfif>">
<input type="hidden" name="valemp" value="<cfif isdefined("Form.valemp")>#Form.valemp#</cfif>">
<input type="hidden" name="valasoc" value="<cfif isdefined("Form.valasoc")>#Form.valasoc#</cfif>">
<input type="hidden" name="DEid" value="<cfif isdefined("Form.DEid")>#Form.DEid#</cfif>">
<input type="hidden" name="NTIcodigo" value="<cfif isdefined("Form.NTIcodigo")>#Form.NTIcodigo#</cfif>">

<input type="hidden" name="DSN" value="<cfif isdefined("Form.DSN")>#Form.DSN#</cfif>">
<input type="hidden" name="Ecodigo" value="<cfif isdefined("Form.Ecodigo")>#Form.Ecodigo#</cfif>">
<cfif isdefined("form.FuncJSalCerrar") and len(trim(form.FuncJSalCerrar))>
	<input type="hidden" name="FuncJSalCerrar" value="#form.FuncJSalCerrar#">
</cfif>
<cfif isdefined("form.JefeDEid") and len(trim(form.JefeDEid))>
	<input type="hidden" name="JefeDEid" value="#form.JefeDEid#">
</cfif>


<cfif isdefined("Form.tarjeta")>
	<input type="hidden" name="tarjeta" value="1">
</cfif>
<cfif isdefined("Form.CFid")>
<input type="hidden" name="CFid" value="#Form.CFid#">
</cfif>
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="tituloListas">
  <tr> 
    <td align="left"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></td>
	
	<cfif isdefined("form.tarjeta")>
		<td align="left"><cf_translate key="LB_ID_Tarjeta">Id Tarjeta</cf_translate></td>	
	</cfif>	
	
    <td align="left"><cf_translate key="LB_Nombre">Nombre</cf_translate></td>
	<td><cfoutput>#vEstado#</cfoutput></td>
    <td rowspan="2" align="center" valign="middle">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Filtrar"
			Default="Filtrar"
			XmlFile="/sif/rh/generales.xml"
			returnvariable="BTN_Filtrar"/>

      <input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#" tabindex="1">
    </td>
  </tr>
  <tr> 
    <td> 
      <input name="FDEidentificacion" type="text" id="FDEidentificacion" tabindex="1" size="15" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>">
    </td>
	<cfif isdefined("Form.tarjeta")>
		<td> 
		  <input name="Ftarjeta" type="text" id="Ftarjeta" tabindex="1" size="15" maxlength="60" value="<cfif isdefined("Form.Ftarjeta")>#Form.Ftarjeta#</cfif>">
		</td>
	</cfif>
    <td> 
      <input name="FDEnombre" type="text" id="FDEnombre" tabindex="1" size="30" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>">
    </td>
	<td>
		<select name="estadoFiltro" id="estadoFiltro">
			<cfoutput>
			<option value="T" <cfif isdefined("form.estadoFiltro") and form.estadoFiltro eq 'T'>selected</cfif>>#vTodos#</option>
			<option value="A" <cfif isdefined("form.estadoFiltro") and form.estadoFiltro eq 'A'>selected</cfif>>#vActivos#</option>
			<option value="I" <cfif isdefined("form.estadoFiltro") and form.estadoFiltro eq 'I'>selected</cfif>>#vInactivos#</option>														
			</cfoutput>
		</select>
	</td>
  </tr>
</table>
</form>
</cfoutput>

<cfquery name="rsListaEmpleados" datasource="#session.DSN#">
	select a.DEid, 
		   a.NTIcodigo, 
		   a.DEidentificacion, 
		   a.DEtarjeta, 		   
		   {fn concat ( {fn concat ( {fn concat ( {fn concat (  a.DEapellido1  , ' ' )}, a.DEapellido2 )}, ', ' )}, a.DEnombre )} as NombreCompleto
		<cfif Form.valus EQ 1>
		 , b.Usucodigo
		</cfif>
	from DatosEmpleado a
	
	<cfif Form.valemp EQ 1>
		inner join LineaTiempo lt
			on lt.DEid = a.DEid
			and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.LTdesde and lt.LThasta
	</cfif>

	<cfif Form.valasoc EQ 1>
		inner join ACAsociados asoc
			on asoc.DEid = a.DEid
			and asoc.ACAestado = 1
	</cfif>

	<cfif Form.valus EQ 1>
		inner join UsuarioReferencia b
			on <cf_dbfunction name="to_number" args="b.llave"> = a.DEid
			and b.llave = <cf_dbfunction name="to_char" args="a.DEid">
			and b.Ecodigo = 1116 <!---<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">--->
			and b.STabla = 'DatosEmpleado'

		inner join Usuario c
			on c.Usucodigo = b.Usucodigo
			and c.Uestado = 1 
			and c.Utemporal = 0
			
		inner join DatosPersonales d
			on d.datos_personales = c.datos_personales
			and d.Pid = a.DEidentificacion
	</cfif>

	<cfif isdefined("Form.CFid") and Len(Trim(Form.CFid))>
		<cfif Form.valemp NEQ 1>
			inner join LineaTiempo lt
				on lt.DEid = a.DEid
				and <cfqueryparam cfsqltype="cf_sql_date" value="#Now()#"> between lt.LTdesde and lt.LThasta
		</cfif>
			
		inner join RHPlazas p
			on p.RHPid = lt.RHPid
			and p.CFid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFid#">
	</cfif>

	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	<cfif isdefined("Form.NTIcodigo") and Len(Trim(Form.NTIcodigo)) NEQ 0>
		and a.NTIcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(Form.NTIcodigo)#">
	</cfif>
	<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
		and upper(a.DEidentificacion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FDEidentificacion)#%">
	</cfif>
	<cfif isdefined("form.Ftarjeta") and len(trim(form.Ftarjeta))>
		and upper(a.DEtarjeta) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.Ftarjeta)#%">
	</cfif>		
	
	<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
		and upper({fn concat ( {fn concat ( {fn concat ( {fn concat ( a.DEapellido1 , ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre )}) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FDEnombre)#%">
	</cfif>
	<cfif Form.valcomp EQ 1>
		and exists (
			select 1
			from RolEmpleadoSNegocios x
			where x.RESNtipoRol = 2
			and x.DEid = a.DEid
			and x.Ecodigo = a.Ecodigo
		)
	</cfif>
	
	<cfif isdefined("Form.estadoFiltro") and listfind('A,I', form.estadoFiltro) >
		and <cfif Form.estadoFiltro eq 'I'>not</cfif> exists (	select 1
																from LineaTiempo lt
																where lt.DEid = a.DEid
																  and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between lt.LTdesde and lt.LThasta )
	</cfif>
	
	order by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre
</cfquery>

<!---Filtra por los empleados subalternos al Jefe--->
<cfif isdefined("form.JefeDEid") and len(trim(form.JefeDEid))>
	<cfset rsSubalternos= getSubalternos(form.JefeDEid)>
	
	<cfset subAltList = 0>
	<cfif rsSubalternos.RecordCount gt 0 and len(trim(rsSubalternos.DEid))>
		<cfset subAltList = ValueList(rsSubalternos.DEid)>
	</cfif>
	<cfquery dbtype="query" name="rsListaEmpleados">
		select * 
		from rsListaEmpleados
		where DEid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes"  value="#subAltList#">)
		or DEid = #form.JefeDEid#	<!---incluye al jefe en la lista sin importar si el jefe no sea su propi--->
	</cfquery>
</cfif>

<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificaci&oacute;n"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreCompleto"
	Default="Nombre Completo"
	returnvariable="LB_NombreCompleto"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_IDTarjeta"
	Default="Id Tarjeta"
	returnvariable="LB_tarjeta"/>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsListaEmpleados#"/>

	<cfinvokeargument name="conexion" value="#form.DSN#"/>

<!---	<cfif Form.shid EQ 1>
		<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto"/>
		<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_NombreCompleto#"/>
		<cfinvokeargument name="align" value="left, left"/>
	<cfelse>
		<cfinvokeargument name="desplegar" value="NombreCompleto"/>
		<cfinvokeargument name="etiquetas" value="#LB_NombreCompleto#"/>
		<cfinvokeargument name="align" value="left"/>
	</cfif>
--->	

	<cfif isdefined("form.tarjeta")>
		<cfinvokeargument name="desplegar" value="DEidentificacion, DEtarjeta, NombreCompleto"/>
		<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_tarjeta#, #LB_NombreCompleto#"/>
		<cfinvokeargument name="align" value="left, left, left"/>
	<cfelse>
		<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto"/>
		<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_NombreCompleto#"/>
		<cfinvokeargument name="align" value="left, left"/>
	</cfif>

	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="conlisEmpleados.cfm"/>
	<cfinvokeargument name="formName" value="listaEmpleados"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfif Form.valus EQ 1>
		<cfinvokeargument name="fparams" value="DEid, NTIcodigo, DEidentificacion, NombreCompleto, Usucodigo"/>
	<cfelse>
		<cfinvokeargument name="fparams" value="DEid, NTIcodigo, DEidentificacion, NombreCompleto"/>
	</cfif>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>



<!--- ***************************************************************** --->
	<!--- Averiguar quienes son los subalternos de un Jefe u Autorizador --->
<!--- ***************************************************************** --->

<cffunction access="public" name="getSubalternos" returntype="any">
	<cfargument name="JefeDEid" required="no" type="numeric">
	<cfargument name="incluirJefesCFhijos" required="no" type="numeric" default="1"><!---incluye o no como subalternos a los jefes de los centros funcionales --->
	<cfargument name="incluirDEid" required="no" type="numeric" default="1">		<!---incluye o no al jefe en la lista de subalternos--->
	
		<!---Centros funcionales de los que el usuario es jefe u autorizador--->
			<cfquery datasource="#Session.DSN#" name="rsCFJefeAutorizador">
				
				<!---Autorizador--->	
				select cfa.CFid
					from CFautoriza cfa
						inner join Usuario a
						on  a.Usucodigo = cfa.Usucodigo 
						and a.Uestado = 1 
						and a.Utemporal = 0
						and a.CEcodigo = #Session.CEcodigo#
					
					where cfa.Ecodigo = #session.Ecodigo# 
						and cfa.Usucodigo = #session.usucodigo#
				Union 
					<!---Ocupante de plaza jefe del centro funcional--->
					select b.CFid
					from LineaTiempo a
					inner join RHPlazas b
						on b.RHPid = a.RHPid
					inner join CFuncional c
						on c.RHPid = b.RHPid
					where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.JefeDEid#">	
						and getDate() between a.LTdesde and a.LThasta 
				Union 
					<!---Ocupante de plaza jefe del centro funcional--->
					select b.CFid
					from DLaboralesEmpleado a
					inner join RHPlazas b
						on b.RHPid = a.RHPid
					inner join CFuncional c
						on c.RHPid = b.RHPid
					where a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.JefeDEid#">	
						and getDate() between a.DLfvigencia and a.DLffin
				Union 
					<!---Usuario del centro fincional--->
					select c.CFid
					from CFuncional c
					where c.CFuresponsable = #session.usucodigo#
					
				Union 
					<!---usuarios del centro funcional--->
					select d.CFid
					from UsuarioCFuncional d
					where d.Usucodigo = #session.usucodigo#		
						
			</cfquery>
			
			<cfquery dbtype="query" name="rsCFs">
				select distinct CFid from rsCFJefeAutorizador
			</cfquery>
			
			<cfset CFids = 0>
			<cfif rsCFs.RecordCount gt 0>
				<cfset CFids = valueList(rsCFs.CFid)>
			</cfif>
			
			<!---Busca subalternos del(os) CF(s) del que es Jefe o Autorizador--->
			<cfquery datasource="#Session.DSN#" name="rsSubalternosAll">
				select c.DEid, c.DEnombre,c.DEapellido1,c.DEapellido2
				from RHPlazas a
					inner join LineaTiempo b
					on  b.RHPid = a.RHPid 
					and getDate() between b.LTdesde and b.LThasta  
					
					inner join DatosEmpleado c
					on b.DEid = c.DEid
				where a.CFid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#CFids#">) 
				Union
				select c.DEid, c.DEnombre,c.DEapellido1,c.DEapellido2			<!---incluye empleados que por alguna razon no se encuentren en la linea del tiempo con la plaza indicada--->
				from RHPlazas a
					inner join DLaboralesEmpleado b
					on  b.RHPid = a.RHPid 
					and getDate() between b.DLfvigencia and b.DLffin  
					
					inner join DatosEmpleado c
					on b.DEid = c.DEid
				where a.CFid in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#CFids#">) 
				
				<cfif arguments.incluirJefesCFhijos EQ 1>					<!---incluye  como subalternos a los jefes de los centros funcionales hijos--->
					Union
					select distinct  c.DEid, c.DEnombre,c.DEapellido1,c.DEapellido2
					from CFuncional  cf
					inner join LineaTiempo b
						on  cf.RHPid = b.RHPid 
						and getDate() between b.LTdesde and b.LThasta  
					inner join DatosEmpleado c
						on b.DEid = c.DEid
					where CFidresp in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#CFids#">)
					Union 
					select distinct c.DEid, c.DEnombre,c.DEapellido1,c.DEapellido2
					from CFuncional  cf
					inner join DLaboralesEmpleado b
						on  cf.RHPid = b.RHPid 
						and getDate() between b.DLfvigencia and b.DLffin  
					inner join DatosEmpleado c
						on b.DEid = c.DEid
					where CFidresp in(<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" value="#CFids#">)
				</cfif>	
				
			</cfquery>
			<cfquery dbtype="query" name="rsSubalternos">
				Select distinct * from rsSubalternosAll
			</cfquery>
			
			
		
		<cfreturn rsSubalternos>	
</cffunction>


</body>
</html>
