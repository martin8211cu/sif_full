<!--- 
	Creado por Gustavo Fonseca Hernández
		Fecha: 16-8-2005.
		Motivo: Mantenimiento de la tabla DDVista.
 --->


<!--- <cfdump var="#form#">
<cfdump var="#url#"> --->

<cfif isdefined('url.id_tipo')>
	<cfset form.id_tipo = url.id_tipo>
	<cfset form.CAMBIO='CAMBIO'>
</cfif>
<cf_template template="#session.sitio.template#">

	<cf_templatearea name="title">
			Lista de Vistas
	</cf_templatearea>
	
	<cf_templatearea name="body">
		
	
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logos de Vistas'>

<cfparam name="form.tipo_reg" default="">
<cfquery datasource="#session.tramites.dsn#" name="lista">
	select 
		a.id_vista, 
		a.id_tipo, 
		a.nombre_vista, 
		a.titulo_vista,
		case when a.es_masivo    =1 then 'X' else '' end as masivo,
		case when a.es_individual=1 then 'X' else '' end as individual,
		case when b.es_persona   =1 then 'X' else '' end as persona,
		case when <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
			between a.vigente_desde and a.vigente_hasta then '' else 'X' end as expirado
	from DDVista a
	left outer join DDTipo b
		on b.id_tipo = a.id_tipo
where es_interna = 0
<cfif isdefined("form.fnombre_vista") and len(trim(form.fnombre_vista)) gt 0 >
  and upper(nombre_vista) like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.fnombre_vista)#%">
</cfif>
<cfif isdefined("form.ftitulo_vista") and len(trim(form.ftitulo_vista)) gt 0 >
  and upper(titulo_vista) like  <cfqueryparam cfsqltype="cf_sql_varchar" value="%#ucase(form.ftitulo_vista)#%"> 
</cfif>
<cfif form.tipo_reg EQ 'I'>
  and es_individual = 1
<cfelseif form.tipo_reg EQ 'M'>
  and es_masivo = 1
</cfif>
order by a.nombre_vista, a.titulo_vista
</cfquery>

			
<table width="100%" border="0" cellspacing="0" cellpadding="0">
  <tr> 
	<td colspan="2" valign="top"> 
		<cfinclude template="/home/menu/pNavegacion.cfm"></td>
  </tr>
  
  <tr>
	  <!--- Filtro, lista--->
	  <td width="95%" valign="top">
			<table width="100%" cellpadding="0" cellspacing="0">
				<!--- filtro --->
				<tr>
					<td valign="top">
						<form style="margin: 0" name="filtro" method="post">
							<table  border="0" width="100%" class="areaFiltro" >
								<tr> 
								  <td nowrap><strong>Nombre&nbsp;de&nbsp;la&nbsp;Vista</strong></td>
								  <td><strong>T&iacute;tulo&nbsp;de&nbsp;la&nbsp;Vista</strong></td>
								  <td>Tipo de Vista </td>
								  <td>&nbsp;</td>
								</tr>
								<tr> 
								  <cfoutput>
								  <td><input type="text" name="fnombre_vista" maxlength="30" size="20" value="<cfif isdefined ("form.fnombre_vista") and len(trim(form.fnombre_vista))>#form.fnombre_vista#</cfif>"></td>
								  <td><input type="text" name="ftitulo_vista"  maxlength="255" size="40" value="<cfif isdefined ("form.ftitulo_vista") and len(trim(form.ftitulo_vista))>#form.ftitulo_vista#</cfif>"></td>
								  <td>
								  
								  <select name="tipo_reg">
								  	<option value="">-Todas-</option>
								  	<option value="M" <cfif form.tipo_reg eq 'M'>selected</cfif>>Registro Masivo</option>
								  	<option value="I" <cfif form.tipo_reg eq 'I'>selected</cfif>>Registro Individual</option>
								  </select>
								  </td>
								  <td width="1%"><input type="submit" name="btnFiltrar" value="Filtrar"></td>
								  <td width="1%"><input type="button" name="btnNuevo" value="Nuevo" onClick="javascript:location.href='Vista_Principal.cfm'"></td>
								  <td width="1%"><input type="button" name="btnImprimir" value="Imprimir" onClick="javascript:location.href='../../Consultas/vistas.cfm'"></td>
								  </cfoutput>
								</tr>
							</table>
						</form>
					</td>
				</tr>
				<!--- lista--->
				<tr>
					<td>
					
					  <cfinvoke component="sif.Componentes.pListas" method="pListaQuery"
							query="#lista#">
							<cfinvokeargument name="desplegar" value="nombre_vista, titulo_vista,masivo,individual,persona,expirado"/>
							<cfinvokeargument name="etiquetas" value="Nombre Vista, Título Vista,Masivo,Individual,Persona,Expirado"/>
							<cfinvokeargument name="formatos" value="S,S,S,S,S,S"/>
							<cfinvokeargument name="align" value="left,left,center,center,center,center"/>
							<cfinvokeargument name="ajustar" value="N,N,N,N,N,N"/>
							<cfinvokeargument name="checkboxes" value="N"/>
							<!--- <cfinvokeargument name="Cortes" value="SNtiposocio"/> --->
							<cfinvokeargument name="showEmptyListMsg" value="true"/>
							<cfinvokeargument name="irA" value="Vista_Principal.cfm"/>
							<cfinvokeargument name="botones" value="Nuevo"/>
							<cfinvokeargument name="keys" value="id_tipo, id_vista"/>
						</cfinvoke> 
					</td>
				</tr>
			</table>
	  </td>
  </tr>
</table>
	<script type="text/javascript">
	<!--
		
	//-->
	</script>
<cf_web_portlet_end>	
</cf_templatearea>
</cf_template>


