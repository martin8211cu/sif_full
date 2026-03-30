<!--- IMPADQ: Importador de Transacciones para Gestión de Activo Fijos--->
<!--- Tabla Temporal de Errores --->
<cf_dbtemp name="ERRORES_TEMP" returnvariable="ERRORES_TEMP" datasource="#session.dsn#">
	<cf_dbtempcol name="Mensaje" type="varchar(255)" mandatory="yes">
	<cf_dbtempcol name="documento" type="varchar(20)" mandatory="no">
	<cf_dbtempcol name="ErrorNum" type="integer" mandatory="yes">
</cf_dbtemp>
<CFSET fecha  = CreateDateTime(YEAR(Now()),MONTH(Now()),DAY(Now()), 0,0,0)>
<!--- 1. Valida errores de inconsistencia en el archivo --->
<cfset VALIDACION = true>
<cfset procesar = false>
<!--- Inicial el proceso de validacion de datos  --->

<!--- *****************************************  --->
<!--- *** VALIDA QUE EL ARCHIVO TENGA DATOS ***  --->
<!--- *****************************************  --->
<cfquery name="CantReg" datasource="#Session.Dsn#">
	select 1
	from #table_name#
</cfquery>
<cfif CantReg.recordcount EQ 0>
	<cfset VALIDACION = false>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		values('El archivo de importación no tiene líneas',1,null)
	</cfquery>
<cfelse>
	<!--- **********************************************  --->
	<!--- *** VALIDA QUE NO EXISTAN PLACAS REPETIDAS ***  --->
	<!--- **********************************************  --->
	<cfquery name="Cantplacas" datasource="#Session.Dsn#">
		select  count(distinct placa) as cant_placas  from #table_name# 
	</cfquery>
	
	<cfif isdefined("Cantplacas") and  CantReg.recordcount neq Cantplacas.cant_placas>
		<cfset VALIDACION = false>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
			values('El archivo de importación tiene placas repetidas',2,null)
		</cfquery>
	</cfif>
	<!--- **************************************************  --->
	<!--- *** VALIDA QUE NO EXISTAN DOCUMENTOS REPETIDOS ***  --->
	<!--- **************************************************  --->
	<cf_dbfunction name="OP_concat" returnvariable="_cat">
	<cfquery name="Cantdocumentos" datasource="#Session.Dsn#">
		select count(distinct documento #_cat# <cf_dbfunction name="to_char" args="linea" isnumber="no">) as cant_docs
			from #table_name# 
	</cfquery>

	<cfif isdefined("Cantdocumentos") and  CantReg.recordcount neq Cantdocumentos.cant_docs>
		<cfset VALIDACION = false>
		<cfquery name="INS_Error" datasource="#session.DSN#">
			insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
			values('El archivo de importación tiene documentos repetidos',3,null)
		</cfquery>
	</cfif>
</cfif>

<cfif VALIDACION> 
	<!--- ****************************************  --->
	<!--- *** VALIDA QUE LA  MONEDA SEA VALIDA ***  --->
	<!--- ****************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene una moneda que no existe ('+ x.moneda +')'"  delimiters= '+' returnvariable="MsgError4" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError4)#,4,x.documento
		from #table_name# x
		where  ltrim(rtrim(x.moneda)) not in (
			select ltrim(rtrim(b.Miso4217)) 
			from Monedas b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfquery>
	<!--- **************************************************  --->
	<!--- *** VALIDA QUE EL SOCIO DE NEGOCIOS SEA VALIDO ***  --->
	<!--- **************************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene un socio de negocios que no existe ('+ x.socio +')'"  delimiters= '+' returnvariable="MsgError5" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError5)#,5,x.documento
		from #table_name# x
		where  ltrim(rtrim(x.socio)) not in (
			select ltrim(rtrim(b.SNnumero)) 
			from SNegocios b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfquery>
	<!--- ***********************************************  --->
	<!--- *** VALIDA QUE CUENTA FINANCIERA SEA VALIDA ***  --->
	<!--- ***********************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene una cuenta financiera que no existe ('+ x.cuenta +')'"  delimiters= '+' returnvariable="MsgError6" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError6)#,6,x.documento
		from #table_name# x
		where  ltrim(rtrim(x.cuenta)) not in (
			select ltrim(rtrim(b.CFformato)) 
			from CFinanciera b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfquery>
	<!--- ******************************************  --->
	<!--- *** VALIDA QUE LA CATEGORIA SEA VALIDA ***  --->
	<!--- ******************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene una categoría que no existe ('+ x.categoria +')'"  delimiters= '+' returnvariable="MsgError7" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError7)#,7,x.documento
		from #table_name# x
		where  ltrim(rtrim(x.categoria)) not in (
			select ltrim(rtrim(b.ACcodigodesc)) 
			from ACategoria b
			where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">)
	</cfquery>
	<!--- **********************************************  --->
	<!--- *** VALIDA QUE LA CLASIFICACIÓN SEA VALIDA ***  --->
	<!--- **********************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene una clasificación que no existe ('+ x.clase +')'"  delimiters= '+' returnvariable="MsgError8" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError8)#,8,x.documento
		from #table_name# x
			where not exists (
			  select 1 from ACategoria f 
				inner join AClasificacion g 
					on g.Ecodigo = #Session.Ecodigo# 
					and g.ACcodigo = f.ACcodigo 	
				where f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and rtrim(f.ACcodigodesc) = x.categoria
					and rtrim(g.ACcodigodesc) = x.clase
			 )
	</cfquery>	
	<!--- **************************************  --->
	<!--- *** VALIDA QUE LA MARCA SEA VALIDA ***  --->
	<!--- **************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene una marca que no existe ('+ x.marca +')'"  delimiters= '+' returnvariable="MsgError9" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError9)#,9,x.documento
		from #table_name# x
			where not exists (
				select 1 from AFMarcas h 
				where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and rtrim(h.AFMcodigo) = x.marca
			)
	</cfquery>
	<!--- ***************************************  --->
	<!--- *** VALIDA QUE EL MODELO SEA VALIDA ***  --->
	<!--- ***************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene un modelo que no existe ('+ x.modelo +') para la Marca indicada'"  delimiters= '+' returnvariable="MsgError10" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError10)#,10,x.documento
		from #table_name# x
		where not exists (
			select 1 from AFMarcas h 
				inner join AFMModelos i 
					on i.Ecodigo = #Session.Ecodigo# 
					and i.AFMid = h.AFMid 
			where h.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and rtrim(h.AFMcodigo) = x.marca
			  and rtrim(i.AFMMcodigo) = x.modelo
		)
	</cfquery>
	<!--- *************************************************  --->
	<!--- *** VALIDA QUE EL CENTRO FUNCIONAL SEA VALIDA ***  --->
	<!--- *************************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene un centro funcional que no existe ('+ x.centrofuncional +')'"  delimiters= '+' returnvariable="MsgError11" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError11)#,11,x.documento
		from #table_name# x
		where not exists (
			select 1 from CFuncional j 
			where j.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and rtrim(j.CFcodigo) = x.centrofuncional	
			)
	</cfquery>
	<!--- ********************************************  --->
	<!--- *** VALIDA QUE LA ADQUISICION SEA VALIDA ***  --->
	<!--- ********************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene un activo que ya fue Adquirido'"  delimiters= '+' returnvariable="MsgError12" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError12)#,12,x.documento
		from #table_name# x
		where exists 	( select 1 from EAadquisicion k 
							where k.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
								and x.codigotransaccion = k.EAcpidtrans  
								and rtrim(x.documento) = k.EAcpdoc
								and x.linea = k.EAcplinea 
						)
	</cfquery>
	<!--- ***************************************  --->
	<!--- *** VALIDA QUE EL ACTIVO SEA VALIDA ***  --->
	<!--- ***************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene un placa que ya fue asignada'"  delimiters= '+' returnvariable="MsgError13" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError13)#,13,x.documento
		from #table_name# x
		where exists 	( select 1 from Activos a 
							where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and rtrim(a.Aplaca)    = x.placa 
						)
	</cfquery>	
	<!--- *****************************************  --->
	<!--- *** VALIDA QUE EL EMPLEADO SEA VALIDA ***  --->
	<!--- *****************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene un empleado responsable que no existe ('+ x.empleado +')'"  delimiters= '+' returnvariable="MsgError14" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError14)#,14,x.documento
		from #table_name# x
		where not exists 	( select 1 from DatosEmpleado n 
							  where n.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							  and rtrim(n.DEidentificacion) = x.empleado
						     )
	</cfquery>
	<!--- ****************************************  --->
	<!--- *** VALIDA QUE EL ALMACEN SEA VALIDA ***  --->
	<!--- ****************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene un almacen que no existe ('+ x.almacen +')'"  delimiters= '+' returnvariable="MsgError15" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError15)#,15,x.documento
		from #table_name# x
		where not exists ( select 1 from Almacen o 
							where o.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
							and rtrim(o.Almcodigo) = x.almacen
						  )
	</cfquery>
	<!--- **********************************************  --->
	<!--- *** VALIDA QUE LA CLASIFICACION SEA VALIDA ***  --->
	<!--- **********************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene un tipo que no existe ('+ x.tipo +')'"  delimiters= '+' returnvariable="MsgError16" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError16)#,16,x.documento
		from #table_name# x
		where not exists ( select 1 from AFClasificaciones p 
							where p.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						    and rtrim(p.AFCcodigoclas) = x.tipo
						)
	</cfquery>
	<!--- **************************************************************  --->
	<!--- *** VALIDA QUE EL MONTO DE LA ADQUISION SEA MAYOR QUE CERO ***  --->
	<!--- **************************************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' el monto es menor o igual a cero'"  delimiters= '+' returnvariable="MsgError17" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError17)#,17,x.documento
		from #table_name# x
		where x.monto <= 0
	</cfquery>
	<!--- ******************************************************************  --->
	<!--- *** VALIDA QUE LA FECHA DE ADQUISICION SEA MENOR O IGUAL A HOY ***  --->
	<!--- ******************************************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene la fecha de adquisición superior a la del día de la exportación'"  delimiters= '+' returnvariable="MsgError18" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError18)#,18,x.documento
		from #table_name# x
		where x.fecha > <cfqueryparam cfsqltype="cf_sql_date" value="#fecha#">
	</cfquery>
	<!--- *******************************************************************  --->
	<!--- *** VALIDA QUE LA FECHA DE INICIO DE DEPRECIACION Y REVALUACION ***  --->
	<!--- *** SEA IGUAL O MAYOR A LA FECHA DE ADQUISICION                 ***  --->
	<!--- *******************************************************************  --->
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene la fecha de inicio de depreciación menor a la fecha de adquisición'"  delimiters= '+' returnvariable="MsgError19" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError19)#,19,x.documento
		from #table_name# x
		where x.fechainidep < x.fecha
	</cfquery>
	<cf_dbfunction name="concat" args="'El documento :' + x.documento + ' tiene la  fecha de revaluación  menor a la fecha de adquisición'"  delimiters= '+' returnvariable="MsgError20" >
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum,documento)
		select #PreserveSingleQuotes(MsgError20)#,20,x.documento
		from #table_name# x
		where x.fechainirev < x.fecha
	</cfquery>
	
	
	<cfquery name="err" datasource="#session.dsn#">
		select Mensaje
		from #ERRORES_TEMP#
		order by documento,ErrorNum
	</cfquery>
	<cfif (err.recordcount) EQ 0>
		<!--- **********************************************  --->
		<!--- *** TODAS LAS VALIDACIONES ESTA CORRECTAS  ***  --->
		<!--- *** INICIA EL PROCESO DE INSERCION         ***  --->
		<!--- **********************************************  --->	
		<cfquery name="rsPeriodo" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Pcodigo = 50
				and Mcodigo = 'GN'
		</cfquery>
		<cfset Periodo = rsPeriodo.Pvalor >
		<cfquery name="rsMes" datasource="#session.dsn#">
			select <cf_dbfunction name="to_number" args="Pvalor" datasource="#session.dsn#"> as Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and Pcodigo = 60
				and Mcodigo = 'GN'
		</cfquery>
		<cfset Mes = rsMes.Pvalor >
		<cfquery datasource="#Session.Dsn#" name="RsEadquisicion">
			insert into EAadquisicion
				(Ecodigo, EAcpidtrans, EAcpdoc, EAcplinea, 
				Ocodigo, Aid, EAPeriodo, EAmes, EAFecha, Mcodigo, 
				EAtipocambio, Ccuenta, 
				SNcodigo, EAdescripcion,
				EAcantidad, EAtotalori, EAtotalloc, EAstatus, 
				EAselect, Usucodigo, BMUsucodigo)
			select #Session.Ecodigo#, a.codigotransaccion, a.documento, a.linea, 
					j.Ocodigo, m.Aid, #Periodo#, #Mes#,  a.fecha, k.Mcodigo,
					a.tcambio, 
					(select min(Ccuenta) 
								from CFinanciera 
								where Ecodigo = #Session.Ecodigo# 
								  and rtrim(CFformato) = rtrim(a.cuenta)) as Ccuenta
					,  l.SNcodigo, a.descripcion,
					1, a.monto, round(a.monto * a.tcambio,2) , 0,
					0, #Session.Usucodigo#,#Session.Usucodigo#
			from #table_name# a
				left outer join CFinanciera d 
					on d.Ecodigo = #Session.Ecodigo# 
					and d.CFformato = a.cuenta
				left outer join ACategoria f 
					on f.Ecodigo = #Session.Ecodigo# 
					and f.ACcodigodesc = a.categoria
				left outer join AClasificacion g 
					on g.Ecodigo = #Session.Ecodigo# 
					and g.ACcodigo = f.ACcodigo 
					and g.ACcodigodesc = a.clase
				left outer join AFMarcas h 
					on h.Ecodigo = #Session.Ecodigo# 
					and h.AFMcodigo = a.marca
				left outer join AFMModelos i 
					on i.Ecodigo = #Session.Ecodigo# 
					and i.AFMid = h.AFMid 
					and i.AFMMcodigo = a.modelo
				left outer join CFuncional j 
					on j.Ecodigo = #Session.Ecodigo# 
					and j.CFcodigo = a.centrofuncional	
				left outer join Monedas k
					on  k.Ecodigo = #Session.Ecodigo# 
					and k.Miso4217 = a.moneda
				left outer join SNegocios l
					on  l.Ecodigo = #Session.Ecodigo# 
					and l.SNnumero = a.socio
				left outer join Almacen m
					on  m.Ecodigo = #Session.Ecodigo# 
					and m.Almcodigo = a.almacen
		</cfquery>
			
		<cfquery datasource="#Session.Dsn#" name="RsDadquisicion">
			insert into DAadquisicion 
			(Ecodigo, EAcpidtrans, EAcpdoc, EAcplinea, 
			DAlinea, DAtc, DAmonto, Usucodigo, BMUsucodigo)
		
			select #Session.Ecodigo#, a.codigotransaccion, a.documento, a.linea, 
					1, a.tcambio, a.monto, #Session.Usucodigo#,#Session.Usucodigo#
			from #table_name# a
		</cfquery>
			
		<cfquery datasource="#Session.Dsn#" name="RsDSActivosAdq">
			insert into DSActivosAdq 
				(Ecodigo
				, EAcpidtrans
				, EAcpdoc
				, EAcplinea
				, DAlinea
				, AFMid
				, AFMMid
				, CFid
				, DEid
				, Alm_Aid
				, Aid
				, Mcodigo
				, AFCcodigo
				, DSAtc
				, SNcodigo
				, ACcodigo
				, ACid
				, DSdescripcion
				, DSserie
				, DSplaca
				, DSfechainidep
				, DSfechainirev
				, DSmonto
				, Status
				, Usucodigo
				, BMUsucodigo)
				select 
				#Session.Ecodigo#
				, a.codigotransaccion
				, a.documento
				, a.linea
				, 1
				, h.AFMid 
				, i.AFMMid
				, j.CFid
				, de.DEid
				, m.Aid
				,<CF_jdbcquery_param cfsqltype="cf_sql_numeric" value="null"> as Aid
				, k.Mcodigo
				, afc.AFCcodigo
				, a.tcambio
				, l.SNcodigo
				, f.ACcodigo
				, g.ACid
				, a.descripcion
				, a.serie
				, a.placa
				, a.fechainidep
				, a.fechainirev
				, a.monto
				, 0
				, #Session.Usucodigo# 
				, #Session.Usucodigo#
				from #table_name# a
				left outer join CFinanciera d 
					on d.Ecodigo = #Session.Ecodigo# 
					and d.CFformato = a.cuenta
				left outer join ACategoria f 
					on f.Ecodigo = #Session.Ecodigo# 
					and f.ACcodigodesc = a.categoria
				left outer join AClasificacion g 
					on g.Ecodigo = #Session.Ecodigo# 
					and g.ACcodigo = f.ACcodigo 
					and g.ACcodigodesc = a.clase
				left outer join AFMarcas h 
					on h.Ecodigo = #Session.Ecodigo# 
					and h.AFMcodigo = a.marca
				left outer join AFMModelos i 
					on i.Ecodigo = #Session.Ecodigo# 
					and i.AFMid = h.AFMid 
					and i.AFMMcodigo = a.modelo
				left outer join CFuncional j 
					on j.Ecodigo = #Session.Ecodigo# 
					and j.CFcodigo = a.centrofuncional	
				left outer join Monedas k
					on  k.Ecodigo = #Session.Ecodigo# 
					and k.Miso4217 = a.moneda
				left outer join SNegocios l
					on  l.Ecodigo = #Session.Ecodigo# 
					and l.SNnumero = a.socio
				left outer join Almacen m
					on  m.Ecodigo = #Session.Ecodigo# 
					and m.Almcodigo = a.almacen
				left outer join DatosEmpleado de
					on de.Ecodigo = #Session.Ecodigo# 
					and de.DEidentificacion = a.empleado
				left outer join AFClasificaciones afc
					on  afc.Ecodigo = #Session.Ecodigo# 
					and afc.AFCcodigoclas = a.tipo	
		</cfquery>
	</cfif>
<cfelse>
	<cfquery name="err" datasource="#session.dsn#">
		select Mensaje
		from #ERRORES_TEMP#
		order by documento,ErrorNum
	</cfquery>	
</cfif>
<!--- ********************************************************************************************************************************************************* --->
