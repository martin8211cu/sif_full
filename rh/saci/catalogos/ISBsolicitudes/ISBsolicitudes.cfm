<cfset CurrentPage = GetFileFromPath(GetTemplatePath())>

<cfsavecontent variable="pNavegacion">
	<cfinclude template="/home/menu/pNavegacion.cfm">
</cfsavecontent>

<cf_templateheader title="#nav__SPdescripcion#">
	<cfoutput>#pNavegacion#</cfoutput>
	<cfinclude template="ISBsolicitudes-params.cfm">
	
	<cf_web_portlet_start titulo="#nav__SPdescripcion#">
		<cfquery datasource="#session.dsn#" name="rsAgente">
			Select count(1) as cant
			from ISBagente
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#" null="#Len(session.Ecodigo) Is 0#">
				and AGid=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.saci.agente.id#" null="#Len(session.saci.agente.id) Is 0#">
				and Habilitado=1
		</cfquery>
		
		<!--- Solo se debe permitir el acceso a los agentes autorizados --->		
		<cfif isdefined('rsAgente') and rsAgente.cant GT 0>
			<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO SOtipo --->
			<cfquery datasource="#session.dsn#" name="rsSOtipo">
				select '' as value, '-- todos --' as description, '0' as ord
				union
				select 'P' as value, 'Prepago' as description, '1' as ord
				union
				select 'S' as value, 'Sobre' as description, '2' as ord
				order by 3,2
			</cfquery>
	
			<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO SOestado --->
			<cfquery datasource="#session.dsn#" name="rsSOestado">
				select '' as value, '-- todos --' as description, '0' as ord
				union
				select 'A' as value, 'Autorizada' as description, '1' as ord
				union
				select 'D' as value, 'Devuelta' as description, '2' as ord
				union
				select 'I' as value, 'Incluida' as description, '3' as ord
				union
				select 'M' as value, 'Modificada' as description, '4' as ord
				union
				select 'N' as value, 'Anulada' as description, '5' as ord
				union
				select 'R' as value, 'Rechazada' as description, '6' as ord
				order by 3,2
			</cfquery>
			
			<!---QUERY PARA EL FILTRO DE LA LISTA, PARA EL CAMPO SOtipoSobre --->
			<cfquery datasource="#session.dsn#" name="rsSOtipoSobre">
				select '' as value, '-- todos --' as description, '0' as ord
				union
				select 'F' as value, 'Físico' as description, '1' as ord
				union
				select 'V' as value, 'Virtual' as description, '2' as ord
				order by 3,2
			</cfquery>

			<cfinvoke component="sif.Componentes.pListas" method="pLista"
				tabla="ISBsolicitudes"
				columnas="SOid
					, SOfechasol
					, case SOtipo
						when 'P' then 'Prepago'
						when 'S' then 'Sobre'
					end as SOtipo
					, case SOestado
						when 'A' then 'Autorizada'	
						when 'D' then 'Devuelta'
						when 'I' then 'Incluida'
						when 'M' then 'Modificada'
						when 'N' then 'Anulada'
						when 'R' then 'Rechazada'
						when 'E' then 'Revisión'
					end SOestado
					, case SOtiposobre
						when 'F' then 'Físico'		
						when 'V' then 'Virtual'
					end SOtipoSobre
					, SOcantidad"
				filtro="AGid=#session.saci.agente.id# order by SOfechasol"
				desplegar="SOfechasol,SOtipo,SOestado,SOtipoSobre,SOcantidad"
				etiquetas="Fecha Solicitud,Tipo,Estado,Tipo Sobre,Cantidad"
				formatos="D,S,S,S,I"
				align="left,left,left,left,right"
				ira="ISBsolicitudes-edit.cfm"
				form_method="post"
				rsSOtipo="#rsSOtipo#"
				rsSOestado="#rsSOestado#"
				rsSOtipoSobre="#rsSOtipoSobre#"
				filtrar_por="SOfechasol,SOtipo,SOestado,SOtipoSobre,SOcantidad"			
				keys="SOid"
				mostrar_filtro="yes"
				filtrar_automatico="yes"
				botones="Nuevo"
				maxrows="20" 
				showEmptyListMsg="true" 
			/>
		<cfelse>
			<cfthrow message="Error, usted no es un agente autorizado para acceder esta p&aacute;gina">
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>
