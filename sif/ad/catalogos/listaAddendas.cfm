<cfparam name="form.ADDcodigo" default="">
<cfparam name="form.ADDNom" default="">
<cfparam name="form.ADDdesc" default="">
<cfset session.ADDID="">
<cfset regresar = "/cfmx/sif/ad/MenuAD.cfm">

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>

<cfquery datasource="#session.dsn#" name="lista_query">
	select ADDid, ADDcodigo, ADDNombre, ADDdesc
	from Addendas a
	where (a.Ecodigo is null or a.Ecodigo=#session.Ecodigo# )

	<cfif len(trim(form.ADDNom)) gt 0  >
		 and upper(ADDNombre) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.ADDNom)#%">
	</cfif>

	<cfif len(trim(form.ADDcodigo)) gt 0  >
		 and upper(ADDcodigo) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.ADDcodigo)#%">
	</cfif>

	<cfif len(trim(form.ADDdesc)) gt 0 >
		 and upper(rtrim(ADDdesc)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.ADDdesc)#%">
	</cfif>
	order by ADDid, ADDDESC
</cfquery>

<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Encabezado de Addendas'>
		<cfinclude template="../../portlets/pNavegacionAD.cfm">
			<table width="100%"  border="0" >
				<tr>
					<td valign="top" colspan="2">
						<form name="filtro" action="" method="post" >
							<table width="100%" class="areaFiltro">
								<tr>
									<td width="2%"></td>
									<td width="1%">C&oacute;digo:&nbsp;</td>
									<td width="22%"><input name="ADDcodigo" type="text" size="7" maxlength="5" value=""></td>
									<td>Nombre</td>
									<td><input name="ADDNom" type="text" size="25" maxlength="15" value=""></td>
									<td>Descripci&oacute;n</td>
									<td><input name="ADDdesc" type="text" size="45" maxlength="50" value=""></td>
									<td><input type="submit" name="btnFiltrar" value="Filtrar" class="btnFiltrar"></td>
									<td><input type="button" name="btnlimpiar" value="Limpiar" onClick="javascript:limpiar();" class="btnlimpiar"></td>
								</tr>
						 	</table>
						</form>
					</td>
				  </tr>

				  <tr>
				  	<td colspan="2">
						<cfinvoke component="sif.Componentes.pListas" method="pListaQuery" returnvariable="pListaRet" query="#lista_query#">
							<cfinvokeargument name="desplegar" 	value="ADDid,ADDcodigo, ADDNombre, ADDdesc"/>
							<cfinvokeargument name="etiquetas" 	value="id,C&oacute;digo, Nombre, Descripci&oacute;n"/>
							<cfinvokeargument name="formatos" 	value="V,V, V, V"/>
							<cfinvokeargument name="align" 		value="left, left, left, left"/>
							<cfinvokeargument name="ajustar" 	value="S"/>
							<cfinvokeargument name="irA" 		value="AgregarAddendasDetalle.cfm"/>
						</cfinvoke>
					</td>
				  </tr>
				  <tr>
					  <td colspan="2" align="center">
						<form action="" method="get" name="form_exportar" id="form_exportar" >
							<input type="button" name="Nuevo"  class="btnNuevo" onClick="javascript:nuevo();" value="Nuevo" >
						</form>
					</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript1.2" type="text/javascript">
	function nuevo(){
		location.href = 'AgregarAddendas.cfm';
	}

	function limpiar(){
		document.filtro.ADDcodigo.value = "";
		document.filtro.ADDNom.value = "";
		document.filtro.ADDdesc.value = "";
	}

	function Refrescar(){
		document.form_exportar.submit();
	}

</script>
