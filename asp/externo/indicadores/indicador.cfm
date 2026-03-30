<cf_templateheader title="Mantenimiento de Indicadores">
<cfif isdefined("url.indicador") and not isdefined("form.indicador")>
	<cfset form.indicador = url.indicador >
</cfif>

<!--- ==============================================================--->
<!--- Filtro --->
<cfset navegacion = "" >
<cfset camposExtra = "" >
<cfif isdefined("url.fSScodigo") and not isdefined("form.fSScodigo")>
	<cfset form.fSScodigo = url.fSScodigo >
	<cfset navegacion = navegacion & "&fSScodigo=#form.fSScodigo#" >
</cfif>

<cfif isdefined("url.fSMcodigo") and not isdefined("form.fSMcodigo")>
	<cfset form.fSMcodigo = url.fSMcodigo >
	<cfset navegacion = navegacion & "&fSMcodigo=#form.fSMcodigo#" >
</cfif>

<cfif isdefined("form.fSScodigo") and len(trim(form.fSScodigo))>
	<cfset navegacion = navegacion & "&fSScodigo=#form.fSScodigo#" >
	<cfset camposExtra = camposExtra & ", '#trim(form.fSScodigo)#' as fSScodigo" >
</cfif>

<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMcodigo))>
	<cfset navegacion = navegacion & "&fSMcodigo=#form.fSMcodigo#" >
	<cfset camposExtra = camposExtra & ", '#trim(form.fSMcodigo)#' as fSMcodigo" >
</cfif>
<!--- ==============================================================--->

<!--- QUERYS, se usan aqui y en el form --->
<cfquery name="rsSistemas" datasource="asp">
	select SScodigo, SSdescripcion
	from SSistemas
	order by SScodigo
</cfquery>

<cfquery name="rsModulos" datasource="asp">
	select SScodigo, SMcodigo, SMdescripcion
	from SModulos
	order by SMcodigo, SMdescripcion
</cfquery>

<cf_web_portlet_start titulo="Mantenimiento de Indicadores">
<cfinclude template="/home/menu/pNavegacion.cfm">

<table width="100%" border="0" cellspacing="6">
  <tr>
    <td valign="top" width="50%">
		<cfoutput>
		<form style="margin:0;" name="filtro" action="indicador.cfm" method="post">
			<table width="100%" cellpadding="0" cellspacing="0" class="areaFiltro">
				<tr>
					<td><strong>Sistema:&nbsp;</strong></td>
					<td >
						<select name="fSScodigo" onChange="javascript:change_sistema_filtro(this, this.form);">
							<option value="" >- todos -</option>
							<cfloop query="rsSistemas">
								<option value="#Trim(rsSistemas.SScodigo)#" <cfif isdefined("form.fSScodigo") and trim(form.fSScodigo) eq trim(rsSistemas.SScodigo)>selected</cfif> >#rsSistemas.SScodigo# - #rsSistemas.SSdescripcion#</option>
							</cfloop>
						</select>
					</td>
					<td rowspan="2" valign="middle"><input type="submit" name="btnFiltrar" value="Filtrar"></td>
				</tr>

				<tr>
					<td><strong>M&oacute;dulo:</strong></td>
					<td >
						<select name="fSMcodigo" >
							<option value="" >- todos -</option>
						</select>
					</td>
				</tr>
			</table>
		</form>
		</cfoutput>

		<cfquery name="rsLista" datasource="asp">
			select indicador, nombre_indicador, SSdescripcion, SMdescripcion, 
				<!---rtrim(SSdescripcion)||'/'||rtrim(SMdescripcion) as grupo,--->
				{fn concat({fn concat(rtrim(SSdescripcion), '/') }, rtrim(SMdescripcion))}  as grupo,
				case when es_diario  = 1 then 'D' else ' ' end as ch_diario,
				case when es_default = 1 then 'P' else ' ' end as ch_default
				
				#preservesinglequotes(camposExtra)#
			from Indicador a
			
			inner join SSistemas b
			on a.SScodigo=b.SScodigo

			inner join SModulos c
			on a.SMcodigo=c.SMcodigo
			
			where 1=1
			
			<cfif isdefined("form.fSScodigo") and len(trim(form.fSScodigo))>
				and a.SScodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fSScodigo)#">
			</cfif> 

			<cfif isdefined("form.fSMcodigo") and len(trim(form.fSMcodigo))>
				and a.SMcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fSMcodigo)#">
			</cfif> 

			order by grupo
		</cfquery>

		<cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
			query="#rsLista#"
			desplegar="SMdescripcion,indicador,nombre_indicador,ch_default,ch_diario"
			etiquetas="M&oacute;dulo,Indicador,Nombre,P,D"
			formatos="S,S,S,S,S"
			keys="indicador"
			mostrar_filtro="no"
			form_method="post"
			align="left,left,left,left,left"
			ira="indicador.cfm"	
			showEmptyListMsg="true"	
			cortes="SSdescripcion"
			navegacion="#navegacion#" />
	</td>
    <td valign="top" align="center" width="50%">
		<cfinclude template="indicador-form.cfm">
	</td>
  </tr>
</table>
<cf_web_portlet_end>

<script type="text/javascript" language="javascript1.2">
	function change_sistema_filtro(obj, form ){
		combo = form.fSMcodigo;
		combo.length = 0;

		var cont = 0;

		combo.length = cont+1;
		combo.options[cont].value = '';
		combo.options[cont].text = '- todos -';	
		cont = 1;
		
		<cfloop query="rsModulos">
		if ( obj.value == '<cfoutput>#Trim(rsModulos.SScodigo)#</cfoutput>' ) {
			combo.length = cont+1;
			combo.options[cont].value = '<cfoutput>#Trim(rsModulos.SMcodigo)#</cfoutput>';
			combo.options[cont].text = '<cfoutput>#Trim(rsModulos.SMcodigo)# - #rsModulos.SMdescripcion#</cfoutput>';	
			
			<cfif isdefined('form.fSMcodigo') and trim(form.fSMcodigo) eq trim(rsModulos.SMcodigo) >
				combo.options[cont].selected = true;
			</cfif>
			cont = cont + 1;
		}
		</cfloop>
	}
	
	change_sistema_filtro(document.filtro.fSScodigo, document.filtro);
	
</script>
<cf_templatefooter>