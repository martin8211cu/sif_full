
<cfcomponent output="true" >
	<cffunction name="getOrigenDatos" access="remote" returnformat="plain">
		<!--- Traducciones --->
		<cfinvoke component="sif.Componentes.Translate" method="init" returnvariable="t">
		<cfset LB_Desc		= t.Translate('LB_Desc', 'Descripcion', 'GestionReportes.xml')>
		<cfset LB_Codigo	= t.Translate('LB_Codigo', 'Codigo', 'GestionReportes.xml')>
		<cfset LB_Eliminar	= t.Translate('LB_Eliminar', 'Eliminar', 'GestionReportes.xml')>

		<!---Se obtiene los Origenes de Datos  --->
		<cfquery name="rsREOD" datasource="#Session.dsn#">
	    	SELECT a.RPTOId, a.RPTId, b.ODId, b.ODCodigo, b.ODDescripcion
			FROM RT_ReporteOrigen a
			inner join RT_OrigenDato b
			 on a.ODId = b.ODId
			where a.RPTId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTId#">
    	</cfquery>

    	<cfsavecontent variable="result">
	    	<div class="row">
	        	<table class="table table-hover">
		        	<tr>
			        	<th>#LB_Codigo#</th>
						<th>#LB_Desc#</th>
						<th>#LB_Eliminar#</th>
					</tr>
					<cfoutput query = "rsREOD">
					<tr>
				        	<td>#rsREOD.ODCodigo#</td>
							<td>#rsREOD.ODDescripcion#</td>
							<td>
								<i class="fa fa-trash-o fa-lg" style="cursor:pointer;" onclick="eliminaOrigenDatos(#rsREOD.RPTOId#,#rsREOD.RPTId#,#rsREOD.ODId#)"></i>
							</td>
						</tr>
					</cfoutput>
	        	</table>
			</div><br>
			<div class="row">
				<input type="button" tabindex="0" onclick="FunviewNewRel()" value="Nuevo"
					class="btnNuevo" name="btnNuevo" style="display: block;  margin-left: auto;  margin-right: auto;">
			</div>
    	</cfsavecontent>
    	<cfreturn result>
	</cffunction>

	<cffunction name="insertaODRO" access="remote" returnformat="plain">
		<cfquery datasource="#Session.dsn#">
	    	INSERT INTO RT_ReporteOrigen (RPTId, ODId)
				VALUES	(
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTId#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ODId#">
						)
    	</cfquery>
	</cffunction>

	<cffunction name="eliminaOrigenDatos" access="remote" returnformat="plain">

		<cfif url.RPTOId neq ""  and url.RPTId neq "" and  url.ODId neq "">
			<!--- Se borran datos relacionados --->
			<cfquery datasource="#Session.dsn#">
				Delete from RT_ReporteColumna
				where RPTId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RPTId#">
				and ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ODId#">
			</cfquery>
			<!--- Eliminamos Reporte origen --->
			<cfquery datasource="#Session.dsn#">
		    	Delete from  RT_ReporteOrigen
		    	where RPTOId = #url.RPTOId#
	    	</cfquery>
		</cfif>
	</cffunction>

</cfcomponent>