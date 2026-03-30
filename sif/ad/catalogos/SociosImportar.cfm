<cfinclude template="SociosModalidad.cfm">
<cfif not modalidad.importar>
	<cf_errorCode	code = "50014" msg = "La configuración actual no le permite importar socios de negocio corporativos">
</cfif>
<cfif isdefined('url.SNcodigo')>
	<cfset form.SNcodigo = url.SNcodigo>
	<cfset form.CAMBIO='CAMBIO'>
</cfif>
	
<cf_templateheader title="Socios de Negocio">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Cat&aacute;logo de Socios de Negocios'>

<cfset checked   = "<img border='0' src='/cfmx/sif/imagenes/checked.gif'>" >
<cfset unchecked = "<img border='0' src='/cfmx/sif/imagenes/unchecked.gif'>" >
<cfquery datasource="#session.dsn#" name="lista">
select
	SNcodigo,SNnumero, SNnombre, 
	case when SNtiposocio = 'C' then 'Cliente' when SNtiposocio = 'P' then 'Proveedor' else 'Ambos' end as SNtiposocio, 
	case
		when EUcodigo is NULL then <cfqueryparam cfsqltype="cf_sql_varchar" value="#unchecked#">
		else <cfqueryparam cfsqltype="cf_sql_varchar" value="#checked#">
	end as Usuario 
from SNegocios
where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.EcodigoCorp#">
<cfif isdefined("form.fSNnumero") and len(trim(form.fSNnumero)) gt 0 >
  and SNnumero like <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.fSNnumero#%">
</cfif>
<cfif isdefined("form.fSNnombre") and len(trim(form.fSNnombre)) gt 0 >
  and upper(SNnombre) like upper( <cfqueryparam cfsqltype="cf_sql_varchar" value="%#form.fSNnombre#%"> )
</cfif>
  and SNidentificacion not in (
  		select SNidentificacion
		from SNegocios
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">  )
order by SNtiposocio, SNnumero, SNnombre 
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
												  <td nowrap>N&uacute;mero (XXX-XXXX)</td>
												  <td>Nombre</td>
												  <td>&nbsp;</td>
												</tr>
												<tr> 
												  <td><input type="text" name="fSNnumero" maxlength="8" size="10" value=""></td>
												  <td><input type="text" name="fSNnombre"  maxlength="255" size="40" value=""></td>
												  <td><input type="submit" name="btnFiltrar" value="Filtrar"></td>
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
											<cfinvokeargument name="desplegar" value="SNnumero, SNnombre, Usuario"/>
											<cfinvokeargument name="etiquetas" value="N&uacute;mero, Nombre, Usuario"/>
											<cfinvokeargument name="formatos" value=""/>
											<cfinvokeargument name="align" value="left, left, left"/>
											<cfinvokeargument name="ajustar" value="N,N,N"/>
											<cfinvokeargument name="checkboxes" value="N"/>
											<cfinvokeargument name="Cortes" value="SNtiposocio"/>
											<cfinvokeargument name="irA" value="SociosImportar-sql.cfm"/>
											<cfinvokeargument name="botones" value="Regresar"/>
											<cfinvokeargument name="keys" value="SNcodigo"/>
										</cfinvoke> 
									</td>
								</tr>
							</table>
					  </td>
				  </tr>
				</table>
				<script type="text/javascript">
				<!--
					function funcRegresar(){
						window.open('listaSocios.cfm','_self');
						return false;
					}
				//-->
				</script>
<cf_web_portlet_end>
<cf_templatefooter>



