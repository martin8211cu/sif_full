<!----  Realizado por: Rebeca Corrales Alfaro
        fecha: 08/07/2005
		Motivo: CreaciÃ³n del CatÃ¡logo de Referencias por Cuentas de Mayor
		Modificado por:
--->		

<!---   ********************* Paso de URL a form  ************************************************ --->
<cfif isdefined('url.IncVal') and not isdefined('form.IncVal')>
	<cfparam name="form.IncVal" default="#url.IncVal#">
</cfif>
<cfif isdefined('url.PCEcatid') and not isdefined('form.PCEcatid')>
	<cfparam name="form.PCEcatid" default="#url.PCEcatid#">
</cfif>
<cfif isdefined('url.PCDcatid') and not isdefined('form.PCDcatid')>
	<cfparam name="form.PCDcatid" default="#url.PCDcatid#">
</cfif>

<!---   ********************* Asigna a la variable navegacion los filtros  *********************** --->
	<cfset navegacion = "">
	<cfif isdefined("form.PCDcatid") and len(trim(form.PCDcatid)) >
		<cfset navegacion = navegacion & "&PCDcatid=#form.PCDcatid#">
	</cfif>
	<style type="text/css">
<!--
.style3 {font-size: 12px}
-->
    </style>


	<cf_templateheader title="Cat&aacute;logo al Plan de Cuentas - Referencias por Cuentas de Mayor">
	<cf_templatecss>
	<cf_web_portlet_start border="true" skin="#session.preferences.skin#" titulo="Referencias por Cuentas de Mayor">
		<table width="100%" align="center" cellpadding="0" cellspacing="0">
			<tr><td colspan="3"><cfinclude template="../../portlets/pNavegacion.cfm"></td></tr>
				<tr><td width="61%" valign="top">
				<!--- ******* Query utilizado para desplegar los datos del encabezado ************--->
					<cfquery name="Encabezado" datasource="#session.DSN#">
						Select  a.PCEcatid,
								a.PCDcatid,
								a.PCDvalor, a.PCDdescripcion,
								b.PCEdescripcion, b.PCEcodigo
						from PCDCatalogo a								
								inner join PCECatalogo b
									on a.PCEcatid = b.PCEcatid
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  					  and a.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
					</cfquery>
					
					<!--- ********** Query utilizado para desplegar los datos de la lista ********* --->
					<cfset LvarIncVal = "">
					<cfif isdefined("Form.IncVal")>
						<cfset LvarIncVal = ",1 as IncVal">
					</cfif>					
					<cfquery name="lista" datasource="#session.DSN#">
						select '#Encabezado.PCEcatid#' as PCEcatid, a.PCDcatid, a.Ecodigo,a.PCEcatidref,rtrim(a.Cmayor) as Cmayor, 
							  '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' + convert(varchar, c.PCEcodigo) as CatalogoRefcod, c.PCEdescripcion as CatalogoRefdes #LvarIncVal#
						from PCDCatalogoRefMayor a
							inner join PCECatalogo c
								on c.PCEcatid = a.PCEcatidref
						where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						  and a.PCDcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.PCDcatid#">
					</cfquery>
					<!---  ***************** Se encarga de pintar el encabezado  ***************** --->
					<cfoutput>
						<form method="post" name="filtros" action="#GetFileFromPath(GetTemplatePath())#" class="AreaFiltro" style="margin:0;">
							<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
								<tr>
									<td colspan="3">
										<strong>
											<span class="style21">C&oacute;digo:</span>
										</strong>&nbsp;
											<span class="style21">#encabezado.PCEcodigo# -  #encabezado.PCEdescripcion#</span>
									</td>
								</tr>
								<tr>
									<td>&nbsp;</td>
								  	<td>&nbsp;</td>
								  	<td>&nbsp;</td>
							  	</tr>
							 	<tr>
							  		<td>&nbsp;</td>
									<td>&nbsp;</td>
									<td>
									 	<strong>
											<span class="style21">Valor:</span>
										</strong>&nbsp;
											<span class="style21">#encabezado.PCDvalor# -  #encabezado.PCDdescripcion#</span>
									</td>
								</tr>
								<tr>
								</tr>
							</table>
							<cfif isdefined("Form.IncVal")>
								<input type="hidden" name="IncVal" value="#form.IncVal#">
							</cfif>							
						</form>
					</cfoutput>
					<!--- ******************** Se encarga de pintar la lista  ******************** --->
					<cfinvoke
						component="sif.Componentes.pListas"
						method="pListaQuery"
					 	returnvariable="pListaRet">
						<cfinvokeargument name="query" value="#lista#"/>
						<cfinvokeargument name="desplegar" value="CMayor, CatalogoRefcod, CatalogoRefdes "/>
						<cfinvokeargument name="etiquetas" value="Cuenta, &nbsp;&nbsp;&nbsp; &nbsp;Cat&aacute;logo,  &nbsp;Descripci&oacute;n &nbsp;"/>
						<cfinvokeargument name="formatos" value="V,V,V "/>
						<cfinvokeargument name="align" value="left, left, left"/>
						<cfinvokeargument name="ajustar" value="S"/>
						<cfinvokeargument name="irA" value="CuentasRefMayor.cfm"/>
						<cfinvokeargument name="keys" value="PCDcatid,Ecodigo,Cmayor,PCEcatidref"/>
						<cfinvokeargument name="PageIndex" value="1"/>					
						<cfinvokeargument name="showemptylistmsg" value="true"/>
						<cfinvokeargument name="navegacion" value="#navegacion#"/>
						<cfinvokeargument name="maxRows" value="12"/> 
				 	</cfinvoke>
				</td>
				<!--- **************** Se encarga de llamar al pintado del formulario ***************--->
				<td width="1%" valign="top">&nbsp;</td>
		    	<td width="38%" valign="top">
					<cfinclude template="CuentasRefMayor-form.cfm">
				</td>
			</tr>		
		</table>
	<cf_web_portlet_end>
	<cf_templatefooter>

