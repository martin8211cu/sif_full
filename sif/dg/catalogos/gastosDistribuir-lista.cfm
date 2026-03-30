
<cfparam name="form.pagenum_lista" default="1">
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>

<cfif isdefined("form.DGGDid")>
	<cfset form.DGGDid = '' >
</cfif>

<cfif isdefined("url.filtro_DGGDcodigo")	and not isdefined("form.filtro_DGGDcodigo")>
	<cfset form.filtro_DGGDcodigo = url.filtro_DGGDcodigo >
</cfif>
<cfif isdefined("url.filtro_DGGDdescripcion")	and not isdefined("form.filtro_DGGDdescripcion")>
	<cfset form.filtro_DGGDdescripcion = url.filtro_DGGDdescripcion >
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="Gastos por Distribuir">

			<script language="JavaScript1.2" type="text/javascript">
				<!--//
				function funcNuevo(){
					document.lista.DGGDID.value='';
					document.lista.action="gastosDistribuir-tabs.cfm";
				}

				function filtrarlista(){
					document.lista.action="gastosDistribuir-lista.cfm";
					return true;
				}

				function funcFiltrar(){
					document.lista.action="gastosDistribuir-lista.cfm";
					return true;
				}
				//-->
			</script>
			
<cfset navegacion = '' >
<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo)) >
	<cfset navegacion = navegacion & '&filtro_DGGDcodigo=#form.filtro_DGGDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGGDdescripcion")  and len(trim(form.filtro_DGGDdescripcion)) >
	<cfset navegacion = navegacion & '&filtro_DGGDdescripcion=#form.filtro_DGGDdescripcion#' >	
</cfif>

<form style="margin:0" action="gastosDistribuir.cfm" method="post" name="lista" id="lista" >
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfoutput>
			<table align="center" border="0" cellspacing="0" cellpadding="2" width="100%" class="areaFiltro">
				<tr>
					<td align="left" valign="middle" width="1%" nowrap="nowrap"><strong>C&oacute;digo:</strong></td>
					<td align="left" valign="middle" width="1%">
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_DGGDcodigo" value="<cfif isdefined("form.filtro_DGGDcodigo")>#trim(form.filtro_DGGDcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle">
						<input  tabindex="1" type="text" size="40" maxlength="80" onfocus="this.select()" 
							onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
							name="filtro_DGGDdescripcion" value="<cfif isdefined("form.filtro_DGGDdescripcion")>#trim(form.filtro_DGGDdescripcion)#</cfif>">
					</td>
					
					<td align="center" rowspan="2" valign="middle">
						<input  tabindex="2" type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcFiltrar) return funcFiltrar();">
						<input  tabindex="2" type="submit" class="btnNuevo" name="btnNuevo" value="Nuevo" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcNuevo) return funcNuevo();">
					</td>	
					

				</tr>	

				<!---
				<tr>
					<td align="left" valign="middle" width="1%"><strong>Criterio:</strong></td>
					<td align="left" valign="middle" width="1%">
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_DGCDcodigo" value="<cfif isdefined("form.filtro_DGCDcodigo")>#trim(form.filtro_DGCDcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle">
						<input  tabindex="1" type="text" size="40" maxlength="80" onfocus="this.select()" 
							onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
							name="filtro_DGCDdescripcion" value="<cfif isdefined("form.filtro_DGCDdescripcion")>#trim(form.filtro_DGCDdescripcion)#</cfif>">
					</td>

				</tr>
				--->	

			</table>
			</cfoutput>
		</td>				
	</tr>	
	
	<tr><td>&nbsp;</td></tr>

	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.DGGDid, a.DGGDcodigo, a.DGGDdescripcion
		from DGGastosDistribuir a	
		
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo))>
			and upper(a.DGGDcodigo) like '%#ucase(trim(form.filtro_DGGDcodigo))#%'
		</cfif>
		<cfif isdefined("form.filtro_DGGDdescripcion") and len(trim(form.filtro_DGGDdescripcion))>
			and upper(a.DGGDdescripcion) like '%#ucase(trim(form.filtro_DGGDdescripcion))#%'
		</cfif>
		order by a.DGGDcodigo, a.DGGDdescripcion					
	</cfquery>

	<tr>
		<td>
			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="DGGDcodigo, DGGDdescripcion"
			etiquetas="C&oacute;digo, Descripci&oacute;n"
			formatos="S,S"
			align="left, left"
			ira="gastosDistribuir-tabs.cfm"
			nuevo="gastosDistribuir-tabs.cfm"
			showemptylistmsg="true"
			keys="DGGDid"
			botones="Nuevo"
			maxrows="15"
			incluyeForm="false"
			navegacion="#navegacion#" />
		</td>
	</tr>												
</table>	
</form>			
		<cf_web_portlet_end>
	<cf_templatefooter>