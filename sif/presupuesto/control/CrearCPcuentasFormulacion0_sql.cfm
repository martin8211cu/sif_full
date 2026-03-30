<cfquery name="rsCPP" datasource="#session.dsn#">
	select CPPid, CPPfechaDesde
	  from CPresupuestoPeriodo d
	 where Ecodigo	= #Session.Ecodigo#
	   and CPPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
	   and CPPestado = 1
</cfquery>
<cfquery name="rsCta" datasource="#session.dsn#">
	select CPcuenta, CPdescripcion
	  from CPresupuesto
	 where Ecodigo		= #Session.Ecodigo#
	   and CPformato	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#-#form.Pdetalle2#">
</cfquery>

<cfset LvarVerificacion = "">
<cfset LvarExistente = false>
<cfset LvarIncluidaPeriodo = false>

<cftransaction>
	<cfif rsCta.CPcuenta NEQ "">
		<cfset LvarExistente = true>
		<cfquery name="rsCtaPer" datasource="#session.dsn#">
			select CPcuenta, CPCPtipoControl, CPCPcalculoControl
			  from CPCuentaPeriodo
			 where Ecodigo	= #Session.Ecodigo#
			   and CPPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
			   and CPcuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCta.CPcuenta#">
		</cfquery>
		<cfif rsCtaPer.CPcuenta NEQ "">
			<cfset LvarIncluidaPeriodo = true>
			<cfif rsCtaPer.CPCPtipoControl NEQ "0" AND isdefined("form.chkForzarAbierto")>
				<cfquery datasource="#session.dsn#">
					update CPCuentaPeriodo
					   set CPCPtipoControl = 0
					 where Ecodigo	= #Session.Ecodigo#
					   and CPPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
					   and CPcuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCta.CPcuenta#">
				</cfquery>
				<cfset rsCtaPer.CPCPtipoControl = "0">
				<cfif not isdefined("form.btnCrear")>
					<cfset LvarTipoNoAbierto = true>
				</cfif>
			</cfif>
			<cfif rsCtaPer.CPCPtipoControl NEQ "0">
				<cfset LvarVerificacion = "El Tipo de Control de la cuenta en el período no es Abierto">
				<cfset LvarTipoNoAbierto = true>
			<cfelseif rsCtaPer.CPCPcalculoControl NEQ form.CVPcalculoControl>
				<cfset LvarVerificacion = "No se permite modificar el Método de Cálculo de Control de la cuenta para el período">
			</cfif>
		</cfif>
		<cfquery name="rsFormulacion" datasource="#session.dsn#">
			select m.CPCano, m.CPCmes, c.CPcuenta
			  from CPmeses m
				left join CPresupuestoControl c
				   on c.Ecodigo 	= m.Ecodigo
				  and c.CPPid		= m.CPPid
				  and c.CPCano		= m.CPCano
				  and c.CPCmes		= m.CPCmes
				  and c.CPcuenta	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCta.CPcuenta#">
				  and c.Ocodigo		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Ocodigo#">
			 where m.Ecodigo	= #Session.Ecodigo#
			   and m.CPPid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		</cfquery>
	<cfelse>
		<cfinvoke 
		 component="sif.Componentes.PC_GeneraCuentaFinanciera"
		 method="fnGeneraCuentaFinanciera"
		 returnvariable="LvarMSG">
			<cfinvokeargument name="Lprm_Cmayor" 				value="#form.Cmayor#"/>
			<cfinvokeargument name="Lprm_Cdetalle" 				value="#form.Pdetalle2#"/>
			<cfinvokeargument name="Lprm_fecha" 				value="#rsCPP.CPPfechaDesde#"/>
			<cfinvokeargument name="Lprm_Ocodigo" 				value="-1"/>
			<cfinvokeargument name="Lprm_Cdescripcion" 			value="#form.CPdescripcion#"/>
			<cfinvokeargument name="Lprm_EsDePresupuesto" 		value="true"/>
			<cfinvokeargument name="Lprm_CrearPresupuesto" 		value="true"/>
			<cfinvokeargument name="Lprm_CPPid" 				value="#form.CPPid#"/>
			<cfinvokeargument name="Lprm_CVPtipoControl"		value="0"/>
			<cfinvokeargument name="Lprm_CVPcalculoControl" 	value="#form.CVPcalculoControl#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" 	value="yes"/>
		</cfinvoke>
		<cfif LvarMSG EQ "NEW">
			<cfquery name="rsCta" datasource="#session.dsn#">
				select CPcuenta, CPdescripcion
				  from CPresupuesto
				 where Ecodigo		= #Session.Ecodigo#
				   and CPformato	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Cmayor#-#form.Pdetalle2#">
			</cfquery>
		<cfelse>
			<cfset LvarVerificacion = LvarMSG>
		</cfif>
		<cfquery name="rsFormulacion" datasource="#session.dsn#">
			select m.CPCano, m.CPCmes, ' ' as CPcuenta
			  from CPmeses m
			 where m.Ecodigo	= #Session.Ecodigo#
			   and m.CPPid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPPid#">
		</cfquery>
	</cfif>
	
	<cfoutput>
		<cfset LvarResultado = LvarResultado & "<table><tr><td>Cuenta de Presupuesto</td><td><strong>#form.Cmayor#-#form.Pdetalle2#  ">
		<cfif rsCta.CPdescripcion NEQ "" AND rsCta.CPdescripcion NEQ form.CPdescripcion>
			<cfset LvarResultado = LvarResultado & "#rsCta.CPdescripcion# (#form.CPdescripcion#)">
		<cfelse>
			<cfset LvarResultado = LvarResultado & "#form.CPdescripcion#">
		</cfif>
		<cfset LvarResultado = LvarResultado & "</strong></td></tr>">

		<cfif LvarIncluidaPeriodo>
			<cfset LvarResultado = LvarResultado & "<tr><td></td><td>Cuenta ya incluida en el Período</td></tr>">
		<cfelseif LvarExistente>
			<cfset LvarResultado = LvarResultado & "<tr><td></td><td>Cuenta Existente pero no incluida en el período</td></tr>">
		<cfelse>
			<cfset LvarResultado = LvarResultado & "<tr><td></td><td>Cuenta Nueva</td></tr>">
		</cfif>

		<cfif LvarVerificacion EQ "">
			<cfif LvarIncluidaPeriodo>
				<cfif isdefined("form.chkForzarAbierto")>
					<cfset LvarResultado = LvarResultado & "<tr><td></td><td><strong>Cambio forzado del Tipo de Control: ABIERTO</strong></td></tr>">
				</cfif>
			<cfelseif LvarExistente>
				<cfset LvarResultado = LvarResultado & "<tr><td></td><td>Inclusión de Cuenta en el período</td></tr>">
				<cfquery datasource="#session.dsn#">
					insert into CPCuentaPeriodo (
						Ecodigo, CPPid, CPcuenta, CPCPcalculoControl, CPCPtipoControl
					)
					values (
						#session.Ecodigo#,
						#form.CPPid#,
						#rsCta.CPcuenta#,
						#form.CVPcalculoControl#,
						0
					)
				</cfquery>
			<cfelse>
				<cfset LvarResultado = LvarResultado & "<tr><td></td><td>Generación de Cuenta Nueva</td></tr>">
			</cfif>
			<cfset LvarResultado = LvarResultado & "<tr><td></td><td>Generación de la Formulacion para la Oficina: #form.Oficodigo#</td></tr>">
			<cfset LvarResultado = LvarResultado & "<tr><td></td><td><table>">
			<cfset LvarResultado = LvarResultado & "<tr><td>Mes</td><td>Resultado</td></tr>">
			<cfset LvarCreado = false>
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select Mcodigo from Empresas where Ecodigo=#session.Ecodigo#
			</cfquery>
			<cfset LvarMcodigo = rsSQL.Mcodigo>
			<cfloop query="rsFormulacion">
				<cfset LvarResultado = LvarResultado & "<tr><td>#rsFormulacion.CPCano#-#rsFormulacion.CPCmes#</td>">
				<cfif rsFormulacion.CPcuenta EQ "">
					<cfset LvarResultado = LvarResultado & "<td><font color='##0000FF'>Formulación generada en CERO</font></td></tr>">
					<cfset LvarCreado = true>
					<cfquery datasource="#session.dsn#">
						insert into CPresupuestoControl (
							Ecodigo,CPPid,CPCano,CPCmes,CPcuenta,Ocodigo,CPCanoMes,CPCpresupuestado
						)
						values (
							#session.Ecodigo#,#form.CPPid#,#rsFormulacion.CPCano#,#rsFormulacion.CPCmes#,#rsCta.CPcuenta#,#form.Ocodigo#,#rsFormulacion.CPCano*100+rsFormulacion.CPCmes#,0
						)
					</cfquery>
					<cfquery datasource="#session.dsn#">
						insert into CPControlMoneda (
							Ecodigo,CPPid,CPCano,CPCmes,CPcuenta,Ocodigo,Mcodigo,CPCMtipoCambioAplicado,CPCMpresupuestado,CPCMmodificado
						)
						values (
							#session.Ecodigo#,#form.CPPid#,#rsFormulacion.CPCano#,#rsFormulacion.CPCmes#,#rsCta.CPcuenta#,#form.Ocodigo#,#LvarMcodigo#,1,0,0
						)
					</cfquery>
				<cfelse>
					<cfset LvarResultado = LvarResultado & "<td>Formulación ya existente</td></tr>">
				</cfif>
			</cfloop>
			<cfif LvarCreado>
				<cfif isdefined("form.btnCrear")>
					<cfset LvarResultado = LvarResultado & "<tr><td></td><td><strong>FORMULACIÓN GENERADA CON ÉXITO</strong></td></tr>">
				<cfelse>
					<cfset LvarResultado = LvarResultado & "<tr><td></td><td><strong>FORMULACIÓN VERIFICADA CON ÉXITO: PRESIONE &LT;Generar Cuenta&GT; PARA GENERAR</strong></td></tr>">
				</cfif>
			<cfelseif LvarExistente AND NOT LvarIncluidaPeriodo>
				<cfif isdefined("form.btnCrear")>
					<cfset LvarResultado = LvarResultado & "<tr><td></td><td><strong>Corrección Ejecutada: CPCuentaPeriodo </strong></td></tr>">
				<cfelse>
					<cfset LvarResultado = LvarResultado & "<tr><td></td><td><strong>FORMULACIÓN VERIFICADA CON ÉXITO: PRESIONE &LT;Generar Cuenta&GT; PARA GENERAR</strong></td></tr>">
				</cfif>
			<cfelseif LvarExistente AND LvarIncluidaPeriodo>
				<cfset LvarResultado = LvarResultado & "<tr><td></td><td><strong>No se generó ninguna formulación</strong></td></tr>">
				<cfset LvarVerificacion = "LA CUENTA DE PRESUPUESTO YA ESTA CREADA Y FORMULADA">
			</cfif>
		</cfif>
		<cfif LvarVerificacion NEQ "">
			<cfset LvarResultado = LvarResultado & "<tr><td></td><td><font color=##FF0000>ERROR:<BR>#LvarVerificacion#</font></td></tr>">
			<cftransaction action="rollback" />
		</cfif>
		<cfset LvarResultado = LvarResultado & "</table>">
	</cfoutput>
	<cfif not isdefined("form.btnCrear")>
		<cfset LvarResultado = Replace(LvarResultado, "generada en CERO", "verficada", "ALL")>
		<cfset LvarResultado = Replace(LvarResultado, "GENERADA", "VERIFICADA", "ALL")>
		<cftransaction action="rollback" />
	</cfif>
</cftransaction>
