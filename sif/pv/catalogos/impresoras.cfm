<cf_templateheader title="Punto de Venta - Impresoras">
<cf_templatecss>
	
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Impresoras">
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
		<tr>
			<td width="50%" valign="top">
			
			<cfif isdefined('url.FAM12CODD_F') and not isdefined('form.FAM12CODD_F')>
					<cfparam name="form.FAM12CODD_F" default="#url.FAM12CODD_F#">
				</cfif>
				<cfif isdefined('url.FAM12DES_F') and not isdefined('form.FAM12DES')>
					<cfparam name="form.FAM12DES_F" default="#url.FAM12DES_F#">
				</cfif>

				<cfinclude template="impresoras-filtro.cfm">

				<cfset navegacion = "">
				
				<cfif isdefined("Form.FAM12CODD_F") and Len(Trim(Form.FAM12CODD_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM12CODD_F=" & Form.FAM12CODD_F>
				</cfif>				
				<cfif isdefined("Form.FAM12DES_F") and Len(Trim(Form.FAM12DES_F)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM12DES_F=" & Form.FAM12DES_F>
				</cfif>					
			
				<cfquery name="lista" datasource="#session.DSN#">
					select FAM12COD, FAM12CODD, FAM12DES
					<cfif isdefined("Form.FAM12CODD_F") and Len(Trim(Form.FAM12CODD_F)) NEQ 0>
						, '#FAM12CODD_F#' as FAM12CODD_F
					</cfif>	
					<cfif isdefined("Form.FAM12DES_F") and Len(Trim(Form.FAM12DES_F)) NEQ 0>
						, '#FAM12DES_F#' as FAM12DES_F
					</cfif>	
									
					from FAM012
					where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					<cfif isdefined('form.FAM12CODD_F') and form.FAM12CODD_F NEQ ''>
						and FAM12CODD = <cfqueryparam cfsqltype="cf_sql_integer" value ="#form.FAM12CODD_F#">
					</cfif>
					<cfif isdefined('form.FAM12DES_F') and form.FAM12DES_F NEQ ''>
						and upper(FAM12DES) like upper('%#form.FAM12DES_F#%')
					</cfif>	
					order by FAM12DES
				</cfquery>
					
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#lista#"/>
					<cfinvokeargument name="desplegar" value="FAM12CODD, FAM12DES"/>
					<cfinvokeargument name="etiquetas" value="C&oacute;digo, Descripci&oacute;n"/>
					<cfinvokeargument name="formatos" value="V, V"/>
					<cfinvokeargument name="align" value="left, left"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="impresoras.cfm"/>
					<cfinvokeargument name="keys" value="FAM12COD"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
				</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="impresoras-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>