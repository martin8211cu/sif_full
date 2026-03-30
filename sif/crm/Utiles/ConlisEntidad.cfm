<!--- Recibe form, conexion, atrRHPcodigo, atrRHPdescripcion, atrRHPid, RHPpuesto, Dcodigo, Ocodigo --->

<cfquery name="rsTipoEnt" datasource="#url.conexion#">
	select 	convert(varchar,CRMTEid) as CRMTEid,
			CRMTEdesc
	from CRMTipoEntidad
	where 	Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and CEcodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
	order by CRMTEdesc
</cfquery>

<!--- <cfdump var="#Url#"> --->

<script language="JavaScript" type="text/javascript" language="JavaScript">
	function Asignar(codigoEntidad, NombreEntidad) {
		if (window.opener != null) {
			<cfoutput>
				window.opener.document.#Url.form#.#Url.CRMEid#.value = codigoEntidad;
				window.opener.document.#Url.form#.#Url.CRMnombre#.value = NombreEntidad;
			</cfoutput>
			
			window.close();
		}
	}
</script>

<cfif (isdefined("Url.CRMEnombre_filtro")) and (not isDefined("Form.CRMEnombre_filtro")) and Url.CRMEnombre_filtro NEQ ''>
	<cfparam name="Form.CRMEnombre_filtro" default="#Url.CRMEnombre_filtro#">
</cfif>
<cfif (isdefined("Url.CRMTEid_filtro")) and (not isDefined("Form.CRMTEid_filtro")) and Url.CRMTEid_filtro NEQ '-1' and Url.CRMTEid_filtro NEQ ''>
	<cfparam name="Form.CRMTEid_filtro" default="#Url.CRMTEid_filtro#">
</cfif>

<cfset filtro = "">
<cfset navegacion = "">
<cfif isdefined("Form.CRMEnombre_filtro") and Len(Trim(Form.CRMEnombre_filtro)) NEQ 0>
	<cfset filtro = filtro & " and upper(CRMEnombre + ' ' + CRMEapellido1 + ' ' + CRMEapellido2) like '%" & #UCase(Form.CRMEnombre_filtro)# & "%'">
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CRMEnombre_filtro=" & Form.CRMEnombre_filtro>
</cfif>

<cfif isdefined("Form.CRMTEid_filtro") and Len(Trim(Form.CRMTEid_filtro)) NEQ 0 and Form.CRMTEid_filtro NEQ '-1'>
 	<cfset filtro = filtro & " and e.CRMTEid=" & #Form.CRMTEid_filtro#>
	<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "CRMTEid_filtro=" & Form.CRMTEid_filtro>
</cfif>
<!--- Para filtrar solo las entidades que reciben donaciones --->
<cfif isdefined("Url.CRMTEdonacion") and Len(Trim(Url.CRMTEdonacion)) NEQ 0 and Url.CRMTEdonacion NEQ 'N'>
 	<cfset filtro = filtro & " and CRMTEdonacion=1">
</cfif>


<html>
<head>
<title>Lista de Entidades</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>
	<body>
	<cfoutput>
	<form name="filtroEmpleado" method="post">
		<table width="98%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro">
			<tr>
				<td align="right"><strong>Descripci&oacute;n</strong></td>
				<td><input name="CRMEnombre_filtro" type="text" id="CRMEnombre_filtro" size="70" maxlength="220" value="<cfif isdefined("Form.CRMEnombre_filtro")>#Form.CRMEnombre_filtro#</cfif>">
				</td>
				<td align="right" nowrap><strong>Tipo de Entidad</strong></td>
				<td>				  
					<select name="CRMTEid_filtro" id="CRMTEid_filtro">
						<option value="-1">-- Todos --</option>
						<cfloop query="rsTipoEnt">
			  	  			<option value="#rsTipoEnt.CRMTEid#" <cfif isdefined('form.CRMTEid_filtro') and form.CRMTEid_filtro EQ rsTipoEnt.CRMTEid> selected</cfif>>#rsTipoEnt.CRMTEdesc#</option>
						</cfloop>						
				  	</select>
				</td>
				<td align="center">
					<input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar">
				</td>
			</tr>
		</table>
	</form>
	</cfoutput>

	<cfinvoke 
		 component="sif.crm.Componentes.pListas"
		 method="pListaCRM"
		 returnvariable="pListaEntidades">
			<cfinvokeargument name="tabla" value="	
				CRMEntidad e,
				CRMTipoEntidad te"/>
			<cfinvokeargument name="columnas" value="
				convert(varchar,CRMEid) as CRMEid,
				(CRMEnombre + ' ' + CRMEapellido1 + ' ' + CRMEapellido2) as Nombre_Completo,
				CRMTEdesc"/>
			<cfinvokeargument name="desplegar" value="Nombre_Completo, CRMTEdesc"/>
			<cfinvokeargument name="etiquetas" value="Entidad, Tipo"/>
			<cfinvokeargument name="formatos" value=""/>
			<cfinvokeargument name="filtro" value="
					e.CEcodigo =#Session.CEcodigo#
				and e.Ecodigo = #Session.Ecodigo#  
				and getdate() between CRMEfechaini and CRMEfechafin
				and e.CEcodigo=te.CEcodigo
				and e.Ecodigo=te.Ecodigo
				and e.CRMTEid=te.CRMTEid #filtro#
				order by CRMEapellido1, CRMEapellido2, CRMEnombre
				"/>
			<cfinvokeargument name="align" value="left, left"/>
			<cfinvokeargument name="ajustar" value=""/>
			<cfinvokeargument name="irA" value="ConlisEntidad.cfm"/>
			<cfinvokeargument name="formName" value="listaEntidad"/>
			<cfinvokeargument name="MaxRows" value="15"/>
			<cfinvokeargument name="funcion" value="Asignar"/>
			<cfinvokeargument name="fparams" value="CRMEid, Nombre_Completo"/>
 			<cfinvokeargument name="navegacion" value="#navegacion#"/>
			<cfinvokeargument name="Conexion" value="#url.conexion#"/>
			<cfinvokeargument name="debug" value="N"/>
			<cfinvokeargument name="MaxRows" value="25"/>
	</cfinvoke>
	</body>
</html>