
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
<cfif isdefined("url.filtro_DGCcodigo")	and not isdefined("form.filtro_DGCcodigo")>
	<cfset form.filtro_DGCcodigo = url.filtro_DGCcodigo >
</cfif>
<cfif isdefined("url.filtro_DGdescripcion")	and not isdefined("form.filtro_DGdescripcion")>
	<cfset form.filtro_DGdescripcion = url.filtro_DGdescripcion >
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
					document.lista.DGCID.value='';
					document.lista.action="cuentasConceptoActividad.cfm";
				}

				function filtrarlista(){
					document.lista.action="cuentasConceptoActividad-lista.cfm";
					return true;
				}

				function funcFiltrar(){
					document.lista.action="cuentasConceptoActividad-lista.cfm";
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
<cfif isdefined("form.filtro_DGCcodigo") and len(trim(form.filtro_DGCcodigo)) >
	<cfset navegacion = navegacion & '&filtro_DGCcodigo=#form.filtro_DGCcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGdescripcion")  and len(trim(form.filtro_DGdescripcion)) >
	<cfset navegacion = navegacion & '&filtro_DGdescripcion=#form.filtro_DGdescripcion#' >	
</cfif>

<form style="margin:0" action="cuentasConceptoActividad.cfm" method="post" name="lista" id="lista" >
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
					<td align="left" valign="middle" width="1%" nowrap="nowrap"><strong>Concepto:</strong></td>
					<td align="left" valign="middle" width="1%" >
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_DGCcodigo" value="<cfif isdefined("form.filtro_DGCcodigo")>#trim(form.filtro_DGCcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle">
						<input tabindex="1" type="text" size="40" maxlength="80" onfocus="this.select()" 
							onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
							name="filtro_DGdescripcion" value="<cfif isdefined("form.filtro_DGdescripcion")>#trim(form.filtro_DGdescripcion)#</cfif>">
					</td>
				</tr>	

			</table>
			</cfoutput>
		</td>				
	</tr>	
	
	<tr><td>&nbsp;</td></tr>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.DGAid, 
			   a.DGCid, 
			   a.Ecodigo as Empresa, 
			   a.Cmayor, 
			   rtrim(a.Cmayor) #_Cat# ' - ' #_Cat# e.Cdescripcion as cuenta, 
			   rtrim(b.DGAcodigo)#_Cat#' - '#_Cat# b.DGAdescripcion as actividad, 
			   rtrim(c.DGCcodigo)#_Cat#' - '#_Cat# c.DGdescripcion as concepto, 
			   d.Edescripcion
		
		from DGCtasConceptoActividad a
		
		inner join DGActividades b
		on b.DGAid=a.DGAid
		<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
			and upper(b.DGAcodigo) like '%#ucase(trim(form.filtro_DGAcodigo))#%'
		</cfif>
		<cfif isdefined("form.filtro_DGAdescripcion") and len(trim(form.filtro_DGAdescripcion))>
			and upper(b.DGAdescripcion) like '%#ucase(trim(form.filtro_DGAdescripcion))#%'
		</cfif>
		
		inner join DGConceptosER c
		on  c.DGCid = a.DGCid
		<cfif isdefined("form.filtro_DGCcodigo") and len(trim(form.filtro_DGCcodigo))>
			and upper(c.DGCcodigo) like '%#ucase(trim(form.filtro_DGCcodigo))#%'
		</cfif>
		<cfif isdefined("form.filtro_DGdescripcion") and len(trim(form.filtro_DGdescripcion))>
			and upper(c.DGdescripcion) like '%#ucase(trim(form.filtro_DGdescripcion))#%'
		</cfif>
		
		inner join Empresas d
		on d.Ecodigo=a.Ecodigo
		and d.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		inner join CtasMayor e
		on e.Ecodigo=a.Ecodigo
		and e.Cmayor=a.Cmayor
		
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		order by d.Edescripcion, b.DGAcodigo, b.DGAdescripcion, c.DGCcodigo, c.DGdescripcion
	</cfquery>

	<tr>
		<td>
			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="actividad, concepto, cuenta"
			etiquetas="Actividad, Concepto, Cuenta Mayor"
			formatos="S,S,S"
			align="left,left,left"
			ira="cuentasConceptoActividad.cfm"
			nuevo="cuentasConceptoActividad.cfm"
			showemptylistmsg="true"
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