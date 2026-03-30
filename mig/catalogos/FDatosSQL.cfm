<!---Mantencion de filtros de la lista inicial--->
<cfparam name="pagenum" default="1">
<cfif isdefined('form.pagenum') and len(trim(form.pagenum))>
	<cfset pagenum = form.pagenum>
</cfif>
<cfif isdefined('form.pagenumL') and len(trim(form.pagenumL)) and isdefined("form.Eliminar")>
	<cfset pagenum = form.pagenumL>
</cfif>
<cfif isdefined('url.pagenum') and len(trim(url.pagenum))>
	<cfset pagenum = url.pagenum>
</cfif>


<cfparam name="fMIGMid" default="">
<cfif isdefined('form.fMIGMid') and len(trim(form.fMIGMid))>
	<cfset fMIGMid = form.fMIGMid>
</cfif>
<cfif isdefined('form.fMIGMidL') and len(trim(form.fMIGMidL)) and isdefined("form.Eliminar")>
	<cfset fMIGMid = form.fMIGMidL>
</cfif>
<cfif isdefined('url.fMIGMid') and len(trim(url.fMIGMid))>
	<cfset fMIGMid = url.fMIGMid>
</cfif>

<cfparam name="fLote" default="">
<cfif isdefined('form.fLote') and len(trim(form.fLote))>
	<cfset fLote = form.fLote>
</cfif>
<cfif isdefined('form.fLoteL') and len(trim(form.fLoteL)) and isdefined("form.Eliminar")>
	<cfset fLote = form.fLoteL>
</cfif>
<cfif isdefined('url.fLote') and len(trim(url.fLote))>
	<cfset fLote = url.fLote>
</cfif>
<!---fin de los filtros de la lista inicial--->


<cfif isdefined('form.Pfecha') and trim(form.Pfecha) EQ "">
<cfset form.Pfecha = LSDateFormat(Now(),'dd/mm/yyyy')>
</cfif>


<cfif isdefined ('form.Regresar')>
	<cflocation url="FDatos.cfm?pagenum=#pagenum#&fMIGMid=#fMIGMid#&fLote=#fLote#">
</cfif>
<cfif isdefined ('form.Lista')>
	<cflocation url="FDatos.cfm?pagenum=#pagenum#&fMIGMid=#fMIGMid#&fLote=#fLote#">
</cfif>
<cfif isdefined ('form.Importar')>
	<cflocation url="FDatosImportador.cfm?pagenum=#pagenum#&fMIGMid=#fMIGMid#&fLote=#fLote#">
</cfif>

<cfif isdefined('form.ALTA')>
	<cfset CargaPeriodo()>
	<cfquery name="rsMet" datasource="#session.DSN#">
		select MIGMtipodetalle,MIGMperiodicidad,MIGMtipodetalle
		from MIGMetricas
		where  MIGMid = #form.MIGMid#
	</cfquery>

	<cfquery name="rsRepetido" datasource="#session.DSN#">
				select count(1) as si
				from F_Datos
				where 	MIGMid			= #form.MIGMid#
			<cfif isdefined('form.Dcodigo') and len(trim(form.Dcodigo))>
				and Dcodigo = #form.Dcodigo#
			</cfif>
		<cfif isdefined("form.MIGMdetalleid") and len(trim(form.MIGMdetalleid))>
			<cfif rsMet.MIGMtipodetalle is 'P'>
				and MIGProid = #form.MIGMdetalleid#
			<cfelseif rsMet.MIGMtipodetalle is 'C'>
				and MIGCueid = #form.MIGMdetalleid#
			<cfelse>
				and Dcodigo = #form.MIGMdetalleid#
			</cfif>
		</cfif>
			<cfif isdefined ('form.Mcodigo') and len(trim(form.Mcodigo)) GT 0>
				and id_moneda= #rsMonedaEmpresa.Mcodigo#
				and id_moneda_origen= #form.Mcodigo#
			</cfif>
			<cfif len(trim(form.id_atr_dim4)) GT 0 >
				and id_atr_dim4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.id_atr_dim4)#">
			</cfif>
			<cfif len(trim(form.id_atr_dim5)) GT 0>
				and id_atr_dim5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.id_atr_dim5)#">
			</cfif>
				and  	Ecodigo =		#session.Ecodigo#
				and 	Periodo_Tipo = 	'#rsPeriodo.Periodo_Tipo#'
				and 	Periodo = 		#rsPeriodo.Periodo#
	</cfquery>
	<cfif rsRepetido.si GT 0>
		<center><font style="font-family:Arial, Helvetica, sans-serif; size:12; color:##FF0000">Dato Repetido</font><br><a href=javascript:history.back() class=linktexto>Volver</a>  </center>
		<cfabort>
	</cfif>
		<cfquery name="rsLote" datasource="#session.dsn#">
			select max(Lote) as Lote from F_Datos
			where Ecodigo=#session.Ecodigo#
		</cfquery>
		<cfset LvarLote=0>
		<cfif rsLote.Lote EQ "">
			<cfset LvarLote=1>
		<cfelse>
			<cfset LvarLote=rsLote.Lote+1>
		</cfif>
		<!---Busca las lineas existentes en F_datos para hacerles un update--->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select  id_datos
			  from 	F_Datos
				 where 	MIGMid			= #form.MIGMid#
			 	and 	Dcodigo			= #form.Dcodigo#
			<cfif isdefined ('form.MIGProid') and form.MIGProid NEQ "">
			   and 	MIGProid = #form.MIGProid#
			</cfif>
			<cfif isdefined ('form.MIGCueid') and form.MIGCueid NEQ "">
			   and 	MIGCueid = 	#form.MIGCueid#
			</cfif>
			<cfif isdefined ('form.Mcodigo') and form.Mcodigo NEQ "">
				and id_moneda=#rsMonedaEmpresa.Mcodigo#
				and id_moneda_origen=#form.Mcodigo#
			</cfif>
			<cfif isdefined ('form.id_atr_dim4') and form.id_atr_dim4 NEQ "">
				and id_atr_dim4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.id_atr_dim4)#">
			</cfif>
			<cfif isdefined ('form.id_atr_dim5') and form.id_atr_dim5 NEQ "">
				and id_atr_dim5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.id_atr_dim5)#">
			</cfif>
			  	and  	Ecodigo =		#session.Ecodigo#
			  	and 	Periodo_Tipo = 	'#rsPeriodo.Periodo_Tipo#'
			  	and 	Periodo = 		#rsPeriodo.Periodo#
		</cfquery>

		<cfif rsSQL.id_datos EQ "">
			<cftransaction>
				<cfinvoke component="mig.Componentes.FDatos" method="Alta" returnvariable="Lvarid_datos">
					<cfinvokeargument name="Lote" 					value="#LvarLote#"/>
					<cfinvokeargument name="cod_fuente" 			value="1"/>
					<cfinvokeargument name="MIGMid" 				value="#form.MIGMid#"/>

				<cfif not isdefined("form.MIGMdetalleid") or not len(trim(form.MIGMdetalleid))>
					<cfinvokeargument name="Dcodigo" 				value="#form.Dcodigo#">
					<cfinvokeargument name="MIGCueid" 				value="null">
					<cfinvokeargument name="MIGProid" 				value="null">
				<cfelse>
					<cfif rsMet.MIGMtipodetalle is 'C'>
						<cfinvokeargument name="MIGCueid" 				value="#form.MIGMdetalleid#">
					<cfelse>
						<cfinvokeargument name="MIGCueid" 				value="null">
					</cfif>
					<cfif rsMet.MIGMtipodetalle is 'P'>
						<cfinvokeargument name="MIGProid" 				value="#form.MIGMdetalleid#">
					<cfelse>
						<cfinvokeargument name="MIGProid" 				value="null">
					</cfif>
					<cfif isdefined('form.MIGMdetalleid') and len(trim(form.MIGMdetalleid)) and rsMet.MIGMtipodetalle is 'D'>
						<cfinvokeargument name="Dcodigo" 				value="#form.MIGMdetalleid#">
					<cfelse>
						<cfinvokeargument name="Dcodigo" 				value="#form.Dcodigo#">
					</cfif>

				</cfif>
				<cfif isdefined ('form.Mcodigo') and form.Mcodigo NEQ "">
					<cfinvokeargument name="id_moneda" 				value="#rsMonedaEmpresa.Mcodigo#">
					<cfinvokeargument name="id_moneda_origen"		value="#form.Mcodigo#">
				<cfelse>
					<cfinvokeargument name="id_moneda" 				value="null">
					<cfinvokeargument name="id_moneda_origen"		value="null">
				</cfif>
					<cfinvokeargument name="Periodo" 				value="#rsPeriodo.Periodo#"/>
					<cfinvokeargument name="Periodo_Tipo" 			value="#rsPeriodo.Periodo_Tipo#"/>
					<cfinvokeargument name="Mes" 					value="#LvarMes#">
					<cfinvokeargument name="Pfecha" 				value="#form.Pfecha#">
					<cfinvokeargument name="Valor" 				    value="#LvarTC#">
					<cfinvokeargument name="valor_moneda_origen" 	value="#form.valor_moneda_origen#">
					<cfinvokeargument name="id_atr_dim4" 			value="#form.id_atr_dim4#">
					<cfinvokeargument name="id_atr_dim5" 			value="#form.id_atr_dim5#">
				</cfinvoke>
				<!---Llamado al Calculo de Acumulados--->
				<cfset LvarOBJ=createObject("component", "mig.componentes.utils")>
				<cfset LvarOBJ.sbCalcularAcumulados(session.dsn)>
			</cftransaction>
		<cfelse>
			<cfthrow type="toUser" message="La M&eacute;trica que esta intentando ingresar ya existe en Sistema para esa Periodicidad.">
		</cfif>

	<cfset modo="Cambio">
	<cflocation url="FDatos.cfm?Lote=#form.Lote#&MIGMid=#MIGMid#&modo=#modo#&id_datos=#Lvarid_datos#&pagenum=#pagenum#&fMIGMid=#fMIGMid#&fLote=#fLote#">
</cfif>

<cfif isdefined ('form.CAMBIO')>
		<cfset CargaPeriodo()>
		<!---Busca las lineas existentes en F_datos para hacerles un update--->
		<cfquery name="rsSQL" datasource="#session.DSN#">
			select  id_datos
			  from 	F_Datos
				 where 	MIGMid			= #form.MIGMid#
			 	and 	Dcodigo			= #form.Dcodigo#
			<cfif isdefined ('form.MIGProid') and form.MIGProid NEQ "">
			   and 	MIGProid = #form.MIGProid#
			</cfif>
			<cfif isdefined ('form.MIGCueid') and form.MIGCueid NEQ "">
			   and 	MIGCueid = 	#form.MIGCueid#
			</cfif>
			<cfif isdefined ('form.Mcodigo') and form.Mcodigo NEQ "">
				and id_moneda=#rsMonedaEmpresa.Mcodigo#
				and id_moneda_origen=#form.Mcodigo#
			</cfif>
			<cfif isdefined ('form.id_atr_dim4') and form.id_atr_dim4 NEQ "">
				and id_atr_dim4 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.id_atr_dim4)#">
			</cfif>
			<cfif isdefined ('form.id_atr_dim5') and form.id_atr_dim5 NEQ "">
				and id_atr_dim5 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.id_atr_dim5)#">
			</cfif>
			  	and  	Ecodigo =		#session.Ecodigo#
			  	and 	Periodo_Tipo = 	'#rsPeriodo.Periodo_Tipo#'
			  	and 	Periodo = 		#rsPeriodo.Periodo#
		</cfquery>
		<cfif rsSQL.id_datos EQ "" or rsSQL.id_datos EQ form.id_datos>
			<cftransaction>
				<cfinvoke component="mig.Componentes.FDatos" method="Cambio" returnvariable="Lvarid_datos">
					<cfinvokeargument name="id_datos" 				value="#form.id_datos#"/>
					<cfinvokeargument name="Pfecha" 				value="#form.Pfecha#">
					<cfinvokeargument name="Valor" 				    value="#LvarTC#">
					<cfinvokeargument name="valor_moneda_origen" 	value="#form.valor_moneda_origen#">
					<cfinvokeargument name="Periodo" 				value="#rsPeriodo.Periodo#"/>
				</cfinvoke>
			<!---Llamado al Calculo de Acumulados--->
				<cfset LvarOBJ=createObject("component", "mig.componentes.utils")>
				<cfset LvarOBJ.sbCalcularAcumulados(session.dsn)>
			</cftransaction>
		<cfelse>
			<cfthrow type="toUser" message="La M&eacute;trica no se puede Modificar ya esa línea ya exite para ese periodo especifico.">
		</cfif>
	<cfset modo="Cambio">
	<cflocation url="FDatos.cfm?MIGMid=#form.MIGMid#&modo=#modo#&id_datos=#form.id_datos#&pagenum=#pagenum#&fMIGMid=#fMIGMid#&fLote=#fLote#">
</cfif>
<cfif isdefined ('form.BAJA')>
	<cftransaction>
		<cfquery datasource="#session.DSN#">
			Delete F_Datos
			where id_datos = #form.id_datos#
		</cfquery>

		<cfquery datasource="#session.DSN#">
			Delete F_METRICA
			where ID_DATOS = #form.id_datos#
		</cfquery>
	</cftransaction>

	<cflocation url="FDatos.cfm?pagenum=#pagenum#&fMIGMid=#fMIGMid#&fLote=#fLote#">
</cfif>
<cfif isdefined ('form.ELIMINAR') and isdefined("form.CHK") and len(trim(form.CHK))>
	<cftransaction>
        <cfquery name="Eliminar_DM" datasource="#session.dsn#">
            delete from F_METRICA
            where ID_DATOS in (#form.CHK#)
        </cfquery>

        <cfquery name="Eliminar_MIG" datasource="#session.dsn#">
            delete from F_Datos
            where ID_DATOS in (#form.CHK#)
            and Ecodigo= #session.Ecodigo#
        </cfquery>
        <cftransaction action="commit"/>
	</cftransaction>
	<cflocation url="FDatos.cfm?pagenum=#pagenum#&fMIGMid=#fMIGMid#&fLote=#fLote#">
</cfif>

<cfif isdefined ('form.Nuevo')>
	<cflocation url="FDatos.cfm?Nuevo&pagenum=#pagenum#&fMIGMid=#fMIGMid#&fLote=#fLote#">
</cfif>

<cffunction name="CargaPeriodo" access="private" output="yes" returntype="any">
	<!---Crea un Temporal para Generar el Periodo en Base a la Periodicidad de la Métrica--->
    <cf_dbtemp name="MIGFDatosPeriodo" returnvariable="MIGFDatosPeriodo" datasource="#session.DSN#">
         <cf_dbtempcol name="Fecha"   type="date" mandatory="yes">
    </cf_dbtemp>
    <cfquery name="ERR" datasource="#session.DSN#">
        Insert into #MIGFDatosPeriodo#
        values (<cfqueryparam cfsqltype="cf_sql_date"    value="#LSparseDateTime(form.Pfecha)#">)
    </cfquery>
    
    <!--- Saca el Periodo de la Meta segun la metrica--->
    <cf_dbfunction2 name="date_part"   args="YYYY,a.Fecha"     datasource="#session.dsn#" returnVariable="YYYY">
    <cfset YYYY &= "* 1000">
    <cf_dbfunction2 name="date_format" args="a.Fecha,YYYY"   datasource="#session.dsn#" returnVariable="PART_A">
    <cf_dbfunction2 name="date_part" args="DY,a.Fecha" datasource="#session.dsn#" returnVariable="PART_D">
    <cf_dbfunction2 name="date_part" args="WK,a.Fecha" datasource="#session.dsn#" returnVariable="PART_W">
    <cf_dbfunction2 name="date_part" args="MM,a.Fecha" datasource="#session.dsn#" returnVariable="PART_M">
    <cf_dbfunction2 name="date_part" args="QQ,a.Fecha" datasource="#session.dsn#" returnVariable="PART_T">
    <cf_dbfunction2 name="date_part" args="QQ,a.Fecha" datasource="#session.dsn#" returnVariable="PART_Q">
    <cfquery  name="rsPeriodo" datasource="#session.dsn#">
        select a.Fecha,
            #preserveSingleQuotes(YYYY)#+
            case b.MIGMperiodicidad
                        when 'D' then #preserveSingleQuotes(PART_D)#
                        when 'W' then #preserveSingleQuotes(PART_W)#
                        when 'M' then #preserveSingleQuotes(PART_M)#
                        when 'T' then #preserveSingleQuotes(PART_T)#
                        when 'A' then 1
                        when 'S' then
                                    case when #preserveSingleQuotes(PART_Q)# <= 2 then
                                                1
                                    else
                                                2
                                    end
            end as Periodo,
            #preserveSingleQuotes(YYYY)#+ #preserveSingleQuotes(PART_M)# as PeriodoMes,
            b.MIGMperiodicidad as Periodo_Tipo
        from #MIGFDatosPeriodo# a, MIGMetricas b
        where b.MIGMid=#form.MIGMid#
        and b.Ecodigo = #session.Ecodigo#
    </cfquery>
    
    <cfset LvarMes=mid(form.Pfecha,4,2)*1>
    <!---FACTOR DE CONVERSIÓN--->
    <cfif isdefined('form.Mcodigo') and form.Mcodigo NEQ "">
        <!---Primero obtengo el MISO de la Moneda del Datos--->
        <cfquery name="rsMIGMonedas" datasource="#session.dsn#">
            select Mcodigo,Miso4217
            from MIGMonedas
            where Mcodigo=#form.Mcodigo#
        </cfquery>
        <!---Luego obtengo el Mcodigo para compararlo con el de la empresa--->
        <cfquery name="rsMonedaEmpresa" datasource="#session.dsn#">
            select Mcodigo
            from Empresas
            where Ecodigo=#session.Ecodigo#
        </cfquery>
        <!---obtengo el Mcodigo para compararlo--->
        <cfquery name="rsMoneda" datasource="#session.dsn#">
            select Mcodigo,Miso4217
            from Monedas
            where Mcodigo=#rsMonedaEmpresa.Mcodigo#
            and Ecodigo=#session.Ecodigo#
        </cfquery>
        <cfif rsMoneda.Miso4217 NEQ rsMIGMonedas.Miso4217>
            <cfset LvarMes=mid(rsPeriodo.Fecha,6,2)*1>
            <cfset LvarMesPer=mid(rsPeriodo.Fecha,6,2)>
            <cfset LvarPer=mid(rsPeriodo.Periodo,1,5)*1>
            <cfquery name="rsTipoCambio" datasource="#session.dsn#">
                select Factor
                from MIGFactorconversion
                where Ecodigo=#session.Ecodigo#
                and Mcodigo=#rsMIGMonedas.Mcodigo#
                and Periodo=#LvarPer##LvarMesPer#
                and Mes=#LvarMes#
            </cfquery>
            <cfset LvarTC=0>
            <cfif rsTipoCambio.recordcount GT 0>
                <cfset LvarTC=rsTipoCambio.Factor*form.valor_moneda_origen>
            <cfelse>
                <cfset LvarPer=mid(rsPeriodo.Periodo,1,4)*1>
                <cfthrow type="toUser" message="Para la Moneda #rsMIGMonedas.Miso4217# no existe un Historico de Tipo de Cambio en el Perido #LvarPer# para el mes #LvarMes#">
            </cfif>
        <cfelse>
            <cfset LvarTC=form.valor_moneda_origen>
        </cfif>
    <cfelse>
        <cfset LvarTC=form.valor_moneda_origen>
    </cfif>
</cffunction>

