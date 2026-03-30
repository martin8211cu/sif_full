
<cfparam name="form.pagenum_lista" default="1">
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>

<cfif isdefined("form.DGDid")>
	<cfset form.DGDid = '' >
</cfif>

<cfif isdefined("url.filtro_DGDcodigo")	and not isdefined("form.filtro_DGDcodigo")>
	<cfset form.filtro_DGDcodigo = url.filtro_DGDcodigo >
</cfif>
<cfif isdefined("url.filtro_DGDdescripcion")	and not isdefined("form.filtro_DGDdescripcion")>
	<cfset form.filtro_DGDdescripcion = url.filtro_DGDdescripcion >
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
					document.lista.DGDID.value='';
					document.lista.action="divisiones.cfm";
				}

				function filtrarlista(){
					document.lista.action="divisiones-lista.cfm";
					return true;
				}

				function funcFiltrar(){
					document.lista.action="divisiones-lista.cfm";
					return true;
				}
				//-->
			</script>
			
<cfset navegacion = '' >
<cfif isdefined("form.filtro_DGDcodigo") and len(trim(form.filtro_DGDcodigo)) >
	<cfset navegacion = navegacion & '&filtro_DGDcodigo=#form.filtro_DGDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGDdescripcion")  and len(trim(form.filtro_DGDdescripcion)) >
	<cfset navegacion = navegacion & '&filtro_DGDdescripcion=#form.filtro_DGDdescripcion#' >	
</cfif>

<form style="margin:0" action="divisiones.cfm" method="post" name="lista" id="lista" >
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
						name="filtro_DGDcodigo" value="<cfif isdefined("form.filtro_DGDcodigo")>#trim(form.filtro_DGDcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle" width="1%"><strong>Descripci&oacute;n:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="80" maxlength="80" onfocus="this.select()" 
							onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
							name="filtro_DGDdescripcion" value="<cfif isdefined("form.filtro_DGDdescripcion")>#trim(form.filtro_DGDdescripcion)#</cfif>">
					</td>
					<td align="center">
						<input type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcFiltrar) return funcFiltrar();">
					</td>	

					<td align="center">
						<input type="submit" class="btnNuevo" name="btnNuevo" value="Nuevo" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcNuevo) return funcNuevo();">
						<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#">
					</td>	
				</tr>	

			</table>
			</cfoutput>
		</td>				
	</tr>	
	
	<tr><td>&nbsp;</td></tr>

	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.DGDid, a.DGDcodigo, a.DGDdescripcion
		from DGDivisiones a	
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		<cfif isdefined("form.filtro_DGDcodigo") and len(trim(form.filtro_DGDcodigo))>
			and upper(a.DGDcodigo) like '%#ucase(trim(form.filtro_DGDcodigo))#%'
		</cfif>
		<cfif isdefined("form.filtro_DGDdescripcion") and len(trim(form.filtro_DGDdescripcion))>
			and upper(a.DGDdescripcion) like '%#ucase(trim(form.filtro_DGDdescripcion))#%'
		</cfif>
		order by a.DGDcodigo, a.DGDdescripcion					
	</cfquery>

	<tr>
		<td>
			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="DGDcodigo, DGDdescripcion"
			etiquetas="C&oacute;digo, Descripci&oacute;n"
			formatos="S,S"
			align="left, left"
			ira="divisiones.cfm"
			nuevo="divisiones.cfm"
			showemptylistmsg="true"
			keys="DGDid"
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