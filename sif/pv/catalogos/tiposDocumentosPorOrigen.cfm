<cf_templateheader title="Punto de Venta - Tipos de Documentos por Origen">
<cf_templatecss>	
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Documentos por Origen">
	<table width="100%" align="center" cellpadding="0" cellspacing="0">
		<tr><td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
			<tr> 
			 <td width="50%" valign="top">			  
			<cfif isdefined('url.Origen') and not isdefined('form.Origen')>
					<cfparam name="form.Origen" default="#url.Origen#">
			</cfif>					
			        <cfset navegacion = "">
			<cfif isdefined("Form.Origen") and Len(Trim(Form.Origen)) NEQ 0>
					<cfset navegacion = navegacion & Iif(Len(Trim(navegacion)) NEQ 0, DE("&"), DE("")) & "Origen=" & Form.Origen>
			</cfif>
			 <cfquery name="lista" datasource="#session.DSN#">
					select 
						a.FAX01ORIGEN,a.CCTcodigoAP,a.CCTcodigoDE,a.CCTcodigoFC,a.CCTcodigoCR,a.CCTcodigoRC, b.OIDescripcion
					from TDocumentosXOrigen a
						inner join OrigenesInterfazPV b
							on a.FAX01ORIGEN = b.FAX01ORIGEN and b.Ecodigo = a.Ecodigo
					where a.Ecodigo = #session.Ecodigo#
					<cfif isdefined('form.Origen') and form.Origen NEQ ''>
						and upper(b.OIDescripcion) like upper('%#form.Origen#%')
					</cfif>						 
					order by a.FAX01ORIGEN
				</cfquery>					
				<cfinclude template="tiposDocumentosPorOrigen_filtro.cfm">
				<cfinvoke 
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="pListaRet">
					<cfinvokeargument name="query" value="#lista#"/>
					<cfinvokeargument name="desplegar" value="OIDescripcion,FAX01ORIGEN,CCTcodigoFC,CCTcodigoCR,CCTcodigoAP,CCTcodigoDE,CCTcodigoRC"/>
					<cfinvokeargument name="etiquetas" value="Descripción,Origen ,Fac Contado,Fac Crédito,Doc Apartado,Doc Devoluciones,Recibo"/>
					<cfinvokeargument name="formatos" value="S,S,S,S,S,S,S"/>
					<cfinvokeargument name="align" value="center,center,center,center,center,center,center"/>
					<cfinvokeargument name="ajustar" value="N"/>
					<cfinvokeargument name="irA" value="tiposDocumentosPorOrigen.cfm"/>
					<cfinvokeargument name="keys" value="FAX01ORIGEN"/>
					<cfinvokeargument name="showemptylistmsg" value="true"/>
				</cfinvoke>
				</td>
				<td width="50%" valign="top"><cfinclude template="tiposDocumentosPorOrigen_form.cfm">
				</td>
			</tr>		
		</table>
	<cf_web_portlet_end>
	<cf_templatefooter>