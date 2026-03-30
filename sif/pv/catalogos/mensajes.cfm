<cf_templateheader title="Punto de Venta - Mensajes">
<cf_templatecss>
	
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Mensajes">
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<td width="50%" valign="top">
				<cfif isdefined('url.FAM23DES_F') and not isdefined('form.FAM23DES_F')>
					<cfparam name="form.FAM23DES_F" default="#url.FAM23DES_F#">
				</cfif>

				<cfinclude template="mensajes-filtro.cfm">

				<cfset navegacion = "">
				
				<cfif isdefined("Form.FAM23DES_F") and Len(Trim(Form.FAM23DES_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM23DES_F=" & Form.FAM23DES_F>
				</cfif>
		
				<cfquery name="lista" datasource="#session.DSN#">
					select FAM23COD, FAM23DES 
					<cfif isdefined("Form.FAM23DES_F") and Len(Trim(Form.FAM23DES_F)) NEQ 0>
						, '#FAM23DES_F#' as FAM23DES_F
					</cfif>		
							
					from FAM023
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined('form.FAM23DES_F') and form.FAM23DES_F NEQ ''>
						and upper(FAM23DES) like upper('%#form.FAM23DES_F#%')
					</cfif>	
					 
					order by FAM23COD, FAM23DES
				</cfquery>
					
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#lista#"/>
					<cfinvokeargument name="desplegar" value="FAM23COD, FAM23DES"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo,Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="mensajes.cfm"/>
					<cfinvokeargument name="keys" value="FAM23COD"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
				</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="mensajes-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>