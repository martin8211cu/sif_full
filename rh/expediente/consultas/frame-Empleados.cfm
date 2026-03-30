
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Activos"
						xmlfile="/rh/generales.xml"	
						Default="Activos"
						returnvariable="vActivos"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Inactivos"
						xmlfile="/rh/generales.xml"	
						Default="Inactivos"
						returnvariable="vInactivos"/>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Todos"
						xmlfile="/rh/generales.xml"	
						Default="Todos"
						returnvariable="vTodos"/>			
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						key="LB_Estado"
						xmlfile="/rh/generales.xml"	
						Default="Estado"
						returnvariable="vEstado"/>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>

<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
	<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
</cfif>
<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
	<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
</cfif>
<cfif isdefined("Url.FEstado") and not isdefined("Form.FEstado")>
	<cfparam name="Form.FEstado" default="#Url.FEstado#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.DEidentificacion) like '%" & #UCase(Form.FDEidentificacion)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
</cfif>
<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
 	<!--- <cfset filtro = filtro & " and upper(a.DEapellido1 || ' ' || a.DEapellido2 || ', ' || a.DEnombre) like '%" & #UCase(Form.FDEnombre)# & "%'"> --->
	<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(a.DEapellido1, ' ')}, a.DEapellido2)}, ' ')}, a.DEnombre) }) like '%" & #UCase(Form.FDEnombre)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
</cfif>
<cfif isdefined("Form.FEstado") and Len(Trim(Form.FEstado)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FEstado=" & Form.FEstado>
</cfif>



<script language="javascript" type="text/javascript">
	function selEmpl(emp) {
		document.listaEmpleados.PageNum1.value = '1';
		document.listaEmpleados.DEID.value = emp;
		document.listaEmpleados.submit();
	}
</script>


<cfoutput>
<form name="filtroEmpleado" method="post" action="#CurrentPage#">
<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
  <tr> 
    <td width="9%" align="right"><div align="left"><cf_translate key="LB_Identificacion">Identificaci&oacute;n</cf_translate></div></td>
    <td width="16%"> 
      <div align="left">
        <input name="FDEidentificacion" type="text" id="FDEidentificacion" size="20" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>">
      </div></td>
    <td width="7%" align="right"><div align="left"><cf_translate key="LB_Nombre">Nombre</cf_translate></div></td>
    <td width="30%"> 
      <div align="left">
        <input name="FDEnombre" type="text" id="FDEnombre" size="40" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>">
      </div></td>
    <td width="5%" align="right"><div align="left">#vTodos#</div></td>
    <td width="18%"> 
		<select name="FEstado" id="FEstado">
			<cfoutput>
			<option value="T" <cfif isdefined("form.FEstado") and form.FEstado eq 'T'>selected</cfif>>#vTodos#</option>
			<option value="A" <cfif isdefined("form.FEstado") and form.FEstado eq 'A'>selected</cfif>>#vActivos#</option>
			<option value="I" <cfif isdefined("form.FEstado") and form.FEstado eq 'I'>selected</cfif>>#vInactivos#</option>														
			</cfoutput>
		</select>
	</td>
    <td width="20%" align="center">
		<cfinvoke component="sif.Componentes.Translate"
			method="Translate"
			Key="BTN_Filtrar"
			Default="Filtrar"
			XmlFile="/rh/generales.xml"
			returnvariable="BTN_Filtrar"/>

      <input name="btnBuscar" type="submit" id="btnBuscar" value="<cfoutput>#BTN_Filtrar#</cfoutput>">
    </td>
  </tr>
</table>
</form>
</cfoutput>
<!--- REVISAR --->

<!--- Variables de Traduccion --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Identificacion"
	Default="Identificación"
	returnvariable="LB_Identificacion"/>
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_NombreCompleto"
	Default="Nombre Completo"
	returnvariable="LB_NombreCompleto"/>

	<cfset filtro_estado = '' >
	<cfif isdefined("Form.FEstado") and listfind('A,I', form.FEstado) >
		<cfsavecontent variable="filtro_estado">
			and <cfif Form.FEstado eq 'I'>not</cfif> exists (	select 1
																from LineaTiempo lt
																where lt.DEid = a.DEid
																  and <cfif isdefined("Application.dsinfo")><cfif Application.dsinfo[session.DSN].type is 'oracle'>sysdate<cfelse>getdate()</cfif><cfelse>getdate()</cfif> 
																   between lt.LTdesde and lt.LThasta )
		</cfsavecontent>																  
	</cfif>
	

<cfif Session.cache_empresarial EQ 0>
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="DatosEmpleado a"/>
		<cfinvokeargument name="columnas" value="a.DEid, a.DEidentificacion, 
												{fn concat(a.DEapellido1,{fn concat(' ',{fn concat(a.DEapellido2,{fn concat(', ',a.DEnombre)})})})} as NombreCompleto"/>
		<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto"/>
		<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_NombreCompleto#"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# #filtro# #filtro_estado# order by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre"/>
		<cfinvokeargument name="align" value="left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="expediente-globalcons.cfm"/>
		<cfinvokeargument name="funcion" value="selEmpl"/>
		<cfinvokeargument name="fparams" value="DEid"/>
		<cfinvokeargument name="formName" value="listaEmpleados"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
		 <cfinvokeargument name="PageIndex" value="1"/>
	</cfinvoke>
<cfelse>
	<cfquery name="rsEmpresaEmpleado" datasource="asp">
		select distinct c.Ereferencia
		from Empresa b, Empresa c
		where b.Ereferencia = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and b.CEcodigo = c.CEcodigo
	</cfquery>

	<cfif rsEmpresaEmpleado.recordCount GT 0>
		<cfset filtro = filtro & " and a.Ecodigo in (#ValueList(rsEmpresaEmpleado.Ereferencia, ',')#)">
	<cfelse>
		<cfset filtro = filtro & " and a.Ecodigo = 0">
	</cfif>
	<!--- Variables de Traduccion --->
	<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="LB_Empresa"
		Default="Empresa"
		returnvariable="LB_Empresa"/>
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaEduRet">
		<cfinvokeargument name="tabla" value="DatosEmpleado a, Empresas d"/>
		<cfinvokeargument name="columnas" value="a.DEid, 
												 a.DEidentificacion, 
												 {fn concat(a.DEapellido1,{fn concat(' ',{fn concat(a.DEapellido2,{fn concat(', ',a.DEnombre)})})})} as NombreCompleto, 
												 d.Edescripcion as Empresa"/>
		<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto, Empresa"/>
		<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_NombreCompleto#, #LB_Empresa#"/>
		<cfinvokeargument name="formatos" value=""/>
		<cfinvokeargument name="filtro" value="a.Ecodigo = d.Ecodigo
												#filtro# #filtro_estado#
												order by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre"/>
		<cfinvokeargument name="align" value="left, left, left"/>
		<cfinvokeargument name="ajustar" value=""/>
		<cfinvokeargument name="irA" value="expediente-globalcons.cfm"/>
		<cfinvokeargument name="funcion" value="selEmpl"/>
		<cfinvokeargument name="fparams" value="DEid"/>
		<cfinvokeargument name="formName" value="listaEmpleados"/>
		<cfinvokeargument name="MaxRows" value="15"/>
		<cfinvokeargument name="navegacion" value="#navegacion#"/>
	</cfinvoke>
</cfif>