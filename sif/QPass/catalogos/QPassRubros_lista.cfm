<table width="100%" border="0" cellspacing="6">
	<tr>
		<td width="60%" valign="top">
			<cfif isDefined("url.QPCid") and not isDefined("form.QPCid")>
			  <cfset form.QPCid = url.QPCid>
			</cfif>		
			<cfif isdefined("url.Filtro_Cod") and len(trim(url.Filtro_Cod))>
				<cfset form.Filtro_Cod = url.Filtro_Cod>
			</cfif>					
			<cfif isdefined("url.Filtro_desc") and len(trim(url.Filtro_desc))>
				<cfset form.Filtro_desc = url.Filtro_desc>
			</cfif>					

			<cfif isdefined("url._")>
				<cf_navegacion name = "Filtro_Cod" default = "">
				<cf_navegacion name = "Filtro_desc" default = "">
			<cfelse>
				<cf_navegacion name = "Filtro_Cod" default = "" session="">
				<cf_navegacion name = "Filtro_desc" default = "" session="">
			</cfif>		
					
		<cfquery name="rsLista" datasource="#session.dsn#">
			select 
				a.QPCid,        
				a.QPCcodigo,
				a.QPCdescripcion, 
				a.QPCmonto,       
				a.Ecodigo,         
				a.BMFecha,      
				a.BMUsucodigo, 
				a.ts_rversion
					from QPCausa a   
				where Ecodigo = #session.Ecodigo#  
				<cfif isdefined('form.Filtro_Cod')and len(trim(form.Filtro_Cod))>
					and upper(QPCcodigo) like upper('%#form.Filtro_Cod#%')
				</cfif>	
				<cfif isdefined('form.Filtro_desc')and len(trim(form.Filtro_desc))>
					and upper(QPCdescripcion) like upper('%#form.Filtro_desc#%')
				</cfif>	
		</cfquery>	
				
		<cfoutput>
			<form action="QPassRubros_SQL.cfm" name="form2" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas"><strong>C&oacute;digo</strong></td>
						<td class="titulolistas" colspan="2"><strong>Descripci&oacute;n</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="Filtro_Cod"  tabindex="1" value="<cfif isdefined('form.Filtro_Cod')>#form.Filtro_Cod#</cfif>"></td>
						<td class="titulolistas"><input type="text" name="Filtro_desc"  tabindex="1" value="<cfif isdefined('form.Filtro_desc')>#form.Filtro_desc#</cfif>"></td>
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="1" onclick="funcFiltrar();" /></td>
					</tr>
				</table> 
				<fieldset><legend>Lista de Causas</legend>
			</form>	
		</cfoutput>
				<cfif isdefined('form.Filtro_Cod')and len(trim(form.Filtro_Cod)) or  isdefined('form.Filtro_desc')and len(trim(form.Filtro_desc))>
					<cfset LvarDireccion = 'QPassRubros.cfm'>
				<cfelse>
					<cfset LvarDireccion = 'QPassRubros.cfm?_'>
				</cfif>

			<cfinvoke
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="rsLista"
				query="#rsLista#"
				desplegar="QPCcodigo,QPCdescripcion,QPCmonto"
				etiquetas="Código,Descripción,Monto"
				formatos="S,S,M"
				align="left,left,left"
				ajustar="S"
				irA="#LvarDireccion#"
				keys="QPCid"
				maxrows="30"
				pageindex="3"
				form_method="post"
				formname= "form3"
				usaAJAX = "no"
				botones="Nuevo"
			/>
			</td>	
		</tr>
	</table>

	<script language="JavaScript" type="text/javascript">
		function funcFiltrar(){
				document.form2.action='QPassRubros.cfm';
				document.form2.submit;
		}
	</script>
