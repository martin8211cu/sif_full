<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select count(1) as Cantidad
	from #table_name#
</cfquery>

<cfif isdefined("rsCheck1") and  rsCheck1.Cantidad EQ 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('El archivo de importaci&oacute;n no tiene l&iacute;neas',1)
	</cfquery>
</cfif>

<cfquery name="datos" datasource="#Session.DSN#">
	select * from #table_name#
</cfquery>

<cfset crearCtas = false>
<cfquery name="rsCreaCtaGE" datasource="#Session.DSN#">
	SELECT  Pvalor FROM Parametros where Mcodigo = 'CE' and Pcodigo = 200088
</cfquery>
<cfif rsCreaCtaGE.recordCount GT 0 and rsCreaCtaGE.pvalor EQ 'S'>
	<cfset crearCtas = true>
</cfif>

<!--- <cf_dump var="#table_name#"> --->
<!---cfquery datasource="#session.dsn#">
	Delete From ErrorProceso Where Ecodigo = #Session.Ecodigo# and Spcodigo = '#Session.menues.SPCODIGO#' and Usucodigo = #session.Usucodigo#
</cfquery--->
<cfobject component="sif/Componentes/ErrorProceso" name="errorP">
<cfinvoke component="#errorP#" method="delErrors" returnvariable="error">
	<cfinvokeargument name="Spcodigo" value="#Session.menues.SPCODIGO#">
	<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
</cfinvoke>

<cfquery name="rsGEid" datasource="#Session.DSN#">
	SELECT  GEid
	FROM AnexoGEmpresaDet
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
</cfquery>

<cfloop query="datos" >
	<cfset formatoCuenta = JavaCast("string",#datos.Formato#)>
	<cfset formatoCuenta = replacenocase(#formatoCuenta#,chr(32),'','ALL')>
	<cfset formatoCuenta = replacenocase(#formatoCuenta#,chr(160),'','ALL')>

	<cfquery name="verificaCuenta" datasource="#Session.DSN#">
		select CCuentaSAT
		from CECuentasSAT
		where ltrim(rtrim(CAgrupador)) = #trim(Session.CAgrupador)#
		and (Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> or Ecodigo is null )
		and Ltrim(Rtrim(CCuentaSAT)) = '#trim(datos.Agrupador)#'
	</cfquery>

	<cfquery name="verificaFormato" datasource="#Session.DSN#">
		select distinct Cformato
		from CContables
		where Ecodigo in (	SELECT  Ecodigo
							FROM AnexoGEmpresaDet
							where GEid = (
								SELECT  GEid
								FROM AnexoGEmpresaDet
								where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
							)
		) and Cformato = '#trim(formatoCuenta)#'
	</cfquery>

	<cfif #verificaCuenta.RecordCount# eq 0>
		<!---cfquery datasource="#session.dsn#">
			Insert Into ErrorProceso(Valor,Descripcion,Ecodigo,Spcodigo,Usucodigo)
			Values('#datos.Agrupador#|#datos.RecordCount#|#datos.CurrentRow#|1','La cuenta sat no se encontró dentro de las ya registradas',#Session.Ecodigo#,'#Session.menues.SPCODIGO#',#session.Usucodigo#)
		</cfquery--->
		<cfinvoke component="#errorP#" method="insertErrors" returnvariable="error">
	        <cfinvokeargument name="Spcodigo" value="#Session.menues.SPCODIGO#">
	        <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
	        <cfinvokeargument name="Descripcion" value="La cuenta SAT no se encontró dentro de las cuentas del Mapeo. Favor de verificar">
	        <cfinvokeargument name="Valor" value="#datos.Agrupador#|#datos.RecordCount#|#datos.CurrentRow#|1">
        </cfinvoke>
	</cfif>
	<cfif #verificaFormato.RecordCount# eq 0>
		<!---cfquery datasource="#session.dsn#">
			Insert Into ErrorProceso(Valor,Descripcion,Ecodigo,Spcodigo,Usucodigo)
			Values('#datos.Formato#|#datos.RecordCount#|#datos.CurrentRow#|2','La cuenta no se encontró dentro de las ya registradas',#Session.Ecodigo#,'#Session.menues.SPCODIGO#',#session.Usucodigo#)
		</cfquery--->
		<cfinvoke component="#errorP#" method="insertErrors" returnvariable="error">
	        <cfinvokeargument name="Spcodigo" value="#Session.menues.SPCODIGO#">
	        <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
	        <cfinvokeargument name="Descripcion" value="La cuenta no se encontró dentro de las cuentas de las Empresas del Grupo. Favor de verificar">
	        <cfinvokeargument name="Valor" value="#datos.Formato#|#datos.RecordCount#|#datos.CurrentRow#|2">
        </cfinvoke>
	</cfif>
</cfloop>

<cfquery name="errores" datasource="#session.dsn#">
	select * from ErrorProceso where Ecodigo = #Session.Ecodigo# and Spcodigo = '#Session.menues.SPCODIGO#' and Usucodigo = #session.Usucodigo#
</cfquery>
<cfset myarray=arraynew(2)>
<cfset errIndex = 0>
<cftransaction>
	<cfif #errores.RecordCount# neq 0>
		<cfoutput>
			<script type="text/javascript">
				location.replace ( "../../sif/ce/GrupoEmpresas/importar/importar-status.cfm" );
		    </script>
	    </cfoutput>
	<cfelse>
		<cfquery name="datosalta" datasource="#Session.DSN#">
			SELECT Agrupador,Formato FROM #table_name#
	    </cfquery>
			<cfloop query="datosalta">
				<cfset formatoCuenta = JavaCast("string",#datosalta.Formato#)>
		        <cfset formatoCuenta = replacenocase(#formatoCuenta#,chr(32),'','ALL')>
		        <cfset formatoCuenta = replacenocase(#formatoCuenta#,chr(160),'','ALL')>
				<cfquery name="rsGrpEmp" datasource="#Session.DSN#">
					SELECT  GEid,Ecodigo
					FROM AnexoGEmpresaDet
					where GEid = (
						SELECT  GEid
						FROM AnexoGEmpresaDet
						where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
					)
				</cfquery>
				<cfloop query="rsGrpEmp">
					<cfquery name="cleve" datasource="#Session.DSN#">
						SELECT Ccuenta,Ecodigo
				        FROM CContables
				        WHERE Cformato = <cfqueryparam cfsqltype="CF_SQL_CHAR" value="#formatoCuenta#">
				        	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsGrpEmp.Ecodigo#">
				    </cfquery >
					<cfset LvarCcuenta = -1>
			        <cfif #cleve.RecordCount# EQ 0>
			        	<cfif crearCtas>
							<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
								<cfinvokeargument name="Lprm_CFformato" 		value="#trim(formatoCuenta)#"/>
								<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
								<cfinvokeargument name="Lprm_DSN" 				value="#Session.DSN#"/>
								<cfinvokeargument name="Lprm_Ecodigo" 			value="#rsGrpEmp.Ecodigo#"/>
							</cfinvoke>
							<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
								<cfset mensaje="ERROR">
								<cfquery name="rsEmpresa" datasource="#session.dsn#">
									SELECT  Edescripcion FROM Empresas where Ecodigo = #rsGrpEmp.Ecodigo#
								</cfquery>
								<cfset errIndex = errIndex + 1>
							    <cfset myarray[errIndex][1] = "#LvarError#">
							    <cfset myarray[errIndex][2] = "#trim(rsEmpresa.Edescripcion)#: #datos.Formato#|#datos.RecordCount#|#datos.CurrentRow#|2">
							</cfif>
							<cfset LvarCcuenta = request.PC_GeneraCFctaAnt.Ccuenta>
						</cfif>
					<cfelse>
						<cfset LvarCcuenta = cleve.Ccuenta>
					</cfif>
					<cfif  LvarCcuenta NEQ -1 and LvarCcuenta NEQ "">
						<cfquery name="rsCuenta" datasource="#Session.DSN#">
							SELECT  Id_Mapeo, CAgrupador,Ccuenta,Ecodigo
							FROM CEMapeoSAT
							where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Session.CAgrupador)#">
								and Ccuenta = #LvarCcuenta#
								and Ecodigo = #rsGrpEmp.Ecodigo#
						</cfquery>
						<cfset agrupadorCuenta = JavaCast("string",#datosalta.Agrupador#)>
				        <cfset agrupadorCuenta = replacenocase(#agrupadorCuenta#,chr(32),'','ALL')>
				        <cfset agrupadorCuenta = replacenocase(#agrupadorCuenta#,chr(160),'','ALL')>
						<cfif rsCuenta.recordCount GT 0>
							<cfquery datasource="#Session.DSN#">
								Update CEMapeoSAT
									set CCuentaSAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#agrupadorCuenta#">,
										UsucodigoModifica= #session.Usucodigo# ,FechaModificacion= SYSDATETIME(),
										GEid = #rsGEid.GEid#
								Where Id_Mapeo = #rsCuenta.Id_Mapeo#
									and Ccuenta = #LvarCcuenta#
							</cfquery>
						<cfelse>
							<cfquery datasource="#Session.DSN#">
								INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion, GEid)
								VALUES(
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#agrupadorCuenta#">,
									<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(Session.CAgrupador)#">,
									#LvarCcuenta#, #rsGrpEmp.Ecodigo#, #session.Usucodigo#, SYSDATETIME(),
									#rsGEid.GEid#
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

	    <cflock timeout=20 scope="Session" type="Exclusive">
			<cfset StructDelete(session, "CAgrupador")>
	    </cflock>
	    <cfif errIndex GT 0>
			<cftransaction action="rollback">
		</cfif>
	</cfif>
</cftransaction>
<cfif errIndex GT 0>
	<cfloop index="Counter" from=1 to="#errIndex#">
		<cfinvoke component="#errorP#" method="insertErrors" returnvariable="error">
			<cfinvokeargument name="Spcodigo" value="#Session.menues.SPCODIGO#">
			<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
			<cfinvokeargument name="Descripcion" value="#myarray[Counter][1]#">
			<cfinvokeargument name="Valor" value="#myarray[Counter][2]#">
		</cfinvoke>
	</cfloop>
</cfif>
<cfquery name="errores" datasource="#session.dsn#">
	select * from ErrorProceso where Ecodigo = #Session.Ecodigo# and Spcodigo = '#Session.menues.SPCODIGO#' and Usucodigo = #session.Usucodigo#
</cfquery>
<cfif #errores.RecordCount# neq 0>
	<cfoutput>
		<script type="text/javascript">
			location.replace ( "../../sif/ce/GrupoEmpresas/importar/importar-status.cfm" );
	    </script>
    </cfoutput>
</cfif>







