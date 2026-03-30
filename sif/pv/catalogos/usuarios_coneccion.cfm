<cf_templateheader title="Punto de Venta - Usuarios de Conexión">
<cf_templatecss>
	
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Usuarios de Conexión">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td width="50%" valign="top">
					<cfif isdefined('url.FAlogin_F') and not isdefined('form.FAlogin_F')>
						<cfparam name="form.FAlogin_F" default="#url.FAlogin_F#">
					</cfif>
					
					<cfinclude template="usuarios_coneccion-filtro.cfm">
	
					<cfset navegacion = "">
					
					<cfif isdefined("Form.FAlogin_F") and Len(Trim(Form.FAlogin_F)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAlogin_F=" & Form.FAlogin_F>
					</cfif>				
										
					<cfquery name="lista" datasource="#session.DSN#">
						Select FAlogin, FAcontrasena, BaseDatos, Servidor, Ecodigo as EcodUsu
						<cfif isdefined("Form.FAlogin_F") and Len(Trim(Form.FAlogin_F)) NEQ 0>
							, '#FAlogin_F#' as FAlogin_F
						</cfif>	
						
						from FAUsuario
						
						where Ecodigo  = <cfqueryparam value="#session.Ecodigo#" 	 cfsqltype="cf_sql_integer"> 
						<cfif isdefined('form.FAlogin_F') and form.FAlogin_F NEQ ''>
							and upper(FAlogin) like upper('%#form.FAlogin_F#%')
						</cfif>
						 						  						
						order by FAlogin
					</cfquery>
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#lista#"/>
							<cfinvokeargument name="desplegar" value="FAlogin, BaseDatos, Servidor"/>
							<cfinvokeargument name="etiquetas" value="Login, Base de Datos, Servidor"/>
							<cfinvokeargument name="formatos" value="V, V, V"/>
							<cfinvokeargument name="align" value="left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="usuarios_coneccion.cfm"/>
							<cfinvokeargument name="showemptylistmsg" value="true"/>
					</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="usuarios_coneccion-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>
