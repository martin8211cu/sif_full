
<cfparam name="form.pagenum_lista" default="1">
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>

<cfif isdefined("form.DGAid")>
	<cfset form.DGAid = '' >
</cfif>

<cfif isdefined("url.filtro_DGAcodigo")	and not isdefined("form.filtro_DGAcodigo")>
	<cfset form.filtro_DGAcodigo = url.filtro_DGAcodigo >
</cfif>
<cfif isdefined("url.filtro_DGAdescripcion")	and not isdefined("form.filtro_DGAdescripcion")>
	<cfset form.filtro_DGAdescripcion = url.filtro_DGAdescripcion >
</cfif>

<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">

			<script language="JavaScript1.2" type="text/javascript">
				<!--//
				function funcNuevo(){
					document.lista.DGAID.value='';
					document.lista.action="actividades-tabs.cfm";
				}

				function filtrarlista(){
					document.lista.action="actividades-lista.cfm";
					return true;
				}

				function funcFiltrar(){
					document.lista.action="actividades-lista.cfm";
					return true;
				}
				//-->
			</script>
			
<cfset navegacion = '' >
<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo)) >
	<cfset navegacion = navegacion & '&filtro_DGAcodigo=#form.filtro_DGAcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGAdescripcion")  and len(trim(form.filtro_DGAdescripcion)) >
	<cfset navegacion = navegacion & '&filtro_DGAdescripcion=#form.filtro_DGAdescripcion#' >	
</cfif>

<form style="margin:0" action="actividades-tabs.cfm" method="post" name="lista" id="lista" >
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfoutput>
			<table align="center" border="0" cellspacing="0" cellpadding="2" width="100%" class="areaFiltro">
				<tr>
					<td align="left" valign="middle" width="1%"><strong>C&oacute;digo:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_DGAcodigo" value="<cfif isdefined("form.filtro_DGAcodigo")>#trim(form.filtro_DGAcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle" width="1%"><strong>Descripci&oacute;n:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="80" maxlength="80" onfocus="this.select()" 
							onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
							name="filtro_DGAdescripcion" value="<cfif isdefined("form.filtro_DGAdescripcion")>#trim(form.filtro_DGAdescripcion)#</cfif>">
					</td>
					<td align="center">
						<input type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcFiltrar) return funcFiltrar();">
					</td>	
					<td align="center">
						<input type="submit" class="btnNuevo" name="btnNuevo" value="Nuevo" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcNuevo) return funcNuevo();">
						<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#" >
					</td>	
				</tr>	

			</table>
			</cfoutput>
		</td>				
	</tr>	
	
	<tr><td>&nbsp;</td></tr>

	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.DGAid, a.DGAcodigo, a.DGAdescripcion
		from DGActividades a	
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
			and upper(a.DGAcodigo) like '%#ucase(trim(form.filtro_DGAcodigo))#%'
		</cfif>
		<cfif isdefined("form.filtro_DGAdescripcion") and len(trim(form.filtro_DGAdescripcion))>
			and upper(a.DGAdescripcion) like '%#ucase(trim(form.filtro_DGAdescripcion))#%'
		</cfif>
		order by a.DGAcodigo, a.DGAdescripcion					
	</cfquery>

	<tr>
		<td>
			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="DGAcodigo, DGAdescripcion"
			etiquetas="C&oacute;digo, Descripci&oacute;n"
			formatos="S,S"
			align="left, left"
			ira="actividades-tabs.cfm"
			nuevo="actividades-tabs.cfm"
			showemptylistmsg="true"
			keys="DGAid"
			botones="Nuevo"
			maxrows="20"
			incluyeForm="false"
			navegacion="#navegacion#" />
		</td>
	</tr>												
</table>	
</form>			
	<cf_web_portlet_end>
<cf_templatefooter>