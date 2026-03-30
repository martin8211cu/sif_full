<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Seleccione_la_institucion_con_la_cual_desea_trabajar"
Default="Seleccione la instituci&oacute;n con la cual desea trabajar"
returnvariable="LB_Seleccione_la_institucion_con_la_cual_desea_trabajar"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Institucion"
Default="Instituci&oacute;n"
returnvariable="LB_Institucion"/>

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_Administracion_de_Instituciones"
Default="Administraci&oacute;n de Instituciones"
returnvariable="LB_Administracion_de_Instituciones"/>

<!--- Hay que obtener los datos del Administrador Correcto --->
<cfquery name="rsAdministrador" datasource="asp">
	select b.Pnombre, b.Papellido1, b.Papellido2
	from Usuario a, DatosPersonales b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#"> 
	and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
	and a.datos_personales = b.datos_personales
</cfquery>

<cfif isdefined("Url.FCEnombre") and not isdefined("Form.FCEnombre")>
	<cfparam name="Form.FCEnombre" default="#Url.FCEnombre#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "o=1">
<cfif isdefined("Form.FCEnombre") and Len(Trim(Form.FCEnombre)) NEQ 0>
 	<cfset filtro = filtro & " and upper(CEnombre) like '%" & UCase(Form.FCEnombre) & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FCEnombre=" & Form.FCEnombre>
</cfif>
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfoutput>
<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">

<script language="javascript" type="text/javascript">
	function funcCancelar2() {
		<cfif isdefined("Session.Progreso.Pantalla") and Session.Progreso.Pantalla EQ "1">
			showList(false);
		</cfif>
		<cfif isdefined("Session.Progreso.Pantalla") and Session.Progreso.Pantalla NEQ "1">
			location.href = '/cfmx/rh/ExpDeportivo/Proyecto/index.cfm';
		</cfif>
	}
</script>

<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td colspan="2" class="tituloProceso" align="center">
		#LB_Administracion_de_Instituciones#
	</td>
  </tr>
  <tr>
	<td colspan="2" class="tituloPersona" nowrap>
		#rsAdministrador.Pnombre#
		#rsAdministrador.Papellido1#
		#rsAdministrador.Papellido2#
	</td>
  </tr>
  <tr>
  	<td colspan="2">&nbsp;</td>
  </tr>
  <tr>
  	<td colspan="2" bgcolor="##A0BAD3">
		<cfinclude template="frame-cancelar.cfm">
	</td>
  </tr>
  <tr>
  	<td colspan="2">&nbsp;</td>
  </tr>
  <tr>
    <td width="20%" rowspan="2" valign="top" class="textoAyuda">
		#LB_Seleccione_la_institucion_con_la_cual_desea_trabajar#
	</td>
    <td style="padding-left: 5px; padding-right: 5px;" valign="top">
		 <form name="filtroCuentas" method="post" action="#CurrentPage#">
			<input type="hidden" name="o" value="1">
			<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			  <tr> 
				<td align="right" class="etiquetaCampo" nowrap>Instituciones</td>
				<td nowrap> 
					<input name="FCEnombre" type="text" id="FCEnombre" size="40" maxlength="80" value="<cfif isdefined("Form.FCEnombre")>#Form.FCEnombre#</cfif>">				</td>
				<td width="20%" align="center" nowrap>
				  <input name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">				</td>
			  </tr>
		  </table>
		</form>
	</td>
  </tr>
  <tr>
    <td style="padding-left: 5px; padding-right: 5px;" valign="top">
	<!--- <cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="CuentaEmpresarial"/>
		<cfinvokeargument name="columnas" value="CEcodigo,CEcuenta,CEnombre"/>
		<cfinvokeargument name="desplegar" value="CEcuenta,CEnombre"/>
		<cfinvokeargument name="etiquetas" value="Id,Proyecto"/>
		<cfinvokeargument name="formatos" value="V, V"/>
		<cfinvokeargument name="filtro" value=" 1=1 #filtro# order by CEnombre"/>
		<cfinvokeargument name="align" value="left,left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="irA" value="#CurrentPage#"/>
		<cfinvokeargument name="keys" value="CEcodigo"/>
		<cfinvokeargument name="Conexion" value="asp"/>
	</cfinvoke> --->
	
	<cfinvoke 
	 component="rh.Componentes.pListas"
	 method="pListaRH"
	 returnvariable="pListaRet">
		<cfinvokeargument name="tabla" value="CuentaEmpresarial"/>
		<cfinvokeargument name="columnas" value="CEcodigo,CEnombre"/>
		<cfinvokeargument name="desplegar" value="CEnombre"/>
		<cfinvokeargument name="etiquetas" value="#LB_Institucion#"/>
		<cfinvokeargument name="formatos" value="V"/>
		<cfinvokeargument name="filtro" value=" CEProyecto = 1  #filtro# order by CEnombre"/>
		<cfinvokeargument name="align" value="left"/>
		<cfinvokeargument name="ajustar" value="N"/>
		<cfinvokeargument name="checkboxes" value="N"/>
		<cfinvokeargument name="irA" value="#CurrentPage#"/>
		<cfinvokeargument name="keys" value="CEcodigo"/>
		<cfinvokeargument name="Conexion" value="asp"/>
	</cfinvoke>
	
	</td>
  </tr>
</table>
</cfoutput>
