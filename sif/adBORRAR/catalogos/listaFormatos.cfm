<cfparam name="form.fFMT01COD" default="">
<cfparam name="form.fFMT01DES" default="">
<cfparam name="form.fFMT01TIP" default="">
<cfset regresar = "/cfmx/sif/ad/MenuAD.cfm">

<cfinvoke component="sif.Componentes.Translate"
method="Translate"
Key="LB_SIFAdministracionDelSistema"
Default="SIF - Administraci&oacute;n del Sistema"
XmlFile="/sif/generales.xml"
returnvariable="LB_SIFAdministracionDelSistema"/>

<cfquery datasource="#session.dsn#" name="lista_query">
	select FMT01COD, FMT01DES, FMT01TIP, FMT01FEC, coalesce(b.FMT00DES, 'Otros') as FMT00DES,
		case when Ecodigo is null then 'X' else '' end as esglobal
	from FMT001 a
		left join FMT000 b 
			on a.FMT01TIP = b.FMT00COD
	where (a.Ecodigo is null or a.Ecodigo=#session.Ecodigo# )
	
	<cfif len(trim(form.fFMT01COD)) gt 0  >
		 and upper(FMT01COD) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.fFMT01COD)#%">
	</cfif>
	
	<cfif len(trim(form.fFMT01DES)) gt 0 >
		 and upper(rtrim(FMT01DES)) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.fFMT01DES)#%">
	</cfif>
	
	<cfif len(trim(form.fFMT01TIP)) and form.fFMT01TIP NEQ "-1" >
		 and FMT01TIP = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fFMT01TIP#">
	</cfif>
	
	order by FMT00DES, FMT01COD
</cfquery>

<cfquery name="rsTipos" datasource="sifcontrol">
	select FMT00COD, FMT00DES from FMT000 order by FMT00DES
</cfquery>

<cf_templateheader title="#LB_SIFAdministracionDelSistema#">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Encabezado de Formatos de Impresi&oacute;n'>	
		<cfinclude template="../../portlets/pNavegacionAD.cfm">	
			<table width="100%"  border="0" >
				<tr> 
					<td valign="top" colspan="2">
						<form name="filtro" action="" method="post" >
							<table width="100%" class="areaFiltro">
								<tr>
									<td width="2%"></td>
									<td width="1%">C&oacute;digo:&nbsp;</td>
									<td width="22%"><input name="fFMT01COD" type="text" size="10" maxlength="10" value=""></td>
									<td>Descripci&oacute;n</td>
									<td><input name="fFMT01DES" type="text" size="50" maxlength="50" value=""></td>
									<td>Sistema</td>
									<td>
										<select name="fFMT01TIP">
											<option value="-1">--- Todos ---</option>
											<cfoutput query="rsTipos">
												<option value="#rsTipos.FMT00COD#" <cfif isdefined("form.fFMT01TIP") and form.fFMT01TIP eq rsTipos.FMT00COD>selected</cfif> >#rsTipos.FMT00DES#</option>
											</cfoutput>
										</select>
									</td>
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
							<cfinvokeargument name="desplegar" 	value="FMT01COD, FMT01DES, esglobal"/>
							<cfinvokeargument name="etiquetas" 	value="C&oacute;digo, Descripci&oacute;n, Común"/>
							<cfinvokeargument name="formatos" 	value="V, V, V"/>
							<cfinvokeargument name="align" 		value="left, left, left"/>
							<cfinvokeargument name="ajustar" 	value="S"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<cfinvokeargument name="Nuevo" 		value="EFormatosImpresion.cfm"/>
							<cfinvokeargument name="irA" 		value="EFormatosImpresion.cfm"/>
							<cfinvokeargument name="Cortes" 	value="FMT00DES"/>
						</cfinvoke>
					</td>
				  </tr>
				  <tr>
					  <td colspan="2" align="center">
						<form action="" method="get" name="form_exportar" id="form_exportar" >
							<input type="button" name="Nuevo"				  class="btnNuevo" 	onClick="javascript:nuevo();"       value="Nuevo" >
							<input type="button" name="btnExportar_Sybase" 	  class="btnNormal"	onClick="funcExportar_Sybase()" 	value="Exportar Todos a Sybase">
							<input type="button" name="btnExportar_Oracle" 	  class="btnNormal" onClick="funcExportar_Oracle()" 	value="Exportar Todos a Oracle">
							<input type="button" name="btnExportar_SQLServer" class="btnNormal" onClick="funcExportar_SQLServer()"	value="Exportar Todos a SQL Server">
							<input type="button" name="btnExportar_DB2" 	  class="btnNormal" onClick="funcExportar_DB2()"	    value="Exportar Todos a DB2">
							<input type="button" name="btnCompilar_Todos" 	  class="btnNormal" onClick="funcCompilar_Todos()" 		value="Compilar Estos los reportes">
						</form>
					</td>
			</tr>
		</table>
	<cf_web_portlet_end>	
<cf_templatefooter>

<script language="JavaScript1.2" type="text/javascript">
	function nuevo(){
		document.lista.action       = "EFormatosImpresion.cfm";
		//document.lista.CAMBIO.value = "";
		document.lista.submit();
	}
	
	function limpiar(){
		document.filtro.fFMT01COD.value = "";
		document.filtro.fFMT01DES.value = "";
		document.filtro.fFMT01TIP.value = -1;
	}
	
	function funcExportar_Sybase() {
		location.href='formatos/exportar.cfm?dbms=syb';
		return false;
	}
	function funcExportar_Oracle() {
		location.href='formatos/exportar.cfm?dbms=ora';
		return false;
	}
	function funcExportar_SQLServer() {
		location.href='formatos/exportar.cfm?dbms=mss';
		return false;
	}
	function funcExportar_DB2() {
		location.href='formatos/exportar.cfm?dbms=db2';
		return false;
	}
	
	<cfoutput>
	function funcCompilar_Todos() {
		location.href='compilar.cfm?fFMT01COD=#URLEncodedFormat(form.fFMT01COD)
			#&fFMT01DES=#URLEncodedFormat(form.fFMT01DES)
			#&fFMT01TIP=#URLEncodedFormat(form.fFMT01TIP)#';
		return false;
	}
	</cfoutput>
</script>
