<cfquery datasource="#Session.DSN#" name="GrupoEmpresas">
	SELECT a.Ecodigo as CodigoEmpresa FROM AnexoGEmpresaDet a
	inner join(
		SELECT GEid
		FROM AnexoGEmpresaDet
		WHERE Ecodigo = #Session.Ecodigo#
	) b on b.GEid = a.GEid
</cfquery>
<cfquery name="nivel" datasource="#Session.DSN#">
	SELECT Pvalor FROM Parametros WHERE Pcodigo = 200080 AND Mcodigo = 'CE'
</cfquery>
<cfset crearCtas = false>
<cfquery name="rsCreaCtaGE" datasource="#Session.DSN#">
	SELECT  Pvalor FROM Parametros where Mcodigo = 'CE' and Pcodigo = 200088
</cfquery>
<cfif rsCreaCtaGE.recordCount GT 0 and rsCreaCtaGE.pvalor EQ 'S'>
	<cfset crearCtas = true>
</cfif>

<cfparam name="modo" default="ALTA">

<!---Limpia la tabla de errores--->
<cfquery datasource="#Session.DSN#">
	DELETE FROM ErrorProceso WHERE Spcodigo = '#session.menues.SPcodigo#' AND Ecodigo = #Session.Ecodigo# AND Usucodigo = #Session.Usucodigo#
</cfquery>


<cfif isdefined("Cuenta_cuenta")>

	<!--- Se obtienen las empresas del grupo --->
	<cfquery name="rsGrpEmp" datasource="#Session.DSN#">
		SELECT  GEid,Ecodigo FROM AnexoGEmpresaDet where GEid = #form.GEid#
	</cfquery>

	<cftransaction>
		<cfloop query="rsGrpEmp"> <!--- por cada empresa --->

			<cfquery name="rsCuenta" datasource="#Session.DSN#"> <!--- se verfica si existe la cuenta --->
				SELECT Ccuenta FROM  CContables
				WHERE Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">
				and Ecodigo = #rsGrpEmp.Ecodigo#
			</cfquery>

			<cfset LvarCcuenta = -1>


			<cfif rsCuenta.recordcount EQ 0> <!--- si no existe y esta activo el parametro de crear cuentas --->
				<cfif crearCtas>
					<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
						<cfinvokeargument name="Lprm_CFformato" 		value="#trim(form.Cformato)#"/>
						<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
						<cfinvokeargument name="Lprm_DSN" 				value="#Session.DSN#"/>
						<cfinvokeargument name="Lprm_Ecodigo" 			value="#rsGrpEmp.Ecodigo#"/>
					</cfinvoke>
					<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
						<cfset mensaje="ERROR">
						<cfquery name="rsEmpresa" datasource="#session.dsn#">
							SELECT  Edescripcion FROM Empresas where Ecodigo = #rsGrpEmp.Ecodigo#
						</cfquery>
						<cfquery name="insError" datasource="#session.dsn#">
							INSERT INTO ErrorProceso
						    (Ecodigo,Spcodigo,Usucodigo,Valor,Descripcion)
						   	Values (
						   		#Session.Ecodigo#,
						   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">,
						   		#Session.Usucodigo#,
						   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsEmpresa.Edescripcion)#">,
						   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarError)#">
						   	)
						</cfquery>

					</cfif>
					<cfset LvarCcuenta = request.PC_GeneraCFctaAnt.Ccuenta>
				</cfif>
			<cfelse>
				<cfset LvarCcuenta = rsCuenta.Ccuenta>
			</cfif>


			<cfif  LvarCcuenta NEQ -1 and LvarCcuenta NEQ "">

				<cfquery name="rsCuenta" datasource="#Session.DSN#">
					SELECT Id_Inactiva,Ccuenta,Ecodigo
					FROM CEInactivas
					WHERE Ecodigo = #rsGrpEmp.Ecodigo#
					AND Ccuenta = #LvarCcuenta#
				</cfquery>

				<cfif rsCuenta.recordCount GT 0>

					<cfquery datasource="#Session.DSN#">
						UPDATE CEInactivas
							SET Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">,
								GEid = #form.GEid#
						WHERE Id_Inactiva = #rsCuenta.Id_Inactiva#
							AND Ccuenta = #LvarCcuenta#
					</cfquery>

				<cfelse>

					<cfquery datasource="#Session.DSN#">
						INSERT INTO CEInactivas(Ccuenta,Cformato,Cdescripcion,Ecodigo,BMUsucodigo,FechaGeneracion,GEid)
						VALUES(
							#LvarCcuenta#,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cdescripcion#">,
							#rsGrpEmp.Ecodigo#,
							 #session.Usucodigo#,
							 SYSDATETIME(),
							#form.GEid#
						)
					</cfquery>

				</cfif>

			</cfif>
		</cfloop>

		<!---Loop para igualar las cuentas excluidas en cada empresa del Grupo de empresas--->
		<cfquery datasource="#Session.DSN#">
			DELETE FROM CEInactivas
			WHERE GEid = -1
			AND Ecodigo in (
				SELECT  Ecodigo
				FROM AnexoGEmpresaDet
				where GEid = (
				   SELECT  GEid
				   FROM AnexoGEmpresaDet
				   where Ecodigo =  #Session.Ecodigo#))
		</cfquery>

		<cfif isdefined("rsError") and rsError.recordCount GT 0>
			<cfset myarray=arraynew(2)>
			<cfloop query="rsError">
			    <cfset myarray[CurrentRow][1]=Valor>
			    <cfset myarray[CurrentRow][2]=Descripcion>
			</cfloop>
			<cftransaction action="rollback">
		</cfif>
	</cftransaction>

	<cfset modo="ALTA">

</cfif>

<cfif isdefined("Cuenta_subcuenta")>

	<cfquery name="subcuentas" datasource="#Session.DSN#">
	    SELECT distinct cc.Cformato FROM  CContables cc
	    WHERE cc.Cformato LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#%">
	    AND (SELECT PCDCniv FROM PCDCatalogoCuenta WHERE Ccuentaniv = cc.Ccuenta GROUP BY PCDCniv) <= #nivel.Pvalor - 1#
    </cfquery>

	<cftransaction>
		<cfloop query="subcuentas"> <!--- por cada cuenta --->

			<cfquery name="rsGrpEmp" datasource="#Session.DSN#">
				SELECT  GEid,Ecodigo FROM AnexoGEmpresaDet where GEid = #form.GEid#
			</cfquery>

			<cfloop query="rsGrpEmp"> <!--- por cada empresa --->
				<cfquery name="rsCuenta" datasource="#Session.DSN#"> <!--- se verfica si existe la cuenta --->
					SELECT Ccuenta FROM  CContables
					WHERE Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#subcuentas.Cformato#">
					and Ecodigo = #rsGrpEmp.Ecodigo#
				</cfquery>
				<cfset LvarCcuenta = -1>

				<cfif rsCuenta.recordcount EQ 0> <!--- si no existe y esta activo el parametro de crear cuentas --->
					<cfif crearCtas>
						<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
							<cfinvokeargument name="Lprm_CFformato" 		value="#trim(subcuentas.Cformato)#"/>
							<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
							<cfinvokeargument name="Lprm_DSN" 				value="#Session.DSN#"/>
							<cfinvokeargument name="Lprm_Ecodigo" 			value="#rsGrpEmp.Ecodigo#"/>
						</cfinvoke>
						<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
							<cfset mensaje="ERROR">
							<cfquery name="rsEmpresa" datasource="#session.dsn#">
								SELECT  Edescripcion FROM Empresas where Ecodigo = #rsGrpEmp.Ecodigo#
							</cfquery>
							<cfquery name="insError" datasource="#session.dsn#">
								INSERT INTO ErrorProceso
							    (Ecodigo,Spcodigo,Usucodigo,Valor,Descripcion)
							   	Values (
							   		#Session.Ecodigo#,
							   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">,
							   		#Session.Usucodigo#,
							   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(rsEmpresa.Edescripcion)#">,
							   		<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(LvarError)#">
							   	)
							</cfquery>
							<cfset LvarCcuenta = -1>
							<!--- <cfthrow message="#LvarError#"> --->
						</cfif>
						<cfset LvarCcuenta = request.PC_GeneraCFctaAnt.Ccuenta>
					</cfif>
				<cfelse>
					<cfset LvarCcuenta = rsCuenta.Ccuenta>
				</cfif>

				<cfif  LvarCcuenta NEQ -1 and LvarCcuenta NEQ "">
					<cfquery name="rsCuenta" datasource="#Session.DSN#">
						SELECT  Id_Inactiva,Ccuenta,Ecodigo
						FROM CEInactivas
						WHERE Ccuenta = #LvarCcuenta#
						AND Ecodigo = #rsGrpEmp.Ecodigo#
					</cfquery>
					<cfif rsCuenta.recordCount GT 0>
						<cfquery datasource="#Session.DSN#">
							UPDATE CEInactivas
								SET Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#subcuentas.Cformato#">,
								GEid = #form.GEid#
							WHERE Id_Inactiva = #rsCuenta.Id_Inactiva#
								AND Ccuenta = #LvarCcuenta#
						</cfquery>
					<cfelse>
						<cfquery datasource="#Session.DSN#">
							INSERT INTO CEInactivas(Cformato, Cdescripcion, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion, GEid)
							VALUES(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#subcuentas.Cformato#">,
								 <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cdescripcion#">,
								#LvarCcuenta#, #rsGrpEmp.Ecodigo#, #session.Usucodigo#, SYSDATETIME(),
								#form.GEid#
							)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>

		<!---Query para igualar las cuentas excluidas en cada empresa del Grupo de empresas--->
		<cfquery datasource="#Session.DSN#">
			DELETE FROM CEInactivas
			WHERE GEid = -1
			AND Ecodigo in (
				SELECT  Ecodigo
				FROM AnexoGEmpresaDet
				WHERE GEid = (
				   SELECT  GEid
				   FROM AnexoGEmpresaDet
				   WHERE Ecodigo =  #Session.Ecodigo#))
		</cfquery>


		<!--- verificando si no hubo errores --->
		<cfquery name="rsError" datasource="#session.dsn#">
			Select Valor,Descripcion
			from ErrorProceso
		    Where Ecodigo = #Session.Ecodigo#
		   		and Spcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.menues.SPcodigo#">
		   		and Usucodigo = #Session.Usucodigo#
		</cfquery>
		<cfif isdefined("rsError") and rsError.recordCount GT 0>
			<cfset myarray=arraynew(2)>
			<cfloop query="rsError">
			    <cfset myarray[CurrentRow][1]=Valor>
			    <cfset myarray[CurrentRow][2]=Descripcion>
			</cfloop>
			<cftransaction action="rollback">
		</cfif>

	</cftransaction>

	<cfset modo="ALTA">

</cfif>


<cfif isdefined("Elimina_cuenta")>
	<cftransaction>
		<cftry>
			<cfloop query="GrupoEmpresas">

				<cfif #Form.tipoME# eq 'cuenta'>
					<cfquery datasource="#Session.DSN#">
						DELETE FROM CEInactivas
						WHERE Ecodigo = #GrupoEmpresas.CodigoEmpresa#
						and Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">
					</cfquery>
				</cfif>

				<cfif #Form.tipoME# eq 'subcuenta'>
					<cfquery name="EliminarCuentas" datasource="#Session.DSN#">
						SELECT Ccuenta,Cformato, Cdescripcion FROM  CContables WHERE Ecodigo = #GrupoEmpresas.CodigoEmpresa# and Cformato LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#%">
					</cfquery>
					<cfloop query="EliminarCuentas">
						<cfquery datasource="#Session.DSN#">
							DELETE FROM CEInactivas WHERE Ecodigo = #GrupoEmpresas.CodigoEmpresa# and Ccuenta = '#EliminarCuentas.Ccuenta#'
						</cfquery>
					</cfloop>
				</cfif>
				<cfset modo="ALTA">
			</cfloop>
			<cfcatch type ="Database">
					<cftransaction action="rollback">
					<cf_dump var = "ERRor en la eliminación"/>
			</cfcatch>
		</cftry>
	</cftransaction>
</cfif>

<cfset LvarAction = 'CatalogoCuentasInactivasCE.cfm'>

<!---------------------------------------------------------------------------------------------->

<cf_templateheader title="Mapeo de Cuentas">
	<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Errores en la Exclucion'>
		<cfset filtro = "">
		<cfset navegacion = "">
		<table width="100%"  border="0" cellspacing="0" cellpadding="0">
			<tr>
				<td colspan="2">
					<cfinclude template="../../../portlets/pNavegacionCG.cfm">
				</td>
			</tr>
			<tr>
				<td colspan="2">
					<table width="100%" align="center">
						<tr>
							<td align="right">
							</td>
						</tr>
					</table>
				</td>
			</tr>
			<tr>
				<td valign="top" colspan="2">
					<form action="<cfoutput>#LvarAction#</cfoutput>" method="post" name="sql">
						<cfoutput>
							<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
						</cfoutput>
					</form>
					<cfif isdefined("myarray") and ArrayLen(myarray) GT 0>
						<cfset Title = "Errores Mapeo Cuentas por Grupo de Empresas">
						<cfset FileName = "ErrMapeoGpoEmp">
						<cfset FileName = FileName & Session.Usucodigo & "-" & DateFormat(Now(),'yyyymmdd') & "-" & TimeFormat(Now(),'hhmmss') & ".xls">

						<!--- Pinta los botones de regresar, impresión y exportar a excel. --->
						<cfset LvarIrA  = 'CatalogoCuentasSATCE.cfm'>

						<cf_htmlreportsheaders title="#Title#" filename="#FileName#.xls" download="yes" back="no" ira="#LvarIrA#">
						<table width="100%" border="0" cellspacing="0" cellpadding="2">
							<tr bgcolor="E2E2E2" class="subTitulo">
					            <td valign="middle" width="25%"><strong>Empresa</strong></td>
					            <td valign="middle"><strong><strong>Error</strong></td>
					        </tr>
					        <cfset actRow = 1>
							<cfloop index="Counter" from=1 to="#ArrayLen(myarray)#">
								<tr style="cursor: pointer;" onMouseOver="javascript: style.color = 'red';" onMouseOut="javascript: style.color = 'black';"
									<cfif actRow MOD 2>
										bgcolor="white"
									<cfelse>
										bgcolor="#F8F8F8"
									</cfif>
									>
										<td>
											<cfoutput>#myarray[Counter][1]#</cfoutput>
										</td>
										<td>
											<cfoutput>#myarray[Counter][2]#</cfoutput>
										</td>
									</tr>
									<cfset actRow = actRow + 1>
							</cfloop>
						</table>
					</cfif>
				</td>
			</tr>
		</table>
		<cfif not isdefined("myarray") or ArrayLen(myarray) EQ 0>
			<script language="JavaScript1.2" type="text/javascript">document.forms['sql'].submit();</script>
		</cfif>
	<cf_web_portlet_end>
<cf_templatefooter>


