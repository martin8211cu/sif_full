<!--- <cfdump  label="URL" var="#url#">
<cfdump  label="FORM" var="#form#">  --->

<script language="JavaScript">

// Marcar todos los documentos disponibles para aplicar
function Marcar(c) {
	if (c.checked) {
		for (counter = 0; counter < document.formVal.chk.length; counter++)
		{
			if ((!document.formVal.chk[counter].checked) && (!document.formVal.chk[counter].disabled))
				{  document.formVal.chk[counter].checked = true;}
		}
		if ((counter==0)  && (!document.formVal.chk.disabled)) {
			document.formVal.chk.checked = true;
		}
	}
	else {
		for (var counter = 0; counter < document.formVal.chk.length; counter++)
		{
			if ((document.formVal.chk[counter].checked) && (!document.formVal.chk[counter].disabled))
				{  document.formVal.chk[counter].checked = false;}
		};
		if ((counter==0) && (!document.formVal.chk.disabled)) {
			document.formVal.chk.checked = false;
		}
	};
}

// Aplicar
		function algunoMarcado(){
			var aplica = false;
			if (document.formVal.chk) {
				if (document.formVal.chk.value) {
					aplica = document.formVal.chk.checked;
				} else {
					for (var i=0; i<document.formVal.chk.length; i++) {
						if (document.formVal.chk[i].checked) { 
							aplica = true;
							break;
						}
					}
				}
			}
			if (aplica) {
				return (confirm("¿Está seguro de que desea aplicar los documentos seleccionadas?"));
			} else {
				alert('Debe seleccionar al menos un documento antes de Aplicar');
				return false;
			}
		}
		function funcAplicar() {
			if (algunoMarcado())
				document.formVal.action = "registroDeduccionesAplicar-sql.cfm";
			else
				return false;
		}
	//-->	
</script>
<cf_templateheader title="Lista de Deducción de Empleados">
	<cf_web_portlet_start border="true" titulo="Lista de Empleados" skin="#Session.Preferences.Skin#">
		<table width="100%" cellpadding="0" cellspacing="0">
			<tr>
				<td valign="top">
					<cfinclude template="../../portlets/pNavegacion.cfm">
			  </td>
			</tr>
			<tr>
				<td>
			        <cfinclude template="InclusionDeducciones-filtro.cfm">
				</td>
			</tr>
			<tr>
				<td  bgcolor="#F4F4F4" align="left" bordercolor="#000000"> &nbsp;
		      <input name="chkTodos" id="chkTodos" type="checkbox" onClick="javascript:Marcar(this);">&nbsp;<label for="chktodos"><strong>Todos</strong></label></td>
			</tr>
			<tr>
				<td colspan="2">
					<cfif isdefined("Url.RHIDid") and not isdefined("Form.RHIDid")>
						<cfparam name="Form.RHIDid" default="#Url.RHIDid#">
					</cfif>
					
					<cfif isdefined("Url.DEid") and not isdefined("Form.DEid")>
						<cfparam name="Form.DEid" default="#Url.DEid#">
					</cfif>
					
					<cfif isdefined("Url.TDid") and not isdefined("Form.TDid")>
						<cfparam name="Form.TDid" default="#Url.TDid#">
					</cfif>
					
					<cfif isdefined("Url.referenciaFiltro") and not isdefined("Form.referenciaFiltro")>
						<cfparam name="Form.referenciaFiltro" default="#Url.referenciaFiltro#">
					</cfif>
					
					<cfif isdefined("Url.fcreacionFiltro") and not isdefined("Form.fcreacionFiltro")>
						<cfparam name="Form.fcreacionFiltro" default="#Url.fcreacionFiltro#">
					</cfif>
					
					<cfif isdefined("Url.fdocumentoFiltro") and not isdefined("Form.fdocumentoFiltro")>
						<cfparam name="Form.fdocumentoFiltro" default="#Url.fdocumentoFiltro#">
					</cfif>
					
					<cfif isdefined("Url.usuarioFiltro") and not isdefined("Form.usuarioFiltro")>
						<cfparam name="Form.usuarioFiltro" default="#Url.usuarioFiltro#">
					</cfif>
					
					<cfif isdefined("Url.numRegistrosFiltro") and not isdefined("Form.numRegistrosFiltro")>
						<cfparam name="Form.numRegistrosFiltro" default="#Url.numRegistrosFiltro#">
					</cfif>

					<cfset filtro = "">
					<cfset navegacion = "">
					
					<cfif isdefined("Form.RHIDid") and Len(Trim(form.RHIDid)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "RHIDid=" & Form.RHIDid>
					</cfif>
					
					<cfif isdefined("Form.DEid") and Len(Trim(form.DEid)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "DEid=" & Form.DEid>
					</cfif>
					
					<cfif isdefined("Form.TDid") and Len(Trim(form.TDid)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "TDid=" & Form.TDid>
					</cfif>
					
					<cfif isdefined("Form.referenciaFiltro") and Len(Trim(form.referenciaFiltro)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "referenciaFiltro=" & Form.referenciaFiltro>
					</cfif>
					
					<cfif isdefined("Form.fcreacionFiltro") and Len(Trim(form.fcreacionFiltro)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fcreacionFiltro=" & Form.fcreacionFiltro>
					</cfif>
					
					<cfif isdefined("Form.fdocumentoFiltro") and Len(Trim(form.fdocumentoFiltro)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "fdocumentoFiltro=" & Form.fdocumentoFiltro>
					</cfif>
					
					<cfif isdefined("Form.usuarioFiltro") and Len(Trim(form.usuarioFiltro)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "usuarioFiltro=" & Form.usuarioFiltro>
					</cfif>
					
					<cfif isdefined("Form.numRegistrosFiltro") and Len(Trim(form.numRegistrosFiltro)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "numRegistrosFiltro=" & Form.numRegistrosFiltro>
						<cfset maxR = #Form.numRegistrosFiltro#>
					<cfelse>
						<cfset maxR = 17>
					</cfif>
					
					<cfquery name="rsLista" datasource="#session.DSN#">
						select RHIDid,RHIDdesc, RHIDreferencia,RHIDfechadoc,RHIDfechadesde,RHIDmonto, DEid 
						from RHInclusionDeducciones 
						where Ecodigo =<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						
						<!--- filtro --->
						<cfif isdefined("Form.DEid") and Len(Trim(form.DEid)) NEQ 0>
							and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.DEid#">
						</cfif>
						
						<cfif isdefined("Form.TDid") and Len(Trim(form.TDid)) NEQ 0>
							and TDid=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.TDid#">
						</cfif>
						
						<cfif isdefined("Form.referenciaFiltro") and Len(Trim(form.referenciaFiltro)) NEQ 0>
							and ltrim(rtrim(upper(RHIDreferencia))) like '%#trim(ucase(form.referenciaFiltro))#%'
						</cfif>
						
						<cfif isdefined("Form.fcreacionFiltro") and Len(Trim(form.fcreacionFiltro)) NEQ 0>
						
							 and BMfechaalta between <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.fcreacionFiltro)#"> and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#DateAdd('s',-1,DateAdd('d',1,LSParseDateTime(form.fcreacionFiltro)))#">
						</cfif>
						
						<cfif isdefined("Form.fdocumentoFiltro") and Len(Trim(form.fdocumentoFiltro)) NEQ 0>
							and RHIDfechadoc = <cfqueryparam  cfsqltype="cf_sql_timestamp" value="#LSDateFormat(LSParseDateTime(form.fdocumentoFiltro), 'yyyy-mm-dd 00:00:00')#">
						</cfif>
						
						<cfif isdefined("Form.usuarioFiltro") and Len(Trim(form.usuarioFiltro)) NEQ 0>
							and BMUsucodigo = <cfqueryparam  cfsqltype="cf_sql_numeric" value="#form.usuarioFiltro#">
						</cfif>
						
						order by RHIDfechadoc 
					</cfquery>
					
					<cfinvoke 
						component="sif.Componentes.pListas"
						method="pListaQuery"
						returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#rsLista#"/>
						<cfinvokeargument name="desplegar" value="RHIDdesc, RHIDreferencia,RHIDfechadoc,RHIDfechadesde,RHIDmonto"/>
						<cfinvokeargument name="etiquetas" value="Descripción,Referencia,Fecha Documento,Inicio Deducción,Monto"/>
						<cfinvokeargument name="formatos" value="V,V,D,D,M"/>
						<cfinvokeargument name="align" value="left,left,center,center,rigth"/>
						<cfinvokeargument name="ajustar" value="N"/>
						<cfinvokeargument name="irA" value="registroDeducciones.cfm"/>
						<cfinvokeargument name="keys" value="RHIDid"/>
						<cfinvokeargument name="showemptylistmsg" value="true"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="checkboxes" value="S"/>
						<cfinvokeargument name="keycorte" value="RHIDid"/>
						<cfinvokeargument name="maxrows" value="#maxR#"/> 
						<cfinvokeargument name="botones" value="Aplicar"/>
						<cfinvokeargument name="formname" value="formVal"/>
					</cfinvoke>
			  	</td>	
		  	</tr>
		</table>	
	<cf_web_portlet_end>
<cf_templatefooter>

