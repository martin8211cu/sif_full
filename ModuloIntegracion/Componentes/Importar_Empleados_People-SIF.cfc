<cfcomponent>

<cfsetting requesttimeout="36000">

<cffunction name="Ejecuta" access="public" returntype="string" output="no">
	
<!---Obtiene los caches para la busqueda de las ordenes de pago --->
<cfquery datasource="asp" name="rscaches">
     select e.Ereferencia as Ecodigo, e.CEcodigo, c.Ccache
     from Empresa e
     join Caches c
     on e.Cid = c.Cid and e.Ereferencia is not null
     and e.Ereferencia = 22
</cfquery>

<cf_dbtemp name="TmpEmpPeople" returnvariable="TmpEmpPeople" datasource="#rsCaches.Ccache#">
			<cf_dbtempcol name="EMPLID" type="numeric">
			<cf_dbtempcol name="FIRST_NAME" type="varchar(50)">
			<cf_dbtempcol name="LAST_NAME" type="varchar(50)">
			<cf_dbtempcol name="SECOND_LAST_NAME" type="varchar(50)">
			<cf_dbtempcol name="ACCT_CD" type="varchar(25)">
			<cf_dbtempcol name="BIRTHDATE" type="datetime">
			<cf_dbtempcol name="SEX" type="char(1)">
			<cf_dbtempcol name="BIRTHCOUNTRY" type="char(5)">
			<cf_dbtempcol name="EMAIL_ADDR" type="varchar(70)">
			<cf_dbtempcol name="NAME" type="varchar(100)">	
</cf_dbtemp>

<!----Se obtiene el codigo de la moneda Local---->
<cfquery name="rsMoneda" datasource="#rsCaches.Ccache#">
	select Mcodigo, Mnombre, Miso4217 from Monedas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rscaches.Ecodigo#">
	and Miso4217 = 'MXP'
</cfquery>

<cfquery name="rsEmpleados" datasource="peoplesoft">
	SELECT
      PE.EMPLID,   --Matricula
      PD.FIRST_NAME,  --Nombre
      PD.LAST_NAME,   --1er Apellido
      PD.SECOND_LAST_NAME,  --2o Apellido
      PE.ACCT_CD,  --Centro Funcional
      PD.BIRTHDATE,  --Cumpleaños
      PD.SEX,  --Sexo
      PD.BIRTHCOUNTRY,  --Pais de nacimiento
      EM.EMAIL_ADDR,  --Correo electronico
      PD.NAME 
      FROM PS_JOB PE
      INNER JOIN PS_PERSONAL_DATA PD ON PE.EMPLID = PD.EMPLID
      INNER JOIN PS_PERS_NID ES ON PE.EMPLID = ES.EMPLID
      LEFT OUTER JOIN PS_EMAIL_ADDRESSES EM ON PD.EMPLID = EM.EMPLID
      WHERE ES.NATIONAL_ID_TYPE = 'RFC'
      AND PE.EMPLID NOT LIKE 'TAB%'
      AND PE.EFFDT =  (SELECT MAX(EFFDT) FROM PS_JOB B1
                 WHERE B1.EMPLID = PE.EMPLID
                 AND B1.EMPL_RCD = PE.EMPL_RCD)
      AND PE.EFFSEQ = (SELECT MAX(B_ES.EFFSEQ) FROM PS_JOB B_ES
                 WHERE B_ES.EMPLID = PE.EMPLID
                 AND B_ES.EMPL_RCD = PE.EMPL_RCD
                 AND B_ES.EFFDT = PE.EFFDT)
      AND PE.ACCT_CD <> ''
      AND EM.EMAIL_ADDR like '%@pmicim.com'
      AND PE.EMPL_STATUS in ('A')
      ORDER BY PE.ACCT_CD
</cfquery>


<cfif isdefined("rsEmpleados") and rsEmpleados.recordcount GT 0>
	<cfloop query="rsEmpleados">
		<cfquery datasource="#rsCaches.Ccache#">	
				insert into #TmpEmpPeople#
						(EMPLID,
						 FIRST_NAME,
						 LAST_NAME,
						 SECOND_LAST_NAME,
						 ACCT_CD,
			             BIRTHDATE,
						 SEX,
						 BIRTHCOUNTRY,
						 EMAIL_ADDR,
						 NAME)
					values
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEmpleados.EMPLID#">,
 						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleados.FIRST_NAME#">,
  						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleados.LAST_NAME#">,
 						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleados.SECOND_LAST_NAME#">,
  						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleados.ACCT_CD#">,
						 <cfqueryparam cfsqltype="cf_sql_date" value="#rsEmpleados.BIRTHDATE#">,
  						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleados.SEX#">,
 						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleados.BIRTHCOUNTRY#">,
  						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleados.EMAIL_ADDR#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEmpleados.NAME#">)
		</cfquery>		
	</cfloop>
		
	<!----Obtiene los registros nuevos--->
	<cfquery name="rsReg" datasource="#rsCaches.Ccache#">
 		select EMPLID, FIRST_NAME, LAST_NAME, SECOND_LAST_NAME, ACCT_CD, BIRTHDATE, SEX, BIRTHCOUNTRY, EMAIL_ADDR, NAME
		from #TmpEmpPeople# P
		where not exists (select 1 from DatosEmpleado E where convert(integer,E.DEidentificacion) = convert(integer,P.EMPLID))
	</cfquery>		
	
	<cfquery name="rsActCF" datasource="#rsCaches.Ccache#">
 		select EMPLID, FIRST_NAME, LAST_NAME, SECOND_LAST_NAME, ACCT_CD, BIRTHDATE, SEX, BIRTHCOUNTRY, EMAIL_ADDR, NAME,
		DE.DEid, CF.CFid, CF.CFcodigo, ltrim(rtrim(TP.EMPLID)) as EMPid, ltrim(rtrim(DE.DEidentificacion)) as Identifica, DE.DEnombre
		from #TmpEmpPeople# TP
		inner join DatosEmpleado DE on convert(integer,TP.EMPLID) = convert(integer,DE.DEidentificacion)
		inner join EmpleadoCFuncional EC on DE.DEid = EC.DEid and GETDATE() between  convert(datetime,ECFdesde) and convert(datetime,ECFhasta) 
		inner join CFuncional CF on EC.CFid = CF.CFid
		where
		convert(integer,ACCT_CD) != convert(integer,CF.CFcodigo) AND CFcodigo != 'RAIZ'
		and convert(integer,DE.DEidentificacion) = convert(integer,TP.EMPLID)
	</cfquery>		
	
	<!---Obtiene los empleados dados de baja en People que siguen activos en SOIN---->
	<cfquery name="rsBajasSoin" datasource="#rsCaches.Ccache#">
 		select DE.DEid, CF.CFid, DE.DEnombre, DE.DEapellido1, DE.DEapellido2, CF.CFcodigo
		from DatosEmpleado DE 
		inner join EmpleadoCFuncional EC on DE.DEid = EC.DEid 
		inner join CFuncional CF on EC.CFid = CF.CFid
		where not exists (select 1 from #TmpEmpPeople# T where convert(integer,T.EMPLID) = convert(integer,DE.DEidentificacion))
		and DEidentificacion <= 3000
	</cfquery>
</cfif>

<cfif isdefined("rsReg") and rsReg.recordcount GT 0>
<cftransaction action="begin">
<cftry>
	<cfloop query="rsReg">
		<cfquery name="rsCF" datasource="#rsCaches.Ccache#">
			select CFid, CFcodigo from CFuncional 
			where CFcodigo = convert(varchar(5),convert(integer,#rsReg.ACCT_CD#))
		</cfquery>
		
		<cfif rsCF.recordcount EQ 0>
			<cfthrow message="El Centro Funcional #rsReg.ACCT_CD# no es valido en SOIN">
		</cfif>
		
		<cfquery name="rsInsertDatosEmp" datasource="#rsCaches.Ccache#">
			insert into DatosEmpleado
				(Ecodigo,
				Bid,
				NTIcodigo,
				DEidentificacion,
				DEnombre,
				DEapellido1,
				DEapellido2,
				CBcc,
				Mcodigo,
				DEemail,
				DEcivil, 
				DEfechanac,
				DEsexo,
				DEcantdep,
				Usucodigo,
				Ulocalizacion,
				DEsistema,
				Ppais,
				DEdato1,
				BMUsucodigo)
			values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#rscaches.Ecodigo#">,
				 1, <!----????---->
				 'G', <!----????---->
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReg.EMPLID#">,
 				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReg.FIRST_NAME#">,
  				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReg.LAST_NAME#">,
 				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReg.SECOND_LAST_NAME#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsReg.EMPLID#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsMoneda.Mcodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReg.EMAIL_ADDR#">,
				 0, 
				 <cfqueryparam cfsqltype="cf_sql_date" value="#rsReg.BIRTHDATE#">,
  				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReg.SEX#">,
				 0, 
				 6, <!---Usuuario SOIN--->
				 00,
				 1,
				 'MX',
				 'NO',
				 6) <!---Usucodigo SOIN--->
				 
 				<cf_dbidentity1 datasource="#rsCaches.Ccache#" verificar_transaccion="false">
			</cfquery>
			<cf_dbidentity2 datasource="#rsCaches.Ccache#" name="rsIdEmp" verificar_transaccion="false">
						
			<cfquery datasource="#rsCaches.Ccache#">	
				insert into EmpleadoCFuncional
						(DEid,
						 CFid,
						 Ecodigo,
						 ECFdesde,
						 ECFhasta,
					     BMUsucodigo,
						 ECFencargado)
					values
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsIdEmp.Identity#">,
 						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsCF.CFid#">,
  						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rscaches.Ecodigo#">,
 						 getdate(),
  						 getdate() + (datediff(dd,getdate(),'01/01/6100')),
						 6,
						 0)
			</cfquery>
	
			<cfquery name="rsEmpleadosSOIN" datasource="#rsCaches.Ccache#">
				select EMPLID
				from #TmpEmpPeople# P
				where not exists (select 1 from TESbeneficiario 
							   where TESBeneficiarioId = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReg.EMPLID#">)
			</cfquery>
			
			<cfif isdefined("rsEmpleadosSOIN") and rsEmpleadosSOIN.recordcount GT 0>
				<cfquery datasource="#rsCaches.Ccache#">
					insert into TESbeneficiario
						(CEcodigo,
						 TESBeneficiarioId,
						 TESBeneficiario,
						 BMUsucodigo,
					 	 TESBtipoId,
						 TESBemail,
						 TESRPTCid,
						 DEid,
						 TESBactivo,
						 Ecodigo)
					values
						(<cfqueryparam cfsqltype="cf_sql_integer" value="#rscaches.CEcodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReg.EMPLID#">,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReg.NAME#">,
						 6,
						 'F',
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsReg.EMAIL_ADDR#">,
						 1,
						 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsIdEmp.Identity#">,
						 1,
						 <cfqueryparam cfsqltype="cf_sql_integer" value="#rscaches.Ecodigo#">)
				</cfquery>
			</cfif>
	</cfloop>
	<cftransaction action="commit"/>
	<cfcatch>
		<cftransaction action="rollback"/>
		<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
		<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
		<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif> 

<!----Actualiza los empleados cuyo Centro Funcional haya cambiado--->	
<cfif isdefined("rsActCF") and rsActCF.recordcount GT 0>
	<cftransaction action="begin">
	<cftry>
		<cfloop query="rsActCF">
			<cfquery name="rsCF" datasource="#rsCaches.Ccache#">
				select CFid, CFcodigo from CFuncional 
				where CFcodigo = convert(varchar(5),convert(integer,#rsActCF.ACCT_CD#))
			</cfquery>
		
			<cfif rsCF.recordcount EQ 0>
				<cfthrow message="El Centro Funcional #rsActCF.ACCT_CD# no es valido en SOIN">
			</cfif>
		
			<cfquery datasource="#rsCaches.Ccache#">
				update EmpleadoCFuncional set ECFhasta = getdate() -1
				where CFid =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsActCF.CFid#"> 
				and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsActCF.DEid#">
				and GETDATE() between  convert(datetime,ECFdesde) and convert(datetime,ECFhasta)
			</cfquery>
			
			<cfquery name="rsInsertDatosEmp" datasource="#rsCaches.Ccache#">
				insert into EmpleadoCFuncional
					(DEid,
					 CFid,
					 Ecodigo,
					 ECFdesde,
					 ECFhasta,
					 BMUsucodigo,
					 ECFencargado)
				values
					 (<cfqueryparam cfsqltype="cf_sql_integer" value="#rsActCF.DEid#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#rsCF.CFid#">,
					  <cfqueryparam cfsqltype="cf_sql_integer" value="#rscaches.Ecodigo#">,
					  getdate(),
  					  getdate() + (datediff(dd,getdate(),'01/01/6100')),
					  6,
					  0)					  
			</cfquery>		
		</cfloop>
	
		<cftransaction action="commit"/>
	<cfcatch>
	<cftransaction action="rollback"/>
		<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
		<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
		<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif> 

<!----Elimina da de baja los empleados en SOIN---->
<cfif isdefined("rsBajasSoin") and rsBajasSoin.recordcount GT 0>
<cftransaction action="begin">
<cftry>
	<cfloop query="rsBajasSoin">
		<cfquery datasource="#rsCaches.Ccache#">
			update EmpleadoCFuncional set ECFhasta = getdate() -1
			where CFid =  <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsBajasSoin.CFid#"> 
			and DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsBajasSoin.DEid#">
			and GETDATE() between  convert(datetime,ECFdesde) and convert(datetime,ECFhasta)
		</cfquery>
		
		<cfquery datasource="#rsCaches.Ccache#">
			update TESbeneficiario set TESBactivo = 0
			where DEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsBajasSoin.DEid#">
		</cfquery>
	</cfloop>
	
	<cftransaction action="commit"/>
	<cfcatch>
		<cftransaction action="rollback"/>
		<cfif isdefined("cfcatch.sql")> <cfset ErrSQL = cfcatch.sql> <cfelse> <cfset ErrSQL = ""> </cfif>
		<cfif isdefined("cfcatch.where")> <cfset ErrPar = cfcatch.where> <cfelse> <cfset ErrPar = ""> </cfif>
		<cfthrow message="#cfcatch.Message#" detail="#cfcatch.Detail# #ErrSQL# #ErrPar#">
	</cfcatch>
	</cftry>
	</cftransaction>
</cfif>
</cffunction>
</cfcomponent>
 
 




		

             