<cf_templateheader title="Punto de Venta - Vendedores">
<cf_templatecss>
	
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Vendedores">
		<table width="100%" align="center" cellpadding="0" border="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td width="40%" valign="top">
					<cfif isdefined('url.FAM21CED_F') and not isdefined('form.FAM21CED_F')>
						<cfparam name="form.FAM21CED_F" default="#url.FAM21CED_F#">
					</cfif>
					<cfif isdefined('url.FAM21NOM_F') and not isdefined('form.FAM21NOM_F')>
						<cfparam name="form.FAM21NOM_F" default="#url.FAM21NOM_F#">
					</cfif>
	
					<cfinclude template="vendedores-filtro.cfm">
	
					<cfset navegacion = "">
					
					<cfif isdefined("Form.FAM21CED_F") and Len(Trim(Form.FAM21CED_F)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM21CED_F=" & Form.FAM21CED_F>
					</cfif>				
					<cfif isdefined("Form.FAM21NOM_F") and Len(Trim(Form.FAM21NOM_F)) NEQ 0>
						<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM21NOM_F=" & Form.FAM21NOM_F>
					</cfif>
				
					<cfquery name="lista" datasource="#session.DSN#">
						Select FAX04CVD, FAM21CED,FAM21NOM,CFdescripcion, FAM21PCO
						<cfif isdefined("Form.FAM21CED_F") and Len(Trim(Form.FAM21CED_F)) NEQ 0>
							, '#FAM21CED_F#' as FAM21CED_F
						</cfif>	
						<cfif isdefined("Form.FAM21NOM_F") and Len(Trim(Form.FAM21NOM_F)) NEQ 0>
							, '#FAM21NOM_F#' as FAM21NOM_F
						</cfif>		
						from FAM021 A, CFuncional B
						
						where A.CFid = B.CFid						
						and A.Ecodigo = B.Ecodigo
						and A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						<cfif isdefined('form.FAM21CED_F') and form.FAM21CED_F NEQ ''>
							and upper(FAM21CED) like upper('%#form.FAM21CED_F#%')
						</cfif>
						<cfif isdefined('form.FAM21NOM_F') and form.FAM21NOM_F NEQ ''>
							and upper(FAM21NOM) like upper('%#form.FAM21NOM_F#%')
						</cfif>			
						  						
						order by A.FAX04CVD, A.FAM21NOM
					</cfquery>
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#lista#"/>
							<cfinvokeargument name="desplegar" value="FAX04CVD, FAM21CED, FAM21NOM"/>
							<cfinvokeargument name="etiquetas" value="C&oacute;digo, Identificacion, Nombre"/>
							<cfinvokeargument name="formatos" value="V, V, V"/>
							<cfinvokeargument name="align" value="left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="vendedores.cfm"/>
							<cfinvokeargument name="keys" value="FAX04CVD"/>
							<cfinvokeargument name="showemptylistmsg" value="true"/>
					</cfinvoke>
				</td>
				<td width="60%" valign="top"><cfinclude template="vendedores-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>