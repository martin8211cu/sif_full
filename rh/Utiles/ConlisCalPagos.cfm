<!--- OPARRALES 2019-01-09
	- Modificacion para parametro de MostrarTodos las nominas (Aplicadas y No Aplicadas)
 --->

<html>
<head>
<title>Lista de Calendarios de Pagos</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

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

<cfif isdefined("Url.vTcodigo") and not isdefined("Form.vTcodigo")>
	<cfparam name="Form.vTcodigo" default="#Url.vTcodigo#">
</cfif>
<cfif isdefined("Url.historicos") and not isdefined("Form.historicos")>
	<cfparam name="Form.historicos" default="#Url.historicos#">
</cfif>
<cfif isdefined("Url.Contabilizado") and not isdefined("Form.Contabilizado")>
	<cfparam name="Form.Contabilizado" default="#Url.Contabilizado#">
</cfif>
<cfif isdefined("Url.Excluir") and not isdefined("Form.Excluir")>
	<cfparam name="Form.Excluir" default="#Url.Excluir#">
</cfif>
<cfif isdefined("Url.CPcodigo") and not isdefined("Form.CPcodigo")>
	<cfparam name="Form.CPcodigo" default="#Url.CPcodigo#">
</cfif>
<cfif isdefined("Url.CPdescripcion") and not isdefined("Form.CPdescripcion")>
	<cfparam name="Form.CPdescripcion" default="#Url.CPdescripcion#">
</cfif>
<cfif isdefined("Url.pintaRCDescripcion") and not isdefined("Form.pintaRCDescripcion")>
	<cfparam name="Form.pintaRCDescripcion" default="#Url.pintaRCDescripcion#">
</cfif>

<cfif isdefined("Url.vMes") and not isdefined("Form.vMes")>
	<cfparam name="Form.vMes" default="#Url.vMes#">
</cfif>
<cfif isdefined("Url.vPeriodo") and not isdefined("Form.vPeriodo")>
	<cfparam name="Form.vPeriodo" default="#Url.vPeriodo#">
</cfif>

<cfif IsDefined("Url.MostrarTodos")>
	<cfparam name="Form.MostrarTodos" default="#Url.MostrarTodos#">
</cfif>

<script language="JavaScript" type="text/javascript">
	function Asignar(id, cod, desc, tcod) {
		if (window.opener != null) {
			<cfoutput>
			window.opener.document.#Form.f#.#Form.p1#.value = id;
			window.opener.document.#Form.f#.#Form.p2#.value = cod;
			window.opener.document.#Form.f#.#Form.p3#.value = desc;

			if (window.opener.document.#Form.f#.#Form.p4#) {
				if (window.opener.document.#Form.f#.#Form.p4#.options != null) {
					for (var i = 0; i < window.opener.document.#Form.f#.#Form.p4#.options.length; i++) {
						if (window.opener.document.#Form.f#.#Form.p4#.options[i].value == tcod) {
							window.opener.document.#Form.f#.#Form.p4#.options.selectedIndex = i;
						}
					}
				}
			}

			</cfoutput>
			window.close();
		}
	}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.CPcodigo") and Len(Trim(Form.CPcodigo)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.CPcodigo) like '%" & #UCase(Form.CPcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPcodigo=" & Form.CPcodigo>
</cfif>
<cfif isdefined("Form.CPdescripcion") and Len(Trim(Form.CPdescripcion)) NEQ 0>
	<cfset filtro = filtro & " and case WHEN datalength (coalesce(CPdescripcion, b.RCDescripcion)) = 0 THEN LTRIM(RTRIM(b.RCDescripcion))
    		ELSE coalesce(CPdescripcion, LTRIM(RTRIM(b.RCDescripcion))) END LIKE '%" & #UCase(Trim(Form.CPdescripcion))# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CPdescripcion=" & Form.CPdescripcion>
</cfif>
<cfif isdefined("form.vTcodigo") and len(trim(form.vTcodigo)) gt 0>
	<cfset filtro = filtro & " and a.Tcodigo='#trim(form.vTcodigo)#' and b.Tcodigo='#trim(form.vTcodigo)#'">
</cfif>
<cfif isdefined("form.Excluir") and len(trim(form.Excluir)) gt 0>
	<cfset filtro = filtro & " and a.CPtipo not in (#form.Excluir#)">
</cfif>
<cfif isdefined("form.vMes") and len(trim(form.vMes)) gt 0>
	<cfset filtro = filtro & " and a.CPmes=#trim(form.vMes)#">
</cfif>
<cfif isdefined("form.vPeriodo") and len(trim(form.vPeriodo)) gt 0>
	<cfset filtro = filtro & " and a.CPperiodo= #trim(form.vPeriodo)#">
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
<cfif isdefined("Form.p4")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "historicos=" & Form.historicos>
</cfif>

<cfif IsDefined("Form.MostrarTodos")>
	<cfset navegacion &= Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "MostrarTodos=" & Form.MostrarTodos>
</cfif>

<table width="98%" border="0" cellpadding="0" cellspacing="0" align="center" >
	<cfoutput>
	<tr><td>
		<table width="100%" class="areaFiltro" cellpadding="0" cellspacing="0">
			<form style="margin:0 " name="filtroEmpleado" method="post" action="#CurrentPage#">
				<input type="hidden" name="f" value="#Form.f#">
				<input type="hidden" name="p1" value="#Form.p1#">
				<input type="hidden" name="p2" value="#Form.p2#">
				<input type="hidden" name="p3" value="#Form.p3#">
				<input type="hidden" name="p4" value="#Form.p4#">
				<input type="hidden" name="historicos" value="#Form.historicos#">
				<input type="hidden" name="MostrarTodos" value="#Form.MostrarTodos#">
				<cfif isdefined("form.vTcodigo") and len(trim(form.vTcodigo)) gt 0>
					<input type="hidden" name="vTcodigo" value="#Form.vTcodigo#">
				</cfif>

				<cfif isdefined("form.vMes") and len(trim(form.vMes)) gt 0>
					<input type="hidden" name="vMes" value="#Form.vMes#">
				</cfif>

				<cfif isdefined("form.vPeriodo") and len(trim(form.vPeriodo)) gt 0>
					<input type="hidden" name="vPeriodo" value="#Form.vPeriodo#">
				</cfif>

				<tr>
					<td align="right"><strong>C&oacute;digo</strong></td>
					<td>
						<input name="CPcodigo" type="text" id="CPcodigo" size="15" maxlength="11" value="<cfif isdefined("Form.CPcodigo")>#Form.CPcodigo#</cfif>">
					</td>
					<td align="right"><strong>Descripci&oacute;n</strong></td>
					<td>
						<input name="CPdescripcion" type="text" id="CPdescripcion" size="60" maxlength="60" value="<cfif isdefined("Form.CPdescripcion")>#Form.CPdescripcion#</cfif>">
					</td>
					<td align="center">
						<input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
					</td>
				</tr>
			</form>
		</table>
	</td></tr>
	</cfoutput>
	<tr>
		<td>

		    <cf_dbfunction name="fn_len" datasource="#session.dsn#" returnvariable="LvarDescripcion">
			<cfset vs_columnas = 'CPid, a.CPcodigo, case when #LvarDescripcion# (rtrim(coalesce(CPdescripcion,RCDescripcion))) = 0 then CDescripcion else coalesce(CPdescripcion,RCDescripcion) end as CPdescripcion, a.Tcodigo, c.Tdescripcion'>
			<cfif isdefined("form.pintaRCDescripcion") and len(trim(form.pintaRCDescripcion)) and form.pintaRCDescripcion EQ true>
				<cfset vs_columnas = 'CPid, a.CPcodigo, case when #LvarDescripcion# (rtrim(coalesce(CPdescripcion,RCDescripcion))) = 0 then RCDescripcion else coalesce(CPdescripcion,RCDescripcion) end as CPdescripcion, a.Tcodigo, c.Tdescripcion'>
			</cfif>

			<cfif isdefined("Form.historicos") and Form.historicos>
				<cfset RCalculoNomina = "HRCalculoNomina">
				<cfif !(IsDefined("Form.MostrarTodos") and Form.MostrarTodos)>
					<cfset filtro = filtro & " and a.CPfcalculo is not null ">
				</cfif>
			<cfelse>
				<cfset RCalculoNomina = "RCalculoNomina">
			</cfif>
			<cfif IsDefined("Form.MostrarTodos") and Form.MostrarTodos>
				<cfif isdefined("Form.historicos") and Form.historicos>
					<cfset RCalcNom = "RCalculoNomina">
				<cfelse>
					<cfset RCalcNom = "HRCalculoNomina">
				</cfif>
			</cfif>

			<cfif isdefined("form.Contabilizado") and form.Contabilizado>
				<cfset filtro = filtro & "and b.IDcontable is not null">
			</cfif>
			<!--- <cfset filtro = filtro & " order by a.CPdesde desc, a.Tcodigo, a.CPcodigo"> --->

			<cfquery name="rsDatos" datasource="#session.dsn#">
				SELECT
					CPid,
					CPcodigo,
					RCNid,
					CPdescripcion,
					Tcodigo,
					Tdescripcion,
					CPdesde
				from
				(
					SELECT
						CPid,
						a.CPcodigo,
						RCNid,
						CPdesde,
						CASE
							WHEN datalength (rtrim(coalesce(CPdescripcion, b.RCDescripcion))) = 0 THEN b.RCDescripcion
							ELSE coalesce(CPdescripcion, b.RCDescripcion)
						END AS CPdescripcion,
					    a.Tcodigo,
					    c.Tdescripcion
					FROM
						CalendarioPagos a,
					    #RCalculoNomina# b,
						TiposNomina c
					WHERE 1 = 1
					and	a.Ecodigo = <cfqueryparam cfsqltype="cf_Sql_numeric" value="#Session.Ecodigo#">
					and b.RCNid = a.CPid
					and b.Ecodigo = c.Ecodigo
					and b.Tcodigo = c.Tcodigo
					#PreserveSingleQuotes(filtro)#
					<cfif IsDefined("Form.MostrarTodos") and Form.MostrarTodos>
						union
						SELECT
							CPid,
							a.CPcodigo,
							RCNid,
							CPdesde,
						    CASE
						    	WHEN datalength (rtrim(coalesce(CPdescripcion, b.RCDescripcion))) = 0 THEN b.RCDescripcion
						        ELSE coalesce(CPdescripcion, b.RCDescripcion)
							END AS CPdescripcion,
						    a.Tcodigo,
						    c.Tdescripcion
						FROM
							CalendarioPagos a,
							#RCalcNom# b,
							TiposNomina c
						WHERE 1 = 1
						and	a.Ecodigo = <cfqueryparam cfsqltype="cf_Sql_numeric" value="#Session.Ecodigo#">
						and b.RCNid = a.CPid
						and b.Ecodigo = c.Ecodigo
						and b.Tcodigo = c.Tcodigo
						#PreserveSingleQuotes(filtro)#
					</cfif>
				) datos
				order by CPdesde desc, Tcodigo, CPcodigo
			</cfquery>

			<cfinvoke
			 component="rh.Componentes.pListas"
			 method="pListaQuery"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="query" value="#rsDatos#"/>
				<cfinvokeargument name="columnas" value="#vs_columnas#"/>
				<cfinvokeargument name="desplegar" value="CPcodigo, CPdescripcion"/>
				<cfinvokeargument name="etiquetas" value="Código, Descripción"/>
				<cfinvokeargument name="formatos" value="S,S"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value="S"/>
				<cfinvokeargument name="irA" value="ConlisCalPagos.cfm"/>
				<cfinvokeargument name="formName" value="listaCalPagos"/>
				<cfinvokeargument name="cortes" value="Tdescripcion">
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="funcion" value="Asignar"/>
				<cfinvokeargument name="fparams" value="CPid, CPcodigo, CPdescripcion, Tcodigo"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
				<cfinvokeargument name="showEmptyListMsg" value="true">
				<cfinvokeargument name="debug" value="N">
			</cfinvoke>
		</td>
	</tr>

</table>

</body>
</html>