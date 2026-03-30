<cfparam name="modom" default="ALTA">
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

<cfinvoke component="sif.Componentes.ErrorProceso" method="delErrors">
	<cfinvokeargument name="Spcodigo"   	value="#session.menues.SPcodigo#">
    <cfinvokeargument name="Ecodigo"   		value="#session.Ecodigo#">
</cfinvoke>

<!---cfif isdefined("form.Mayor_cuenta")>
	<cfquery name="cuenta" datasource="#Session.DSN#">
		SELECT Ccuenta FROM  CContables WHERE Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#">
	</cfquery>
	<cfquery datasource="#Session.DSN#">
		INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion)
		VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">, #cuenta.Ccuenta#, #Session.Ecodigo#, #session.Usucodigo#, SYSDATETIME())
	</cfquery>
	<cfset modom="ALTA">
</cfif>
<cfif isdefined("form.Mayor_subcuenta")>
	<cfquery name="cuentas" datasource="#Session.DSN#">
		SELECT Ccuenta FROM  CContables WHERE Cmayor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#">
	</cfquery>
	<cfloop query="cuentas">
		<cfquery datasource="#Session.DSN#">
			INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion)
		    VALUES(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">, <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">, #cuentas.Ccuenta#, #Session.Ecodigo#, #session.Usucodigo#, SYSDATETIME())
		</cfquery>
	</cfloop>
	<cfset modom="ALTA">
</cfif--->
<cfif isdefined("Subcuenta_cuenta")>
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
				SELECT  Id_Mapeo, CAgrupador,Ccuenta,Ecodigo
				FROM CEMapeoSAT
				where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">
					and Ccuenta = #LvarCcuenta#
					and Ecodigo = #rsGrpEmp.Ecodigo#
			</cfquery>
			<cfif rsCuenta.recordCount GT 0>
				<cfquery datasource="#Session.DSN#">
					Update CEMapeoSAT
						set CCuentaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">,
							GEid = #form.GEid#
					Where Id_Mapeo = #rsCuenta.Id_Mapeo#
						and Ccuenta = #LvarCcuenta#
				</cfquery>
			<cfelse>
				<cfquery datasource="#Session.DSN#">
					INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion, GEid)
					VALUES(
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">,
						<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">,
						#LvarCcuenta#, #rsGrpEmp.Ecodigo#, #session.Usucodigo#, SYSDATETIME(),
						#form.GEid#
					)
				</cfquery>
			</cfif>
		</cfif>
	</cfloop>

	<!---Query para igualar las cuentas mapeadas en cada empresa del Grupo de empresas--->
	<!--- Se comenta, pendiente de revisar funcionalidad --->
	<!--- <cfquery datasource="#Session.DSN#">
		DELETE FROM CEMapeoSAT
		WHERE GEid = -1
		AND Ecodigo in (
			SELECT  Ecodigo
			FROM AnexoGEmpresaDet
			where GEid = (
			   SELECT  GEid
			   FROM AnexoGEmpresaDet
			   where Ecodigo =  #Session.Ecodigo#))
	</cfquery> --->

	<cfif isdefined("rsError") and rsError.recordCount GT 0>
		<cfset myarray=arraynew(2)>
		<cfloop query="rsError">
		    <cfset myarray[CurrentRow][1]=Valor>
		    <cfset myarray[CurrentRow][2]=Descripcion>
		</cfloop>
		<cftransaction action="rollback">
	</cfif>
	</cftransaction>
	<cfset modom="ALTA">
</cfif>
<cfif isdefined("Subcuenta_subcuenta")>
	<cfquery name="subcuentas" datasource="#Session.DSN#">
	    SELECT distinct cc.Cformato FROM  CContables cc
	    WHERE cc.Cformato LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#%">
	    AND (SELECT PCDCniv FROM PCDCatalogoCuenta WHERE Ccuentaniv = cc.Ccuenta GROUP BY PCDCniv) <= #nivel.Pvalor - 1#
	    AND cc.Ecodigo = #Session.Ecodigo#
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
						SELECT  Id_Mapeo, CAgrupador,Ccuenta,Ecodigo
						FROM CEMapeoSAT
						where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">
							and Ccuenta = #LvarCcuenta#
							and Ecodigo = #rsGrpEmp.Ecodigo#
					</cfquery>
					<cfif rsCuenta.recordCount GT 0>
						<cfquery datasource="#Session.DSN#">
							Update CEMapeoSAT
								set CCuentaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">,
								GEid = #form.GEid#
							Where Id_Mapeo = #rsCuenta.Id_Mapeo#
								and Ccuenta = #LvarCcuenta#
						</cfquery>
					<cfelse>
						<cfquery datasource="#Session.DSN#">
							INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion, GEid)
							VALUES(
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">,
								<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">,
								#LvarCcuenta#, #rsGrpEmp.Ecodigo#, #session.Usucodigo#, SYSDATETIME(),
								#form.GEid#
							)
						</cfquery>
					</cfif>
				</cfif>
			</cfloop>
		</cfloop>

		<!---Query para igualar las cuentas mapeadas en cada empresa del Grupo de empresas--->
		<!--- Se comenta, pendiente de revisar funcionalidad --->
		<!--- <cfquery datasource="#Session.DSN#">
			DELETE FROM CEMapeoSAT
			WHERE GEid = -1
			AND Ecodigo in (
				SELECT  Ecodigo
				FROM AnexoGEmpresaDet
				where GEid = (
				   SELECT  GEid
				   FROM AnexoGEmpresaDet
				   where Ecodigo =  #Session.Ecodigo#))
		</cfquery> --->

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
	<cfset modom="ALTA">
	<cfset form.modom="ALTA">
</cfif>
<!---cfif isdefined("Form.Cambio")>
	<cfif #Form.tipoME# eq 'cuenta'>
		<cfquery name="cambioCuenta" datasource="#Session.DSN#">
		    SELECT Ccuenta FROM  CContables WHERE Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#">
	    </cfquery>
		<cfquery datasource="#Session.DSN#">
			UPDATE CEMapeoSAT SET CCuentaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#"> , UsucodigoModifica= #session.Usucodigo# ,FechaModificacion= SYSDATETIME()  WHERE CAgrupador =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#"> AND Ccuenta= #cambioCuenta.Ccuenta#
		</cfquery>
	</cfif>
	<cfif #Form.tipoME# eq 'subcuenta'>
		<cfquery name="cambioCuentas" datasource="#Session.DSN#">
		    SELECT Ccuenta FROM  CContables WHERE Cformato LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cformato#%">
	    </cfquery>
	    <cfloop query="cambioCuentas">
		    <cfquery datasource="#Session.DSN#">
			    UPDATE CEMapeoSAT SET CCuentaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCuentaSAT#">, UsucodigoModifica= #session.Usucodigo# ,FechaModificacion= SYSDATETIME()  WHERE CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#"> AND Ccuenta= #cambioCuentas.Ccuenta#
		    </cfquery>
		</cfloop>
	</cfif>
	<cfset modom="CAMBIO">
</cfif--->
<cfif isdefined("Form.Eliminar")>
		<cfquery datasource="#Session.DSN#">
		    UPDATE cm
		    SET cm.GEid = -1
		    FROM CEMapeoSAT cm
			inner join CContables cc
				on cm.Ccuenta = cc.Ccuenta
				and cm.Ecodigo = cc.Ecodigo
		    WHERE cm.CAgrupador= <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.CAgrupador)#">
		    AND cm.GEid = #form.GEid#
		    <cfif #Form.tipoME# eq 'cuenta'>
			    and cc.Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.Cformato)#">
		    <cfelseif #Form.tipoME# eq 'subcuenta'>
			    and cc.Cformato like '#trim(form.Cformato)#%'
			<cfelse>
				and 1 = 2 <!--- no se actualiza nada --->
			</cfif>
		    and cm.Ecodigo in (SELECT  Ecodigo FROM AnexoGEmpresaDet where GEid = #form.GEid#)
		</cfquery>
	<cfset modom="ALTA">
	<cfset form.modom="ALTA">
</cfif>

<cfset LvarAction = 'CatalogoCuentasSATCE.cfm'>

<cf_templateheader title="Mapeo de Cuentas">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Errores en el Mapeo'>
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
				<table width="100%" border="0" cellspacing="0" cellpadding="2">
					<tr>
			            <td align="right"><a href="#" onClick="document.forms['sql'].submit();">Regresar</a></td>
			        </tr>
			    </table>
			<cfoutput>
			    <input name="CAgrupador" type="hidden" value="#trim(form.CAgrupador)#">
				<input name="CCuentaSAT" type="hidden" value="#form.CCuentaSAT#">
			    <input name="modo" type="hidden" value="CAMBIO">
				<input name="modom" type="hidden" value="#form.modom#">
				<cfif isdefined('Ccuenta')>
				    <input name="Ccuenta" type="hidden" value="#Ccuenta#">
				</cfif>
				<cfif modom neq 'ALTA'>
					<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
					<cfif isdefined('Form.tipoME')>
					<cfif #Form.tipoME# eq 'cuenta'>
						<!---input name="Ccuenta" type="hidden" value="#cambioCuenta.Ccuenta#"--->
					</cfif>
					<cfif #Form.tipoME# eq 'subcuenta'>
						<!---input name="Ccuenta" type="hidden" value="#cambioCuentas.Ccuenta#"--->
					</cfif>
					</cfif>
				</cfif>
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


