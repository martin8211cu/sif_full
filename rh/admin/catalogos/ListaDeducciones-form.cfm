
<cfif isdefined("Url.EIDlote") and not isdefined("Form.EIDlote")>
	<cfset Form.EIDlote = Url.EIDlote>
</cfif>
<cfif isdefined("Url.SNcodigo") and not isdefined("Form.SNcodigo")>
	<cfset Form.SNcodigo = Url.SNcodigo>
</cfif>
<cfif isdefined("Url.TDid") and not isdefined("Form.TDid")>
	<cfset Form.TDid = Url.TDid>
</cfif>
<cfif isdefined("Url.Usuario") and not isdefined("Form.Usuario")>
	<cfset Form.Usuario = Url.Usuario>
</cfif>

<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo)) NEQ 0>
	<cfquery name="rsSocios" datasource="#Session.DSN#">
		select SNcodigo, a.SNnumero, a.SNnombre
		from SNegocios a
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.SNcodigo#">
	</cfquery>
</cfif>

<cfif isdefined("Form.TDid") and Len(Trim(Form.TDid)) NEQ 0>
	<cfquery name="rsTipoDeduccion" datasource="#Session.DSN#">
		select TDid, TDcodigo, TDdescripcion 
		from TDeduccion 
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		  and TDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.TDid#">
	</cfquery>
</cfif>

<cfset filtro = "">
<cfset navegacion = "">

<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario NEQ "-1">
	<cfset filtro = " and a.Usucodigo = " & Form.Usuario >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & Form.Usuario>
<cfelseif not (isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1")>
	<cfset Form.Usuario = Session.Usucodigo >
	<cfset filtro = " and a.Usucodigo = " & Session.Usucodigo >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & Form.Usuario>
<cfelseif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & "-1">
</cfif>

<cfif isdefined("Form.EIDlote") and Len(Trim(Form.EIDlote)) NEQ 0>
	<cfset filtro = filtro & " and a.EIDlote = " & Form.EIDlote >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "EIDlote=" & Form.EIDlote>
</cfif>

<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo)) NEQ 0>
	<cfset filtro = filtro & " and a.SNcodigo = " & Form.SNcodigo >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "SNcodigo=" & Form.SNcodigo>
</cfif>

<cfif isdefined("Form.TDid") and Len(Trim(Form.TDid)) NEQ 0 and Form.TDid NEQ -1>
	<cfset filtro = filtro & " and a.TDid = " & Form.TDid >
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TDid=" & Form.TDid>
</cfif>

<!--- Lista de Usuarios que han registrado valoraciones de puestos --->
<cfquery name="rsUsuariosRegistro" datasource="#Session.DSN#">
	select distinct Usucodigo
	from EIDeducciones
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsUsuarios" datasource="asp">
	select u.Usucodigo as Codigo,
		   <cf_dbfunction name="concat" args="d.Pnombre,' ',d.Papellido1,' ',d.Papellido2"> as Nombre
	from Usuario u, DatosPersonales d
	<cfif rsUsuariosRegistro.recordCount GT 0>
	where u.Usucodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" separator="," value="#ValueList(rsUsuariosRegistro.Usucodigo, ',')#">)
	<cfelse>
	where u.Usucodigo = 0
	</cfif>
	and u.datos_personales = d.datos_personales
</cfquery> 

<!---====== Traducciones =======--->
<!---Lista-lote--->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaLote"
	Default="Lote"	
	returnvariable="vLLote"/>	
<!---Lista-socio--->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaSocio"
	Default="Socio"	
	returnvariable="vLSocio"/>	
<!---Lista-Tipo deduccion--->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaTipoDeduccion"
	Default="Tipo de Deducci&oacute;n"	
	returnvariable="vLTipoDeduccion"/>
<!---Lista-Fecha registro--->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_ListaFechaRegistro"
	Default="Fecha de Registro"	
	returnvariable="vLFechaRegistro"/>	
<!---Msg-Aplicacion de deducciones seleccionadas--->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_que_desea_aplicar_los_lotes_de_deducciones_seleccionadas"
	Default="¿Está seguro de que desea aplicar los lotes de deducciones seleccionadas?"	
	returnvariable="vMAplicacionDeducciones"/>		
<!---Msg-Fecha registro--->	
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Debe_seleccionar_al_menos_un_expediente_antes_de_Aplicar"
	Default="Debe seleccionar al menos un expediente antes de Aplicar"	
	returnvariable="vMSeleccionoExpediente"/>
<!---Boton de aplicar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aplicar"
	Default="Aplicar"	
	xmlfile="/rh/generales.xml"
	returnvariable="vBAplicar"/>
<!---Boton de importar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Importar"
	Default="Importar"	
	xmlfile="/rh/generales.xml"
	returnvariable="vBImportar"/>
<!----Boton Nuevo ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"
	XmlFile="/rh/generales.xml"
	returnvariable="vNuevo"/>	

<link href="/cfmx/rh/css/rh.css" rel="stylesheet" type="text/css">
<script language="javascript" type="text/javascript">
	/* cambiar nombre de la funcion si cambi ael nombre del boton */
	function funcReversar() {
		document.listaDeducciones.action = 'EliminarLoteDeducciones.cfm';
	}

	function funcAplicar() {
		var aplica = false;
		<cfoutput>
		if (document.listaDeducciones.chk) {
			if (document.listaDeducciones.chk.value) {
				aplica = document.listaDeducciones.chk.checked;
			} else {
				for (var i=0; i<document.listaDeducciones.chk.length; i++) {
					if (document.listaDeducciones.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (confirm("#vMAplicacionDeducciones#"));
		} else {
			alert('#vMSeleccionoExpediente#');
			return false;
		}
		</cfoutput>
	}
	
	function funcNuevo() {
		document.listaDeducciones.EIDLOTE.VALUE = "";
	}


	function buttonOver(obj) {
		obj.className="botonDown";
	}

	function buttonOut(obj) {
		obj.className="botonUp";
	}

</script>

<cfoutput>
<form style="margin:0;"  name="filtroDeducciones" method="post" action="#GetFileFromPath(GetTemplatePath())#">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  <tr>
  	<td colspan="3"></td>
	<td  rowspan="4"align="center">
		<cfinvoke component="sif.Componentes.Translate"
		method="Translate"
		Key="BTN_Filtrar"
		Default="Filtrar"
		XmlFile="/rh/generales.xml"
		returnvariable="BTN_Filtrar"/>
		<input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#">
     </td>
  </tr>
  <tr> 
    <td class="fileLabel"><cf_translate key="LB_NumeroLote">N&uacute;mero de Lote</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_SocioNegocio" xmlfile="/rh/generales.xml">Socio de Negocio</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_TipoDeduccion">Tipo Deducci&oacute;n</cf_translate></td>
  </tr>
  <tr>
    <td>
		<input name="EIDlote" type="text" id="EIDlote" size="15" maxlength="15" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif isdefined('Form.EIDlote')>#Form.EIDlote#</cfif>">
	</td>
    <td>
		<cfif isdefined("Form.SNcodigo") and Len(Trim(Form.SNcodigo)) NEQ 0>
			<cf_rhsociosnegociosFA SNtiposocio="A" form="filtroDeducciones" query="#rsSocios#">
		<cfelse>
			<cf_rhsociosnegociosFA SNtiposocio="A" form="filtroDeducciones">
		</cfif>
	</td>
    <td>
		<cfif isdefined('Form.TDid') and Len(Trim(Form.TDid)) NEQ 0>
			<cf_rhtipodeduccion size="40" form="filtroDeducciones" query="#rsTipoDeduccion#" validate="1">
		<cfelse>
			<cf_rhtipodeduccion size="40" form="filtroDeducciones" validate="1">
		</cfif>
	</td>
 </tr>
 <tr>
   		<td class="fileLabel"><cf_translate key="LB_UsuarioqueRegistro">Usuario que Registr&oacute;</cf_translate></td>
		<td  colspan="2"></td>
 </tr>
 <tr>
   	<td>
	    <select name="Usuario">
		      <option value="-1" <cfif Form.Usuario EQ "-1">selected</cfif>><cf_translate key="CMB_Todos" xmlfile="/rh/generales.xml">(Todos)</cf_translate></option>
		      <cfloop query="rsUsuarios">
		        <option value="#rsUsuarios.Codigo#" <cfif Form.Usuario EQ rsUsuarios.Codigo>selected</cfif>>#rsUsuarios.Nombre#</option>
		        </cfloop>
	      </select>
	 <br> 
	 </td>
	<td  colspan="2" align="right" height="40" >
		<table width="25%" cellpadding="2" cellspacing="0" align="right">
			<tr><td class="botonUp" valign="middle" onmouseover="javascript: buttonOver(this);" onmouseout="javascript: buttonOut(this);">
				
					<table cellpadding="3">
						<tr>
							<td align="right"><a href="EliminarLoteDeducciones.cfm" style=" cursor:pointer; text-decoration:none;"><img style="border:0"; src="/cfmx/rh/imagenes/undo.small.png" /></a></td>
							<td nowrap="nowrap" align="right" ><a href="EliminarLoteDeducciones.cfm" style=" cursor:pointer; text-decoration:none;">Reversar Lotes aplicados</a></td>
						</tr>
					</table>
			</td></tr>
		</table>
	</td>
 </tr>

</table>
</form>
</cfoutput>

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>
		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaRH"
		 returnvariable="pListaRet">
			<cfinvokeargument name="tabla" value="EIDeducciones a, SNegocios b, TDeduccion c"/>
			<cfinvokeargument name="columnas" value="a.EIDlote, 
													a.TDid, 
													a.SNcodigo, 
													a.Usucodigo, 
													a.Ulocalizacion, 
													a.Usucodigo2, 
													a.Ulocalizacion2, 
													a.EIDfecha as FechaRegistro,
													a.EIDfechaaplic, 
													a.EIDestado,
													b.SNnombre as Socio,
													c.TDdescripcion as TipoDeduccion
													"/>
			<cfinvokeargument name="desplegar" value="EIDlote, Socio, TipoDeduccion, FechaRegistro"/>
			<cfinvokeargument name="etiquetas" value="#vLLote#, #vLSocio#,#vLTipoDeduccion#,#vLFechaRegistro#"/>
			<cfinvokeargument name="formatos" value="V,V,V,D"/>
			<cfinvokeargument name="filtro" value=" a.Ecodigo = #Session.Ecodigo# 
													#filtro#
													and a.EIDestado = 0
													and a.SNcodigo = b.SNcodigo
													and a.Ecodigo = b.Ecodigo
													and a.TDid = c.TDid
													order by a.EIDlote, a.EIDfecha"/>
			<cfinvokeargument name="align" value="left, left, center, center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="botones" value="Aplicar,Importar,Nuevo"/>
			<cfinvokeargument name="irA" value="/cfmx/rh/admin/catalogos/ListaDeducciones-sql.cfm"/>
			<cfinvokeargument name="keys" value="EIDlote"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="formName" value="listaDeducciones"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
		</cfinvoke>
	</td>
  </tr>
</table>
