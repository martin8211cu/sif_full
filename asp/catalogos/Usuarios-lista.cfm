<cfset acceso_cuenta = acceso_uri('/asp/catalogos/Cuentas.cfm')>
<cfquery name="rsCuentas" datasource="asp">
	select CEcodigo, CEnombre
	from CuentaEmpresarial
	<cfif not acceso_cuenta>
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	</cfif>
</cfquery>

<cfif isdefined("Session.Progreso.CEcodigo")>
	<cfparam name="Form.FCuenta" default="#Session.Progreso.CEcodigo#">
<cfelse>
	<cfset Session.Progreso.CEcodigo = rsCuentas.CEcodigo>
	<cfparam name="Form.FCuenta" default="#rsCuentas.CEcodigo#">
</cfif>

<!--- Hay que obtener los datos del Administrador Correcto --->
<cfquery name="rsAdministrador" datasource="asp">
	select b.Pnombre, b.Papellido1, b.Papellido2
	from Usuario a, DatosPersonales b
	where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#"> 
	and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#"> 
	and a.datos_personales = b.datos_personales
</cfquery>

	
<cfif acceso_cuenta and isdefined("form.fCuenta") and isdefined("session.progreso.CEcodigo") and form.fCuenta neq session.progreso.CEcodigo>
	<cfset session.progreso.CEcodigo = form.fCuenta >
</cfif>


<cfif isdefined("Url.FCuenta") and not isdefined("Form.FCuenta")>
	<cfparam name="Form.FCuenta" default="#Url.FCuenta#">
</cfif>
<cfif isdefined("Url.FPid") and not isdefined("Form.FPid")>
	<cfparam name="Form.FPid" default="#Url.FPid#">
</cfif>
<cfif isdefined("Url.FNombre") and not isdefined("Form.FNombre")>
	<cfparam name="Form.FNombre" default="#Url.FNombre#">
</cfif>
<cfif isdefined("Url.FPapellido1") and not isdefined("Form.FPapellido1")>
	<cfparam name="Form.FPapellido1" default="#Url.FPapellido1#">
</cfif>
<cfif isdefined("Url.FPapellido2") and not isdefined("Form.FPapellido2")>
	<cfparam name="Form.FPapellido2" default="#Url.FPapellido2#">
</cfif>
	

<cfset filtro = " a.datos_personales = b.datos_personales">
<cfset additionalCols = "">
<cfset navegacion = "o=1">

<cfif isdefined("Form.FCuenta") and Len(Trim(Form.FCuenta)) NEQ 0>
	<cfset filtro = filtro & " and a.CEcodigo = #Form.FCuenta#" >
	<cfset additionalCols = additionalCols & "'#Form.FCuenta#' as FCuenta, ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FCuenta=" & Form.FCuenta>
</cfif>	
<cfif isdefined("Form.FPid") and Len(Trim(Form.FPid)) NEQ 0>
	<cfset filtro = filtro &  " and upper(Pid) like upper('%#Form.FPid#%')" >
	<cfset additionalCols = additionalCols & "'#Form.FPid#' as FPid, ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPid=" & Form.FPid>
</cfif>	
<cfif isdefined("Form.FNombre") and Len(Trim(Form.FNombre)) NEQ 0>
	<cfset filtro = filtro &  " and upper(Pnombre) like upper('%#Form.FNombre#%')" >
	<cfset additionalCols = additionalCols & "'#Form.FNombre#' as FNombre, ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FNombre=" & Form.FNombre>
</cfif>	
<cfif isdefined("Form.FPapellido1") and len(trim(Form.FPapellido1)) NEQ 0>
	<cfset filtro = filtro &  " and upper(Papellido1) like upper('%#Form.FPapellido1#%')" >
	<cfset additionalCols = additionalCols & "'#Form.FPapellido1#' as FPapellido1, ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPapellido1=" & Form.FPapellido1>
</cfif>	
<cfif isdefined("Form.FPapellido2") and len(trim(Form.FPapellido2)) NEQ 0>
	<cfset filtro = filtro &  " and upper(Papellido2) like upper('%#Form.FPapellido2#%')" >
	<cfset additionalCols = additionalCols & "'#Form.FPapellido2#' as FPapellido2, ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPapellido2=" & Form.FPapellido2>
</cfif>	
<cfif isdefined("Form.flogin") and len(trim(Form.flogin)) NEQ 0>
	<cfset filtro = filtro &  " and upper(Usulogin) like upper('#Form.flogin#%')" >
	<cfset additionalCols = additionalCols & "'#Form.flogin#' as flogin, ">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "flogin=" & Form.flogin>
</cfif>

<cfif isdefined("Form.fUestadoUtemporal") and len(trim(Form.fUestadoUtemporal)) NEQ 0 and Form.fUestadoUtemporal eq '10'>
	<!--- Busca Usuarios Activos --->
	<cfset filtro = filtro &  " and a.Uestado = 1 and a.Utemporal = 0">
<cfelseif isdefined("Form.fUestadoUtemporal") and len(trim(Form.fUestadoUtemporal)) NEQ 0 and Form.fUestadoUtemporal eq '0'>    
	<!--- Busca usuarios Inactivos --->
    <cfset filtro = filtro &  " and a.Uestado = 0">
<cfelseif isdefined("Form.fUestadoUtemporal") and len(trim(Form.fUestadoUtemporal)) NEQ 0 and Form.fUestadoUtemporal eq '11'>    
	<!--- Busca usuarios Inactivos --->
    <cfset filtro = filtro &  " and a.Uestado = 1 and a.Utemporal = 1">
<cfelse>
	<!--- filtra por defecto para ver los usuarios activos --->
	<cfset filtro = filtro &  " and a.Uestado = 1 and a.Utemporal = 0">
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
	<link href="/cfmx/asp/css/asp.css" type="text/css" rel="stylesheet">
	<cfoutput>
	<script language="javascript" type="text/javascript">
		function funcCancelar3() {
			<cfif CurrentPage EQ "Permisos.cfm">
				location.href = "/cfmx/asp/index.cfm";
			<cfelse>
				showList(false);
			</cfif>
		}

		function buttonOver(obj) {
			obj.className="botonDown";
		}
	
		function buttonOut(obj) {
			obj.className="botonUp";
		}
		
	</script>
	<table width="100%"  border="0" cellspacing="0" cellpadding="3">
	  <tr>
		<td colspan="2" class="tituloProceso" align="center">
			Trabajar con Usuarios
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
			<table border="0" cellpadding="2" cellspacing="0" style="height: 20px; ">
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
			<cfif pagina EQ "Permisos.cfm">
				<b>Asignaci&oacute;n de Permisos</b><br>
				Para poder asignar permisos a Usuarios, debe seleccionar primero la Cuenta Empresarial con la que desea trabajar y luego seleccionar el Usuario al que se le asignar&aacute;n los permisos.<br>
			<cfelse>
				Seleccione el usuario con el que desea trabajar
			</cfif>
		</td>
		<td>
        <form style="margin:0; " name="filtroUsuarios" method="post" action="#CurrentPage#">
		  <input type="hidden" name="o" value="1">

          <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
              <td class="selectpicker" width="1%" nowrap><font size="3"><b>Cuenta Empresarial:&nbsp;</b></font></td>
              <td class="selectpicker">
                <select name="fCuenta" class="selectpicker" onChange="document.filtroUsuarios.action='';document.filtroUsuarios.submit();">
                  <cfloop query="rsCuentas">
                    <option value="#rsCuentas.CEcodigo#" <cfif isdefined("session.progreso.CEcodigo") and session.progreso.CEcodigo eq rsCuentas.CEcodigo>selected</cfif> >#rsCuentas.CEnombre#</option>
                  </cfloop>
                </select>
              </td>
            </tr>
          </table>
          <br>
          <table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
		    <tr>

			  <td align="left" nowrap class="selectpicker">Identificaci&oacute;n</td>
		      <td align="left" nowrap class="selectpicker">Nombre</td>
		      <td align="left" nowrap class="selectpicker">Apellido1</td>
			  <td align="left" nowrap class="selectpicker">Apellido2</td>
			  <td align="left" nowrap class="selectpicker">Login</td>
              <td align="left" nowrap class="selectpicker">Estado</td>
		      <td align="center" nowrap>
                    <input class="selectpicker" name="btnBuscar" type="submit" id="btnBuscar" value="Filtrar">
			  </td>
	        </tr>
		    <tr>
            	<td align="left" style="padding-right: 5px;" nowrap>
              		<input name="fPid" type="text" id="fPid" size="15" maxlength="60" value="<cfif isdefined("Form.fPid")>#Form.fPid#</cfif>" style="width: 100%;">
			    </td>
            	<td align="left" style="padding-right: 5px;" nowrap>
					<input name="fNombre" type="text" id="fNnombre" size="12" maxlength="60" value="<cfif isdefined("Form.fNombre")>#Form.fNombre#</cfif>" style="width: 100%;">
                </td>
            	<td align="left" style="padding-right: 5px;" nowrap>
					<input name="fPapellido1" type="text" id="fPapellido1" size="12" maxlength="60" value="<cfif isdefined("Form.fPapellido1")>#Form.fPapellido1#</cfif>">
				</td>
				<td>
              		<input name="fPapellido2" type="text" id="fPapellido2" size="12" maxlength="60" value="<cfif isdefined("Form.fPapellido2")>#Form.fPapellido2#</cfif>">
                </td>
				<td>
              		<input name="flogin" type="text" id="flogin" size="10" maxlength="20" value="<cfif isdefined("Form.flogin")>#Form.flogin#</cfif>">
                </td>
                
                <td>
                    <select name="fUestadoUtemporal" id="fUestadoUtemporal">
                    	<option <cfif isdefined("Form.fUestadoUtemporal") and Form.fUestadoUtemporal eq '10'>selected</cfif> value="10">Activo</option>
                        <option <cfif isdefined("Form.fUestadoUtemporal") and Form.fUestadoUtemporal eq '0'>selected</cfif> value="0">Inactivo</option>
                        <option <cfif isdefined("Form.fUestadoUtemporal") and Form.fUestadoUtemporal eq '11'>selected</cfif> value="11">Temporal</option>
                    </select>
                </td>
                <td width="10%" align="center" nowrap>
                  <input class="label" name="btnLimpiar" type="button" id="btnBuscar" value="Limpiar" onClick="limpiar();">
                </td>
            </tr>
          </table>
        </form>
		</td>
	  </tr>
	  <tr>
		<td>
		  <cfinvoke 
			 component="commons.Componentes.pListas"
			 method="pListaRH"
			 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="Usuario a, DatosPersonales b"/>
			<cfinvokeargument name="columnas" value="#additionalCols# a.Usucodigo, a.CEcodigo, b.Pid, b.Pnombre, b.Papellido1, b.Papellido2,
													(case 
														when a.Uestado = 0 then '<font color=''##FF0000''>Inactivo</font>' 
														when a.Uestado = 1 and a.Utemporal = 1 then 'Temporal' 
														when a.Uestado = 1 and a.Utemporal = 0 then '<font color=''##009900''>Activo</font>' 
														else '' 
													end) as Estado, Usulogin
													"/>
			<cfinvokeargument name="desplegar" value="Pid,Pnombre,Papellido1,Papellido2,Usulogin,Estado"/>
			<cfinvokeargument name="etiquetas" value="Identificación,Nombre,Apellido1,Apellido2,Login,Estado"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="#filtro#"/>
			<cfinvokeargument name="align" value="left,left,left,left,left,center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="irA" value="#CurrentPage#"/>
			<cfinvokeargument name="keys" value="CEcodigo, Usucodigo"/>
			<cfinvokeargument name="Conexion" value="asp"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="maxRows" value="20"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="true"/>
		  </cfinvoke>
		</td>
	  </tr>
	</table>
	</cfoutput>
	<script language="javascript1.2" type="text/javascript">
		function limpiar(){
			document.filtroUsuarios.fPid.value = '';
			document.filtroUsuarios.fNombre.value = '';
			document.filtroUsuarios.fPapellido1.value = '';
			document.filtroUsuarios.fPapellido2.value = '';
			document.filtroUsuarios.flogin.value = '';
		}
	</script>
