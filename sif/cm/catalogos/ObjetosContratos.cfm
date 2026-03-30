<cf_templateheader title="Compras - Objetos del Contrato">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Objetos del Contrato'>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
				</tr>
                <cfinclude template="../../Utiles/sifConcat.cfm">
				<cfquery name="rsContratosObj" datasource="#session.DSN#">
					select a.OCid, a.ECid, a.OCdescripcion, a.OCarchivo, a.OCextension,
						'<img alt=''Descargar Archivo'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:descargar(' #_Cat# <cf_dbfunction name="to_char" args="OCid" datasource="#Session.DSN#" > #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="b.ECid"  datasource="#Session.DSN#"> #_Cat# ');''>' as imagen,
						b.SNcodigo, b.ECdesc 
					from ObjetosContrato a 
						inner join EContratosCM b 
							on a.ECid = b.ECid
					where a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
				</cfquery>
				<tr>
					<cfquery name="Proveedor" datasource="#session.DSN#">
						select a.SNnumero, a.SNnombre, b.ECdesc
						from SNegocios a
							inner join EContratosCM b
								on a.Ecodigo=b.Ecodigo
								and a.SNcodigo=b.SNcodigo
								and b.ECid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ECid#">
					</cfquery>
					<td colspan="2" class="tituloPersona" align="left" style="text-align:left" nowrap><cfoutput>Contrato: #Proveedor.ECdesc# <br>Proveedor: #Proveedor.SNnumero# #Proveedor.SNnombre#</cfoutput></td> 
				</tr>	

				<tr> 
					<td valign="top" width="50%"> 
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsContratosObj#"/>
							<cfinvokeargument name="desplegar" value="OCdescripcion, OCextension, imagen"/>
							<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Extensi&oacute;n, Descargar"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="align" value="left, left, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="n"/>
							<cfinvokeargument name="irA" value="ObjetosContratos.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="OCid"/>
						</cfinvoke>
					</td>
					<td valign="top" width="50%">
						<cfinclude template="ObjetosContrato-form.cfm">
					</td>
				</tr>
			</table>
			
			<cfoutput>
				<script language="javascript1.2" type="text/javascript">
					function descargar(OCid, ECid){
						var param  = "OCid=" + OCid + "&ECid=" + ECid;
						document.lista.nosubmit=true;
										
						if ((OCid != "") && (ECid != "")) {
							document.form1.action = 'AbrirArchivoContratos.cfm?' + param;
							document.form1.submit();
						}
						return false;
					}
				</script>
			</cfoutput>
		
		<cf_web_portlet_end>	
	<cf_templatefooter>