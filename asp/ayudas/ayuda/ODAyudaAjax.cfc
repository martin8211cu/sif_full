
<cfcomponent output="true">

		<cffunction name="TablaArticulosF" access="remote" returnformat="plain">
			<cfsavecontent variable = "result">

				<cfquery datasource="asp" name="lista_query_AyudaDetalle">
					select AyudaCabId, AyudaDetallePos, AyudaDetalleId, AyudaDetalleTitulo, AyudaDetalleText
					,'<i class=''fa fa-edit fa-lg'' title=''Editar'' style=''cursor:pointer;''
					onclick=''editarModal(' + cast(AyudaDetalleId as varchar)+','+ cast(AyudaCabId as varchar) + ');''></i>&nbsp;
					<i class=''fa fa-trash-o fa-lg'' title=''Eliminar'' style=''cursor:pointer;''
					onclick=''eliminarModal(' + cast(AyudaDetalleId as varchar)+','+ cast(AyudaCabId as varchar) +  ');''></i>' as Acciones
					from AyudaDetalle where 1=1 <!--- and AyudaIdioma = <cf_jdbcquery_param value="#session.idioma#" cfsqltype="cf_sql_varchar"> --->
						<cfif isdefined("url.AyudaCabIdVar") and #Len(Trim("url.AyudaCabIdVar"))# gt 0 >
								and AyudaCabId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaCabIdVar#">
								order by AyudaDetallePos asc
						</cfif>
				</cfquery>

				<div align="center">
					<div class="row">&nbsp;</div>
						<table class="table table-striped" style="width: 30%;">
								<tr>
									<th>Orden</th>
									<th>T&iacute;tulo</th>
									<th>Acciones</th>
								</tr>
									<cfoutput query="lista_query_AyudaDetalle">
										<tr>
											<td>#lista_query_AyudaDetalle.AyudaDetallePos#</td>
											<td>#lista_query_AyudaDetalle.AyudaDetalleTitulo#</td>
											<td align="center">#lista_query_AyudaDetalle.Acciones#</td>
										</tr>
									</cfoutput>
						</table>
					<input type="button" tabindex="0" onclick="NuevoArticulosModal()" value="Nuevo" class="btnNuevo" name="btnNuevo" style="display: block;  margin-left: auto;  margin-right: auto;">
				</div>

			</cfsavecontent>
			<cfreturn result>
		</cffunction>

		<cffunction name="funcTablaArticulosRelacionados" access="remote" returnformat="plain">
			<cfsavecontent variable = "result">

				<cfquery datasource="asp" name="lista_query_AyudaRelacionados">
					select aod.AyudaODId as codigo, ac.SScodigo as sistema, ac.SPcodigo as modulo, ac.AyudaCabTitulo as cabecera
					,'<i class=''fa fa-trash-o fa-lg'' style=''cursor:pointer;''
					onclick=''eliminarModalRef('+ cast(aod.AyudaODId as varchar)+','+ cast(AyudaCabIdL as varchar) + ');''></i>' as acciones
					from AyudaOD aod join AyudaCabecera ac on aod.AyudaCabIdR = ac.AyudaCabId where 1=1
						<cfif isdefined("url.AyudaCabIdVarRel") and #Len(Trim("url.AyudaCabIdVarRel"))# gt 0 >
							and AyudaCabIdL = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.AyudaCabIdVarRel#">
						</cfif>
				</cfquery>

				<div align="center">
					<div class="row">&nbsp;</div>
						<table class="table table-striped" style="width: 70%;">
							<tr>
								<th>C&oacute;digo</th>
								<th>Sistema</th>
								<th>M&oacute;dulo</th>
								<th>Cabecera</th>
								<th>Acciones</th>
							</tr>
								<cfoutput query="lista_query_AyudaRelacionados">
									<tr>
										<td>#lista_query_AyudaRelacionados.codigo#</td>
										<td>#lista_query_AyudaRelacionados.sistema#</td>
										<td>#lista_query_AyudaRelacionados.modulo#</td>
										<td>#lista_query_AyudaRelacionados.cabecera#</td>
										<td>#lista_query_AyudaRelacionados.acciones#</td>
									</tr>
								</cfoutput>
						</table>
					<input type="button" tabindex="0" onclick="NuevoArticulosRelModal()" value="Nuevo" class="btnNuevo" name="btnNuevo" style="display: block;  margin-left: auto;  margin-right: auto;">
				</div>

			</cfsavecontent>
			<cfreturn result>
		</cffunction>

</cfcomponent>