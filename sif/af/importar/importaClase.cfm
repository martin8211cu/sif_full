<cf_dbtemp name="errores" returnvariable="errores" datasource="#session.DSN#">
	 <cf_dbtempcol name="Error"   type="varchar(250)" mandatory="no">
</cf_dbtemp> 

<cfset session.Importador.SubTipo = "2">			
<cfflush interval="64">

<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetPeriodoAux" returnvariable="rsPeriodo.Pvalor"/>
<cfinvoke component="sif/Componentes/AF_ValidarActivo" method="fnGetMesAux"     returnvariable="rsMes.Pvalor"/>

<cfquery  name="rsImportador" datasource="#session.dsn#">
  select * from #table_name#
  order by ACcodigodescCat
</cfquery>
<cfquery name="rs3100" datasource="#session.dsn#">
	select Pvalor from Parametros where Ecodigo = #session.Ecodigo# and Pcodigo = 3100
</cfquery>
	<cfparam name="ActivadoNegarMejoras" default="false">
<cfif rs3100.recordcount GT 0 and rs3100.Pvalor EQ 1>
	<cfset ActivadoNegarMejoras = true>
</cfif>

<cfset LvarAntCategoria = "">
<cfloop query="rsImportador">
	<cfset session.Importador.Avance = rsImportador.currentRow/rsImportador.recordCount>
	<cfset fnImportaRegistro()>
</cfloop>		

<cfquery name="rsErrores" datasource="#session.DSN#">
	select count(1) as cantidad
	from #errores#
</cfquery>

<cfif rsErrores.cantidad gt 0>
	<cfquery name="ERR" datasource="#session.DSN#">
		select Error as MSG
		from #errores#
	</cfquery>
	<cfreturn>		
</cfif>
<cfset session.Importador.SubTipo = 3>


<cffunction name="fnImportaRegistro" access="private" output="false">
	<cfif len(trim(rsImportador.ACcodigodescCat)) neq "" and rsImportador.ACcodigodescCat NEQ LvarAntCategoria>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select 
				ACcodigo, 
				ACcodigodesc, 
				ACdescripcion, 
				ACvutil, 
				ACcatvutil, 
				ACmetododep, 
				ACmascara, 
				cuentac, 
				BMUsucodigo
			from ACategoria 
			where Ecodigo  = #Session.Ecodigo#
			and ACcodigodesc = '#rsImportador.ACcodigodescCat#'
		</cfquery>
		<cfif rsSQL.recordcount EQ 0>
			<cfquery name="ERR" datasource="#session.DSN#"><!--- Valida que la vida util no sea menor que cero--->
				insert into #errores# (Error)
				values ('Error! Codigo de Categoria #rsImportador.ACcodigodescCat# No Existe ')
			</cfquery>
			<cfreturn>
		</cfif>
		<cfset LvarACcodigo = rsSQL.ACcodigo>
		<cfset LvarAntCategoria = rsImportador.ACcodigodesc>
	</cfif>
		
	<!---Validar archivo de texto--->
	<!--- Existencia de lineas blancas en el archivo de texto--->
	<cfif len(trim(rsImportador.ACcodigodescCat)) eq 0 or len(trim(rsImportador.ACcodigodesc)) eq 0 or len(trim(rsImportador.ACdescripcion)) eq 0 or len(trim(rsImportador.ACvutil)) eq 0
		or len(trim(rsImportador.ACdepreciable)) eq 0 or len(trim(rsImportador.ACrevalua)) eq 0 or len(trim(rsImportador.ACcsuperavit)) eq 0 
		or len(trim(rsImportador.ACcadq)) eq 0 or len(trim(rsImportador.ACcdepacum)) eq 0 or len(trim(rsImportador.ACcrevaluacion)) eq 0 or len(trim(rsImportador.ACcdepacumrev)) eq 0
		or len(trim(rsImportador.ACgastodep)) eq 0 or len(trim(rsImportador.ACgastorev)) eq 0 or len(trim(rsImportador.ACtipo)) eq 0
		or len(trim(rsImportador.ACvalorres)) eq 0
		or len(trim(rsImportador.ACgastoret)) eq 0 >
			<cfquery name="ERR" datasource="#session.DSN#"><!--- Valida que la vida util no sea menor que cero--->
				insert into #errores# (Error)
				values ('Error! Existen Columnas en el archivo que estan en blanco')
			</cfquery>
			<cfreturn>
	</cfif>

	<cfquery name="rsCuenta" datasource="#session.dsn#">
		select Ccuenta
		from CContables
		where Ecodigo = #session.Ecodigo#
		  and Cformato = '#rsImportador.ACcsuperavit#'
	</cfquery>
	<cfif rsCuenta.recordcount EQ 0>
		<!---Crear cuenta financiera Superavit--->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_CFformato" 		value="#trim(rsImportador.ACcsuperavit)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Lprm_DSN" 				value="#session.dsn#"/>
			<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfset mensaje="ERROR">
			<cfthrow message="#LvarError#">									
		</cfif>
		<cfset LvarCFcuenta = request.PC_GeneraCFctaAnt.Ccuenta>
	<cfelse>
		<cfset LvarCFcuenta = rsCuenta.Ccuenta>
	</cfif>
	
	<cfquery name="rsCuenta" datasource="#session.dsn#">
		select Ccuenta
		from CContables
		where Ecodigo = #session.Ecodigo#
		  and Cformato = '#rsImportador.ACcadq#'
	</cfquery>
	<cfif rsCuenta.recordcount EQ 0>
		<!---Crear cuenta financiera Adquisicion--->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_CFformato" 		value="#trim(rsImportador.ACcadq)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Lprm_DSN" 				value="#session.dsn#"/>
			<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfset mensaje="ERROR">													
			<cfthrow message="#LvarError#">									
		</cfif>
		<cfset LvarCFcuenta2 = request.PC_GeneraCFctaAnt.Ccuenta>
	<cfelse>
		<cfset LvarCFcuenta2 = rsCuenta.Ccuenta>
	</cfif>
		
	<cfquery name="rsCuenta" datasource="#session.dsn#">
		select Ccuenta
		from CContables
		where Ecodigo = #session.Ecodigo#
		  and Cformato = '#rsImportador.ACcdepacum#'
	</cfquery>
	<cfif rsCuenta.recordcount EQ 0>
		<!---Crear cuenta financiera Depreciacion Acumulada--->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_CFformato" 		value="#trim(rsImportador.ACcdepacum)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Lprm_DSN" 				value="#session.dsn#"/>
			<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfset mensaje="ERROR">													
			<cfthrow message="#LvarError#">									
		</cfif>
		<cfset LvarCFcuenta3 = request.PC_GeneraCFctaAnt.Ccuenta>
	<cfelse>
		<cfset LvarCFcuenta3 = rsCuenta.Ccuenta>
	</cfif>
	
	<cfquery name="rsCuenta" datasource="#session.dsn#">
		select Ccuenta
		from CContables
		where Ecodigo = #session.Ecodigo#
		  and Cformato = '#rsImportador.ACcrevaluacion#'
	</cfquery>
	<cfif rsCuenta.recordcount EQ 0>
		<!---Crear cuenta financiera Revaluacion--->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_CFformato" 		value="#trim(rsImportador.ACcrevaluacion)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Lprm_DSN" 				value="#session.dsn#"/>
			<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfset mensaje="ERROR">													
			<cfthrow message="#LvarError#">									
		</cfif>
		<cfset LvarCFcuenta4 = request.PC_GeneraCFctaAnt.Ccuenta>
	<cfelse>
		<cfset LvarCFcuenta4 = rsCuenta.Ccuenta>
	</cfif>
		
	<cfquery name="rsCuenta" datasource="#session.dsn#">
		select Ccuenta
		from CContables
		where Ecodigo = #session.Ecodigo#
		  and Cformato = '#rsImportador.ACcdepacumrev#'
	</cfquery>
	<cfif rsCuenta.recordcount EQ 0>
		<!---Crear cuenta financiera Depr. Acum. Revaluación--->
		<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
			<cfinvokeargument name="Lprm_CFformato" 		value="#trim(rsImportador.ACcdepacumrev)#"/>
			<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
			<cfinvokeargument name="Lprm_DSN" 				value="#session.dsn#"/>
			<cfinvokeargument name="Lprm_Ecodigo" 			value="#session.Ecodigo#"/>
		</cfinvoke>
		<cfif LvarError NEQ "OLD" AND LvarError NEQ "NEW">
			<cfset mensaje="ERROR">													
			<cfthrow message="#LvarError#">									
		</cfif>
		<cfset LvarCFcuenta5 = request.PC_GeneraCFctaAnt.Ccuenta>
	<cfelse>
		<cfset LvarCFcuenta5 = rsCuenta.Ccuenta>
	</cfif>
	
	<!--- Si ya existe un registro con ACcodigodesc no permite insertarlo --->
	<cfquery name="rsVerifica" datasource="#session.DSN#">
		select ACcodigodesc, ACid
		from AClasificacion
		where Ecodigo = #Session.Ecodigo#
		  and ACcodigo = #LvarACcodigo#
		  and ACcodigodesc = '#rsImportador.ACcodigodesc#'
	</cfquery>	
			
	<cfif rsVerifica.recordCount eq 0>	
		<cfquery name="data" datasource="#session.DSN#">
			select max(ACid) as ACid
			from AClasificacion 
				where Ecodigo = #Session.Ecodigo#
		</cfquery>
					
		<cfif data.RecordCount gt 0 and len(trim(data.ACid))>
			<cfset vACid = data.ACid + 1>
		<cfelse>
			<cfset vACid = 1 >
		</cfif>

		<cfquery datasource="#Session.DSN#">
			insert into AClasificacion(
				Ecodigo,
				ACcodigo, 
				ACcodigodesc, 
				ACdescripcion, 
				ACvutil, 
				ACdepreciable, 
				ACrevalua, 
				ACcsuperavit, 
				ACcadq, 
				ACcdepacum, 
				ACcrevaluacion, 
				ACcdepacumrev, 
				ACgastodep, 
				ACgastorev, 
				ACtipo, 
				ACvalorres, 
				cuentac,
				ACid, 
				ACgastoret, 
				ACingresoret,
				BMUsucodigo,
				ACNegarMej

			)
			values( 
				#session.Ecodigo#,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSQL.ACcodigo#">,		
				<cfqueryparam value="#rsImportador.ACcodigodesc#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#rsImportador.ACdescripcion#" cfsqltype="cf_sql_varchar">,
				<cfif rsSQL.ACcatvutil EQ "S">
					<cfqueryparam value="#rsSQL.ACvutil#" cfsqltype="cf_sql_integer">,
				<cfelse>
					<cfqueryparam value="#rsImportador.ACvutil#" cfsqltype="cf_sql_integer">,
				
				</cfif>
				<cfif isdefined("rsImportador.ACdepreciable")>'S'<cfelse>'N'</cfif>,
				<cfif isdefined("rsImportador.ACrevalua")>'S'<cfelse>'N'</cfif>,
				<cfqueryparam value="#LvarCFcuenta#" cfsqltype="cf_sql_varchar">, 
				<cfqueryparam value="#LvarCFcuenta2#" cfsqltype="cf_sql_varchar">, 
				<cfqueryparam value="#LvarCFcuenta3#" cfsqltype="cf_sql_varchar">,
				<cfqueryparam value="#LvarCFcuenta4#" cfsqltype="cf_sql_varchar">, 
				<cfqueryparam value="#LvarCFcuenta5#" cfsqltype="cf_sql_varchar">, 
				<cfif len(trim(rsImportador.ACgastodep))><cfqueryparam value="#rsImportador.ACgastodep#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>, 
				<cfif len(trim(rsImportador.ACgastorev))><cfqueryparam value="#rsImportador.ACgastorev#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
				<cfif isdefined("rsImportador.ACtipo")>'M'<cfelse>'P'</cfif>,
				<cfqueryparam cfsqltype="cf_sql_money" value="#rsImportador.ACvalorres#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.cuentac#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#vACid#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.ACgastoret#" null="#len(trim(rsImportador.ACgastoret)) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.ACingresoret#" null="#len(trim(rsImportador.ACingresoret)) EQ 0#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				<cfif ActivadoNegarMejoras and isdefined('rsImportador.ACNegarMej') and listfind('1,S,Y',rsImportador.ACNegarMej)>1<cfelse>0</cfif>
				)
		</cfquery>
	<cfelse>

		<cfquery datasource="#session.dsn#">
			update  AClasificacion 
			set
				ACdescripcion = <cfqueryparam value="#rsImportador.ACdescripcion#" cfsqltype="cf_sql_varchar">,
				ACvutil = <cfif rsSQL.ACcatvutil EQ "S">
					<cfqueryparam value="#rsSQL.ACvutil#" cfsqltype="cf_sql_integer">,
				<cfelse>
					<cfqueryparam value="#rsImportador.ACvutil#" cfsqltype="cf_sql_integer">,
				</cfif>
				ACdepreciable 	= <cfif isdefined("rsImportador.ACdepreciable") and rsImportador.ACdepreciable EQ 'S'>'S'<cfelse>'N'</cfif>,
				ACrevalua 		= <cfif isdefined("rsImportador.ACrevalua") and rsImportador.ACrevalua EQ 'S'>'S'<cfelse>'N'</cfif>,
				ACcsuperavit 	= #LvarCFcuenta#,
				ACcadq 			= #LvarCFcuenta2#, 
				ACcdepacum 		= #LvarCFcuenta3#, 
				ACcrevaluacion 	= #LvarCFcuenta4#, 
				ACcdepacumrev 	= #LvarCFcuenta5#, 
				ACgastodep 		= <cfif len(trim(rsImportador.ACgastodep))><cfqueryparam value="#rsImportador.ACgastodep#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>, 
				ACgastorev 		= <cfif len(trim(rsImportador.ACgastorev))><cfqueryparam value="#rsImportador.ACgastorev#" cfsqltype="cf_sql_varchar"><cfelse>null</cfif>,
				ACtipo 			= <cfif isdefined("rsImportador.ACtipo")>'M'<cfelse>'P'</cfif>,
				ACvalorres 		= <cfqueryparam cfsqltype="cf_sql_money"   value="#rsImportador.ACvalorres#">,
				cuentac			= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.cuentac#">,
				ACgastoret 		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.ACgastoret#" null="#len(trim(rsImportador.ACgastoret)) EQ 0#">,
				ACingresoret	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImportador.ACingresoret#" null="#len(trim(rsImportador.ACingresoret)) EQ 0#">,<!------>
				ACNegarMej		= <cfif ActivadoNegarMejoras and isdefined('rsImportador.ACNegarMej') and listfind('1,S,Y',rsImportador.ACNegarMej)>1<cfelse>0</cfif>
			where Ecodigo		= #Session.Ecodigo#
			  and ACcodigo 		= #LvarACcodigo#
              and ACid     		= #rsVerifica.ACid#
			  and ACcodigodesc 	= '#rsImportador.ACcodigodesc#'
		</cfquery>
	</cfif>
</cffunction>

