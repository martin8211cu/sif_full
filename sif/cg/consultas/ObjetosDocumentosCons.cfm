<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
	<cfset PolizaDoc = t.Translate('PolizaDoc','Documentos de la p&oacute;liza contable')>
<cfoutput>
	<form name="lista" method="post">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">		
			<tr><td align="center">&nbsp;</td></tr>
			<tr><td class="tituloListas" align="center">#PolizaDoc#</td></tr>
			<tr><td align="center"><hr></td></tr>
			
			<cfif isdefined("url.IDcontable")  and not(isdefined("form.IDcontable"))>
				<cfset form.IDcontable = url.IDcontable>
			</cfif>
			<cfinclude template="../../Utiles/sifConcat.cfm">
			<cfquery name="rsObj" datasource="#session.DSN#">
				select 	IDdocsoporte,ECSdescripcion, ECScontenttype,		
							'<img alt=''Descargar Archivo'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:descargar(' #_Cat# <cf_dbfunction name="to_char" args="IDdocsoporte" datasource="#Session.DSN#" > #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="IDcontable"  datasource="#Session.DSN#"> #_Cat# ');''>' 
						as imagen	
				from EContableSoporte
				where IDcontable = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDcontable#">					
			</cfquery>
	
			<input type="hidden" name="IDdocsoporte" value="<cfif isdefined("rsObj") and len(trim(rsObj.IDdocsoporte))>#rsObj.IDdocsoporte#</cfif>">
			<input type="hidden" name="IDcontable" value="<cfif isdefined("form.IDcontable")>#form.IDcontable#</cfif>">	
					
			<cfif rsObj.RecordCount NEQ 0>
				<tr> 
					<td valign="top" width="50%"> 
						<cfinvoke 
						 component="sif.Componentes.pListas"
						 method="pListaQuery"
						 returnvariable="pListaRet">
							<cfinvokeargument name="query" value="#rsObj#"/>
							<cfinvokeargument name="desplegar" value="ECSdescripcion, ECScontenttype, imagen"/>
							<cfinvokeargument name="etiquetas" value="Descripci&oacute;n, Extensi&oacute;n, Descargar"/>
							<cfinvokeargument name="formatos" value="S, S, S"/>
							<cfinvokeargument name="align" value="left, left, center"/>
							<cfinvokeargument name="ajustar" value="N"/>
							<cfinvokeargument name="checkboxes" value="n"/>
							<cfinvokeargument name="irA" value="ObjetosDocumentosCons.cfm"/>
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="formName" value="lista"/>
							<cfinvokeargument name="incluyeForm" value="false"/>
							<cfinvokeargument name="showLink" value="false"/>											
						</cfinvoke>						
					</td>
				</tr>
			<cfelse>	
				<tr><td align="center">----------------------------  No se encontraron archivos adjuntos  ----------------------------</td></tr>
			</cfif>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr><td>&nbsp;</td></tr>
			<tr>
				<td align="center">
					<cf_botones values="Cerrar" functions="window.close();">
				</td>
			</tr>
		</table>	
	</form>	
</cfoutput>

<script language="javascript1.2" type="text/javascript">
	function descargar(IDdocsoporte, IDcontable){
		var param  = "IDdocsoporte=" + IDdocsoporte + "&IDcontable=" + IDcontable;
		if ((IDdocsoporte != "") && (IDcontable != "")) {
			document.lista.action = 'AbrirArchivoDocumentosCons.cfm?' + param;
			document.lista.submit();
		}
		return false;
	}
</script>

