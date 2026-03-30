<cfif isdefined("Url.RHAlote") and not isdefined("Form.RHAlote")>
	<cfset Form.RHAlote = Url.RHAlote>
</cfif>
<cfif isdefined("Url.RHAfdesde") and not isdefined("Form.RHAfdesde")>
	<cfset Form.RHAfdesde = Url.RHAfdesde>
</cfif>
<cfif isdefined("Url.RHAfecha") and not isdefined("Form.RHAfecha")>
	<cfset Form.RHAfecha = Url.RHAfecha>
</cfif>
<cfif isdefined("Url.Usuario") and not isdefined("Form.Usuario")>
	<cfset Form.Usuario = Url.Usuario>
</cfif>

<cfset navegacion = "">

<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario NEQ "-1">
	<cfset a = ListToArray(Form.Usuario, '|')>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & Form.Usuario>
<cfelseif not (isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1")>
	<cfset Form.Usuario = Session.Usucodigo>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & Form.Usuario>
<cfelseif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario EQ "-1">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Usuario=" & "-1">
</cfif>

<cfif isdefined("Form.RHAlote") and Len(Trim(Form.RHAlote)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHAlote=" & Form.RHAlote>
</cfif>
<cfif isdefined("Form.RHAfdesde") and Len(Trim(Form.RHAfdesde)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHAfdesde=" & Form.RHAfdesde>
</cfif>
<cfif isdefined("Form.RHAfecha") and Len(Trim(Form.RHAfecha)) NEQ 0>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHAfecha=" & Form.RHAfecha>
</cfif>

<cfquery name="rsUsuariosRegistro" datasource="#Session.DSN#">
	select distinct Usucodigo
	from RHEAumentos
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfquery name="rsUsuarios" datasource="asp">
	select u.Usucodigo as Codigo,
		   {fn concat({fn concat({fn concat({ fn concat( d.Pnombre, ' ') },d.Papellido1)}, ' ')}, d.Papellido2) } as Nombre
	from Usuario u, DatosPersonales d
	<cfif rsUsuariosRegistro.recordCount GT 0>
	where u.Usucodigo in (<cfqueryparam cfsqltype="cf_sql_numeric" list="yes" separator="," value="#ValueList(rsUsuariosRegistro.Usucodigo, ',')#">)
	<cfelse>
	where u.Usucodigo = 0
	</cfif>
	and u.datos_personales = d.datos_personales
</cfquery> 
<!---====== Traducciones =======--->
<!--MSG Aplicacion relaciones --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Esta_seguro_de_que_desea_aplicar_las_relaciones_de_aumento_seleccionadas"
	Default="¿Está seguro de que desea aplicar las relaciones de aumento seleccionadas?"	
	returnvariable="LB_AplicacionRelacionAumento"/>	
<!--MSG Seleccion relac.aumento --->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Debe-seleccionar_al_menos_un_relación_de_aumento_antes_de_Aplicar"
	Default="Debe seleccionar al menos una relación de aumento antes de Aplicar"	
	returnvariable="LB_SeleccionRelacionAumento"/>

<!---Lista-Lote ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Lote"
	Default="Lote"
	returnvariable="LB_Lote"/>
<!---Lista-Fecha vigencia ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_Vigencia"
	Default="Fecha de Vigencia"
	returnvariable="LB_Fecha_de_Vigencia"/>
<!---Lista-Fecharegistro ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_Fecha_de_Registro"
	Default="Fecha de Registro"
	returnvariable="LB_Fecha_de_Registro"/>
<!---Lista-No registros ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="LB_No_hay_nigun_lote_de_aumentos_salariales_pendiente_por_aplicar"
	Default="-- No hay nigun lote de aumentos salariales pendiente por aplicar --"
	returnvariable="LB_EmptyListMsg"/>

<!---Boton Filtrar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Filtrar"
	Default="Filtrar"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Filtrar"/>	
<!---Boton de aplicar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Aplicar"
	Default="Aplicar"	
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Aplicar"/>
<!---Boton de importar ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Importar"
	Default="Importar"	
	xmlfile="/rh/generales.xml"
	returnvariable="BTN_Importar"/>
<!----Boton Nuevo ---->
<cfinvoke component="sif.Componentes.Translate"
	method="Translate"
	Key="BTN_Nuevo"
	Default="Nuevo"
	XmlFile="/rh/generales.xml"
	returnvariable="BTN_Nuevo"/>	

<script language="javascript" type="text/javascript" src="/cfmx/rh/js/utilesMonto.js">//utiles</script>
<script language="javascript" type="text/javascript">
	function funcAplicar() {
		<cfoutput>
		var aplica = false;
		if (document.listaAumentos.chk) {
			if (document.listaAumentos.chk.value) {
				aplica = document.listaAumentos.chk.checked;
			} else {
				for (var i=0; i<document.listaAumentos.chk.length; i++) {
					if (document.listaAumentos.chk[i].checked) { 
						aplica = true;
						break;
					}
				}
			}
		}
		if (aplica) {
			return (confirm("#LB_AplicacionRelacionAumento#"));
		} else {
			alert('#LB_SeleccionRelacionAumento#');
			return false;
		}
		</cfoutput>
	}
	
	function funcNuevo() {
		document.listaAumentos.RHAID.VALUE = "";
	}

</script>

<cfoutput>
<form name="filtroAumentos" method="post" action="#GetFileFromPath(GetTemplatePath())#" style="margin: 0; ">
<table width="100%" border="0" cellspacing="0" cellpadding="2" class="areaFiltro">
  <tr> 
    <td class="fileLabel"><cf_translate key="LB_NumeroDeLote">N&uacute;mero de Lote</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_FechaDeVigencia">Fecha de Vigencia</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_FechaDeRegistro">Fecha de Registro</cf_translate></td>
    <td class="fileLabel"><cf_translate key="LB_UsuarioQueRegistro">Usuario que Registr&oacute;</cf_translate></td>
    <td class="fileLabel">&nbsp;</td>
  </tr>
  <tr>
    <td>
		<input name="RHAlote" type="text" id="RHAlote" size="15" maxlength="15" onFocus="this.value=qf(this); this.select();" onBlur="javascript: fm(this,0);"  onKeyUp="if(snumber(this,event,0)){ if(Key(event)=='13') {this.blur();}}" style="text-align: right;" value="<cfif isdefined('Form.RHAlote')>#Form.RHAlote#</cfif>">
	</td>
    <td>
		<cfif isdefined("Form.RHAfdesde")>
			<cfset fechadesde = Form.RHAfdesde>
		<cfelse>
			<cfset fechadesde = "">
		</cfif>
		<cf_sifcalendario name="RHAfdesde" form="filtroAumentos" value="#fechadesde#">
	</td>
    <td>
		<cfif isdefined("Form.RHAfecha")>
			<cfset fechareg = Form.RHAfecha>
		<cfelse>
			<cfset fechareg = "">
		</cfif>
		<cf_sifcalendario name="RHAfecha" form="filtroAumentos" value="#fechareg#">
	</td>
    <td>
	  <select name="Usuario">
		  <option value="-1" <cfif Form.Usuario EQ "-1">selected</cfif>><cf_translate key="CMB_Todos" xmlfile="/rh/generales.xml">(Todos)</cf_translate></option>
		<cfloop query="rsUsuarios">
		  <option value="#rsUsuarios.Codigo#" <cfif Form.Usuario EQ rsUsuarios.Codigo>selected</cfif>>#rsUsuarios.Nombre#</option>
		</cfloop>
	  </select>
	</td>
	<td align="center">
		<input name="btnBuscar" type="submit" id="btnBuscar" value="#BTN_Filtrar#">
	</td>
  </tr>
</table>
</form>
</cfoutput>

<cfinclude template="RelacionAumento-Observacion.cfm">

<table width="98%" border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td>&nbsp;</td>
  </tr>
  <tr>
    <td style="border-bottom: 1px solid black"><strong><cf_translate key="LB_ListaDeLotesDeAumentosSalariales">Lista de Lotes de Aumentos Salariales:</cf_translate></strong></td>
  </tr>
  <tr>
    <td>
		<cfquery name="rsListaAumentos" datasource="#Session.DSN#">
			select a.RHAid, a.RHAlote as lote, 
				   a.RHAfecha as fregistro, 
				   a.RHAfdesde as fvigencia
			from RHEAumentos a
			where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">

			<cfif isdefined("Form.Usuario") and Len(Trim(Form.Usuario)) NEQ 0 and Form.Usuario NEQ "-1">
				and a.Usucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Usuario#">
			</cfif>
			<cfif isdefined("Form.RHAlote") and Len(Trim(Form.RHAlote)) NEQ 0>
				and a.RHAlote = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.RHAlote#">
			</cfif>
			<cfif isdefined("Form.RHAfdesde") and Len(Trim(Form.RHAfdesde)) NEQ 0>
				and a.RHAfdesde = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHAfdesde)#">
			</cfif>
			<cfif isdefined("Form.RHAfecha") and Len(Trim(Form.RHAfecha)) NEQ 0>
				and a.RHAfecha between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(Form.RHAfecha)#"> and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s', -1, DateAdd('d', 1, LSParseDateTime(Form.RHAfecha)))#">
			</cfif>

			and a.RHAestado = 0
			order by a.RHAfdesde, a.RHAfecha
		</cfquery>

		<cfinvoke 
		 component="rh.Componentes.pListas"
		 method="pListaQuery"
		 returnvariable="pListaRet">
			<cfinvokeargument name="query" value="#rsListaAumentos#"/>
			<cfinvokeargument name="desplegar" value="lote, fvigencia, fregistro"/>
			<cfinvokeargument name="etiquetas" value="#LB_Lote#, #LB_Fecha_de_Vigencia#,#LB_Fecha_de_Registro#"/>
			<cfinvokeargument name="formatos" value="V,D,D"/>
			<cfinvokeargument name="align" value="left, center, center"/>
			<cfinvokeargument name="ajustar" value="N"/>
			<cfinvokeargument name="checkboxes" value="S"/>
			<cfinvokeargument name="botones" value="Aplicar,Importar,Nuevo"/>
			<cfinvokeargument name="irA" value="/cfmx/rh/nomina/operacion/RelacionAumento-listaSql.cfm"/>
			<cfinvokeargument name="keys" value="RHAid"/>
			<cfinvokeargument name="MaxRows" value="0"/>
			<cfinvokeargument name="formName" value="listaAumentos"/>
			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="showEmptyListMsg" value="yes"/>
			<cfinvokeargument name="EmptyListMsg" value="#LB_EmptyListMsg#"/>
		</cfinvoke>
	</td>
  </tr>
</table>
