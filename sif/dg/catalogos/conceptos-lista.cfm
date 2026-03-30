
<cfparam name="form.pagenum_lista" default="1">
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>

<cfif isdefined("form.DGCid")>
	<cfset form.DGCid = '' >
</cfif>

<cfif isdefined("url.filtro_DGCcodigo")	and not isdefined("form.filtro_DGCcodigo")>
	<cfset form.filtro_DGCcodigo = url.filtro_DGCcodigo >
</cfif>
<cfif isdefined("url.filtro_DGdescripcion")	and not isdefined("form.filtro_DGdescripcion")>
	<cfset form.filtro_DGdescripcion = url.filtro_DGdescripcion >
</cfif>
<cfif isdefined("url.filtro_DGtipo")	and not isdefined("form.filtro_DGtipo")>
	<cfset form.filtro_DGtipo = url.filtro_DGtipo >
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
					document.lista.DGCID.value='';
					document.lista.action="conceptos-tabs.cfm";
				}

				function filtrarlista(){
					document.lista.action="conceptos-lista.cfm";
					return true;
				}

				function funcFiltrar(){
					document.lista.action="conceptos-lista.cfm";
					return true;
				}
				//-->
			</script>
			
<cfset navegacion = '' >
<cfif isdefined("form.filtro_DGCcodigo") and len(trim(form.filtro_DGCcodigo)) >
	<cfset navegacion = navegacion & '&filtro_DGCcodigo=#form.filtro_DGCcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGdescripcion")  and len(trim(form.filtro_DGdescripcion)) >
	<cfset navegacion = navegacion & '&filtro_DGdescripcion=#form.filtro_DGdescripcion#' >	
</cfif>
<cfif isdefined("form.filtro_DGtipo")  and len(trim(form.filtro_DGtipo)) >
	<cfset navegacion = navegacion & '&filtro_DGtipo=#form.filtro_DGtipo#' >	
</cfif>

<form style="margin:0" action="conceptos.cfm" method="post" name="lista" id="lista" >
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
						name="filtro_DGCcodigo" value="<cfif isdefined("form.filtro_DGCcodigo")>#trim(form.filtro_DGCcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle" width="1%"><strong>Descripci&oacute;n:</strong></td>
					<td align="left" valign="middle">
						<input type="text" size="50" maxlength="80" onfocus="this.select()" 
							onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
							name="filtro_DGdescripcion" value="<cfif isdefined("form.filtro_DGdescripcion")>#trim(form.filtro_DGdescripcion)#</cfif>">
					</td>
					
					<td align="left" valign="middle" width="1%"><strong>Tipo:</strong></td>
					<td align="left" valign="middle">
						<select name="filtro_DGtipo">
							<option value="I" <cfif isdefined("form.filtro_DGtipo") and form.filtro_DGtipo eq 'I'>selected</cfif> >Ingreso</option>
							<option value="G" <cfif isdefined("form.filtro_DGtipo") and form.filtro_DGtipo eq 'G'>selected</cfif>>Gasto</option>
						</select>
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
		select a.DGCid, 
			   a.DGCcodigo, 
			   a.DGdescripcion,
			   case a.DGtipo when 'I' then 'Ingreso' else 'Gasto' end as DGtipo,
			   case a.Comportamiento when 'O' then 'Objeto de Gasto' else 'Producto' end as Comportamiento
		from DGConceptosER a	
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		<cfif isdefined("form.filtro_DGCcodigo") and len(trim(form.filtro_DGCcodigo))>
			and upper(a.DGCcodigo) like '%#ucase(trim(form.filtro_DGCcodigo))#%'
		</cfif>
		<cfif isdefined("form.filtro_DGdescripcion") and len(trim(form.filtro_DGdescripcion))>
			and upper(a.DGdescripcion) like '%#ucase(trim(form.filtro_DGdescripcion))#%'
		</cfif>
		<cfif isdefined("form.filtro_DGtipo") and len(trim(form.filtro_DGtipo))>
			and a.DGtipo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.filtro_DGtipo#">
		</cfif>
		
		order by a.DGCcodigo, a.DGdescripcion					
	</cfquery>

	<tr>
		<td>
			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="DGCcodigo, DGdescripcion, DGtipo, Comportamiento"
			etiquetas="C&oacute;digo, Descripci&oacute;n, Tipo, Comportamiento"
			formatos="S,S,S,S"
			align="left, left, left, left"
			ira="conceptos-tabs.cfm"
			nuevo="conceptos-tabs.cfm"
			showemptylistmsg="true"
			keys="DGCid"
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