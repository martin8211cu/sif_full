<cf_templateheader title="Compras - Objetos del Contrato">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Documentos de la Línea de Solictud'>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
				</tr>
							
				<cfif isdefined("url.NotaId")  and not(isdefined("form.NotaId"))>
					<cfset form.NotaId = url.NotaId>					
				</cfif>
				<cfinclude template="../../Utiles/sifConcat.cfm">
				<cfquery name="rsObj" datasource="#session.DSN#">
					select a.CMNid, a.CMNDAid, a.CMNDAnombre, a.CMNDAextension, a.CMNDAdocumento, a.Usucodigo, CMNDAfechaAlta, 
						'<img alt=''Descargar Archivo'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:descargar('#_Cat# <cf_dbfunction name="to_char" args="CMNDAid" datasource="#Session.DSN#" > #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="n.CMNid"  datasource="#Session.DSN#"> #_Cat# ');''>' as imagen							
					from CMNDocumentoAdjunto a
						inner join CMNotas n 
								on n.CMNid = a.CMNid
					where a.CMNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.NotaId#">
					<!---	and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">--->
				</cfquery>
				
				<tr> 
					<td valign="top" width="50%"> 
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsObj#"/>
							<cfinvokeargument name="desplegar" value="CMNDAnombre, CMNDAextension, imagen"/>
							<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Extensi&oacute;n, Descargar"/> <!---, Descargar--->
							<cfinvokeargument name="formatos" value="S, S, S"/>
							<cfinvokeargument name="align" value="left, left, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="n"/>
							<cfinvokeargument name="irA" value="ObjetosCompras.cfm?NotaId=#form.NotaId#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="CMNDAid"/>								
						</cfinvoke>					
					</td>
					<td valign="top" width="50%">
						<cfinclude template="ObjetosCompras-form.cfm">
					</td>
				</tr>
			</table>
			
			<cfoutput>
				<script language="javascript1.2" type="text/javascript">
					function descargar(CMNDAid, CMNid){
						var param  = "CMNDAid=" + CMNDAid + "&CMNid=" + CMNid;
						document.lista.nosubmit=true;
										
						if ((CMNDAid != "") && (CMNid != "")) {
							document.form1.action = 'AbrirArchivoCompras.cfm?' + param;
							document.form1.submit();
						}
						return false;
					}
				</script>
			</cfoutput>
		
		<cf_web_portlet_end>	
	<cf_templatefooter>
