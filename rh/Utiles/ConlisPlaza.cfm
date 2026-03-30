<html>
<head>
<title>Lista de Plazas</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js"></script>
</head>
<body>

<cfset LvarEmpresa = Session.Ecodigo>
<cfset Lvarvfyplz = 0>
<cfset LvarfechaAcc = LSDateFormat(Now(), 'dd/mm/yyyy')>

<cfif isdefined("Url.RHPcodigo") and not isdefined("Form.RHPcodigo")>
	<cfparam name="Form.RHPcodigo" default="#Url.RHPcodigo#">
</cfif>
<cfif isdefined("Url.RHPdescripcion") and not isdefined("Form.RHPdescripcion")>
	<cfparam name="Form.RHPdescripcion" default="#Url.RHPdescripcion#">
</cfif>
<cfif isdefined("Url.RHPpuesto") and not isdefined("Form.RHPpuesto")>
	<cfparam name="Form.RHPpuesto" default="#Url.RHPpuesto#">
</cfif>
<cfif isdefined("Url.Dcodigo") and not isdefined("Form.Dcodigo")>
	<cfparam name="Form.Dcodigo" default="#Url.Dcodigo#">
</cfif>
<cfif isdefined("Url.Ocodigo") and not isdefined("Form.Ocodigo")>
	<cfparam name="Form.Ocodigo" default="#Url.Ocodigo#">
</cfif>

<cfif isdefined("Url.empresa") and not isdefined("Form.empresa")>
	<cfset LvarEmpresa = Url.empresa>
<cfelseif isdefined("Form.empresa")>
	<cfset LvarEmpresa = Form.empresa>
</cfif>

<!--- Parámetro para verificar el porcentaje de la plaza --->
<cfif isdefined("Url.vfyplz") and not isdefined("Form.vfyplz")>
	<cfset Lvarvfyplz = Url.vfyplz>
<cfelseif isdefined("Form.vfyplz")>
	<cfset Lvarvfyplz = Form.vfyplz>
</cfif>

<!--- Parámetro de fecha de vigencia para verificar el porcentaje de la plaza --->
<cfif isdefined("Url.fechaAcc") and not isdefined("Form.fechaAcc")>
	<cfset LvarfechaAcc = Url.fechaAcc>
<cfelseif isdefined("Form.fechaAcc")>
	<cfset LvarfechaAcc = Form.fechaAcc>
</cfif>

<!--- Recibe form, conexion, atrRHPcodigo, atrRHPdescripcion, atrRHPid, RHPpuesto, Dcodigo, Ocodigo --->
<script language="JavaScript" type="text/javascript">
function Asignar(RHPcodigo, RHPdescripcion, RHPid, RHPpuesto, Dcodigo, Ocodigo, Disponible) {
	if (window.opener != null) {
		<cfoutput>
		window.opener.document.#Url.form#.#Url.atrRHPcodigo#.value = RHPcodigo;
		window.opener.document.#Url.form#.#Url.atrRHPdescripcion#.value = RHPdescripcion;
		window.opener.document.#Url.form#.#Url.atrRHPid#.value = RHPid;
		if (window.opener.document.#url.form#.LTporcplaza) {
			<cfif Lvarvfyplz EQ 0>
			if (Disponible > 0) {
				window.opener.document.#url.form#.LTporcplaza.value = fm(Disponible, 2);
			} else {
				window.opener.document.#url.form#.LTporcplaza.value = "0.00";
			}
			<cfelse>
				window.opener.document.#url.form#.LTporcplaza.value = "100.00";
			</cfif>
		}
		</cfoutput>
		window.close();
	}
}
</script>


<cfset navegacion = "empresa=" & LvarEmpresa & "&vfyplz=" & Lvarvfyplz & "&fechaAcc=" & LvarfechaAcc>
<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPcodigo=" & Form.RHPcodigo>
</cfif>
<cfif isdefined("Form.RHPdescripcion") and Len(Trim(Form.RHPdescripcion)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPdescripcion=" & Form.RHPdescripcion>
</cfif>
<cfif isdefined("Form.RHPpuesto") and Len(Trim(Form.RHPpuesto)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHPpuesto=" & Form.RHPpuesto>
</cfif>
<cfif isdefined("Form.Dcodigo") and Len(Trim(Form.Dcodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Dcodigo=" & Form.Dcodigo>
</cfif>
<cfif isdefined("Form.Ocodigo") and Len(Trim(Form.Ocodigo)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Ocodigo=" & Form.Ocodigo>
</cfif>

<cfoutput>
<form name="filtroEmpleado" method="post">
<input type="hidden" name="empresa" value="#LvarEmpresa#">
<input type="hidden" name="vfyplz" value="#Lvarvfyplz#">
<input type="hidden" name="fechaAcc" value="#LvarfechaAcc#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
	<tr>
		<td align="right"><strong>C&oacute;digo</strong></td>
		<td> 
			<input name="RHPcodigo" type="text" id="RHPcodigo" size="10" maxlength="10" value="<cfif isdefined("Form.RHPcodigo")>#Form.RHPcodigo#</cfif>">
		</td>
		<td align="right"><strong>Descripci&oacute;n</strong></td>
		<td> 
			<input name="RHPdescripcion" type="text" id="RHPdescripcion" size="40" maxlength="80" value="<cfif isdefined("Form.RHPdescripcion")>#Form.RHPdescripcion#</cfif>">
		</td>
		<td align="center">
			<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
		</td>
	</tr>
</table>
</form>
</cfoutput>

<cfquery name="rsPlazas" datasource="#Session.DSN#">
	select  rtrim(a.RHPcodigo) as RHPcodigo, a.RHPdescripcion, a.RHPid, a.RHPpuesto, a.Dcodigo, a.Ocodigo, 
			100.00 - coalesce(sum(b.LTporcplaza), 0.00) as Disponible
	from RHPlazas a
		left outer join LineaTiempo b
			on a.RHPid = b.RHPid
			and a.Ecodigo = b.Ecodigo
			and <cfqueryparam cfsqltype="cf_sql_date" value="#LvarfechaAcc#"> between b.LTdesde and b.LThasta
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarEmpresa#">
	and a.RHPactiva = 1
	<cfif isdefined("Form.RHPcodigo") and Len(Trim(Form.RHPcodigo)) NEQ 0>
		and upper(a.RHPcodigo) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.RHPcodigo)#%">
	</cfif>
	<cfif isdefined("Form.RHPdescripcion") and Len(Trim(Form.RHPdescripcion)) NEQ 0>
		and upper(a.RHPdescripcion) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.RHPdescripcion)#%">
	</cfif>
	<cfif isdefined("Form.RHPpuesto") and Len(Trim(Form.RHPpuesto)) NEQ 0>
		and a.RHPpuesto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Form.RHPpuesto)#">
	</cfif>
	<cfif isdefined("Form.Dcodigo") and Len(Trim(Form.Dcodigo)) NEQ 0>
		and a.Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Dcodigo#">
	</cfif>
	<cfif isdefined("Form.Ocodigo") and Len(Trim(Form.Ocodigo)) NEQ 0>
		and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.Ocodigo#">
	</cfif>
	group by rtrim(a.RHPcodigo), a.RHPdescripcion, a.RHPid, a.RHPpuesto, a.Dcodigo, a.Ocodigo
	<cfif Lvarvfyplz EQ 0>
	having coalesce(sum(b.LTporcplaza), 0) < 100
	</cfif>
</cfquery>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaQuery"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="query" value="#rsPlazas#"/>
	<cfinvokeargument name="desplegar" value="RHPcodigo, RHPdescripcion"/>
	<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
	<cfinvokeargument name="formatos" value=""/>
	<cfinvokeargument name="align" value="left, left"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="ConlisPlaza.cfm"/>
	<cfinvokeargument name="formName" value="listaPlaza"/>
	<cfinvokeargument name="MaxRows" value="15"/>
	<cfinvokeargument name="funcion" value="Asignar"/>
	<cfinvokeargument name="fparams" value="RHPcodigo, RHPdescripcion, RHPid, RHPpuesto, Dcodigo, Ocodigo, Disponible"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="Conexion" value="#url.conexion#"/>
	<cfinvokeargument name="debug" value="N"/>
</cfinvoke>
</body>
</html>
