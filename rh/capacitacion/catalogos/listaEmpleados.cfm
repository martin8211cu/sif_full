
<cfset t = createObject("component", "sif.Componentes.Translate")>
<cfset LB_RecursosHumanos = t.translate('LB_RecursosHumanos','Recursos Humanos','/rh/generales.xml')>
<cfset LB_Identificacion = t.translate('LB_Identificacion','Identificaci&oacute;n','/rh/generales.xml')>
<cfset LB_Nombre = t.translate('LB_Nombre','Nombre','/rh/generales.xml')>
<cfset LB_Nombre_Completo = t.translate('LB_Nombre_Completo','Nombre Completo','/rh/generales.xml')>
<cfset LB_Filtrar = t.translate('LB_Filtrar','Filtrar','/rh/generales.xml')>

<cf_templateheader title="#LB_RecursosHumanos#">

		<cf_templatecss>
		<cf_web_portlet_start border="true" titulo="Convalidar Cursos" skin="#Session.Preferences.Skin#">
		<cfinclude template="/rh/portlets/pNavegacion.cfm">
		
		<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
		
		<cfif isdefined("Url.FDEidentificacion") and not isdefined("Form.FDEidentificacion")>
			<cfparam name="Form.FDEidentificacion" default="#Url.FDEidentificacion#">
		</cfif>
		<cfif isdefined("Url.FDEnombre") and not isdefined("Form.FDEnombre")>
			<cfparam name="Form.FDEnombre" default="#Url.FDEnombre#">
		</cfif>
		
		<cfset filtro = "">
		<cfset navegacion = "">
		<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
			<cfset filtro = filtro & " and upper(a.DEidentificacion) like '%" & #UCase(Form.FDEidentificacion)# & "%'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEidentificacion=" & Form.FDEidentificacion>
		</cfif>
		<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
			<cfset filtro = filtro & " and upper({fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre )}) like '%" & #UCase(Form.FDEnombre)# & "%'">
			<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FDEnombre=" & Form.FDEnombre>
		</cfif>
		
		<script language="javascript" type="text/javascript">
			function selEmpl(emp) {
				//document.listaEmpleados.PageNum.value = '1';
				document.listaEmpleados.DEID.value = emp;
				document.listaEmpleados.submit();
			}
		</script>
		
		<cfoutput>
			<form name="filtroEmpleado" method="post" action="#CurrentPage#" style="margin:0; ">
				<table width="99%" border="0" cellpadding="2" cellspacing="0" class="areaFiltro" align="center">
				  <tr> 
					<td width="9%" align="right"><div align="left">#LB_Identificacion#</div></td>
					<td width="16%"> 
					  <div align="left">
						<input name="FDEidentificacion" type="text" id="FDEidentificacion" size="20" maxlength="60" value="<cfif isdefined("Form.FDEidentificacion")>#Form.FDEidentificacion#</cfif>">
					  </div></td>
					<td width="7%" align="right"><div align="left">#LB_Nombre#</div></td>
					<td width="48%"> 
					  <div align="left">
						<input name="FDEnombre" type="text" id="FDEnombre" size="40" maxlength="80" value="<cfif isdefined("Form.FDEnombre")>#Form.FDEnombre#</cfif>">
					  </div></td>
					<td width="20%" align="center">
					  <input name="btnBuscar" type="submit" id="btnBuscar" value="#LB_Filtrar#">
					</td>
				  </tr>
				</table>
			</form>
		</cfoutput>
			
		<table width="99%" cellpadding="0" cellspacing="0" align="center">
			<tr>
				<td>
					<cfquery name="lista" datasource="#session.DSN#">
						select a.DEid, a.DEidentificacion, {fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre )} as NombreCompleto
						from DatosEmpleado a 
						
						inner join LineaTiempo lt
						on a.Ecodigo=lt.Ecodigo
						and a.DEid=lt.DEid
						and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#"> between lt.LTdesde and lt.LThasta
						
						where a.Ecodigo = lt.Ecodigo 
						  and a.DEid=lt.DEid 
						  and a.Ecodigo = #Session.Ecodigo# 

						<cfif isdefined("Form.FDEidentificacion") and Len(Trim(Form.FDEidentificacion)) NEQ 0>
							and upper(a.DEidentificacion) like '%#UCase(Form.FDEidentificacion)#%'
						</cfif>
						<cfif isdefined("Form.FDEnombre") and Len(Trim(Form.FDEnombre)) NEQ 0>
							and upper({fn concat({fn concat({fn concat({fn concat(a.DEapellido1 , ' ' )}, a.DEapellido2 )}, ' ' )}, a.DEnombre )}) like '%#UCase(Form.FDEnombre)#%'
						</cfif>

						  order by a.DEidentificacion, a.DEapellido1, a.DEapellido2, a.DEnombre
					</cfquery>

					<cfinvoke 
					 component="rh.Componentes.pListas"
					 method="pListaQuery"
					 returnvariable="pListaEduRet">
						<cfinvokeargument name="query" value="#lista#"/>
						<cfinvokeargument name="desplegar" value="DEidentificacion, NombreCompleto"/>
						<cfinvokeargument name="etiquetas" value="#LB_Identificacion#,#LB_Nombre_Completo#"/>
						<cfinvokeargument name="formatos" value=""/>
						<cfinvokeargument name="align" value="left, left"/>
						<cfinvokeargument name="ajustar" value=""/>
						<cfinvokeargument name="irA" value="convalidar.cfm"/>
						<cfinvokeargument name="funcion" value="selEmpl"/>
						<cfinvokeargument name="fparams" value="DEid"/>
						<cfinvokeargument name="formName" value="listaEmpleados"/>
						<cfinvokeargument name="MaxRows" value="15"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
					</cfinvoke>
				</td>
			</tr>
		</table>
	<cf_web_portlet_end>
<cf_templatefooter>