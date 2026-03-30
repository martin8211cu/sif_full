<cffunction name="insertCuenta" >
	<cfargument name="parametro" type="string" required="yes">
	<cfargument name="descripcion" type="string" required="yes">
	<cfargument name="Cformato" type="string" required="yes">
	<cfargument name="modulo" type="string" required="yes">
	
	<cfquery name="rsCuenta" datasource="#session.DSN#">
		select Ccuenta
		from CContables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Cformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(arguments.Cformato)#">
	</cfquery>

	<cfquery name="rsExiste" datasource="#session.DSN#">
		select 1
		from  Parametros
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(parametro)#">
	</cfquery>

	<cfif rsExiste.recordCount gt 0>
		<cfquery name="update" datasource="#session.DSN#">
			update Parametros
			set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuenta.Ccuenta#">
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#trim(parametro)#">
		</cfquery>
	<cfelse>
		<cfquery name="insert" datasource="#session.DSN#">
			insert into Parametros(Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
			values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
					 <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.parametro#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.modulo#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.descripcion#">,
					 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCuenta.Ccuenta#"> )
		</cfquery>
	</cfif>
</cffunction>

<!--- inserta los parametros, depende del catalogo elegido, por eso se meten fijas --->
<cfif form.WTCid eq 1 >
	<cfset insertCuenta('70','Cuenta de Descuentos Ventas','4000-0001-0001','CC')>
	<cfset insertCuenta('80','Cuenta de Descuentos Compras','4000-0003-0001','CP')>
	<cfset insertCuenta('90','Cuenta Contable Mov. entre Sucursales','1000-0001-0002-005','GN')>
	<cfset insertCuenta('100','Cuenta de Ajuste por Redondeo de Monedas','2000-0002-0001','GN')>
	<cfset insertCuenta('110','Cuenta de Ingreso por Dif. Camb.','4000-0002-0002','CC')>
	<cfset insertCuenta('120','Cuenta de Egreso por Dif. Cam.','5000-0003-0003','CC')>
	<cfset insertCuenta('130','Cuenta de Ingreso por Diferencial Cambiario.','4000-0002-0002','CP')>
	<cfset insertCuenta('140','Cuenta de Ingreso por Diferencial Cambiario.','5000-0003-0003','CP')>
	<cfset insertCuenta('150','Cuenta Contable de Retenciones','1000-0001-0003-002-001','GN')>
	<cfset insertCuenta('180','Cuenta de Anticipos Clientes','1000-0001-0002-003','CC')>
	<cfset insertCuenta('190','Cuenta de Anticipos Proveedores','2000-0002-0001','CP')>
	<cfset insertCuenta('240','Cuenta de Activos en Tránsito','1000-0002-0003','AF')>
	<cfset insertCuenta('200','Cuenta de Balance Multimoneda','5000-0003-0003','CG')>
	<cfset insertCuenta('260','Cuenta de Ingreso por Diferencial Cambiario.','4000-0002-0002','CG')>
	<cfset insertCuenta('270','Cuenta de Egreso por Diferencial Cambiario.','5000-0003-0003','CG')>					
	<cfset insertCuenta('290','Cuenta de Utilidad del Período','3000-0005','CG')>
	<cfset insertCuenta('300','Cuenta de Utilidad Acumulada','3000-0004','CG')>
	<cfset insertCuenta('350','Cuenta de Caja CxC','1000-0001-0001-001','FA')>
</cfif>
