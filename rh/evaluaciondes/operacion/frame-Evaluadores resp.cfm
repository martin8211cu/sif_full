<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>
<cfif isdefined("Url.fRHPcodigo") and not isdefined("Form.fRHPcodigo")>
	<cfparam name="Form.fRHPcodigo" default="#Url.fRHPcodigo#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SEL=3">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHEEid=" & Form.RHEEid>
<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(b.DEidentificacion) like '%" & #UCase(Form.FDEidentificacion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
</cfif>
<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(b.DEapellido1 + ' ' + b.DEapellido2 + ', ' + b.DEnombre) like '%" & #UCase(Form.FDEnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
</cfif>
<cfif isdefined("Form.fRHPcodigo") and Len(Trim(Form.fRHPcodigo)) NEQ 0>
 	<cfset filtro = filtro & " and upper(a.RHPcodigo) like '%" & #UCase(Form.fRHPcodigo)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fRHPcodigo=" & Form.fRHPcodigo>
</cfif>

<cfoutput>
<form name="form1" method="post" action="registro_evaluacion.cfm">
<input type="hidden" name="SEL" value="5">
<input type="hidden" name="RHEEid" value="#form.RHEEid#">
<cfset descripcion_campo = " La información del empleado a evaluar ayudará a encontrar al empleado del cual desea identificar sus 
evaluadores.">
<fieldset><legend title="#descripcion_campo#">Datos del Empleado a Evaluar</legend>
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td width="4%" align="right">Puesto</td>
    <td width="20%">
</cfoutput>
		<cfif isdefined("Form.fRHPcodigo") and len(trim(Form.fRHPcodigo)) gt 0>
			<cfquery name="rsPuesto" datasource="#session.dsn#">
				select coalesce(RHPcodigoext,RHPcodigo) as RHPcodigoext,RHPcodigo as fRHPcodigo, RHPdescpuesto
				from RHPuestos
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
				and RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.fRHPcodigo#">
			</cfquery>
			<cf_rhpuesto query="#rsPuesto#" name="fRHPcodigo" size="20" form="form1" tabindex="1">
		<cfelse>
		<cf_rhpuesto name="fRHPcodigo" size="20" form="form1" tabindex="1">
		</cfif>
<cfoutput>
	</td>
    <td width="4%" align="right">Identificaci&oacute;n</td>
    <td width="20%">
        <input name="FDEidentificacion" type="text" id="FDEidentificacion" size="10" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>" tabindex="1">
	</td>
    <td width="4%" align="right"><div align="left">Nombre</div></td>
    <td width="40%"> 
		<input name="FDEnombre" type="text" id="FDEnombre" size="30" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>" tabindex="1">
	</td>
    <td width="8%" align="center">
      <input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar" tabindex="1">
    </td>
  </tr>
</table>
</fieldset>
</form>
</cfoutput>

<cfinvoke 
 component="rh.Componentes.pListas"
 method="pListaRH"
 returnvariable="pListaEduRet">
	<cfinvokeargument name="debug" value="N"/>
	<cfinvokeargument name="tabla" value="RHListaEvalDes a, DatosEmpleado b, RHPuestos c, RHEvaluadoresDes d, DatosEmpleado e"/>
	<cfinvokeargument name="columnas" value="a.RHEEid, b.DEid, b.DEidentificacion + ' ' + b.DEapellido1 + ' ' + b.DEapellido2 + ', ' + b.DEnombre as DEidentificacionNombre, b.DEidentificacion, b.DEapellido1 + ' ' + b.DEapellido2 + ', ' + b.DEnombre as NombreCompleto, c.RHPdescpuesto, SEL=5, e.DEid as DEideval, e.DEidentificacion as DEidentificacioneval, e.DEapellido1 + ' ' + e.DEapellido2 + ', ' + e.DEnombre as NombreCompletoEval, d.RHEDtipo
											, RHEDtipodesc = case RHEDtipo when 'A' then 'Autoevaluación' when 'J' then 'Jefe' when 'C' then 'Compañero' when 'S' then 'Colaborador' end, BTNELIMINAR = 0,
											case d.RHEDtipo 
												when 'A' {fn concat(convert(varchar, a.DEid),{fn concat('|',convert(varchar,d.DEideval))})}
												else '' end as inactivecol,
											case when (select count(coalesce(z.RHNEDnotajefe,0)) -  (select count(coalesce(z.RHNEDnotajefe,0))
																										from RHNotasEvalDes z 
																										where z.RHEEid = a.RHEEid 
																										and z.DEid = a.DEid 
																										and z.RHNEDnotajefe is not null)
											   from RHNotasEvalDes z where z.RHEEid = a.RHEEid and z.DEid = a.DEid) != 0 then 'Pendiente' else 'Listo' end as Estado
											"/>
	<cfinvokeargument name="desplegar" value="DEidentificacioneval, NombreCompletoEval, Estado, RHEDtipodesc "/>
	<cfinvokeargument name="etiquetas" value="Identificación, Nombre Completo, Estado, Tipo"/>
	<cfinvokeargument name="cortes" value="RHPdescpuesto, DEidentificacionNombre"/>
	<cfinvokeargument name="formatos" value="S,S,S,S"/>
	<cfinvokeargument name="filtro" value=" a.Ecodigo = #SESSION.ECODIGO# 
											and a.RHEEid = #FORM.RHEEID# 
											#FILTRO#
											and a.DEid = b.DEid 
											and a.Ecodigo = c.Ecodigo 
											and a.RHPcodigo = c.RHPcodigo 
											and a.DEid = d.DEid 
											and a.RHEEid = d.RHEEid 
											and d.DEideval = e.DEid
											order by c.RHPdescpuesto, b.DEidentificacion, b.DEapellido1, b.DEapellido2, b.DEnombre, e.DEidentificacion, e.DEapellido1, e.DEapellido2, e.DEnombre"/>
	<cfinvokeargument name="align" value="left, left, left, center"/>
	<cfinvokeargument name="ajustar" value=""/>
	<cfinvokeargument name="irA" value="registro_evaluacion.cfm"/>
	<cfinvokeargument name="incluyeForm" value="true"/>
	<cfinvokeargument name="MaxRows" value="50"/>
	<cfinvokeargument name="formName" value="listaEvaluadores"/>
	<cfinvokeargument name="showLink" value="false"/>
	<cfinvokeargument name="checkboxes" value="D"/>
	<cfinvokeargument name="keys" value="DEid, DEideval"/>
	<cfinvokeargument name="showEmptyListMsg" value="true"/>
	<cfinvokeargument name="EmptyListMsg" value="***NO SE HAN AGREGADO EVALUADORES PARA ESTA RELACION***"/>
	<cfinvokeargument name="navegacion" value="#navegacion#"/>
	<cfinvokeargument name="inactivecol" value="inactivecol"/>
</cfinvoke>
<script language="javascript" type="text/javascript">
	var f = document.form1;
	//f.fRHPcodigo.focus();	
</script>