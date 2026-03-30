<cfif isdefined("Session.Progreso.CEcodigo")>
	<!--- Hay que obtener los datos del Administrador Correcto --->
	<cfquery name="rsAdministrador" datasource="asp">
		select b.Pnombre, b.Papellido1, b.Papellido2
		from Usuario a, DatosPersonales b
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#"> 
		and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
		and a.datos_personales = b.datos_personales
	</cfquery>
	
	<cfquery datasource="asp" name="Ecorporativa">
		select Ecorporativa
		from CuentaEmpresarial
		where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Progreso.CEcodigo#"> 
	</cfquery>
	<cfif Len(Ecorporativa.Ecorporativa)>
		<cfset Ecorporativa = Ecorporativa.Ecorporativa>
	<cfelse>
		<cfset Ecorporativa = 0>
	</cfif>
	
	<cfif isdefined("Url.FEnombre") and not isdefined("Form.FEnombre")>
		<cfparam name="Form.FEnombre" default="#Url.FEnombre#">
	</cfif>
	
	<cfset navegacion = "o=1">
	<cfif isdefined("Form.FEnombre") and Len(Trim(Form.FEnombre)) NEQ 0>
		<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FEnombre=" & Form.FEnombre>
	</cfif>
	
	<cfquery datasource="asp" name="listaEmp">
		select
			<cfif isdefined("Form.FEnombre") and Len(Trim(Form.FEnombre)) NEQ 0>
				'#Form.FEnombre#' as FEnombre, 
			</cfif>
			Ecodigo as Empresa,
			case when Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecorporativa#">
				then {fn concat(Enombre, ' (Corporativa)')} else Enombre end as Enombre
		from Empresa
		where CEcodigo = #Session.Progreso.CEcodigo# 
		<cfif isdefined("Form.FEnombre") and Len(Trim(Form.FEnombre)) NEQ 0>
		  and upper(Enombre) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#UCase(Form.FEnombre)#%">
		</cfif>
		order by Enombre
	</cfquery>	
	
	<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<cfoutput>
	<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
	<script language="javascript" type="text/javascript">
		function funcCancelar3() {
			showList(false);
		}
	</script>
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	  <tr>
		<td colspan="2" class="tituloProceso" align="center">
			Trabajar con Empresas </td>
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
			<table border="0" cellpadding="2" cellspacing="0" style="height: 24px; ">
				<tr>
					<td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);" onClick="javascript: funcCancelar3();">
						<img src="../imagenes/cancel.gif" border="0" align="top" hspace="2">Cancelar
					</td>
				</tr>
			</table>
		</td>
	  </tr>
	  <tr>
		<td colspan="2">&nbsp;</td>
	  </tr>
	  <tr>
		<td width="20%" rowspan="2" valign="top" class="textoAyuda">
			Seleccione la empresa con la cual desea trabajar
		</td>
		<td style="padding-left: 5px; padding-right: 5px;" valign="top">
			<form name="filtroCuentas" method="post" action="#CurrentPage#">
				<input type="hidden" name="o" value="1">
				<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
				  <tr> 
					<td align="right">Nombre</td>
					<td> 
						<input name="FEnombre" type="text" id="FEnombre" size="40" onfocus="this.select()" maxlength="80" value="<cfif isdefined("Form.FEnombre")>#Form.FEnombre#</cfif>">
					</td>
					<td width="20%" align="center">
					  <input name="btnBuscar" type="submit" id="btnBuscar" value="Buscar">
					</td>
				  </tr>
				</table>
			</form>
		</td>
	  </tr>
	  <tr>
		<td style="padding-left: 5px; padding-right: 5px;" valign="top">
		
		
			<cfinvoke 
			 component="commons.Componentes.pListas"
			 method="pListaQuery"
			 query="#listaEmp#"
			 returnvariable="pListaRet"
				desplegar="Enombre"
				etiquetas="Empresa"
				formatos=""
				align="left"
				ajustar="N"
				irA="#CurrentPage#"
				keys="Empresa"
				Conexion="asp"
				navegacion="#navegacion#"
				maxRows="20"
				debug="N"
				showEmptyListMsg="true" >
			</cfinvoke>
		</td>
	  </tr>
	</table>
	</cfoutput>
</cfif>