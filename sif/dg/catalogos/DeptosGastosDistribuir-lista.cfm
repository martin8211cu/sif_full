
<cfparam name="form.pagenum_lista" default="1">
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>

<cfif isdefined("url.filtro_DGGDcodigo")	and not isdefined("form.filtro_DGGDcodigo")>
	<cfset form.filtro_DGGDcodigo = url.filtro_DGGDcodigo >
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
					document.lista.DGGDID.value='';
					document.lista.EMPRESA.value='';
					document.lista.PCECATID.value='';
					document.lista.PCDCATID.value='';
					document.lista.action="DeptosGastosDistribuir.cfm";
				}

				function filtrarlista(){
					document.lista.action="DeptosGastosDistribuir-lista.cfm";
					return true;
				}

				function funcFiltrar(){
					document.lista.action="DeptosGastosDistribuir-lista.cfm";
					return true;
				}
				//-->
			</script>
			
<cfset navegacion = '' >
<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo)) >
	<cfset navegacion = navegacion & '&filtro_DGGDcodigo=#form.filtro_DGGDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_PCEcodigo") and len(trim(form.filtro_PCEcodigo)) >
	<cfset navegacion = navegacion & '&filtro_PCEcodigo=#form.filtro_PCEcodigo#' >
</cfif>
<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor)) >
	<cfset navegacion = navegacion & '&filtro_PCDvalor=#form.filtro_PCDvalor#' >
</cfif>
<!---
<cfif isdefined("form.filtro_DGGDdescripcion")  and len(trim(form.filtro_DGGDdescripcion)) >
	<cfset navegacion = navegacion & '&filtro_DGGDdescripcion=#form.filtro_DGGDdescripcion#' >	
</cfif>
--->

<form style="margin:0" action="DeptosGastosDistribuir.cfm" method="post" name="lista" id="lista" >
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfoutput>
			<table align="center" border="0" cellspacing="0" cellpadding="2" width="100%" class="areaFiltro">
				<tr>
					<td align="left" valign="middle" width="1%" nowrap="nowrap"><strong>Gasto:</strong></td>
					<td align="left" valign="middle">
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_DGGDcodigo" value="<cfif isdefined("form.filtro_DGGDcodigo")>#trim(form.filtro_DGGDcodigo)#</cfif>" >
					</td>
						
					<td align="left" valign="middle" width="1%" nowrap="nowrap"><strong>Cat&aacute;logo:</strong></td>
					<td align="left" valign="middle">
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_PCEcodigo" value="<cfif isdefined("form.filtro_PCEcodigo")>#trim(form.filtro_PCEcodigo)#</cfif>" >
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
							name="filtro_DGGDdescripcion" value="<cfif isdefined("form.filtro_DGGDdescripcion")>#trim(form.filtro_DGGDdescripcion)#</cfif>">
					</td>
					--->

					<td align="center" rowspan="2" valign="middle">
						<input tabindex="2" type="submit" class="btnFiltrar" name="btnFiltrar" value="Filtrar" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcFiltrar) return funcFiltrar();">
						<input tabindex="2" type="submit" class="btnNuevo" name="btnNuevo" value="Nuevo" onclick="javascript: this.form.pListaBtnSel.value = this.name; if (window.funcNuevo) return funcNuevo();">
					</td>	
				</tr>	

			</table>
			</cfoutput>
		</td>				
	</tr>	
	
	<tr><td>&nbsp;</td></tr>
	<cfinclude template="../../Utiles/sifConcat.cfm">
	<cfquery name="rsLista" datasource="#session.DSN#">
		select a.DGGDid, 
			  rtrim(b.DGGDcodigo)#_Cat#' - '#_Cat#b.DGGDdescripcion as gasto, 
			  a.PCDcatid, 
			  rtrim(c.PCDvalor) #_Cat#' - '#_Cat# c.PCDdescripcion as PCDdescripcion, 
			  a.PCEcatid,
			  a.Ecodigo as Empresa,
			  e.Edescripcion
		
		from DGDeptosGastosDistribuir a
		
		inner join DGGastosDistribuir b
		on b.DGGDid=a.DGGDid
		and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		<cfif isdefined("form.filtro_DGGDcodigo") and len(trim(form.filtro_DGGDcodigo))>
			and upper(b.DGGDcodigo) like '%#ucase(trim(form.filtro_DGGDcodigo))#%'
		</cfif>
		
		inner join PCDCatalogo c
		on c.PCDcatid=a.PCDcatid
		<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor))>
			and upper(c.PCDvalor) like '%#ucase(trim(form.filtro_PCDvalor))#%'
		</cfif>

		
		inner join Empresas e
		on e.Ecodigo=a.Ecodigo
		and e.cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >

		order by e.Edescripcion, b.DGGDcodigo, c.PCDvalor
	</cfquery>

	<tr>
		<td>
			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="gasto,PCDdescripcion"
			etiquetas="Gasto, Departamento"
			formatos="S,S"
			align="left,left"
			ira="DeptosGastosDistribuir.cfm"
			nuevo="DeptosGastosDistribuir.cfm"
			showemptylistmsg="true"
			botones="Nuevo"
			maxrows="15"
			incluyeForm="false"
			navegacion="#navegacion#"
			Cortes="Edescripcion" />
		</td>
	</tr>												
</table>	
</form>			
		<cf_web_portlet_end>
	<cf_templatefooter>