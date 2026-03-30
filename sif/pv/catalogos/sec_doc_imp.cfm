<cf_templateheader title="Punto de Venta - Secuencia de Documentos por Impresoras">
<cf_templatecss>
	
		<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Secuencia de Documentos por Impresoras">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr>
				<td width="50%" valign="top">
					<cfif isdefined('url.FAM12CODD_F') and not isdefined('form.FAM12CODD_F')>
						<cfparam name="form.FAM12CODD_F" default="#url.FAM12CODD_F#">
					</cfif>
					<cfif isdefined('url.FAM12DES_F') and not isdefined('form.FAM12DES_F')>
						<cfparam name="form.FAM12DES_F" default="#url.FAM12DES_F#">
					</cfif>				
					<cfinclude template="sec_doc_imp-filtro.cfm">
	
					<cfset navegacion = "">

					<cfquery name="lista" datasource="#session.DSN#">
						select a.FAM12COD, a.FAX09DIN, a.FAX09DFI,a.FAX01ORIGEN, a.FAX09NXT, a.FAX09SER, b.FAM12DES, b.FAM12CODD
						<cfif isdefined("Form.FAM12CODD_F") and Len(Trim(Form.FAM12CODD_F)) NEQ 0>
							, '#form.FAM12CODD_F#' as FAM12CODD_F
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM12CODD_F=" & Form.FAM12CODD_F>
						</cfif>	
						<cfif isdefined("Form.FAM12DES_F") and Len(Trim(Form.FAM12DES_F)) NEQ 0>
							, '#form.FAM12DES_F#' as FAM12DES_F
							<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "FAM12DES_F=" & Form.FAM12DES_F>
						</cfif>							
						
						from FAX009 as a
						
							inner join FAM012 as b
								on a.FAM12COD = b.FAM12COD
								<cfif isdefined('form.FAM12CODD_F') and form.FAM12CODD_F NEQ ''>
									 and b.FAM12CODD = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.FAM12CODD_F#">									
								</cfif>
								<cfif isdefined("Form.FAM12DES_F") and Len(Trim(Form.FAM12DES_F)) NEQ 0>
									and upper(b.FAM12DES) like upper('%#form.FAM12DES_F#%')		
								</cfif>										
									
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						order by b.FAM12COD
					</cfquery>
					<!---<cf_dump var="#lista#">--->
					<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#lista#"/>
							<cfinvokeargument name="desplegar" value=" FAM12CODD, FAM12DES, FAX09DIN, FAX09DFI,FAX01ORIGEN, FAX09NXT, FAX09SER "/>
							<cfinvokeargument name="etiquetas" value=" Codigo, Impresora, Doc Inicial, Doc Final,Origen, Doc Siguiente, Serie"/>
							<cfinvokeargument name="formatos" value="V, V, V,V, V, V, V"/>
							<cfinvokeargument name="align" value="left, left, left,left, left, left, left"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="irA" value="sec_doc_imp.cfm"/>
							<cfinvokeargument name="keys" value="FAM12COD,FAX01ORIGEN"/>
							<cfinvokeargument name="showemptylistmsg" value="true"/>
							<cfinvokeargument name="navegacion" value="#navegacion#"/>						
					</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="sec_doc_imp-form.cfm"></td>
			</tr>		
		</table>
		<cf_web_portlet_end>
<cf_templatefooter>

