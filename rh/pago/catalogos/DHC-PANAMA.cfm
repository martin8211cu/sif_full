<!-----========= Traduccion =============---->
<cfinvoke component="sif.Componentes.Translate" method="Translate" Key="MSG_LaNominaNoExiste" Default="La nomina no existe" returnvariable="MSG_LaNominaNoExiste"/> 
<cfparam name="url.Bid" 		type="numeric">	
<cfparam name="url.EcodigoASP" 	type="numeric" default="#session.EcodigoSDC#">	
<cfparam name="url.ERNid" 		type="numeric">	

<cfset vb_nominahist = false>	<!---TRUE:Indica que la nomina SI es historica---->
<cfset vb_nomina = true>		<!----Indica si Existe la nomina---->

<cf_dbtemp name="Datos" returnvariable="Datos" datasource="#session.DSN#"><!---Tabla temporal de datos que van a ser insertados ---->
	<cf_dbtempcol name="Identificacion" 	type="varchar(15)"  mandatory="no">
	<cf_dbtempcol name="Empleado" 			type="varchar(22)"  mandatory="no">
	<cf_dbtempcol name="RegistroBanco" 		type="varchar(2)"  	mandatory="no">
	<cf_dbtempcol name="CuentaEmpleado" 	type="varchar(17)"  mandatory="no">
	<cf_dbtempcol name="TipoCuenta" 		type="varchar(2)"  	mandatory="no">
	<cf_dbtempcol name="MontoDepositado" 	type="float"  		mandatory="no">
	<cf_dbtempcol name="Credito" 			type="varchar(1)"  	mandatory="no">
	<cf_dbtempcol name="Descripcion" 		type="varchar(80)"  mandatory="no">
</cf_dbtemp>

<!---====== 1. Verificar si toma los datos de nominas sin cerrar o de historicas ====---->
<cfquery name="rsNominaHist" datasource="#session.DSN#">
	Select 1 from HERNomina 
	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
</cfquery>
<cfif rsNominaHist.RecordCount EQ 0>	
	<cfquery name="rsNominaAct" datasource="#session.DSN#">
		Select 1 from ERNomina 
		where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
	</cfquery>
	<cfif rsNominaAct.RecordCount EQ 0>
		<cfquery name="ERR" datasource="#session.DSN#">
			select '#MSG_LaNominaNoExiste#' as Error
			from dual
		</cfquery>
		<cfset vb_nomina = false>
	</cfif>
<cfelse>
	<cfset vb_nominahist=true>
</cfif>

<cfif vb_nomina><!----Si existe la nomina--->
	<cfif vb_nominahist><!----La Nomina es historica---->
		<cfquery datasource="#session.DSN#"	>
			Insert into #Datos# (Identificacion,Empleado,RegistroBanco,CuentaEmpleado,TipoCuenta,MontoDepositado,Credito,Descripcion)
			Select 	<cf_dbfunction name="string_part"   args="upper(DEidentificacion),1,15">,
					<!---{fn concat(upper(DEnombre),{fn concat(' ',{fn concat(upper(DEapellido1),{fn concat(' ',upper(DEapellido2))})})})},---->
					<cf_dbfunction name="concat" args="upper(DEnombre),' ',upper(DEapellido1),' ',upper(DEapellido2)">,	
					'71' as RegistroBanco,
					coalesce(DEcuenta,' ') as CuentaEmpleado,
					Case when b.CBTcodigo= 1 then '04'  else '03' end as TipoCuenta,
					HDRNliquido as MontoDepositado,
					'C' as Credito,
					<cf_dbfunction name="concat" args="'REF*TXT**',upper(c.HERNdescripcion)">
			from HERNomina c
				inner join HDRNomina b 
					on b.ERNid = c.ERNid
				inner join DatosEmpleado a
					on a.DEid=b.DEid
			Where c.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		</cfquery>
	<cfelse>
		<cfquery datasource="#session.DSN#"	>
			Insert into #Datos# (Identificacion,Empleado,RegistroBanco,CuentaEmpleado,TipoCuenta,MontoDepositado,Credito,Descripcion)
			Select 	<cf_dbfunction name="string_part"   args="upper(DEidentificacion),1,15">,
					<!----<cf_dbfunction name="concat" args="DEnombre,' ',DEapellido1,' ',DEapellido2">,---->
					{fn concat(upper(DEnombre),{fn concat(' ',{fn concat(upper(DEapellido1),{fn concat(' ',upper(DEapellido2))})})})},
					'71' as RegistroBanco,
					coalesce(DEcuenta,' ') as CuentaEmpleado,
					Case when b.CBTcodigo= 1 then '04'  else '03' end as TipoCuenta,
					DRNliquido as MontoDepositado,
					'C' as Credito,
					<cf_dbfunction name="concat" args="'REF*TXT**',upper(c.HERNdescripcion)">
			from ERNomina c
				inner join DRNomina b
					on  b.ERNid = c.ERNid
				inner join DatosEmpleado a
					on a.DEid=b.DEid				
			where c.ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.ERNid#">
		</cfquery>		
	</cfif>
	<!----=============== Cortar los campos ===============----->
	<cfquery datasource="#session.DSN#">
		update #Datos# set Empleado = <cf_dbfunction name="string_part"   args="upper(Empleado),1,22">
	</cfquery>
	<cfquery datasource="#session.DSN#">
		update #Datos# set Descripcion = <cf_dbfunction name="string_part"   args="upper(Descripcion),1,80">
	</cfquery>
	<!----=============== Reemplazar los caracteres que no se permiten (Tildes,Ñ,Ü)===============---->
	<cfif ListFind('sybase,sqlserver', Application.dsinfo[session.DSN].type)><!---Sybase/SqlServer---->
		<!---- Identificacion ---->
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = str_replace(Identificacion,'Á','A')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = str_replace(Identificacion,'É','E')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = str_replace(Identificacion,'Í','I')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = str_replace(Identificacion,'Ó','O')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = str_replace(Identificacion,'Ú','U')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = str_replace(Identificacion,'Ñ','N')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = str_replace(Identificacion,'Ü','U')	</cfquery>
		<!---- Empleado ---->		
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = str_replace(Empleado,'Á','A')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = str_replace(Empleado,'É','E')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = str_replace(Empleado,'Í','I')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = str_replace(Empleado,'Ó','O')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = str_replace(Empleado,'Ú','U')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = str_replace(Empleado,'Ñ','N')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = str_replace(Empleado,'Ü','U')	</cfquery>
		<!----Descripcion---->
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = str_replace(Descripcion,'Á','A') </cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = str_replace(Descripcion,'É','E')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = str_replace(Descripcion,'Í','I')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = str_replace(Descripcion,'Ó','O')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = str_replace(Descripcion,'Ú','U')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = str_replace(Descripcion,'Ñ','N')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = str_replace(Descripcion,'Ü','U')</cfquery>
	<cfelse><!-----Oracle----->
		<!---- Identificacion ---->
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = replace(Identificacion,'Á','A')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = replace(Identificacion,'É','E')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = replace(Identificacion,'Í','I')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = replace(Identificacion,'Ó','O')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = replace(Identificacion,'Ú','U')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = replace(Identificacion,'Ñ','N')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Identificacion = replace(Identificacion,'Ü','U')	</cfquery>
		<!---- Empleado ---->
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = replace(Empleado,'Á','A')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = replace(Empleado,'É','E')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = replace(Empleado,'Í','I')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = replace(Empleado,'Ó','O')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = replace(Empleado,'Ú','U')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = replace(Empleado,'Ñ','N')	</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Empleado = replace(Empleado,'Ü','U')	</cfquery>
		<!----Descripcion---->
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = replace(Descripcion,'Á','A')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = replace(Descripcion,'É','E')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = replace(Descripcion,'Í','I')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = replace(Descripcion,'Ó','O')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = replace(Descripcion,'Ú','U')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = replace(Descripcion,'Ñ','N')</cfquery>
		<cfquery datasource="#session.DSN#">update #Datos# set Descripcion = replace(Descripcion,'Ü','U')</cfquery>		
	</cfif>
	<cfquery name="ERR" datasource="#session.DSN#">
		select * from #Datos#
	</cfquery>	
</cfif>

