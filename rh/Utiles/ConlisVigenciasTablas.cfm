<html>
<head>
<title>Lista de Vigencias</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<body>

<cfif isdefined("Url.f") and not isdefined("Form.f")>
	<cfparam name="Form.f" default="#Url.f#">
</cfif>
<cfif isdefined("Url.p1") and not isdefined("Form.p1")>
	<cfparam name="Form.p1" default="#Url.p1#">
</cfif>
<cfif isdefined("Url.p2") and not isdefined("Form.p2")>
	<cfparam name="Form.p2" default="#Url.p2#">
</cfif>
<cfif isdefined("Url.RHTTid") and not isdefined("Form.RHTTid")>
	<cfparam name="Form.RHTTid" default="#Url.RHTTid#">
</cfif>
<cfif isdefined("Url.fRHVTfecharige") and not isdefined("Form.fRHVTfecharige")>
	<cfparam name="Form.fRHVTfecharige" default="#Url.fRHVTfecharige#">
</cfif>
<cfif isdefined("Url.fRHVTfechahasta") and not isdefined("Form.fRHVTfechahasta")>
	<cfparam name="Form.fRHVTfechahasta" default="#Url.fRHVTfechahasta#">
</cfif>
<cfif isdefined("Url.fRHVTporcentaje") and not isdefined("Form.fRHVTporcentaje")>
	<cfparam name="Form.fRHVTporcentaje" default="#Url.fRHVTporcentaje#">
</cfif>
<cfif isdefined("Url.fRHVTestado") and not isdefined("Form.fRHVTestado")>
	<cfparam name="Form.fRHVTestado" default="#Url.fRHVTestado#">
</cfif>

<!--- Requiere estos tres parámetros --->
<cfparam name="Form.f">
<cfparam name="Form.p1">
<cfparam name="Form.RHTTid">

<script language="JavaScript1.2" src="/cfmx/rh/js/utilesMonto.js"></script>
<script language="JavaScript" type="text/javascript">
	function Asignar(id,codigo) {
		if (window.opener != null) {
			<cfoutput>
			window.opener.document.#Form.f#.#Form.p1#.value = id;
			window.opener.document.#Form.f#.#Form.p2#.value = codigo;
			window.close();
			</cfoutput>
		}
	}
</script>

<cfset filtro = "">
<cfset navegacion = "">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f=" & Form.f>
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p1=" & Form.p1>
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "p2=" & Form.p2>
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHTTid=" & Form.RHTTid>



<cfif isdefined("Form.fRHVTfecharige") and Len(Trim(Form.fRHVTfecharige)) NEQ 0>
	<cfset filtro = filtro & " and RHVTfecharige >= convert(datetime,'" & #Form.fRHVTfecharige# & "',103)">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHVTfecharige=" & Form.fRHVTfecharige>
</cfif>
<cfif isdefined("Form.fRHVTfechahasta") and Len(Trim(Form.fRHVTfechahasta)) NEQ 0>
	<cfset filtro = filtro & " and RHVTfechahasta <= convert(datetime,'" & #Form.fRHVTfechahasta# & "',103)">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHVTfechahasta=" & Form.fRHVTfechahasta>
</cfif>

<cfif isdefined("Form.fRHVTporcentaje") and Len(Trim(Form.fRHVTporcentaje)) NEQ 0>
	<cfset filtro = filtro & " and RHVTporcentaje = " & #Form.fRHVTporcentaje#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHVTporcentaje=" & Form.fRHVTporcentaje>
</cfif>
<cfif isdefined("Form.fRHVTestado") and Len(Trim(Form.fRHVTestado)) NEQ 0>
	<cfset filtro = filtro & " and RHVTestado = '" & #Form.fRHVTestado# & "'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHVTestado=" & Form.fRHVTestado>
</cfif>


<cfoutput>
<form name="filtroVigencias" method="post" action="ConlisVigenciasTablas.cfm">
<input type="hidden" name="f" value="#Form.f#">
<input type="hidden" name="p1" value="#Form.p1#">
<input type="hidden" name="p2" value="#Form.p2#">
<input type="hidden" name="RHTTid" value="#Form.RHTTid#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
	<td nowrap><strong>&nbsp;</strong></td>
	<td nowrap><strong>Fecha Desde</strong></td>
	<td nowrap><strong>Fecha Hasta</strong></td>
	<td nowrap><strong>Porcentaje Inc</strong></td>
	<td nowrap><strong>Estado</strong></td>
	<td nowrap><strong>&nbsp;</strong></td>
	<td nowrap><strong>&nbsp;</strong></td>
  </tr>
  <tr>
	<td>&nbsp;</td>
	<td><cfif isdefined("form.fRHVTfecharige")><cfoutput><cf_sifcalendario form="filtroVigencias" name="fRHVTfecharige" value="#form.fRHVTfecharige#"></cfoutput><cfelse><cf_sifcalendario form="filtroVigencias" name="fRHVTfecharige"></cfif></td>
	<td><cfif isdefined("form.fRHVTfechahasta")><cfoutput><cf_sifcalendario form="filtroVigencias" name="fRHVTfechahasta" value="#form.fRHVTfechahasta#"></cfoutput><cfelse><cf_sifcalendario form="filtroVigencias" name="fRHVTfechahasta"></cfif></td>
	<td>
		<input type="text"
				name="fRHVTporcentaje" id="fRHVTporcentaje"
				value="<cfif isdefined("Form.fRHVTporcentaje")>#Form.fRHVTporcentaje#</cfif>"
				onKeyPress="return acceptNum(event)" 
				onFocus="javascript:this.select();"
				maxlength="10"
				size="10">
	</td>
	<td>
		<select name="fRHVTestado">
			<option value="">Todos</option>
			<option value="P">Pendientes</option>
			<option value="A">Aplicados</option>
		</select>
	</td>
	<td><input type="submit" value="Filtrar" name="Filtrar" id="Filtrar">
	</td>
  </tr>
</table>
</form>
</cfoutput>
<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRHRet">
			<cfinvokeargument name="tabla" value="RHVigenciasTabla"/>
			<cfinvokeargument name="columnas" value="RHTTid,RHVTcodigo,RHVTid,RHVTfecharige,case convert(varchar,RHVTfechahasta,103) when '01/01/6100' then 'Indefinido' else convert(varchar,RHVTfechahasta,103) end as RHVTfechahasta,RHVTporcentaje,case RHVTestado when 'A' then 'Aplicado' when 'P' then 'Pendiente' else RHVTestado end as RHVTestado"/>
			<cfinvokeargument name="desplegar" value="RHVTcodigo,RHVTfecharige,RHVTfechahasta,RHVTporcentaje,RHVTestado"/>
			<cfinvokeargument name="etiquetas" value="Código, Fecha Desde,Fecha Hasta,Porcentaje Inc,Estado"/>
			<cfinvokeargument name="formatos" value="S,D,S,N,S"/>
			<cfinvokeargument name="filtro" value="RHTTid = #Form.RHTTid# and RHVTestado = 'A' #filtro# order by RHVTfecharige,RHVTfechahasta,RHVTporcentaje,RHVTestado"/>
			<cfinvokeargument name="align" value="left,center,center,center,center"/>
			<cfinvokeargument name="ajustar" value="S"/>
			<cfinvokeargument name="irA" value="ConlisVigenciasTablas.cfm"/>
			<cfinvokeargument name="formName" value="listaVigencias"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="RHVTid, RHVTcodigo"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
</cfinvoke>

</body>
</html>
