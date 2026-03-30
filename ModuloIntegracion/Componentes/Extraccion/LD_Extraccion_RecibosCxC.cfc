<!----
	Author: 	   Andres Lara
	Name: 	 	   LD_Extraccion_RecibosCxC
	Version: 	   1.0
	Date Created:  18-SEPT-2017
	Date Modified:
--->
<cfcomponent extends="ModuloIntegracion.Componentes.Interfaz_base" output="yes">
<cffunction name="Ejecuta" access="public" returntype="string" output="yes">

	<cfsetting requestTimeout="3600" />
	<!--- Asigna variables de Fechas --->
		<cfif isdefined("form.fechaini") && isdefined("form.fechafin")>
			<cfset fechaini = createdate(right(form.fechaini,4),mid(form.fechaini,4,2),left(form.fechaini,2))>
			<cfset fechafin = createdatetime(right(form.fechafin,4),mid(form.fechafin,4,2),left(form.fechafin,2),23,59,59)>
		<cfelse>
			<cfset fechaini = createdate(YEAR(NOW() -10), MONTH(NOW() -10), DAY(NOW() -10))>
			<cfset fechafin = createdatetime(YEAR(NOW()), MONTH(NOW()), DAY(NOW()),23,59,59)>
		</cfif>


	<!--- Obtiene las operaciones de Recibo --->
<cfset DataSourceLD = 'ldcom'>
<cfset idEnc = 1>


<cfquery name="rsCierre" datasource="#DataSourceLD#">
	SELECT a.Emp_id,
	       a.Suc_id,
	       c.Cliente_CodigoExterno AS Cliente_id,
	       a.Moneda_id,
	       format(a.Recibo_Fecha, 'yyyy-MM-dd') Recibo_Fecha,
	       a.Operacion_id,
	       a.Recibo_id,
	       SUM(a.Recibo_Monto) Monto,
		   CONCAT('RP-000', Suc_id, '-', a.Recibo_id, '-', a.Operacion_id) AS NomDoc
	FROM Cxc_Recibo a
	INNER JOIN Cliente c ON c.Cliente_Id = a.Cliente_Id
	AND c.Emp_Id = a.Emp_id
	WHERE Recibo_Fecha BETWEEN <cfqueryparam cfsqltype="cf_sql_timestamp" value='#FechaIni#'>
	                       AND <cfqueryparam cfsqltype="cf_sql_timestamp" value='#FechaFin#'>
	GROUP BY a.Emp_id,
	         Suc_id,
	         c.Cliente_CodigoExterno,
	         a.Moneda_id,
	         format(a.Recibo_Fecha, 'yyyy-MM-dd'),
	         a.Operacion_id,
	         a.Recibo_id
	ORDER BY format(a.Recibo_Fecha, 'yyyy-MM-dd'),
	         c.Cliente_CodigoExterno
</cfquery>

<!--- Crea tabla temporal para comparación --->
		<cf_dbtemp name="LocalTempRecibo" returnvariable="varLocalTempRecibo" datasource="sifinterfaces">
			<cf_dbtempcol name="Emp_Id" 				type="numeric">
			<cf_dbtempcol name="Suc_Id" 				type="numeric">
			<cf_dbtempcol name="Cliente_id" 			type="numeric">
			<cf_dbtempcol name="Moneda_id" 				type="numeric">
			<cf_dbtempcol name="Recibo_Fecha" 			type="DATETIME">
			<cf_dbtempcol name="Monto" 					type="money">
			<cf_dbtempcol name="Operacion_id" 			type="numeric">
			<cf_dbtempcol name="Recibo_id" 				type="numeric">
			<cf_dbtempcol name="NomDoc"	type="varchar(75)" 	mandatory="no">
		</cf_dbtemp>
<!--- Inserta operaciones del día en tabla temporal para comparación --->
		<cfif rsCierre.recordcount GT 0>
			<cfquery datasource="sifinterfaces">
				<cfoutput query="rsCierre">
					INSERT INTO #varLocalTempRecibo# VALUES(#Emp_id#,#Suc_id#,#Cliente_id#,#Moneda_id#,'#Recibo_Fecha#',#Monto#,
						#Operacion_id#,#Recibo_id#,'#NomDoc#')
				</cfoutput>
			</cfquery>
		</cfif>

<cfquery name="rsCierre" datasource="sifinterfaces">
	SELECT a.Emp_id,
	       a.Suc_id,
	       a.Cliente_id,
	       a.Moneda_id,
	       a.Recibo_Fecha Fecha,
	       Monto,
	       a.Operacion_id,
	       a.Recibo_id
	FROM ##LocalTempRecibo a
	WHERE RTRIM(LTRIM(a.NomDoc)) NOT IN
	    (SELECT Documento
	     FROM ESIFLD_MovBancariosCxC)
	ORDER BY a.Emp_id,
	         a.Suc_id,
	         a.Operacion_id
</cfquery>

<cfloop query="rsCierre">
	<cftransaction action="begin">
					<cftry>
						<cfquery name="rsMaxIDEnc" DataSource="sifinterfaces">
							select 	isnull(max(ID_DocumentoM),0) + 1 as MaxID
							from 	ESIFLD_MovBancariosCxC
						</cfquery>
						<cfif #rsMaxIDEnc.MaxID# GT #idEnc#>
							<cfset idEnc = #rsMaxIDEnc.MaxID#>
						</cfif>
					<cfquery name="insertEncMovBCxC" DataSource="sifinterfaces">
						INSERT INTO ESIFLD_MovBancariosCxC
								 (Ecodigo,Origen,ID_DocumentoM,Tipo_Operacion,Tipo_Movimiento,Documento,Descripcion,
								  Fecha_Recibo,Referencia,Banco_Origen,Cuenta_Origen,Moneda,Tipo_Cambio,Importe_Movimiento,
								  TpoSocio,Cliente,Sucursal,Usuario,Estatus,Fecha_Inicio_Proceso,Recibo)
						VALUES(<cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="#Emp_id#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="LD">,
							   <cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="#idEnc#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="DP">,
							   <cfqueryparam 	  cfsqltype="cf_sql_char" 	   value="C">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="RP-000#Suc_id#-#Recibo_id#-#Operacion_id#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="RP-000#Suc_id#-#Fecha#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_date" 	   value="#dateformat(Fecha,"yyyy/mm/dd")#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="000#Suc_id#-#Cliente_id#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="1234">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="9999999">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#Moneda_id#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="1">,
							   <cfqueryparam      cfsqltype="cf_sql_money"     value="#numberformat(Monto,'9.9999')#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="1">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#Cliente_id#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#Suc_Id#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="#session.usucodigo#">,
							   <cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="1">,
							   getdate(),
							   <cfqueryparam 	  cfsqltype="cf_sql_numeric"   value="#Recibo_id#">
						)
					</cfquery>

					<cfquery name="maxIDBit" DataSource="sifinterfaces">
						select (max(Proceso_Id)+1) maximo from SIFLD_Bitacora_Proceso
					</cfquery>

					<!---cfquery name="insertBitMov" DataSource="sifinterfaces">
						insert into SIFLD_Bitacora_Proceso (Proceso_Id, Sistema, Emp_id, Suc_id, Operacion_Id,Fecha_Proceso,Proceso)
							values(
									#maxIDBit.maximo#,'LD',#Emp_id#,#Suc_id#,#Operacion_id#,
									<cfqueryparam 	  cfsqltype="cf_sql_date" 	   value="#dateformat(Fecha,"yyyy/mm/dd")#">,
									<cfqueryparam 	  cfsqltype="cf_sql_varchar"   value="RECIBOSCxC">
								  )
					</cfquery--->

					<cftransaction action="commit" />

					<cfcatch type="any">
						<cfset idEnc = 1>
						<cftransaction action="rollback" />
						<cflog file="LOG_Ejecuta_Extraccion_LDCOM" application="no" text="Error al insertar encabezado #idEnc# Recibos CxC, Error: #cfcatch.Message#">
						<cfthrow message="Error al insertar encabezado #idEnc# Recibos CxC, Error: #cfcatch.Message#">
					</cfcatch>

					</cftry>
	</cftransaction>
</cfloop>


</cffunction>
</cfcomponent>