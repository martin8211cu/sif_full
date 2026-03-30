<cfif isdefined("Url.nombreFiltro") and not isdefined("Form.nombreFiltro")>
	<cfparam name="Form.nombreFiltro" default="#Url.nombreFiltro#">
</cfif>
<cfif isdefined("Url.DEidentificacionFiltro") and not isdefined("Form.DEidentificacionFiltro")>
	<cfparam name="Form.DEidentificacionFiltro" default="#Url.DEidentificacionFiltro#">
</cfif>		
<cfif isdefined("Url.filtrado") and not isdefined("Form.filtrado")>
	<cfparam name="Form.filtrado" default="#Url.filtrado#">
</cfif>	
<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
	<cfparam name="Form.DEid" default="#Url.DEid#">
</cfif>
<cfif isdefined("Url.sel") and not isdefined("Form.sel")>
	<cfparam name="Form.sel" default="#Url.sel#">
</cfif>		

<cfset filtro = "">
<cfset navegacion = "">
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "filtrado=Filtrar">
<cfif isdefined("Form.DEid")>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & #form.DEid#>				
</cfif>

<cfif isdefined("Form.nombreFiltro") and Len(Trim(Form.nombreFiltro)) NEQ 0>
	<cfset filtro = filtro & " and upper((DEapellido1 + ' ' + DEapellido2 + ', ' + DEnombre)) like '%" & #UCase(Form.nombreFiltro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "nombreFiltro=" & Form.nombreFiltro>
</cfif>
<cfif isdefined("Form.DEidentificacionFiltro") and Len(Trim(Form.DEidentificacionFiltro)) NEQ 0>
	<cfset filtro = filtro & " and upper(DEidentificacion)  like '%" & #UCase(Form.DEidentificacionFiltro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEidentificacionFiltro=" & Form.DEidentificacionFiltro>
</cfif>
<cfif isdefined("Form.sel") and form.sel NEQ 1>
<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "sel=" & #form.sel#>				
</cfif>		

<table width="100%" border="0" cellspacing="0" cellpadding="0">

<tr style="display: ;" id="verFiltroListaEmpl"> 
  <td> 
	<form name="formFiltroListaEmpl" method="post">
		<input type="hidden" name="filtrado" value="<cfif isdefined('form.btnFiltrar') or isdefined('form.filtrado')>Filtrar</cfif>">
		<input type="hidden" name="sel" value="<cfif isdefined('form.sel')><cfoutput>#form.sel#</cfoutput><cfelse>0</cfif>">
		<table width="90%" border="0" cellspacing="0" cellpadding="0" class="areaFiltro" align="center">
			<tr> 
				<td width="25%" height="17" class="fileLabel">Identificaci&oacute;n</td>
				<td width="70%" class="fileLabel">Nombre del empleado</td>
				<td width="5%" rowspan="2" class="fileLabel"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar"></td>
			</tr>
			<tr> 
				<td>
					<input name="DEidentificacionFiltro" type="text" id="DEidentificacionFiltro" size="30" maxlength="60" value="<cfif isdefined('form.DEidentificacionFiltro')><cfoutput>#form.DEidentificacionFiltro#</cfoutput></cfif>">
				</td>
				<td>
					<input name="nombreFiltro" type="text" id="nombreFiltro2" size="100" maxlength="260" value="<cfif isdefined('form.nombreFiltro')><cfoutput>#form.nombreFiltro#</cfoutput></cfif>">
				</td>
			</tr>
		</table>
	</form>
  </td>
</tr>		

<tr style="display: ;" id="verLista"> 
  <td> 
	<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">
	  <tr>
		<td>
		<cfif Session.cache_empresarial EQ 0>
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaEmpl">
				<cfinvokeargument name="tabla" value="DatosEmpleado a"/>
				<cfinvokeargument name="columnas" value="a.DEid, a.DEidentificacion, a.DEapellido1 || ' ' || a.DEapellido2 || ', ' || a.DEnombre as NombreCompleto,o=1,sel=1"/>
				<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto"/>
				<cfinvokeargument name="etiquetas" value="Identificación, Nombre Completo"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="a.Ecodigo = #Session.Ecodigo# #filtro# order by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre"/>
				<cfinvokeargument name="align" value="left, left"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="HistoricoPagos.cfm"/>
				<cfinvokeargument name="formName" value="listaEmpleados"/>
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
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
		
			<cfinvoke 
			 component="rh.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaEduRet">
				<cfinvokeargument name="tabla" value="DatosEmpleado a, Empresas d"/>
				<cfinvokeargument name="columnas" value="a.DEid, a.DEidentificacion, a.DEapellido1 || ' ' || a.DEapellido2 || ', ' || a.DEnombre as NombreCompleto, d.Edescripcion as Empresa, 1 as o, 1 as sel"/>
				<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto, Empresa"/>
				<cfinvokeargument name="etiquetas" value="Identificación, Nombre Completo, Empresa"/>
				<cfinvokeargument name="formatos" value=""/>
				<cfinvokeargument name="filtro" value="a.Ecodigo = d.Ecodigo
														#filtro# 
														order by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre"/>
				<cfinvokeargument name="align" value="left, left, left"/>
				<cfinvokeargument name="ajustar" value=""/>
				<cfinvokeargument name="irA" value="HistoricoPagos.cfm"/>
				<cfinvokeargument name="formName" value="listaEmpleados"/>
				<cfinvokeargument name="MaxRows" value="15"/>
				<cfinvokeargument name="navegacion" value="#navegacion#"/>
			</cfinvoke>
		</cfif>
		</td>
	  </tr>
	</table>
  </td>
</tr>
<tr style="display: ;" id="verPagina"> 
  <td> 
    <cfif isDefined("Form.DEid") and len(trim(Form.DEid)) gt 0>
			<table width="90%" border="0" cellpadding="0" cellspacing="0" align="center">
			  <tr>
				<td>
					<cfinclude template="/rh/portlets/pEmpleado.cfm">
				</td>
			  </tr>
			  <tr>
				<td>&nbsp;
				</td>
			  </tr>
			  <tr>
				<td>
					<cfinclude template="frame-pagosRealizados.cfm">
				</td>
			  </tr>
			</table>
	<cfelse>
		<p class="tituloAlterno">Debe Seleccionar un Empleado.</p>
	</cfif>
  </td>
</tr>
</table>

<script language="JavaScript" type="text/javascript">
	var Bandera = "L";
	function buscar(){
		var connVerLista			= document.getElementById("verLista");
		var connVerPagina			= document.getElementById("verPagina");				
		var connVerFiltroListaEmpl	= document.getElementById("verFiltroListaEmpl");								
		
		if(document.formFiltroListaEmpl.filtrado.value != "")
			Bandera = "L";
			
		if(document.formFiltroListaEmpl.sel.value == "1")
			Bandera = "P";					
	
		if(Bandera == "L"){	// Ver Lista
			Bandera = "P";
			connVerLista.style.display = "";
			connVerFiltroListaEmpl.style.display = "";					
			connVerPagina.style.display = "none";
		}else{	//Pagina
			Bandera = "L";				
			connVerLista.style.display = "none";
			connVerFiltroListaEmpl.style.display = "none";					
			connVerPagina.style.display = "";
		}
	}
	function limpiaFiltrado(){
		document.formFiltroListaEmpl.filtrado.value = "";
		document.formFiltroListaEmpl.sel.value = 0;
	}
	buscar();
</script>