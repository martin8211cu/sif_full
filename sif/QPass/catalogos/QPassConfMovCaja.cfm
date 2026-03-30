<cf_templateheader title="Movimientos">
	<cf_web_portlet_start border="true" titulo="Movimientos" >
		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>
		<cfset Request.jsMask = true>
		<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="60%" valign="top">
					<cfif isDefined("Url.QPMovid") and not isDefined("form.QPMovid")>
					  <cfset form.QPMovid = Url.QPMovid>
					</cfif>		
					<cfif isdefined("url.Filtro_Cod") and len(trim(url.Filtro_Cod))>
						<cfset form.Filtro_Cod = url.Filtro_Cod>
					</cfif>					
					<cfif isdefined("url.Filtro_Des") and len(trim(url.Filtro_Des))>
						<cfset form.Filtro_Des = url.Filtro_Des>
					</cfif>

				<cfif isdefined("url._")>
					<cf_navegacion name = "Filtro_Cod" default = "">
					<cf_navegacion name = "Filtro_Des" default = "">
				<cfelse>
					<cf_navegacion name = "Filtro_Cod" default = "" session="">
					<cf_navegacion name = "Filtro_Des" default = "" session="">
				</cfif>		
							
				<cfquery name="rsLista" datasource="#session.dsn#">
					select 
						QPMovid,   
						QPMovCodigo,
						QPMovDescripcion,
						Ecodigo,                   
						BMFecha,                
						BMUsucodigo   
						from QPMovimiento     
					where Ecodigo = #session.Ecodigo# 
					<cfif isdefined('form.Filtro_Cod')and len(trim(form.Filtro_Cod)) >
						and upper(QPMovCodigo) like upper('%#form.Filtro_Cod#%')
					</cfif>	
					<cfif isdefined('form.Filtro_Des')and len(trim(form.Filtro_Des)) >
						and upper(QPMovDescripcion) like upper('%#form.Filtro_Des#%')
					</cfif>	
				</cfquery>	
				
			<cfoutput>
				<form action="QPassConfMovCaja_SQL.cfm" name="form2" method="post">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
						<tr>
							<td class="titulolistas"><strong>C&oacute;digo</strong></td>
							<td class="titulolistas" colspan="2"><strong>Descripci&oacute;n</strong></td>
						</tr>
						<tr>
							<td class="titulolistas"><input type="text" name="Filtro_Cod"  tabindex="1" value="<cfif isdefined('form.Filtro_Cod')>#form.Filtro_Cod#</cfif>"></td>
							<td class="titulolistas"><input type="text" name="Filtro_Des"  tabindex="1" value="<cfif isdefined('form.Filtro_Des')>#form.Filtro_Des#</cfif>"></td>
							<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="1" onclick="funcFiltrar();" /></td>
						</tr>
						<tr><td colspan="4"><hr></td></tr>
					</table> 
					<fieldset><legend>Lista de Movimientos</legend>
					</form>	
				</cfoutput>
					<cfif isdefined('form.Filtro_Cod')and len(trim(form.Filtro_Cod)) or isdefined('form.Filtro_Des')and len(trim(form.Filtro_Des))>
						<cfset LvarDireccion = 'QPassConfMovCaja.cfm'>
					<cfelse>
						<cfset LvarDireccion = 'QPassConfMovCaja.cfm?_'>
					</cfif>
	
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					desplegar="QPMovCodigo,QPMovDescripcion"
					etiquetas="Código,Descripción"
					formatos="S,S"
					align="left,left"
					ajustar="S"
					irA="#LvarDireccion#"
					keys="QPMovid"
					maxrows="30"
					pageindex="3"
					navegacion="#navegacion#" 				 
					form_method="post"
					formname= "form3"
					usaAJAX = "no"
					/>
			</td>
			<td width="5%">&nbsp;</td>
			<td width="55%" valign="top">
				<cfinclude template="QPassConfMovCaja_form.cfm"> 
			</td>			
		</tr>
	</table>
	<br>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript" type="text/javascript">
	function funcFiltrar(){
			document.form2.action='QPassConfMovCaja.cfm';
			document.form2.submit;
	}
</script>
