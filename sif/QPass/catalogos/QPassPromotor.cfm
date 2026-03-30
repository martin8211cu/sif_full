<cf_templateheader title="Promotores">
	<cf_web_portlet_start border="true" titulo="Promotores" >
		<script language="JavaScript1.2" type="text/javascript" src="/cfmx/sif/js/utilesMonto.js"></script>
		<script language="JavaScript" src="/cfmx/sif/js/MaskApi/masks.js"></script>
		<cfset Request.jsMask = true>
		<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td width="60%" valign="top">
					<cfif isDefined("Url.QPPid") and not isDefined("form.QPPid")>
					  <cfset form.QPPid = Url.QPPid>
					</cfif>		
					<cfif isdefined("url.Filtro_Cod") and len(trim(url.Filtro_Cod))>
						<cfset form.Filtro_Cod = url.Filtro_Cod>
					</cfif>					
					<cfif isdefined("url.Filtro_Nombre") and len(trim(url.Filtro_Nombre))>
						<cfset form.Filtro_Nombre = url.Filtro_Nombre>
					</cfif>

					<cfif isdefined("url.estado") and len(trim(url.estado))>
						<cfset form.estado = url.estado>
					</cfif>

				<cfif isdefined("url._")>
					<cf_navegacion name = "Filtro_Cod" default = "">
					<cf_navegacion name = "Filtro_Nombre" default = "">
					<cf_navegacion name = "estado" default = "">
				<cfelse>
					<cf_navegacion name = "Filtro_Cod" default = "" session="">
					<cf_navegacion name = "Filtro_Nombre" default = "" session="">
					<cf_navegacion name = "estado" default = "" session="">
				</cfif>		
							
				<cfquery name="rsLista" datasource="#session.dsn#">
					select 
					  case a.QPPestado when '1' then 'Vigente' when '0' then 'No Vigente' else '' end as state,
					  a.QPPid,
					  a.QPPnombre,
					  oo.Odescripcion as Oficina,
					  a.QPPcodigo,
					  a.QPPtelefono,
					  case when a.QPPestado = '0' then 'checked' end as Chequear,
					  a.Ecodigo,
					  a.Ocodigo,
					  a.BMFecha,
					  a.QPPdirreccion,
					  a.BMUsucodigo
					from QPPromotor a
						inner join Oficinas oo
						on oo.Ecodigo = a.Ecodigo
						and oo.Ocodigo = a.Ocodigo
					where a.Ecodigo = #session.Ecodigo# 
					<cfif isdefined('form.Filtro_Cod')and len(trim(form.Filtro_Cod)) >
						and upper(a.QPPcodigo) like upper('%#form.Filtro_Cod#%')
					</cfif>	
					<cfif isdefined('form.Filtro_Nombre')and len(trim(form.Filtro_Nombre)) >
						and upper(a.QPPnombre) like upper('%#form.Filtro_Nombre#%')
					</cfif>	
					
					<cfif isdefined('form.estado')and len(trim(form.estado))>
						and upper(a.QPPestado) like upper('%#form.estado#%')
					</cfif>	
				</cfquery>	
				
			<cfoutput>
				<form action="QPassPromotor_SQL.cfm" name="form2" method="post">
					<table width="100%"  border="0" cellspacing="0" cellpadding="0" style="margin:0px;">
						<tr>
							<td class="titulolistas"><strong>C&oacute;digo</strong></td>
							<td class="titulolistas" ><strong>Nombre</strong></td>
							<td class="titulolistas" colspan="3"><strong>Estado</strong></td>
						</tr>
						<tr>
							<td class="titulolistas"><input type="text" name="Filtro_Cod"  tabindex="1" value="<cfif isdefined('form.Filtro_Cod')>#form.Filtro_Cod#</cfif>"></td>
							<td class="titulolistas"><input type="text" name="Filtro_Nombre"  tabindex="1" value="<cfif isdefined('form.Filtro_Nombre')>#form.Filtro_Nombre#</cfif>"></td>
							<td class="titulolistas">
								<select name="estado" tabindex="1" value="<cfif isdefined('form.estado')>#form.estado#</cfif>">
									<option value="">--Todos--</option>
									<option value="1"<cfif isdefined ('form.estado') and form.estado EQ "1"> selected</cfif>>Activo</option>
									<option value="0"<cfif isdefined ('form.estado') and form.estado EQ "0"> selected</cfif>>Inactivo</option>
								</select>
							</td>
							<td class="titulolistas"><input name="btnFiltrar" type="submit" id="btnFiltrar" value="Filtrar" tabindex="1" onclick="funcFiltrar();" /></td>
						</tr>
						<tr><td colspan="4"><hr></td></tr>
					</table> 
					<fieldset><legend>Lista de Promotores</legend>
					</form>	
				</cfoutput>
					<cfif isdefined('form.Filtro_Cod')and len(trim(form.Filtro_Cod)) or isdefined('form.Filtro_Nombre')and len(trim(form.Filtro_Nombre)) or isdefined('form.estado')and len(trim(form.estado)) >
						<cfset LvarDireccion = 'QPassPromotor.cfm'>
					<cfelse>
						<cfset LvarDireccion = 'QPassPromotor.cfm?_'>
					</cfif>
	
				<cfinvoke
					component="sif.Componentes.pListas"
					method="pListaQuery"
					returnvariable="rsLista"
					query="#rsLista#"
					desplegar="QPPcodigo,QPPnombre, Oficina, state"
					etiquetas="Código,Promotor, Sucursal,Estado"
					formatos="S,S,S,S"
					align="left,left,left,left"
					ajustar="S"
					irA="#LvarDireccion#"
					keys="QPPid"
					maxrows="30"
					pageindex="3"
					navegacion="#navegacion#" 				 
					form_method="post"
					formname= "form3"
					usaAJAX = "no"
					lineaazul = "chequear neq ''"
					/>
			</td>
			<td width="5%">&nbsp;</td>
			<td width="55%" valign="top">
				<cfinclude template="QPassPromotor_form.cfm"> 
			</td>			
		</tr>
	</table>
	<br>
	<cf_web_portlet_end>
<cf_templatefooter>

<script language="JavaScript" type="text/javascript">
	function funcFiltrar(){
			document.form2.action='QPassPromotor.cfm';
			document.form2.submit;
	}
	var oQPPtelefono = new Mask("####-####", "string");
	oQPPtelefono.attach(document.form1.QPPtelefono, oQPPtelefono, "string");
</script>
