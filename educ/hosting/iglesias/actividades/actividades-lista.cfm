<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfset filtro = "">
<cfset navegacion = "">
<cfset additionalCols = "">

<cfif isdefined("Url.fDesde") and not isdefined("Form.fDesde")>
	<cfset Form.fDesde = Url.fDesde>
</cfif>
<cfif isdefined("Url.fHasta") and not isdefined("Form.fHasta")>
	<cfparam name="Form.fHasta" default="#Url.fHasta#">
</cfif>

<cfif isdefined("Form.fDesde") and Len(Trim(Form.fDesde)) NEQ 0>
	<cfset filtro = filtro & " and convert(datetime, convert(varchar, a.MEVfecha, 103), 103) >= convert(datetime, '" & form.fDesde & "', 103)">
	<!---
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPid=" & Form.FPid>
	<cfset additionalCols = additionalCols & Iif(Len(Trim(additionalCols)) NEQ 0, DE(", "), DE("")) & " '#Form.FPid#' as FPid">
	--->
</cfif>
<cfif isdefined("Form.fHasta") and Len(Trim(Form.fHasta)) NEQ 0>
	<cfset filtro = filtro & " and convert(datetime, convert(varchar, a.MEVfecha, 103), 103) <= convert(datetime, '" & form.fHasta & "', 103)">
	<!---
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPnombre=" & Form.FPnombre>
	<cfset additionalCols = additionalCols & Iif(Len(Trim(additionalCols)) NEQ 0, DE(", "), DE("")) & " '#Form.FPnombre#' as FPnombre">
	--->
</cfif>
<!---
<cfif Len(Trim(additionalCols)) NEQ 0>
	<cfset additionalCols = additionalCols & ", ">
</cfif>
--->

<cfoutput>
<form name="filtroActividades" method="post" action="#CurrentPage#">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro" align="center">
  <tr> 
    <td class="fileLabel">Desde</td>
    <td class="fileLabel">Hasta</td>
	<td>&nbsp;</td>
  </tr>
  <tr>
    <td> 
		<cfset fDesde = "">
		<cfif isdefined("Form.fDesde")>
			<cfset fDesde = Form.fDesde>
		</cfif>
		<cf_sifcalendario form="filtroActividades" value="#fDesde#" name="fDesde"> 
    </td>
    <td> 
		<cfset fHasta = "">
		<cfif isdefined("Form.fHasta")>
			<cfset fHasta = Form.fHasta>
		</cfif>
		<cf_sifcalendario form="filtroActividades" value="#fHasta#" name="fHasta"> 
    </td>
    <td align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
    </td>
  </tr>
</table>
</form>
</cfoutput>


<table width="100%"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
		<cfinvoke 
		 component="sif.Componentes.pListas"
		 method="pLista"
		 returnvariable="pListaEduRet">
			<cfinvokeargument name="tabla" value="MEEvento a"/>
			<cfinvokeargument name="columnas" value="#additionalCols# convert(varchar, a.MEVid) as MEVid, a.MEVevento, convert(varchar, MEVfecha, 103) as MEVfecha
													"/>
			<cfinvokeargument name="desplegar" value="MEVevento, MEVfecha"/>
			<cfinvokeargument name="etiquetas" value="Actividad, Fecha"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value=" a.Ecodigo = #Session.Ecodigo#
													#filtro# 
													order by a.MEVfecha, a.MEVinicio, a.MEVfin
													"/>
			<cfinvokeargument name="align" value="left, center"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="actividades.cfm"/>
			<cfinvokeargument name="formName" value="listaActividades"/>
			<cfinvokeargument name="MaxRows" value="0"/>
			<cfinvokeargument name="keys" value="MEVid"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
		</cfinvoke>
	</td>
  </tr>
</table>

