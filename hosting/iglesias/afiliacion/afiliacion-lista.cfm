<cfset filtro = "">
<cfset navegacion = "empr=" & Form.empr>
<cfset additionalCols = "">

<cfif isdefined("Url.FPnombre") and not isdefined("Form.FPnombre")>
	<cfset Form.FPnombre = Url.FPnombre>
</cfif>
<cfif isdefined("Url.FPoficina") and not isdefined("Form.FPoficina")>
	<cfset Form.FPoficina = Url.FPoficina>
</cfif>

<cfif isdefined("Form.FPnombre") and Len(Trim(Form.FPnombre)) NEQ 0>
	<cfset filtro = filtro & " and upper(a.Pnombre + ' ' + a.Papellido1 + ' ' + a.Papellido2) like '%#Form.FPnombre#%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPnombre=" & Form.FPnombre>
</cfif>
<cfif isdefined("Form.FPoficina") and Len(Trim(Form.FPoficina)) NEQ 0>
	<cfset filtro = filtro & " and rtrim(a.Poficina) = rtrim('#Form.FPoficina#')">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FPoficina=" & Form.FPoficina>
</cfif>

<cfoutput>
<script language="javascript" type="text/javascript">
	
	function funcNuevo() {
		document.listaPersonas.MEPERSONA.value = '';
		document.listaPersonas.EMPR.value = '#Form.empr#';
	}
	
	function funcEliminar(){
		var elimina = false;
		if (document.listaPersonas.chk) {
			if (document.listaPersonas.chk.value) {
				elimina = document.listaPersonas.chk.checked;
			} else {
				for (var i=0; i<document.listaPersonas.chk.length; i++) {
					if (document.listaPersonas.chk[i].checked) { 
						elimina = true;
						break;
					}
				}
			}
		}
		if (elimina) {
			document.listaPersonas.action = "afiliacion-elimina.cfm";
			document.listaPersonas.EMPR.value = '#Form.empr#';
			document.listaPersonas.PageNum.value = 1;
			document.listaPersonas.StartRow.value = 1;
			return true;
		} else {
			alert('Debe seleccionar al menos un Feligres para Eliminarlo.');
			return false;
		}
	}
	
</script>
<cfquery name="rsCantidad" datasource="#Session.DSN#">
	select count(1) as cant
	from MEPersona
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.empr#">
	and cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	and activo = 1
</cfquery>

<cfquery name="rsMiEmpresa" datasource="asp">
	select Ecodigo, Enombre
	from Empresa
	where CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.CEcodigo#">
	  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.EcodigoSDC#">
</cfquery>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
  <tr>
    <td> <span style="font-size:14px;font-weight:bold;">
			#rsMiEmpresa.Enombre#</span> 
	</td>
    <td align="right">
		<strong>Actualmente hay <cfoutput>#rsCantidad.cant#</cfoutput> feligreses</strong>
	</td>
  </tr>
</table>
<form name="filtroActividades" method="post" action="#CurrentPage#" style="margin:0 ">
<input type="hidden" name="empr" value="#Form.empr#">
<table width="100%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro" align="center">
  <tr> 
    <td class="fileLabel">Nombre</td>
    <td class="fileLabel">Tel&eacute;fono Diurno</td>
	<td>&nbsp;</td>
  </tr>
  <tr>
    <td> 
		<input name="FPnombre" type="text" size="25" maxlength="60" value="<cfif isdefined('Form.FPnombre')>#Form.FPnombre#</cfif>">
    </td>
    <td> 
		<input name="FPoficina" type="text" size="25" maxlength="15" value="<cfif isdefined('Form.FPoficina')>#Form.FPoficina#</cfif>">
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
			<cfinvokeargument name="tabla" value="MEPersona a, asp..Empresa b, asp..UsuarioReferencia c"/>
			<cfinvokeargument name="columnas" value="'#Form.empr#' as empr,
													convert(varchar, a.MEpersona) as MEpersona, 
													rtrim(a.Papellido1 || ' ' || a.Papellido2) || ', ' || a.Pnombre as Nombre, 
													a.Poficina,
													(case when c.Usucodigo is null then '<font color=''##FF0000''>No</font>' else 'Sí' end) as tieneUsuario
													"/>
			<cfinvokeargument name="desplegar" value="Nombre, Poficina, tieneUsuario"/>
			<cfinvokeargument name="etiquetas" value="Nombre Completo, Tel. Diurno, Usuario"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value=" a.Ecodigo = #Form.empr#
													and a.cliente_empresarial = #Session.CEcodigo#
													and a.activo = 1
													#filtro# 
													and a.Ecodigo = b.Ereferencia
													and a.MEpersona *= convert(numeric, c.llave)
													and b.Ecodigo *= c.Ecodigo
													and c.STabla = 'MEPersona'
													order by a.Papellido1, a.Papellido2, a.Pnombre
													"/>
			<cfinvokeargument name="align" value="left, center, center"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="afiliacion.cfm"/>
			<cfinvokeargument name="formName" value="listaPersonas"/>
			<cfinvokeargument name="MaxRows" value="20"/>
			<cfinvokeargument name="keys" value="MEpersona"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="botones" value="Nuevo,Eliminar"/>
			<cfinvokeargument name="checkboxes" value="D"/>
		</cfinvoke>
	</td>
  </tr>
</table>

