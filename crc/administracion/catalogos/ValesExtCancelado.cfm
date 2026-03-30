<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Folio" Default="Folio" returnvariable="LB_Folio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_CodDistribuidor" Default="C&oacute;digo Distribuidor Ext" returnvariable="LB_CodDistribuidor"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_FechaCancel" Default="Fecha Cancelado" returnvariable="LB_FechaCancel"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Observaciones" Default="Observaciones" returnvariable="LB_Observaciones"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Folio" Default="Folio" returnvariable="LB_Folio"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Estado" Default="Estado" returnvariable="LB_Estado"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Tienda" Default="Tienda" returnvariable="LB_Tienda"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Filtrar" Default="Filtrar" returnvariable="LB_Filtrar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_Limpiar" Default="Limpiar" returnvariable="LB_Limpiar"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="LB_DescripTienda" Default="Descripci&oacute;n" returnvariable="LB_DescripTienda"/>

<cfoutput>

<cfquery name="q_Estados" datasource="#Session.DSN#">
	SELECT 
		distinct (A.Estado) as Estado
	FROM CRCValesExtCancelados A
	WHERE A.Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">	

</cfquery>

<cfset datosTienda = "">

<!--- filtros para lista de vales externos--->
<cfset strFiltro = " ">
<!--- si estan definidos en la url, los asigna a su correspondiente en form --->
<cfif isDefined('url.ff')><cfset form.f_folio = url.ff></cfif>
<cfif isDefined('url.fe')><cfset form.f_estado = url.fe></cfif>
<cfif isDefined('url.ft')><cfset form.idtienda = url.ft></cfif>
<cfif isDefined('url.fc')><cfset form.codigotienda = url.fc></cfif>
<cfif isDefined('url.fd')><cfset form.descriptienda = url.fd></cfif>
<cfset params="">
<!--- --->
<cfif !isDefined('form.bLimpiar') || isDefined('url.ff')>
	<cfif isdefined('form.f_folio') && trim(form.f_folio) neq "">
		<cfset strFiltro = "#strFiltro# and Folio like '%#form.f_folio#%'">
		<cfset params="#params#&ff=#form.f_folio#">
	</cfif>
	<cfif isdefined('form.f_estado') && trim(form.f_estado) neq "-">
		<cfset strFiltro = "#strFiltro# and Estado = '#form.f_estado#'">
		<cfset params="#params#&ff=#form.f_estado#">
	</cfif>
	<cfif isdefined('form.idtienda') && trim(form.idtienda) neq "">
		<cfset strFiltro = "#strFiltro# and CRCTiendaExternaid = #form.idtienda#">
		<cfset datosTienda = "#form.idtienda#,#form.codigotienda#,#form.descriptienda#">
		<cfset params="#params#&ft=#form.idTienda#&fc=#form.CodigoTienda#&fd=#form.DescripTienda#">
	</cfif>
</cfif>

<cf_templateheader title='Vales Externos Cancelados'>
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Vales Externos Cancelados'>
		<table width="100%" border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfinclude template="/home/menu/pNavegacion.cfm">
				</td>
			</tr>
			<form name="form" method="post" action="ValesExtCancelado.cfm">
			<tr>
				<td nowrap>
					<strong>#LB_Folio#:&nbsp;</strong>
					<input type="text" name="f_folio" id="f_folio" style="width: 15%"
						<cfif isdefined('form.f_folio')>value="#form.f_folio#"</cfif>
					>

					<strong>#LB_Estado#:&nbsp;</strong>
					<select name="f_estado">
						<option value="-">Todos</option>
						<cfloop query="#q_Estados#">
							<option value="#q_Estados.Estado#" 
								<cfif isdefined('form.f_estado') and form.f_estado eq q_Estados.Estado>selected</cfif>
							>#q_Estados.Estado#</option>
						</cfloop>
					</select>

					<strong>#LB_Tienda#:&nbsp;</strong>
					<!---<input type="text" name="tienda" id="tienda" style="width: 25%">--->
					<cf_conlis
						Campos="idTienda,CodigoTienda,DescripTienda"
						Values="#datosTienda#"
						Desplegables="N,S,S"
						Modificables="N,N,N"
						Size="0,10,30"
						tabindex="1"
						Tabla="CRCTiendaExterna"
						Columnas="id as idTienda,Codigo as CodigoTienda,Descripcion as DescripTienda"
						form="form"
						Filtro="Ecodigo = #Session.Ecodigo#"
						Desplegar="CodigoTienda,DescripTienda"
						Etiquetas="Codigo de Tienda, Descripcion"
						filtrar_por="Codigo,Descripcion"
						Formatos="S,S"
						Align="left,left"
						Asignar="idTienda,CodigoTienda,DescripTienda"
						Asignarformatos="S,S,S"/>

					<input type="submit" name="bFiltrar" value="#LB_Filtrar#" class="btnFiltrar">
					<input type="submit" name="bLimpiar" value="#LB_Limpiar#" class="btnFiltrar">
				</td>
			</tr>
			</form>
			<tr>
				<td width="65%" valign="top">

					<cfinvoke component="commons.Componentes.pListas" method="pListaRH"
						tabla="CRCValesExtCancelados A left join CRCTiendaExterna B on A.CRCTiendaExternaid = B.id"
						columnas="A.id,A.Folio,B.Codigo,B.Descripcion,A.FechaCancelado,A.Observaciones, A.Estado"
						desplegar="Folio,Codigo,Descripcion,FechaCancelado,Observaciones, Estado"
						etiquetas="#LB_Folio#,Codigo Tienda,Descripcion Tienda,#LB_FechaCancel#,#LB_Observaciones#, Estado"
						formatos="S,S,S,D,S,S"
						filtro="A.Ecodigo = #Session.Ecodigo# #strFiltro#"
						align="left,left,left,left,left,left"
						incluyeform="true"
						form="form"
						checkboxes="N"
						ira="ValesExtCancelado.cfm?#params#"
						keys="id"
					>
					</cfinvoke>
					<cf_exportarCatalogo tableName="CRCValesExtCancelados" keyColumnName="Folio">
					
				</td>
				
				<td width="50%" valign="top">
					<cfinclude template="ValesExtCancelado_form.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="2">&nbsp;</td>
			</tr>
		</table>
		<cfif isdefined("form.resultT") and #form.resultT# neq ""> 
			<script type="text/javascript">
				alert("#form.resultT#");
			</script> 
		</cfif>		
	</cfoutput>
	<cf_web_portlet_end>
<cf_templatefooter>