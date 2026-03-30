<!--- 
	****************************** 
	REVERSIÓN DE MARCAS DE   RELOJ 
	FECHA DE CREACIÓN   12/08/2007 
	CREADO POR DORIAN ABARCa GÓMEZ 
	(Este proceso permite reversar 
	un grupo de marcas aplicado, a 
	un grupo de marcas sin aplicar 
	con el objetivo de revisar   o 
	corregir un error   encontrado 
	en la Nómina. El mismo realiza 
	los siguientes 	  subprocesos:
	1. Elimina las     incidencias 
	generadas.
	2. Actualiza el estado     del 
	grupo de marcas aplicado (Esto 
	puede implicar borrar datos de 
	históricos, insertar en  tabla 
	de   marcas,   etc.  para  más 
	detalles, revisar  la  sección 
	correspondiente).
	****************************** 
--->
		<cfinclude template="reversionMarcas-translate.cfm">

<cfset rsFeriado = QueryNew("value,description","integer,varchar")>
<cfset QueryAddRow(rsFeriado,3)>
<cfset QuerySetCell(rsFeriado,"value","-1",1)>
<cfset QuerySetCell(rsFeriado,"description",#LB_Todos#,1)>
<cfset QuerySetCell(rsFeriado,"value","0",2)>
<cfset QuerySetCell(rsFeriado,"description",#LB_NoFeriado#,2)>
<cfset QuerySetCell(rsFeriado,"value","1",3)>
<cfset QuerySetCell(rsFeriado,"description",#LB_Feriado#,3)>

<cfset rsPermiso = QueryNew("value,description","integer,varchar")>
<cfset QueryAddRow(rsPermiso,3)>
<cfset QuerySetCell(rsPermiso,"value","-1",1)>
<cfset QuerySetCell(rsPermiso,"description",#LB_Todos#,1)>
<cfset QuerySetCell(rsPermiso,"value","0",2)>
<cfset QuerySetCell(rsPermiso,"description",#LB_NoPermiso#,2)>
<cfset QuerySetCell(rsPermiso,"value","1",3)>
<cfset QuerySetCell(rsPermiso,"description",#LB_Permiso#,3)>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
	<cfinclude template="/rh/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader template="#session.sitio.template#" title="#nav__SPdescripcion#">
	<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">
		<cfoutput>#pNavegacion#</cfoutput>
		<br>
		<form name="form1" action="reversionMarcas-sql.cfm" method="post">
			<!--- <cfinclude template="reversionMarcas-form.cfm"> --->
			<!--- <cfinclude template="reversionMarcas-consulta.cfm"> --->
			<table align="center" width="98%" cellpadding="0" cellspacing="0" border="0" id="tblFiltro" class="AreaFiltro"><tr><td>
			<cf_botones values="Reversar,Reversar_Masivo">
			<cfset checked = "<img src=''/cfmx/rh/imagenes/checked.gif'' border=''0''>">
			<cfset unchecked = "<img src=''/cfmx/rh/imagenes/unchecked.gif'' border=''0''>">				
			<cfif not isdefined('form.Filtro_Fecha')><cfset Lvar_Filtro = "and CAMfdesde >= #Now()#"><cfelse><cfset Lvar_Filtro = ""></cfif>
			<cfinvoke 
				 component="rh.Componentes.pListas"
				 method="pListaRH"
				 returnvariable="pListaRet">
					<cfinvokeargument name="tabla" value="RHCMCalculoAcumMarcas a
															inner join DatosEmpleado b
															on b.DEid = a.DEid"/>
					<cfinvokeargument name="columnas" value="distinct a.DEid, 
															a.CAMid, 
															b.DEidentificacion as Identificacion,
															{fn concat(b.DEapellido1, {fn concat(' ', {fn concat(b.DEapellido2, {fn concat(' ', b.DEnombre)})})})} as NombreCompleto,
															a.CAMfdesde as Fecha,
															a.CAMgeneradoporferiado as Feriado,
															case a.CAMgeneradoporferiado when 0 then '#unchecked#' else '#checked#' end as imgFeriado,
															a.CAMpermiso as Permiso,
															case a.CAMpermiso when 0 then '#unchecked#' else '#checked#' end as imgPermiso
															"/>
					<cfinvokeargument name="desplegar" value="Identificacion, NombreCompleto, Fecha, imgFeriado, imgPermiso"/>
					<cfinvokeargument name="etiquetas" value="#LB_Identificacion#, #LB_Empleado#,#LB_Fecha#,#LB_Feriado#,#LB_Permiso#"/>
					<cfinvokeargument name="formatos" value="S,S,D,U,U"/>
					<cfinvokeargument name="filtro" value="a.Ecodigo = #session.Ecodigo#
															and a.CAMestado = 'A'
															and not exists (
																select 1 from RCalculoNomina x, IncidenciasCalculo y
																where x.Ecodigo = a.Ecodigo
																and x.RCestado <> 0
																and y.RCNid = x.RCNid
																and (y.Iid = a.CAMhniid
																or y.Iid = a.CAMhriid
																or y.Iid = a.CAMheaiid
																or y.Iid = a.CAMhebiid
																or y.Iid = a.CAMferiid)
															)
															and exists (
																select 1 
																from Incidencias v
																where (v.Iid = a.CAMhniid
																or v.Iid = a.CAMhriid
																or v.Iid = a.CAMheaiid
																or v.Iid = a.CAMhebiid
																or v.Iid = a.CAMferiid)
															)
															#Lvar_Filtro# 
															order by DEidentificacion,CAMfdesde
															"/>
					<cfinvokeargument name="align" value="left,left,center,center,center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="formName" value="form1"/>
					<cfinvokeargument name="checkboxes" value="S"/>
					<cfinvokeargument name="irA" value="reversionMarcas.cfm"/>
					<cfinvokeargument name="keys" value="CAMid"/>
					<cfinvokeargument name="maxRows" value="15"/>
					<cfinvokeargument name="MaxRowsQuery" value="200"/>
					<cfinvokeargument name="showEmptyListMsg" value="true"/>
					<cfinvokeargument name="mostrar_filtro" value="true"/>
					<cfinvokeargument name="filtrar_automatico" value="true"/>
					<cfinvokeargument name="filtrar_por" value="b.DEidentificacion| 
																{fn concat(b.DEapellido1, {fn concat(' ', {fn concat(b.DEapellido2, {fn concat(' ', b.DEnombre)})})})}|
																a.CAMfdesde|
																a.CAMgeneradoporferiado|
																a.CAMpermiso
																"/>			
					<cfinvokeargument name="filtrar_por_delimiters" value="|"/>	
					<cfinvokeargument name="showLink" value="false"/>
					<cfinvokeargument name="rsimgPermiso" value="#rsPermiso#"/>
					<cfinvokeargument name="rsimgFeriado" value="#rsFeriado#"/>
				</cfinvoke>

			<!--- <cf_botones  values="Reversar,Reversar_Masivo"> --->
			</td></tr></table>
		</form>
		<cfoutput><script  language="javascript">
			function funcReversar(){
				if (!fnAlgunoMarcadoform1()){
					alert("Error, #MSG_Debe_Marcar_Un_Item#!");
					return false;
				}
				if (!confirm("#MSG_Confirmar_Eliminar_Un_Item#?")){
					return false;
				}
				return true;
			}
			function funcReversar_Masivo(){
				if (!confirm("#MSG_Confirmar_Eliminar_Items_Rango#?")){
					return false;
				}
				return true;
			}
			function fnMarcarTodosform1(){
				if (document.form1.chk) {
					if (document.form1.chk.value) {
						document.form1.chk.checked = (!document.form1.chk.checked);
					} else {
						for (var i=0; i<document.form1.chk.length; i++) {
							document.form1.chk[i].checked=(!document.form1.chk[i].checked);
						}
					}
				}
			}
			
			function funcFiltrar(){
				var f = document.form1;
				if(f.filtro_Identificacion.value == '' && f.filtro_NombreCompleto.value == ''  && f.filtro_imgFeriado.options[f.filtro_imgFeriado.selectedIndex].value == -1 &&  f.filtro_imgPermiso.options[f.filtro_imgPermiso.selectedIndex].value == -1){
					alert('#MSG_Debe_Marcar_Un_Item#');
					return false;
				}
				return true;
			}
		</script></cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>
