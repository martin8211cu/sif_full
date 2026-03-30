<cf_templateheader title="Punto de Venta - Documentos">
<cf_templatecss>
	
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Documentos">
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<td width="50%" valign="top">
				<cfif isdefined('url.FAD01COD_F') and not isdefined('form.FAD01COD_F')>
					<cfparam name="form.FAD01COD_F" default="#url.FAD01COD_F#">
				</cfif>
				<cfif isdefined('url.FAD01DES_F') and not isdefined('form.FAD01DES_F')>
					<cfparam name="form.FAD01DES_F" default="#url.FAD01DES_F#">
				</cfif>

				<cfinclude template="documentos-filtro.cfm">

				<cfset navegacion = "">
				
				<cfif isdefined("Form.FAD01COD_F") and Len(Trim(Form.FAD01COD_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAD01COD_F=" & Form.FAD01COD_F>
				</cfif>				
				<cfif isdefined("Form.FAD01DES_F") and Len(Trim(Form.FAD01DES_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAD01DES_F=" & Form.FAD01DES_F>
				</cfif>
		
				<cfquery name="lista" datasource="#session.DSN#">
					select FAD01COD, FAD01DES, FAD01REF, FAD01GEN, FAD01PRE, FAD01PRS, FAD01INT 
					<cfif isdefined("Form.FAD01COD_F") and Len(Trim(Form.FAD01COD_F)) NEQ 0>
						, '#FAD01COD_F#' as FAD01COD_F
					</cfif>	
					<cfif isdefined("Form.FAD01DES_F") and Len(Trim(Form.FAD01DES_F)) NEQ 0>
						, '#FAD01DES_F#' as FAD01DES_F
					</cfif>		
							
					from FAD001
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined('form.FAD01COD_F') and form.FAD01COD_F NEQ ''>
						and FAD01COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.FAD01COD_F#">
					</cfif>
					<cfif isdefined('form.FAD01DES_F') and form.FAD01DES_F NEQ ''>
						and upper(FAD01DES) like upper('%#form.FAD01DES_F#%')
					</cfif>	
					 
					order by FAD01COD, FAD01DES
				</cfquery>
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#lista#"/>
					<cfinvokeargument name="desplegar" value="FAD01COD, FAD01DES"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="documentos.cfm"/>
					<cfinvokeargument name="keys" value="FAD01COD"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
				</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="documentos-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>