<!--- OPARRALES Proceso creado especificamente para Tiendas FULL --->
<head>
<title><cf_translate key="ImportacionEnProceso">Importaci&oacute;n en progreso</cf_translate></title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cf_templatecss>
</head>

<cffile charset="us-ascii" action="upload"
	destination="#GetTempDirectory()#"
	filefield="archivo"
	nameconflict="MakeUnique">
<cfset uploadedFilename=#cffile.serverDirectory# & "/" & #cffile.serverFile#>

<cfscript>
	ios  = CreateObject("java", "java.io.FileInputStream");
	frdr = CreateObject("java", "java.io.FileReader");
	lrdr = CreateObject("java", "java.io.LineNumberReader");

	// contar lineas
	frdr.init(uploadedFilename);
	lrdr.init(frdr);
	t1=now();
	while (true) {
		line = lrdr.readLine();
		if (Not IsDefined("line")) {
			break;
		}
	}
	total_lineas = lrdr.getLineNumber();

	frdr.close();
	lrdr.close();

	// abrir archivos para leer datos
	frdr.init(uploadedFilename);
	lrdr.init(frdr);
	t2=now();

	// Validador de fechas
	//datevalid = CreateObject("java", "java.text.SimpleDateFormat");
	//datevalid.init("yyyyMMdd");
</cfscript>

<cfif IsDefined('form.TTcodigo') and Trim(form.TTcodigo) neq ''>
	<cfset form.Tcodigo = Trim(form.TTcodigo)>
	<cfset form.CPid = form.TCPid>
</cfif>

<cfset arrEmpl = ArrayNew(1)>
<cfset objEmps = StructNew()>

<cfset objActualCod = "">
<cfset factorFaltas = 1.17>

<cfloop from="1" to="#total_lineas#" index="counter">
	<cfset line=lrdr.readLine()>
	<cfset line2 = Trim(line)>


	<cfif Right(line2,2) eq 'R"'>
		<cfset varArrTempObj = ListToArray(line2,';',true,false)>
		<!--- Variables para armar objeto --->
		<cfset varCod = varArrTempObj[1]>
		<cfset DEIdentificacion = RepeatString('0',4-Len(Trim(varCod))) & varCod>
		<cfset DiasHoras = varArrTempObj[2]>
		<cfset varFaltas = "#Left(varArrTempObj[3],2)#.#Right(varArrTempObj[3],3)#">
		<cfset varHorasExtra = "#Left(varArrTempObj[4],2)#.#Right(varArrTempObj[4],2)#">
		<cfset varHorasEspeciales = "#Left(varArrTempObj[5],2)#.#Right(varArrTempObj[5],2)#">
		<cfset DiasExtras = varArrTempObj[6]>
		<cfset DiasEspeciales = varArrTempObj[7]>
		<cfset Periodo = varArrTempObj[8]>


		<!--- CREAMOS OBJETO NUEVO --->
		<cfset objActual = getEmpleadoObj(DEIdentificacion,DiasHoras,varFaltas,varHorasExtra,varHorasEspeciales,DiasExtras,DiasEspeciales,Periodo)>
		<cfscript>
			StructInsert(#objEmps#,#DEIdentificacion#,#objActual#);
		</cfscript>
		<cfset objActualCod = DEIdentificacion>

	<cfelseif Left(line,1) eq '|' and not StructIsEmpty(objEmps)>
		<!--- Complementamos el contenido del objeto con sus  --->
		<cfset arrInc = ListToArray(line,';',false,false)>
		<cfset objTemp = objEmps['#objActualCod#']>

		<cfif FindNoCase('1PA',arrInc[1]) neq 0>
			<cfset objTemp.Monto1PA = arrInc[2]>
		<cfelseif FindNoCase('1PP',arrInc[1]) neq 0>
			<cfset objTemp.Monto1PP = arrInc[2]>
		<cfelseif FindNoCase('1DD',arrInc[1]) neq 0>
			<cfset objTemp.Monto1DD = arrInc[2]>
		<cfelseif FindNoCase('1DF',arrInc[1]) neq 0>
			<cfset objTemp.Monto1DF = arrInc[2]>
		<cfelse>
			<cfthrow detail="El archivo no tiene un contenido valido.">
		</cfif>
		<cfscript>
			StructUpdate(objEmps,#objActualCod#,objTemp);
		</cfscript>
	<cfelse>
		<cfthrow detail="El archivo no tiene un contenido valido.">
	</cfif>

</cfloop>

<cfset contador = 1>

<!--- ITERAMOS LA ESTRUCTURA DE OBJETOS Y DEFINIMOS SI LLEVA INCIDENCIAS O SOLO ACCIONES --->
<cfset countObj = 1>
<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")>

<cftransaction>
	<cfloop collection="#objEmps#" item="key">
		<cfset unObj = objEmps['#key#']>
		
		<!--- VALIDANDO BLOQUE PARA INSERTAR ACCIONES --->
		<cfquery name="rsEmp" datasource="#session.dsn#">
			select
				de.DEid,
				coalesce(te.TEid,0) TEid,
				coalesce(te.TEcodigo,'') TEcodigo,
				DEidentificacion
			from DatosEmpleado de
			left join TiposEmpleado te
				on te.TEid = de.DEtipocontratacion
				and te.Ecodigo = de.Ecodigo
			where de.DEidentificacion = <cfqueryparam cfsqltype="cf_sql_varchar" value="#key#">
			and de.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsEmp.RecordCount eq 0>
			<cfthrow detail="No existe el empleado con el codigo #key#">
		</cfif>

		<cfif rsEmp.TEcodigo eq ''>
			<cfthrow detail="El empleado con el codigo #key# no tiene asigando un TIPO.">
		</cfif>

		<!--- Fechas de calendario de pago segun el tipo de Nomina --->
		<cfif Trim(form.Tcodigo) eq '01'>
			<cfquery name="rsUltimaAccion" datasource="#session.dsn#">
				select
					top 1 Tcodigo,
					dle.RHTid,
					DLsalario as LTsalario,
					dle.DLfvigencia as LTdesde,
					ta.RHTcomportam
				from DLaboralesEmpleado dle
				inner join RHTipoAccion ta
					on ta.RHTid = dle.RHTid
					and ta.Ecodigo = dle.Ecodigo
				where dle.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">
				and dle.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and ta.RHTcomportam in (1,6,8)<!--- Nombramientos, Cambios, Aumentos --->
				order by DLfechaaplic desc
			</cfquery>
		<cfelse><!--- Trim(form.Tcodigo) eq '02' temporada --->
			<cfquery name="rsUltimaAccion" datasource="#session.dsn#">
				select
					top 1 Tcodigo,
					dle.RHTid,
					LTsalario,
					dle.LTdesde,
					ta.RHTcomportam
				from LineaTiempo dle
				inner join RHTipoAccion ta
					on ta.RHTid = dle.RHTid
					and ta.Ecodigo = dle.Ecodigo
				where dle.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">
				and dle.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				and ta.RHTcomportam in (1,6,8)<!--- Nombramientos, Cambios, Aumentos --->
				order by LTdesde desc
			</cfquery>

		</cfif>
		<cfquery name="rsCalendario" datasource="#session.dsn#">
			select CPdesde, CPhasta
			from CalendarioPagos
			where CPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPid#">
			and Tcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Trim(form.Tcodigo)#">
		</cfquery>

		<cfif rsUltimaAccion.RecordCount gt 0 and rsUltimaAccion.RHTcomportam eq 2 and DateDiff("d",rsUltimaAccion.LTdesde,rsCalendario.CPhasta) gte 0>
			<cfthrow detail="El empleado con el codigo #key# esta dado de baja.">
		</cfif>

		<!--- OPARRALES 2019-03-20 Obtener dias de incapacidad del empleado --->
		<cfquery name="rsInc" datasource="#session.dsn#">
			SELECT
				CASE
					<!--- Validacion cuando la incapacidad empieza antes y termina despues del periodo de pago seleccionado --->
					WHEN lt.LTdesde < '#rsCalendario.CPdesde#' AND lt.LThasta > '#rsCalendario.CPhasta#'
						THEN DATEDIFF(DD,'#rsCalendario.CPdesde#','#rsCalendario.CPhasta#')+1
					<!--- Validacion cuando las fechas de la incapacidad dentro del periodo de pago seleccionado --->
					WHEN lt.LTdesde >= '#rsCalendario.CPdesde#' AND lt.LThasta <= '#rsCalendario.CPhasta#'
						THEN DATEDIFF(DD, LTdesde, lt.LThasta)+1
					<!--- Validacion cuando la incapacidad empieza antes o igual de la fecha inicio del periodo de pago 
							pero termina antes o igual de la fecha fin del periodo de pago seleccionado --->
					WHEN lt.LTdesde <= '#rsCalendario.CPdesde#' AND lt.LThasta <= '#rsCalendario.CPhasta#'
						THEN DATEDIFF(DD, '#rsCalendario.CPdesde#', lt.LThasta)+1
					<!--- Validacion cuando la incapacidad empieza igual o despues de la fecha inicio del periodo de pago 
							pero termina despues o igual de la fecha fin del periodo de pago seleccionado --->
					WHEN lt.LTdesde >= '#rsCalendario.CPdesde#' AND lt.LThasta >= '#rsCalendario.CPhasta#'
						THEN DATEDIFF(DD, lt.LTdesde, '#rsCalendario.CPhasta#')+1
				END AS PEcantdias
			FROM LineaTiempo lt
			INNER JOIN RHTipoAccion ta 
				ON ta.RHTid = lt.RHTid
			AND lt.Ecodigo = ta.Ecodigo
			WHERE 
				lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			AND ta.RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="5">
			AND (
					'#rsCalendario.CPdesde#' BETWEEN lt.LTdesde AND lt.LThasta
					OR '#rsCalendario.CPhasta#' BETWEEN lt.LTdesde AND lt.LThasta
					or lt.LTdesde between '#rsCalendario.CPdesde#' and '#rsCalendario.CPhasta#'
					or lt.LThasta between '#rsCalendario.CPdesde#' and '#rsCalendario.CPhasta#'
				)
			AND lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">
		</cfquery>
		
		<cfset horasFalta = 0>
		<cfset varDiasHorasFalta = ''>
		<cfset DiasFalta  = 0>
		<cfset varDiasInc = 0>

		<cfif rsInc.recordCount gt 0>
			<!--- Validacion para tope de dias de incapacidad por nomina  --->
			<cfset diasNomina = DateDiff('d',rsCalendario.CPdesde,rsCalendario.CPhasta)+1>
			
			<cfif rsInc.PEcantdias gte diasNomina>
				<cfset varDiasInc = diasNomina>
			<cfelse>
				<cfset varDiasInc = rsInc.PEcantdias>
			</cfif>
		</cfif>

		<!---========== OBTENEMOS DIAS Y FRACCION EN HORAS SOBRE LAS FALTAS =========--->
		<cfif unObj.Faltas gt 0>
			<!--- Definimos fecha inicio y fecha fin del las faltas --->
			<cfset varDias = unObj.Faltas>
			<cfset arrFaltas = ListToArray(varDias,'.',false,true)>
			<cfset varTotDias = val(arrFaltas[1])>
			<!--- <cfset varTotDias = (varTotDias eq 1 ? 0 : varTotDias)> --->

			<cfset DiasFalta = varTotDias>

			<!--- Asignamos la proporcion de la falta en horas para agregarlo como Incidencia --->
			<cfif Trim(arrFaltas[2]) neq '' and val(arrFaltas[2]) gt 0>
				<cfset horasFalta = Val(arrFaltas[2])>
				<cfset varUltimodiaHors = (Round(varDias) gte varDias ? Round(varDias) : varDias+1)>
				<cfset varDiasHorasFalta = LSDateFormat(DateAdd("d",varUltimodiaHors,rsCalendario.CPdesde),'YYYY-MM-dd')>
			</cfif>

		</cfif>

		<cfif DiasFalta gt 0>
			<!--- Tipos de Empleado
			    - 01 Planta
			    - 02 Temporada

			    Verificar que los Tipos de accion esten definidos
			 --->

			<cfset varCodAccion = (rsEmp.TEcodigo eq '01' ? '04' : '04T')>
			<cfquery name="rsAccion" datasource="#session.dsn#">
				select
					RHTid
				from RHTipoAccion
				where RHTcomportam = <cfqueryparam cfsqltype="cf_sql_numeric" value="13"><!--- Faltas / Ausentismos --->
				and RHTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#varCodAccion#">
			</cfquery>

			<cfif rsAccion.RecordCount eq 0>
				<cfthrow detail="El tipo de acci�n con el codigo #varCodAccion# no ha sido definido.">
			</cfif>

			<cfset varCPHasta = LSDateFormat(DateAdd("d",varTotDias-1,rsCalendario.CPdesde),'YYYY-MM-dd')>

			<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
				insert into RHAcciones (Ecodigo, DEid, RHTid, DLfvigencia, DLffin, DLobs, Usucodigo, Ulocalizacion, EcodigoRef,RHAporcsal,
										RHItiporiesgo, RHIconsecuencia, RHIcontrolincapacidad, RHfolio, RHporcimss,BMUsucodigo,BMfecha,Tcodigo)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsAccion.RHTid#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsCalendario.CPdesde)#">,
					<cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(varCPHasta)#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="FALTA CARGADA DESDE IMPORTADOR">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">,
					null,
					-1,
					null,null,null
					,null,null
					,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
					,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					,<cfqueryparam cfsqltype="cf_sql_char" value="#form.Tcodigo#">
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_RHAcciones">

			<cfquery name="rsEstadoActual" datasource="#Session.DSN#">
	            select a.LTid,
	            		<!--- rtrim(a.Tcodigo) as Tcodigo, --->
	            		rtrim('#Trim(form.Tcodigo)#') as Tcodigo,
	                   a.RHCPlineaP,
	                   a.RVid,
	                   a.Ocodigo,
	                   a.Dcodigo,
	                   a.RHPid,
	                   rtrim(a.RHPcodigo) as RHPcodigo,
	                   (select min(coalesce(ltrim(rtrim(ff.RHPcodigoext)),rtrim(ltrim(ff.RHPcodigo))))
	                            from RHPuestos ff
	                            where ff.Ecodigo = a.Ecodigo
	                               and ff.RHPcodigo = a.RHPcodigo
	                            ) as RHPcodigoext,
	                   a.RHJid,
	                   a.LTporcplaza,
	                   a.LTporcsal,
	                   a.LTsalario,
	                   a.RHCPlinea,
	                   a.RHPcodigoAlt,
	                  (select  min(c.Descripcion)
	                    from RegimenVacaciones c
	                    where a.RVid = c.RVid
	                  ) as RegVacaciones,
	                  (select min(d.Odescripcion)
	                    from Oficinas d
	                    where a.Ocodigo = d.Ocodigo
	                        and a.Ecodigo = d.Ecodigo
	                  ) as Odescripcion,
	                  (select min(e.Ddescripcion)
	                    from Departamentos e
	                    where a.Dcodigo = e.Dcodigo
	                        and a.Ecodigo = e.Ecodigo
	                  ) as Ddescripcion,
	                   f.RHPdescripcion,
	                   rtrim(f.RHPcodigo) as CodPlaza,

	                   (select min(coalesce(ltrim(rtrim(fx.RHPcodigoext)),rtrim(ltrim(fx.RHPcodigo))))
	                            from RHPuestos fx
	                            where fx.Ecodigo = a.Ecodigo
	                               and fx.RHPcodigo = a.RHPcodigo
	                     ) as CodPuesto,
	                   f.Dcodigo as CodDepto,
	                   f.Ocodigo as CodOfic,
	                   {fn concat(rtrim(f.RHPcodigo),{fn concat(' - ',f.RHPdescripcion)})}	as Plaza,
	                   (select min(g.RHPdescpuesto)
	                    from RHPuestos g
	                    where g.RHPcodigo = a.RHPcodigo
	                        and g.Ecodigo = a.Ecodigo
	                    ) as RHPdescpuesto,
	                   (select 	min({fn concat(rtrim(coalesce(ltrim(rtrim(g.RHPcodigoext)),ltrim(rtrim(g.RHPcodigo)))),{fn concat(' - ',g.RHPdescpuesto)})})
	                    from RHPuestos g
	                    where g.RHPcodigo = a.RHPcodigo
	                      and g.Ecodigo = a.Ecodigo
	                   ) as Puesto,
	                  (select 	min({fn concat(rtrim(j.RHJcodigo),{fn concat(' - ',j.RHJdescripcion)})})
	                    from RHJornadas j
	                    where  a.Ecodigo = j.Ecodigo
	                        and a.RHJid = j.RHJid
	                  )	as Jornada,
	                   s.RHTTid as RHTTid1,rtrim(s.RHTTcodigo) as RHTTcodigo1, s.RHTTdescripcion as RHTTdescripcion1,
	                   s2.RHTTid as RHTTid2, rtrim(s2.RHTTcodigo) as RHTTcodigo2, s2.RHTTdescripcion as RHTTdescripcion2,
	                   u.RHMPPid as RHMPPid1,rtrim(u.RHMPPcodigo) as RHMPPcodigo1, u.RHMPPdescripcion as RHMPPdescripcion1,
	                   u2.RHMPPid as RHMPPid2,rtrim(u2.RHMPPcodigo) as RHMPPcodigo2, u2.RHMPPdescripcion as RHMPPdescripcion2,
	                   t.RHCid as RHCid1, rtrim(t.RHCcodigo) as RHCcodigo1, t.RHCdescripcion as RHCdescripcion1,
	                   t2.RHCid as RHCid2,rtrim(t2.RHCcodigo) as RHCcodigo2, t2.RHCdescripcion as RHCdescripcion2,
	                   s.RHTTid as RHTTid3,rtrim(s.RHTTcodigo) as RHTTcodigo3, s.RHTTdescripcion as RHTTdescripcion3,
	                   s2.RHTTid as RHTTid4, rtrim(s2.RHTTcodigo) as RHTTcodigo4, s2.RHTTdescripcion as RHTTdescripcion4,
	                   u.RHMPPid as RHMPPid3,rtrim(u.RHMPPcodigo) as RHMPPcodigo3, u.RHMPPdescripcion as RHMPPdescripcion3,
	                   u2.RHMPPid as RHMPPid4,rtrim(u2.RHMPPcodigo) as RHMPPcodigo4, u2.RHMPPdescripcion as RHMPPdescripcion4,
	                   t.RHCid as RHCid3, rtrim(t.RHCcodigo) as RHCcodigo3, t.RHCdescripcion as RHCdescripcion3,
	                   t2.RHCid as RHCid4,rtrim(t2.RHCcodigo) as RHCcodigo4, t2.RHCdescripcion as RHCdescripcion4,

	                  (select 	min({fn concat(ltrim(rtrim(cf.CFcodigo)),{fn concat(' ',ltrim(rtrim(cf.CFdescripcion)))})})
	                   from CFuncional cf
	                    where f.CFid = cf.CFid
	                        and f.Ecodigo = cf.Ecodigo
	                  )	as Ctrofuncional,
	                   pp.RHPPid,
	                   pp.RHPPcodigo,
	                   pp.RHPPdescripcion,
	                   ltp.RHMPnegociado

	            from LineaTiempo a

	                 inner join RHPlazas f
	                    on a.RHPid = f.RHPid
	                    and a.Ecodigo = f.Ecodigo

	                    <!---====================================================================================
	                            Se une con la linea del tiempo de la plaza presup. para obtener los datos de la plaza de RH
	                            en el momento de la accion, se verifica que el puesto de RH tenga asignado el mismo
	                            puesto presupuestario de plaza presup.
	                        ===============================================================================---->
	                        left outer join RHLineaTiempoPlaza ltp
	                            on f.RHPid = ltp.RHPid
	                            and  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPdesde#"> between ltp.RHLTPfdesde
	                                and ltp.RHLTPfhasta

	                            left outer join RHPlazaPresupuestaria pp
	                                on ltp.RHPPid = pp.RHPPid
	                                and ltp.Ecodigo = pp.Ecodigo

	                 left outer join RHCategoriasPuesto r
	                    on r.RHCPlinea = a.RHCPlinea

	                 left outer join RHTTablaSalarial s
	                    on s.RHTTid = r.RHTTid

	                 left outer join RHCategoria t
	                    on t.RHCid = r.RHCid

	                left outer join RHMaestroPuestoP u 	<!----Puesto presupuestario ----->
	                    on r.RHMPPid = u.RHMPPid

	                <!---En caso de que existas puesto-categorias propuestos--->
	                    left outer join RHCategoriasPuesto r2
	                        on r2.RHCPlinea = a.RHCPlineaP

	                     left outer join RHTTablaSalarial s2
	                        on s2.RHTTid = r2.RHTTid

	                     left outer join RHCategoria t2
	                        on t2.RHCid = r2.RHCid

	                    left outer join RHMaestroPuestoP u2 	<!----Puesto presupuestario ----->
	                        on r2.RHMPPid = u2.RHMPPid
	            where <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsCalendario.CPhasta#"> between a.LTdesde and a.LThasta
	            and a.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#" null="#Len(rsEmp.DEid) is 0#">
	            and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
	        </cfquery>

			<cfset varRHAlinea = ABC_RHAcciones.identity>
			<cfset varCSid = 0>
			<cfif IsDefined('rsEstadoActual.RHCid3') and Trim(rsEstadoActual.RHCid3) neq ''>
				<cfquery name="rsCS" datasource="#session.dsn#">
					select CSid from RHMontosCategoria
					where RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHCid3#">
				</cfquery>
				<cfif rsCS.RecordCount gt 0>
					<cfset varCSid = rsCS.CSid>
				</cfif>
			</cfif>

			<cfquery name="rsCatPaso" datasource="#Session.DSN#">
				select RHCPlinea
				from RHCategoriasPuesto
				where RHTTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHTTid3#">
				and RHCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHCid3#">
				and RHMPPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHMPPid3#">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			</cfquery>

			<cfquery name="rsNegociado" datasource="#Session.DSN#">
				select a.RHMPnegociado
				from RHLineaTiempoPlaza a
				where a.RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHPid#">
				and <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(rsCalendario.CPdesde)#"> between a.RHLTPfdesde and a.RHLTPfhasta
			</cfquery>

			<cfset LvarNegociado = (rsNegociado.RHMPnegociado EQ 'N')>

			<cfquery name="rsEquipararLineaTiempo" datasource="#Session.DSN#">
				insert into RHDAcciones (RHAlinea, CSid, RHDAtabla, RHDAunidad, RHDAmontobase, RHDAmontores,RHDAmetodoC, Usucodigo, Ulocalizacion)
				select <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHAlinea#"  null="#Len(varRHAlinea) is 0#">,
					   a.CSid, a.DLTtabla,
					   coalesce(a.DLTunidades, 1.00),
					   case
				   			when d.RHMCcomportamiento is not null and d.RHMCcomportamiento = 2 then
								round(coalesce(a.DLTmonto, 0.00) / coalesce(a.DLTunidades, 1.00), 2) * 100
				   			else
								(case
									when a.DLTmetodoC is not null then
										coalesce(a.DLTmonto, 0.00)
									else round(coalesce(a.DLTmonto, 0.00) / coalesce(a.DLTunidades, 1.00), 2)
								end)
				   	   end as DLTmontobase,
					   coalesce(a.DLTmonto, 0.00),
					   coalesce(a.DLTmetodoC,''),
					   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					   <cfqueryparam cfsqltype="cf_sql_char" value="#Session.Ulocalizacion#">
				from DLineaTiempo a
					left outer join RHMetodosCalculo d
						on d.CSid = a.CSid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#rsCalendario.CPdesde#"> between d.RHMCfecharige and d.RHMCfechahasta
						and d.RHMCestadometodo = 1
				where a.LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.LTid#">
				and not exists (
					select 1
					from RHDAcciones b
					where b.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHAlinea#" null="#Len(varRHAlinea) is 0#">
					and b.CSid = a.CSid
				)
				<cf_dbidentity1 datasource="#Session.DSN#">
			</cfquery>
			<cf_dbidentity2 datasource="#Session.DSN#" name="ABC_RHDAccionesD">
			<cfset varRHDAccionesD = ABC_RHDAccionesD.identity>

			<cfquery name="toUpd" datasource="#Session.DSN#">
				update RHAcciones set
					<!--- Cambio de Empresa --->
					RVid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RVid#">
					 , Dcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEstadoActual.Dcodigo#">
					 , Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEstadoActual.Ocodigo#">
					 , RHPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHPid#">
					 , RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsEstadoActual.RHPcodigo#">
					 , RHAporc = <cfqueryparam cfsqltype="cf_sql_float" value="#rsEstadoActual.LTporcplaza#">
					 , RHAporcsal = <cfqueryparam cfsqltype="cf_sql_float" value="#rsEstadoActual.LTporcsal#">
					 , RHJid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHJid#">

					<!---
					<cfif Len(Trim(Form.DLobs)) NEQ 0>
					, DLobs = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.DLobs#">
					<cfelse>
					, DLobs =  null
					</cfif>
					<cfif isdefined('Form.RHAvdisf') and Len(Trim(Form.RHAvdisf)) NEQ 0>
					, RHAvdisf = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHAvdisf#">
					<cfelse>
					, RHAvdisf =  null
					</cfif>
					<cfif isdefined('Form.RHAvcomp') and Len(Trim(Form.RHAvcomp)) NEQ 0>
					, RHAvcomp = <cfqueryparam cfsqltype="cf_sql_float" value="#Form.RHAvcomp#">
					<cfelse>
					, RHAvcomp =  null
					</cfif>
					 --->
					<!--- Categor�a Puesto --->
					<cfif isdefined('rsCatPaso.RHCPlinea') and Len(Trim(rsCatPaso.RHCPlinea)) NEQ 0>
					, RHCPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCatPaso.RHCPlinea#">
					<cfelse>
					, RHCPlinea =  null
					</cfif>
					<!--- Categor�a Puesto Propuesta--->
					<cfif isdefined('rsEstadoActual.RHCPlineaP') and Len(Trim(rsEstadoActual.RHCPlineaP)) NEQ 0>
					, RHCPlineaP = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEstadoActual.RHCPlineaP#">
					<cfelse>
					, RHCPlineaP =  null
					</cfif>
					<!--- Puesto Alterno--->
					<!--- <cfif isdefined('RHPcodigoAlt') and Len(Trim(RHPcodigoAlt)) NEQ 0>
					, RHPcodigoAlt = <cfqueryparam cfsqltype="cf_sql_char" value="#form.RHPcodigoAlt#">
					<cfelse>
					, RHPcodigoAlt =  null
					</cfif> --->
					<!--- Cambio de Empresa --->

					, TcodigoRef = null
					<!--- Neogciado --->
					<cfif LvarNegociado>
					, Indicador_de_Negociado = 1
					<cfelse>
					, Indicador_de_Negociado = 0
					</cfif>
					<!--- <cfif isdefined("form.RHAdiasenfermedad") and len(trim(form.RHAdiasenfermedad))>
						, RHAdiasenfermedad = <cfqueryparam cfsqltype="cf_sql_float" value="#replace(form.RHAdiasenfermedad, ',','','all')#">
					<cfelse>
						, RHAdiasenfermedad = null
					</cfif> --->
	                      <!--- Tipo de aplicacion, solo componentes o todo --->
	                ,RHTipoAplicacion = 0
					,BMUsucodigo 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					 BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHAlinea#">
			</cfquery>

			<cfif varCSid neq 0>
				<cfquery datasource="#session.dsn#">
					update RHDAcciones
						set CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCSid#">
					where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHAlinea#">
					and CSid not in (select obj.CSid from RHDAcciones obj where obj.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHAlinea#">)
					and CSid <> <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCSid#">
				</cfquery>
			</cfif>

			<!--- Averiguar si hay que utilizar la tabla salarial --->
			<cfquery name="rsTipoTabla" datasource="#Session.DSN#">
				select CSusatabla
				from ComponentesSalariales
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				<cfif varCSid neq 0>
					and CSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varCSid#">
				<cfelse>
					and CSsalariobase = 1
				</cfif>
			</cfquery>

			<cfif rsTipoTabla.recordCount GT 0>
				<cfset usaEstructuraSalarial = rsTipoTabla.CSusatabla>
			<cfelse>
				<cfset usaEstructuraSalarial = 0>
			</cfif>

			<cfquery name="rsDetAct" datasource="#session.dsn#">
				select
					RHDAlinea,
					RHAlinea,
					CSid,
					RHDAtabla,
					RHDAunidad,
					RHDAmontobase,
					RHDAmontores,
					Usucodigo,
					Ulocalizacion,
					BMUsucodigo,
					RHDAporcplazacomponente,
					BMfechamodif,
					RHDAmetodoC,
					BMfecha
				from RHDAcciones
				where RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHDAccionesD#">

			</cfquery>

			<cfif usaEstructuraSalarial EQ 1 >
				<cfset Lvar_RHTTid = 0>
				<cfset Lvar_RHMPPid = 0>
				<cfset Lvar_RHCid = 0>
				<cfquery name="rsAccionES" datasource="#Session.DSN#">
					select
						b.DEid,b.DLfvigencia, coalesce(b.DLffin,'61000101') as DLffin,
						b.RHCPlinea as RHCPlinea, a.CSid,a.RHDAmetodoC,RHPcodigoAlt,
						coalesce(RHCPlineaP,0) as RHCPlineaP
					from RHDAcciones a, RHAcciones b
					where a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHDAccionesD#">
					and a.RHAlinea = b.RHAlinea
				</cfquery>
				<cfset Lvar_CatAlt = (rsAccionES.RHCPlinea eq '' ? 0 : rsAccionES.RHCPlinea)>
				<cfif isdefined('rsEstadoActual.RHTTid3') and Len(Trim(rsEstadoActual.RHTTid3)) and rsEstadoActual.RHTTid3 GT 0>
					<cfset Lvar_RHTTid = rsEstadoActual.RHTTid3>
					<cfset Lvar_RHMPPid = rsEstadoActual.RHMPPid3>
					<cfset Lvar_RHCid = rsEstadoActual.RHCid3>
				</cfif>
				<!--- VERIFICAR SI TIENE UN PUESTO ALTERNO QUE CAMBIA LA CATEGORIA --->
				<cfif rsAccionES.RecordCount GT 0 and rsAccionES.RHPcodigoAlt GT 0>
					<cfquery name="rsCatPuestoAlt" datasource="#session.DSN#">
					    select RHCPlinea
					    from RHPuestos a
					    inner join RHMaestroPuestoP b
					        on b.RHMPPid = a.RHMPPid
					        and b.Ecodigo = a.Ecodigo
					    inner join RHCategoriasPuesto c
					        on c.RHMPPid = b.RHMPPid
					        and c.Ecodigo = b.Ecodigo
					    where RHPcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsAccionES.RHPcodigoAlt#">
					      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					</cfquery>
					<cfif rsCatPuestoAlt.RecordCount>
						<cfset Lvar_CatAlt = rsCatPuestoAlt.RHCPlinea>
						<cfset Lvar_RHTTid = 0>
						<cfset Lvar_RHMPPid = 0>
						<cfset Lvar_RHCid = 0>
					<cfelse>
						<cfset Lvar_CatAlt = 0>
	                    <cfset Lvar_RHTTid = 0>
	                    <cfset Lvar_RHMPPid = 0>
	                    <cfset Lvar_RHCid = 0>
					</cfif>
				</cfif>

				<cfinvoke component="rh.Componentes.RH_EstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
					<cfinvokeargument name="CSid" value="#rsAccionES.CSid#"/>
					<cfinvokeargument name="fecha" value="#rsAccionES.DLfvigencia#"/>
					<cfinvokeargument name="fechah" value="#rsAccionES.DLffin#"/>
					<cfinvokeargument name="DEid" value="#rsAccionES.DEid#"/>
					<cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>
					<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
					<cfinvokeargument name="negociado" value="#LvarNegociado#"/>

					<cfinvokeargument name="Unidades" value="#rsDetAct.RHDAunidad#"/>
					<cfinvokeargument name="MontoBase" value="#rsDetAct.RHDAmontobase#"/>
					<cfinvokeargument name="Monto" value="#rsDetAct.RHDAmontores#"/>
					<cfinvokeargument name="Metodo" value="#rsAccionES.RHDAmetodoC#"/>
					<cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
					<cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
					<cfinvokeargument name="ValorLlaveTC" value="#varRHAlinea#"/>
					<cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
					<cfinvokeargument name="RHTTid" value="#Lvar_RHTTid#">
					<cfinvokeargument name="RHCid" value="#Lvar_RHMPPid#">
					<cfinvokeargument name="RHMPPid" value="#Lvar_RHCid#">
					<cfinvokeargument name="PorcSalario" value="#rsEstadoActual.LTporcsal#"/>
					<cfinvokeargument name="RHCPlineaP" value="#rsAccionES.RHCPlineaP#"/>
				</cfinvoke>


				<cfset unidades = calculaComponenteRet.Unidades>
				<cfset montobase = calculaComponenteRet.MontoBase>
				<cfset monto = calculaComponenteRet.Monto>
				<cfset metodo = calculaComponenteRet.Metodo>
			<cfelse>
				<!---Datos de la Acci�n--->
				<cfquery name="rsAccionES" datasource="#Session.DSN#">
					select
						b.DEid,b.DLfvigencia, coalesce(b.DLffin,'61000101') as DLffin, b.RHCPlinea as RHCPlinea,
						a.CSid,a.RHDAmetodoC,RHPcodigoAlt,coalesce(RHCPlineaP,0) as RHCPlineaP
					from RHDAcciones a, RHAcciones b
					where a.RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHDAccionesD#">
					and a.RHAlinea = b.RHAlinea
				</cfquery>

				<!--- NO SE VERIFICA SI TIENE UN PUESTO ALTERNO, NI CATEGORIA--->
				<cfset Lvar_CatAlt = 0>

				<cfinvoke component="rh.Componentes.RH_SinEstructuraSalarial" method="calculaComponente" returnvariable="calculaComponenteRet">
					<cfinvokeargument name="CSid" value="#rsAccionES.CSid#"/>
					<cfinvokeargument name="fecha" value="#rsAccionES.DLfvigencia#"/>
					<cfinvokeargument name="fechah" value="#rsAccionES.DLffin#"/>
					<cfinvokeargument name="DEid" value="#rsAccionES.DEid#"/>
					<cfinvokeargument name="RHCPlinea" value="#Lvar_CatAlt#"/>
					<cfinvokeargument name="BaseMontoCalculo" value="0.00"/>
					<cfinvokeargument name="negociado" value="#LvarNegociado#"/>

					<cfinvokeargument name="Unidades" value="#rsDetAct.RHDAunidad#"/>
					<cfinvokeargument name="MontoBase" value="#rsDetAct.RHDAmontobase#"/>
					<cfinvokeargument name="Monto" value="#rsDetAct.RHDAmontores#"/>
					<cfinvokeargument name="Metodo" value="#rsAccionES.RHDAmetodoC#"/>
					<cfinvokeargument name="TablaComponentes" value="RHDAcciones"/>
					<cfinvokeargument name="CampoLlaveTC" value="RHAlinea"/>
					<cfinvokeargument name="ValorLlaveTC" value="#varRHAlinea#"/>
					<cfinvokeargument name="CampoMontoTC" value="RHDAmontores"/>
					<cfinvokeargument name="PorcSalario" value="#rsEstadoActual.LTporcsal#"/>
					<cfinvokeargument name="RHCPlineaP" value="#rsAccionES.RHCPlineaP#"/>
					<cfinvokeargument name="RHAlinea" value="#varRHAlinea#"/>
				</cfinvoke>

				<cfset unidades = calculaComponenteRet.unidades>
				<cfset montobase = calculaComponenteRet.monto>
				<cfset monto = calculaComponenteRet.monto>
				<cfset metodo = 'M'>

			</cfif>

			<cfif Len(Trim(unidades)) EQ 0 or Len(Trim(montobase)) EQ 0 or Len(Trim(monto)) EQ 0>
				<cf_throw message="#MSG_NoPuedeAplicarAccion#">
			</cfif>

			<cfquery name="updAct" datasource="#Session.DSN#">
				update RHDAcciones
					set RHDAunidad = <cfqueryparam cfsqltype="cf_sql_float" value="#unidades#">,
					RHDAmontobase = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(montobase, ',','','all')#">,
					RHDAmontores = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(monto, ',','','all')#">,
					RHDAmetodoC = <cfqueryparam cfsqltype="cf_sql_char" value="#metodo#">,
					BMUsucodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					BMfechamodif = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				where RHDAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHDAccionesD#">
			</cfquery>

			<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
				delete RHSalPromAccion
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHAlinea#">
			</cfquery>

			<cfquery name="ABC_RHAcciones" datasource="#Session.DSN#">
				delete RHConceptosAccion
				where RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHAlinea#">
			</cfquery>

			<cfquery name="checkMaxLTid" datasource="#session.DSN#">
				select max (LThasta) as Fhasta
				from LineaTiempo
				where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">
			</cfquery>

			<cfif isdefined("checkMaxLTid") or (checkMaxLTid.recordcount GT 0) >
				<cfset Fhasta= "#checkMaxLTid.Fhasta#">
			<cfelse>
			 	<cfset Fhasta = '01/01/6100'>
			</cfif>
			<cfquery datasource="#session.DSN#">
				update RHAcciones
				set DLffin = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#rsAccionES.DLffin#">
				Where RHAlinea=<cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHAlinea#">
				and DLffin is null
			</cfquery>

			<!--- Procesamiento de los Conceptos de Pago --->
			<cfquery name="rsConceptos" datasource="#Session.DSN#">
				select a.DLfvigencia,
					   a.DLffin,
					   a.DEid,
					   a.Ecodigo,
					   a.RHTid,
					   a.RHAlinea,
					   coalesce(a.RHJid, 0) as RHJid,
					   c.CIid,
					   c.CIcantidad, c.CIrango, c.CItipo, c.CIcalculo, c.CIdia, c.CImes
					   ,CIsprango, coalesce(CIspcantidad,0) as CIspcantidad, coalesce(CImescompleto,0) as CImescompleto
				from RHAcciones a, ConceptosTipoAccion b, CIncidentesD c
				where a.RHAlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHAlinea#">
				and a.RHTid = b.RHTid
				and b.CIid = c.CIid
			</cfquery>
			<cfloop query="rsConceptos">
				<cfset FVigencia = LSDateFormat(rsConceptos.DLfvigencia, 'DD/MM/YYYY')>
				<cfset FFin = LSDateFormat(rsConceptos.DLffin, 'DD/MM/YYYY')>

				<!---<cfif Len(Trim(rsConceptos.DLffin))>
					<cfset FFin = LSDateFormat(rsConceptos.DLffin, 'DD/MM/YYYY')>
				<cfelse>
				 	<cfset FFin = '01/01/6100'>
				</cfif>--->
				<cfset current_formulas = rsConceptos.CIcalculo>
				<cfset presets_text = RH_Calculadora.get_presets(CreateDate(ListGetAt(FVigencia,3,'/'), ListGetAt(FVigencia,2,'/'), ListGetAt(FVigencia,1,'/')),
											   CreateDate(ListGetAt(FFin,3,'/'), ListGetAt(FFin,2,'/'), ListGetAt(FFin,1,'/')),
											   rsConceptos.CIcantidad,
											   rsConceptos.CIrango,
											   rsConceptos.CItipo,
											   rsConceptos.DEid,
											   rsConceptos.RHJid,
											   rsConceptos.Ecodigo,
											   rsConceptos.RHTid,
											   rsConceptos.RHAlinea,
											   rsConceptos.CIdia,
											   rsConceptos.CImes,
											   "", <!--- Tcodigo solo se requiere si no va RHAlinea--->
											   FindNoCase('SalarioPromedio', current_formulas), <!--- optimizacion - SalarioPromedio es el calculo m�s pesado--->
											   'false',
											   '',
											   FindNoCase('DiasRealesCalculoNomina', current_formulas) <!--- optimizacion - DiasRealesCalculoNomina es el segundo calculo mas pesado--->
											   , 0
											   , ''
											   ,rsConceptos.CIsprango
											   ,rsConceptos.CIspcantidad
											   ,rsConceptos.CImescompleto)>
				<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
	                  <cfset calc_error = RH_Calculadora.getCalc_error()>
				<cfif Not IsDefined("values")>
					<cfif isdefined("presets_text")>
						<cf_throw message="#presets_text# & '----' & #current_formulas# & '-----' & #calc_error#">
					<cfelse>
						<cf_throw message="#calc_error#" >
					</cfif>
				</cfif>

				<cfquery name="updConceptos" datasource="#Session.DSN#">
					insert into RHConceptosAccion(RHAlinea, CIid, RHCAimporte, RHCAres, RHCAcant, CIcalculo,BMUsucodigo,BMfecha)
					values (
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#varRHAlinea#">,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsConceptos.CIid#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('importe').toString()#">,
						<cfqueryparam cfsqltype="cf_sql_money" value="#values.get('resultado').toString()#">,
						<cfqueryparam cfsqltype="cf_sql_float" value="#values.get('cantidad').toString()#">,
						<cfqueryparam cfsqltype="cf_sql_longvarchar" value="#presets_text & ';' & current_formulas#">
						,<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">
						,<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
					)
				</cfquery>
			</cfloop>

			<cfquery name="vParam" datasource="#session.dsn#">
				select Pvalor from RHParametros
				where Pcodigo = 540
				and Ecodigo=#session.Ecodigo#
			</cfquery>
			<cfif vParam.Pvalor eq 1>
				<!--- <cfif isdefined("Form.btnAplicar")> OPARRALES VALIDAR SI SE APLICAN O NO--->
					<cfquery name="rsArt" datasource="#session.dsn#">
						select RHCatParcial from RHTipoAccion where RHTid=#form.RHTid#
					</cfquery>
					<cfif rsArt.RHCatParcial eq 1>
						<cfinvoke component="rh.Componentes.RH_ValidaPresupuesto"  method="Art40">
						 <cfinvokeargument name="RHAlinea" value="#form.RHAlinea#"/>
						</cfinvoke>
					</cfif>

				<!--- </cfif> --->

			</cfif>

			<cfquery name="rsCheckAplica" datasource="#session.dsn#">
				select Pvalor
				from RHParametros
				where
					Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="14600702">
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif rsCheckAplica.RecordCount gt 0 and rsCheckAplica.Pvalor eq 1>
				<!--- Validar acci�n --->
				<cftransaction>
					<cfinvoke component="rh.Componentes.RH_AplicaAccion" method="AplicaAccion" returnvariable="LvarResult">
						<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
						<cfinvokeargument name="RHAlinea" value="#varRHAlinea#"/>
						<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
						<cfinvokeargument name="conexion" value="#Session.DSN#"/>
						<cfinvokeargument name="validar" value="true"/>
						<cfinvokeargument name="debug" value="false"/>
					</cfinvoke>
				</cftransaction>

				<!--- Postear acci�n --->
				<cftransaction>
					<cfinvoke component="rh.Componentes.RH_AplicaAccion" method="AplicaAccion" returnvariable="LvarResult">
						<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#"/>
						<cfinvokeargument name="RHAlinea" value="#varRHAlinea#"/>
						<cfinvokeargument name="Usucodigo" value="#Session.Usucodigo#"/>
						<cfinvokeargument name="conexion" value="#Session.DSN#"/>
						<cfinvokeargument name="validar" value="false"/>
						<cfinvokeargument name="debug" value="false"/>
					</cfinvoke>
				</cftransaction>
			</cfif>
			<cfset countObj++>
		</cfif>


		<!---==================********** VALIDANDO BLOQUE PARA INSERTAR INCIDENCIAS **********============--->

		<!--- ===== INCIDENCIAS DE NOMINA DE TEMPORADA 02 --->
		<cfif IsDefined('form.Tcodigo') and Trim(form.Tcodigo) eq '02'>
			<cfquery name="rsIncEx" datasource="#session.dsn#">
				SELECT *
				FROM
					CIncidentes
				where Upper(RTrim(LTrim(CIcodigo))) = 'PAE'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif rsIncEx.RecordCount eq 0>
				<cfthrow detail="La incidencia Premio de Asistencia Efectivo con el codigo PAE no se ha definido.">
			</cfif>
		<cfelse>
			<cfquery name="rsIncEx" datasource="#session.dsn#">
				SELECT *
				FROM
					CIncidentes
				where Upper(RTrim(LTrim(CIcodigo))) = '1PA'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif rsIncEx.RecordCount eq 0>
				<cfthrow detail="La incidencia Premio de Asistencia con el codigo 1PA no se ha definido.">
			</cfif>
		</cfif>

		<cfif IsDefined('form.Tcodigo') and Trim(form.Tcodigo) eq '02'>
			<cfquery name="rsIncEx2" datasource="#session.dsn#">
				SELECT *
				FROM
					CIncidentes
				where Upper(RTrim(LTrim(CIcodigo))) = 'PPE'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			<cfif rsIncEx2.RecordCount eq 0>
				<cfthrow detail="La incidencia PREMIO PUNTUALIDAD EFECTIVO con el codigo PPE no se ha definido.">
			</cfif>
		<cfelse>
			<cfquery name="rsIncEx2" datasource="#session.dsn#">
				SELECT *
				FROM
					CIncidentes
				where Upper(RTrim(LTrim(CIcodigo))) = '1PP'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>

			<cfif rsIncEx2.RecordCount eq 0>
				<cfthrow detail="La incidencia Premio por Puntualidad con el codigo 1PP no se ha definido.">
			</cfif>
		</cfif>


		<cfquery name="rsIncDF" datasource="#session.dsn#">
			SELECT *
			FROM
				CIncidentes
			where Upper(RTrim(LTrim(CIcodigo))) = '1DF'
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfif rsIncDF.RecordCount eq 0>
			<cfthrow detail="La incidencia Dias de Falta con el codigo 1DF no se ha definido.">
		</cfif>

		<cfquery name="rsIncDD" datasource="#session.dsn#">
			SELECT *
			FROM
				CIncidentes
			where Upper(RTrim(LTrim(CIcodigo))) = '1DD'
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfif rsIncDD.RecordCount eq 0>
			<cfthrow detail="La incidencia Dias de Descanso con el codigo 1DD no se ha definido.">
		</cfif>

		<cfquery name="rsIncHExt" datasource="#session.dsn#">
			SELECT *
			FROM
				CIncidentes
			where Upper(RTrim(LTrim(CIcodigo))) = '104'
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfif rsIncHExt.RecordCount eq 0>
			<cfthrow detail="La incidencia Horas Extra Dobles Exentas con el codigo 104 no se ha definido.">
		</cfif>

		<cfquery name="rsIncHrsEsp" datasource="#session.dsn#">
			SELECT *
			FROM
				CIncidentes
			where Upper(RTrim(LTrim(CIcodigo))) = '105'
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<cfif rsIncHrsEsp.RecordCount eq 0>
			<cfthrow detail="La incidencia Horas Extra Especiales con el codigo 105 no se ha definido.">
		</cfif>

		<cfif IsDefined('form.Tcodigo') and Trim(form.Tcodigo) eq '02'>
			<cfquery name="rsIncHExtDesc" datasource="#session.dsn#">
				SELECT *
				FROM
					CIncidentes
				where Upper(RTrim(LTrim(CIcodigo))) = 'FEF'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			<cfif rsIncHExtDesc.RecordCount eq 0>
				<cfthrow detail="La incidencia Horas Falta Efectivo con el codigo FEF no se ha definido.">
			</cfif>
		<cfelse>
			<cfquery name="rsIncHExtDesc" datasource="#session.dsn#">
				SELECT *
				FROM
					CIncidentes
				where Upper(RTrim(LTrim(CIcodigo))) = '04'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			<cfif rsIncHExtDesc.RecordCount eq 0>
				<cfthrow detail="La incidencia Horas Extra para la Proporcion de Falta con el codigo 04 no se ha definido.">
			</cfif>

			<cfquery name="rsIncEfectivo" datasource="#session.dsn#">
				SELECT *
				FROM
					CIncidentes
				where Upper(RTrim(LTrim(CIcodigo))) = '04E'
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			</cfquery>
			<cfif rsIncEfectivo.RecordCount eq 0>
				<cfthrow detail="La incidencia Horas Falta Efectivo con el codigo 04E no se ha definido.">
			</cfif>
		</cfif>


		<cfquery name="rs2DE" datasource="#session.dsn#">
			SELECT *
			FROM
				CIncidentes
			where Upper(RTrim(LTrim(CIcodigo))) = '2DE'
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rs2DE.RecordCount eq 0>
			<cfthrow detail="La incidencia DESPENSA EXENTA con el codigo 2DE no se ha definido.">
		</cfif>

		<cfquery name="rs1PR" datasource="#session.dsn#">
			SELECT *
			FROM
				CIncidentes
			where Upper(RTrim(LTrim(CIcodigo))) = '1PR'
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rs1PR.RecordCount eq 0>
			<cfthrow detail="La incidencia PREMIO PRODUCTIVIDAD con el codigo 1PR no se ha definido.">
		</cfif>

		<cfquery name="rs1P2" datasource="#session.dsn#">
			SELECT *
			FROM
				CIncidentes
			where Upper(RTrim(LTrim(CIcodigo))) = '1P2'
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>
		<cfif rs1P2.RecordCount eq 0>
			<cfthrow detail="La incidencia PREMIO PRODUCTIVIDAD con el codigo 1P2 no se ha definido.">
		</cfif>

		<!---==================********** FIN VALIDANDO BLOQUE PARA INSERTAR INCIDENCIAS **********============--->


		<cfquery datasource="#session.dsn#" name="rsUltimaAccionEmp">
			select top 1
				LTid,
				'#Trim(form.Tcodigo)#',
				RHTid,
				Ocodigo,
				RHJid
			from LineaTiempo
			where DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			order by LTdesde desc
		</cfquery>

		<cfquery name="rsCFEmp" datasource="#session.dsn#">
			select top 1 CFid from
				DLaboralesEmpleado dle
				inner join RHPlazas p
				on p.RHPid = dle.RHPid
				and p.Ecodigo = dle.Ecodigo
			where dle.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">
			order by DLfvigencia desc,DLlinea asc
		</cfquery>

		<!--- HORAS EXTRAS --->
		<cfif unObj.HorasExtra gt 0>
			<cfset arrHrsMin = ListToArray(unObj.HorasExtra,'.',false,true)>
			<cfset varMin = arrHrsMin[2]>
			<cfset minToHors = LSNumberFormat((varMin/60),"9.0000")>

			<cfset arrMin = ListToArray(minToHors,'.',false,false)>
			<cfset varMisArr = (ArrayLen(arrMin) gt 1 ? arrMin[2] : 0)>

			<cfset varHorsTot = "#Val(arrHrsMin[1])#.#(Trim(varMisArr) eq '' ? 0 : varMisArr)#">
			
			<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
				DEid = "#rsEmp.DEid#"
				CIid = "#rsIncHExt.CIid#"
				iFecha = "#LSParseDateTime(rsCalendario.CPhasta)#"
				iValor = "#LSNumberFormat(varHorsTot,'9.0000')#"
				returnVariable="Lvar_Iid">
				<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
					<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
				</cfif>
				<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
					<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
				</cfif>
			</cfinvoke>
		</cfif>

		<!--- HORAS Horas Especiales --->
		<cfif unObj.HorasEspeciales gt 0>
			<cfset arrHrsMin = ListToArray(unObj.HorasEspeciales,'.',false,true)>
			<cfset varMin = arrHrsMin[2]>
			<cfset minToHors = LSNumberFormat((varMin/60),"9.0000")>

			<cfset arrMin = ListToArray(minToHors,'.',false,false)>
			<cfset varMisArr = (ArrayLen(arrMin) gt 1 ? arrMin[2] : 0)>
			<cfset varHorsTot = "#Val(arrHrsMin[1])#.#Val(varMisArr)#">

			<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
				DEid = "#rsEmp.DEid#"
				CIid = "#rsIncHrsEsp.CIid#"
				iFecha = "#LSParseDateTime(rsCalendario.CPhasta)#"
				iValor = "#varHorsTot#"
				returnVariable="Lvar_Iid">
				<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
					<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
				</cfif>
				<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
					<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
				</cfif>
			</cfinvoke>
		</cfif>


		<!--- OPARRALES 2018-01-13
			- Se agrega validacion para buscar empleados dados de alta despues de la fecha inicio del calendario de pago
			- Si existen empleados se saca los dias trabajados de fecha de alta vs Fecha fin de pago
		 --->
		<cfquery name="rsLTAlta" datasource="#session.dsn#">
			select top 1 lt.LTdesde,lt.LTid
			from
				LineaTiempo lt
			inner join RHTipoAccion ta
				on ta.RHTid = lt.RHTid
				and ta.Ecodigo = lt.Ecodigo
			where
				lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">
			and lt.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			and ta.RHTcomportam = 1 <!--- Accion de Tipo Nombramiento --->
			and lt.LTdesde
				between <cfqueryparam cfsqltype="cf_sql_date" value="#rsCalendario.CPdesde#">
				and <cfqueryparam cfsqltype="cf_sql_date" value="#rsCalendario.CPhasta#">
			AND lt.BMUsucodigo is not null
			order by lt.LTdesde
		</cfquery>

		<cfif rsLTAlta.RecordCount gt 0>
			<cfset varDiasLab = (DateDiff("d",rsLTAlta.LTdesde,rsCalendario.CPhasta) + 1)>
			<cfset varDiffDias = 7-varDiasLab>
			<!--- 2019-01-18 Cuando el empleado se dio de alta despues de la fecha Inicio de pago
			no aplica multiplicar por factor del 7mo dia
			 <cfset varPropDias = varDiffDias * factorFaltas> --->
			<cfset varPropDias = varDiffDias>
			<cfset varDBC = 7 - varPropDias>
		<cfelse>
			<cfset varDBC = 7>
		</cfif>
		
		<cfset varDBC -=  varDiasInc>

		<!--- PREMIO DE PUNTUALIDAD --->
		<cfif unObj.Monto1PP gt 0>
			<cfset numCompleto = LSNumberFormat(horasFalta,'000')>

			<cfset numHors = Left(numCompleto,1)>
			<cfset numMins = Val(Right(numCompleto,2))>

			<cfset varHorasFalta = numHors & '.' & numMins>
			<cfif numMins gt 0>
				<!--- Convertirmos Minuntos a Horas --->
				<cfset fracHor = numMins/60>
				<cfset arrFracHor = ListToArray(fracHor,'.',false,true)>
				<cfset varFracHor = arrFracHor[2]>

				<!--- Concatenamos el numero total de horas --->
				<cfset varHorasFalta = Val(numHors) & "." & Val(varFracHor)>

			</cfif>

			<cfset vDiasCalInc = varDBC-((varHorasFalta gt 0 ? (DiasFalta+(varHorasFalta/8)): DiasFalta) * factorFaltas)>
			<cfquery name="rsDatosConcepto" datasource="#Session.DSN#"><!---Obtener datos de la incidencia, requeridos por la calculadora--->
				select 	coalesce(b.CItipo,'m') as CItipo,
						b.CIdia,
						b.CImes,
						b.CIcalculo,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(rsCalendario.CPhasta,'YYYY-MM-dd')#"> as Ifecha,
						<!--- OPARRALES 2018-12-27 Si horasFalta > 0 se convierte a dias y se le resta a los dias laborados (7) --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vDiasCalInc#"> as Ivalor,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#"> as DEid,
						0 as RHJid,
						'#Trim(form.Tcodigo)#' as Tcodigo,
						coalesce(b.CIcantidad,0) as CIcantidad,
						coalesce(b.CIrango,0) as CIrango
						, coalesce(b.CIspcantidad,0) as CIspcantidad
						, coalesce(b.CIsprango,0) as CIsprango
				from CIncidentes a
					left outer join CIncidentesD b
						on a.CIid = b.CIid
				where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncEx2.CIid#">
				and a.CItipo = 3
			</cfquery>

			<cfif rsDatosConcepto.RecordCount NEQ 0>
				<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
				<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
				<cfset current_formulas = rsDatosConcepto.CIcalculo>
				<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
											   LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
											   rsDatosConcepto.CIcantidad,<!---CIcantidad--->
											   rsDatosConcepto.CIrango, <!---CIrango--->
											   rsDatosConcepto.CItipo, <!---CItipo--->
											   rsDatosConcepto.DEid,	<!---DEid--->
											   rsDatosConcepto.RHJid, <!---RHJid--->
											   session.Ecodigo, <!---Ecodigo--->
											   0, <!---RHTid--->
											   0, <!---RHAlinea--->
											   rsDatosConcepto.CIdia, <!---CIdia--->
											   rsDatosConcepto.CImes,<!---CImes--->
											   rsDatosConcepto.Tcodigo,<!---Tcodigo--->
											   FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
											   'false', <!---masivo--->
											   '', <!---tabla_temporal--->
											   0,<!---calc_diasnomina--->
											   rsDatosConcepto.Ivalor
											   , ''
											   ,rsDatosConcepto.CIsprango
											   ,rsDatosConcepto.CIspcantidad
											   )>

				<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>

				<cfif Not IsDefined("values") or not isdefined("presets_text")>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_NoEsPosibleRealizarElCalculo"
						Default="No es posible realizar el c&aacute;lculo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
					<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
				</cfif>

				<cfset iMonto = #values.get('resultado').toString()#>
			<!----------------- Fin de calculadora ------------------->
			<cfelse>
				<cfset vDiasCalInc = (vDiasCalInc * (rsUltimaAccion.LTsalario/30.4)) * (unObj.Monto1PP/100)>
				<cfset iMonto = vDiasCalInc>
			</cfif>

			<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
				DEid = "#rsEmp.DEid#"
				CIid = "#rsIncEx2.CIid#"
				iFecha = "#LSParseDateTime(rsCalendario.CPhasta)#"
				iValor = "#vDiasCalInc#"
				returnVariable="Lvar_Iid">
				<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
					<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
				</cfif>
				<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
					<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
				</cfif>

				<cfinvokeargument name="Imonto" value="#iMonto#">

			</cfinvoke>
		</cfif>

		<!--- PREMIO DE ASISTENCIA --->
		<cfif unObj.Monto1PA gt 0>

			<cfset numCompleto = LSNumberFormat(horasFalta,'000')>

			<cfset numHors = Left(numCompleto,1)>
			<cfset numMins = Val(Right(numCompleto,2))>

			<cfset varHorasFalta = numHors & '.' & numMins>

			<cfif numMins gt 0>
				<!--- Convertirmos Minuntos a Horas --->
				<cfset fracHor = numMins/60>
				<cfset arrFracHor = ListToArray(fracHor,'.',false,true)>
				<cfset varFracHor = arrFracHor[2]>

				<!--- Concatenamos el numero total de horas --->
				<cfset varHorasFalta = Val(numHors) & "." & Val(varFracHor)>

			</cfif>

			<cfset vDiasCalInc = varDBC-((varHorasFalta gt 0 ? (DiasFalta+(varHorasFalta/8)): DiasFalta) * factorFaltas)>

			<cfset numCompleto = LSNumberFormat(horasFalta,'000')>

			<cfset numHors = Left(numCompleto,1)>
			<cfset numMins = Val(Right(numCompleto,2))>

			<cfset varHorasFalta = numHors & '.' & numMins>

			<cfif numMins gt 0>
				<!--- Convertirmos Minuntos a Horas --->
				<cfset fracHor = numMins/60>
				<cfset arrFracHor = ListToArray(fracHor,'.',false,true)>
				<cfset varFracHor = arrFracHor[2]>

				<!--- Concatenamos el numero total de horas --->
				<cfset varHorasFalta = Val(numHors) & "." & Val(varFracHor)>

			</cfif>
			<cfquery name="rsDatosConcepto" datasource="#Session.DSN#"><!---Obtener datos de la incidencia, requeridos por la calculadora--->
				select 	coalesce(b.CItipo,'m') as CItipo,
						b.CIdia,
						b.CImes,
						b.CIcalculo,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(rsCalendario.CPhasta,'YYYY-MM-dd')#"> as Ifecha,
						<!--- OPARRALES 2018-12-27 Si horasFalta > 0 se convierte a dias y se le resta a los dias laborados (7) --->
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#vDiasCalInc#"> as Ivalor,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#"> as DEid,
						0 as RHJid,
						'#Trim(form.Tcodigo)#' as Tcodigo,
						coalesce(b.CIcantidad,0) as CIcantidad,
						coalesce(b.CIrango,0) as CIrango
						, coalesce(b.CIspcantidad,0) as CIspcantidad
						, coalesce(b.CIsprango,0) as CIsprango
				from CIncidentes a
					left outer join CIncidentesD b
						on a.CIid = b.CIid
				where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncEx.CIid#">
					and a.CItipo = 3
			</cfquery>

			<cfif rsDatosConcepto.RecordCount NEQ 0>
				<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
				<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
				<cfset current_formulas = rsDatosConcepto.CIcalculo>
				<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
											   LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
											   rsDatosConcepto.CIcantidad,<!---CIcantidad--->
											   rsDatosConcepto.CIrango, <!---CIrango--->
											   rsDatosConcepto.CItipo, <!---CItipo--->
											   rsDatosConcepto.DEid,	<!---DEid--->
											   rsDatosConcepto.RHJid, <!---RHJid--->
											   session.Ecodigo, <!---Ecodigo--->
											   0, <!---RHTid--->
											   0, <!---RHAlinea--->
											   rsDatosConcepto.CIdia, <!---CIdia--->
											   rsDatosConcepto.CImes,<!---CImes--->
											   rsDatosConcepto.Tcodigo,<!---Tcodigo--->
											   FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
											   'false', <!---masivo--->
											   '', <!---tabla_temporal--->
											   0,<!---calc_diasnomina--->
											   rsDatosConcepto.Ivalor
											   , ''
											   ,rsDatosConcepto.CIsprango
											   ,rsDatosConcepto.CIspcantidad
											   )>

				<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
				<cfif Not IsDefined("values") or not isdefined("presets_text")>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_NoEsPosibleRealizarElCalculo"
						Default="No es posible realizar el c&aacute;lculo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
					<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
				</cfif>

				<cfset iMonto = #values.get('resultado').toString()# >
			<!----------------- Fin de calculadora ------------------->
			<cfelse>
				<cfset vDiasCalInc = (vDiasCalInc * (rsUltimaAccion.LTsalario/30.4)) * (unObj.Monto1PA/100)  >
				<cfset iMonto = vDiasCalInc  >
			</cfif>
			
			<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
				DEid = "#rsEmp.DEid#"
				CIid = "#rsIncEx.CIid#"
				iFecha = "#LSParseDateTime(rsCalendario.CPhasta)#"
				iValor = "#vDiasCalInc#"
				returnVariable="Lvar_Iid">
				<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
					<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
				</cfif>
				<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
					<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
				</cfif>
				<cfinvokeargument name="Imonto" value="#iMonto#">
			</cfinvoke>
		</cfif>

		<!---============= INICIO DIAS DE DESCANSO ============--->
		<cfif unObj.Monto1DD gt 0>
			<cfquery name="rsDatosConcepto" datasource="#Session.DSN#"><!---Obtener datos de la incidencia, requeridos por la calculadora--->
				select 	coalesce(b.CItipo,'m') as CItipo,
						b.CIdia,
						b.CImes,
						b.CIcalculo,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(rsCalendario.CPhasta,'YYYY-MM-dd')#"> as Ifecha,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#unObj.Monto1DD#"> as Ivalor,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#"> as DEid,
						0 as RHJid,
						'#Trim(form.Tcodigo)#' as Tcodigo,
						coalesce(b.CIcantidad,0) as CIcantidad,
						coalesce(b.CIrango,0) as CIrango
						, coalesce(b.CIspcantidad,0) as CIspcantidad
						, coalesce(b.CIsprango,0) as CIsprango
				from CIncidentes a
					left outer join CIncidentesD b
						on a.CIid = b.CIid
				where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncDD.CIid#">
					and a.CItipo = 3
			</cfquery>

			<cfif rsDatosConcepto.RecordCount NEQ 0>
				<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
				<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
				<cfset current_formulas = rsDatosConcepto.CIcalculo>
				<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
											   LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
											   rsDatosConcepto.CIcantidad,<!---CIcantidad--->
											   rsDatosConcepto.CIrango, <!---CIrango--->
											   rsDatosConcepto.CItipo, <!---CItipo--->
											   rsDatosConcepto.DEid,	<!---DEid--->
											   rsDatosConcepto.RHJid, <!---RHJid--->
											   session.Ecodigo, <!---Ecodigo--->
											   0, <!---RHTid--->
											   0, <!---RHAlinea--->
											   rsDatosConcepto.CIdia, <!---CIdia--->
											   rsDatosConcepto.CImes,<!---CImes--->
											   rsDatosConcepto.Tcodigo,<!---Tcodigo--->
											   FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
											   'false', <!---masivo--->
											   '', <!---tabla_temporal--->
											   0,<!---calc_diasnomina--->
											   rsDatosConcepto.Ivalor
											   , ''
											   ,rsDatosConcepto.CIsprango
											   ,rsDatosConcepto.CIspcantidad
											   )>

				<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
				<cfif Not IsDefined("values") or not isdefined("presets_text")>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_NoEsPosibleRealizarElCalculo"
						Default="No es posible realizar el c&aacute;lculo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
					<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
				</cfif>

				<cfset iMonto = #values.get('resultado').toString()#>
			<!----------------- Fin de calculadora ------------------->
			</cfif>
			<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
				DEid = "#rsEmp.DEid#"
				CIid = "#rsIncDD.CIid#"
				iFecha = "#LSParseDateTime(rsCalendario.CPhasta)#"
				iValor = "#unObj.Monto1DD#"
				returnVariable="Lvar_Iid">
				<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
					<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
				</cfif>
				<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
					<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
				</cfif>
				<cfinvokeargument name="Imonto" value="#iMonto#">
			</cfinvoke>
		</cfif>
		<!---============= FIN DIAS DESCANSO ===========--->


		<!---============= INICIO DIAS DE FALTA ============--->
		<cfif unObj.Monto1DF gt 0>
			<cfquery name="rsDatosConcepto" datasource="#Session.DSN#"><!---Obtener datos de la incidencia, requeridos por la calculadora--->
				select 	coalesce(b.CItipo,'m') as CItipo,
						b.CIdia,
						b.CImes,
						b.CIcalculo,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(rsCalendario.CPhasta,'YYYY-MM-dd')#"> as Ifecha,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#unObj.Monto1DF#"> as Ivalor,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#"> as DEid,
						0 as RHJid,
						'#form.Tcodigo#' as Tcodigo,
						coalesce(b.CIcantidad,0) as CIcantidad,
						coalesce(b.CIrango,0) as CIrango
						, coalesce(b.CIspcantidad,0) as CIspcantidad
						, coalesce(b.CIsprango,0) as CIsprango
				from CIncidentes a
					left outer join CIncidentesD b
						on a.CIid = b.CIid
				where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsIncDF.CIid#">
					and a.CItipo = 3
			</cfquery>

			<cfif rsDatosConcepto.RecordCount NEQ 0>
				<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
				<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
				<cfset current_formulas = rsDatosConcepto.CIcalculo>
				<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
											   LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
											   rsDatosConcepto.CIcantidad,<!---CIcantidad--->
											   rsDatosConcepto.CIrango, <!---CIrango--->
											   rsDatosConcepto.CItipo, <!---CItipo--->
											   rsDatosConcepto.DEid,	<!---DEid--->
											   rsDatosConcepto.RHJid, <!---RHJid--->
											   session.Ecodigo, <!---Ecodigo--->
											   0, <!---RHTid--->
											   0, <!---RHAlinea--->
											   rsDatosConcepto.CIdia, <!---CIdia--->
											   rsDatosConcepto.CImes,<!---CImes--->
											   rsDatosConcepto.Tcodigo,<!---Tcodigo--->
											   FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
											   'false', <!---masivo--->
											   '', <!---tabla_temporal--->
											   0,<!---calc_diasnomina--->
											   rsDatosConcepto.Ivalor
											   , ''
											   ,rsDatosConcepto.CIsprango
											   ,rsDatosConcepto.CIspcantidad
											   )>

				<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>
				<cfif Not IsDefined("values") or not isdefined("presets_text")>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_NoEsPosibleRealizarElCalculo"
						Default="No es posible realizar el c&aacute;lculo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
					<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
				</cfif>

				<cfset iMonto = #values.get('resultado').toString()#>
			<!----------------- Fin de calculadora ------------------->
			</cfif>
			<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
				DEid = "#rsEmp.DEid#"
				CIid = "#rsIncDF.CIid#"
				iFecha = "#LSParseDateTime(rsCalendario.CPhasta)#"
				iValor = "#unObj.Monto1DF#"
				returnVariable="Lvar_Iid">
				<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
					<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
				</cfif>
				<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
					<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
				</cfif>
				<cfinvokeargument name="Imonto" value="#iMonto#">
			</cfinvoke>
		</cfif>
		<!---============= FIN DIAS DE FALTA ===========--->

		<!--- ============ HORAS DE FALTA --->

		<cfif horasFalta gt 0>
			<cfset numCompleto = LSNumberFormat(horasFalta,'000')>

			<cfset numHors = Left(numCompleto,1)>
			<cfset numMins = Val(Right(numCompleto,2))>

			<cfset varHorasFalta = numHors & '.' & numMins>

			<cfif numMins gt 0>
				<!--- Convertirmos Minuntos a Horas --->
				<cfset fracHor = numMins/60>
				<cfset arrFracHor = ListToArray(fracHor,'.',false,true)>
				<cfset varFracHor = arrFracHor[2]>
				<!--- Concatenamos el numero total de horas --->
				<cfset varHorasFalta = Val(numHors) & "." & Val(varFracHor)>
			</cfif>

			<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
				DEid = "#rsEmp.DEid#"
				CIid = "#rsIncHExtDesc.CIid#"
				iFecha = "#LSParseDateTime(varDiasHorasFalta)#"
				iValor = "#varHorasFalta#"
				returnVariable="Lvar_Iid">
				<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
					<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
				</cfif>
				<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
					<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
				</cfif>
			</cfinvoke>

			<!--- OPARRALES 2019-01-28
				- Modificacion para faltas que afectan al componente de Efectivo
			 --->
			<cfif IsDefined('form.Tcodigo') and Trim(form.Tcodigo) eq '01'>
				<cfquery name="rsUltAc" datasource="#session.dsn#">
					select top 1 lt.LTid
					from LineaTiempo lt
					inner join RHTipoAccion rt
						on rt.RHTid = lt.RHTid
					where 1=1
					and rt.RHTcomportam in (1,6)
					and lt.DEid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#">
					order by LTdesde desc
				</cfquery>

				<cfquery Name="rsCSEfec" datasource="#session.dsn#">
					select coalesce(DLTmonto,0) as DLTmonto
					from
						DLineaTiempo dlt
					inner join ComponentesSalariales cs
						on cs.CSid = dlt.CSid
					where
						LTid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsUltAc.LTid#">
					and cs.CSsalariobase = <cfqueryparam cfsqltype="cf_sql_numeric" value="0">
					and cs.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				</cfquery>
				<cfif rsCSEfec.RecordCount gt 0 and rsCSEfec.DLTmonto gt 0>

					<cfset varIvalor = (((rsCSEfec.DLTmonto / 30.4) / 8) * varHorasFalta) * 1.158>
					<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
						DEid = "#rsEmp.DEid#"
						CIid = "#rsIncEfectivo.CIid#"
						iFecha = "#LSParseDateTime(varDiasHorasFalta)#"
						iValor = "#varIvalor#"
						returnVariable="Lvar_Iid">
						<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
							<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
						</cfif>
						<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
							<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
						</cfif>
					</cfinvoke>
				</cfif>
			</cfif>
		</cfif>

		<cfquery name="rsDEdatos" datasource="#session.dsn#">
			select DEdato3,DEdato4
			from
				DatosEmpleado
			where DEidentificacion = LTRIM(RTRIM('#unObj.DEIdentificacion#'))
			and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		</cfquery>

		<!--- ================ INICIO INCIDENCIAS DE PRODUCTIVIDAD ============== --->
		<cfset numCompleto = LSNumberFormat(horasFalta,'000')>
		<cfset numHors = Left(numCompleto,1)>
		<cfset numMins = Val(Right(numCompleto,2))>
		<cfset varHorasFalta = numHors & '.' & numMins>
		<cfif numMins gt 0>
			<!--- Convertirmos Minuntos a Horas --->
			<cfset fracHor = numMins/60>
			<cfset arrFracHor = ListToArray(fracHor,'.',false,true)>
			<cfset varFracHor = arrFracHor[2]>

			<!--- Concatenamos el numero total de horas --->
			<cfset varHorasFalta = Val(numHors) & "." & Val(varFracHor)>
		</cfif>

		<!--- N0TA
			- La conversion es de:
				- Minutos a horas
				- De horas a dias donde un dia es equivalente a 8 hrs laborales
		--->
		<cfset varFaltasToDias = (DiasFalta+(varHorasFalta/8))>
		<cfset vDiasCalInc = varDBC-((varHorasFalta gt 0 ? varFaltasToDias : DiasFalta) * factorFaltas)>
		<cfif varFaltasToDias lt 0.0625 and Trim(form.Tcodigo) neq '02'> <!--- Faltas menores a 0 Dias, 0 Horas y 30 minutos --->
			<!--- ==== 1PR PREMIO DE PRODUCTIVIDAD 1==== --->
			<cfif rsDEdatos.DEdato3 neq '' and rsDEdatos.DEdato3 gt 0>
				<cfset iValor1PR = rsDEdatos.DEdato3 * vDiasCalInc>

				<cfquery name="rsDatosConcepto" datasource="#Session.DSN#">
				<!--- Obtener datos de la incidencia, requeridos por la calculadora --->
					select 	
						coalesce(b.CItipo,'m') as CItipo,
						b.CIdia,
						b.CImes,
						b.CIcalculo,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(rsCalendario.CPhasta,'YYYY-MM-dd')#"> as Ifecha,
						<!--- OPARRALES 2018-12-27 Si horasFalta > 0 se convierte a dias y se le resta a los dias laborados (7) --->
						#iValor1PR# as Ivalor,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#"> as DEid,
						0 as RHJid,
						'#Trim(form.Tcodigo)#' as Tcodigo,
						coalesce(b.CIcantidad,0) as CIcantidad,
						coalesce(b.CIrango,0) as CIrango
						, coalesce(b.CIspcantidad,0) as CIspcantidad
						, coalesce(b.CIsprango,0) as CIsprango
					from CIncidentes a
						left outer join CIncidentesD b
							on a.CIid = b.CIid
					where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs1PR.CIid#">
					and a.CItipo = 3
				</cfquery>

				<cfif rsDatosConcepto.RecordCount NEQ 0>
					<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
					<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
					<cfset current_formulas = rsDatosConcepto.CIcalculo>
					<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
												LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
												rsDatosConcepto.CIcantidad,<!---CIcantidad--->
												rsDatosConcepto.CIrango, <!---CIrango--->
												rsDatosConcepto.CItipo, <!---CItipo--->
												rsDatosConcepto.DEid,	<!---DEid--->
												rsDatosConcepto.RHJid, <!---RHJid--->
												session.Ecodigo, <!---Ecodigo--->
												0, <!---RHTid--->
												0, <!---RHAlinea--->
												rsDatosConcepto.CIdia, <!---CIdia--->
												rsDatosConcepto.CImes,<!---CImes--->
												rsDatosConcepto.Tcodigo,<!---Tcodigo--->
												FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
												'false', <!---masivo--->
												'', <!---tabla_temporal--->
												0,<!---calc_diasnomina--->
												rsDatosConcepto.Ivalor
												, ''
												,rsDatosConcepto.CIsprango
												,rsDatosConcepto.CIspcantidad
												)>

					<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>

					<cfif Not IsDefined("values") or not isdefined("presets_text")>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_NoEsPosibleRealizarElCalculo"
							Default="No es posible realizar el c&aacute;lculo"
							XmlFile="/rh/generales.xml"
							returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
						<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
					</cfif>

					<cfset iMonto = #values.get('resultado').toString()#>
				<!----------------- Fin de calculadora ------------------->
				<cfelse>
					<cfset iValor1PR = rsDEdatos.DEdato3 * vDiasCalInc>
				</cfif>

				<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
					DEid = "#rsEmp.DEid#"
					CIid = "#rs1PR.CIid#"
					iFecha = "#LSParseDateTime(rsCalendario.CPhasta)#"
					iValor = "#iValor1PR#"
					returnVariable="Lvar_Iid">
					<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
						<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
					</cfif>
					<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
						<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
					</cfif>
					<cfinvokeargument name="Imonto" value="#iMonto#">
				</cfinvoke>

			</cfif>

			<!---==== 1P2 PREMIO DE PRODUCTIVIDAD 2====--->
			<cfif rsDEdatos.DEdato4 neq '' and rsDEdatos.DEdato4 gt 0>
				<cfquery name="rsDatosConcepto" datasource="#Session.DSN#">
				<!--- Obtener datos de la incidencia, requeridos por la calculadora --->
					select 	
						coalesce(b.CItipo,'m') as CItipo,
						b.CIdia,
						b.CImes,
						b.CIcalculo,
						<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(rsCalendario.CPhasta,'YYYY-MM-dd')#"> as Ifecha,
						<!--- OPARRALES 2018-12-27 Si horasFalta > 0 se convierte a dias y se le resta a los dias laborados (7) --->
						#rsDEdatos.DEdato4# as Ivalor,
						<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#"> as DEid,
						0 as RHJid,
						'#Trim(form.Tcodigo)#' as Tcodigo,
						coalesce(b.CIcantidad,0) as CIcantidad,
						coalesce(b.CIrango,0) as CIrango
						, coalesce(b.CIspcantidad,0) as CIspcantidad
						, coalesce(b.CIsprango,0) as CIsprango
					from CIncidentes a
						left outer join CIncidentesD b
							on a.CIid = b.CIid
					where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs1P2.CIid#">
					and a.CItipo = 3
				</cfquery>

				<cfif rsDatosConcepto.RecordCount NEQ 0>
					<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
					<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
					<cfset current_formulas = rsDatosConcepto.CIcalculo>
					<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
												LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
												rsDatosConcepto.CIcantidad,<!---CIcantidad--->
												rsDatosConcepto.CIrango, <!---CIrango--->
												rsDatosConcepto.CItipo, <!---CItipo--->
												rsDatosConcepto.DEid,	<!---DEid--->
												rsDatosConcepto.RHJid, <!---RHJid--->
												session.Ecodigo, <!---Ecodigo--->
												0, <!---RHTid--->
												0, <!---RHAlinea--->
												rsDatosConcepto.CIdia, <!---CIdia--->
												rsDatosConcepto.CImes,<!---CImes--->
												rsDatosConcepto.Tcodigo,<!---Tcodigo--->
												FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
												'false', <!---masivo--->
												'', <!---tabla_temporal--->
												0,<!---calc_diasnomina--->
												rsDatosConcepto.Ivalor
												, ''
												,rsDatosConcepto.CIsprango
												,rsDatosConcepto.CIspcantidad
												)>

					<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>

					<cfif Not IsDefined("values") or not isdefined("presets_text")>
						<cfinvoke component="sif.Componentes.Translate"
							method="Translate"
							Key="LB_NoEsPosibleRealizarElCalculo"
							Default="No es posible realizar el c&aacute;lculo"
							XmlFile="/rh/generales.xml"
							returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
						<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
					</cfif>

					<cfset iMonto = #values.get('resultado').toString()#>
				<!----------------- Fin de calculadora ------------------->
				<cfelse>
					<cfset iValor1P2 = rsDEdatos.DEdato4 * vDiasCalInc>
				</cfif>

				<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
					DEid = "#rsEmp.DEid#"
					CIid = "#rs1P2.CIid#"
					iFecha = "#LSParseDateTime(rsCalendario.CPhasta)#"
					iValor = "#iValor1P2#"
					returnVariable="Lvar_Iid">
					<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
						<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
					</cfif>
					<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
						<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
					</cfif>
					<cfinvokeargument name="Imonto" value="#iMonto#">
				</cfinvoke>
			</cfif>
		</cfif>
		<!--- ================ FIN INCIDENCIAS DE PRODUCTIVIDAD ============== --->

		<!--- ==== 2DE DESPENSA EXENTA ==== --->
		<cfif form.Tcodigo neq '02'>
			<cfset numCompleto = LSNumberFormat(horasFalta,'000')>

			<cfset numHors = Left(numCompleto,1)>
			<cfset numMins = Val(Right(numCompleto,2))>

			<cfset varHorasFalta = numHors & '.' & numMins>

			<cfif numMins gt 0>
				<!--- Convertirmos Minuntos a Horas --->
				<cfset fracHor = numMins/60>
				<cfset arrFracHor = ListToArray(fracHor,'.',false,true)>
				<cfset varFracHor = arrFracHor[2]>

				<!--- Concatenamos el numero total de horas --->
				<cfset varHorasFalta = Val(numHors) & "." & Val(varFracHor)>

			</cfif>
			
			<cfset iValor2DE = 52.59>

			<cfset vDiasCalInc = varDBC-((varHorasFalta gt 0 ? (DiasFalta+(varHorasFalta/8)): DiasFalta) * factorFaltas)>
			<cfquery name="rsDatosConcepto" datasource="#Session.DSN#">
			<!--- Obtener datos de la incidencia, requeridos por la calculadora --->
				select 	
					coalesce(b.CItipo,'m') as CItipo,
					b.CIdia,
					b.CImes,
					b.CIcalculo,
					<cfqueryparam cfsqltype="cf_sql_date" value="#LSDateFormat(rsCalendario.CPhasta,'YYYY-MM-dd')#"> as Ifecha,
					<!--- OPARRALES 2018-12-27 Si horasFalta > 0 se convierte a dias y se le resta a los dias laborados (7) --->
					#iValor2DE# as Ivalor,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEmp.DEid#"> as DEid,
					0 as RHJid,
					'#Trim(form.Tcodigo)#' as Tcodigo,
					coalesce(b.CIcantidad,0) as CIcantidad,
					coalesce(b.CIrango,0) as CIrango
					, coalesce(b.CIspcantidad,0) as CIspcantidad
					, coalesce(b.CIsprango,0) as CIsprango
				from CIncidentes a
					left outer join CIncidentesD b
						on a.CIid = b.CIid
				where a.CIid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rs2DE.CIid#">
				and a.CItipo = 3
			</cfquery>

			<cfif rsDatosConcepto.RecordCount NEQ 0>
				<!---LLAMAR CALCULADORA PARA OBTENER EL Imonto----->
				<cfset RH_Calculadora = createobject("component","rh.Componentes.RH_Calculadora")><!----Para utilizar la calculadora--->
				<cfset current_formulas = rsDatosConcepto.CIcalculo>
				<cfset presets_text = RH_Calculadora.get_presets(LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha1_accion--->
											   LSParseDateTime(rsDatosConcepto.Ifecha),<!---fecha2_accion--->
											   rsDatosConcepto.CIcantidad,<!---CIcantidad--->
											   rsDatosConcepto.CIrango, <!---CIrango--->
											   rsDatosConcepto.CItipo, <!---CItipo--->
											   rsDatosConcepto.DEid,	<!---DEid--->
											   rsDatosConcepto.RHJid, <!---RHJid--->
											   session.Ecodigo, <!---Ecodigo--->
											   0, <!---RHTid--->
											   0, <!---RHAlinea--->
											   rsDatosConcepto.CIdia, <!---CIdia--->
											   rsDatosConcepto.CImes,<!---CImes--->
											   rsDatosConcepto.Tcodigo,<!---Tcodigo--->
											   FindNoCase('SalarioPromedio', current_formulas), <!---calc_promedio--->
											   'false', <!---masivo--->
											   '', <!---tabla_temporal--->
											   0,<!---calc_diasnomina--->
											   rsDatosConcepto.Ivalor
											   , ''
											   ,rsDatosConcepto.CIsprango
											   ,rsDatosConcepto.CIspcantidad
											   )>

				<cfset values = RH_Calculadora.calculate( presets_text & ";" & current_formulas )>

				<cfif Not IsDefined("values") or not isdefined("presets_text")>
					<cfinvoke component="sif.Componentes.Translate"
						method="Translate"
						Key="LB_NoEsPosibleRealizarElCalculo"
						Default="No es posible realizar el c&aacute;lculo"
						XmlFile="/rh/generales.xml"
						returnvariable="LB_NoEsPosibleRealizarElCalculo"/>
					<cf_throw message="#LB_NoEsPosibleRealizarElCalculo#" errorCode="1000">
				</cfif>

				<cfset iMonto = #values.get('resultado').toString()#>
			<!----------------- Fin de calculadora ------------------->
			<cfelse>
				<cfset vDiasCalInc = varDBC-((varHorasFalta gt 0 ? (DiasFalta+(varHorasFalta/8)): DiasFalta) * factorFaltas)>
				<cfset iValor2DE = 52.59 * 0.4 * vDiasCalInc>
			</cfif>
		
			<cfinvoke component="rh.Componentes.RH_Incidencias"  method="Alta"
				DEid = "#rsEmp.DEid#"
				CIid = "#rs2DE.CIid#"
				iFecha = "#LSParseDateTime(rsCalendario.CPhasta)#"
				iValor = "#iValor2DE#"
				returnVariable="Lvar_Iid">
				<cfif isdefined("rsCFEmp.CFid") and len(trim(rsCFEmp.CFid)) gt 0>
					<cfinvokeargument name="CFid" value="#rsCFEmp.CFid#">
				</cfif>
				<cfif isdefined("rsUltimaAccionEmp.RHJid") and len(trim(rsUltimaAccionEmp.RHJid)) gt 0>
					<cfinvokeargument name="RHJid" value="#rsUltimaAccionEmp.RHJid#">
				</cfif>
				<cfinvokeargument name="Imonto" value="#iMonto#">
			</cfinvoke>
		</cfif>

		<cfset contador++>
	</cfloop>
	<!---
		<cf_dump var="STOP.... INDUCIENDO A ROLLBACK">
	--->
</cftransaction>

<form name="form1" method="post" action="InterfazRelojChecador_form.cfm">
	<input type="hidden" name="ProcesoTerminado" value="1">
</form>

<script>
	document.form1.submit();
</script>

<cffunction name="getEmpleadoObj" access="private" returntype="struct">
	<cfargument name="DEIdentificacion" type="string" 	required="true">
	<cfargument name="DiasHoras" 		type="any" 		required="true">
	<cfargument name="Faltas"			type="any"		required="true">
	<cfargument name="HorasExtra"		type="any"		required="true">
	<cfargument name="HorasEspeciales"	type="any"		required="true">
	<cfargument name="DiasExtras"		type="numeric"	required="true">
	<cfargument name="DiasEspeciales"	type="numeric"	required="true">
	<cfargument name="Periodo"			type="string"	required="true">

	<cfset myStruct = StructNew()>
	<cfscript>
		myStruct = {
						DEIdentificacion:Arguments.DEIdentificacion,
						DiasHoras:Arguments.DiasHoras,
						Faltas:Arguments.Faltas,
						HorasExtra:Arguments.HorasExtra,
						HorasEspeciales:Arguments.HorasEspeciales,
						DiasExtras:Arguments.DiasExtras,
						DiasEspeciales:Arguments.DiasEspeciales,
						Periodo:Arguments.Periodo,
						Monto1PA:0.0,
						Monto1PP:0.0,
						Monto1DD:0.0,
						Monto1DF:0.0
					};
	</cfscript>
	<cfreturn myStruct>
</cffunction>