
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
<cfif isdefined("url.filtro_DGGDcodigo")	and not isdefined("form.filtro_DGGDcodigo")>
	<cfset form.filtro_DGGDcodigo = url.filtro_DGGDcodigo >
</cfif>
<cfif isdefined("url.filtro_DGGDcodigo")	and not isdefined("form.filtro_DGGDcodigo")>
	<cfset form.filtro_DGGDcodigo = url.filtro_DGGDcodigo >
</cfif>



<cfset CurrentPage=GetFileFromPath(GetTemplatePath())>
<cfsavecontent variable="pNavegacion">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
</cfsavecontent>
<cf_templateheader title="#nav__SPdescripcion#">
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>"><cfoutput>#pNavegacion#</cfoutput>

			<script language="JavaScript1.2" type="text/javascript">
				<!--//
				function funcNuevo(){
					document.lista.DGAID.value='';
					document.lista.DGGDID.value='';
					document.lista.action="gastosActividad.cfm";
				}

				function filtrarlista(){
					document.lista.action="gastosActividad-lista.cfm";
					return true;
				}

				function funcFiltrar(){
					document.lista.action="gastosActividad-lista.cfm";
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

<form style="margin:0" action="gastosActividad.cfm" method="post" name="lista" id="lista" >
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfoutput>
			<table align="center" border="0" cellspacing="0" cellpadding="2" width="100%" class="areaFiltro">
				<tr>
					<td align="left" valign="middle" width="1%"><strong>Actividad:</strong></td>
					<td align="left" valign="middle" width="1%">
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_DGAcodigo" value="<cfif isdefined("form.filtro_DGAcodigo")>#trim(form.filtro_DGAcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle">
						<input  tabindex="1" type="text" size="40" maxlength="80" onfocus="this.select()" 
							onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
							name="filtro_DGAdescripcion" value="<cfif isdefined("form.filtro_DGAdescripcion")>#trim(form.filtro_DGAdescripcion)#</cfif>">
					</td>

					<td align="center" rowspan="2" valign="middle">
						<input tabindex="2" type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcFiltrar) return funcFiltrar();">
						<input tabindex="2" type="submit" class="btnNuevo" name="btnNuevo" value="Nuevo" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcNuevo) return funcNuevo();">
					</td>	

				</tr>	

				<tr>
					<td align="left" valign="middle" width="1%" nowrap="nowrap"><strong>Gastos por Distribuir:</strong></td>
					<td align="left" valign="middle" width="1%">
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_DGGDcodigo" value="<cfif isdefined("form.filtro_DGGDcodigo")>#trim(form.filtro_DGGDcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle">
						<input tabindex="1" type="text" size="40" maxlength="80" onfocus="this.select()" 
							onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
							name="filtro_DGGDdescripcion" value="<cfif isdefined("form.filtro_DGGDdescripcion")>#trim(form.filtro_DGGDdescripcion)#</cfif>">
					</td>
				</tr>	

			</table>
			</cfoutput>
		</td>				
	</tr>	
	
	<tr><td>&nbsp;</td></tr>

	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.DGAid, a.DGGDid, b.DGAcodigo, b.DGAdescripcion, c.DGGDcodigo, c.DGGDdescripcion, a.ValorFactor 
		from DGGastosActividad a
		
		inner join DGActividades b
		on b.DGAid=a.DGAid
		<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
			and upper(b.DGAcodigo) like '%#ucase(trim(form.filtro_DGAcodigo))#%'
		</cfif>
		<cfif isdefined("form.filtro_DGAdescripcion") and len(trim(form.filtro_DGAdescripcion))>
			and upper(b.DGAdescripcion) like '%#ucase(trim(form.filtro_DGAdescripcion))#%'
		</cfif>
		
		inner join DGGastosDistribuir c
		on  c.DGGDid = a.DGGDid
		<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo))>
			and upper(c.DGGDcodigo) like '%#ucase(trim(form.filtro_DGGDcodigo))#%'
		</cfif>
		<cfif isdefined("form.filtro_DGGDdescripcion") and len(trim(form.filtro_DGGDdescripcion))>
			and upper(c.DGGDdescripcion) like '%#ucase(trim(form.filtro_DGGDdescripcion))#%'
		</cfif>
		
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		order by b.DGAcodigo, b.DGAdescripcion, c.DGGDcodigo, c.DGGDdescripcion
	</cfquery>

	<tr>
		<td>
			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="DGAcodigo, DGAdescripcion, DGGDcodigo, DGGDdescripcion, ValorFactor "
			etiquetas="Actividad, Descripci&oacute;n, Gasto por Distribuir, Descripci&oacute;n, Factor"
			formatos="S,S,S,S,M"
			align="left, left,left,left,right"
			ira="gastosActividad.cfm"
			nuevo="gastosActividad.cfm"
			showemptylistmsg="true"
			keys="DGAid,DGGDid"
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