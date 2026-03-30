<cfinclude template="../../Utiles/sifConcat.cfm">
<form name="form1">
	<table width="100%"  border="0" cellspacing="0" cellpadding="0">		
		<tr><td align="center">&nbsp;</td></tr>
		<tr><td class="tituloListas" align="center">Archivos Adjuntos de la Solicitud de Compra</td></tr>
		<tr><td align="center"><hr></td></tr>
		<input type="hidden" name="DSlinea1" value="">
		<input type="hidden" name="DDAid" value="">		
		
		<cfif isdefined("url.DSlinea1")  and not(isdefined("form.DSlinea1"))>
			<cfset form.DSlinea1 = url.DSlinea1>
		</cfif>
		<cfif isdefined("url.LPCid")  and not(isdefined("form.LPCid"))>
			<cfset form.LPCid = url.LPCid>
		</cfif>
		
		<!---- Query para obtener el nombre de la base de datos donde estan los archivos adjuntos (sifpublica)--->
		<cfquery name="rsBDs" datasource="sifpublica">
			select cncache, DSlinea, DDAid
			from DDocumentosAdjuntos
			where  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.DSlinea1#">
				and LPCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.LPCid#"> 														
		</cfquery>

		<input type="hidden" name="cncache" value="<cfoutput>#rsBDs.cncache#</cfoutput>">

		<cfif rsBDs.cncache NEQ''>	<!--- Si no hay registros en la tabla ---->			
			<cfquery name="rsObj" datasource="#rsBDs.cncache#">
				select a.DDAnombre, a.DDAextension, 
					'<img alt=''Descargar Archivo'' style=''cursor:hand;'' border=''0'' src=''../../imagenes/Description.gif'' onClick=''javascript:descargar(' #_Cat# <cf_dbfunction name="to_char" args="a.DDAid" datasource="#rsBDs.cncache#" > #_Cat# ',' #_Cat# <cf_dbfunction name="to_char" args="a.DSlinea"  datasource="#rsBDs.cncache#"> #_Cat# ');''>' as imagen
				from DDocumentosAdjuntos a
				where a.DSlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsBDs.DSlinea#">
			</cfquery>	
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
						<cfinvokeargument name="irA" value="ObjetosCotizaciones.cfm?DSlinea1=#form.DSlinea1#"/>
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
	<cfoutput>
		<script language="javascript1.2" type="text/javascript">
			function descargar(DDAid, DSlinea1){
				var param  = "DDAid=" + DDAid + "&DSlinea1=" + DSlinea1;				
				if ((DDAid != "") && (DSlinea1 != "")) {
					document.form1.DSlinea1.value = DSlinea1;
					document.form1.DDAid.value = DDAid;
					document.form1.action = 'AbrirArchivoCotizaciones.cfm';
					document.form1.submit();
				}
				return false;
			}						
		</script>
	</cfoutput>

