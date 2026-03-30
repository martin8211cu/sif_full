<cfinvoke  key="LB_Titulo" default="Objetos del Documento Contable" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Titulo" xmlfile="ObjetosDocumentos.xml"/>
<cfinvoke  key="LB_Descripcion" default="Descripci&oacute;n" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Descripcion" xmlfile="ObjetosDocumentos.xml"/>
<cfinvoke  key="LB_Extension" default="Extensi&oacute;n" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Extension" xmlfile="ObjetosDocumentos.xml"/>
<cfinvoke  key="LB_Descargar" default="Descargar" component="sif.Componentes.Translate" method="Translate"
returnvariable="LB_Descargar" xmlfile="ObjetosDocumentos.xml"/>


<cfparam name="sufix" default="">
<cfinclude template="../../Utiles/sifConcat.cfm">
	<cf_templateheader title="#LB_Titulo#">
	    <cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='#LB_Titulo#'>
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
		<tr><td>
			<table width="100%"  border="0" cellspacing="0" cellpadding="0">
				<tr>
					<td colspan="2"><cfinclude template="../../portlets/pNavegacion.cfm"></td>
				</tr><!---as imagen--->
				<cfquery name="rsObj" datasource="#session.DSN#">
					select ECSdescripcion, ECScontenttype, ECStipo, ECStexto, IDdocsoporte, IDcontable,
						case ECStipo when 0 then '' 
						else
							'<img alt=''Descargar Archivo'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:descargar(' #_Cat# <cf_dbfunction name="to_char" args="IDdocsoporte" datasource="#Session.DSN#" > #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="IDcontable"  datasource="#Session.DSN#"> #_Cat# ');''>' 
						end as imagen	
					from EContableSoporte
					where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">				
				</cfquery>								
				<tr> 
					<td valign="top" width="50%"> 

						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsObj#"/>
							<cfinvokeargument name="desplegar" value="ECSdescripcion, ECScontenttype, imagen"/>
							<cfinvokeargument name="etiquetas" value="#LB_Descripcion#, #LB_Extension#, #LB_Descargar#"/>
							<cfinvokeargument name="formatos" value=""/>
							<cfinvokeargument name="align" value="left, left, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="n"/>
							<cfinvokeargument name="irA" value="ObjetosDocumentos#sufix#.cfm?IDcontable=#form.IDcontable#"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="keys" value="IDdocsoporte"/>								
						</cfinvoke>						
					</td>
					<td valign="top" width="50%">
						<cfinclude template="ObjetosDocumentos-form.cfm">
					</td>
				</tr>
			</table>
			
			
			
			<cfoutput>
				<script language="javascript1.2" type="text/javascript">
					function descargar(IDdocsoporte, IDcontable){
						var param  = "IDdocsoporte=" + IDdocsoporte + "&IDcontable=" + IDcontable;
						document.lista.nosubmit=true;
										
						if ((IDdocsoporte != "") && (IDcontable != "")) {
							document.form1.action = 'AbrirArchivoDocumentos#sufix#.cfm?' + param;
							document.form1.submit();
						}
						return false;
					}
				</script>
			</cfoutput>
		
		<cf_web_portlet_end>	
	</td></tr>
	</table>
<cf_templatefooter>