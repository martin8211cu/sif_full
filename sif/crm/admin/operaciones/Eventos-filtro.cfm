<!--- Pasar los datos del filtro del url al form --->
<cfif isdefined("Url.f_CRMEid_Nombre") and not isdefined("Form.f_CRMEid_Nombre")>
	<cfparam name="Form.f_CRMEid_Nombre" default="#Url.f_CRMEid_Nombre#">
</cfif>
<cfif isdefined("Url.f_CRMEidrel_Nombre") and not isdefined("Form.f_CRMEidrel_Nombre")>
	<cfparam name="Form.f_CRMEidrel_Nombre" default="#Url.f_CRMEidrel_Nombre#">
</cfif>
<cfif isdefined("Url.f_CRMEVdescripcion_Resum") and not isdefined("Form.f_CRMEVdescripcion_Resum")>
	<cfparam name="Form.f_CRMEVdescripcion_Resum" default="#Url.f_CRMEVdescripcion_Resum#">
</cfif>
<cfif isdefined("Url.f_CRMTEVid") and not isdefined("Form.f_CRMTEVid")>
	<cfparam name="Form.f_CRMTEVid" default="#Url.f_CRMTEVid#">
</cfif>
<cfif isdefined("Url.f_CRMEVfecha") and not isdefined("Form.f_CRMEVfecha")>
	<cfparam name="Form.f_CRMEVfecha" default="#Url.f_CRMEVfecha#">
</cfif>

<!--- Agrega valores al filtro y a la navegcación --->

<cfset filtro = "">
<cfset navegacion = "btnfiltrar=Filtrar">
<cfif isdefined("Form.f_CRMEid_Nombre") and Len(Trim(Form.f_CRMEid_Nombre)) NEQ 0>
	<cfset filtro = filtro & " and (b.CRMEnombre like '%" & Trim(Form.f_CRMEid_Nombre) & "%' or b.CRMEapellido1 like '%" & Trim(Form.f_CRMEid_Nombre) & "%' or b.CRMEapellido2 like '%" & Trim(Form.f_CRMEid_Nombre) & "%')">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_CRMEid_Nombre=" & Form.f_CRMEid_Nombre>
</cfif>
<cfif isdefined("Form.f_CRMEidrel_Nombre") and Len(Trim(Form.f_CRMEidrel_Nombre)) NEQ 0>
	<cfset filtro = filtro & " and (c.CRMEnombre like '%" & Trim(Form.f_CRMEidrel_Nombre) & "%' or c.CRMEapellido1 like '%" & Trim(Form.f_CRMEidrel_Nombre) & "%' or c.CRMEapellido2 like '%" & Trim(Form.f_CRMEidrel_Nombre) & "%')">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_CRMEidrel_Nombre=" & Form.f_CRMEidrel_Nombre>
</cfif>
<cfif isdefined("Form.f_CRMEVdescripcion_Resum") and Len(Trim(Form.f_CRMEVdescripcion_Resum)) NEQ 0>
	<cfset filtro = filtro & " and a.CRMEVdescripcion like '%" & Trim(Form.f_CRMEVdescripcion_Resum) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_CRMEVdescripcion_Resum=" & Form.f_CRMEVdescripcion_Resum>
</cfif>
<cfif isdefined("Form.f_CRMTEVid") and Len(Trim(Form.f_CRMTEVid)) NEQ 0>
	<cfset filtro = filtro & " and a.CRMTEVid =" & Trim(Form.f_CRMTEVid)>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_CRMTEVid=" & Form.f_CRMTEVid>
</cfif>
<cfif isdefined("Form.f_CRMEVfecha") and Len(Trim(Form.f_CRMEVfecha)) NEQ 0>
	<cfset filtro = filtro & " and a.CRMEVfecha >= convert(datetime,'" & LSDateFormat(Trim(Form.f_CRMEVfecha) , 'YYYYMMDD') &  "')" >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "f_CRMEVfecha=" & Form.f_CRMEVfecha>
<cfelse>
	<cfset filtro = filtro & " and a.CRMEVfecha >= convert(datetime,convert(varchar,getDate(),112))">
</cfif>

<!--- Consultas --->
<cfquery name="rsCRMTipoEvento" datasource="CRM">
	select CRMTEVid, CRMTEVdescripcion
	from CRMTipoEvento
</cfquery>

<!--- Crea el form y la lista --->
<link href="../../css/crm.css" rel="stylesheet" type="text/css">

<table width="100%" border="0" cellspacing="0" cellpadding="0" bgcolor="#E6E6E6">
  <form action="Eventos.cfm" method="post" name="formfiltro">
    <tr> 
      <td class="messages"><strong>Entidad</strong></td>
      <td class="messages"><strong>Entidad Responsable</strong></td>
      <td class="messages"><strong>Descripción Resumida del Evento</strong></td>
      <td class="messages"><strong>Tipo de Evento</strong></td>
      <td class="messages"><strong>Fecha del Evento</strong></td>
	  <td class="messages"><strong>&nbsp;</strong></td>
    </tr>
    <tr> 
      <td class="messages"><input name="f_CRMEid_Nombre" type="text" value="<cfif (isDefined("Form.f_CRMEid_Nombre")) and (len(trim(Form.f_CRMEid_Nombre)))><cfoutput>#Form.f_CRMEid_Nombre#</cfoutput></cfif>" size="30" maxlength="60"></td><!--- CRMEid_Nombre --->
      <td class="messages"><input name="f_CRMEidrel_Nombre" type="text" value="<cfif (isDefined("Form.f_CRMEidrel_Nombre")) and (len(trim(Form.f_CRMEidrel_Nombre)))><cfoutput>#Form.f_CRMEidrel_Nombre#</cfoutput></cfif>" size="30" maxlength="60"></td><!--- CRMEidrel_Nombre --->
      <td class="messages"><input name="f_CRMEVdescripcion_Resum" type="text" value="<cfif (isDefined("Form.f_CRMEVdescripcion_Resum")) and (len(trim(Form.f_CRMEVdescripcion_Resum)))><cfoutput>#Form.f_CRMEVdescripcion_Resum#</cfoutput></cfif>" size="30" maxlength="60"></td><!--- CRMEVdescripcion_Resum --->
      <td class="messages">
	  	<!--- <input name="f_CRMTEVid_Descripcion" type="text" value="<cfif (isDefined("Form.f_CRMTEVid_Descripcion")) and (len(trim(Form.f_CRMTEVid_Descripcion)))><cfoutput>#Form.f_CRMTEVid_Descripcion#</cfoutput></cfif>" size="30" maxlength="60">	  </td><!--- CRMTEVid_Descripcion ---> --->
		<select name="f_CRMTEVid">
			<option value="">Todos</option>
			<cfoutput query="rsCRMTipoEvento">
				<option value="#CRMTEVid#"<cfif (isDefined("Form.f_CRMTEVid")) and (len(trim(Form.f_CRMTEVid))) and (Form.f_CRMTEVid eq CRMTEVid)>selected</cfif>>#CRMTEVdescripcion#</option>
			</cfoutput>
		</select>
      <td class="messages">
	  	<cfif (isDefined("Form.f_CRMEVfecha")) and (len(trim(Form.f_CRMEVfecha)))>
		  	<cf_sifcalendario form="formfiltro" name="f_CRMEVfecha" value="#f_CRMEVfecha#">
		<cfelse>
			<cf_sifcalendario form="formfiltro" name="f_CRMEVfecha" value="#LSDateFormat(Now(),'dd/mm/yyyy')#">
		</cfif>
	  </td><!--- CRMEVfecha --->
	  <td class="messages"><input name="btnfiltrar" type="submit" value="Filtrar"></td>
    </tr>
  </form>
</table>

<!---
Select 
From 
Where CEcodigo=CEcodigo and Ecodigo=Ecodigo and CRMEVid=CRMEVid and 1=2 --->

<cfinvoke 
 component="sif.crm.Componentes.pListas"
 method="pListaCRM"
 returnvariable="pListaCRMRet">
	<cfinvokeargument name="tabla" value="CRMEventos a, CRMEntidad b, CRMEntidad c, CRMTipoEvento e"/>
	<cfinvokeargument name="columnas" value="a.CRMEVid, a.CRMEid, a.CRMEidrel, a.CRMEVid2, a.CRMTEVid, a.CRMEVfecha, 
											case when (datalength(a.CRMEVdescripcion)>60) then substring(convert(varchar,a.CRMEVdescripcion),1,56) + '...'
											else convert(varchar,a.CRMEVdescripcion) end as CRMEVdescripcion_Resum, 
											b.CRMEnombre + ' ' + b.CRMEapellido1 + ' ' + b.CRMEapellido2 as CRMEid_Nombre,
											c.CRMEnombre + ' ' + c.CRMEapellido1 + ' ' + c.CRMEapellido2 as CRMEidrel_Nombre,
											e.CRMTEVdescripcion as CRMTEVid_Descripcion
											"/>
	<cfinvokeargument name="filtro" value="a.CEcodigo=#Session.CEcodigo# and a.Ecodigo=#Session.Ecodigo# #filtro# 
											and a.CRMEid = b.CRMEid 
											and a.CRMEidrel *= c.CRMEid 
											and a.CRMTEVid = e.CRMTEVid
											order by a.CRMEVfecha
											"/>
	<cfinvokeargument name="desplegar" value="CRMEid_Nombre, CRMEidrel_Nombre, CRMEVdescripcion_Resum, CRMTEVid_Descripcion, CRMEVfecha"/>
	<cfinvokeargument name="etiquetas" value="Entidad, Entidad Responsable, Descripción Resumida del Evento, Tipo de Evento, Fecha del Evento"/>
	<cfinvokeargument name="formatos" value="S, S, S, S, D"/>
	<cfinvokeargument name="align" value="left, left, left, left, center"/>
	<cfinvokeargument name="ajustar" value="N"/>
	<cfinvokeargument name="irA" value="Eventos.cfm"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="botones" value="Nuevo"/>
	<cfinvokeargument name="keys" value="CRMEVid"/>
	<cfinvokeargument name="Conexion" value="CRM"/>
	<cfinvokeargument name="showLink" value="true"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
</cfinvoke>
