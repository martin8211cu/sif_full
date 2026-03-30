
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_RecursosHumanos = t.translate('LB_RecursosHumanos','Recursos Humanos','/rh/generales.xml')>
<cfset LB_ConvalidacionCursos = t.translate('LB_ConvalidacionCursos','Convalidación de Cursos')>
<cfset LB_Siglas = t.translate('LB_Siglas','Siglas')>
<cfset LB_Descripcion = t.translate('LB_Descripcion','Descripción','/rh/generales.xml')>
<cfset LB_Fecha_Inicio = t.translate('LB_Fecha_Inicio','Fecha Inicio','/rh/generales.xml')>
<cfset LB_Fecha_Final = t.translate('LB_Fecha_Final','Fecha Final','/rh/generales.xml')>
<cfset LB_Curso = t.translate('LB_Curso','Curso')>
<cfset LB_NotaMinima = t.translate('LB_NotaMinima','Nota Mínima')>
<cfset LB_Horas = t.translate('LB_Horas','Horas')>
<cfset LB_NotaObtenida = t.translate('LB_NotaObtenida','Nota obtenida')>
<cfset MSG_CampoCursoRequerido = t.translate('MSG_CampoCursoRequerido','El campo Curso es requerido')>
<cfset MSG_CampoNotaMinimaRequerido = t.translate('MSG_CampoNotaMinimaRequerido','El campo Nota Mínima es requerido')>
<cfset MSG_SePresentaronLosSiguientesErrores = t.translate('MSG_SePresentaronLosSiguientesErrores','Se presentaron los siguientes errores','/rh/generales.xml')>


<cf_templateheader title="#LB_RecursosHumanos#">
<cf_templatecss>

<table width="99%" align="center" cellpadding="2" cellspacing="0"><tr><td width="99%" align="center">
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Convalidar Cursos">
		<cfoutput>
			<table width="99%" border="0" cellspacing="0" align="center">
				<tr><td colspan="2"><cfinclude template="/rh/portlets/pNavegacion.cfm"></td></tr>
				<tr>
					<td colspan="2"><cfinclude template="../expediente/info-empleado.cfm"></td>
				</tr>	
				<tr>
					<td colspan="2" bgcolor="##CCCCCC" align="center">
						<strong><font size="2">#LB_ConvalidacionCursos#</font></strong>
					</td>
				</tr>
				<tr>
					<td valign="top" width="60%">
						<cfif isdefined("url.DEid") and not isdefined("form.DEid")>
							<cfset form.DEid = url.DEid >
						</cfif>
				
						<cfquery datasource="#session.dsn#" name="lista">
							select a.RHECid, a.DEid, a.RHCid, b.Msiglas, b.Mnombre, 10 as tab, a.RHECfdesde as inicio, a.RHECfhasta as fin, a.RHEMhoras as horas
							from RHEmpleadoCurso a
								inner join RHMateria b
									on a.Ecodigo = b.Ecodigo
									and a.Mcodigo = b.Mcodigo
							where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DEid#">
								and a.RHEMestado = 15
								order by Mnombre
						</cfquery>
						
						<cfset navegacion = "&DEid=#form.DEid#&tab=9" >
						<cfinvoke component="rh.Componentes.pListas" method="pListaQuery"
							query="#lista#"
							desplegar="Msiglas,Mnombre, inicio, fin, horas"
							etiquetas="#LB_Siglas#,#LB_Descripcion#,#LB_Fecha_Inicio#,#LB_Fecha_Final#,#LB_Horas#"
							formatos="S,S,D,D,S"
							align="left,left,left,left,left"
							ira="convalidar.cfm"
							form_method="get"
							keys="RHECid"
							showEmptyListMsg="true"
							navegacion="#navegacion#"/>		
					</td>
					<td valign="top" with="40%">
						<cfinclude template="convalidar-form.cfm">
					</td>
				</tr>
			</table>
		</cfoutput>	
	<cf_web_portlet_end>
</table>
<cf_templatefooter>
