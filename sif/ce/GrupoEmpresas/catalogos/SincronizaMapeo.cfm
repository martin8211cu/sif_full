
<cfset crearCtas = false>
<cfset myarray=arraynew(2)>
<cfset errIndex = 0>
<cftransaction>

	<cfquery name="rsCreaCtaGE" datasource="#Session.DSN#">
		SELECT  Pvalor FROM Parametros where Mcodigo = 'CE' and Pcodigo = 200088
	</cfquery>
	<cfif rsCreaCtaGE.recordCount GT 0 and rsCreaCtaGE.pvalor EQ 'S'>
		<cfset crearCtas = true>
	</cfif>

	<cfquery name="rsGEid" datasource="#session.dsn#">
		SELECT  GEid FROM AnexoGEmpresaDet where Ecodigo = #Session.Ecodigo#
	</cfquery>

	<cfquery name="rsEcodigos" datasource="#session.dsn#">
		SELECT  Ecodigo FROM AnexoGEmpresaDet where GEid = #rsGEid.GEid# and Ecodigo <> #Session.Ecodigo#
	</cfquery>


	<cfif crearCtas>
		<!--- Cuentas que existen en las Empresas de eliminacion y no en empresas grupo --->
		<cfquery name="subcuentas" datasource="#session.dsn#">
			SELECT a.Cformato, b.Ecodigo,e.Edescripcion,a.Cdescripcion
			FROM CContables a,(SELECT  Ecodigo FROM AnexoGEmpresaDet
								where GEid =(SELECT  GEid FROM AnexoGEmpresaDet	where Ecodigo = #Session.Ecodigo#) and Ecodigo <> #Session.Ecodigo# ) b
				inner join Empresas e
				on b.Ecodigo = e.Ecodigo
			Where a.Ecodigo in (SELECT  Ecodigo FROM AnexoGEmpresaDet
								where GEid =(SELECT  GEid FROM AnexoGEmpresaDet	where Ecodigo = #Session.Ecodigo#)
								)
			and a.Cmovimiento = 'S'
			AND not EXists (select Cformato from CContables b
							where Ecodigo in (SELECT Ecodigo FROM AnexoGEmpresaDet
											  where GEid =(SELECT  GEid FROM AnexoGEmpresaDet
															where Ecodigo = #Session.Ecodigo#)
															and Ecodigo <> #Session.Ecodigo#
															and a.Cformato = b.Cformato
											  )
							)
			order by a.Cformato, a.Ecodigo
		</cfquery>


		<cfloop query="subcuentas">
			<cfset LvarCcuenta = -1>
			<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
				<cfinvokeargument name="Lprm_CFformato" 		value="#trim(subcuentas.Cformato)#"/>
				<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
				<cfinvokeargument name="Lprm_DSN" 				value="#Session.DSN#"/>
				<cfinvokeargument name="Lprm_Ecodigo" 			value="#subcuentas.Ecodigo#"/>
			</cfinvoke>
			<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
				<cfset mensaje="ERROR">
				<cfquery name="rsEmpresa" datasource="#session.dsn#">
					SELECT  Edescripcion FROM Empresas where Ecodigo = #subcuentas.Ecodigo#
				</cfquery>
				<cfset errIndex = errIndex + 1>
			    <cfset myarray[errIndex][1] = "#LvarError#">
			    <cfset myarray[errIndex][2] = "#trim(rsEmpresa.Edescripcion)#: #trim(subcuentas.Cformato)#">
				<cfset LvarCcuenta = -1>
			</cfif>
			<cfset LvarCcuenta = request.PC_GeneraCFctaAnt.Ccuenta>
		</cfloop>
	</cfif>

	<cfquery name="delExc" datasource="#session.dsn#">
		delete from CEInactivas
		where Ecodigo in (SELECT  Ecodigo FROM AnexoGEmpresaDet where GEid = #rsGEid.GEid# and Ecodigo <> #Session.Ecodigo#)
	</cfquery>
	<cfquery name="delExcEmp" datasource="#session.dsn#">
		delete from CEInactivas
		where GEid <> #rsGEid.GEid# and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfquery name="delMap" datasource="#session.dsn#">
		delete from CEMapeoSAT
		where Ecodigo in (SELECT  Ecodigo FROM AnexoGEmpresaDet where GEid = #rsGEid.GEid# and Ecodigo <> #Session.Ecodigo#)
			and CAgrupador = #form.CAgrupador#
	</cfquery>
	<cfquery name="delMapEmp" datasource="#session.dsn#">
		delete from CEInactivas
		where GEid <> #rsGEid.GEid# and Ecodigo = #Session.Ecodigo#
	</cfquery>

	<cfquery name="insExc" datasource="#session.dsn#">
		INSERT INTO CEInactivas
           (Ccuenta
           ,Cformato
           ,Cdescripcion
           ,Ecodigo
           ,BMUsucodigo
           ,FechaGeneracion
           ,GEid)
		SELECT  cc2.Ccuenta, cc2.Cformato, cc2.Cdescripcion, cc2.Ecodigo, #Session.Usucodigo#, getdate(), #rsGEid.GEid#
		FROM CEInactivas cm
		inner join CContables cc
			on cc.Ccuenta = cm.Ccuenta
			and cc.Ecodigo = cm.Ecodigo
			and cm.Ecodigo = #Session.Ecodigo#
			and cm.GEid = #rsGEid.GEid#
		inner join CContables cc2
			on cc.Cformato = cc2.Cformato
		where cc2.Ecodigo in (SELECT  Ecodigo FROM AnexoGEmpresaDet where GEid = #rsGEid.GEid# and Ecodigo <> #Session.Ecodigo#)
	</cfquery>


	<cfquery name="insMap" datasource="#session.dsn#">
		INSERT INTO CEMapeoSAT
           (CCuentaSAT
           ,CAgrupador
           ,Ccuenta
           ,Ecodigo
           ,BMUsucodigo
           ,FechaGeneracion
           ,GEid)
		SELECT  cm.CCuentaSAT,cm.CAgrupador,cc2.Ccuenta, cc2.Ecodigo, #Session.Usucodigo#, getdate(), #rsGEid.GEid#
		FROM CEMapeoSAT cm
		inner join CContables cc
			on cc.Ccuenta = cm.Ccuenta
			and cc.Ecodigo = cm.Ecodigo
			and cm.Ecodigo = #Session.Ecodigo#
			and cm.CAgrupador = #form.CAgrupador#
			and cm.GEid = #rsGEid.GEid#
		inner join CContables cc2
			on cc.Cformato = cc2.Cformato
		where cc2.Ecodigo in (SELECT  Ecodigo FROM AnexoGEmpresaDet where GEid = #rsGEid.GEid# and Ecodigo <> #Session.Ecodigo#)
	</cfquery>
    <cfif errIndex GT 0>
		<cftransaction action="rollback">
	</cfif>
</cftransaction>


<cfset LvarAction = 'listaCatalogoCuentasSATCE.cfm'>
<cf_templateheader title="Mapeo de Cuentas al SAT por Grupo de Empresa ">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Errores Sicronizando Mapeo'>
<cfset navegacion = "">
<cfset form.modom = "CAMBIO">
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
									<cfoutput>#myarray[Counter][2]#</cfoutput>
								</td>
								<td>
									<cfoutput>#myarray[Counter][1]#</cfoutput>
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
