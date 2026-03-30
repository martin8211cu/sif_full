<cfcomponent output="true">
	<!--- Inserto la relacion de variables --->
    <cffunction name="InsertColumns" access="remote" returnformat="plain">
		<cfsavecontent variable = "result">
			<cfset LvarODLocal="#form.IDODLocal#">
			<cfset LvarODFo="#form.ODFO#">
			<cfset LvarODComLocal="#form.ODLocal#">
			<cfset LvarODComFo="#form.ODFOColumns#">

			<cfif form.InsertODAjax eq 1 and LvarODLocal neq "" and LvarODFo neq "" and LvarODComLocal neq ""
				and LvarODComFo neq "">
				<cfquery datasource="#session.DSN#">
					insert into RT_RelacionOD(ODIdL,ODIdR,ODCampoL,ODCampoR)
					values(#LvarODLocal#,#LvarODFo#,'#LvarODComLocal#','#LvarODComFo#')
				</cfquery>
			</cfif>
		</cfsavecontent>
	<cfreturn result>
    </cffunction>
	<!--- Obtengo campos de origen de datos --->
	 <cffunction name="SelectColumns" access="remote" returnformat="plain">
		<cfsavecontent variable = "result">
			<cfif form.ODFO neq "">
					<!--- Mostrar campos ODLocal --->
					<cfquery name="rsODFO" datasource="#session.DSN#">
						select 	ODId,ODCodigo,ODDescripcion,ODSQL,Ecodigo,COId
						FROM 	RT_OrigenDato
						where 	ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDODLocal#">
					</cfquery>
					<!--- Ejecutamos al consulta --->

					<cfset queryString = #REreplace(PreserveSingleQuotes(rsODFO.ODSQL),'(<\?[^,<]*\:date\?\>)',"01/01/1900", "all")#>
					<cfset queryString = #REreplace(PreserveSingleQuotes(queryString),'(<\?[^,<]*\:numeric\?\>)',"0", "all")#>
					<cfset queryString = #REreplace(PreserveSingleQuotes(queryString),'(<\?[^,<]*\:string\?\>)',"0", "all")#>

					<cfquery name="rsColumnsLocal" datasource="#session.DSN#">
						#PreserveSingleQuotes(queryString)#
					</cfquery>
					<!--- Quitamos a los campos las mayusculas --->
					<cfset LvarRsColumnLocal = getmetadata(#rsColumnsLocal#)>
					<div class="col-md-6">
						<select name="ODLocal" id="ODLocal" multiple="multiple" style="width:200px">
						<cfloop array="#LvarRsColumnLocal#" index="rs">
							<cfquery  name="rsReUniLocal" datasource="#session.DSN#">
								select * from RT_RelacionOD
								where ODIdL = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDODLocal#">
								and ODIdR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODFO#">
								and ODCampoL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.name#">
							</cfquery>

							<cfif rsReUniLocal.RecordCount eq 0>
									<option><cfoutput>#rs.name#</cfoutput></option>
							</cfif>
						</cfloop>
						</select>
					</div>
					<!--- Mostrar ODForaneos --->
					<cfquery name="rsColumnODFO" datasource="#session.DSN#">
						select 	ODId,ODCodigo,ODDescripcion,ODSQL,Ecodigo,COId
						FROM 	RT_OrigenDato
						where 	ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODFO#">
					</cfquery>

					<cfset LvarSql=replace("#rsColumnODFO.ODSQL#","select","select top 1","one")>

					<cfset queryrsColumnsFO = #REreplace(PreserveSingleQuotes(rsColumnODFO.ODSQL),'(<\?[^,<]*\:date\?\>)',"01/01/1900", "all")#>
					<cfset queryrsColumnsFO = #REreplace(PreserveSingleQuotes(queryrsColumnsFO),'(<\?[^,<]*\:numeric\?\>)',"0", "all")#>
					<cfset queryrsColumnsFO = #REreplace(PreserveSingleQuotes(queryrsColumnsFO),'(<\?[^,<]*\:string\?\>)',"0", "all")#>

					<cfquery name="rsColumnsFO" datasource="#session.DSN#">
						#PreserveSingleQuotes(queryrsColumnsFO)#
					</cfquery>

					<cfset LvarRsColumn = getmetadata(#rsColumnsFO#)>
					<div class="col-md-6">
						<select name="ODFOColumns" id="ODFOColumns" multiple="multiple" style="width:200px">
						<cfloop array="#LvarRsColumn#" index="rs">
							<cfquery  name="rsReUni" datasource="#session.DSN#">
								select * from RT_RelacionOD
								where ODIdL = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.IDODLocal#">
								and ODIdR = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODFO#">
								and ODCampoR = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rs.name#">
							</cfquery>

							<cfif rsReUni.RecordCount eq 0>
								<option><cfoutput>#rs.name#</cfoutput></option>
							</cfif>
						</cfloop>
						</select>
					</div>
		 	</cfif>
		</cfsavecontent>
	<cfreturn result>
    </cffunction>

	<cffunction name="EditVariables" access="remote" returnformat="plain">
		<cfset Lvartype="editar">
		<cfset LvarModo="#form.modo#">

		<!--- Editar --->
		<cfif LvarModo eq #trim(listGetAt(Lvartype,1))#>
			<cfif isdefined(form.LvarContador)>
				<cfset LvarContador="#form.LvarContador#">
			</cfif>

			<cfset LvarODId="#form.ODId#">

			<cfloop index = "Count" from = "1" to = "#LvarContador#" step = "1">
				<cfset LvarVVarAux 		= FORM["VVar"&Count]>
				<cfset LvarFormulaAux 	= FORM["Formula"&Count]>
				<cfset LvarValorFormAux = FORM["ValorForm"&Count]>

				<cfif LvarFormulaAux neq "ND">
					<cfquery datasource="#session.DSN#">
						update RT_Variable
							set VFormula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarFormulaAux#">,
								VValor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarValorFormAux#">
						where VVar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarVVarAux#">
						and ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarODId#">
					</cfquery>
				<cfelse>
					<cfif LvarValorFormAux neq "" and LvarFormulaAux neq "">
						<cfquery datasource="#session.DSN#">
							update RT_Variable
								set VFormula = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarFormulaAux#">,
									VValor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarValorFormAux#">
							where VVar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#LvarVVarAux#">
							and ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarODId#">
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
	<cfreturn result>
    </cffunction>

	<cffunction name="DeleteRe" access="remote" returnformat="plain">
		<cfsavecontent variable = "result">
			<cfif url.RODId neq "">
				<cfquery datasource="#session.DSN#">
					delete RT_RelacionOD where RODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.RODId#">
				</cfquery>
			</cfif>
		</cfsavecontent>
	<cfreturn result>
	</cffunction>

	<cffunction name="ODRe" access="remote" returnformat="plain">
		<cfsavecontent variable = "result">
			<cfquery name="rsVar" datasource="#session.DSN#">
				select RODId,t2.ODCodigo,
					(select ODCodigo from RT_OrigenDato where ODId = t1.ODIdR) as ODFO,ODCampoL,ODCampoR
				from RT_RelacionOD t1
				inner join RT_OrigenDato t2 on t1.ODIdL = t2.ODId
				where ODIdL =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODId#">
				UNION ALL
				select RODId,t2.ODCodigo,
					(select ODCodigo from RT_OrigenDato where ODId = t1.ODIdR) as ODFO,ODCampoL,ODCampoR
				from RT_RelacionOD t1
				inner join RT_OrigenDato t2 on t1.ODIdL = t2.ODId
				where ODIdR =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ODId#">
			</cfquery>
			<table class="table table-striped">
				<tr>
					<th>Base</th>
					<th>Foraneo</th>
					<th>CampoLocal</th>
					<th>CampoForaneo</th>
					<cfif form.varEdit>
						<th>Eliminar</th>
					</cfif>
				</tr>
				<cfoutput query="rsVar">
				<tr>
					<td>#rsVar.ODCodigo#</td>
					<td>#rsVar.ODFO#</td>
					<td>#rsVar.ODCampoL#</td>
					<td>#rsVar.ODCampoR#</td>
					<cfif form.varEdit>
						<td>
						 	<i class="fa fa-trash fa-lg" <cfif form.varEdit> style="cursor:pointer"  onclick="DeleteRe(#rsVar.RODId#)" </cfif>></i>
						</td>
					</cfif>
				</tr>
				</cfoutput>
	 		</table>
	 		<div class="">
				<cfif form.varEdit>
					<input type="button" tabindex="0" onclick="FunviewNewRel()" value="Nuevo"
					class="btnNuevo" name="btnNuevo" style="display: block;  margin-left: auto;  margin-right: auto;">
				</cfif>
			</div>
		</cfsavecontent>
	<cfreturn result>
	</cffunction>
	<!--- Obtiene las variables de OD --->
	<cffunction name="GetVariablesOD" access="remote" returnformat="plain">
		<cfsavecontent variable = "result">

			<!--- Variable Auxiliares--->
			<cfset LvarAux = 1>
			<cfset LvarODId="#form.ODId#">

			<cfquery  name="rsVariables" datasource="#session.DSN#">
				select * from RT_Variable where ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarODId#">
			</cfquery>

			<table width="100%" class="">
			<cfif rsVariables.RecordCount GT 0>
				<tr>
					<th><h5>Variables</h5></th>
					<th><h5>Formulas</h5></th>
					<th id="titleValor" <!--- style="display:none" --->><h5>Valor</h5></th>
				</tr>
				<cfoutput query = "rsVariables">
				<tr>
					<!--- Obtenemos el valor de VValor --->
					<cfquery  name="rsVariablesValor" datasource="#session.DSN#">
						select * from RT_Variable
						where ODId = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVariables.ODId#">
						and VVar = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsVariables.VVar#">
					</cfquery>
					<td><strong>#rsVariables.VVar#</strong>
					</td>
					<td><select name="Formula#LvarAux#"	id ="Formula#LvarAux#" <!--- onchange="ShowInput(#LvarAux#)" --->>
							<option value="ND" <cfif rsVariablesValor.VFormula eq "ND"> selected </cfif>>Valor personalizado</option>
							<option value="Ecodigo"<cfif rsVariablesValor.VFormula eq "Ecodigo"> selected </cfif>>Codigo de la empresa</option>
							<option value="Parametros"<cfif rsVariablesValor.VFormula eq "Parametros"> selected </cfif>>Parametro</option>
							<option value="Usuario"<cfif rsVariablesValor.VFormula eq "Usuario"> selected </cfif>>Usuario actual</option>
						</select>
					</td>
					<td><input name="ValorForm#LvarAux#" id="ValorForm#LvarAux#"
					value="#rsVariablesValor.VValor#" type="text" <!--- style="display:none" --->>
					</td>
				</tr>
					<!--- Campos ocultos --->
					<input name="VVar#LvarAux#" id="VVar#LvarAux#" type="hidden"   value="#rsVariables.VVar#">
					<cfset LvarAux += 1>
				</cfoutput>
			</cfif>
				<tr>
					<td colspan="3"><span class="mensaje"></span></td>
				</tr>
			</table><br>
			<div class="row">
				<cfif form.varEdit and rsVariables.RecordCount GT 0>
					<input type="button" tabindex="0" onclick="FunUpdateVar()" value="Guardar"
					class="btnGuardar" name="btnGuardar" style="display: block;  margin-left: auto;  margin-right: auto;">
					<input name="modo" id="modo" type="hidden" value="editar">
				</cfif>
			</div>
			<!--- Campos ocultos --->
			<input name="LvarContador"  id="LvarContador"   type="hidden"  value="<cfoutput>#rsVariables.RecordCount#</cfoutput>">
		</cfsavecontent>
	<cfreturn result>
	</cffunction>
</cfcomponent>