<table width="100%" border="0" cellspacing="6">
	<tr>
		<td width="60%" valign="top">
			<cfif isDefined("url.QPvtaConvid") and not isDefined("form.QPvtaConvid")>
			  <cfset form.QPvtaConvid = url.QPvtaConvid>
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
				<cf_navegacion name = "FiltroFechaI" default = "">
				<cf_navegacion name = "FiltroFechaF" default = "">
			<cfelse>
				<cf_navegacion name = "Filtro_Cod" default = "" session="">
				<cf_navegacion name = "Filtro_desc" default = "" session="">
				<cf_navegacion name = "FiltroFechaI" default = "" session="">
				<cf_navegacion name = "FiltroFechaF" default = "" session="">
			</cfif>		
					
		<cfquery name="rsLista" datasource="#session.dsn#">
			select 
				QPvtaConvid, 
				QPvtaConvCod,           
				QPvtaConvDesc,         
				Ecodigo,                       
				QPvtaConvFecIni,       
				QPvtaConvFecFin,      
				QPvtaConvFrecuencia,       
				BMusucodigo,    
				BMFecha,           
				QPvtaConvFact,
				QPvtaConvCont
			from QPventaConvenio  
			where Ecodigo = #session.Ecodigo#  
			<cfif isdefined('form.Filtro_Cod')and len(trim(form.Filtro_Cod))>
				and upper(QPvtaConvCod) like upper('%#form.Filtro_Cod#%')
			</cfif>	
			<cfif isdefined('form.Filtro_desc')and len(trim(form.Filtro_desc))>
				and upper(QPvtaConvDesc) like upper('%#form.Filtro_desc#%')
			</cfif>	
			
			<cfif isdefined('form.FiltroFechaI')and len(trim(form.FiltroFechaI))>
				and QPvtaConvFecIni = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FiltroFechaI)#">
			</cfif>	
			<cfif isdefined('form.FiltroFechaF')and len(trim(form.FiltroFechaF))>
				and QPvtaConvFecFin = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.FiltroFechaF)#">
			</cfif>	
		</cfquery>	
				
		<cfoutput>
			<form action="QPassConvenio_SQL.cfm" name="form2" method="post">
				<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
					<tr>
						<td class="titulolistas"><strong>C&oacute;digo</strong></td>
						<td class="titulolistas"><strong>Descripci&oacute;n</strong></td>
						<td class="titulolistas"><strong>Vigencia Desde</strong></td>
						<td class="titulolistas" colspan="4"><strong>Vigencia Hasta</strong></td>
					</tr>
					<tr>
						<td class="titulolistas"><input type="text" name="Filtro_Cod"  tabindex="1" value="<cfif isdefined('form.Filtro_Cod')>#form.Filtro_Cod#</cfif>"></td>
						<td class="titulolistas"><input type="text" name="Filtro_desc"  tabindex="1" value="<cfif isdefined('form.Filtro_desc')>#form.Filtro_desc#</cfif>"></td>
						<td class="titulolistas"><cfif isdefined('form.FiltroFechaI')><cf_sifcalendario form="form2" value="#form.FiltroFechaI#" name="FiltroFechaI" tabindex="1"><cfelse><cf_sifcalendario form="form2" value="" name="FiltroFechaI" tabindex="1"></cfif></td>
						<td class="titulolistas"><cfif isdefined('form.FiltroFechaF')><cf_sifcalendario form="form2" value="#form.FiltroFechaF#" name="FiltroFechaF" tabindex="1"><cfelse><cf_sifcalendario form="form2" value="" name="FiltroFechaF" tabindex="1"></cfif></td>
						<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="1" onclick="funcFiltrar();" /></td>
					</tr>
				</table> 
				<fieldset><legend>Lista de Convenios</legend>
			</form>	
		</cfoutput>
				<cfif isdefined('form.Filtro_Cod')and len(trim(form.Filtro_Cod)) or  isdefined('form.Filtro_desc')and len(trim(form.Filtro_desc)) or  isdefined('form.FiltroFechaI')and len(trim(form.FiltroFechaI)) or  isdefined('form.FiltroFechaF')and len(trim(form.FiltroFechaF))>
					<cfset LvarDireccion = 'QPassConvenio.cfm'>
				<cfelse>
					<cfset LvarDireccion = 'QPassConvenio.cfm?_'>
				</cfif>

			<cfinvoke
				component="sif.Componentes.pListas"
				method="pListaQuery"
				returnvariable="rsLista"
				query="#rsLista#"
				desplegar="QPvtaConvCod,QPvtaConvDesc,QPvtaConvFecIni, QPvtaConvFecFin"
				etiquetas="Código,Descripción,Vigencia Desde, Hasta"
				formatos="S,S,D,D"
				align="left,left,left,left"
				ajustar="S"
				irA="#LvarDireccion#"
				keys="QPvtaConvid"
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
				document.form2.action='QPassConvenio.cfm';
				document.form2.submit;
		}
	</script>
