<cfparam name="url.formname">
<cfparam name="url.objid"   >
<cfparam name="url.objiden" >
<cfparam name="url.objnom"  >
<cfparam name="url.objtxt"  >
<cfparam name="url.id_tipo" >
<cfset url.id_tipo = ListFirst(url.id_tipo)>
<cfparam name="url.id_tipo" type="numeric">
<cfparam name="url.filtro_nombre" default="">
<cfparam name="url.filtro_apellido1" default="">
<cfparam name="url.filtro_apellido2" default="">
<cfparam name="url.fechaI" default="">
<cfparam name="url.fechaF" default="">
<cfparam name="url.filtro_identificacion_persona" default="">
<!--- VERIFICA QUE LAS FECHA INICIAL SEA MENOR QUE LA FECHA FINAL, Y SI NO LAS INVIERTE--->
<cfif isdefined("url.FechaI") and len(trim(url.FechaI)) and isdefined("url.FechaF") and len(trim(url.FechAF))>
  <cfset url.FechaI = url.FechaI >
  <cfset url.FechaF = url.FechaF >
  <cfif LSParseDateTime(FechaI) gt LSParseDateTime(FechaF)>
    <cfset tmp = url.FechaI >
    <cfset url.FechaI = url.FechaF >
    <cfset url.FechaF = tmp >
  </cfif>
</cfif>
<cfquery name="rsDDTipo" datasource="#session.tramites.dsn#">
	select b.nombre_tipo, b.es_persona 
	from DDTipo b
	where b.id_tipo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.id_tipo#">
</cfquery>
<cfinvoke component="home.tramites.componentes.vistas"
	method="getCamposLista" returnvariable="rsNombresCampos"
	id_tipo="#url.id_tipo#"
></cfinvoke>
<cfset navegacion = "">
<cfset formato_campos="">
<cfset align_campos="">
<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfloop query="rsNombresCampos">
  <cfparam name="url.filtro_#nombre_objeto#" default="">
  <cfset formato_campos = ListAppend(formato_campos,rsNombresCampos.formato)>
  <cfset align_campos = ListAppend(align_campos,rsNombresCampos.align)>
</cfloop>
<cfinvoke component="home.tramites.componentes.vistas"
	method="getLista" returnvariable="listaCatalogos"
	id_tipo="#url.id_tipo#" >
  <cfif Len(Trim(url.FechaI))>
    <cfinvokeargument name="f_desde" value="#LSParseDateTime(url.FechaI)#">
  </cfif>
  <cfif Len(Trim(url.FechaF))>
    <cfinvokeargument name="f_hasta" value="#LSParseDateTime(url.FechaF)#">
  </cfif>
  <cfif Len(Trim(url.filtro_identificacion_persona))>
    <cfinvokeargument name="identificacion_persona" value="#url.filtro_identificacion_persona#">
  </cfif>
  <cfif Len(Trim(url.filtro_nombre))>
    <cfinvokeargument name="nombre" value="#url.filtro_nombre#">
  </cfif>
  <cfif Len(Trim(url.filtro_apellido1))>
    <cfinvokeargument name="apellido1" value="#url.filtro_apellido1#">
  </cfif>
  <cfif Len(Trim(url.filtro_apellido2))>
    <cfinvokeargument name="apellido2" value="#url.filtro_apellido2#">
  </cfif>
  <cfloop query="rsNombresCampos">
    <cfset url_filtro = "filtro_" & nombre_objeto>
    <cfif StructKeyExists(url,url_filtro) and  Len(Trim(url[url_filtro]))>
      <cfinvokeargument name="C_#id_campo#" value="#url[url_filtro]#">
      <cfset navegacion = navegacion & "&amp;#url_filtro#=" & url[url_filtro]>
    </cfif>
  </cfloop>
  <cfinvokeargument name="debug" value="no">
</cfinvoke>
<html>
<head>
<title>Consulta por Documento</title>
<cf_templatecss>
</head>
<body style="margin:0">
<!--- Si ya se ha seleccionado una vista --->
<form name="form1" method="get" action="" style="margin: 0;">
  <cfoutput>
    <input type="hidden" name="id_tipo" value="#HTMLEditFormat(url.id_tipo)#">
  </cfoutput>
  <table width="100%"  border="0" cellspacing="0" cellpadding="2">
    <tr>
      <td bgcolor="#ECE9D8" style="padding:3px; border-bottom:1px solid black; border-top:1px solid black;"><strong> <cfoutput> Seleccionar #HTMLEditFormat(rsDDTipo.nombre_tipo)# </cfoutput> </strong></td>
    </tr>
    <tr>
      <td colspan="2"><table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
          <tr class="tituloListas">
            <td width="40%">&nbsp;</td>
          </tr>
        </table>
        <table width="100%" border="0" cellpadding="2" cellspacing="0" align="center">
          <!--- Titulo de la Lista --->
          <tr>
            <td class="tituloListas" valign="top" colspan="<cfoutput>#rsNombresCampos.RecordCount+5#</cfoutput>"><table    border="0" cellspacing="0" cellpadding="0">
                <tr>
                  <td><strong>Registrado Desde:</strong>&nbsp;</td>
                  <td><cfif IsDefined("url.FechaI") and Len(Trim(url.FechaI))>
                      <cfset fecha = LSDateFormat(url.FechaI,'dd/mm/yyyy')>
                      <cfelse>
                      <cfset fecha = ''>
                    </cfif>
                    <cf_sifcalendario name="FechaI" form="form1" value="#fecha#"> </td>
                  <td>&nbsp;&nbsp;<strong>Hasta:</strong>&nbsp;</td>
                  <td><cfif IsDefined("url.FechaF") and Len(Trim(url.FechaF))>
                      <cfset fecha = LSDateFormat(url.FechaF,'dd/mm/yyyy')>
                      <cfelse>
                      <cfset fecha = ''>
                    </cfif>
                    <cf_sifcalendario name="FechaF" form="form1" value="#fecha#"> </td>
                  <td>&nbsp;</td>
                  <td><input type="submit" name="btnFiltrar" value="Buscar"></td>
                  <td>&nbsp;</td>
                </tr>
              </table>
              <cfif rsDDTipo.es_persona>
                <cfset des_persona = "identificacion_persona,apellido1,apellido2,nombre,">
                <cfset eti_persona = "Identificacion,Apellido,Apellido,Nombre,">
                <cfset fmt_persona = "S,S,S,S,">
                <cfset ali_persona = "left,left,left,left,">
              <cfelse>
                <cfset des_persona = "">
                <cfset eti_persona = "">
                <cfset fmt_persona = "">
                <cfset ali_persona = "">
              </cfif>
              <cfinvoke 
				component="sif.Componentes.pListas"
				method="pListaQuery"
				query="#listaCatalogos#"
				desplegar="#des_persona##ValueList(rsNombresCampos.nombre_objeto)#"
				etiquetas="#eti_persona##ValueList(rsNombresCampos.nombre_campo)#"
				formatos="#fmt_persona##formato_campos#"
				align="#ali_persona##align_campos#"
				mostrar_filtro="true"
				irA="#CurrentPage#"
				navegacion="#navegacion#"
				maxrows="50"
				incluyeForm="false"
				formname="form1"
				funcion="funcSeleccionar"
				fparams="id_registro,identificacion_persona,apellido1,apellido2,nombre,#ValueList(rsNombresCampos.nombre_objeto)#"
				/>
            </td>
          </tr>
        </table></td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
    <tr>
      <td colspan="2">&nbsp;</td>
    </tr>
  </table>
</form>
<cfoutput>
  <script language="javascript" type="text/javascript">
  	function format_when_date(s) {
		return s.replace(/\{ts '(.*)-(.*)-(.*) (.*):(.*):(.*)'\}/g,'$3/$2/$1');
	}
	function funcSeleccionar(id_registro, identificacion_persona,
		apellido1, apellido2, nombre, etcetera)
	{
		<!---
			el guión y el espacio luego de la cedula en "descr"
			son sumamente importantes, lo
			utiliza el cf_tipo_complejo para separar en dos cajas
			la cédula y el nombre de la persona
		--->
		var txt = '', descr = '';
		for (x = 5; x < arguments.length;x++){
			txt += ' ' + format_when_date(arguments[x]);
		}
		<cfif rsDDTipo.es_persona>
			descr = identificacion_persona + ' '
				+ apellido1 + ' ' + apellido2 + ' ' + nombre
				+ (arguments.length>5 ? descr+=' -' : '')
				+ txt;
		<cfelse>
			descr = txt;
		</cfif>
		var ctl_id   = window.opener.document.forms.#url.formname#.#url.objid#;
		var ctl_txt  = window.opener.document.forms.#url.formname#.#url.objtxt#;
		<cfif rsDDTipo.es_persona>
		var ctl_iden = window.opener.document.forms.#url.formname#.#url.objiden#;
		var ctl_nom  = window.opener.document.forms.#url.formname#.#url.objnom#;
		</cfif>
		ctl_id.value   = '{ ' + id_registro + ' , ' + descr + ' }';
		ctl_txt.value  = txt;
		<cfif rsDDTipo.es_persona>
		ctl_iden.value = identificacion_persona;
		ctl_nom.value  = apellido1 + ' ' + apellido2 + ' ' + nombre;
		</cfif>
		window.close();
	}
</script>
</cfoutput>
</body>
</html>
