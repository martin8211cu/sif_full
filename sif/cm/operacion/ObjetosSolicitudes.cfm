<cf_templateheader title="Compras - Documentos de la Solicitud">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Documentos de la Línea de Solicitud'>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
				</tr>
								
				<cfif isdefined("url.DSlinea1")  and not(isdefined("form.DSlinea1"))>
					<cfset form.DSlinea1 = url.DSlinea1>
				</cfif>
				<cfinclude template="../../Utiles/sifConcat.cfm">
				<cfquery name="rsObj" datasource="#session.DSN#">
					select a.DDAid, a.DDAnombre, a.DDAextension, 
						'<img alt=''Descargar Archivo'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:descargar(' #_Cat# <cf_dbfunction name="to_char" args="DDAid" datasource="#Session.DSN#" > #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="b.DSlinea"  datasource="#Session.DSN#"> #_Cat# ');''>' as imagen							
					from DDocumentosAdjuntos a
						inner join DSolicitudCompraCM b 
								on a.DSlinea = b.DSlinea
					where a.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSlinea1#">
					<cfif isdefined('COMPRAS.PROCESOCOMPRA.CMPID') and Session.Compras.ProcesoCompra.CMPid EQ "">
						and CMPid is NULL
					<cfelseif isdefined('COMPRAS.PROCESOCOMPRA.CMPID') and Session.Compras.ProcesoCompra.CMPid NEQ "">
						and CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
					<cfelseif isdefined('COMPRAS.PROCESOCOMPRA.CMPID')>
						and 
							(
								CMPid IS NULL OR
								CMPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Compras.ProcesoCompra.CMPid#">
							)
					</cfif>
				</cfquery>
                
                <cfset ndoc = 0 >
                <cfif isdefined("rsObj") AND rsObj.recordcount GT 0>

						<cfset ndoc = rsObj.recordcount >

                </cfif>
				
				<tr> 
					<td valign="top" width="50%"> 
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsObj#"/>
							<cfinvokeargument name="desplegar" value="DDAnombre, DDAextension, imagen"/>
							<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Extensi&oacute;n, Descargar"/> <!---, Descargar--->
							<cfinvokeargument name="formatos" value="S, S, S"/>
							<cfinvokeargument name="align" value="left, left, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="n"/>
							<cfinvokeargument name="irA" value="ObjetosSolicitudes.cfm?DSlinea1=#form.DSlinea1#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="DDAid"/>								
						</cfinvoke>						
					</td>
					<td valign="top" width="50%">
						<cfinclude template="ObjetosSolicitudes-form.cfm">
					</td>
				</tr>
			</table>
			
			<cfoutput>
				<script language="javascript1.2" type="text/javascript">
					function descargar(DDAid, DSlinea1){
						var param  = "DDAid=" + DDAid + "&DSlinea1=" + DSlinea1;
						document.lista.nosubmit=true;
										
						if ((DDAid != "") && (DSlinea1 != "")) {
							document.lista.action = 'AbrirArchivoSolicitudes.cfm?' + param;
							document.lista.submit();
						}
						return false;
					}
					function cambiarCarpetaDoc(ndocument)
					{
						//alert(window.opener.location);
						window.opener.document.getElementById('img'+#form.DSlinea1#).title="Documentos Adjuntos:"+ndocument;
						window.opener.document.getElementById('img'+#form.DSlinea1#).alt="Documentos Adjuntos:"+ndocument;
						if(ndocument>0)
						{
							window.opener.document.getElementById('img'+#form.DSlinea1#).src="/cfmx/sif/imagenes/OP/folder-go.gif";
						}else{
							window.opener.document.getElementById('img'+#form.DSlinea1#).src="/cfmx/sif/imagenes/ftv2folderopen.gif";
						}
					}
					
					cambiarCarpetaDoc(#ndoc#);
					
				</script>
			</cfoutput>
		
		<cf_web_portlet_end>	
	<cf_templatefooter>
