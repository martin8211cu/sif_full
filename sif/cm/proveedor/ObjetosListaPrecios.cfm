<cf_templateheader title="Compras - Objetos de la Lista de Precios">
		<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Objetos de la Lista de Precios'>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
				<td colspan="2">
					<cfinclude template="pNavegacion.cfm">
				</td>
				</tr>
                	<cfinclude template="../../Utiles/sifConcat.cfm">
                    <cfquery name="rsListaObj" datasource="sifpublica">
                        select a.OLPid, a.ELPid, a.OLPdescripcion, a.OLParchivo, a.OLPextension,
                            '<img alt=''Descargar Archivo'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:descargar('#_Cat# <cf_dbfunction name="to_char" args="OLPid"  datasource="#Session.DSN#" > #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="b.ELPid"  datasource="#Session.DSN#" > #_Cat# ');''>' as imagen,
                            b.ELPdescripcion
                        from ObjetosListaPrecios a 
                            inner join EListaPrecios b
                                on a.ELPid = b.ELPid
                        where a.ELPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ELPid#">
                    </cfquery>
				<tr>
					<td colspan="2" class="tituloPersona" align="left" style="text-align:left" nowrap><cfoutput>Descripción : #rsListaObj.ELPdescripcion#</cfoutput></td> 
				</tr>	
				<tr> 
					<td valign="top" width="50%"> 
						
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsListaObj#"/>
							<cfinvokeargument name="desplegar" value="OLPdescripcion, OLPextension, imagen"/>
							<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Extensi&oacute;n, Descargar"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="align" value="left, left, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="n"/>
							<cfinvokeargument name="irA" value="ObjetosListaPrecios.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="OLPid"/>
						</cfinvoke>
						
					</td>
					<td valign="top" width="50%">
						<cfinclude template="ObjetosListaPrecios-form.cfm">
					</td>
				</tr>
			</table>
			
			<cfoutput>
				<script language="javascript1.2" type="text/javascript">
					function descargar(OLPid, ELPid){
						var param  = "OLPid=" + OLPid + "&ELPid=" + ELPid;
						document.lista.nosubmit=true;
						
						if ((OLPid != "") && (ELPid != "")) {
							document.form1.action = 'AbrirArchivoListaPrecios.cfm?' + param;
							document.form1.submit();
						}
						return false;
					}
				</script>
			</cfoutput>
			
		<cf_web_portlet_end>	
	<cf_templatefooter>