<cf_template> <cf_templatearea name="title"> Registro de Documentos </cf_templatearea> <cf_templatearea name="body"> <cf_web_portlet_start titulo='Registro de Documentos'>
<cfobject name="tramites" component="home.tramites.componentes.tramites">
<cfinclude template="/home/menu/pNavegacion.cfm">
<cfquery datasource="#session.tramites.dsn#" name="lista">
select a.id_vista,a.id_tipo,a.nombre_vista,a.titulo_vista, 
	d.es_documento, a.es_masivo, a.es_individual,
	e.id_documento
from DDVista a
	inner join DDTipo d
		on d.id_tipo = a.id_tipo
	left outer join TPDocumento e 
		on e.id_tipo = a.id_tipo
where exists (
	select 1 from DDVistaCampo vc
		where vc.id_vista = a.id_vista
	)
	and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
	between a.vigente_desde and a.vigente_hasta order by a.titulo_vista
</cfquery>

<cfquery dbtype="query" name="list_ind">
	select * from lista where es_individual = 1
</cfquery>
<cfquery dbtype="query" name="list_mas">
	select * from lista where es_masivo = 1
</cfquery>

<table width="850"  border="0" cellspacing="0" cellpadding="0" align="center">
  <tr>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td colspan="3">
	
	<table width="100%"  border="0" cellspacing="0" cellpadding="4" align="center" >
  <tr>
    <td width="808" align="center" style="font-size:16px;background-color:#CCCCCC ">Sistema de Tr&aacute;mites - Registro de informaci&oacute;n </td>
  </tr>
</table>

    </td>
  </tr>
  <tr>
    <td colspan="3">&nbsp;</td>
  </tr>
  <tr>
    <td width="390" valign="top"><cfif list_ind.RecordCount><table width="100%"  border="0" cellspacing="0" cellpadding="2">
        <cfset NoTieneNingunPermiso = true>
		<cfset NoTieneTitulo = true>
		<cfoutput query="list_ind"> 
		  <cfif len(id_documento) eq 0 or (len(id_documento) and tramites.permisos_obj(session.tramites.id_funcionario,id_documento,'D'))>
		  <cfset NoTieneNingunPermiso = false>
		  <cfif NoTieneTitulo>
		  	<tr>
				<td colspan="2" class="tituloListas"><strong>Documentos</strong></td>
			</tr>
			<cfset NoTieneTitulo=false>
		  </cfif>
		  <tr>
		  <td align="right"><em><img src="../images/option_arrow.gif" width="12" height="17"></em></td>
            <td><a href="index-ind-list.cfm?id_vista=#id_vista#&amp;id_tipo=#id_tipo#">#HTMLEditFormat(titulo_vista)#</a></td>
          </tr>
		  </cfif>
        </cfoutput>
      </table></cfif></td>
    <td width="30" valign="top">&nbsp;</td>
    <td width="390" valign="top"><cfif list_mas.RecordCount><table width="100%"  border="0" cellspacing="0" cellpadding="2">
		<cfset NoTieneNingunPermiso = true>
		<cfset NoTieneTituloMasivo = true>
        <cfoutput query="list_mas"> 		
          <cfif len(id_documento) eq 0 or (len(id_documento) and tramites.permisos_obj(session.tramites.id_funcionario,id_documento,'D'))>
		  <cfset NoTieneNingunPermiso = false>
		  <cfif NoTieneTituloMasivo>
			<tr>
				<td colspan="2" class="tituloListas"><strong>Documentos Masivos</strong></td>
			</tr>
			<cfset NoTieneTituloMasivo = false>
		  </cfif>
		  <tr>
		  <td align="right"><em><img src="../images/option_arrow.gif" width="12" height="17"></em></td>
            <td>
			<a href="vistas.cfm?id_vista=#id_vista#&amp;id_tipo=#id_tipo#">
			#HTMLEditFormat(titulo_vista)#</a></td>
          </tr>
		  </cfif>
        </cfoutput>
      </table></cfif></td>
  </tr>
</table>
<cf_web_portlet_end> </cf_templatearea> </cf_template> 