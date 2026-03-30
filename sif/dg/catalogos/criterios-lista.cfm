
<cfparam name="form.pagenum_lista" default="1">
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>

<cfif isdefined("form.DGCDid")>
	<cfset form.DGCDid = '' >
</cfif>

<cfif isdefined("url.filtro_DGCDcodigo")	and not isdefined("form.filtro_DGCDcodigo")>
	<cfset form.filtro_DGCDcodigo = url.filtro_DGCDcodigo >
</cfif>
<cfif isdefined("url.filtro_DGCDdescripcion")	and not isdefined("form.filtro_DGCDdescripcion")>
	<cfset form.filtro_DGCDdescripcion = url.filtro_DGCDdescripcion >
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
					document.lista.DGCDID.value='';
					document.lista.action="criterios.cfm";
				}

				function filtrarlista(){
					document.lista.action="criterios-lista.cfm";
					return true;
				}

				function funcFiltrar(){
					document.lista.action="criterios-lista.cfm";
					return true;
				}
				//-->
			</script>
			
<cfset navegacion = '' >
<cfif isdefined("form.filtro_DGCDcodigo") and len(trim(form.filtro_DGCDcodigo)) >
	<cfset navegacion = navegacion & '&filtro_DGCDcodigo=#form.filtro_DGCDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGCDdescripcion")  and len(trim(form.filtro_DGCDdescripcion)) >
	<cfset navegacion = navegacion & '&filtro_DGCDdescripcion=#form.filtro_DGCDdescripcion#' >	
</cfif>

<form style="margin:0" action="criterios.cfm" method="post" name="lista" id="lista" >
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
						name="filtro_DGCDcodigo" value="<cfif isdefined("form.filtro_DGCDcodigo")>#trim(form.filtro_DGCDcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle" width="1%"><strong>Descripci&oacute;n:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="80" maxlength="80" onfocus="this.select()" 
							onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
							name="filtro_DGCDdescripcion" value="<cfif isdefined("form.filtro_DGCDdescripcion")>#trim(form.filtro_DGCDdescripcion)#</cfif>">
					</td>
					<td align="center">
						<input type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcFiltrar) return funcFiltrar();">
					</td>	

					<td align="center">
						<input type="submit" class="btnNuevo" name="btnNuevo" value="Nuevo" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcNuevo) return funcNuevo();">
					</td>	
				</tr>	

			</table>
			</cfoutput>
		</td>				
	</tr>	
	
	<tr><td>&nbsp;</td></tr>

	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.DGCDid, a.DGCDcodigo, a.DGCDdescripcion
		from DGCriteriosDistribucion a	
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		<cfif isdefined("form.filtro_DGCDcodigo") and len(trim(form.filtro_DGCDcodigo))>
			and upper(a.DGCDcodigo) like '%#ucase(trim(form.filtro_DGCDcodigo))#%'
		</cfif>
		<cfif isdefined("form.filtro_DGCDdescripcion") and len(trim(form.filtro_DGCDdescripcion))>
			and upper(a.DGCDdescripcion) like '%#ucase(trim(form.filtro_DGCDdescripcion))#%'
		</cfif>
		order by a.DGCDcodigo, a.DGCDdescripcion					
	</cfquery>

	<tr>
		<td>
			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="DGCDcodigo, DGCDdescripcion"
			etiquetas="C&oacute;digo, Descripci&oacute;n"
			formatos="S,S"
			align="left, left"
			ira="criterios.cfm"
			nuevo="criterios.cfm"
			showemptylistmsg="true"
			keys="DGCDid"
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