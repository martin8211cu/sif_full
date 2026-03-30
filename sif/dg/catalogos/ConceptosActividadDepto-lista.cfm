
<cfparam name="form.pagenum_lista" default="1">
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>

<cfif isdefined("url.filtro_DGAcodigo")	and not isdefined("form.filtro_DGAcodigo")>
	<cfset form.filtro_DGAcodigo = url.filtro_DGAcodigo >
</cfif>
<cfif isdefined("url.filtro_DGCcodigo")	and not isdefined("form.filtro_DGCcodigo")>
	<cfset form.filtro_DGCcodigo = url.filtro_DGCcodigo >
</cfif>
<cfif isdefined("url.filtro_PCDvalor")	and not isdefined("form.filtro_PCDvalor")>
	<cfset form.filtro_PCDvalor = url.filtro_PCDvalor >
</cfif>

<!---
<cfif isdefined("url.filtro_DGdescripcion")	and not isdefined("form.filtro_DGdescripcion")>
	<cfset form.filtro_DGdescripcion = url.filtro_DGdescripcion >
</cfif>
--->

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
					document.lista.EMPRESA.value='';
					document.lista.PCDCATID.value='';
					document.lista.action="ConceptosActividadDepto.cfm";
				}

				function filtrarlista(){
					document.lista.action="ConceptosActividadDepto-lista.cfm";
					return true;
				}

				function funcFiltrar(){
					document.lista.action="ConceptosActividadDepto-lista.cfm";
					return true;
				}
				//-->
			</script>
			
<cfset navegacion = '' >
<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo)) >
	<cfset navegacion = navegacion & '&filtro_DGAcodigo=#form.filtro_DGAcodigo#' >
</cfif>
<cfif isdefined("form.filtro_DGCcodigo") and len(trim(form.filtro_DGCcodigo)) >
	<cfset navegacion = navegacion & '&filtro_DGCcodigo=#form.filtro_DGCcodigo#' >
</cfif>
<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor)) >
	<cfset navegacion = navegacion & '&filtro_PCDvalor=#form.filtro_PCDvalor#' >
</cfif>
<!---
<cfif isdefined("form.filtro_DGAdescripcion")  and len(trim(form.filtro_DGAdescripcion)) >
	<cfset navegacion = navegacion & '&filtro_DGAdescripcion=#form.filtro_DGAdescripcion#' >	
</cfif>
--->

<form style="margin:0" action="DeptosGastosDistribuir.cfm" method="post" name="lista" id="lista" >
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfoutput>
			<table align="center" border="0" cellspacing="0" cellpadding="2" width="100%" class="areaFiltro">
				<tr>
					<td align="left" valign="middle" width="1%" nowrap="nowrap"><strong>Actividad:</strong></td>
					<td align="left" valign="middle">
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_DGAcodigo" value="<cfif isdefined("form.filtro_DGAcodigo")>#trim(form.filtro_DGAcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle" width="1%" nowrap="nowrap"><strong>Concepto:</strong></td>
					<td align="left" valign="middle">
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_DGCcodigo" value="<cfif isdefined("form.filtro_DGCcodigo")>#trim(form.filtro_DGCcodigo)#</cfif>" >
					</td>

					<td align="left" valign="middle" width="1%" nowrap="nowrap"><strong>Departamento:</strong></td>
					<td align="left" valign="middle">
						<input tabindex="1" type="text" size="15" maxlength="20" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_PCDValor" value="<cfif isdefined("form.filtro_PCDValor")>#trim(form.filtro_PCDValor)#</cfif>" >
					</td>

					<!---
					<td align="left" valign="middle" width="1%"><strong>Descripci&oacute;n:</strong></td>
					<td align="left" valign="middle">
						<input  tabindex="1" type="text" size="40" maxlength="80" onfocus="this.select()" 
							onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
							name="filtro_DGAdescripcion" value="<cfif isdefined("form.filtro_DGAdescripcion")>#trim(form.filtro_DGAdescripcion)#</cfif>">
					</td>
					--->

					<td align="center" rowspan="2" valign="middle">
						<input tabindex="2" type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcFiltrar) return funcFiltrar();">
						<input tabindex="2" type="submit" class="btnNuevo" name="btnNuevo" value="Nuevo" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcNuevo) return funcNuevo();">
						<input type="hidden" name="pageNum_lista" value="#form.pageNum_lista#" >
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
			  a.PCEcatid,
			  rtrim(b.DGAcodigo) #_Cat#' - '#_Cat# b.DGAdescripcion as actividad, 
			  a.PCDcatid, 
			  rtrim(c.PCDvalor) #_Cat#' - '#_Cat# c.PCDdescripcion as valor, 
			  a.Ecodigo,
			  a.Ecodigo as Empresa,
			  e.Edescripcion,
			  a.DGCid,
			  f.DGCcodigo #_Cat#' - '#_Cat# f.DGdescripcion as concepto
		
		from DGConceptosActividadDepto a
		
		inner join DGActividades b
		on b.DGAid=a.DGAid
		and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >

		<cfif isdefined("form.filtro_DGAcodigo") and len(trim(form.filtro_DGAcodigo))>
			and upper(b.DGAcodigo) like '%#ucase(trim(form.filtro_DGAcodigo))#%'
		</cfif>
		
		inner join DGConceptosER f
		on f.DGCid=a.DGCid
		and f.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		<cfif isdefined("form.filtro_DGCcodigo") and len(trim(form.filtro_DGCcodigo))>
			and upper(f.DGCcodigo) like '%#ucase(trim(form.filtro_DGCcodigo))#%'
		</cfif>
		
		inner join PCDCatalogo c
		on c.PCDcatid=a.PCDcatid
		<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor))>
			and upper(c.PCDvalor) like '%#ucase(trim(form.filtro_PCDvalor))#%'
		</cfif>
		
		inner join Empresas e
		on e.Ecodigo=a.Ecodigo
		and e.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">

		order by e.Edescripcion, b.DGAcodigo, f.DGCcodigo, c.PCDvalor
	</cfquery>

	<tr>
		<td>
			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="actividad, concepto, valor"
			etiquetas="Actividad, Concepto, Departamento"
			formatos="S,S,S"
			align="left,left,left"
			ira="ConceptosActividadDepto.cfm"
			nuevo="ConceptosActividadDepto.cfm"
			showemptylistmsg="true"
			botones="Nuevo"
			maxrows="20"
			incluyeForm="false"
			navegacion="#navegacion#"
			Cortes="Edescripcion" />
		</td>
	</tr>												
</table>	
</form>			
		<cf_web_portlet_end>
	<cf_templatefooter>