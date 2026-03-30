
<cfparam name="form.pagenum_lista" default="1">
<cfif isdefined("url.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>

<cfif isdefined("url.filtro_DGCDcodigo")	and not isdefined("form.filtro_DGCDcodigo")>
	<cfset form.filtro_DGCDcodigo = url.filtro_DGCDcodigo >
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
	<cfoutput>#pNavegacion#</cfoutput>
		<cf_web_portlet_start titulo="<cfoutput>#nav__SPdescripcion#</cfoutput>">

			<script language="JavaScript1.2" type="text/javascript">
				<!--//
				function funcNuevo(){
					document.lista.DGCDID.value='';
					document.lista.PCDCATID.value='';
					document.lista.action="criteriosDeptoE.cfm";
				}

				function filtrarlista(){
					document.lista.action="criteriosDeptoE-lista.cfm";
					return true;
				}

				function funcFiltrar(){
					document.lista.action="criteriosDeptoE-lista.cfm";
					return true;
				}
				//-->
			</script>
			
<cfset navegacion = '' >
<cfif isdefined("form.filtro_DGCDcodigo") and len(trim(form.filtro_DGCDcodigo)) >
	<cfset navegacion = navegacion & '&filtro_DGCDcodigo=#form.filtro_DGCDcodigo#' >
</cfif>
<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor)) >
	<cfset navegacion = navegacion & '&filtro_PCDvalor=#form.filtro_PCDvalor#' >
</cfif>
<!---
<cfif isdefined("form.filtro_DGCDdescripcion")  and len(trim(form.filtro_DGCDdescripcion)) >
	<cfset navegacion = navegacion & '&filtro_DGCDdescripcion=#form.filtro_DGCDdescripcion#' >	
</cfif>
--->

<form style="margin:0" action="criteriosDeptoE.cfm" method="post" name="lista" id="lista" >
<table width="100%" cellpadding="0" cellspacing="0">
	<tr>
		<td>
			<cfoutput>
			<table align="center" border="0" cellspacing="0" cellpadding="2" width="100%" class="areaFiltro">
				<tr>
					<td align="left" valign="middle" width="1%" nowrap="nowrap"><strong>Criterio:</strong></td>
					<td align="left" valign="middle">
						<input tabindex="1" type="text" size="15" maxlength="10" onfocus="this.select()" 
						onkeypress="javascript: if((event.which?event.which:event.keyCode)==13){ return  filtrarlista(); }"
						name="filtro_DGCDcodigo" value="<cfif isdefined("form.filtro_DGCDcodigo")>#trim(form.filtro_DGCDcodigo)#</cfif>" >
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
							name="filtro_DGCDdescripcion" value="<cfif isdefined("form.filtro_DGCDdescripcion")>#trim(form.filtro_DGCDdescripcion)#</cfif>">
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
		select a.PCEcatid,
			   a.PCDcatid,
			   rtrim(c.PCDvalor) #_Cat#' - '#_Cat# c.PCDdescripcion as PCDdescripcion, 
			   a.CEcodigo,
			   a.DGCDid,
			   rtrim(b.DGCDcodigo)#_Cat#' - '#_Cat#b.DGCDdescripcion as criterio,
			   a.Periodo,
			   a.Mes,
				( case a.Mes when 1 then 'Enero'
							 when 2 then 'Febrero'
							 when 3 then 'Marzo'
							 when 4 then 'Abril'
 							 when 5 then 'Mayo'
							 when 6 then 'Junio'
							 when 7 then 'Julio'
							 when 8 then 'Agosto'
							 when 9 then 'Setiembre'
							 when 10 then 'Octubre'
							 when 11 then 'Noviembre'
							 when 12 then 'Diciembre' end ) as DescMes

		from DGCriteriosDeptoE  a
		
		inner join DGCriteriosDistribucion b
		on b.DGCDid=a.DGCDid
		and b.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >
		
		<cfif isdefined("form.filtro_DGCDcodigo") and len(trim(form.filtro_DGCDcodigo))>
			and upper(b.DGCDcodigo) like '%#ucase(trim(form.filtro_DGCDcodigo))#%'
		</cfif>
		
		inner join PCDCatalogo c
		on c.PCDcatid=a.PCDcatid

		<cfif isdefined("form.filtro_PCDvalor") and len(trim(form.filtro_PCDvalor))>
			and upper(c.PCDvalor) like '%#ucase(trim(form.filtro_PCDvalor))#%'
		</cfif>

		where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#" >

		order by b.DGCDcodigo, c.PCDvalor
	</cfquery>

	<tr>
		<td>
			<cfinvoke
			component="sif.Componentes.pListas"
			method="pListaQuery"
			returnvariable="pListaRet"
			query="#rsLista#"
			desplegar="criterio,PCDdescripcion,Periodo,DescMes"
			etiquetas="Criterio, Departamento, Per&iacute;odo,Mes"
			formatos="S,S,S,S"
			align="left,left,left,left"
			ira="criteriosDeptoE.cfm"
			nuevo="criteriosDeptoE.cfm"
			showemptylistmsg="true"
			botones="Nuevo,Copiar"
			maxrows="15"
			incluyeForm="false"
			navegacion="#navegacion#" />
		</td>
	</tr>												
</table>	
</form>			
	<script type="text/javascript" language="javascript1.2">
		function funcCopiar(){
			location.href = 'criteriosDeptoE-copiar.cfm';
			return false;
		}
	</script>


		<cf_web_portlet_end>
	<cf_templatefooter>