
<cfcomponent output="true" >
	<cffunction name="getColumnas" access="remote" returnformat="plain">
		<cfargument name="rtpid" type="numeric">
		<cf_dbfunction name="to_char" args="rc.RPTId" returnvariable="toCharRPTId">
		<cf_dbfunction name="to_char" args="rc.RPTCId" returnvariable="toCharRPTCId">
		<cf_dbfunction name="op_concat" returnvariable="concat">
		<cfquery name="rsColumnas" datasource="#Session.dsn#">
	    	SELECT  rc.RPTCId,  rc.RPTId, rc.ODCampo, rc.RTPCAlias,
					rc.RTPCOrdenColumna, rc.RTPCOrdenDato, rc.ODId,
					od.ODCodigo #concat#'.'#concat# rc.ODCampo as Campo,
					<!---'<i class=''fa fa-edit fa-lg'' style=''cursor:pointer;'' onclick=''editarColumna(' #concat# #toCharRPTId# #concat# ',' #concat# #toCharRPTCId# #concat# ');''>
					</i>&nbsp;'	habilita la edición de las columnas de RT_ReporteVerColumna  --->
					'<i class=''fa fa-trash fa-lg'' style=''cursor:pointer;'' onclick=''eliminaColumna(' #concat# #toCharRPTId# #concat# ',' #concat# #toCharRPTCId# #concat# ');''></i>' as acciones
			FROM RT_ReporteColumna rc
			inner join RT_OrigenDato od
				on rc.ODId = od.ODId
			where rc.RPTId = #arguments.rtpid#
			order by rc.RTPCOrdenColumna, od.ODCodigo #concat#'.'#concat# rc.ODCampo
    	</cfquery>

    	<cfsavecontent variable="result">
	    	<div>
	        	<div class="row">&nbsp;</div>
	    		<cfif rsColumnas.recordCount GT 0 >
			    	<div class="row cont">
				        <div class="col col-md-12">
				      		<table class="table">
				      			<thead>
				      				<th>Campo</th>
				      				<!---<th>Alias</th>--->
				      				<th>Orden</th>
				      				<th></th>
				      			</thead>
				      			<tbody>
				      				<cfloop query="rsColumnas">
				      					<tr>
					      					<td>#Campo#</td>
					      					<!---<td>#RTPCAlias#</td>--->
					      					<td>#RTPCOrdenColumna#</td>
					      					<td>#acciones#</td>
					      				</tr>
				      				</cfloop>
				      			</tbody>
				      		</table>
				      	</div>
				    </div>
				<cfelse>
					<p>No se ha asignado ninguna Columna</p>
			    </cfif>
			    <div class="row">&nbsp;</div>
			    <div class="row">
			        <div class="col col-md-12">
			      		<input id="btnNuevoCol"  name="btnNuevoCol" class="btnNuevo btnNuevoCol" value="Nuevo" tabindex="0" type="button"
			      		onclick="javascript:creaNuevoColumna(#arguments.rtpid#)">
			      	</div>
			    </div>
			</div>
    	</cfsavecontent>
	    <cfreturn  result>
	</cffunction>

	<cffunction name="getColumnasCondicion" access="remote" returnformat="plain">
		<cfargument name="rtpvid" type="numeric">
		<cf_dbfunction name="to_char" args="RT_R.RPTVId" returnvariable="toCharRPTVId">
		<cf_dbfunction name="to_char" args="RT_R.RPTVCId" returnvariable="toCharRPTVCId">
		<cf_dbfunction name="op_concat" returnvariable="concat">
		<cfquery name="rsColumnas" datasource="#Session.dsn#">
	    	select RPTVCId, RPTVCCampo as Campo,
	    	RPTVCCondicion as Condicion, RPTVCValor as Valor, RPTVCGrupo as Grupo,
	    	case RPTVCY_O
	    		when '1' then 'Y'
	    		else 'O'
	    	end as RPTVCY_O,
	    	'<i class=''fa fa-edit fa-lg'' style=''cursor:pointer;''
	    	 onclick=''editarColumnaCondicion('#concat# <cf_dbfunction name="to_char" args="RT_R.RPTVCId"> #concat# ','
	    	 	#concat#'"'#concat# <cf_dbfunction name="to_char" args="RT_R.RPTVCCampo">#concat#'"'#concat# ','
	    	 	#concat#'"'#concat# <cf_dbfunction name="to_char" args="RT_R.RPTVCCondicion">#concat#'"'#concat# ','
	    	 	#concat#'"'#concat# <cf_dbfunction name="to_char" args="RT_R.RPTVCValor">#concat#'"'#concat# ','
	    	 	#concat#'"'#concat# <cf_dbfunction name="to_char" args="RT_R.RPTVCY_O">#concat#'"'#concat# ','
	    	 	#concat#'"'#concat# <cf_dbfunction name="to_char" args="RT_R.RPTVCGrupo"> #concat#'"'#concat#
	    	 	');''></i>&nbsp;
			<i class=''fa fa-trash fa-lg'' style=''cursor:pointer;'' onclick=''eliminaColumnaCondicion(' #concat# #toCharRPTVId# #concat# ',' #concat# #toCharRPTVCId# #concat# ');''></i>' as acciones
     		from RT_ReporteVersionCondicion RT_R
	    	where RPTVId = #arguments.rtpvid# order by RPTVCId
    	</cfquery>

    	<div class="row">&nbsp;</div>
			    <div class="row">
			        <div class="col col-md-12">
			      		<input id="btnGuardarColCondicion"  name="btnGuardarColCondicion" class="btnGuardar btnGuardarColCondicion" value="Guardar" tabindex="0" type="button"
		      			onclick="javascript:guardaColumnaCondicion(#arguments.rtpvid#)">
		      			<input name="nuevo" class="btnNuevo btnEliminar" id="btnNuevo" onclick="javascript:resetPage()" tabindex="0" type="button" value="Nuevo" style="display: none;">
			    </div>
		</div>
			<div class="row">&nbsp;</div>
			<div class="row">&nbsp;</div>

    	<cfsavecontent variable="result">
	    	<div>
	        	<div class="row">&nbsp;</div>

	    		<cfif rsColumnas.recordCount GT 0 >
			    	<div class="row cont">
				        <div class="col col-md-12">
				      		<table class="table">
				      			<thead>
				      				<th>Modificador</th>
				      				<th>Campo</th>
				      				<th>Condici&oacuten</th>
				      				<th>Valor</th>
				      				<th>Grupo</th>
				      				<th>Acciones</th>
				      			</thead>
				      			<tbody>
				      				<cfloop query="rsColumnas">
				      					<tr>
					      					<td align="center">#RPTVCY_O#</td><!--- #((RPTVCY_O EQ 1) ? "Y" : "O")# --->
					      					<td align="left">#Campo#</td>
					      					<td align="center">#Condicion#</td>
					      					<td align="center">#Valor#</td>
					      					<td align="center">#Grupo#</td>
					      					<td align="center">#acciones#</td>
					      				</tr>
				      				</cfloop>
				      			</tbody>
				      		</table>
				      	</div>
				    </div>
				<cfelse>
					<p>No se han agregado condiciones</p>
			    </cfif>

			</div>
    	</cfsavecontent>
	    <cfreturn  result>
	</cffunction>

	<cffunction name="getColumnasVer" access="remote" returnformat="plain">
		<cfargument name="rtpvid" type="numeric">

		<cf_dbfunction name="to_char" args="rc.RPTVId" returnvariable="toCharRPTVId">
		<cf_dbfunction name="to_char" args="rc.RPTCId" returnvariable="toCharRPTCId">
		<cf_dbfunction name="op_concat" returnvariable="concat">
		<cfquery name="rsColumnas" datasource="#Session.dsn#">
	    	SELECT  rc.RPTCId,  rc.RPTVId, rc.ODCampo, rc.RTPCAlias,
					rc.RTPCOrdenColumna, rc.RTPCOrdenDato, rc.ODId,
					od.ODCodigo #concat#'.'#concat# rc.ODCampo as Campo,
					'<i class=''fa fa-edit fa-lg'' style=''cursor:pointer;'' onclick=''editarColumnaVer(' #concat# #toCharRPTVId# #concat# ',' #concat# #toCharRPTCId# #concat# ');''></i>&nbsp;
					 <i class=''fa fa-trash fa-lg'' style=''cursor:pointer;'' onclick=''eliminaColumnaVer(' #concat# #toCharRPTVId# #concat# ',' #concat# #toCharRPTCId# #concat# ');''></i>' as acciones,
					 RPTCCalculo as calculo
			FROM RT_ReporteVerColumna rc
			inner join RT_OrigenDato od
				on rc.ODId = od.ODId
			where rc.RPTVId = #arguments.rtpvid#
			order by rc.RTPCOrdenColumna, od.ODCodigo #concat#'.'#concat# rc.ODCampo

    	</cfquery>
    	<cfsavecontent variable="result">
	    	<div>
	        	<div class="row">&nbsp;</div>
	    		<cfif rsColumnas.recordCount GT 0 >
			    	<div class="row cont">
				        <div class="col col-md-12">
				      		<table class="table">
				      			<thead>
				      				<th>Campo</th>
				      				<th>Alias</th>
				      				<th>Orden</th>
				      				<th>Calcula</th>
				      				<th></th>
				      			</thead>
				      			<tbody>
				      				<cfloop query="rsColumnas">
				      					<tr>
					      					<td>#Campo#</td>
					      					<td>#RTPCAlias#</td>
					      					<td>#RTPCOrdenColumna#</td>
					      					<td>
						      					<cfset cl= "">
						      					<cfif #calculo# EQ "COUNT"><cfset cl="Cuenta"></cfif>
												<cfif #calculo# EQ "MIN"><cfset cl="Minimo"></cfif>
					                        	<cfif #calculo# EQ "MAX"><cfset cl="Maximo"></cfif>
					                        	<cfif #calculo# EQ "SUM"><cfset cl="Suma"></cfif>
					                        	<cfif #calculo# EQ "AVG"><cfset cl="Promedio"></cfif>
												#cl#
											</td>
					      					<td>#acciones#</td>
					      				</tr>
				      				</cfloop>
				      			</tbody>
				      		</table>
				      	</div>
				    </div>
				<cfelse>
					<p>No se ha asignado ninguna Columna</p>
			    </cfif>
			    <div class="row">&nbsp;</div>
			    <div class="row">
			        <div class="col col-md-12">
			      		<input id="btnNuevoCol"  name="btnNuevoCol" class="btnNuevo btnNuevoCol" value="Nuevo" tabindex="0" type="button"
			      			onclick="javascript:creaNuevoColumnaVer(#arguments.rtpvid#)">
			      	</div>
			    </div>
			</div>
    	</cfsavecontent>
	    <cfreturn  result>
	</cffunction>

<cffunction name="seleccionarColumnas" access="remote" returnformat="plain">
		<cfargument name="rtpid" type="numeric">
		<cfquery name="rsOD" datasource="#Session.dsn#">
	    	SELECT  ro.ODId, od.ODCodigo, od.ODDescripcion, od.ODSQL
			FROM RT_ReporteOrigen ro
			inner join RT_OrigenDato od
				on ro.ODId = od.ODId
			Where ro.RPTId = #arguments.rtpid#
			order by ro.RPTOId
    	</cfquery>

    	<cfset listCols = "">
    	<cfset strUn  ="">
    	<cf_dbfunction name="op_concat" returnvariable="concat">
    	<cf_dbfunction name="to_char" args="ODId" returnvariable="toCharODId">
    	<cfquery name="rsCols" datasource="#Session.dsn#">
	    	SELECT  <cf_dbfunction name="to_char" args="RPTId"> #concat#'|'#concat##toCharODId##concat#'|'#concat#ODCampo token
			FROM RT_ReporteColumna
			where RPTId = #arguments.rtpid#
    	</cfquery>
    	<cfloop query="rsCols">
    		<cfset listCols = "#listCols##strUn##token#">
	    	<cfset strUn  =",">
    	</cfloop>
    	<cfsavecontent variable="result">
	    	<div>
	        	<div class="row">&nbsp;</div>
	    		<cfif rsOD.recordCount GT 0 >
			    	<div class="row cont">
				        <div class="col col-md-12">
				      		<div class="row">
				      			<cfset idx = 1>
				      			<cfloop query="rsOD">
				      				<cftry>

				      					<cfset queryString = #REreplace(PreserveSingleQuotes(ODSQL),'(<\?[^,<]*\:date\?\>)',"01/01/1900", "all")#>
										<cfset queryString = #REreplace(PreserveSingleQuotes(queryString),'(<\?[^,<]*\:numeric\?\>)',"0", "all")#>
										<cfset queryString = #REreplace(PreserveSingleQuotes(queryString),'(<\?[^,<]*\:string\?\>)',"0", "all")#>

										<cfquery name="rsColumns" datasource="#session.DSN#">
											#PreserveSingleQuotes(queryString)#
										</cfquery>
										<cfset varErrorQ = false>
										<cfset varList = arraytolist(rsColumns.getMetaData().getColumnLabels())>
										<cfcatch>
											<cfset varErrorQ = true>
											<cfset errDet = #cfcatch.detail#>
										</cfcatch>
									</cftry>
			      					<div class="col col-md-6">
				      					<div class="panel panel-default">
											<div class="panel-heading">
												<p class="panel-title">
													<a id="collapsableTxt" data-toggle="collapse" data-parent="##collapse" href="##collapse<cfoutput>#idx#</cfoutput>">
														<span style="display:inline-block;"> #ODCodigo# </span>
													</a>
												</p>
											</div>
											<div id="collapse<cfoutput>#idx#</cfoutput>" class="panel-collapse">
												<div id="divResult" class="panel-body">
													<cfif varErrorQ>
														<cfif modo NEQ 'ALTA'>
															<p style="color:red; font-weight:strong;">#MSG_Falla# #errDet#</p>
														</cfif>
													<cfelse>
														<cfloop list="#varList#" index="i">
															<cfif ListFind(listCols, "#arguments.rtpid#|#rsOD.ODId#|#i#") EQ 0>
																<div align="left">
																	<!--- <label> --->
																		<span style="display:inline-block;"> <!--- #rsOD.ODCodigo#. --->#i#&nbsp;
																			<i id="img" class="fa fa-plus" style='cursor:pointer;' onclick='insertaColumna(<cfoutput>#arguments.rtpid#</cfoutput>,#rsOD.ODId#,"#i#");'></i>
																		</span>
																	<!--- </label> --->
																</div>
															</cfif>
														</cfloop>
													</cfif>
												</div>
											</div>
										</div>
				      				</div>
				      				<cfset idx = idx + 1>
			      				</cfloop>
				      		</div>
				      	</div>
				    </div>
				<cfelse>
					<p>No se ha asignado ninguna Columna</p>
			    </cfif>
			    <div class="row">&nbsp;</div>
			    <div class="row">
			        <div class="col col-md-12">
			      		<input id="btnRegresarCol"  name="btnRegresarCol" class="btnLimpiar btnRegresarCol" value="Regresar" tabindex="0" type="button"
			      		onclick="javascript:regresarColumna(#arguments.rtpid#)">
			      	</div>
			    </div>
			</div>
    	</cfsavecontent>
	    <cfreturn  result>
	</cffunction>

	<cffunction name="seleccionarColumnasVer" access="remote" returnformat="plain">
		<cfargument name="rtpvid" type="numeric">

		<cfquery name="rsOD" datasource="#Session.dsn#">
	    	SELECT  ro.ODId, od.ODCodigo, od.ODDescripcion, od.ODSQL
			FROM RT_ReporteOrigen ro
			inner join RT_OrigenDato od
				on ro.ODId = od.ODId
			Where ro.RPTId = (select RPTId
									from RT_ReporteVersion
									where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.rtpvid#">)
			order by ro.RPTOId
    	</cfquery>
    	<cfset listCols = "">
    	<cfset strUn  ="">
    	<cf_dbfunction name="op_concat" returnvariable="concat">
    	<cf_dbfunction name="to_char" args="ODId" returnvariable="toCharODId">
    	<cfquery name="rsCols" datasource="#Session.dsn#">
	    	SELECT  <cf_dbfunction name="to_char" args="RPTVId"> #concat#'|'#concat##toCharODId##concat#'|'#concat#ODCampo token
			FROM RT_ReporteVerColumna
			where RPTVId =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.rtpvid#">
    	</cfquery>
    	<cfloop query="rsCols">
    		<cfset listCols = "#listCols##strUn##token#">
	    	<cfset strUn  =",">
    	</cfloop>

    	<cfsavecontent variable="result">
	    	<div>
	        	<div class="row">&nbsp;</div>
	    		<cfif rsOD.recordCount GT 0 >
			    	<div class="row cont">
				        <div class="col col-md-12">
				      		<div class="row">
				      			<cfset idx = 1>
				      			<cfloop query="rsOD">
				      				<cftry>
				      					<cfset queryString = #REreplace(PreserveSingleQuotes(rsOD.ODSQL),'(<\?[^,<]*\:date\?\>)',"01/01/1900", "all")#>
										<cfset queryString = #REreplace(PreserveSingleQuotes(queryString),'(<\?[^,<]*\:numeric\?\>)',"0", "all")#>
										<cfset queryString = #REreplace(PreserveSingleQuotes(queryString),'(<\?[^,<]*\:string\?\>)',"0", "all")#>
											<cfquery name="rsColumns" datasource="#session.DSN#">
												#PreserveSingleQuotes(queryString)#
											</cfquery>
										<cfquery name="rsColumns" datasource="#session.DSN#">
											#PreserveSingleQuotes(queryString)#
										</cfquery>
										<cfset varErrorQ = false>
										<cfset varList = arraytolist(rsColumns.getMetaData().getColumnLabels())>
										<cfcatch>
											<cfset varErrorQ = true>
											<cfset errDet = #cfcatch.detail#>
										</cfcatch>
									</cftry>
									<div class="col col-md-6">
				      					<div class="panel panel-default">
											<div class="panel-heading">

												<p class="panel-title">
													<a id="collapsableTxt" data-toggle="collapse" data-parent="##collapse" href="##collapse<cfoutput>#idx#</cfoutput>">
														<span style="display:inline-block;"> #ODCodigo# </span>
													</a>
												</p>
											</div>
											<div id="collapse<cfoutput>#idx#</cfoutput>" class="panel-collapse">
												<div id="divResult" class="panel-body">
													<cfif varErrorQ>
														<cfif isdefined('modo') and modo NEQ 'ALTA'>
															<p style="color:red; font-weight:strong;">#MSG_Falla# #errDet#</p>
														</cfif>
													<cfelse>
														<cfloop list="#varList#" index="i">
															<cfif ListFind(listCols, "#arguments.rtpvid#|#rsOD.ODId#|#i#") EQ 0>
																<div align="left">
																	<!--- <label> --->
																		<span style="display:inline-block;"> <!--- #rsOD.ODCodigo#. --->#i#&nbsp;
																			<i id="img" class="fa fa-plus" style='cursor:pointer;' onclick='insertaColumnaVer(<cfoutput>#arguments.rtpvid#</cfoutput>,#rsOD.ODId#,"#i#");'></i>
																		</span>
																	<!--- </label> --->
																</div>
															</cfif>
														</cfloop>
													</cfif>
												</div>
											</div>
										</div>
				      				</div>
				      				<cfset idx = idx + 1>
			      				</cfloop>
				      		</div>
				      	</div>
				    </div>
				<cfelse>
					<p>No se ha asignado ninguna Columna</p>
			    </cfif>
			    <div class="row">&nbsp;</div>
			    <div class="row">
			        <div class="col col-md-12">
			      		<input id="btnRegresarCol"  name="btnRegresarCol" class="btnLimpiar btnRegresarCol" value="Regresar" tabindex="0" type="button"
			      			onclick="javascript:regresarColumnaVer(#arguments.rtpvid#)">
			      	</div>
			    </div>
			</div>
    	</cfsavecontent>
	    <cfreturn  result>
	</cffunction>

	<cffunction name="editarColumnas" access="remote" returnformat="plain">
		<cfargument name="rtpid" type="numeric">
		<cfargument name="rtpcid" 	type="numeric">

		<cfquery name="rsCol" datasource="#Session.dsn#">
	    	SELECT RPTCId,RPTId,RTPCAlias,RTPCOrdenColumna,RTPCOrdenDato,ODCampo,RPTCCalculo
			FROM RT_ReporteColumna
			where RPTCId = #arguments.rtpcid#
    	</cfquery>

    	<cfsavecontent variable="result">
	    	<div>
	        	<div class="row">&nbsp;</div>
	        	<div class="row"><h4>#rsCol.ODCampo#</h4></div>
	    		<div class="row">
		    		<div class="col col-md-12" align="left">
		    			<div >
							<div class="form-group" style="margin-bottom:5px">
								<label for="frmAlias">Alias:</label>
								<input type="text" id="frmAlias" name="frmAlias" value="#rsCol.RTPCAlias#">
							</div>
							<div class="form-group" style="margin-bottom:5px">
								<label for="frmOrdenC">Numero Columna:</label>
								<input type="text" id="frmOrdenC" name="frmOrdenC" size="5" value="#rsCol.RTPCOrdenColumna#">
							</div>
							<div class="form-group" style="margin-bottom:5px">
								<label for="frmOrdenD">Orden:</label>
								<select id="frmOrdenD" name="frmOrdenD">
		                        	<option value="asc" <cfif #rsCol.RTPCOrdenColumna# EQ "asc"> selected </cfif>>Ascendente</option>
		                        	<option value="desc" <cfif #rsCol.RTPCOrdenColumna# EQ "desc"> selected </cfif>>Descendente</option>
		                      </select>
							</div>
							<div class="form-group" style="margin-bottom:5px">
								<label for="frmCalculo">Calculo:</label>
								<select id="frmCalculo" name="frmCalculo">
									<option value="">Ninguno</option>
									<!--- <option value="COUNT" <cfif #rsCol.RPTCCalculo# EQ "COUNT"> selected </cfif>>Cuenta</option>
									<option value="MIN" <cfif #rsCol.RPTCCalculo# EQ "MIN"> selected </cfif>>Minimo</option>
		                        	<option value="MAX" <cfif #rsCol.RPTCCalculo# EQ "MAX"> selected </cfif>>Maximo</option>
		                        	<option value="SUM" <cfif #rsCol.RPTCCalculo# EQ "SUM"> selected </cfif>>Suma</option>
		                        	<option value="AVG" <cfif #rsCol.RPTCCalculo# EQ "AVG"> selected </cfif>>Promedio</option> --->
		                      </select>
							</div>
						</div>
		    		</div>
		    	</div>
			    <div class="row">
			        <div class="col col-md-12">
			        	<input id="btnGuardarCol"  name="btnGuardarCol" class="btnGuardar btnGuardarCol" value="Guardar" tabindex="0" type="button"
		      				onclick="javascript:guardaColumna(#arguments.rtpid#,#arguments.rtpcid#)">
			      		<input id="btnRegresarCol"  name="btnRegresarCol" class="btnLimpiar btnRegresarCol" value="Regresar" tabindex="0" type="button"
			      		onclick="javascript:regresarColumna(#arguments.rtpid#)">
			      	</div>
			    </div>
			</div>
    	</cfsavecontent>
	    <cfreturn  result>
	</cffunction>

	<cffunction name="editarColumnasVer" access="remote" returnformat="plain">
		<cfargument name="rtpvid" type="numeric">
		<cfargument name="rtpcid" 	type="numeric">

		<cfquery name="rsCol" datasource="#Session.dsn#">
	    	SELECT RPTCId,RPTVId,RTPCAlias,RTPCOrdenColumna,RTPCOrdenDato,ODCampo,RPTCCalculo
			FROM RT_ReporteVerColumna
			where RPTCId = #arguments.rtpcid#
    	</cfquery>

    	<cfsavecontent variable="result">
	    	<div>
	        	<div class="row">&nbsp;</div>
	        	<div class="row"><h4>#rsCol.ODCampo#</h4></div>
		    	<div class="row">
		    			<br/><br/>
		    		<div class="col col-md-2"></div>
			    		<div class="col col-md-5">
								<div class="form-group" style="margin-bottom:5px" align="left">
									<label for="frmAlias">Alias:</label>
										<input type="text" id="frmAlias" name="frmAlias" value="#rsCol.RTPCAlias#">
								</div>
								<br/>
								<div class="form-group" style="margin-bottom:5px" align="left">
									<label for="frmOrdenC">Numero Columna:</label>
										<input type="text" id="frmOrdenC" name="frmOrdenC" size="6" value="#rsCol.RTPCOrdenColumna#">
								</div>
						</div>
						<div class="col col-md-4">
								<div class="form-group" style="margin-bottom:5px" align="left">
									<label for="frmOrdenD">Orden:</label>
										<select id="frmOrdenD" name="frmOrdenD">
				                        	<option value="asc" <cfif #rsCol.RTPCOrdenColumna# EQ "asc"> selected </cfif>>Ascendente</option>
				                        	<option value="desc" <cfif #rsCol.RTPCOrdenColumna# EQ "desc"> selected </cfif>>Descendente</option>
				                      	</select>
								</div>
									<br/>
								<div class="form-group" style="margin-bottom:5px" align="left">
									<label for="frmCalculo">Calculo:</label>
										<select id="frmCalculo" name="frmCalculo">
											<option value="">Ninguno</option>
											<!--- <option value="COUNT" <cfif #rsCol.RPTCCalculo# EQ "COUNT"> selected </cfif>>Cuenta</option>
											<option value="MIN" <cfif #rsCol.RPTCCalculo# EQ "MIN"> selected </cfif>>Minimo</option>
				                        	<option value="MAX" <cfif #rsCol.RPTCCalculo# EQ "MAX"> selected </cfif>>Maximo</option>
				                        	<option value="SUM" <cfif #rsCol.RPTCCalculo# EQ "SUM"> selected </cfif>>Suma</option>
				                        	<option value="AVG" <cfif #rsCol.RPTCCalculo# EQ "AVG"> selected </cfif>>Promedio</option> --->
				                      	</select>
								</div>
			    		</div>
		    		<div class="col col-md-1"></div>
		    	</div>
		    			<br/><br/>
			    <div class="row">
			        	<div class="col col-md-12">
			        	<input id="btnGuardarCol"  name="btnGuardarCol" class="btnGuardar btnGuardarCol" value="Guardar" tabindex="0" type="button"
		      				onclick="javascript:guardaColumnaVer(#arguments.rtpvid#,#arguments.rtpcid#)">
			      		<input id="btnRegresarCol"  name="btnRegresarCol" class="btnLimpiar btnRegresarCol" value="Regresar" tabindex="0" type="button"
			      		onclick="javascript:regresarColumnaVer(#arguments.rtpvid#)">
			      	</div>
			    </div>
			</div>
    	</cfsavecontent>
	    <cfreturn  result>
	</cffunction>	<cffunction name="insertaColumna" access="remote" returnformat="plain">
		<cfargument name="rtpid" 	type="numeric">
		<cfargument name="odid" 	type="numeric">
		<cfargument name="campo" 	type="string">

		<cfquery name="rsColumnas" datasource="#Session.dsn#">
	    	INSERT INTO RT_ReporteColumna
				(RPTId,ODId,ODCampo,RTPCOrdenColumna)
			select
					#Arguments.rtpid#,
					#Arguments.odid#,
					'#Arguments.campo#',
					(select COALESCE(max(RTPCOrdenColumna),0)+1 from RT_ReporteColumna where RPTId = #Arguments.rtpid#)
			from dual
    	</cfquery>

        <cfreturn seleccionarColumnas(#Arguments.rtpid#)>
	</cffunction>

	<cffunction name="insertaColumnaVer" access="remote" returnformat="plain">
		<cfargument name="rtpvid" 	type="numeric">
		<cfargument name="odid" 	type="numeric">
		<cfargument name="campo" 	type="string">

		<cfquery datasource="#Session.dsn#">
	    	INSERT INTO RT_ReporteVerColumna
				(RPTVId,ODId,ODCampo,RTPCOrdenColumna)
			select
					#Arguments.rtpvid#,
					#Arguments.odid#,
					'#Arguments.campo#',
					(select COALESCE(max(RTPCOrdenColumna),0)+1
						from RT_ReporteVerColumna
						where RPTVId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.rtpvid#">
					)
			from dual
    	</cfquery>

        <cfreturn seleccionarColumnasVer(#Arguments.rtpvid#)>
	</cffunction>

	<cffunction name="eliminaColumna" access="remote" returnformat="plain">
		<cfargument name="rtpid" 	type="numeric">
		<cfargument name="rtpcid" 	type="string">
		<cfquery name="rsColumnas" datasource="#Session.dsn#">
	    	Delete from  RT_ReporteColumna
	    	where RPTCId = #Arguments.rtpcid#
    	</cfquery>

        <cfreturn getColumnas(#Arguments.rtpid#)>
	</cffunction>

	<cffunction name="eliminaColumnaVer" access="remote" returnformat="plain">
		<cfargument name="rtpvid" 	type="numeric">
		<cfargument name="rtpcid" 	type="string">
		<cfquery datasource="#Session.dsn#">
	    	Delete from  RT_ReporteVerColumna
	    	where RPTCId = #Arguments.rtpcid#
    	</cfquery>

        <cfreturn getColumnasVer(#Arguments.rtpvid#)>
	</cffunction>

	<cffunction name="actualizaColumna" access="remote" returnformat="plain">
		<cfargument name="rtpid" 	type="numeric">
		<cfargument name="rtpcid" 		type="numeric">
		<cfargument name="alias" 		type="string" 	default="">
		<cfargument name="numeroCol" 	type="numeric" 	default="100">
		<cfargument name="ordenCol" 	type="string"	default="asc">
		<cfargument name="calculo" 		type="string"	default="">

		<cfquery name="rsColumnas" datasource="#Session.dsn#">
	    	Update RT_ReporteColumna set
	    			RTPCAlias = '#arguments.alias#'
	    			,RTPCOrdenColumna = #arguments.numeroCol#
	    			,RTPCOrdenDato = '#arguments.ordenCol#'
	    		<cfif arguments.calculo NEQ "">
		    		,RPTCCalculo = '#trim(arguments.calculo)#'
		    	<cfelse>
		    		,RPTCCalculo = null
	    		</cfif>
	    	where RPTCId = #Arguments.rtpcid#
    	</cfquery>


        <cfreturn getColumnas(#Arguments.rtpid#)>
	</cffunction>

	<cffunction name="actualizaColumnaVer" access="remote" returnformat="plain">
		<cfargument name="rtpvid" 	type="numeric">
		<cfargument name="rtpcid" 		type="numeric">
		<cfargument name="alias" 		type="string" 	default="">
		<cfargument name="numeroCol" 	type="numeric" 	default="100">
		<cfargument name="ordenCol" 	type="string"	default="asc">
		<cfargument name="calculo" 		type="string"	default="">

		<cfquery datasource="#Session.dsn#">
	    	Update RT_ReporteVerColumna set
	    			RTPCAlias = '#arguments.alias#'
	    			,RTPCOrdenColumna = #arguments.numeroCol#
	    			,RTPCOrdenDato = '#arguments.ordenCol#'
	    		<cfif arguments.calculo NEQ "">
		    		,RPTCCalculo = '#trim(arguments.calculo)#'
		    	<cfelse>
		    		,RPTCCalculo = null
	    		</cfif>
	    	where RPTCId = #Arguments.rtpcid#
    	</cfquery>

        <cfreturn getColumnasVer(#Arguments.rtpvid#)>
	</cffunction>

	<cffunction name="saveColCondicion" access="remote" returnformat="plain">

		<cfargument name="Modificador" default="required" type="numeric">
		<cfargument name="Campo" default="required" type="string" >
		<cfargument name="Condicion" default="required" type="string" />
		<cfargument name="Valor" default="required" type="string" />
		<cfargument name="rtpvid" default="required" type="numeric" />
		<cfargument name="Grupo" type="string" />
		<cfargument name="Edicion" default="required" type="string">

			<cfquery name="rsReporte" datasource="#Session.DSN#">
				SELECT  rtr.RPCodigo
				FROM RT_ReporteVersion rtrv
				inner join RT_Reporte rtr
					on rtr.RPTId = rtrv.RPTId
					and rtrv.RPTVId = #Arguments.rtpvid#
			</cfquery>


			<cfinvoke component="commons.GeneraReportes.Componentes.GeneraReporte"
				method="getSQL"
				varRPCodigo="#rsReporte.RPCodigo#"
				varIdver="#Arguments.rtpvid#"
				returnvariable="strSQL"
			/>


			<cftry>
					<cftransaction>
						<cfquery name="rsDatos" datasource="#Session.DSN#">
							#PreserveSingleQuotes(strSQL)#
						</cfquery>
						<cftransaction action="rollback" />
					</cftransaction>

					<cfset arrCol = Getmetadata(rsDatos)>
					<cfset vTipo ="varchar">

					<cfloop array="#arrCol#" index="col">
						<cfif trim(lcase(col.Name)) EQ trim(lcase(Arguments.Campo))>
							<cfset arr = listToArray ("#col.TypeName#", " ",false,true)>
						</cfif>
					</cfloop>

					<cfif #Arguments.Edicion# EQ "0">

		     			<cfquery datasource="#session.dsn#">
							INSERT INTO RT_ReporteVersionCondicion(RPTVCCampo, RPTVCCondicion, RPTVCValor, RPTVId, RPTVCY_O, RPTVCGrupo)
							VALUES('#Arguments.Campo#:#arr[1]#', '#Arguments.Condicion#', '#Arguments.Valor#', #Arguments.rtpvid#,
							#Arguments.Modificador#, '#Arguments.Grupo#');
						</cfquery>
					<cfelse>
						<cfquery datasource="#session.dsn#">
							UPDATE RT_ReporteVersionCondicion
								SET RPTVCCampo = '#Arguments.Campo#:#arr[1]#',
								RPTVCCondicion = '#Arguments.Condicion#',
								RPTVCValor ='#Arguments.Valor#',
								RPTVId = #Arguments.rtpvid#,
								RPTVCY_O = #Arguments.Modificador#,
								RPTVCGrupo = '#Arguments.Grupo#' WHERE
								RPTVCId = #Arguments.Edicion#
						</cfquery>

					</cfif>
					<cfreturn getColumnasCondicion(#Arguments.rtpvid#)>

					<cfcatch type="database">
								<script language="javascript">
							 		alert('El Listado de Campos contiene valores ambiguos, elimine los campos repetidos para continuar con la operaci\u00F3n');
							 		$('.frmCondicion').trigger("reset");
							 		$('.btnCamposCondicionRPT').hide();
								</script>
							<cfreturn getColumnasCondicion(#Arguments.rtpvid#)>
					</cfcatch>

				</cftry>

	</cffunction>

	<cffunction name="eliminaColumnaCondicion" access="remote" returnformat="plain">
		<cfargument name="rptvid" 	type="numeric">
		<cfargument name="rptcid" 	type="string">

		<cfquery datasource="#Session.dsn#">
	    	Delete from  RT_ReporteVersionCondicion
	    	where RPTVCId = #Arguments.rptcid#
    	</cfquery>

        <cfreturn getColumnasCondicion(#Arguments.rptvid#)>
	</cffunction>

</cfcomponent>