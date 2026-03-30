<cfcomponent output="no">
	<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<!---Consultas moneda local de la empresa--->
    <cffunction name="MonedaLocal" output="no"  access="public" returntype="query" hint="Consultas moneda local de la empresa">
    	<cfargument name="Ecodigo"      		type="numeric" required="yes">
       	<cfquery name="rsMonedaLoc" datasource="#session.dsn#" cachedwithin="#CreateTimeSpan(1,0,0,0)#">
         	select Mcodigo
				from Empresas
          	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
       	</cfquery>
       <cfreturn rsMonedaLoc>
     </cffunction>
<!----Balance entre monedas ----->
    <cffunction name="balanceEntreMonedas" output="no"  access="public" returntype="any" hint="balance entre monedas">
        <cfargument name="Conexion" 	  type="string"  required="false" default="#session.dsn#">
		<cfargument name="Ecodigo" 		  type="numeric" required="false" default="#session.Ecodigo#">
		<cfargument name="TB_Intarc" 	  type="string"  required="true">

		<cfset INTARC = arguments.TB_Intarc>

		 <cfquery name="rsIntarc" datasource="#session.dsn#">
			 select	coalesce(sum(CASE WHEN INTTIP = 'C' THEN INTMON ELSE 0 END),0)  as MON_C,
			 		coalesce(sum(CASE WHEN INTTIP = 'C' THEN INTMOE ELSE 0 END),0)  as MOE_C,
					coalesce(sum(CASE WHEN INTTIP = 'D' THEN INTMON ELSE 0 END),0)  as MON_D,
			 		coalesce(sum(CASE WHEN INTTIP = 'D' THEN INTMOE ELSE 0 END),0)  as MOE_D
			 from #INTARC#
		 </cfquery>

		<cfset LvarDifMon =  rsIntarc.MON_C - rsIntarc.MON_D>
		<cfset LvarDifMoE =  rsIntarc.MOE_C - rsIntarc.MOE_D>

		<cfif isdefined ('LvarDifMoE') and LvarDifMoE neq 0>
	   		<cfquery name="rsBalanceOM" datasource="#session.dsn#">
				select 	Ocodigo, Mcodigo,sum(INTMOE * case when INTTIP = 'D' then 1 else -1 end) as DIFMOE
		  		from #INTARC#
		 		  group by Ocodigo, Mcodigo
		 		having sum(INTMOE * case when INTTIP = 'D' then 1 else -1 end) <> 0
			</cfquery>
			<cfif rsBalanceOM.recordCount GT 0>
				<!--- Establece si el Balance es entre Oficinas o Monedas --->
				<cfquery name="rsBalanceOfi" dbtype="query">
					select count(distinct Ocodigo) as Cantidad
					  from rsBalanceOM
				</cfquery>
				<cfif rsBalanceOfi.Cantidad GT 1>
					<!--- Balance entre Oficinas --->
					<cfset LvarPcodigo = "90">
					<cfset LvarDesc = "Balance entre Oficinas">
				<cfelse>
					<!--- Balance entre Monedas --->
					<cfset LvarPcodigo = "200">
					<cfset LvarDesc = "Balance entre Monedas">
				</cfif>

			<cfquery name="rsCtaBalance" datasource="#session.dsn#" cachedwithin="#CreateTimeSpan(0,1,0,0)#">
				select p.Pvalor as Ccuenta
				  from Parametros p
				 where p.Ecodigo = #Arguments.Ecodigo#
				   and p.Pcodigo = #LvarPcodigo#
			</cfquery>

			<!--- Datos del primer registro de INTARC --->
			<cfquery name="rsINTARC" datasource="#session.dsn#" maxrows="1">
				select *
				  from #INTARC#
			</cfquery>
		<cfloop query="rsBalanceOM">
			<!--- Inserta el ajuste por cada Oficina, Moneda, TipoCambio --->
			<cfquery name="rsBalance" datasource="#session.dsn#">
				select 	Ocodigo, Mcodigo, round(INTCAM,10) as INTCAM,
						sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) as DIFMOE,
						sum(case when INTTIP = 'D' then INTMON else -INTMON end) as DIFMON
				  from #INTARC#
				 where Ocodigo = #rsBalanceOM.Ocodigo#
				   and Mcodigo = #rsBalanceOM.Mcodigo#
				 group by Ocodigo, Mcodigo, round(INTCAM,10)
				 having sum(case when INTTIP = 'D' then INTMOE else -INTMOE end) <> 0
				 	 OR (min(INTMOE) = 0 AND sum(case when INTTIP = 'D' then INTMON else -INTMON end) <>0) <!--- Para que tome en cuenta los ajustes por redondeo --->
			</cfquery>
			<cfif (not isdefined('Arguments.RealizaBO') and LvarPcodigo eq 90)>
                <cfloop query="rsBalance">
                    <cfquery datasource="#session.dsn#">
                        insert into #INTARC#
                            (
                                INTORI, INTREL, INTDOC, INTREF,
                                INTFEC, Periodo, Mes, Ocodigo,
                                INTTIP, INTDES,
                                CFcuenta, Ccuenta,
                                Mcodigo, INTMOE, INTCAM, INTMON
                            )
                        values (
                                '#rsINTARC.INTORI#', #rsINTARC.INTREL#, '#rsINTARC.INTDOC#', '#rsINTARC.INTREF#',
                                '#rsINTARC.INTFEC#', #rsINTARC.Periodo#, #rsINTARC.Mes#,
                                #rsBalance.Ocodigo#,
                                <cfif rsBalance.DIFMON GT 0>'C'<cfelse>'D'</cfif>,
                                '#left(LvarDesc,80)#',
                                <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="null">,
                                #rsCtaBalance.Ccuenta#,
                                #rsBalance.Mcodigo#, #abs(rsBalance.DIFMOE)#, #rsBalance.INTCAM#, #abs(rsBalance.DIFMON)#
                            )
                    </cfquery>
                </cfloop>
    	     </cfif>
	    </cfloop>
	</cfif>
			</cfif>
         <cfreturn true>
     </cffunction>

<!----Genera retenciones ----->
    <cffunction name="GeneraRetencion" output="no"  access="public" returntype="any">
        <cfargument name="ETnumero" type="numeric" required="yes">
		<cfargument name="FCid"     type="numeric" required="yes">
		<cfargument name="Ecodigo"  type="numeric" required="yes">
		<cfargument name="INTARC"   type="string"  required="yes">

       <cfquery name="rsRetencion" datasource="#session.dsn#">
         select  case when Rcodigo is null or Rcodigo = '-1' then '' else Rcodigo end as Rcodigo,
		 ETperiodo,ETmes,ETdocumento,CCTcodigo,Usucodigo,Ocodigo from ETransacciones
          where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
		    and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
		    and FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
       </cfquery>
	   <cfif IsDefined('rsRetencion') and  len(trim(#rsRetencion.Rcodigo#)) gt 0>
		  <cfquery name="rsCuentaRetencion" datasource="#session.dsn#">
			 select  Ccuentaretp from Retenciones
			  where Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			  and Rcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsRetencion.Rcodigo#">
		   </cfquery>
			<cfif IsDefined('rsCuentaRetencion') and  (rsCuentaRetencion.recordcount eq 0 or  len(trim(#rsCuentaRetencion.Ccuentaretp#)) eq 0)>
			   <cfthrow message="No está definida la cuenta de pago a retencion para el codigo #rsRetencion.Rcodigo#. Revisar en administración del sistema en el catálogo de retenciones.">
			</cfif>
	      <cfquery name="rsInsert" datasource="#session.dsn#">
            insert #arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,
            INTllave1,INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona, INTidPersona)
          select 'CCRE',1, <cf_dbfunction name="to_char"	args="a.ETdocumento"> #_Cat# a.ETserie,a.CCTcodigo,
              round( ((r.Rporcentaje/100)* a.ETtotal)  * a.ETtc,2),
            b.CCTtipo,
			'Retencion Facturacion: ' #_Cat# <cf_dbfunction name="to_char"	args="a.ETdocumento"> #_Cat# a.ETserie,
            <cf_dbfunction name="to_char"	args="getdate(),112">, a.ETtc,a.ETperiodo,a.ETmes, #rsCuentaRetencion.Ccuentaretp#, a.Mcodigo,a.Ocodigo,
            round( ((r.Rporcentaje/100)* a.ETtotal),2),
			<cf_dbfunction name="to_char"	args="a.FCid">,
			<cf_dbfunction name="to_char"	args="a.ETnumero">,
             'Retencion al socio: ' #_Cat# sn.SNnombre #_Cat# ' - '  #_Cat# sn.SNidentificacion,
            <cf_dbfunction name="to_char"	args="a.ETdocumento"> #_Cat# a.ETserie, case when a.CDCcodigo is not null then '03' else '01' end,	case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
        from ETransacciones a
		  INNER JOIN Retenciones r
		   ON a.Rcodigo = r.Rcodigo
		  AND a.Ecodigo = r.Ecodigo
          INNER JOIN CCTransacciones b
             ON a.CCTcodigo = b.CCTcodigo
			 and a.Ecodigo = b.Ecodigo
          INNER JOIN SNegocios sn
            ON a.SNcodigo = sn.SNcodigo  and a.Ecodigo = sn.Ecodigo
          LEFT OUTER JOIN CuentasSocios d
            ON a.CCTcodigo = d.CCTcodigo  and a.Ecodigo = d.Ecodigo  and a.SNcodigo = d.SNcodigo
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
             and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery>
		 <cfquery name="rsInsert" datasource="#session.dsn#">
            insert #arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,
            INTllave1,INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona, INTidPersona)
          select 'CCRE',1, <cf_dbfunction name="to_char"	args="a.ETdocumento"> #_Cat# a.ETserie,a.CCTcodigo,
              round( ((r.Rporcentaje/100)* a.ETtotal)  * a.ETtc,2),
            case when b.CCTtipo = 'C' then 'D' else 'C' end,
			'Cuenta por cobrar a la caja (retencion): ' #_Cat# k.FCcodigo #_Cat# ' - ' #_Cat# k.FCdesc,
            <cf_dbfunction name="to_char"	args="getdate(),112">, a.ETtc,a.ETperiodo,a.ETmes, k.Ccuenta, a.Mcodigo,a.Ocodigo,
            round( ((r.Rporcentaje/100)* a.ETtotal),2),
			<cf_dbfunction name="to_char"	args="a.FCid">,
			<cf_dbfunction name="to_char"	args="a.ETnumero">,
             'Cuenta por cobrar a la caja (retencion): ' #_Cat# k.FCcodigo #_Cat# ' - ' #_Cat# k.FCdesc,
            <cf_dbfunction name="to_char"	args="a.ETdocumento"> #_Cat# a.ETserie, case when a.CDCcodigo is not null then '03' else '01' end,	case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
        from ETransacciones a
		  INNER JOIN Retenciones r
		   ON a.Rcodigo = r.Rcodigo
		  AND a.Ecodigo = r.Ecodigo
		  INNER JOIN FCajas k
		   ON a.FCid = k.FCid
		  and a.Ecodigo = k.Ecodigo
          INNER JOIN CCTransacciones b
             ON a.CCTcodigo = b.CCTcodigo and a.Ecodigo = b.Ecodigo
          INNER JOIN SNegocios sn
            ON a.SNcodigo = sn.SNcodigo  and a.Ecodigo = sn.Ecodigo
          LEFT OUTER JOIN CuentasSocios d
            ON a.CCTcodigo = d.CCTcodigo  and a.Ecodigo = d.Ecodigo  and a.SNcodigo = d.SNcodigo
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
             and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery>
	<cfset LvarFecha = now()>
	  <cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
        <cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
        <cfinvokeargument name="Oorigen"		value="FAFC"/>
        <cfinvokeargument name="Eperiodo"		value="#rsRetencion.ETperiodo#"/>
        <cfinvokeargument name="Emes"			value="#rsRetencion.ETmes#"/>
        <cfinvokeargument name="Efecha"			value="#LvarFecha#"/>
        <cfinvokeargument name="Edescripcion"	value="Asiento retencion"/>
        <cfinvokeargument name="Edocbase"		value="#rsRetencion.ETdocumento#"/>
        <cfinvokeargument name="Ereferencia"	value="#rsRetencion.CCTcodigo#"/>
        <cfinvokeargument name="Ocodigo"        value="#rsRetencion.Ocodigo#"/>
        <cfinvokeargument name="Usucodigo"		value="#rsRetencion.Usucodigo#"/>
        <cfinvokeargument name="debug"		    value="no"/>
        <cfinvokeargument name="PintaAsiento"   value="false"/>
       </cfinvoke>
	   </cfif>	<!--- Si no hay retencion, no se hace nada---->
        <cfquery name="rsDel" datasource="#session.dsn#">
            delete from #arguments.INTARC#
        </cfquery>


        <cfreturn true>
     </cffunction>


	<cffunction name="InsertaIntarFacturacion">
        <cfargument name="INTARC"       type="string" required="yes">
		<cfargument name="Conexion" 	type="string"  required="no">
		<cfargument name="Ecodigo" 	    type="string"  required="no">
       	<cfargument name="FCid"      	type="numeric" required="yes">
       	<cfargument name="ETnumero"     type="numeric" required="yes">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

        <!---Pronto Pago--->
		<cfset LvarCidPPCom   = ObtenerDato(15752).Pvalor>
        <cfset rsConPPCom   = ObtenerConceptos(LvarCidPPCom)>


        <cfif rsConPPCom.Cformato eq "" and  rsConPPCom.cuentac eq "">
            <cfthrow message="No se ha definido ni el complemento ni la cuenta del concepto codigo:#rsConPPCom.Ccodigo# descr:#rsConPPCom.Cdescripcion#
            favor defina alguno en el catalago de conceptos de servicio">
        </cfif>

        <cfquery name="rsInfo" datasource="#session.dsn#">
             select b.CFid, c.SNid, a.CCTcodigo, a.ETtc, a.Mcodigo, a.Ocodigo, b.DTtotal, a.ETtc, b.ProntoPagoCliente,
              ETperiodo,ETmes,ETdocumento,CCTcodigo,Usucodigo, <cf_dbfunction name="to_char"	args="a.ETdocumento"> #_Cat# a.ETserie as ref
                from ETransacciones a
                	inner join DTransacciones b
                        on b.FCid = a.FCid
                        and b.ETnumero = a.ETnumero
                    left join SNegocios c
                    	on c.SNcodigo = a.SNcodigo
                        and c.Ecodigo = a.Ecodigo
            where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
              and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
        </cfquery>
     	<cfobject component="sif.Componentes.AplicarMascara" name="mascara">

        <cfloop query="rsInfo">

            <cfset LvarCFformato = mascara.fnComplementoItem(Arguments.Ecodigo, rsInfo.CFid, rsInfo.SNid, "Comision", "", rsConPPCom.Cid, "", "",rsConPPCom.Cformato)>

            <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                    <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformato#"/>
                    <cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>
                    <cfinvokeargument name="Lprm_TransaccionActiva" value="no"/>
                    <cfinvokeargument name="Lprm_Ecodigo" 			value="#Arguments.Ecodigo#"/>
            </cfinvoke>

            <cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
                <cfquery name="rsTraeCuenta" datasource="#session.DSN#">
                    select a.CFcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
                    from CFinanciera a
                        inner join CPVigencia b
                             on a.CPVid     = b.CPVid
                            and <cf_dbfunction name="now"> between b.CPVdesde and b.CPVhasta
                    where a.Ecodigo   = #Arguments.Ecodigo#
                      and a.CFformato = '#LvarCFformato#'
                </cfquery>
            </cfif>

            <cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
                <cfthrow message="#LvarCFformato# #LvarError#">
            <cfelseif rsTraeCuenta.CFcuenta EQ "">
                <cfthrow message="#LvarCFformato#, No existe Cuenta de Presupuesto">
            </cfif>

            <cfset LvarPeriodo 	=ObtenerDato(50).Pvalor>
            <cfset LvarMes 		=ObtenerDato(60).Pvalor>

            <cf_dbfunction name="OP_concat"	returnvariable="_Cat">
            <cfquery name="rs" datasource="#session.dsn#">
                 insert #arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM,
                 Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE
                    )
                 values
                 (
                    'CCco', 1,'#arguments.ETnumero#', '#rsInfo.CCTcodigo#',
                    round( #rsInfo.ProntoPagoCliente#  * #rsInfo.ETtc# ,2),
                    'D',
                    'Comisiones: Pronto pago cliente',
                    <cf_dbfunction name="to_char"	args="getdate(),112">,
                    #rsInfo.ETtc#,
                    #LvarPeriodo#, #LvarMes#,
                    #rsTraeCuenta.Ccuenta#,#rsTraeCuenta.CFcuenta# ,
                    #rsInfo.Mcodigo#, #rsInfo.Ocodigo#,
                    round( #rsInfo.ProntoPagoCliente#,2)
                  )
            </cfquery>
        </cfloop>

        <cfquery name="rsInsert" datasource="#session.dsn#">
            insert #arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM,
                 Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)
          select
            'CCco', 1,<cf_dbfunction name="to_char"	args="a.ETdocumento"> #_Cat# a.ETserie,
            a.CCTcodigo,
            round( (select sum(ProntoPagoCliente) from DTransacciones dt where dt.FCid = a.FCid and dt.ETnumero = a.ETnumero)   * #rsInfo.ETtc# ,2),
            'C',
            'Cuenta por cobrar a la caja (comision): '#_Cat# k.FCcodigo #_Cat# ' - ' #_Cat# k.FCdesc,
            <cf_dbfunction name="to_char"	args="getdate(),112">,
            a.ETtc,a.ETperiodo,a.ETmes, k.Ccuenta, a.Mcodigo,a.Ocodigo,

            round( (select sum(ProntoPagoCliente) from DTransacciones dt where dt.FCid = a.FCid and dt.ETnumero = a.ETnumero),2)

        from ETransacciones a
          INNER JOIN FCajas k
           ON a.FCid = k.FCid
          and a.Ecodigo = k.Ecodigo
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
             and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery>
        <cfset LvarFecha = now()>
        <cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="LvarIDcontable">
            <cfinvokeargument name="Ecodigo"		value="#Arguments.Ecodigo#"/>
            <cfinvokeargument name="Oorigen"		value="FAFC"/>
            <cfinvokeargument name="Eperiodo"		value="#rsInfo.ETperiodo#"/>
            <cfinvokeargument name="Emes"			value="#rsInfo.ETmes#"/>
            <cfinvokeargument name="Efecha"			value="#LvarFecha#"/>
            <cfinvokeargument name="Edescripcion"	value="Asiento Comision Egresos: #rsInfo.ref# "/>
            <cfinvokeargument name="Edocbase"		value="#rsInfo.ETdocumento#"/>
            <cfinvokeargument name="Ereferencia"	value="#rsInfo.CCTcodigo#"/>
            <cfinvokeargument name="Ocodigo"        value="#rsInfo.Ocodigo#"/>
            <cfinvokeargument name="Usucodigo"		value="#rsInfo.Usucodigo#"/>
            <cfinvokeargument name="debug"		    value="no"/>
            <cfinvokeargument name="PintaAsiento"   value="false"/>
        </cfinvoke>
        <cfquery name="rsDel" datasource="#session.dsn#">
            delete from #arguments.INTARC#
        </cfquery>
	</cffunction>


	<!--- Valida si en FA va a realizar  --->
    <cffunction name="ValidaComDeFA" >
        <cfargument name="INTARC"       type="string" required="yes">
		<cfargument name="Conexion" 	type="string"  required="no">
		<cfargument name="Ecodigo" 	    type="string"  required="no">
       	<cfargument name="FCid"      	type="numeric" required="yes">
       	<cfargument name="ETnumero"     type="numeric" required="yes">

		<cfif not isdefined('Arguments.Conexion')>
			<cfset Arguments.Conexion = session.dsn>
		</cfif>
		<cfif not isdefined('Arguments.Ecodigo')>
			<cfset Arguments.Ecodigo = session.Ecodigo>
		</cfif>

        <cfquery name="rsComisiones" datasource="#session.dsn#">
             select count(1) as cantidad from DTransacciones
                where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and ProntoPagoClienteCheck = 1
        </cfquery>
        <cfif rsComisiones.cantidad gt 0>
        	<cfset InsertaIntarFacturacion (#arguments.INTARC#,#arguments.Conexion#,#arguments.Ecodigo#,#arguments.FCid#,#arguments.ETnumero#)>
        </cfif>

    </cffunction>

<!------Inserta impuestos --------->
    <cffunction name="GeneraImpuestos" access="public" returntype="any">
        <cfargument name="FCid"        type="numeric" required="true">
		<cfargument name="ETnumero"    type="numeric" required="true">
		<cfargument name="Ecodigo"     type="numeric" required="true">
		<cfargument name="INTARC"      type="string"  required="true">
		<cfargument name="ETdocumento" type="string"  required="true">
		<cfargument name="CCTcodigo"   type="string"  required="true">
		<cfargument name="Monloc"      type="numeric" required="true">
		<cfargument name="Monedadoc"   type="numeric" required="true">
		<cfargument name="Periodo"     type="numeric" required="true">
		<cfargument name="Mes"         type="numeric" required="true">
		<cfargument name="Ocodigo"          type="numeric" required="true">
		<cfargument name="AnulacionParcial" type="boolean" required="false" default="false">
		<cfargument name="LineasDetalle"    type="string" required="false">
    <cfargument name="TBanulacion" type="string"  required="true"> <!--- Tabla de Anulacion --->


    <cfset INTARC = arguments.INTARC>

     <cfquery name="rsImpXlinea" datasource="#session.dsn#">
       select a.Icodigo,  a.DTimpuesto, b.Icompuesto, a.DTlinea
        from DTransacciones a
         inner join Impuestos b
           on a.Icodigo = b.Icodigo
        and a.Ecodigo = b.Ecodigo
            where a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
              and a.FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
        and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        and a.DTimpuesto !=0
          and a.DTborrado  =0
     </cfquery>

	   <cfloop query="rsImpXlinea">
	     <cfif rsImpXlinea.Icompuesto eq 0>
		   <cfquery name="rs" datasource="#session.dsn#">
			insert #INTARC# (
				 INTORI, INTREL, INTDOC, INTREF,
				 INTMON, INTTIP, INTDES, INTFEC,
				 INTCAM, Periodo, Mes, Ccuenta,
				 Mcodigo, Ocodigo, INTMOE,
			INTllave1,INTllave2,INTdescripcion,
			INTdoc_original,INTtipoPersona, INTidPersona)
			select
			'FAFC', 1,'#arguments.ETdocumento#','#arguments.CCTcodigo#',
			((case when #arguments.Monloc# != #arguments.Monedadoc# then
				 round(a.DTimpuesto * e.ETtc,2) else a.DTimpuesto end)),
        <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
          'D',
        <cfelse>
				  case when c.CCTtipo = 'D' then 'C' else 'D' end,
        </cfif>
				<!---b.Idescripcion ,--->
                 b.Icodigo   #_Cat# ' - '#_Cat# sn.SNnombre,
                 <cf_dbfunction name="to_char"	args="getdate(),112">,
				e.ETtc, #arguments.Periodo#, #arguments.Mes#, b.Ccuenta,
				e.Mcodigo, #arguments.Ocodigo#,
        a.DTimpuesto,
				<cf_dbfunction name="to_char"	args="e.FCid">,
				<cf_dbfunction name="to_char"	args="e.ETnumero">,
				a.DTdescripcion, '#arguments.ETdocumento#',
				case when e.CDCcodigo is not null then '03'
				else '01' end,
				case when e.CDCcodigo is not null then e.CDCcodigo else sn.SNid end
			from DTransacciones a
				 inner join CCTransacciones c
					on a.Ecodigo = c.Ecodigo
				 inner join Impuestos b
					 on a.Icodigo  = b.Icodigo
					and a.Ecodigo  = b.Ecodigo
				 inner join ETransacciones e
					 on e.ETnumero  = a.ETnumero
					and e.FCid      = a.FCid
					and e.CCTcodigo = c.CCTcodigo
				 inner join SNegocios sn
					 on e.SNcodigo = sn.SNcodigo
					and e.Ecodigo  = sn.Ecodigo
			where <!---a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
				 and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">  --->
         a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
         and a.DTimpuesto !=0
         and a.DTborrado  = 0
         and b.Icodigo    = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImpXlinea.Icodigo#">
         and a.DTlinea    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsImpXlinea.DTlinea#">
			</cfquery>
		<cfelse>
		   <cfquery name="rs" datasource="#session.dsn#">
			insert #INTARC# (
				 INTORI, INTREL, INTDOC, INTREF,
				 INTMON, INTTIP, INTDES, INTFEC,
				 INTCAM, Periodo, Mes, Ccuenta,
				 Mcodigo, Ocodigo, INTMOE,
			INTllave1,INTllave2,INTdescripcion,
			INTdoc_original,INTtipoPersona, INTidPersona)
			select
			'FAFC', 1,'#arguments.ETdocumento#','#arguments.CCTcodigo#',
			((case when #arguments.Monloc# != #arguments.Monedadoc# then
				 round((a.DTimpuesto *bb.DIporcentaje/ b.Iporcentaje) * e.ETtc,2)
         else  round(a.DTimpuesto * bb.DIporcentaje/ b.Iporcentaje,2) end)),
				<cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
            'D',
         <cfelse>
	         case when c.CCTtipo = 'D' then 'C' else 'D' end,
         </cfif>
				<!---bb.DIdescripcion,--->
                bb.DIcodigo   #_Cat# ' - '#_Cat# sn.SNnombre,
                <cf_dbfunction name="to_char"	args="getdate(),112">,
				e.ETtc, #arguments.Periodo#, #arguments.Mes#, bb.Ccuenta,
				e.Mcodigo, #arguments.Ocodigo#,
        (a.DTimpuesto * bb.DIporcentaje/ b.Iporcentaje),
				<cf_dbfunction name="to_char"	args="e.FCid">,
				<cf_dbfunction name="to_char"	args="e.ETnumero">,
				a.DTdescripcion, '#arguments.ETdocumento#',
				case when e.CDCcodigo is not null then '03'
				else '01' end,
				case when e.CDCcodigo is not null then e.CDCcodigo else sn.SNid end
			from DTransacciones a
				 inner join CCTransacciones c
					on a.Ecodigo = c.Ecodigo
				 inner join Impuestos b
					 on a.Icodigo  = b.Icodigo
					and a.Ecodigo  = b.Ecodigo
				 inner join DImpuestos bb
				    on bb.Icodigo = b.Icodigo
				   and bb.Ecodigo  = b.Ecodigo
				 inner join ETransacciones e
					 on e.ETnumero  = a.ETnumero
					and e.FCid      = a.FCid
					and e.CCTcodigo = c.CCTcodigo
				 inner join SNegocios sn
					 on e.SNcodigo = sn.SNcodigo
					and e.Ecodigo  = sn.Ecodigo
			where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
				 and a.DTimpuesto !=0
				 and a.DTborrado  = 0
				 and b.Icodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsImpXlinea.Icodigo#">
         and a.DTlinea   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsImpXlinea.DTlinea#">
			</cfquery>
        </cfif>
      </cfloop>
	</cffunction>
 <!----Consultas datos ----->
    <cffunction name="ConsultaDatos" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"           type="numeric" required="yes">
        <cfargument name="FCid"      		 type="numeric" required="yes">
        <cfargument name="ETnumero"      	 type="numeric" required="yes">
        <cfargument name="AnulacionParcial"  type="boolean" required="yes">
        <cfargument name="consecutivo"       type="numeric" required="yes">
        <cfargument name="TotalDetalles"     type="numeric" >

        <cfquery name="rsDatos" datasource="#session.dsn#">
    select a.CCTcodigo,
         <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
         ( a.ETserie #_Cat# <cf_dbfunction name="to_char"	args="a.ETdocumento">  #_Cat# '_'#_Cat# <cf_dbfunction name="to_char"	args="#arguments.consecutivo#">) as documento,
        <cfelse>( a.ETserie #_Cat# <cf_dbfunction name="to_char"	args="a.ETdocumento"> ) as documento,</cfif>
         <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
         (<cf_dbfunction name="to_char"	args="a.ETdocumento"> #_Cat# '_' #_Cat# <cf_dbfunction name="to_char"	args="#arguments.consecutivo#">) as documentoOriginal,
        <cfelse> (<cf_dbfunction name="to_char"	args="a.ETdocumento">) as documentoOriginal, </cfif>
        a.Ocodigo, a.Mcodigo, a.ETtc/1.00 as ETtc, <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>  #arguments.TotalDetalles# as ETtotal,
         <cfelse> a.ETtotal, </cfif>a.ETfecha,case when b.CCTtipo = 'D' then 'S' else 'E' end as CCTtipo, SNcodigo, a.CFid, b.CCTtipo as tipoTran, a.ETmontodes, a.ETnombredoc,a.id_direccion,
         coalesce(a.ETmontoRetencion,0) as ETmontoRetencion, ETlote
    from ETransacciones a, CCTransacciones b
    where    a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      and a.Ecodigo = b.Ecodigo and a.CCTcodigo = b.CCTcodigo
    </cfquery>
         <cfreturn rsDatos>
</cffunction>

 <!----Consultas Dtotal ----->
    <cffunction name="ConsultaDtotal" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"           type="numeric" required="yes">
        <cfargument name="FCid"      		 type="numeric" required="yes">
        <cfargument name="ETnumero"      	 type="numeric" required="yes">
        <cfargument name="AnulacionParcial"  type="boolean" required="yes">
        <cfargument name="LineasDetalle"     type="string">
        <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
           <cfset _TBanulacion ='##TBanulacion'>
        </cfif>

       <cfquery name="rsDTtotal" datasource="#session.dsn#">
        <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
         select  ( coalesce(d.DTtotal,0) + coalesce(d.DTimpuesto,0) - coalesce(d.MontoAnulado,0) ) * Coalesce(a.porcentaje,1) as DTtotal
        from DTransacciones d
        left outer join #_TBanulacion# a
          on d.DTlinea = a.DTlinea
        <cfelse>
         select  ( coalesce(d.DTtotal,0) + coalesce(d.DTimpuesto,0) - coalesce(d.MontoAnulado,0) )  as DTtotal
        from DTransacciones d
        </cfif>
        where d.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and d.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and d.DTborrado = 0
		      <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
             and d.DTlinea in (#arguments.LineasDetalle#)
          </cfif>
        </cfquery>
        <cfreturn rsDTtotal>
</cffunction>
 <!----Consultas Total parcial ----->
    <cffunction name="TotalParcial" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"       type="numeric" required="yes">
        <cfargument name="LineasDetalle" type="string" >

      <cfset TBanulacion = '##TBanulacion'>
       <cfquery name="rsTotalParcial" datasource="#session.dsn#">
          select sum((coalesce(d.DTtotal,0) + coalesce(d.DTimpuesto,0) - coalesce(d.MontoAnulado,0) ) * Coalesce(a.porcentaje,1)) as TotalParcial
          from DTransacciones d
          left outer join #TBanulacion# a
            on d.DTlinea = a.DTlinea
          where d.DTlinea in (#arguments.LineasDetalle#)
          and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery>
        <cfreturn rsTotalParcial>
</cffunction>
 <!----Consultas Socio SNid ----->
    <cffunction name="SocioID" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"   type="numeric" required="yes">
        <cfargument name="SNcodigo"  type="string" >

     <cfquery name="rsSNid" datasource="#session.dsn#">
        select SNid from SNegocios
        where Ecodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        and SNcodigo =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNcodigo#">
     </cfquery>
        <cfreturn rsSNid>
</cffunction>
 <!----Consultas vencimiento ----->
    <cffunction name="ConsultaVencimiento" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"    type="numeric" required="yes">
        <cfargument name="CCTcodigo"  type="string" >

     <cfquery name="rsCCTvencim2" datasource="#session.dsn#">
	    select  case when coalesce(CCTvencim,0) = -1 then 1 else 0 end as Contado
	    from CCTransacciones
           where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
	      and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Arguments.CCTcodigo#">
     </cfquery>
        <cfreturn rsCCTvencim2>
</cffunction>
 <!----Consultas de cuentas de la caja ----->
    <cffunction name="CuentasCajas" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"  type="numeric" required="yes">
        <cfargument name="FCid"     type="numeric" required="yes">

        <cfquery name="rsCuentasCajas" datasource="#session.dsn#">
        select  a.Ccuentadesc, a.Ccuenta, b.CFcuenta, a.FCcomplemento , a.FCdesc, a.FCcodigo
          from FCajas  a
            inner join CFinanciera b
               on a.Ccuenta = b.Ccuenta
               and a.Ecodigo = b.Ecodigo
         where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
           and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
        </cfquery>
       <cfreturn rsCuentasCajas>
</cffunction>

  <!----Consultas de cuentas de descuento por centro funcional----->
    <cffunction name="CuentasDescCF" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"          type="numeric" required="yes">
        <cfargument name="FCid"             type="numeric" required="yes">
        <cfargument name="ETnumero"         type="numeric" required="yes">
        <cfargument name="AnulacionParcial" type="boolean" required="yes">
        <cfargument name="LineasDetalle"    type="string"   >

         <cfquery name="rsDescLinea" datasource="#session.dsn#">
                select c.CFid, c.DTlinea, c.Cid,c.Aid, c.CFComplemento, c.DTtipo, c.Aid,c.Cid
                from ETransacciones a
                   inner join  CCTransacciones b
                    on a.CCTcodigo = b.CCTcodigo
                   and a.Ecodigo   = b.Ecodigo
                  inner join DTransacciones c
                     on a.ETnumero = c.ETnumero
                    and a.FCid     = c.FCid
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                 and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and c.DTdeslinea != 0.00
                  and c.DTborrado = 0
                  <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                  and c.DTlinea in (#arguments.LineasDetalle#)
                  </cfif>
		 </cfquery>
  <cfreturn rsDescLinea>
</cffunction>

 <!----Descripcion de tarjeta ----->
    <cffunction name="DescripcionTarjeta" output="no"  access="public" returntype="query">
        <cfargument name="FATid"    type="numeric" required="yes">

        <cfquery name="rsTarjDesc" datasource="#Session.DSN#">
            select FATdescripcion from FATarjetas where FATid = #arguments.FATid#
         </cfquery>
        <cfreturn rsTarjDesc>
</cffunction>
 <!----Direccion del socio de negocios ----->
    <cffunction name="DireccionSN" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"    type="numeric" required="yes">
        <cfargument name="SNid"       type="numeric" required="yes">

        <cfquery name="rsIdDireccion" datasource="#session.dsn#">
            	select coalesce(id_direccion,0) as id_direccion from SNDirecciones
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNid#">
        </cfquery>
        <cfreturn rsIdDireccion>
</cffunction>

 <!----Inserta Plan pagos ----->
<cffunction name="InsertaPlanPagos" output="no"  access="public" returntype="any">
        <cfargument name="Ddocumento"       type="string"  required="yes">
        <cfargument name="Vencimiento"      type="numeric" required="yes">
        <cfargument name="AnulacionParcial" type="boolean"  required="yes">
        <cfargument name="TotalDetalles"    type="numeric" required="yes">
        <cfargument name="FCid"             type="numeric" required="yes">
        <cfargument name="ETnumero"         type="numeric" required="yes">
        <cfargument name="Ecodigo"          type="numeric" required="yes">

<!---  <cfquery name="rsInsert" datasource="#session.dsn#">
            insert into PlanPagos (Ecodigo, CCTcodigo, Ddocumento, PPnumero,PPfecha_vence, PPsaldoant, PPprincipal, PPinteres, PPpagoprincipal, PPpagointeres, PPpagomora, PPfecha_pago, Mcodigo)
            select Ecodigo, CCTcodigo,'#arguments.Ddocumento#', 1 AS PPnumero,<cf_dbfunction name="dateadd"	args="#arguments.Vencimiento#, ETfecha,DD">,
                <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                  #arguments.TotalDetalles#, #arguments.TotalDetalles#,<cfelse> ETtotal, ETtotal,</cfif> 0 as PPinteres,0 as PPpagoprincipal, 0 as PPpagointeres, 0 as PPpagomora, null as PPfecha_pago, Mcodigo
            from ETransacciones a where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                 and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
         </cfquery> --->
</cffunction>
 <!----Consulta CFinanciera ----->
    <cffunction name="ConsultaCFinanciera" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"    type="numeric" required="yes">
        <cfargument name="CFformato"  type="string"  required="no">
        <cfargument name="CFcuenta"  type="numeric"  required="no">

      <cfquery name="rsCFinanciera" datasource="#session.dsn#">
        select Ccuenta, coalesce(CFcuenta,0) as CFcuenta, CFformato
        from CFinanciera
        where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
          <cfif isdefined('arguments.CFformato') and len(trim(arguments.CFformato)) gt 0>
             and CFformato = '#arguments.CFformato#'
          </cfif>
           <cfif isdefined('arguments.CFcuenta') and len(trim(arguments.CFcuenta)) gt 0 and arguments.CFcuenta neq -1 >
             and CFcuenta = #arguments.CFcuenta#
           </cfif>
      </cfquery>
     <cfreturn rsCFinanciera>
</cffunction>
 <!----Consulta lineas de inventario ----->
    <cffunction name="LineasInventario" output="no"  access="public" returntype="query">
        <cfargument name="FCid"             type="numeric"  required="yes">
        <cfargument name="ETnumero"         type="numeric"  required="yes">
        <cfargument name="AnulacionParcial" type="boolean"  required="yes">
        <cfargument name="LineasDetalle"    type="string">
        <cfargument name="Ecodigo"          type="numeric"  required="yes">

        <!----Control de invetarios: Si no se maneja control de inventarios, se va a indicar que no envie nada al posteo para el calculo de posteo de inventario ni costos, de lo contrario pasa el dato de los articulos existentes ------>
            <cfquery name="rsControlInvetarios" datasource="#session.dsn#">
            select <cf_dbfunction name="to_integer" args="Pvalor"> as Pvalor
            from Parametros
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
            and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="15835">
            </cfquery>
        <cfif isdefined('rsControlInvetarios') and rsControlInvetarios.recordcount gt 0 and rsControlInvetarios.Pvalor eq 1>
           <cfquery name="rsPosteo" datasource="#session.dsn#">
             select 1 from DTransacciones
                where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
              and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and DTtipo = 'A' and DTborrado = 0
                  <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                    and DTlinea in (#arguments.LineasDetalle#)
                  </cfif>
          </cfquery>
         <cfelse>
           <cfquery name="rsPosteo" datasource="#session.dsn#">
             select 1 from DTransacciones
                where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
              and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">

           </cfquery>
         </cfif>

     <cfreturn rsPosteo>
</cffunction>


<!------ Costo de linea para articulos ------------->

 <!----Consulta lineas de inventario ----->
    <cffunction name="CostoInventarioArt" output="no"  access="public" returntype="any">
        <cfargument name="FCid"             type="numeric"   required="yes">
        <cfargument name="ETnumero"         type="numeric"   required="yes">
        <cfargument name="AnulacionParcial" type="boolean"   required="yes">
        <cfargument name="LineasDetalle"    type="string"    required="no">
        <cfargument name="Ecodigo"          type="numeric"   required="yes">
        <cfargument name="Articulos1"       type="string"    required="yes">
        <cfargument name="Ocodigo"          type="numeric"   required="true">
        <cfargument name="TBanulacion"      type="string"    required="no">


        <cfset Articulos1 = arguments.Articulos1>

        <cfobject component="sif.Componentes.AplicarMascara" name="mascara">

        <cfquery name="rsDatosInsert" datasource="#session.dsn#">
        select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">, b.Aid, b.DTlinea, b.Alm_Aid, coalesce(b.Ocodigo,#arguments.Ocodigo#) as Ocodigo,
         b.Dcodigo,
        (Round((b.DTcant <cfif Arguments.AnulacionParcial>*Coalesce(tb.porcentaje,1)</cfif>),0)) as cant,
        (round(b.DTtotal * a.ETtc,2) <cfif Arguments.AnulacionParcial>*Coalesce(tb.porcentaje,1)</cfif>) as costolinloc,
        (b.DTtotal <cfif Arguments.AnulacionParcial>*Coalesce(tb.porcentaje,1)</cfif>) as costolinori,
        a.ETtc, a.Mcodigo, e.Ecostou , coalesce(b.NC_Ecostou, 0) as NC_Ecostou, b.CFid, a.ETfecha
        from ETransacciones a, DTransacciones b , Existencias e <cfif Arguments.AnulacionParcial> , #Arguments.TBanulacion# tb</cfif>
        where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETnumero#">
          and a.FCid=b.FCid and a.ETnumero=b.ETnumero and b.DTtipo = 'A' and b.DTborrado = 0
          and b.Aid = e.Aid
          and b.Alm_Aid = e.Alm_Aid
          and b.Ecodigo = a.Ecodigo
          <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
              and b.DTlinea = tb.DTlinea
              and b.DTlinea in (#arguments.LineasDetalle#)
           </cfif>
      </cfquery>
      <cfloop query="rsDatosInsert">
		  <cfif isdefined('rsDatosInsert') and len(trim(rsDatosInsert.CFid)) gt 0>
              <cfquery name="rsCuentaGastoInv" datasource="#session.dsn#">
                   select CFcuentainventario, CFcodigo, CFdescripcion
                   from CFuncional
                    where CFid = #rsDatosInsert.CFid#
                    and Ecodigo = #arguments.Ecodigo#
              </cfquery>
              <cfif isdefined('rsCuentaGastoInv') and  len(trim(rsCuentaGastoInv.CFcuentainventario)) eq 0>
                <cfthrow message="No se ha podido obtener la cuenta de gasto para consumo de inventarios para el centro funcional: #rsCuentaGastoInv.CFcodigo# - #rsCuentaGastoInv.CFdescripcion#. Proceso cancelado!">
              </cfif>
              <cfset LvarCuentagastoInventario =  rsCuentaGastoInv.CFcuentainventario>
          </cfif>
             <cfquery name="rsArtInfo" datasource="#session.dsn#">
                select a.Adescripcion, a.ComplementoActividad, c.cuentac , c.Cdescripcion
                    from Articulos a
                    inner join Clasificaciones c
                    on a.Ccodigo=c.Ccodigo
                    and a.Ecodigo = c.Ecodigo
                    and a.Aid = #rsDatosInsert.Aid#
             </cfquery>

              <cfquery name="VerificaActividadEmpresarial" datasource="#Session.DSN#">
                select Pvalor
                from Parametros
                where Ecodigo = #Session.Ecodigo#
                  and Pcodigo = 2200
              </cfquery>

             <cfif len(trim(VerificaActividadEmpresarial.Pvalor)) GT 0 and VerificaActividadEmpresarial.Pvalor EQ "S">
                 <cfif isdefined('rsArtInfo') and len(trim(rsArtInfo.ComplementoActividad)) eq 0>
                    <cfthrow message="No se ha podido obtener la actividad Empresarial del articulo : #rsArtInfo.Adescripcion#">
                 </cfif>
                 <cfif isdefined('rsArtInfo') and len(trim(rsArtInfo.cuentac)) eq 0>
                    <cfthrow message="No se ha podido obtener el objeto de gasto de la clasificacion: #rsArtInfo.Cdescripcion#">
                 </cfif>

              	<cfset LvaCuentaGastoInv  = mascara.AplicarMascara(LvarCuentagastoInventario,rsArtInfo.cuentac,'?')>
                <cfset LvarCFformCtaGastoInv = mascara.AplicarMascara(LvaCuentaGastoInv,replace(rsArtInfo.ComplementoActividad,'-','',"ALL"),'_')>

                <cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" returnvariable="LvarError">
                    <cfinvokeargument name="Lprm_CFformato" 		value="#LvarCFformCtaGastoInv#"/>
                    <!---<cfinvokeargument name="Lprm_fecha" 			value="#now()#"/>--->
                    <cfinvokeargument name="Lprm_fecha" 			value="#rsDatosInsert.ETfecha#"/>
                    <cfinvokeargument name="Lprm_TransaccionActiva" value="yes"/>
                    <cfinvokeargument name="Lprm_Ecodigo" 			value="#arguments.Ecodigo#"/>
                </cfinvoke>
                <cfif LvarError EQ 'NEW' OR LvarError EQ 'OLD'>
                    <cfquery name="rsTraeCuenta" datasource="#session.DSN#">
                        select a.CFcuenta, a.Ccuenta, a.CFformato, a.CFdescripcion
                        from CFinanciera a
                            inner join CPVigencia b
                                 on a.CPVid     = b.CPVid
                                and <cf_dbfunction name="now"> between b.CPVdesde and b.CPVhasta
                        where a.Ecodigo   =  #arguments.Ecodigo#
                          and a.CFformato = '#LvarCFformCtaGastoInv#'
                    </cfquery>
                  <cfelse>
    				     	  <cfthrow message="#LvarError#">
    				      </cfif>
             </cfif>

          <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #Articulos1# (Ecodigo, Aid, linea, Alm_Aid, Ocodigo, Dcodigo, cant, costolinloc, costolinori, TC,Moneda, EcostoU, NC_EcostoU
        <cfif len(trim(VerificaActividadEmpresarial.Pvalor)) GT 0 and VerificaActividadEmpresarial.Pvalor EQ "S">
          , Ccuenta)
        <cfelse>
          )
        </cfif>
        values
        (
        #arguments.Ecodigo#,
        #rsDatosInsert.Aid#,
        #rsDatosInsert.DTlinea#,
        #rsDatosInsert.Alm_Aid#,
        #rsDatosInsert.Ocodigo#,
        #rsDatosInsert.Dcodigo#,
        #rsDatosInsert.cant#,
        #rsDatosInsert.costolinloc#,
        #rsDatosInsert.costolinori#,
        #rsDatosInsert.ETtc#,
        #rsDatosInsert.Mcodigo#,
        #rsDatosInsert.Ecostou#,
        #rsDatosInsert.NC_Ecostou#
        <cfif len(trim(VerificaActividadEmpresarial.Pvalor)) GT 0 and VerificaActividadEmpresarial.Pvalor EQ "S">
          ,
          #rsTraeCuenta.Ccuenta#
          )
        <cfelse>
          )
        </cfif>
        </cfquery>
    </cfloop>
    <cfreturn  Articulos1>
  </cffunction>


 <!---- Descuento x linea de la factura ----->
    <cffunction name="int_DescuentoLinea" output="no"  access="public" returntype="any">
        <cfargument name="ETdocumento"      type="string"   required="yes">
        <cfargument name="CCTcodigo"        type="string"   required="yes">
        <cfargument name="Monloc"           type="numeric"  required="yes">
        <cfargument name="MonedaDoc"        type="numeric"  required="yes">
        <cfargument name="AnulacionParcial" type="boolean"  required="yes">
        <cfargument name="Periodo"          type="numeric"  required="yes">
        <cfargument name="Mes"              type="numeric"  required="yes">
        <cfargument name="CuentaDesc"       type="numeric"  required="yes">
        <cfargument name="FCid"             type="numeric"  required="yes">
        <cfargument name="ETnumero"         type="numeric"  required="yes">
        <cfargument name="DTlinea"          type="numeric"  required="yes">
        <cfargument name="Ecodigo"          type="numeric"  required="yes">
        <cfargument name="INTARC"           type="string"  required="yes">
        <cfargument name="TBanulacion"      type="string"  required="yes">

        <cfquery name="rsInsert" datasource="#session.dsn#">
 	      insert #arguments.INTARC# (
                      INTORI, INTREL, INTDOC, INTREF,
                      INTMON, INTTIP, INTDES,INTFEC,
                      INTCAM, Periodo, Mes, Ccuenta,
                      Mcodigo, Ocodigo, INTMOE, INTllave1,
                      INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona,
                      INTidPersona)
             select 'FAFC', 1,'#arguments.ETdocumento#' #_Cat#  <cf_dbfunction name="to_char"	args="c.DTlinea"> ,'#arguments.CCTcodigo#',
              ((case when #arguments.Monloc# != #arguments.Monedadoc# then
                   round(c.DTdeslinea * a.ETtc,2) else c.DTdeslinea end) <cfif Arguments.AnulacionParcial> * Coalesce(tb.porcentaje,1) </cfif>),
              case when b.CCTtipo = 'D' then
			      <cfif arguments.AnulacionParcial eq true>'C' else 'D' <cfelse>'D' else 'C'</cfif>end,
              'Desc Linea: ' #_Cat# substring(coalesce(DTdescripcion, DTdescalterna),1,50),
            <cf_dbfunction name="to_char"	args="getdate(),112">, a.ETtc,
             #arguments.Periodo#, #arguments.Mes#, #arguments.CuentaDesc#, a.Mcodigo,c.Ocodigo,
             ((c.DTdeslinea)<cfif Arguments.AnulacionParcial> * Coalesce(tb.porcentaje,1) </cfif>),
            <cf_dbfunction name="to_char"	args="a.FCid">, <cf_dbfunction name="to_char" args="a.ETnumero">,
            c.DTdescripcion, '#arguments.ETdocumento#',case when a.CDCcodigo is not null then '03'
			else '01' end, case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
       from ETransacciones a
     inner join  CCTransacciones b
        on a.CCTcodigo = b.CCTcodigo
           and a.Ecodigo = b.Ecodigo
     inner join DTransacciones c
         on a.ETnumero = c.ETnumero
           and  a.FCid  = c.FCid
     <cfif Arguments.AnulacionParcial>
        left outer join #Arguments.TBanulacion# tb
            on c.DTlinea = tb.DTlinea
      </cfif>
          inner join SNegocios sn
            on a.SNcodigo = sn.SNcodigo
           and a.Ecodigo = sn.Ecodigo
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
             and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and c.DTdeslinea != 0.00 and c.DTborrado = 0
          and c.DTlinea = #arguments.DTlinea#
     <!---and a.ETtotal <> 0  --->
        </cfquery>
</cffunction>

<!---- Documento x Cobrar ----->
<cffunction name="Int_DocumentosCxC" output="no"  access="public" returntype="any">
        <cfargument name="ETdocumento"      type="string"   required="yes">
        <cfargument name="CCTcodigo"        type="string"   required="yes">
        <cfargument name="Monloc"           type="numeric"  required="yes">
        <cfargument name="MonedaDoc"        type="numeric"  required="yes">
        <cfargument name="AnulacionParcial" type="boolean"  required="yes">
        <cfargument name="TotalDetalles"    type="numeric">
        <cfargument name="INTDES"           type="string"   required="yes">
        <cfargument name="PagTarjetaTot"    type="numeric"  required="yes">
	    <cfargument name="PagTarjetaTotLoc" type="numeric"  required="yes">
        <cfargument name="Contado"          type="numeric"  required="yes">
        <cfargument name="Periodo"          type="numeric"  required="yes">
        <cfargument name="Mes"              type="numeric"  required="yes">
        <cfargument name="Cuentacaja"       type="numeric"  required="yes">
         <cfargument name="CFCuentacaja"    type="numeric" required="yes">
        <cfargument name="FCid"             type="numeric"  required="yes">
        <cfargument name="ETnumero"         type="numeric"  required="yes">
        <cfargument name="Ocodigo"          type="string"   required="yes">
        <cfargument name="Ecodigo"          type="numeric"  required="yes">
        <cfargument name="INTARC"           type="string"   required="yes">



       <cfquery name="_rsParaValidaciones" datasource="#session.dsn#">
         select sn.SNcuentacxc, coalesce(b.CCTvencim,0) as CCTvencim
         from ETransacciones a
          inner join CCTransacciones b
             on a.CCTcodigo = b.CCTcodigo and a.Ecodigo = b.Ecodigo
          inner join SNegocios sn
            on a.SNcodigo = sn.SNcodigo  and a.Ecodigo = sn.Ecodigo
          left outer join CuentasSocios d
            on a.CCTcodigo = d.CCTcodigo  and a.Ecodigo = d.Ecodigo  and a.SNcodigo = d.SNcodigo
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
             and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
       </cfquery>
    <cfif isdefined('_rsParaValidaciones') and _rsParaValidaciones.CCTvencim neq -1>
       <cfif not Len(Trim(_rsParaValidaciones.SNcuentacxc))>
        <cf_ErrorCode code="-1" msg="NO se ha definido una cuenta por cobrar para el socio de negocio">
       </cfif>
    </cfif>



         <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,
         INTllave1,INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona, INTidPersona)
        select 'FAFC',1,'#arguments.ETdocumento#','#arguments.CCTcodigo#',
             <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
               case when #arguments.Monloc# != #arguments.Monedadoc#
			      then round( (#arguments.TotalDetalles# -  #arguments.PagTarjetaTot#)  * a.ETtc,2)
			   else #arguments.TotalDetalles#  -  #arguments.PagTarjetaTot# end,
             <cfelse>
			 case when #arguments.Monloc# != #arguments.Monedadoc#
			      then round( (a.ETtotal-  #arguments.PagTarjetaTot#)  * a.ETtc,2)
		 	  else a.ETtotal -  #arguments.PagTarjetaTot# end,
			</cfif>
      <cfif Arguments.AnulacionParcial>
        case b.CCTtipo when 'C' then 'D'
                       when 'D' then 'C' end as CCttipo,
        <cfelse>
        b.CCTtipo,
      </cfif>
			case when #arguments.Contado# != 1
			  then '#arguments.INTDES# ' + sn.SNidentificacion
			else 'FA: Transacción de Contado ' #_Cat# '#arguments.CCTcodigo#' #_Cat#'-'#_Cat# '#arguments.ETdocumento#' end,
            <cf_dbfunction name="to_char"	args="getdate(),112">,
			a.ETtc,
			#arguments.Periodo#,#arguments.Mes#,
            case when #arguments.Contado# != 1 then
                 sn.SNcuentacxc
              else
                 #arguments.Cuentacaja#
               end,
             a.Mcodigo,#arguments.Ocodigo#,
            <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
               #arguments.TotalDetalles# -  #arguments.PagTarjetaTot#,
			<cfelse>
			   a.ETtotal -  #arguments.PagTarjetaTot#,
			</cfif>
			<cf_dbfunction name="to_char"	args="a.FCid">,
			<cf_dbfunction name="to_char"	args="a.ETnumero">,
             case when #arguments.Contado# != 1
			  then '#arguments.INTDES# ' + sn.SNidentificacion
			 else 'FA: Transaccion de Contado ' #_Cat# '#arguments.CCTcodigo#' #_Cat#'-'#_Cat# '#arguments.ETdocumento#' end,
            '#arguments.ETdocumento#',
			case when a.CDCcodigo is not null then '03' else '01' end,
			case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
        from ETransacciones a
          inner join CCTransacciones b
             on a.CCTcodigo = b.CCTcodigo and a.Ecodigo = b.Ecodigo
          inner join SNegocios sn
            on a.SNcodigo = sn.SNcodigo  and a.Ecodigo = sn.Ecodigo
          left outer join CuentasSocios d
            on a.CCTcodigo = d.CCTcodigo  and a.Ecodigo = d.Ecodigo  and a.SNcodigo = d.SNcodigo
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
             and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.ETtotal != 0 and a.ETtotal -  #arguments.PagTarjetaTot#  != 0
        </cfquery>

</cffunction>
<!----Consultas varias a ETransacciones ----->
       <cffunction name="consultarVencim" output="no"  access="public" returntype="query">
        <cfargument name="FCid"      			type="numeric" required="yes">
        <cfargument name="ETnumero"      		type="numeric" required="yes">
        <cfargument name="Ecodigo"      		type="numeric" required="yes">
            <cfquery name="rsCCTvencim" datasource="#session.dsn#">
                select coalesce(c.CCTvencim,0) as CCTvencim
                from ETransacciones a, CCTransacciones c
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and a.Ecodigo = c.Ecodigo
                  and a.CCTcodigo = c.CCTcodigo
                </cfquery>
         <cfreturn rsCCTvencim>
   	   </cffunction>
       <cffunction name="insertaEncabezadoDoc" output="no"  access="public" returntype="any">
        <cfargument name="FCid"      			type="numeric" required="yes">
        <cfargument name="ETnumero"      		type="numeric" required="yes">
        <cfargument name="Ecodigo"      		type="numeric" required="yes">
        <cfargument name="CCTcodigo"      		type="string"  required="yes">
        <cfargument name="ETdocumento"     		type="string"  required="yes">
        <cfargument name="AnulacionParcial"     type="boolean" required="yes" default="false">
        <cfargument name="TotalDetalles"     	type="numeric"  required="yes" default="0">
        <cfargument name="Anulacion"     		type="boolean"  required="yes" default="false">
        <cfargument name="Vencimiento"       	type="numeric"  required="yes">
        <cfargument name="Contado"       	    type="numeric"  required="yes">
        <cfargument name="Cuentacaja"       	type="numeric"  required="yes">
        <cfargument name="usuario"       	    type="numeric"  required="yes">
        <cfargument name="Retencion"       	    type="numeric"  required="yes">
        <cfargument name="id_direccion"       	type="numeric"  required="yes">
            <cfquery name="rsInsert" datasource="#session.dsn#">
            insert Documentos (FCid, CFid, ETnumero, Ecodigo, CCTcodigo,Ddocumento,  Ocodigo,  SNcodigo, Mcodigo, Dtipocambio, Dtotal, Dsaldo, Dfecha, Dvencimiento,
                Ccuenta, Dtcultrev, Dusuario, Rcodigo, Dmontoretori, Dtref, Ddocref, DEdiasVencimiento, DEdiasMoratorio, TESDPaprobadoPendiente, EDtipocambioVal, EDtipocambioFecha,
                id_direccionFact, ETnombreDoc,DEobservacion,CDCcodigo )
            select a.FCid, a.CFid,a.ETnumero, a.Ecodigo,'#arguments.CCTcodigo#','#arguments.ETdocumento#',a.Ocodigo, a.SNcodigo, a.Mcodigo, a.ETtc, <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                #arguments.TotalDetalles#,<cfelse> a.ETtotal, </cfif>	<cfif not Arguments.Anulacion> a.ETtotal <cfelse> 0.00 </cfif>, a.ETfecha, dateadd(dd, #arguments.Vencimiento#, a.ETfecha),
                case when #arguments.Contado# = 1 then #arguments.Cuentacaja# else coalesce(c.Ccuenta,a.Ccuenta) end, a.ETtc, '#Arguments.usuario#', null, #arguments.Retencion#, null, null, 0, 0, 0, a.ETtc,<cf_dbfunction name="now">,
                #arguments.id_direccion#, a.ETnombredoc, a.ETobs,a.CDCcodigo
               from ETransacciones a
                     inner join CCTransacciones b
                        on a.Ecodigo = b.Ecodigo and a.CCTcodigo = b.CCTcodigo Left outer join  CuentasSocios c
                        on  a.Ecodigo = c.Ecodigo and a.SNcodigo = c.SNcodigo and a.CCTcodigo = c.CCTcodigo
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                 and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            </cfquery>
         <cfreturn true>
   	   </cffunction>
      <cffunction name="insertaDetalleDoc" output="no"  access="public" returntype="any">
        <cfargument name="FCid"      			    type="numeric" required="yes">
        <cfargument name="ETnumero"      		    type="numeric" required="yes">
        <cfargument name="Ecodigo"      	        type="numeric" required="yes">
        <cfargument name="CCTcodigo"      	        type="string"  required="yes">
        <cfargument name="ETdocumento"     		    type="string"  required="yes">
        <cfargument name="TienePagos"     		    type="boolean"  required="yes">
        <cfargument name="CuentaTransitoriaGeneral" type="numeric"  required="yes">

       <cfquery name="rsInsert" datasource="#session.dsn#">
       insert DDocumentos ( Ecodigo,  CCTcodigo, Ddocumento, CCTRcodigo,  DRdocumento, DDlinea,  DDtotal, DDcodartcon, DDcantidad, DDpreciou, DDcostolin, DDdesclinea, DDtipo,DDescripcion,DDdescalterna,
        Alm_Aid, Dcodigo, Ccuenta, CFid, Ocodigo, DcuentaT, DesTransitoria)
    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,'#Arguments.CCTcodigo#','#Arguments.ETdocumento#','#Arguments.CCTcodigo#','#Arguments.ETdocumento#',b.DTlinea,
        b.DTtotal, case when b.Aid is null then b.Cid else b.Aid end, b.DTcant, b.DTpreciou, 0.00, b.DTdeslinea, b.DTtipo, b.DTdescripcion,b.DTdescalterna, b.Alm_Aid,
        b.Dcodigo, b.Ccuenta, b.CFid, b.Ocodigo, <cfif Arguments.TienePagos>null,0 <cfelse> case when cf.CFACTransitoria = 1 then coalesce(cf.CFcuentatransitoria,#Arguments.CuentaTransitoriaGeneral#) else null end, cf.CFACTransitoria
        </cfif>
    from ETransacciones a, DTransacciones b, CFuncional cf
    where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
    and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
      and a.FCid = b.FCid and a.ETnumero = b.ETnumero  and a.Ecodigo = b.Ecodigo  and b.CFid = cf.CFid and b.Ecodigo = cf.Ecodigo and b.DTborrado = 0
     </cfquery>
      <cfreturn true>
    </cffunction>
      <cffunction name="insertaDHDDoc" output="no"  access="public" returntype="any">
        <cfargument name="HDid"      			    type="numeric" required="yes">
        <cfargument name="Ecodigo"      	        type="numeric" required="yes">
        <cfargument name="CCTcodigo"      	        type="string"  required="yes">
        <cfargument name="ETdocumento"     		    type="string"  required="yes">
        <cfargument name="CC_calculoLin"     	    type="string"  required="yes">

        <cfquery name="rsSQL" datasource="#session.dsn#">
	        insert into HDDocumentos (HDid,Ecodigo, CCTcodigo,Ddocumento, CCTRcodigo, DRdocumento, DDlinea, DDtotal, DDcodartcon, DDcantidad, DDpreciou,
						DDcostolin,	DDdesclinea,DDtipo,	DDescripcion,DDdescalterna,	Alm_Aid,Dcodigo,Ccuenta,CFid,Icodigo,OCid, OCTid, OCIid,
						DDid,DocrefIM,CCTcodigoIM,cantdiasmora,ContractNo,DDimpuesto,DDdescdoc,Ocodigo,DcuentaT,DesTransitoria,CFComplemento
					)select  #Arguments.HDid#,	Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, DDlinea, DDtotal, DDcodartcon, DDcantidad,
						DDpreciou,  DDcostolin,	DDdesclinea,DDtipo,DDescripcion,DDdescalterna,Alm_Aid,Dcodigo,Ccuenta,CFid,	Icodigo,
						OCid, OCTid, OCIid,	DDid,DocrefIM,CCTcodigoIM,cantdiasmora,ContractNo,
						coalesce((select sum(impuesto) from #Arguments.CC_calculoLin# where DDid	= d.DDid),0.00),
						coalesce((select sum(descuentoDoc) from #Arguments.CC_calculoLin# where DDid	= d.DDid),0.00)
                        ,Ocodigo,DcuentaT,DesTransitoria,CFComplemento from DDocumentos d
				 where Ecodigo = #Arguments.Ecodigo# and CCTcodigo	= '#Arguments.CCTcodigo#' and Ddocumento	= '#Arguments.ETdocumento#'
       	</cfquery>
      <cfreturn true>
    </cffunction>

        <cffunction name="CFinanciera" output="no"  access="public" returntype="query">
        <cfargument name="Ecodigo"        	type="numeric" required="yes">
        <cfargument name="CFformato"      	type="string"  required="no">
        <cfargument name="CFcuenta"      	type="string"  required="no">

          <cfquery name="rsCFinanciera" datasource="#session.dsn#">
                    select Ccuenta, coalesce(CFcuenta,0) as CFcuenta, CFformato
                    from CFinanciera
                    where Ecodigo    = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Ecodigo#">
                    <cfif isdefined('Arguments.CFformato') and len(trim(Arguments.CFformato)) gt 0>
                       and CFformato = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CFformato#">
                    </cfif>
                    <cfif isdefined('Arguments.CFcuenta') and len(trim(Arguments.CFcuenta)) gt 0 and Arguments.CFcuenta neq -1>
                       and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.CFcuenta#">
                    </cfif>
                </cfquery>
          <cfreturn rsCFinanciera>
   	   </cffunction>
       <cffunction name="SNvenventas" output="no"  access="public" returntype="query">
        <cfargument name="FCid"      			type="numeric" required="yes">
        <cfargument name="ETnumero"      		type="numeric" required="yes">
        <cfargument name="Ecodigo"      		type="numeric" required="yes">
              <cfquery name="rsSNvenventas" datasource="#session.dsn#">
                select coalesce(SNvenventas,0) as SNvenventas, a.SNcodigo
                from ETransacciones a, SNegocios b
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and a.Ecodigo = b.Ecodigo and a.SNcodigo = b.SNcodigo
                </cfquery>
          <cfreturn rsSNvenventas>
   	   </cffunction>
       <cffunction name="FPagos1" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="CCTcodigo"      		type="string"  required="yes">
         <cfargument name="Pcodigo"      		type="string"  required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">

           <cfquery name="rsFPagos1" datasource="#Session.DSN#">
            select FPlinea, FCid, CCTcodigo,Pcodigo, m.Mnombre,m.Mcodigo, m.Msimbolo, m.Miso4217 , FPtc, FPmontoori, FPmontolocal, FPfechapago, Tipo,
              (FPtc * FPmontoori) as PagoDoc, case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' when 'A' then 'Documento' end as Tipodesc,
                FPdocnumero, FPdocfecha, FPBanco, FPCuenta, FPtipotarjeta
            from PFPagos f
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and f.CCTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
            and f.Pcodigo=<cfqueryparam  cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
            and FPagoDoc <> 0
           </cfquery>
       <cfreturn rsFPagos1>
   	 </cffunction>
    <cffunction name="consultaFPagos" output="no"  access="public" returntype="query">
     <cfargument name="TotalDetalles"    	type="numeric" required="yes">
     <cfargument name="documento"     		type="string"  required="yes">
     <cfargument name="FCid"      			type="numeric" required="yes">
     <cfargument name="ETnumero"      		type="numeric" required="yes">
     <cfargument name="Ecodigo"      		type="numeric" required="yes">
     <cfargument name="AnulacionParcial"	type="boolean" required="yes" default="false">
         <cfquery name="rsFPagos" datasource="#Session.DSN#">
            select FPlinea, FCid, ETnumero, m.Mnombre,m.Mcodigo, m.Msimbolo, m.Miso4217,
             <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
             FPtc, #arguments.TotalDetalles#, #arguments.TotalDetalles# * FPtc, FPfechapago, Tipo,(#arguments.TotalDetalles#/FPtc) as PagoDoc,
             <cfelse>
             FPtc, FPmontoori,FPmontolocal,FPfechapago, Tipo, (FPmontoori) as PagoDoc,
             </cfif>
                case Tipo when 'D' then FPdocnumero when 'E' then 'EF:'#_Cat# '#arguments.documento#' when 'A' then FPdocnumero when 'T' then FPautorizacion when 'C' then FPdocnumero end as docNumero,
                case Tipo when 'E' then 'Efectivo' when 'T' then 'Tarjeta' when 'C' then 'Cheque' when 'D' then 'Deposito' when 'A' then 'Documento' end as Tipodesc,
                rtrim(coalesce(FPdocnumero,'No')) as FPdocnumero, FPdocfecha, coalesce(FPBanco,0) as FPBanco, FPCuenta,
                FPtipotarjeta, FPautorizacion
            from FPagos f, Monedas m
            where f.Mcodigo = m.Mcodigo
            and FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETnumero#">
            and FPagoDoc <> 0
        </cfquery>
      <cfreturn rsFPagos>
   	 </cffunction>

     <cffunction name="FPagosTotales" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">

         <cfquery name="rsFPagosTotales" datasource="#Session.DSN#">
            select coalesce(sum(FPmontolocal),0.00) as PagoTotalLoc, coalesce(sum(FPmontoori),0.00) as PagoTotalOri
            from FPagos f
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            where Tipo = 'T' and FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and f.ETnumero=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and m.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
          </cfquery>
       <cfreturn rsFPagosTotales>
   	 </cffunction>
       <cffunction name="consultaDescLinea" output="no"  access="public" returntype="query">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="AnulacionParcial"   	type="boolean" required="yes">
         <cfargument name="LineasDetalle"      	type="string" required="yes">
           <cfquery name="rsDescLinea" datasource="#session.dsn#">
                select c.CFid, c.DTlinea  from ETransacciones a
                   inner join  CCTransacciones b  on a.CCTcodigo = b.CCTcodigo  and a.Ecodigo = b.Ecodigo
                  inner join DTransacciones c  on a.ETnumero = c.ETnumero  and  a.FCid  = c.FCid
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                 and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and c.DTdeslinea != 0.00  and c.DTborrado = 0
                  <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>and c.DTlinea in (#arguments.LineasDetalle#)</cfif>
			   </cfquery>
     <cfreturn rsDescLinea>
   	 </cffunction>
     <cffunction name="Rel" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">

       <cfquery name="rsRel" datasource="#session.dsn#">
            select a.CCTcodigo, a.ETmontodes
            from ETransacciones a
                inner join CCTransacciones b
                 on a.CCTcodigo = b.CCTcodigo  and a.Ecodigo = b.Ecodigo
               left outer join CuentasSocios c
                 on  a.Ecodigo = c.Ecodigo and a.SNcodigo = c.SNcodigo and a.CCTcodigo = c.CCTcodigo
            where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
              and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
           </cfquery>
       <cfreturn rsRel>
   	 </cffunction>

     <cffunction name="TransDesc" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">

         <cfquery name="rsTransDesc" datasource="#session.dsn#">
            select 1 from ETransacciones a, CCTransacciones b
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                  and a.Ecodigo = b.Ecodigo  and a.CCTcodigo = b.CCTcodigo and a.ETmontodes != 0
            </cfquery>
            <cfreturn rsTransDesc>
      </cffunction>

      <cffunction name="ETcuenta" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">

        <cfquery name="rsETcuenta" datasource="#session.dsn#">
        select a.CFid from ETransacciones a, CCTransacciones b
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.Ecodigo = b.Ecodigo and a.CCTcodigo = b.CCTcodigo  and a.ETmontodes != 0.00
        </cfquery>
       <cfreturn rsETcuenta>
      </cffunction>
      <cffunction name="Caja" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">

         <cfquery name="rsCaja" datasource="#session.dsn#">
            select a.FCdesc from FCajas a
            where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
              and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
        </cfquery>
        <cfreturn rsCaja>
      </cffunction>
      <cffunction name="DatosSocio" output="no"  access="public" returntype="query">
      <cfargument name="SNid"      			type="numeric" >
      <cfargument name="Ecodigo"      		type="numeric" default="#session.Ecodigo#" >
      <cfargument name="SNcodigo"      		type="string" >

         <cfquery name="rsSocio" datasource="#session.dsn#">
            select SNid, SNcodigo, SNnombre from SNegocios
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
              <cfif isdefined('arguments.SNid') and len(trim(#arguments.SNid#)) gt 0>
               and SNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.SNid#">
             </cfif>
             <cfif isdefined('arguments.SNcodigo') and len(trim(#arguments.SNcodigo#)) gt 0>
              and SNcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.SNcodigo#">
            </cfif>
        </cfquery>
        <cfreturn rsSocio>
      </cffunction>
      <cffunction name="CxPsocio"  output="no"  access="public" returntype="any">
       <cfargument name="ETdocumento" 			type="string" required="yes">
       <cfargument name="CCTcodigo"      		type="string" required="yes">
       <cfargument name="Monloc"      		    type="numeric" required="yes">
       <cfargument name="Mcodigo"      		    type="numeric" required="yes">
       <cfargument name="FPmontoori"      	    type="numeric" required="yes">
       <cfargument name="FATporccom"      	    type="numeric" required="yes">
       <cfargument name="FPtc"      	        type="numeric" required="yes">
       <cfargument name="CCTtipo"      	        type="string"  required="yes">
       <cfargument name="Anulacion"   	        type="boolean" required="yes">
       <cfargument name='AnulacionParcial'      type='boolean' required="no" default="false">
       <cfargument name="FATdescripcion"   	    type="string"  required="yes">
       <cfargument name="Periodo"   	        type="numeric" required="yes">
       <cfargument name="mes"            	    type="numeric" required="yes">
       <cfargument name="CFcuentaComision"      type="numeric" required="yes">
       <cfargument name="CFcuentaCobro"         type="numeric" required="yes">
       <cfargument name="Cuentacaja"            type="numeric" required="yes">
       <cfargument name="CFCuentacaja"          type="numeric" required="yes">
       <cfargument name="Ocodigo"               type="string"  required="yes">
       <cfargument name="INTARC"                type="string" required="yes">
       <cfargument name="FATaplicamontos"       type="numeric" required="yes">
       <cfargument name="Comision"              type="numeric" required="yes" default="-1">

       <cfset GeneraCxP = true>
       <cfif arguments.AnulacionParcial eq true>
         <cfset GeneraCxP = false>
       </cfif>
       <cfif arguments.Anulacion eq true >
        <cfset GeneraCxP = false>
       </cfif>

       <cfif GeneraCxP eq true >
         <cfquery name="rs" datasource="#session.dsn#">
           insert #arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE)
           values
           (  'FAFC',   1, '#arguments.ETdocumento#', '#arguments.CCTcodigo#',

           case when (#arguments.FATaplicamontos# = 1) then
              round((#arguments.Comision#)* (#arguments.FPtc#),2)
           else
            case when #arguments.Monloc# != #arguments.Mcodigo#
               then  round(#arguments.FPmontoori# * #arguments.FATporccom# /100.00,2)* #arguments.FPtc#
             else
               (round(#arguments.FPmontoori# * #arguments.FATporccom#/100.00,2))
             end
           end,
            case when '#arguments.CCTtipo#' = 'C' then 'D' else 'C' end,
            '<cfif Arguments.Anulacion>Reversion </cfif>CxP (al socio):' #_Cat# '#arguments.FATdescripcion#',
            <cf_dbfunction name="to_char"	args="getdate(),112">,
            case when #arguments.Monloc# != #arguments.Mcodigo# then #arguments.FPtc# else 1.00 end,
            #arguments.Periodo#, #arguments.Mes#,
            <cfif not Arguments.Anulacion> 0,#arguments.CFcuentaCobro# <cfelse> #arguments.Cuentacaja#,#arguments.CFCuentacaja# </cfif>,
            #arguments.Mcodigo#, #arguments.Ocodigo#,
           case when (#arguments.FATaplicamontos# = 1) then
              round((#arguments.Comision#),2)
           else
            round(#arguments.FPmontoori# * #arguments.FATporccom#/100.00,2)
           end)
           </cfquery>
          <!-----<cfquery name="rsComSoc" datasource="#session.dsn#">
           select
             case when #arguments.Monloc# != #arguments.Mcodigo# then  round(#arguments.FPmontoori# * #arguments.FATporccom# /100.00,2)* #arguments.FPtc#
             else (round(#arguments.FPmontoori# * #arguments.FATporccom#/100.00,2))
             end as ComSocLoc,
            round(#arguments.FPmontoori# * #arguments.FATporccom#/100.00,2) as ComSocE
            from dual
           </cfquery>  ------>
           <cfquery name="rsComSoc" datasource="#session.dsn#">
           select
             case when (#arguments.FATaplicamontos# = 1) then
              round((#arguments.Comision#)* (#arguments.FPtc#),2)
           else
            case when #arguments.Monloc# != #arguments.Mcodigo#
               then  round(#arguments.FPmontoori# * #arguments.FATporccom# /100.00,2)* #arguments.FPtc#
             else
               (round(#arguments.FPmontoori# * #arguments.FATporccom#/100.00,2))
             end
           end as ComSocLoc,
            case when (#arguments.FATaplicamontos# = 1) then
              round((#arguments.Comision#),2)
           else
            round(#arguments.FPmontoori# * #arguments.FATporccom#/100.00,2)
           end as ComSocE
            from dual
           </cfquery>
          <cfelse>
            <cfquery name="rsComSoc" datasource="#session.dsn#">
           select
             0 as ComSocLoc,
            0 as ComSocE
            from dual
           </cfquery>
          </cfif>
          <cfreturn rsComSoc>
     </cffunction>
     <cffunction name="TarjetaCompuesta" output="no"  access="public" returntype="query">
       <cfargument name="FCid"      			type="numeric" required="yes">
       <cfargument name="ETnumero"      		type="numeric" required="no">
       <cfargument name="CCTcodigo"      		type="string"  required="no">
       <cfargument name="Pcodigo"        		type="string"  required="no">

      <cfquery name="rsTJCompuesta" datasource="#Session.DSN#">
            select  j.FATcompuesta, j.FATid, FPlinea
            <cfif isdefined('arguments.ETnumero') and len(trim(arguments.ETnumero))  gt 0>
               from FPagos f
            <cfelse>
              from PFPagos f
            </cfif>
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
            inner join FATarjetas j
               on <cf_dbfunction name="to_number"		args="f.FPtipotarjeta"> = j.FATid
            where f.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            <cfif isdefined('arguments.ETnumero') and len(trim(arguments.ETnumero))  gt 0>
             and f.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            <cfelse>
             and f.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
              and f.Pcodigo  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
            </cfif>
             and m.Ecodigo = #session.Ecodigo#
             and Tipo =  'T'
         </cfquery>
      <cfreturn rsTJCompuesta>
      </cffunction>
     <cffunction name="PagosTarjeta" output="no"  access="public" returntype="query">
       <cfargument name="FCid"      			type="numeric" required="yes">
       <cfargument name="ETnumero"      		type="numeric" required="no">
       <cfargument name="CCTcodigo"      		type="string"  required="no">
       <cfargument name="Pcodigo"      		    type="string"  required="no">
       <cfargument name="TotalDetalles"      	type="numeric" required="yes">
       <cfargument name="TJCompuesta"      	    type="boolean" required="yes" default="false">
       <cfargument name="AnulacionParcial"      type="boolean" required="false" default="false">
       <cfargument name="CC"                    type="numeric" required="false">
       <cfargument name="FATid"      	    	type="numeric" required="yes">
       <cfargument name="FPlinea"      	    	type="numeric" required="yes">


      <cfquery name="rsFPagosTJ" datasource="#Session.DSN#">
            select FPlinea, FCid,
            <cfif not isdefined('Arguments.CC') > ETnumero,</cfif> m.Mnombre, m.Mcodigo, m.Msimbolo, m.Miso4217 , FPtc,
                 <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                <!--- #Arguments.TotalDetalles# / FPtc as FPmontoori, --->
                FPmontoori,
                 #Arguments.TotalDetalles# as FPmontolocal, FPfechapago, Tipo,
                 (FPtc * #Arguments.TotalDetalles#) as PagoDoc,
                 <cfelse>
                 FPmontoori, FPmontolocal, FPfechapago, Tipo, (FPtc * FPmontoori) as PagoDoc,
                </cfif>
                FPdocnumero, FPdocfecha, FPBanco, FPCuenta, j.FATid, FPtipotarjeta, FATcomplemento,
                coalesce(CFcuentaComision,-1) as CFcuentaComision,CFcuentaCobro, FPtipotarjeta,FATdescripcion,
                FATporccom,FATcxpsocio, SNcodigo, FATmontomin,FATmontomax,FATaplicamontos,FATNOsumaComision,FATCFtarjeta,FATCtaCobrotarjeta
               <cfif Arguments.TJCompuesta eq true>
               ,tj.FATidDcxc
               <cfelse>
              , -1 as FATidDcxc
               </cfif>
               ,(FPagoDoc / FPfactorConv) as pagoLoc
               ,FPagoDoc as pagoOri
            <cfif isdefined('Arguments.CC') and Arguments.CC eq 1>
              from PFPagos f
            <cfelse>
              from FPagos f
            </cfif>
            inner join Monedas m
             on f.Mcodigo = m.Mcodigo
           <cfif Arguments.TJCompuesta eq false>
            inner join FATarjetas j
               on <cf_dbfunction name="to_number"	args="f.FPtipotarjeta"> = j.FATid
           <cfelse>
           inner join FATarjetaCompuesta tj
              on <cf_dbfunction name="to_number"	args="f.FPtipotarjeta"> = tj.FATid
            inner join FATarjetas j
               on j.FATid = tj.FATidD
           </cfif>
            where f.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            <cfif isdefined('Arguments.ETnumero') and len(trim(#Arguments.ETnumero#)) gt 0>
               and f.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
             </cfif>
              <cfif isdefined('Arguments.CC') and Arguments.CC eq 1>
                and f.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                and f.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
              </cfif>
             and m.Ecodigo = #session.Ecodigo# and Tipo =  'T'
          <cfif Arguments.TJCompuesta eq false>
             and j.FATid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FATid#">
          <cfelse>
             and tj.FATid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FATid#">
          </cfif>
          and FPlinea =   <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FPlinea#">
          <cfif Arguments.AnulacionParcial>
              and FatPorcCom <> 0.00   <!----Para anulación Parcial se incluyen sólo las comiciones de tarjetas asociadas al emisor----->
          </cfif>
      </cfquery>
       <cfreturn rsFPagosTJ>
      </cffunction>

      <cffunction name="MontoComisionLoc" output="no"  access="public" returntype="query">
       <cfargument name="MonLoc"     type="numeric" required="yes">
       <cfargument name="FPmontoori" type="numeric"   required="yes">
       <cfargument name="Mcodigo"    type="numeric"   required="yes">
       <cfargument name="FATporccom" type="numeric"   required="yes">
       <cfargument name="FPtc"       type="numeric"   required="yes">

          <cfquery name="rsMontoComisLoc" datasource="#session.dsn#">
            select  case when #arguments.Monloc# != #arguments.Mcodigo# then
                round(#arguments.FPmontoori# - round(#arguments.FPmontoori#*#arguments.FATporccom#/100.00,2),2)*	(case when #arguments.Monloc# != #arguments.Mcodigo# then #arguments.FPtc# else 1.00 end)
               else ((#arguments.FPmontoori#) -round(#arguments.FPmontoori#*#arguments.FATporccom#/100.00,2)) end as MontoComision from Dual
         </cfquery>
        <cfreturn rsMontoComisLoc>
      </cffunction>
      <cffunction name="MontoComisionE" output="no"  access="public" returntype="query">
       <cfargument name="FPmontoori" type="numeric"   required="yes">
       <cfargument name="FATporccom" type="numeric"   required="yes">
         <cfquery name="rsMontoComisE" datasource="#session.dsn#">
            select #arguments.FPmontoori#-round(#arguments.FPmontoori#*#arguments.FATporccom#/100.00,2) as MontoComision from Dual
         </cfquery>
        <cfreturn rsMontoComisE>
      </cffunction>


      <cffunction name="DEStransitoria" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">

         <cfquery name="rsDEStransitoria" datasource="#session.dsn#">
		       select case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  b.CFACTransitoria = 1 then 1 else 0 end as code
			    			 from CFuncional b, CCTransacciones c, ETransacciones d, DTransacciones f
			    			 where f.CFid = b.CFid and b.CFcuentatransitoria <> 0 and f.DTtipo = 'S' 	and d.Ecodigo = c.Ecodigo and d.CCTcodigo = c.CCTcodigo
			    			 	and f.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
			    			 	and f.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
			    			 	and f.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			    			 	and f.FCid = d.FCid	and f.ETnumero = d.ETnumero	and f.Ecodigo = d.Ecodigo
		   </cfquery>
      <cfreturn rsDEStransitoria>
      </cffunction>
       <cffunction name="insertaHDocumentos" output="no"  access="public" returntype="any">
         <cfargument name="Ecodigo"      		type="numeric" required="yes" default="#session.dsn#">
         <cfargument name="CCTcodigo"      		type="numeric" required="yes">
         <cfargument name="Ddocumento"     		type="string"  required="yes">
   		<cfquery name="rsInserta" datasource="#session.dsn#">
         insert Documentos(Ecodigo, CCTcodigo ,Ddocumento ,Ocodigo ,SNcodigo ,Mcodigo ,Ccuenta ,Rcodigo
                ,Icodigo ,Dtipocambio ,Dtotal ,Dsaldo ,Dfecha ,Dvencimiento ,DfechaAplicacion ,Dtcultrev ,Dusuario
                ,Dtref ,Ddocref ,Dmontoretori ,Dretporigen ,Dreferencia ,DEidVendedor ,DEidCobrador ,id_direccionFact
                ,id_direccionEnvio ,CFid ,DEdiasVencimiento ,DEordenCompra ,DEnumReclamo ,DEobservacion ,DEdiasMoratorio
                ,BMUsucodigo ,TESDPaprobadoPendiente ,EDtipocambioFecha ,EDtipocambioVal ,EDid ,CDCcodigo
                ,TESRPTCid ,TESRPTCietu ,FCid ,ETnumero ,ETnombreDoc,SNcodigoAgencia,DfechaExpedido)
                select Ecodigo, CCTcodigo ,Ddocumento ,Ocodigo ,SNcodigo ,Mcodigo ,Ccuenta ,Rcodigo
                ,Icodigo ,Dtipocambio ,Dtotal ,Dsaldo ,Dfecha ,Dvencimiento ,DfechaAplicacion ,Dtcultrev ,Dusuario
                ,Dtref ,Ddocref ,Dmontoretori ,Dretporigen ,Dreferencia ,DEidVendedor ,DEidCobrador ,id_direccionFact
                ,id_direccionEnvio ,CFid ,DEdiasVencimiento ,DEordenCompra ,DEnumReclamo ,DEobservacion ,DEdiasMoratorio
                ,BMUsucodigo ,0.00  as TESDPaprobadoPendiente ,EDtipocambioFecha ,EDtipocambioVal ,EDid ,CDCcodigo
                ,TESRPTCid ,TESRPTCietu ,FCid ,ETnumero ,ETnombreDoc,SNcodigoAgencia,DfechaExpedido
                from HDocumentos
                where	CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
                and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.FPdocnumero#">
				and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
		</cfquery>
       <cfreturn true>
      </cffunction>

       <cffunction name="TipoTrans" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">
           <cfquery name="rsTipoTrans" datasource="#session.dsn#">
               select case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  b.CFACTransitoria = 1  then b.CFcuentatransitoria else NULL  end as cuenta
             from CFuncional b, CCTransacciones c, ETransacciones d, DTransacciones e
             where e.CFid = b.CFid and b.CFcuentatransitoria <> 0 and e.DTtipo = 'S' and d.Ecodigo = c.Ecodigo and d.CCTcodigo = c.CCTcodigo
                and e.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and e.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and e.FCid = d.FCid and e.ETnumero = d.ETnumero               and e.Ecodigo = d.Ecodigo
               </cfquery>
       <cfreturn rsTipoTrans>
      </cffunction>

       <cffunction name="CantEx" output="no"  access="public" returntype="query">
         <cfargument name="FCid"      			type="numeric" required="yes">
         <cfargument name="ETnumero"      		type="numeric" required="yes">
         <cfargument name="Ecodigo"      		type="numeric" required="yes">

		   <cfquery name="rsCantEx" datasource="#session.dsn#">
		   select 1 as cantidad from CFuncional b, CCTransacciones c, ETransacciones d, DTransacciones e
             where e.CFid = b.CFid  and b.CFcuentatransitoria <> 0 and e.DTtipo = 'S' and d.Ecodigo = c.Ecodigo
                and d.CCTcodigo = c.CCTcodigo  and e.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                and e.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                and e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
                and e.FCid = d.FCid and e.ETnumero = d.ETnumero and e.Ecodigo = d.Ecodigo
		   </cfquery>
      <cfreturn rsCantEx>
      </cffunction>
       <cffunction name="consLineasAnul" output="no"  access="public" returntype="string">
            <cfargument name="FCid"      			type="numeric" required="yes">
            <cfargument name="ETnumero"      		type="numeric" required="yes">
            <cfargument name="Ecodigo"      		type="numeric" required="yes">
              <cfquery name="rdLineasAnuladas" datasource="#session.dsn#">
                select count(1) as consec  from ETransacciones a inner join DTransacciones b
                    on a.ETnumero = b.ETnumero and a.FCid = b.FCid
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                  and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and b.DTestado = 'A'
              </cfquery>
         <cfreturn rdLineasAnuladas.consec>
   	   </cffunction>
      <cffunction name="CreaTablas" access="public" returntype="any" output="no">
		<cfargument name="Conexion" type="string" required="yes">
		<cf_dbtemp name="CC_impLin1" returnvariable="CC_impLinea" datasource="#session.dsn#">
			<cf_dbtempcol name="FCid"            	type="numeric"  mandatory="yes">
			<cf_dbtempcol name="ETnumero"    		type="numeric"  mandatory="yes">
            <cf_dbtempcol name="DDid"    	     	type="numeric"  mandatory="no">
            <cf_dbtempcol name="DTlinea"    		type="numeric"  mandatory="yes">
            <cf_dbtempcol name="ccuenta"   			type="numeric"  mandatory="yes">
			<cf_dbtempcol name="ecodigo"    		type="integer"  mandatory="yes">
			<cf_dbtempcol name="icodigo"    		type="char(5)"  mandatory="yes">
			<cf_dbtempcol name="dicodigo"    		type="char(5)"  mandatory="yes">
			<cf_dbtempcol name="descripcion"   		type="varchar(100)"  mandatory="yes">
			<cf_dbtempcol name="montoBase"   	 	type="money"  	mandatory="no">
			<cf_dbtempcol name="porcentaje"    		type="float"  	mandatory="no">
			<cf_dbtempcol name="impuesto"    		type="money"  	mandatory="no">
			<cf_dbtempcol name="icompuesto"    		type="integer"  mandatory="no">
			<cf_dbtempcol name="ajuste"    			type="money"  	mandatory="no">
            <cf_dbtempcol name="descuentoDoc"    	type="money"  	mandatory="yes">
		</cf_dbtemp>
		<cf_dbtemp name="CC_calLin1" returnvariable="CC_calculoLin" datasource="#session.dsn#">
			<cf_dbtempcol name="FCid"            	type="numeric"  mandatory="yes">
			<cf_dbtempcol name="ETnumero"    		type="numeric"  mandatory="yes">
            <cf_dbtempcol name="DDid"    	     	type="numeric"  mandatory="no">
            <cf_dbtempcol name="DTlinea"    		type="numeric"  mandatory="yes">
			<cf_dbtempcol name="subtotalLinea"	    type="money"  	mandatory="yes">
			<cf_dbtempcol name="descuentoDoc"    	type="money"  	mandatory="yes">
			<cf_dbtempcol name="impuestoBase"    	type="money"  	mandatory="yes">
			<cf_dbtempcol name="impuesto"    		type="money"  	mandatory="yes">
			<cf_dbtempcol name="impuestoInterfaz" 	type="money"  	mandatory="no">
			<cf_dbtempcol name="ingresoLinea"	    type="money"  	mandatory="yes">
			<cf_dbtempcol name="totalLinea"	    	type="money"  	mandatory="yes">
		</cf_dbtemp>
		<cfset request.CC_impLinea		= CC_impLinea>
		<cfset request.CC_calculoLin	= CC_calculoLin>
        <cfreturn request>
	</cffunction>
    <cffunction name="TablaNCredito" access="public" returntype="any" output="no">
        <cfargument name="Conexion" type="string" required="yes">
        <cf_dbtemp name="NCredito" returnvariable="N_Credito" datasource="#session.dsn#">
            <cf_dbtempcol name="Ecodigo"	        type="integer"  	mandatory="yes">
            <cf_dbtempcol name="Pcodigo"    		type="char(20)"     mandatory="yes">
            <cf_dbtempcol name="MontoNC"    	    type="money"  	    mandatory="yes">
            <cf_dbtempcol name="FPBanco"	    	type="numeric"  	mandatory="yes">
            <cf_dbtempcol name="FPCuenta"	    	type="numeric"  	mandatory="yes">
            <cf_dbtempcol name="Docnumero"	    	type="varchar(20)"  mandatory="yes">
        </cf_dbtemp>
        <cfset request.N_Credito	    = N_Credito>
    </cffunction>
    <cffunction name="consultaParametro" returntype="query">
         <cfargument name='Ecodigo'   type="numeric"   required="yes" default="#session.Ecodigo#">
         <cfargument name='Mcodigo'   type="string"    default="" >
         <cfargument name='Pcodigo'   type="numeric"   required="yes">

       <cfquery name="rsValor" datasource="#session.dsn#">
        select <cf_dbfunction name="to_char"	args="Pvalor"> as valor
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          <cfif len(trim(#Arguments.Mcodigo#)) gt 0>
           and Mcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Mcodigo#">
          </cfif>
          and Pcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Arguments.Pcodigo#">
        </cfquery>
        <cfreturn rsValor>
    </cffunction>
    <cffunction name="accionDocumentos" returntype="string">
     <cfargument name='Ecodigo'   type="numeric"   required="yes" default="#session.Ecodigo#">
     <cfargument name='FCid'      type="numeric"   required="yes" >
     <cfargument name='ETnumero'  type="numeric"   required="yes" >
     <cfargument name='AnulacionParcial' type="boolean" default="false">
     <cfargument name='TotalDetalles'  type="numeric"  required="false" >
     <cfargument name='ETmontodes'  type="numeric"  required="yes" >

       <cfquery name="select" datasource="#session.dsn#">
					select 	Ecodigo,CCTcodigo, Ddocumento, Ocodigo,SNcodigo,Mcodigo, Dtipocambio,
                        <cfif isdefined('Arguments.AnulacionParcial') and Arguments.AnulacionParcial eq true>
                        #Arguments.TotalDetalles# as Dtotal, <cfelse> Dtotal,</cfif>
						#Arguments.ETmontodes# as EDdescuento, Dsaldo, Dfecha, Dvencimiento,Ccuenta, Dtcultrev,	Dusuario,Rcodigo,Dmontoretori, Dtref,
						Ddocref, Icodigo, Dreferencia, DEidVendedor, DEidCobrador, DEdiasVencimiento, DEordenCompra, DEnumReclamo, DEobservacion,
						DEdiasMoratorio, id_direccionFact, id_direccionEnvio, CFid,	EDtipocambioFecha, EDtipocambioVal, TESRPTCid ,TESRPTCietu  ,FCid
                        ,ETnumero ,ETnombreDoc,CDCcodigo,SNcodigoAgencia, DfechaExpedido
				 from Documentos where FCid= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                    and ETnumero= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                    and  Ecodigo=  <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
			</cfquery>
            <cfinvoke method="consultaParametro" returnvariable="rsPeriodo"
                    Ecodigo     ="#Arguments.Ecodigo#"
                    Mcodigo       ="GN"
                    Pcodigo       ="50">
            </cfinvoke>

            <cfinvoke method="consultaParametro" returnvariable="rsMes"
                            Ecodigo     ="#Arguments.Ecodigo#"
                            Mcodigo       ="GN"
                            Pcodigo       ="60">
            </cfinvoke>
			<cfquery name="rsSQL" datasource="#session.dsn#">
					insert into HDocumentos
					(	Ecodigo, CCTcodigo, Ddocumento, Ocodigo,SNcodigo, Mcodigo,Dtipocambio, Dtotal, EDdescuento,	Dsaldo,	Dfecha, Dvencimiento,Ccuenta,
						Dtcultrev,	Dusuario,Rcodigo,Dmontoretori,	Dtref, Ddocref, Icodigo,Dreferencia,DEidVendedor,DEidCobrador,	DEdiasVencimiento,
						DEordenCompra,DEnumReclamo,	DEobservacion,DEdiasMoratorio,id_direccionFact, id_direccionEnvio, CFid,EDtipocambioFecha, EDtipocambioVal
						,TESRPTCid,TESRPTCietu ,FCid ,ETnumero ,ETnombreDoc ,EDperiodo ,EDmes ,CDCcodigo,SNcodigoAgencia, DfechaExpedido
					)

				VALUES(
					   #session.Ecodigo#,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#select.CCTcodigo#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.Ddocumento#"        voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.Ocodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.SNcodigo#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.Mcodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#select.Dtipocambio#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.Dtotal#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.EDdescuento#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.Dsaldo#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.Dfecha#"            voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.Dvencimiento#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.Ccuenta#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#select.Dtcultrev#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="30"  value="#select.Dusuario#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#select.Rcodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_money"             value="#select.Dmontoretori#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="2"   value="#select.Dtref#"             voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.Ddocref#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="5"   value="#select.Icodigo#"           voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.Dreferencia#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.DEidVendedor#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.DEidCobrador#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.DEdiasVencimiento#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.DEordenCompra#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="20"  value="#select.DEnumReclamo#"      voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#select.DEobservacion#"     voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.DEdiasMoratorio#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.id_direccionFact#"  voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.id_direccionEnvio#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.CFid#"              voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.EDtipocambioFecha#" voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_float"             value="#select.EDtipocambioVal#"   voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.TESRPTCid#"         voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_integer"           value="#select.TESRPTCietu#"       voidNull>,
                       <cf_jdbcQuery_param cfsqltype="cf_sql_numeric" scale="0" value="#select.FCid#"              voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"           value="#select.ETnumero#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_varchar" len="255" value="#select.ETnombreDoc#"       voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"           value="#rsMes.valor#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"           value="#rsPeriodo.valor#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"           value="#select.CDCcodigo#"          voidNull>,
             		   <cf_jdbcQuery_param cfsqltype="cf_sql_numeric"           value="#select.SNcodigoAgencia#"          voidNull>,
					   <cf_jdbcQuery_param cfsqltype="cf_sql_timestamp"         value="#select.DfechaExpedido#" voidNull>

				)
             <cf_dbidentity1 name="rsSQL" datasource="#session.dsn#" verificar_transaccion="false">
			</cfquery>
	 <cf_dbidentity2 name="rsSQL" datasource="#session.dsn#" verificar_transaccion="false" returnvariable="LvarHDid">
        <cfreturn LvarHDid>
    </cffunction>
    <cffunction name="table_Cfunc_comisiones" output="no" returntype="string" access="public">
       <cf_dbtemp name="Cfunc_comisiones" returnvariable="Cfunc_comisionesgasto" datasource="#session.dsn#">
            <cf_dbtempcol name="CFid" 	type="numeric"	      mandatory="yes">
            <cf_dbtempcol name="CFcuentac"  	type="varchar(100)"     mandatory="yes">
            <cf_dbtempcol name="CFcuenta"  		type="numeric"        mandatory="yes">
        </cf_dbtemp>
        <cfreturn Cfunc_comisionesgasto>
    </cffunction>
    <cffunction name="table_asientoV1" output="no" returntype="string" access="public">
    <cf_dbtemp name="asientoV1" returnvariable="asiento" datasource="#session.dsn#">
		<cf_dbtempcol name="IDcontable" 	type="numeric"	      mandatory="yes">
		<cf_dbtempcol name="Cconcepto"  	type="integer"        mandatory="yes">
        <cf_dbtempcol name="Edocumento"  	type="integer"        mandatory="yes">
        <cf_dbtempcol name="Eperiodo"  	    type="integer"        mandatory="yes">
        <cf_dbtempcol name="Emes"  	        type="integer"        mandatory="yes">
	</cf_dbtemp>
    <cfreturn asiento>
    </cffunction>
    <cffunction  name="table_IdKardexV1" output="no" returntype="string" access="public">
    <cf_dbtemp name="IdKardexV1" returnvariable="IdKardex" datasource="#session.dsn#">
		<cf_dbtempcol name="Kid"        	type="numeric"	      mandatory="yes">
		<cf_dbtempcol name="IDcontable"  	type="numeric"        mandatory="yes">
	</cf_dbtemp>
    <cfreturn IdKardex>
    </cffunction>

    <cffunction name="table_ArticulosV1" output="no" returntype="string" access="public">
    <cf_dbtemp name="ArticulosV1" returnvariable="Articulos1" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"      type="integer"	    mandatory="yes">
		<cf_dbtempcol name="Aid"  	      type="numeric"        mandatory="yes">
        <cf_dbtempcol name="linea"        type="numeric"        mandatory="yes">
        <cf_dbtempcol name="Alm_Aid"  	  type="numeric"        mandatory="yes">
        <cf_dbtempcol name="Ocodigo"  	  type="integer"        mandatory="yes">
        <cf_dbtempcol name="Dcodigo"  	  type="integer"        mandatory="yes">
        <cf_dbtempcol name="cant"  	      type="float"          mandatory="yes">
        <cf_dbtempcol name="costolinloc"  type="money"          mandatory="yes">
        <cf_dbtempcol name="costolinori"  type="money"          mandatory="yes">
        <cf_dbtempcol name="TC"           type="money"          mandatory="yes"> <!--- Lo agregue yo ----->
        <cf_dbtempcol name="Moneda"       type="numeric"        mandatory="yes"> <!--- Lo agregue yo ----->
		<cf_dbtempcol name="EcostoU"      type="float"          mandatory="no"> <!--- Lo agregue yo ----->
		<cf_dbtempcol name="NC_EcostoU"   type="float"          mandatory="no">
	</cf_dbtemp>
     <cfreturn Articulos1>
    </cffunction>
    <cffunction name="table_ArticulosV2" returntype="string">
    <cf_dbtemp name="ArticulosV2" returnvariable="Articulos2" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"      type="integer"	    mandatory="yes">
		<cf_dbtempcol name="Aid"  	      type="numeric"        mandatory="yes">
        <cf_dbtempcol name="linea"        type="numeric"        mandatory="yes">
        <cf_dbtempcol name="Alm_Aid"  	  type="numeric"        mandatory="yes">
        <cf_dbtempcol name="Ocodigo"  	  type="integer"        mandatory="yes">
        <cf_dbtempcol name="Dcodigo"  	  type="integer"        mandatory="yes">
        <cf_dbtempcol name="cant"  	      type="float"          mandatory="yes">
        <cf_dbtempcol name="costolinloc"  type="money"          mandatory="yes">
        <cf_dbtempcol name="costolinori"  type="money"          mandatory="yes">
        <cf_dbtempcol name="TC"           type="money"          mandatory="yes"> <!--- Lo agregue yo ----->
        <cf_dbtempcol name="Moneda"       type="numeric"        mandatory="yes"> <!--- Lo agregue yo ----->
		<cf_dbtempcol name="EcostoU"      type="float"          mandatory="no"> <!--- Lo agregue yo ----->
		<cf_dbtempcol name="NC_EcostoU"   type="float"          mandatory="no">
	</cf_dbtemp>
    <cfreturn Articulos2>
    </cffunction>
<cffunction name="CalcularDocumento" output="no" returntype="any" access="public">
        <cfargument name="FCid"      			type="numeric" required="yes">
        <cfargument name="ETnumero"      		type="numeric" required="yes">
		<cfargument name="CalcularImpuestos"	type="boolean" required="yes">
		<cfargument name="Ecodigo"  			type="numeric" required="yes">
		<cfargument name="Conexion" 			type="string"  required="yes">

		<!--- Validaciones Preposteo --->
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad
			  from ETransacciones
			 where FCid   = #Arguments.FCid#
             and ETnumero = #Arguments.ETnumero#
             and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		</cfquery>
		<cfif rsSQL.Cantidad EQ 0>
			 <cf_errorCode	code = "50994" msg = "El documento indicado no existe. Verifique que el documento exista!">
		</cfif>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select count(1) as cantidad  from DTransacciones
			 where FCid   = #Arguments.FCid# and ETnumero = #Arguments.ETnumero#
             and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and DTborrado = 0
		</cfquery>
		<cfif rsSQL.cantidad EQ 0>
			<cfquery datasource="#session.DSN#">
			update DTransacciones   set DTtotal = 0 , DTimpuesto = 0
			   where FCid   = #Arguments.FCid#  and ETnumero = #Arguments.ETnumero#	 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
               and DTborrado = 0
			</cfquery>
		<cfelse>
			<cfif not isdefined("LvarPcodigo420")>
				<cfset CreaTablas(#session.dsn#)>

				<!--- Manejo del DescuentoDoc para calculo de impuestos --->
                 <cfinvoke method="consultaParametro" returnvariable="rsSQL"
                    Ecodigo     ="#Arguments.Ecodigo#"
                    Pcodigo       ="420">
                 </cfinvoke>
				<cfset LvarPcodigo420 = rsSQL.valor>
				<cfif LvarPcodigo420 EQ "">
					<cf_errorCode	code = "50996" msg = "No se ha definido el parametro de Manejo del Descuento a Nivel de Documento para CxC y CxP!">
				</cfif>
				<!--- Usar Cuenta de Descuentos en CxC --->
                <cfinvoke method="consultaParametro" returnvariable="rsSQL"
                    Ecodigo     ="#Arguments.Ecodigo#"
                    Pcodigo       ="421">
                 </cfinvoke>
				<cfset LvarPcodigo421 = rsSQL.valor>
				<cfif LvarPcodigo421 EQ "">
					<cf_errorCode	code = "50997" msg = "No se ha definido el parametro de Tipo de Registro del Descuento a Nivel de Documento para CxC!">
				</cfif>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select  coalesce(a.ETmontodes, 0) as ETdescuento,
							coalesce(( select sum(DTtotal) from DTransacciones where FCid   = a.FCid and ETnumero = a.ETnumero
				                 and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">) ,0.00) as SubTotal
					  from ETransacciones a	 where a.FCid   = #Arguments.FCid#
                       and ETnumero = #Arguments.ETnumero#
				        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
				<cfset LvarDescuentoDoc = rsSQL.ETdescuento>
				<cfset LvarSubTotalDoc = rsSQL.SubTotal>
			</cfif>
			<cfif LvarDescuentoDoc GT LvarSubTotalDoc>
				<cf_errrCode	code = "51000" msg = "El descuento no puede ser mayor al subtotal">
			</cfif>
			<cfset CC_impLinea		= request.CC_impLinea>
			<cfset CC_calculoLin	= request.CC_calculoLin>

			<!--- Prorratear el Descuento a nivel de Documento --->
			<cfquery datasource="#session.dsn#">
			insert into #CC_calculoLin# (FCid, ETnumero, DTlinea, descuentoDoc,	impuestoInterfaz, impuesto, impuestoBase, ingresoLinea, totalLinea,subtotalLinea)
			select 	FCid, ETnumero, DTlinea, 0, 0,0, 0, 0, 0,0
				from DTransacciones d where d.FCid   = #Arguments.FCid# and ETnumero = #Arguments.ETnumero#
		        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">      and DTborrado = 0
			</cfquery>
			<!--- Ajuste de redondeo por Prorrateo del Descuento --->
			<cfquery name="rsSQL" datasource="#session.dsn#">
				select sum(descuentoDoc) as descuentoDoc from #CC_calculoLin#
			</cfquery>
			<cfset LvarAjuste = LvarDescuentoDoc - rsSQL.descuentoDoc>
			<cfif LvarAjuste NEQ 0>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select max(descuentoDoc) as mayor  from #CC_calculoLin#
				</cfquery>
				<cfif rsSQL.mayor LT -(LvarAjuste)>
					<cf_errorCode	code = "51001" msg = "No se puede prorratear el descuento a nivel de documento">
				</cfif>
				<cfquery name="rsSQL" datasource="#session.dsn#">
					select min(DTlinea) as DDid  from #CC_calculoLin# where descuentoDoc = (	select max(descuentoDoc)  from #CC_calculoLin#	)
				</cfquery>
				<cfquery datasource="#session.dsn#">
					update #CC_calculoLin#  set descuentoDoc = descuentoDoc + #LvarAjuste# where DTlinea = #rsSQL.DDid#
				</cfquery>
			</cfif>
			<!--- Obtiene los Impuestos Simples --->
			<cfquery datasource="#session.dsn#" name="rsTT">
				insert into #CC_impLinea# (	FCid, ETnumero, ecodigo,   icodigo,  dicodigo, descripcion, ccuenta,montoBase, porcentaje,  impuesto, icompuesto,DTlinea, descuentoDoc)
				select FCid,ETnumero, d.Ecodigo, i.Icodigo, i.Icodigo, <cf_dbfunction name="concat" args="i.Icodigo, ': ', i.Idescripcion">,
					coalesce(i.CcuentaCxC,i.Ccuenta), DTtotal, Iporcentaje, 0.00,     0,DTlinea, coalesce(d.DTdeslinea,0.00)
				from DTransacciones d	inner join Impuestos  i	 on i.Ecodigo = d.Ecodigo and i.Icodigo = d.Icodigo
					and i.Icompuesto = 0 where d.FCid   = #Arguments.FCid#   and d.ETnumero = #Arguments.ETnumero#
		        and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and DTborrado = 0
			</cfquery>

			<!--- Obtiene los Impuestos Compuestos --->
			<cfquery datasource="#session.dsn#" name="rsDD">
				insert into #CC_impLinea# (	FCid, ETnumero, 	ecodigo,	icodigo, 	dicodigo,
					descripcion, ccuenta, montoBase, porcentaje, impuesto, icompuesto,DTlinea,descuentoDoc)
				select 	FCid, ETnumero, d.Ecodigo, 	di.Icodigo, di.DIcodigo,
					<cf_dbfunction name="concat" args="i.Icodigo, '-' , di.DIcodigo, ': ', di.DIdescripcion">,
					coalesce(i.CcuentaCxC,di.Ccuenta),	DTtotal, di.DIporcentaje,	0.00,     1,DTlinea, coalesce(d.DTdeslinea,0.00)
				from DTransacciones d
					inner join Impuestos  i
						inner join DImpuestos di on di.Ecodigo = i.Ecodigo
						and di.Icodigo = i.Icodigo	on i.Ecodigo = d.Ecodigo
					and i.Icodigo = d.Icodigo	and i.Icompuesto = 1
				where d.FCid   = #Arguments.FCid#  and d.ETnumero = #Arguments.ETnumero#
		        and d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> and DTborrado = 0
			</cfquery>
			<!--- Calculo del Impuesto --->
			<cfquery datasource="#session.dsn#">
				update #CC_impLinea#  set impuesto = round((montoBase)* coalesce(porcentaje, 0) / 100.00, 2)
			</cfquery>
	    	<cfquery datasource="#session.DSN#">
				update DTransacciones  set DTimpuesto = (select impuesto from #CC_impLinea# a where a.FCid = DTransacciones.FCid	and a.ETnumero = DTransacciones.ETnumero
               and a.DTlinea = DTransacciones.DTlinea) where exists(select 1 from #CC_impLinea# a where a.FCid = DTransacciones.FCid and a.ETnumero = DTransacciones.ETnumero
              and a.DTlinea = DTransacciones.DTlinea)
			</cfquery>
		</cfif>
		<cfreturn request>
   </cffunction>

  <cffunction name="AfectaSaldos" output="no" returntype="query" access="public">
        <cfargument name="Ecodigo"  	  type="numeric" required="yes">
        <cfargument name="CCTcodigo"      type="string"  required="yes">
        <cfargument name="FPdocnumero"    type="string"  required="yes">
		<cfargument name="SNcodigoFac"	  type="string"  required="yes">
        <cfargument name="PagoDoc"	      type="numeric" required="yes">

           <cfquery name = "SaldoOri" datasource ="#session.dsn#">
            Select Dsaldo  from Documentos where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                    and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                    and SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarSNcodigoFac#">
            </cfquery>
            <cfset SaldoOrigen = SaldoOri.Dsaldo>
            <cfquery name = "RegresaSaldo" datasource ="#session.dsn#">
            update Documentos set Dsaldo = Dsaldo+<cfqueryparam cfsqltype="cf_sql_money" value="#rsFPagos.PagoDoc#">
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                    and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                    and SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarSNcodigoFac#">
            </cfquery>
           <cfquery name = "SaldoAfectado" datasource ="#session.dsn#">
            Select Dsaldo  from Documentos
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#rsTransfer.CCTcodigo#">
                    and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#rsFPagos.FPdocnumero#">
                    and SNcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#LvarSNcodigoFac#">
            </cfquery>
            <cfset SaldoAfectado = SaldoAfectado.Dsaldo>
            <cfquery name="rsDatos" datasource="#session.dsn#">
              select #SaldoOrigen# as SaldoOrigen, #SaldoAfectado# as SaldoAfectado from dual
            </cfquery>
        <cfreturn rsDatos>
    </cffunction>
   <cffunction name="ValidarDocumento" output="no"  access="public">
        <cfargument name="FCid"      			type="numeric" required="yes">
        <cfargument name="ETnumero"      		type="numeric" required="yes">

         <!--- --Validaciones Preposteo--->
      <cfquery name="rsETransacciones" datasource="#session.dsn#">
        select 1 from ETransacciones where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#"> and ETestado = 'T'
      </cfquery>
      <cfif isdefined('rsETransacciones') and rsETransacciones.recordcount eq 0>
        <cfthrow message="Error! El documento indicado no existe o no esta terminado!!">
      </cfif>
     <cfquery name="rsDTransacciones" datasource="#session.dsn#">
        select 1 from DTransacciones where FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#"> and DTborrado != 1
     </cfquery>
     <cfif isdefined('rsDTransacciones') and rsDTransacciones.recordcount eq 0>
        <cfthrow message="Error! El documento indicado no tiene detalles! Proceso Cancelado.">
     </cfif>
   </cffunction>

<!----Funciona Insertar Encabezados el documento de cobro----->
  <cffunction name="InsertaPago" access="public" returntype="any">
       <cfargument name='CCTcodigo'        type="string"    required="yes">
       <cfargument name='Pcodigo'          type="string"    required="yes">
       <cfargument name='Mcodigo'          type='numeric'   required="yes">
       <cfargument name='Ptipocambio'      type="numeric"   required="yes">
       <cfargument name='Ptotal'           type="numeric"   required="yes">
       <cfargument name='Observaciones'    type="string"    required="yes">
       <cfargument name='Ocodigo'          type="string"    required="yes">
       <cfargument name='SNcodigo'         type="string"    required="yes">
       <cfargument name='Ccuenta'          type='numeric'   required="yes">
       <cfargument name='CBid'             type='numeric'   required="no">
       <cfargument name='Preferencia'      type='string'    required="no">
       <cfargument name="FPdocnumero"      type="string"    required="no">
       <cfargument name='FPBanco'          type='numeric'   required="no">
       <cfargument name='FPCuenta'         type='numeric'   required="no">
       <cfargument name='Param'            type='boolean'   required="no" default="true">
       <cfargument name='Anulacion'        type='boolean'   required="no" default="false">
       <cfargument name='AnulacionParcial' type='boolean'   required="no" default="false">
       <cfargument name='consecutivo'      type='numeric'   required="no" default="0">
       <cfargument name="N_Credito"        type="string"    required="yes">
       <cfargument name="FCid"             type="numeric"   required="yes">
          <cfset LvarPagado = 0>
             <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
               <cfset arguments.Pcodigo = arguments.Pcodigo & '_' & arguments.consecutivo>
            </cfif>

			<cfset LvarCont = true>
            <cfset total = 0>	<cfset LvarDif = 0>
            <cfif isdefined('arguments.N_Credito') and len(trim(#arguments.N_Credito#)) eq 0>
             <!---   <cfset TablaNCredito(#session.dsn#)>--->
                  <cfinvoke  method="TablaNCredito" returnvariable="N_Credito"
	                        Conexion        ="#session.dsn#" >
                  </cfinvoke>
            </cfif>

  			<cfif not arguments.Anulacion and not arguments.AnulacionParcial >
	            <cfif LvarPagado eq LvarTotal and GenNCredito>
	                <cfset LvarCont = false>
	                <cfquery datasource="#session.dsn#" name="rsNC">
	                    insert into #request.N_Credito# ( Ecodigo, Pcodigo,	MontoNC, FPBanco, Docnumero, FPCuenta)
	                    values (#Session.Ecodigo#,
	                        <cfqueryparam cfsqltype="cf_sql_char"    value="#arguments.Pcodigo#">,
	                        <cfqueryparam cfsqltype="cf_sql_money"   value="#arguments.Ptotal#">,
	                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPBanco#">,
	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FPdocnumero#">,
                            <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPCuenta#">
	                    )
					</cfquery>
	            <cfelseif (Arguments.Ptotal + LvarPagado) gt LvarTotal>

					<cfset LvarIni          = arguments.Ptotal>
					<cfset arguments.Ptotal = (LvarTotal - LvarPagado)>
	                <cfset LvarDif          = arguments.Ptotal>
	                <cfset LvarIni          = (LvarIni - arguments.Ptotal)>

	                  <cfquery datasource="#session.dsn#" name="rsNC">
	                    insert into #Arguments.N_Credito# (Ecodigo, Pcodigo,MontoNC, FPBanco, Docnumero
                        <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(#arguments.FPCuenta#)) NEQ "" > , FPCuenta</cfif>
                        )
	                    values(#Session.Ecodigo#,
	                        <cfqueryparam cfsqltype="cf_sql_char"    value="#arguments.Pcodigo#">,
	                        <cfqueryparam cfsqltype="cf_sql_money"   value="#LvarIni#">,
	                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPBanco#">,
	                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FPdocnumero#">
	                        <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(#arguments.FPCuenta#)) NEQ "" > ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FPCuenta#"></cfif>
	                    )
					  </cfquery>
	            </cfif>
	            <cfset LvarPagado = (LvarPagado + arguments.Ptotal)>
			</cfif>

          <cfif LvarCont>

                <cfquery datasource="#Session.DSN#" name="rsInsertP">
                    insert into Pagos(Ecodigo, CCTcodigo, Pcodigo, Mcodigo, Ptipocambio, Seleccionado,
                                      Ccuenta, Ptotal, Pfecha, Pobservaciones, Ocodigo, SNcodigo,
                                      Pusuario,Preferencia <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(#arguments.FPCuenta#)) NEQ ""> ,CBid</cfif>,FCid)
                    values (#Session.Ecodigo#,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.Ptipocambio#">,
                        0,
                        <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#">,
                        <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.Ptotal#">,
                        <cf_jdbcquery_param cfsqltype="cf_sql_timestamp" value="#Now()#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Observaciones#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ocodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.Usuario#">,
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.Preferencia#">
                        <cfif isdefined('arguments.FPCuenta') and arguments.FPCuenta neq 0 and len(trim(#arguments.FPCuenta#)) NEQ "" > ,<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.FPCuenta#"></cfif>
                        ,<cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
                   )
                </cfquery>
                <cfquery datasource="#Session.DSN#" name="rsPagosValida">
                    select count(1) as lineas from  Pagos where Ecodigo=  #Session.Ecodigo# and
                    CCTcodigo= <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#"> and
                    Pcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">
                </cfquery>

                <cfset LvarMyId  =  rsPagosValida.lineas>
          </cfif>
          <cfif isdefined('LvarMyId') and LvarMyId gt 0 or LvarCont>
            <cfreturn true>
          <cfelse>
            <cfreturn false>
          </cfif>
  </cffunction>
  <cffunction name="InsertaDetallePago" returntype="any">
           <cfargument name='CCTcodigo'     type="string"    required="yes">
           <cfargument name='Pcodigo'       type="string"    required="yes">
           <cfargument name='Doc_CCTcodigo' type="string"    required="yes">
           <cfargument name='Ddocumento'    type="string"    required="yes">
           <cfargument name='Mcodigo'       type="string"    required="yes">
           <cfargument name='Ccuenta'       type="string"    required="yes">
           <cfargument name='DPmonto'       type="numeric"    required="yes">
           <cfargument name='DPtipocambio'  type="numeric"    required="yes">
           <cfargument name='DPmontodoc'    type="numeric"    required="yes">
           <cfargument name='DPtotal'       type="numeric"    required="yes">
           <cfargument name='DPmontoretdoc' type="numeric"    required="yes">
           <cfargument name='PPnumero'      type="numeric"    required="yes">
           <cfargument name='AnulacionParcial' type='boolean' required="no" default="false">
           <cfargument name='consecutivo'   type='numeric'    required="no" default="0">

            <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
               <cfset arguments.Pcodigo = arguments.Pcodigo & '_' & arguments.consecutivo>
            </cfif>
            <cfquery datasource="#Session.DSN#">
                insert into DPagos(Ecodigo, CCTcodigo, Pcodigo, Doc_CCTcodigo, Ddocumento, Mcodigo,
                    Ccuenta, DPmonto, DPtipocambio, DPmontodoc, DPtotal, DPmontoretdoc, PPnumero)
                values (
                    #Session.Ecodigo#,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Pcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Doc_CCTcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Mcodigo#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.Ccuenta#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.DPtotal#">,
                    <cfqueryparam cfsqltype="cf_sql_float" value="#arguments.DPtipocambio#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.DPmontodoc#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.DPtotal#">,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#arguments.DPmontoretdoc#">,
                    <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.PPnumero#">
                )
            </cfquery>
    <cfreturn true>
 </cffunction>
 <cffunction name="ComisionesConceptos" returntype="any">
           <cfargument name="INTARC"           type="string" required="yes">
           <cfargument name="Cfunc_comisionesgasto" type="string" required="yes">
           <cfargument name="Ecodigo"  	       type="numeric" required="yes">
           <cfargument name="ETdocumento"      type="string" required="yes">
           <cfargument name="CCTcodigo"        type="string" required="yes">
           <cfargument name="FATmontomin"      type="numeric" >
           <cfargument name="FATmontomax"      type="numeric" >
           <cfargument name="FATaplicamontos"  type="numeric" >
           <cfargument name="Total"            type="numeric" required="yes">
           <cfargument name="FPtc"             type="numeric" required="yes">
           <cfargument name="FPmontoori"       type="numeric" required="yes">
           <cfargument name="FATporccom"       type="numeric" required="yes">
           <cfargument name="CCTtipo"          type="string"  required="yes">
           <cfargument name="Anulacion"        type="boolean" required="yes">
           <cfargument name="FATdescripcion"   type="string" required="yes">
           <cfargument name="Monloc"           type="numeric" required="yes">
           <cfargument name="Mcodigo"          type="numeric" required="yes">
           <cfargument name="Periodo"          type="numeric" required="yes">
           <cfargument name="Mes"              type="numeric" required="yes">
           <cfargument name="Cuentacaja"       type="numeric" required="yes">
           <cfargument name="CFCuentacaja"     type="numeric" required="yes">
           <cfargument name="FCid"             type="numeric" required="yes">
           <cfargument name="ETnumero"         type="numeric" required="yes">
           <cfargument name="AnulacionParcial" type="boolean" required="yes">
           <cfargument name="LineasDetalle"    type="string" required="yes">
           <cfargument name="Comision"         type="numeric" required="yes" default="-1">
           <cfargument name="FATNOsumaComision"  type="numeric" required="yes" default="0">
           <cfargument name="FATid"            type="numeric" required="yes">

           <cfquery name="rsTarjeta" datasource="#Session.DSN#">
            select FATdescripcion,
                FATporccom,FATcxpsocio, SNcodigo, FATmontomin,FATmontomax,FATaplicamontos,FATNOsumaComision,CFcuentaCobro,CFid ,FATCtaCobrotarjeta, FATCFtarjeta,FATNOaplicaAnulacion
            from FATarjetas j
            where j.FATid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FATid#">
          </cfquery>

            <cfif rsTarjeta.FATCtaCobrotarjeta eq 1 and len(trim(#rsTarjeta.CFcuentaCobro#)) eq 0>
               <cfthrow message ="#arguments.FATdescripcion# requiere una cuenta de cobro pues el gasto no va a la cuenta del centro funcional. Sino la administracion.">
            </cfif>
             <cfif rsTarjeta.FATCFtarjeta eq 1 and len(trim(#rsTarjeta.CFid#)) eq 0>
               <cfthrow message ="#arguments.FATdescripcion# requiere un centro funcional para registro de la cuenta.">
            </cfif>

     <cfset GeneraMov = true>
      <cfif  arguments.AnulacionParcial eq true>
         <cfif rsTarjeta.FATNOaplicaAnulacion eq 1>
             <cfset GeneraMov = false>
         </cfif>
      </cfif>
     <cfif  arguments.Anulacion eq true>
         <cfif rsTarjeta.FATNOaplicaAnulacion eq 1>
             <cfset GeneraMov = false>
         </cfif>
      </cfif>

      <cfif GeneraMov eq true>
         <cfquery name="rs" datasource="#session.dsn#">
		    insert #arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE,
                 INTllave1,INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona, INTidPersona)
			     select 'FAFC', 1,'#arguments.ETdocumento#', '#arguments.CCTcodigo#',

                     <!-----   case when (#arguments.FATmontomin# = #arguments.FATmontomax#) and (#arguments.FATaplicamontos# = 1) then
                         round((#arguments.FATmontomin# * ((b.DTtotal)/#arguments.Total#))* (#arguments.FPtc#),2)
                      when (round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)*((b.DTtotal)/#arguments.Total#)) * (#arguments.FPtc#),2)) > #arguments.FATmontomax# and (#arguments.FATaplicamontos# = 1)  then
                         round((#Arguments.FATmontomax# * ((b.DTtotal)/#Arguments.Total#))* (#Arguments.FPtc#),2)
                      when (round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)*((b.DTtotal)/#arguments.Total#)) * (#arguments.FPtc#),2)) < #Arguments.FATmontomin# and (#Arguments.FATaplicamontos# = 1)  then
                         round((#arguments.FATmontomin# * ((b.DTtotal)/#Arguments.Total#))* (#Arguments.FPtc#),2)
                      <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal)/#arguments.FPmontoori#))  * (#arguments.FPtc#),2)
                      <cfelse>
                      else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal)/#arguments.Total#))  * (#arguments.FPtc#),2)
                      </cfif>
                    end,  ----->

                      <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                      case when (#rsTarjeta.FATaplicamontos# = 1) then
                         round(
                               (#arguments.Comision# *
                                        (
                                               (b.DTtotal + coalesce(b.DTimpuesto,0) )
                                               /#arguments.FPmontoori#
                                       )
                               )
                                  * (#arguments.FPtc#)
                            ,2)
                       else
                       round(
                               (
                                   round(#arguments.FPmontoori#*  (#arguments.FATporccom#/100.00),2)
                               )
                                * (#arguments.FPtc#)
                          ,2)
                      <cfelse>
                      case when (#rsTarjeta.FATaplicamontos# = 1) then
                         round(
                                (#arguments.Comision#
                                   * ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.Total#)
                                )
                                   * (#arguments.FPtc#)
                            ,2)
                      else
				round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.Total#))* (#arguments.FPtc#) ,2)


                      </cfif>
                     end,
                   case when '#arguments.CCTtipo#' = 'D' then 'D' else 'C' end,
		            '<cfif Arguments.Anulacion>Reversion </cfif>Comisiones: ' #_Cat# '#arguments.FATdescripcion#',
		            <cf_dbfunction name="to_char"	args="getdate(),112">,
		            case when #arguments.Monloc# != #arguments.Mcodigo# then #arguments.FPtc# else 1.00 end,
		            #arguments.Periodo#, #arguments.Mes#,
		            <cfif not Arguments.Anulacion>0,<cfif rsTarjeta.FATCtaCobrotarjeta eq 1>#rsTarjeta.CFcuentaCobro# <cfelse> cfunc.CFcuenta</cfif><cfelse> #Arguments.Cuentacaja#,#Arguments.CFCuentacaja# </cfif>,
		            #Arguments.Mcodigo#, d.Ocodigo,

                  <!-----   case when (#Arguments.FATmontomin# = #Arguments.FATmontomax#) and (#Arguments.FATaplicamontos# = 1)  then
                       round(((#Arguments.FATmontomax# / #Arguments.FPtc#)* ((b.DTtotal)/#Arguments.Total#)),2)
                      when ( round((round(#Arguments.FPmontoori#*#Arguments.FATporccom#/100.00,2) * ((b.DTtotal)/#Arguments.Total#)),2)) > (#Arguments.FATmontomax# / #Arguments.FPtc#) and (#Arguments.FATaplicamontos# = 1) then
                       round(((#Arguments.FATmontomax# / #Arguments.FPtc#)* ((b.DTtotal)/#Arguments.Total#)),2)
                      when ( round((round(#Arguments.FPmontoori#*#Arguments.FATporccom#/100.00,2) * ((b.DTtotal)/#Arguments.Total#)),2)) < (#Arguments.FATmontomin# / #Arguments.FPtc#) and (#Arguments.FATaplicamontos# = 1) then
                       round(((#Arguments.FATmontomin# / #Arguments.FPtc#)* ((b.DTtotal)/#Arguments.Total#)),2)
                      <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal)/#Arguments.FPmontoori#)),2)
                      <cfelse>
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal)/#Arguments.Total#)),2)
                      </cfif>
                   end, ---->

                     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                     case when (#rsTarjeta.FATaplicamontos# = 1)  then

                       round(
                               (
                                 (#Arguments.Comision# / #Arguments.FPtc#)
                                 *
                                 (
                                     (b.DTtotal + (b.DTimpuesto,0) )
                                     /#Arguments.FPmontoori#
                                 )
                               )
                          ,2)
                      else
                      round(
                            (
                              round(#Arguments.FPmontoori#
                                      *(#Arguments.FATporccom#)
                                      /(100.00)
                                 ,2)
                            )
                         ,2)
                      <cfelse>
                        case when (#rsTarjeta.FATaplicamontos# = 1)  then
                       round(
                                (
                                    (#Arguments.Comision# / #Arguments.FPtc#)*
                                    (
                                      (b.DTtotal + coalesce(b.DTimpuesto,0) )/#Arguments.Total#
                                    )
                                )
                          ,2)
                      else
                       round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.Total#)),2)
                      </cfif>
                   end,
                   <cf_dbfunction name="to_char"	args="a.FCid">, <cf_dbfunction name="to_char"	args="a.ETnumero">,
                   b.DTdescripcion, '#Arguments.ETdocumento#', case when a.CDCcodigo is not null then '03' else '01' end, case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
			        from ETransacciones a
		        inner join DTransacciones b on a.FCid = b.FCid and a.ETnumero = b.ETnumero
		        inner join #arguments.Cfunc_comisionesgasto# cfunc on b.CFid = cfunc.CFid
		        inner join CCTransacciones c  on a.CCTcodigo = c.CCTcodigo and a.Ecodigo = c.Ecodigo
		        inner join CFuncional d
		         <cfif rsTarjeta.FATCFtarjeta eq 1>
		           on d.CFid = #rsTarjeta.CFid#
		         <cfelse>
		           on b.CFid = d.CFid
		         </cfif>
		        and b.Ecodigo = d.Ecodigo
                inner join SNegocios sn on a.Ecodigo = sn.Ecodigo and a.SNcodigo = sn.SNcodigo
		        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
		          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and b.DTtipo = 'S' and b.DTtotal!= 0 and b.DTborrado = 0
                 <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                  and b.NC_DTlinea in (#arguments.LineasDetalle#)
                 </cfif>
         </cfquery>

          <cfquery name="rsComCon" datasource="#session.dsn#">
			     select

                <!-----  case when (#arguments.FATmontomin# = #arguments.FATmontomax#) and (#arguments.FATaplicamontos# = 1) then
                         round((#arguments.FATmontomin# * ((b.DTtotal + coalesce(b.DTimpuesto,0))/#arguments.Total#))* (#arguments.FPtc#),2)
                      when (round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)*((b.DTtotal + coalesce(b.DTimpuesto,0))/#arguments.Total#)) * (#arguments.FPtc#),2)) > #arguments.FATmontomax# and (#arguments.FATaplicamontos# = 1)  then
                         round((#Arguments.FATmontomax# * ((b.DTtotal + coalesce(b.DTimpuesto,0))/#Arguments.Total#))* (#Arguments.FPtc#),2)
                      when (round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)*((b.DTtotal + coalesce(b.DTimpuesto,0))/#arguments.Total#)) * (#arguments.FPtc#),2)) < #Arguments.FATmontomin# and (#Arguments.FATaplicamontos# = 1)  then
                         round((#arguments.FATmontomin# * ((b.DTtotal + coalesce(b.DTimpuesto,0))/#Arguments.Total#))* (#Arguments.FPtc#),2)
                       <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal + coalesce(b.DTimpuesto,0))/#arguments.FPmontoori#))  * (#arguments.FPtc#),2)
                       <cfelse>
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal + coalesce(b.DTimpuesto,0))/#arguments.Total#)) * (#arguments.FPtc#),2)
                       </cfif>
                  end----->

                     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                         case when (#rsTarjeta.FATaplicamontos# = 1) then
                         round((#arguments.Comision# * ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.FPmontoori#))* (#arguments.FPtc#),2)
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2))	* (#arguments.FPtc#),2)
                       <cfelse>
                         case when (#rsTarjeta.FATaplicamontos# = 1) then
                         round((#arguments.Comision# * ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.Total#))* (#arguments.FPtc#),2)
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.Total#)) * (#arguments.FPtc#),2)
                       </cfif>
                  end
                  as ConMonLoc,
                  <!----   case when (#Arguments.FATmontomin# = #Arguments.FATmontomax#) and (#Arguments.FATaplicamontos# = 1)  then
                       round(((#Arguments.FATmontomax# / #Arguments.FPtc#)* ((b.DTtotal + coalesce(b.DTimpuesto,0))/#Arguments.Total#)),2)
                      when ( round((round(#Arguments.FPmontoori#*#Arguments.FATporccom#/100.00,2) * ((b.DTtotal)/#Arguments.Total#)),2)) > (#Arguments.FATmontomax# / #Arguments.FPtc#) and (#Arguments.FATaplicamontos# = 1) then
                       round(((#Arguments.FATmontomax# / #Arguments.FPtc#)* ((b.DTtotal + coalesce(b.DTimpuesto,0))/#Arguments.Total#)),2)
                      when ( round((round(#Arguments.FPmontoori#*#Arguments.FATporccom#/100.00,2) * ((b.DTtotal)/#Arguments.Total#)),2)) < (#Arguments.FATmontomin# / #Arguments.FPtc#) and (#Arguments.FATaplicamontos# = 1) then
                       round(((#Arguments.FATmontomin# / #Arguments.FPtc#)* ((b.DTtotal + coalesce(b.DTimpuesto,0))/#Arguments.Total#)),2)
                     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal + coalesce(b.DTimpuesto,0))/#Arguments.FPmontoori#)),2)
                      <cfelse>
                       else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal + coalesce(b.DTimpuesto,0))/#Arguments.Total#)),2)
                      </cfif>
                     end------>

                     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                     case when  (#rsTarjeta.FATaplicamontos# = 1)  then
                         round(((#Arguments.Comision# / #Arguments.FPtc#)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#Arguments.FPmontoori#)),2)
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2)),2)
                      <cfelse>
                      case when  (#rsTarjeta.FATaplicamontos# = 1)  then
                          round(((#Arguments.Comision# / #Arguments.FPtc#)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#Arguments.Total#)),2)
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#Arguments.Total#)),2)
                      </cfif>
                   end
                    as ConMonE
			        from ETransacciones a
		        inner join DTransacciones b on a.FCid = b.FCid and a.ETnumero = b.ETnumero  and a.Ecodigo = b.Ecodigo
		        inner join #arguments.Cfunc_comisionesgasto# cfunc on b.CFid = cfunc.CFid
		        inner join CCTransacciones c  on a.CCTcodigo = c.CCTcodigo and a.Ecodigo = c.Ecodigo
		        inner join CFuncional d
		        <cfif rsTarjeta.FATCFtarjeta eq 1>
		           on d.CFid = #rsTarjeta.CFid#
		         <cfelse>
		           on b.CFid = d.CFid
		         </cfif>
		         and b.Ecodigo = d.Ecodigo
                inner join SNegocios sn on a.Ecodigo = sn.Ecodigo and a.SNcodigo = sn.SNcodigo
		        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
		          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and b.DTtipo = 'S' and b.DTtotal!= 0 and b.DTborrado = 0
                 <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                  and b.NC_DTlinea in (#arguments.LineasDetalle#)
                 </cfif>
         </cfquery>
       </cfif> <!--- fin del if de generaMov---->
         <cfif isdefined('rsComCon') and  rsComCon.recordcount eq 0 or FATNOsumaComision eq 1>
           <cfquery name="rsComCon" datasource="#session.dsn#">
             select 0 as ConMonLoc,
             0 as ConMonE from dual
           </cfquery>
         </cfif>
         <cfif  not isdefined('rsComCon')>
           <cfquery name="rsComCon" datasource="#session.dsn#">
             select 0 as ConMonLoc,
             0 as ConMonE from dual
           </cfquery>
         </cfif>
    <cfreturn rsComCon>
 </cffunction>
  <cffunction name="ComisionesArticulos" returntype="any">
           <cfargument name="INTARC"           type="string" required="yes">
           <cfargument name="Cfunc_comisionesgasto" type="string" required="yes">
           <cfargument name="Ecodigo"  	       type="numeric" required="yes">
           <cfargument name="ETdocumento"      type="string" required="yes">
           <cfargument name="CCTcodigo"        type="string" required="yes">
           <cfargument name="FATmontomin"      type="numeric">
           <cfargument name="FATmontomax"      type="numeric">
           <cfargument name="FATaplicamontos"  type="numeric">
           <cfargument name="Total"            type="numeric" required="yes">
           <cfargument name="FPtc"             type="numeric" required="yes">
           <cfargument name="FPmontoori"       type="numeric" required="yes">
           <cfargument name="FATporccom"       type="numeric" required="yes">
           <cfargument name="CCTtipo"          type="string"  required="yes">
           <cfargument name="Anulacion"        type="boolean" required="yes">
           <cfargument name="FATdescripcion"   type="string" required="yes">
           <cfargument name="Monloc"           type="numeric" required="yes">
           <cfargument name="Mcodigo"          type="numeric" required="yes">
           <cfargument name="Periodo"          type="numeric" required="yes">
           <cfargument name="Mes"              type="numeric" required="yes">
           <cfargument name="Cuentacaja"       type="numeric" required="yes">
           <cfargument name="CFCuentacaja"     type="numeric" required="yes">
           <cfargument name="FCid"             type="numeric" required="yes">
           <cfargument name="ETnumero"         type="numeric" required="yes">
           <cfargument name="AnulacionParcial" type="boolean" required="yes">
           <cfargument name="LineasDetalle"    type="string" required="yes">
           <cfargument name="Comision"         type="numeric" required="yes" default="-1">
           <cfargument name="FATNOsumaComision"  type="numeric" required="yes" default="0">
           <cfargument name="FATid"            type="numeric" required="yes">

           <cfquery name="rsTarjeta" datasource="#Session.DSN#">
            select FATdescripcion,
                FATporccom,FATcxpsocio, SNcodigo, FATmontomin,FATmontomax,FATaplicamontos,FATNOsumaComision,CFcuentaCobro, CFid,FATCtaCobrotarjeta, FATCFtarjeta,FATNOaplicaAnulacion
            from FATarjetas j
            where j.FATid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FATid#">
          </cfquery>

           <cfif rsTarjeta.FATCtaCobrotarjeta eq 1 and len(trim(#rsTarjeta.CFcuentaCobro#)) eq 0>
               <cfthrow message ="#arguments.FATdescripcion# requiere una cuenta de cobro pues el gasto no va a la cuenta del centro funcional. Sino la administracion.">
            </cfif>

            <cfif rsTarjeta.FATCFtarjeta eq 1 and len(trim(#rsTarjeta.CFid#)) eq 0>
               <cfthrow message ="#arguments.FATdescripcion# requiere un centro funcional para registro de la cuenta.">
            </cfif>
        <cfset GeneraMov = true>
        <cfif  arguments.AnulacionParcial eq true>
         <cfif rsTarjeta.FATNOaplicaAnulacion eq 1>
             <cfset GeneraMov = false>
         </cfif>
        </cfif>
       <cfif  arguments.Anulacion eq true>
         <cfif rsTarjeta.FATNOaplicaAnulacion eq 1>
             <cfset GeneraMov = false>
         </cfif>
      </cfif>

      <cfif GeneraMov eq true>
           <cfquery name="rs" datasource="#session.dsn#">
		         insert #arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE,
                 INTllave1,INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona, INTidPersona)
			     select 'FAFC', 1,'#arguments.ETdocumento#', '#arguments.CCTcodigo#',
               <!---
                      case when (#arguments.FATmontomin# = #arguments.FATmontomax#) and (#arguments.FATaplicamontos# = 1) then
                         round((#arguments.FATmontomin# * ((b.DTtotal)/#arguments.Total#))* (#arguments.FPtc#),2)
                      when (round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)*((b.DTtotal)/#arguments.Total#)) * (#arguments.FPtc#),2)) > #arguments.FATmontomax# and (#arguments.FATaplicamontos# = 1)  then
                         round((#Arguments.FATmontomax# * ((b.DTtotal)/#Arguments.Total#))* (#Arguments.FPtc#),2)
                      when (round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)*((b.DTtotal)/#arguments.Total#)) * (#arguments.FPtc#),2)) < #Arguments.FATmontomin# and (#Arguments.FATaplicamontos# = 1)  then
                         round((#arguments.FATmontomin# * ((b.DTtotal)/#Arguments.Total#))* (#Arguments.FPtc#),2)
                       <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal)/#arguments.FPmontoori#))  * (#arguments.FPtc#),2)
                       <cfelse>
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal)/#arguments.Total#)) * (#arguments.FPtc#),2)
                       </cfif>
                  end,----->
                      <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                        case when  (#rsTarjeta.FATaplicamontos# = 1) then
                         round((#arguments.Comision# * ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.FPmontoori#))* (#arguments.FPtc#),2)
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2))	* (#arguments.FPtc#),2)
                       <cfelse>
                       case when  (#rsTarjeta.FATaplicamontos# = 1) then
                         round((#arguments.Comision# * ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.Total#))* (#arguments.FPtc#),2)
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.Total#))	* (#arguments.FPtc#),2)
                       </cfif>
                  end,
                   case when '#arguments.CCTtipo#' = 'D' then 'D' else 'C' end,
		            '<cfif Arguments.Anulacion>Reversion </cfif>Comisiones: ' #_Cat# '#arguments.FATdescripcion#',
		            <cf_dbfunction name="to_char"	args="getdate(),112">,
		            case when #arguments.Monloc# != #arguments.Mcodigo# then #arguments.FPtc# else 1.00 end,
		            #arguments.Periodo#, #arguments.Mes#,
		            <cfif not Arguments.Anulacion>0, <cfif rsTarjeta.FATCtaCobrotarjeta eq 1>#rsTarjeta.CFcuentaCobro# <cfelse> cfunc.CFcuenta</cfif>
		              <cfelse> #Arguments.Cuentacaja#,#Arguments.CFCuentacaja# </cfif>,
		            #Arguments.Mcodigo#, d.Ocodigo,

               <!----     case when (#Arguments.FATmontomin# = #Arguments.FATmontomax#) and (#Arguments.FATaplicamontos# = 1)  then
                       round(((#Arguments.FATmontomax# / #Arguments.FPtc#)* ((b.DTtotal)/#Arguments.Total#)),2)
                      when ( round((round(#Arguments.FPmontoori#*#Arguments.FATporccom#/100.00,2) * ((b.DTtotal)/#Arguments.Total#)),2)) > (#Arguments.FATmontomax# / #Arguments.FPtc#) and (#Arguments.FATaplicamontos# = 1) then
                       round(((#Arguments.FATmontomax# / #Arguments.FPtc#)* ((b.DTtotal)/#Arguments.Total#)),2)
                      when ( round((round(#Arguments.FPmontoori#*#Arguments.FATporccom#/100.00,2) * ((b.DTtotal)/#Arguments.Total#)),2)) < (#Arguments.FATmontomin# / #Arguments.FPtc#) and (#Arguments.FATaplicamontos# = 1) then
                       round(((#Arguments.FATmontomin# / #Arguments.FPtc#)* ((b.DTtotal)/#Arguments.Total#)),2)
                     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal)/#Arguments.FPmontoori#)),2)
                     <cfelse>
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal)/#Arguments.Total#)),2)
                     </cfif>
                   end,    ------>

                     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                      case when (#rsTarjeta.FATaplicamontos# = 1)  then
                       round(((#Arguments.Comision# / #Arguments.FPtc#)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#Arguments.FPmontoori#)),2)
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2)),2)
                     <cfelse>
                      case when (#rsTarjeta.FATaplicamontos# = 1)  then
                       round(((#Arguments.Comision# / #Arguments.FPtc#)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#Arguments.Total#)),2)
                     else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal + coalesce(b.DTimpuesto,0))/#Arguments.Total#)),2)
                     </cfif>
                   end,
                   <cf_dbfunction name="to_char"	args="a.FCid">, <cf_dbfunction name="to_char"	args="a.ETnumero">,
                   b.DTdescripcion, '#Arguments.ETdocumento#', case when a.CDCcodigo is not null then '03' else '01' end, case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
			        from ETransacciones a
		        inner join DTransacciones b on a.FCid = b.FCid and a.ETnumero = b.ETnumero  and a.Ecodigo = b.Ecodigo
		        inner join #arguments.Cfunc_comisionesgasto# cfunc on b.CFid = cfunc.CFid
		        inner join CCTransacciones c  on a.CCTcodigo = c.CCTcodigo and a.Ecodigo = c.Ecodigo
		        inner join CFuncional d
		         <cfif rsTarjeta.FATCFtarjeta eq 1>
		           on d.CFid = #rsTarjeta.CFid#
		         <cfelse>
		           on b.CFid = d.CFid
		         </cfif>
		         and b.Ecodigo = d.Ecodigo
                inner join SNegocios sn on a.Ecodigo = sn.Ecodigo and a.SNcodigo = sn.SNcodigo
		        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
		          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and b.DTtipo = 'A' and b.DTtotal!= 0 and b.DTborrado = 0
                 <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                  and b.NC_DTlinea in (#arguments.LineasDetalle#)
                 </cfif>
         </cfquery>
         <cfquery name="rsComArt" datasource="#session.dsn#">
            select


                  <!---     case when (#arguments.FATmontomin# = #arguments.FATmontomax#) and (#arguments.FATaplicamontos# = 1) then
                         round((#arguments.FATmontomin# * ((b.DTtotal)/#arguments.Total#))* (#arguments.FPtc#),2)
                      when (round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)*((b.DTtotal)/#arguments.Total#)) * (#arguments.FPtc#),2)) > #arguments.FATmontomax# and (#arguments.FATaplicamontos# = 1)  then
                         round((#Arguments.FATmontomax# * ((b.DTtotal)/#Arguments.Total#))* (#Arguments.FPtc#),2)
                      when (round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)*((b.DTtotal)/#arguments.Total#)) * (#arguments.FPtc#),2)) < #Arguments.FATmontomin# and (#Arguments.FATaplicamontos# = 1)  then
                         round((#arguments.FATmontomin# * ((b.DTtotal)/#Arguments.Total#))* (#Arguments.FPtc#),2)
                       <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal)/#arguments.FPmontoori#))  * (#arguments.FPtc#),2)
                       <cfelse>
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal)/#arguments.Total#)) * (#arguments.FPtc#),2)
                       </cfif>
                     end
                     ---->
                      <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                       case when  (#rsTarjeta.FATaplicamontos# = 1) then
                         round((#arguments.Comision# * ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.FPmontoori#))* (#arguments.FPtc#),2)
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2))	* (#arguments.FPtc#),2)
                       <cfelse>
                       case when (#rsTarjeta.FATaplicamontos# = 1) then
                         round((#arguments.Comision# * ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.Total#))* (#arguments.FPtc#),2)
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal +coalesce(b.DTimpuesto,0) )/#arguments.Total#))	* (#arguments.FPtc#),2)
                       </cfif>
                  end

                  as ArtMonLoc,
                  <!----     case when (#Arguments.FATmontomin# = #Arguments.FATmontomax#) and (#Arguments.FATaplicamontos# = 1)  then
                       round(((#Arguments.FATmontomax# / #Arguments.FPtc#)* ((b.DTtotal)/#Arguments.Total#)),2)
                      when ( round((round(#Arguments.FPmontoori#*#Arguments.FATporccom#/100.00,2) * ((b.DTtotal)/#Arguments.Total#)),2)) > (#Arguments.FATmontomax# / #Arguments.FPtc#) and (#Arguments.FATaplicamontos# = 1) then
                       round(((#Arguments.FATmontomax# / #Arguments.FPtc#)* ((b.DTtotal)/#Arguments.Total#)),2)
                      when ( round((round(#Arguments.FPmontoori#*#Arguments.FATporccom#/100.00,2) * ((b.DTtotal)/#Arguments.Total#)),2)) < (#Arguments.FATmontomin# / #Arguments.FPtc#) and (#Arguments.FATaplicamontos# = 1) then
                       round(((#Arguments.FATmontomin# / #Arguments.FPtc#)* ((b.DTtotal)/#Arguments.Total#)),2)
                     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal)/#Arguments.FPmontoori#)),2)
                      <cfelse>
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal)/#Arguments.Total#)),2)
                      </cfif>
                    end
                            ---->
                     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                        case when (#rsTarjeta.FATaplicamontos# = 1)  then
                          round(((#Arguments.Comision# / #Arguments.FPtc#)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#Arguments.FPmontoori#)),2)
                        else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2)),2)
                     <cfelse>
                        case when (#rsTarjeta.FATaplicamontos# = 1)  then
                          round(((#Arguments.Comision# / #Arguments.FPtc#)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#Arguments.Total#)),2)
                        else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#Arguments.Total#)),2)
                      </cfif>
                   end
                   as ArtMonE
			        from ETransacciones a
		        inner join DTransacciones b on a.FCid = b.FCid and a.ETnumero = b.ETnumero  and a.Ecodigo = b.Ecodigo
		        inner join #arguments.Cfunc_comisionesgasto# cfunc on b.CFid = cfunc.CFid
		        inner join CCTransacciones c  on a.CCTcodigo = c.CCTcodigo and a.Ecodigo = c.Ecodigo
		        inner join CFuncional d
		         <cfif rsTarjeta.FATCFtarjeta eq 1>
		           on d.CFid = #rsTarjeta.CFid#
		         <cfelse>
		           on b.CFid = d.CFid
		         </cfif>
		         and b.Ecodigo = d.Ecodigo
                inner join SNegocios sn on a.Ecodigo = sn.Ecodigo and a.SNcodigo = sn.SNcodigo
		        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
		          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and b.DTtipo = 'A' and b.DTtotal!= 0 and b.DTborrado = 0
                 <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                  and b.NC_DTlinea in (#arguments.LineasDetalle#)
                 </cfif>
         </cfquery>
      </cfif>    <!---- fin del if de GeneraMov ----->
         <cfif isdefined('rsComArt') and  rsComArt.recordcount eq 0 or FATNOsumaComision eq 1>
           <cfquery name="rsComArt" datasource="#session.dsn#">
             select 0 as ArtMonLoc,
             0 as ArtMonE from dual
           </cfquery>
         </cfif>
         <cfif not isdefined('rsComArt')>
           <cfquery name="rsComArt" datasource="#session.dsn#">
             select 0 as ArtMonLoc,
             0 as ArtMonE from dual
           </cfquery>
         </cfif>
    <cfreturn rsComArt>
 </cffunction>
 <cffunction name="ConsComisionesConceptos" returntype="any">
           <cfargument name="INTARC"           type="string" required="yes">
           <cfargument name="Cfunc_comisionesgasto" type="string" required="yes">
           <cfargument name="Ecodigo"  	       type="numeric" required="yes">
           <cfargument name="ETdocumento"      type="string" required="yes">
           <cfargument name="CCTcodigo"        type="string" required="yes">
           <cfargument name="FATmontomin"      type="numeric" required="yes">
           <cfargument name="FATmontomax"      type="numeric" required="yes">
           <cfargument name="FATaplicamontos"  type="numeric" required="yes" default= "0">
           <cfargument name="Total"            type="numeric" required="yes">
           <cfargument name="FPtc"             type="numeric" required="yes">
           <cfargument name="FPmontoori"       type="numeric" required="yes">
           <cfargument name="FATporccom"       type="numeric" required="yes">
           <cfargument name="CCTtipo"          type="string"  required="yes">
           <cfargument name="Anulacion"        type="boolean" required="yes">
           <cfargument name="FATdescripcion"   type="string" required="yes">
           <cfargument name="Monloc"           type="numeric" required="yes">
           <cfargument name="Mcodigo"          type="numeric" required="yes">
           <cfargument name="Periodo"          type="numeric" required="yes">
           <cfargument name="Mes"              type="numeric" required="yes">
           <cfargument name="Cuentacaja"       type="numeric" required="yes">
           <cfargument name="FCid"             type="numeric" required="yes">
           <cfargument name="ETnumero"         type="numeric" required="yes">
           <cfargument name="AnulacionParcial" type="boolean" required="yes">
           <cfargument name="LineasDetalle"    type="string" required="yes">


        <cfset LvarComConLoc= 0>
         <cfquery name="rsCom" datasource="#session.dsn#">
			     select
                         round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)),2) as com
                         from dual
        </cfquery>
         <cfset LvarComConLoc= LvarComConLoc + rsCom.com >

        <cfif isdefined('Arguments.FATaplicamontos') and  Arguments.FATaplicamontos eq 1 >
	     	<cfif LvarComConLoc gt Arguments.FATmontomax >
	          <cfset LvarComConLoc  = Arguments.FATmontomax>
	        </cfif>
	        <cfif LvarComConLoc lt Arguments.FATmontomin>
	          <cfset LvarComConLoc  = Arguments.FATmontomin>
	        </cfif>
	        <cfif Arguments.FATmontomax eq Arguments.FATmontomin>
	      	   <cfset LvarComConLoc  = Arguments.FATmontomax>
	        </cfif>
        </cfif>

    <cfreturn LvarComConLoc >
 </cffunction>
  <cffunction name="ConsComisionesArticulos" returntype="any">
           <cfargument name="INTARC"           type="string" required="yes">
           <cfargument name="Cfunc_comisionesgasto" type="string" required="yes">
           <cfargument name="Ecodigo"  	       type="numeric" required="yes">
           <cfargument name="ETdocumento"      type="string" required="yes">
           <cfargument name="CCTcodigo"        type="string" required="yes">
           <cfargument name="FATmontomin"      type="numeric" required="yes">
           <cfargument name="FATmontomax"      type="numeric" required="yes">
           <cfargument name="FATaplicamontos"  type="numeric" required="yes">
           <cfargument name="Total"            type="numeric" required="yes">
           <cfargument name="FPtc"             type="numeric" required="yes">
           <cfargument name="FPmontoori"       type="numeric" required="yes">
           <cfargument name="FATporccom"       type="numeric" required="yes">
           <cfargument name="CCTtipo"          type="string"  required="yes">
           <cfargument name="Anulacion"        type="boolean" required="yes">
           <cfargument name="FATdescripcion"   type="string" required="yes">
           <cfargument name="Monloc"           type="numeric" required="yes">
           <cfargument name="Mcodigo"          type="numeric" required="yes">
           <cfargument name="Periodo"          type="numeric" required="yes">
           <cfargument name="Mes"              type="numeric" required="yes">
           <cfargument name="Cuentacaja"       type="numeric" required="yes">
           <cfargument name="FCid"             type="numeric" required="yes">
           <cfargument name="ETnumero"         type="numeric" required="yes">
           <cfargument name="AnulacionParcial" type="boolean" required="yes">
           <cfargument name="LineasDetalle"    type="string" required="yes">

          <cfquery name="rsComArt" datasource="#session.dsn#">
            select
                       <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2))	* (#arguments.FPtc#),2)
                       <cfelse>
                       else  round((round(#arguments.FPmontoori#*(#arguments.FATporccom#/100.00),2)* ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#arguments.Total#))	* (#arguments.FPtc#),2)
                       </cfif>  as ArtMonLoc,
                     <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2)),2)
                      <cfelse>
                      else  round((round(#Arguments.FPmontoori#*(#Arguments.FATporccom#)/(100.00),2) * ((b.DTtotal + coalesce(b.DTimpuesto,0) )/#Arguments.Total#)),2)
                      </cfif>   as ArtMonE
			        from ETransacciones a
		        inner join DTransacciones b on a.FCid = b.FCid and a.ETnumero = b.ETnumero  and a.Ecodigo = b.Ecodigo
		        inner join #arguments.Cfunc_comisionesgasto# cfunc on b.CFid = cfunc.CFid
		        inner join CCTransacciones c  on a.CCTcodigo = c.CCTcodigo and a.Ecodigo = c.Ecodigo
		        inner join CFuncional d on b.CFid = d.CFid and b.Ecodigo = d.Ecodigo
                inner join SNegocios sn on a.Ecodigo = sn.Ecodigo and a.SNcodigo = sn.SNcodigo
		        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#"> and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
		          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#"> and b.DTtipo = 'A' and b.DTtotal!= 0 and b.DTborrado = 0
                 <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                  and b.NC_DTlinea in (#arguments.LineasDetalle#)
                 </cfif>
         </cfquery>
         <cfif rsComArt.recordcount eq 0>
           <cfquery name="rsComArt" datasource="#session.dsn#">
             select 0 as ArtMonLoc,
             0 as ArtMonE from dual
           </cfquery>
         </cfif>
          <cfset LvarComArtLoc = 0>

         <cfloop  query="rsComArt">
          <cfset LvarComArtLoc =   rsComArt.ArtMonLoc>
        </cfloop>
    <cfreturn LvarComArtLoc>
 </cffunction>
  <cffunction name="ComisionesTJ" returntype="any">
           <cfargument name="INTARC"           type="string" required="yes">
           <cfargument name="Cfunc_comisionesgasto" type="string" required="false">
           <cfargument name="Ecodigo"  	       type="numeric" required="yes">
           <cfargument name="ETdocumento"      type="string"  required="false">
           <cfargument name="referencia"       type="string"  required="false">
           <cfargument name="Pcodigo"          type="string"  required="yes">
           <cfargument name="CCTcodigo"        type="string"  required="yes">
           <cfargument name="Ocodigo"          type="string"  required="yes">
           <cfargument name="FATmontomin"      type="numeric" required="false">
           <cfargument name="FATmontomax"      type="numeric" required="false">
           <cfargument name="FATaplicamontos"  type="numeric" required="false">
           <cfargument name="Total"            type="numeric" required="false">
           <cfargument name="FPtc"             type="numeric" required="false">
           <cfargument name="FPmontoori"       type="numeric" required="false">
           <cfargument name="FATporccom"       type="numeric" required="false">
           <cfargument name="CCTtipo"          type="string"  required="false">
           <cfargument name="Anulacion"        type="boolean" required="false">
           <cfargument name="FATdescripcion"   type="string"  required="false">
           <cfargument name="Monloc"           type="numeric" required="false">
           <cfargument name="Mcodigo"          type="numeric" required="false">
           <cfargument name="Periodo"          type="numeric" required="false">
           <cfargument name="Mes"              type="numeric" required="false">
           <cfargument name="Cuentacaja"       type="numeric" required="false">
           <cfargument name="CFCuentacaja"     type="numeric" required="false">
           <cfargument name="FCid"             type="numeric" required="false">
           <cfargument name="ETnumero"         type="numeric" required="false">
           <cfargument name="AnulacionParcial" type="boolean" required="false">
           <cfargument name="LineasDetalle"    type="string"  required="false">
           <cfargument name="Comision"         type="numeric" required="false" default="-1">
           <cfargument name="FATNOsumaComision"type="numeric" required="false" default="0">
           <cfargument name="FATid"            type="numeric" required="yes">
           <cfargument name="CC"               type="numeric" required="false">

           <cfquery name="rsTarjeta" datasource="#Session.DSN#">
            select FATdescripcion,
                FATporccom,FATcxpsocio, SNcodigo, FATmontomin,FATmontomax,FATaplicamontos,FATNOsumaComision,CFcuentaCobro,CFcuentaComision,CFid ,FATCtaCobrotarjeta, FATCFtarjeta,FATNOaplicaAnulacion
            from FATarjetas j
            where j.FATid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FATid#">
          </cfquery>

            <cfif rsTarjeta.FATCtaCobrotarjeta eq 1 and len(trim(#rsTarjeta.CFcuentaCobro#)) eq 0>
               <cfthrow message ="#arguments.FATdescripcion# requiere una cuenta de cobro pues el gasto no va a la cuenta del centro funcional. Sino la administracion.">
            </cfif>
             <cfif rsTarjeta.FATCFtarjeta eq 1 and len(trim(#rsTarjeta.CFid#)) eq 0>
               <cfthrow message ="#arguments.FATdescripcion# requiere un centro funcional para registro de la cuenta.">
            </cfif>
          <cfif len(trim(rsTarjeta.CFcuentaComision)) EQ 0>
            <cf_errorCode code = "52245"
                    msg  = "La cuenta de comisión es requerida. </br>
                    Favor ir al catalogo de tarjetas en el modulo de facturación y agregar la cuenta de comisión a la tarjeta: <BR>@errorDat_1@"
                    errorDat_1="#rsTarjeta.FATdescripcion#"
            >
          </cfif>
         <cfquery name="rs" datasource="#session.dsn#">
		         insert #arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta,CFcuenta, Mcodigo, Ocodigo, INTMOE
				  )
			     select 'FARE', 1,coalesce('#arguments.ETdocumento#','#arguments.Pcodigo#'), coalesce('#arguments.referencia#','#arguments.CCTcodigo#'),
                       round(
                                       (round(#arguments.FPmontoori#*
                                                 (#rsTarjeta.FATporccom#/100.00)
                                           ,2)
                                       )
                                       * (#arguments.FPtc#)
                               ,2),

                  'D',
		            'Comisiones: ' #_Cat# '#rsTarjeta.FATdescripcion#',
		            <cf_dbfunction name="to_char"	args="getdate(),112">,
		            case when #arguments.Monloc# != #arguments.Mcodigo# then #arguments.FPtc# else 1.00 end,
		            #arguments.Periodo#, #arguments.Mes#,
		          0,#rsTarjeta.CFcuentaComision# ,
		            #Arguments.Mcodigo#, #arguments.Ocodigo#,
                   round((round(#arguments.FPmontoori#*(#rsTarjeta.FATporccom#/100.00),2)),2)

			        from Pagos a
		        where a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
         </cfquery>
          <cfquery name="rsComCon" datasource="#session.dsn#">
			     select
                      round(
                                       (round(#arguments.FPmontoori#*
                                                 (#rsTarjeta.FATporccom#/100.00)
                                           ,2)
                                       )
                                       * (#arguments.FPtc#)
                               ,2)
                   as ConMonLoc,
                   round((round(#arguments.FPmontoori#*(#rsTarjeta.FATporccom#/100.00),2)),2)
                    as ConMonE
            from Pagos a
            where a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.CCTcodigo#">
                  and a.Pcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.Pcodigo#">
         </cfquery>
    <cfreturn rsComCon>
 </cffunction>

<!----------------------------------------------------------------------------------------------------------->
<!--- Si no contabiliza, solo aplica, entonces, NO ejecuta contabilidad, presupuesto y mucho de los auxiliares --->
<!--- Si contabiliza hace todo lo que no se hizo en el cambio pasado --->
 <cffunction name="AplicarTransaccionFA">
   <cfargument name="ETnumero">
   <cfargument name="FCid">
   <cfargument name="Usuario" 						default="#session.Usucodigo#">
   <cfargument name="InvocarFacturacionElectronica" required="false" default="true"> <!--- Indica si hay que invocar el envio a facturacion electronica --->
   <cfargument name="InvocarInterfaz718" 			required="false" default="true"> <!--- Inserta en la tabla de comisiones --->
   <cfargument name="InvocarInterfaz719" 			required="false" default="true"> <!--- Realiza el calculo de comisiones --->
   <cfargument name="Contabilizar" 					required="false" type="string"  default="todos">
   <cfargument name="TempDiferencial" 				required="no" 	 type="string"  hint="Nombre de la tabla temporal de diferencial">
   <cfargument name="TempPresupuesto" 				required="no" 	 type="string"  hint="Nomnbre de la tabla temporal de presupuesto">
   <cfargument name="TempCostos" 					required="no" 	 type="string"  hint="Nomnbre de la tabla temporal de Costos">
   <cfargument name="TempConta" 					required="no" 	 type="string"  hint="Nomnbre de la tabla temporal de Contabilidad">
   <cfargument name="Ecodigo" 						required="no" 	 type="numeric" hint="Codigo Interno de la empresa">
   <cfargument name="Usucodigo" 					required="no" 	 type="numeric" hint="Codigo Interno del Usuario">
   <cfargument name="Conexion" 						required="no" 	 type="numeric" hint="Nombre del DataSource">
   <cfargument name="PrioridadEnvio"      required="false" type="numeric" default="0">
   <cfargument name="CPNAPmoduloOri"      type="string"  required="false" default="">

   <cfif NOT ISDEFINED('Arguments.Ecodigo') and ISDEFINED('Session.Ecodigo')>
   		<cfset Arguments.Ecodigo = Session.Ecodigo>
   </cfif>
   <cfif NOT ISDEFINED('Arguments.Usucodigo') and ISDEFINED('Session.Usucodigo')>
   		<cfset Arguments.Ecodigo = Session.Ecodigo>
   </cfif>
   <cfif NOT ISDEFINED('Arguments.Conexion') and ISDEFINED('Session.dsn')>
   		<cfset Arguments.Conexion = Session.dsn>
   </cfif>

   <cfif isdefined('arguments.Contabilizar') and arguments.Contabilizar neq 'conta' and arguments.Contabilizar neq 'aplica' and  arguments.Contabilizar neq 'todos'>
        <cf_ErrorCode code="-1" msg="EL argumento Contabilizar no tiene ninguno de los siguientes valores:  conta, aplica, todos. Proceso cancelado.">
   </cfif>

   <!---Esta seccion no se ejecuta si se invoca desde la tarea programada--->
   <cfif isdefined('arguments.Contabilizar') and arguments.Contabilizar neq 'conta'>
		 <cfquery name = "rsVerificaFechas" datasource = "#session.dsn#">
		  select  a.ETfecha
		  from ETransacciones a
		  where a.Ecodigo  = #session.Ecodigo#
			and a.ETnumero = #Arguments.ETnumero#
			and a.FCid     = #Arguments.FCid#
		</cfquery>

		<cfset LvarPeriodo = datepart("yyyy",rsVerificaFechas.ETfecha)>
		<cfset LvarMes     = datepart("m",rsVerificaFechas.ETfecha)>

		<!---Se obtiene el mes auxiliar--->
		<cfquery name="mes" datasource="#session.DSN#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			  and Pcodigo = 60
		</cfquery>
		<!---Se obtiene el periodo auxiliar --->
		<cfquery name="periodo" datasource="#session.DSN#" cachedwithin="#CreateTimeSpan(0,0,20,0)#">
			select Pvalor
			from Parametros
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and Pcodigo = 50
		</cfquery>
		<cfif mes.Pvalor neq LvarMes>
			 <cf_ErrorCode code="-1" msg="El mes de la factura #LvarMes# es diferente al mes de auxiliares: #mes.Pvalor#. Favor verificar fechas">
		</cfif>
		<cfif periodo.Pvalor neq LvarPeriodo>
		   <cf_ErrorCode code="-1" msg="El Periodo de la factura #LvarPeriodo# es diferente al periodo de auxiliares: #periodo.Pvalor#. Favor verificar fechas">
		</cfif>
	</cfif>

   <cfif Arguments.contabilizar EQ 'todos' or arguments.contabilizar EQ 'conta'>
          <!---Tabla de Contabilidad--->
		  <!---<cfif isdefined('Arguments.TempConta')>
		  	   <cfset INTARC         = Arguments.TempConta>
			   <cfset Request.intarc = Arguments.TempConta>
		  <cfelse>--->
		  	   <cfinvoke component="sif.Componentes.CG_GeneraAsiento" Conexion="#session.dsn#"   method="CreaIntarc"          returnvariable="INTARC"  CrearPresupuesto="false"/>
		<!---  </cfif>
		  <cfquery datasource="#session.dsn#">
		   		delete from #INTARC#
		  </cfquery>--->

          <!---Tabla de Costos--->
<!---		  <cfif isdefined('Arguments.TempCostos')>
		  		<cfset Tb_Calculo = Arguments.TempCostos>
		  <cfelse>
--->		  		 <cfinvoke component="sif.fa.operacion.CostosAuto"      Conexion="#session.dsn#"   method="CreaCostos"          returnvariable="Tb_Calculo"/>
		 <!--- </cfif>
		  <cfquery datasource="#session.dsn#">
		   		delete from #Tb_Calculo#
		  </cfquery>--->
		  <!---Tabla de Presupuesto, quitar el false cuando se pasen las demas tablas creadas en PRES_Presupuesto.CreaTablaIntPresupuesto--->
		 <!--- <cfif isdefined('Arguments.TempPresupuesto') AND FALSE>
		  	   	<cfset IntPresup 		       = Arguments.TempPresupuesto>
				<cfset Request.IntPresupuesto  = Arguments.TempPresupuesto>
		  <cfelse> --->
		  	  	<cfinvoke component="sif.Componentes.PRES_Presupuesto" Conexion = "#session.dsn#" method="CreaTablaIntPresupuesto" returnvariable="IntPresup"/>
		  <!---</cfif>
		  <cfquery datasource="#session.dsn#">
		   		delete from #IntPresup#
		  </cfquery>--->
		  <!---Tabla de Diferencial--->
		  <!---<cfif isdefined('Arguments.TempDiferencial')>
		  	  <cfset DIFERENCIAL = Arguments.TempDiferencial>
		  <cfelse>--->
		  	  <cfset DIFERENCIAL = CreateTempDiferencial()>
		 <!--- </cfif>
		   <cfquery datasource="#session.dsn#">
		   		delete from #DIFERENCIAL#
		  </cfquery>--->
   </cfif>

   <cfquery name="rsVerificaEstado" datasource = "#session.dsn#">
      select a.ETexterna,a.ETestado, a.ETfecha, round(a.ETtotal- (COALESCE(Rporcentaje,1)/100 * a.ETtotal),2) as ETtotal  , a.Mcodigo,ct.CCTvencim, a.CCTcodigo,
	  (select Count(1)
	   	from DTransacciones  dt
        	inner join FADRecuperacion fd
           		on fd.DTlinea   = dt.DTlinea
               and fd.Ecodigo   = dt.Ecodigo
        	inner join FAERecuperacion fe
          		on fe.FAERid    = fd.FAERid
               and fe.Ecodigo   = fd.Ecodigo
		 where a.ETnumero = dt.ETnumero
           and a.FCid     = dt.FCid
           and a.Ecodigo  = dt.Ecodigo) Existe
      from ETransacciones a
      inner join CCTransacciones ct
        on a.CCTcodigo = ct.CCTcodigo
        and a.Ecodigo = ct.Ecodigo
      LEFT outer join Retenciones r
         on a.Rcodigo = r.Rcodigo
        and a.Ecodigo = r.Ecodigo
      where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
        and a.FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
    </cfquery>

    <!---  APLICAR APLICAR APLICAR APLICAR --->
	<cfif Arguments.Contabilizar EQ 'aplica' or Arguments.Contabilizar EQ 'todos'>
  		<cfoutput>
			<!---  A las lineas que tengan vuelto, se les resta al pago el vuelto para hacer los asientos--->
			<cfquery name="upPagosVuelto" datasource="#session.dsn#">
			  update FPagos
				set FPagoDoc = (FPagoDoc - FPVuelto)
			  where ETnumero = #Arguments.ETnumero#
				and FCid = #Arguments.FCid#
				and Tipo = 'E'
				and FPVuelto <> 0
			</cfquery>

			<cfif rsVerificaEstado.ETestado NEQ "T">
				<cfthrow message="La Factura no se puede Aplicar porque no está en estado Terminada!">
			</cfif>


       <!--- Valida si los costos e ingresos automaticos de los centros funcionales estan bien configurados --->
        <cfquery name = "rsDetalle" datasource = "#session.dsn#">
            select  cf.CFcodigo
              from DTransacciones a
             inner join CfuncionalConc cfc
                on a.CFid =  cfc.CFid
             inner join CFuncional cf
                on a.CFid = cf.CFid
            where a.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
              and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ETnumero#">
              and a.FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
              and ( (select count(1) from CfuncionalConc cc where CFid = a.CFid  ) %  2) <> 0
              group by cf.CFcodigo
        </cfquery>

        <cfif rsDetalle.recordcount>
          <cfset LvarCodigos = "">
          <cfloop query="rsDetalle">
              <cfif rsDetalle.recordcount gt 1>
                  <cfset LvarCodigos =  LvarCodigos & " " &  CFcodigo & ",">
               <cfelse>
                  <cfset LvarCodigos =  LvarCodigos & " " &  CFcodigo>
              </cfif>

          </cfloop>
           <cf_errorCode  code = "-1" msg = "Favor revisar la configuración de costos e ingresos automáticos del centro funcional: #LvarCodigos# ">
        </cfif>
<cf_dumptable var="#INTARC#">

			<cfquery name="rsPagosAsoc" datasource="#session.dsn#">
				select FPmontolocal
					from FPagos
				where ETnumero = #Arguments.ETnumero#
				  and FCid     = #Arguments.FCid#
				  and FPagoDoc <> 0
			</cfquery>
			<cfquery name="rsMonedaLoc" datasource="#session.dsn#">
			   select e.Mcodigo from Empresas es
			   inner join Empresa e
				 on es.cliente_empresarial = e.CEcodigo
			   where es.Ecodigo = #session.Ecodigo#
			</cfquery>
			<cfset LvarMonedaLocal = rsMonedaLoc.Mcodigo>
            <!--- Si encuentra un pago en moneda local, pero con un tipo de cambio
			 diferente a 1, lo actualiza a 1 ----->
			<cfquery  datasource="#session.dsn#">
			     update FPagos
                     set FPtc = 1
                    where ETnumero = #Arguments.ETnumero#
                      and FCid = #Arguments.FCid#
                      and Mcodigo = #LvarMonedaLocal#
                      and FPtc <> 1
			</cfquery>
            <cfquery name="rsPagosAsoc" datasource="#session.dsn#">
				select sum(FPagoDoc) as pagoTotal
				from FPagos
				where ETnumero = #Arguments.ETnumero#
				  and FCid = #Arguments.FCid#
				  and FPagoDoc <> 0
			</cfquery>

        	<cfif rsVerificaEstado.CCTvencim eq -1>
				<cfif rsPagosAsoc.recordcount eq 0>
				 	<cfthrow message="No existe un pago asociado a la factura.">
				</cfif>
				<!---- Nueva validacion para los totales ------>
				<cfquery name="rsLineasDetalleTerminar" datasource="#Session.DSN#">
				  select count(1)  as cantidadLineas
				  from DTransacciones
				  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
					  and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
					  and DTborrado = 0
				</cfquery>
				<!--- Subtotal --->
				<cfquery name="rsSubTotal" datasource="#Session.DSN#">
				  select sum(DTtotal) as subtotal
				  from DTransacciones
				  where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
					and ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
					and DTborrado = 0
				</cfquery>
                <cfquery name="rsTipo" datasource="#Session.DSN#">
					select  CCTvencim
					from ETransacciones  a
					 inner join CCTransacciones b
					  on a.CCTcodigo = b.CCTcodigo
					and  a.Ecodigo   = b.Ecodigo
					where  a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
					  and  a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
					  and  a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            	</cfquery><!---- Fin de la validacion de esos totales --->

            	<cfif rsPagosAsoc.pagoTotal  lt rsVerificaEstado.ETtotal>
					  <cfif rsVerificaEstado.ETtotal eq 0 and  rsSubtotal.subtotal eq 0 and rsLineasDetalleTerminar.cantidadLineas gt 0  and rsTipo.CCTvencim eq -1>
						   <!--- No hace nada, continua el codigo normal ----->
					  <cfelse>
							<cfset MensajeError = 'FA_funciones.El total facturado y el total pagado no son iguales. Proceso cancelado! </br>'>
							<cfset MensajeError &= 'verificaEstado:'&rsVerificaEstado.ETtotal&'</br>'>
							<cfset MensajeError &= 'SubTotal:'&rsSubtotal.subtotal&'</br>'>
							<cfset MensajeError &= 'LineasDetalleTerminar:'&rsLineasDetalleTerminar.cantidadLineas&'</br>'>
							<cfset MensajeError &= 'rsTipo:'&rsTipo.CCTvencim&'</br>'>
							<cfthrow message="#MensajeError#">
					 </cfif>
         		</cfif>
        </cfif>

        <cfquery name = "rsVerificaExistencia" datasource = "#session.dsn#">
          select d.Aid, d.Alm_Aid, d.DTlinea, d.DTcant, coalesce(a.Adescripcion,'') as Adescripcion
          from DTransacciones d
          left join Articulos a
            on a.Ecodigo = #session.Ecodigo#
            and a.Aid = d.Aid
          where d.Ecodigo  = #session.Ecodigo#
            and d.ETnumero = #Arguments.ETnumero#
            and d.FCid     = #Arguments.FCid#
            and d.DTtipo = 'A'
        </cfquery>
        <cfif rsVerificaExistencia.recordcount  gt 0>
           <cfloop query="rsVerificaExistencia">
              <cfquery name="rsSQL" datasource="#session.dsn#">
                select Eexistencia
                from Existencias
                where Aid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaExistencia.Aid#">
                  and Alm_Aid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsVerificaExistencia.Alm_Aid#">
                  and Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              </cfquery>
              <cfif isdefined('rsSQL') and rsSQL.recordcount gt 0>
                <cfif  rsVerificaExistencia.DTcant gt rsSQL.Eexistencia>
                    <cfthrow message="La existencia para el articulo: #rsVerificaExistencia.Adescripcion#, es de: #rsSQL.Eexistencia# unidades, la cantidad solicitada es #rsVerificaExistencia.DTcant#, es mayor. Proceso cancelado!">
                </cfif>
              </cfif>
            </cfloop>
        </cfif>

      <!----- Se le asigna el numero de documento, manteniendo el consecutivo del talonario ------>
      <!----- Buscamos el ID del talonario asignado a la caja --->
      <cfinvoke  method="SigTalonarioDoc" returnvariable="rsRIsig">
        <cfinvokeargument name="FCid"          value="#Arguments.FCid#">
        <cfinvokeargument name="CCTcodigo"     value="#rsVerificaEstado.CCTcodigo#">
      </cfinvoke>

      <cfquery name="rsUpdate" datasource="#session.dsn#">
         update ETransacciones set ETdocumento = #rsRIsig.RIsig#, ETserie = '#rsRIsig.RIserie#'
         where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
            and ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and FCid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
            and (ETdocumento  is null or ETdocumento = 0)
      </cfquery>

      <!--- Validamos que la nueva factura que se aplicara, NO repita con serie y documento con algun otro documento --->
      <cfquery name="_rsTTransaction" datasource="#session.dsn#">
          select ETserie,ETdocumento,Ecodigo from ETransacciones
          where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
      </cfquery>
      <cfquery name="rsValidaETserieDocumentoRepetido" datasource="#session.dsn#">
          select * from ETransacciones
          where ETserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_rsTTransaction.ETserie#">
          and ETdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_rsTTransaction.ETdocumento#">
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_rsTTransaction.Ecodigo#">
          and ETestado = <cfqueryparam cfsqltype="cf_sql_varchar" value="C">
      </cfquery>
      <!--- Esto se puede dar o bien, porque se genero una serie que ya existia entonces el ETransacciones NO deberia tener asignado el ETdocumento --->
      <!--- El otro caso posible es que, ya se habia asignado el ETdocumento entonces este ETnumero ya deberia tener el ETdocumento --->
      <cfif rsValidaETserieDocumentoRepetido.recordCount GT 0>
        <cf_ErrorCode code="-1" msg="Se genero un numero de serie y documento invalido. ETnumero:#Arguments.ETnumero#. Documento:#_rsTTransaction.ETdocumento# y la serie:#_rsTTransaction.ETserie# </br> Favor Intentar aplicar el documento Nuevamente.">
      </cfif>

      <cfif Arguments.contabilizar EQ 'aplica'>
          <cfinvoke component="sif.Componentes.FA_posteotransaccionesAplicar" method="posteo_documentosFA" returnvariable="any">
              <cfinvokeargument name="FCid"       		value="#Arguments.FCid#">
              <cfinvokeargument name="ETnumero"     	value="#Arguments.ETnumero#">
              <cfinvokeargument name="Ecodigo"    		value="#Session.Ecodigo#">
              <cfinvokeargument name="usuario"      	value="#Arguments.Usuario#">
              <cfinvokeargument name="debug"        	value="N">
              <cfinvokeargument name="FechaDocumento"	value="#rsVerificaEstado.ETfecha#">
              <cfinvokeargument name="CPNAPmoduloOri"	value="#Arguments.CPNAPmoduloOri#">
              <cfif isdefined("form.NCredito")>
                <cfinvokeargument name="NotCredito"  value="S">
              <cfelse>
                <cfinvokeargument name="NotCredito"  value="N">
              </cfif>
              <cfif isdefined("rsVerificaEstado") and rsVerificaEstado.existe  gt 0>
                <cfinvokeargument name="Importacion"  value="true">
              </cfif>
          </cfinvoke>
      <cfelseif Arguments.contabilizar EQ 'todos'>
          <cfinvoke component="sif.Componentes.FA_posteotransacciones" method="posteo_documentosFA" returnvariable="any">
              <cfinvokeargument name="FCid"           value="#Arguments.FCid#">
              <cfinvokeargument name="ETnumero"       value="#Arguments.ETnumero#">
              <cfinvokeargument name="Ecodigo"        value="#Session.Ecodigo#">
              <cfinvokeargument name="usuario"        value="#Arguments.Usuario#">
              <cfinvokeargument name="debug"          value="N">
              <cfinvokeargument name="FechaDocumento" value="#rsVerificaEstado.ETfecha#">
              <cfinvokeargument name="INTARC"        value="#INTARC#">
              <cfinvokeargument name="IntPresup"      value="#IntPresup#">
              <cfinvokeargument name="Tb_Calculo"     value="#Tb_Calculo#">
              <cfinvokeargument name="DIFERENCIAL"    value="#DIFERENCIAL#">
              <cfinvokeargument name="CPNAPmoduloOri"	value="#Arguments.CPNAPmoduloOri#">
              <cfif isdefined("form.NCredito")>
                <cfinvokeargument name="NotCredito"  value="S">
              <cfelse>
                <cfinvokeargument name="NotCredito"  value="N">
              </cfif>
              <cfif isdefined("rsVerificaEstado") and rsVerificaEstado.existe  gt 0>
                <cfinvokeargument name="Importacion"  value="true">
              </cfif>
          </cfinvoke>

		<cfquery name="rsUpdateContabiliza" datasource="#session.dsn#">
			update ETransacciones
				set ETcontabiliza = 1
			where Ecodigo  = #session.Ecodigo#
			  and ETnumero = #Arguments.ETnumero#
			  and FCid     = #Arguments.FCid#
		</cfquery>
    </cfif>

         <!--- Invoca calculo de comisiones --->
        <cfquery name="rsVerificaAgencia" datasource="#session.dsn#">
          <cfoutput>
                  select SNcodigo2,IndReFactura
                  from ETransacciones
                  where Ecodigo  = #session.Ecodigo#
                  and ETnumero = #Arguments.ETnumero#
                  and FCid     = #Arguments.FCid#
          </cfoutput>
        </cfquery>

        <cfif rsVerificaAgencia.IndReFactura EQ 0>
          <cfset _invocarComisiones = true> <!--- por default para los que no son refactura siempre lo hace --->
        <cfelse>
          <!--- si es refactura entonces verifica que el doucmento original tenga  --->
          <cfinvoke component="sif.Componentes.CC_NotaCredito" method="esReFacturaYTieneAgencia" returnvariable="_invocarComisiones">
              <cfinvokeargument name="ETnumero" value="#Arguments.ETnumero#">
              <cfinvokeargument name="FCid" value="#Arguments.FCid#">
              <cfinvokeargument name="Ecodigo" value="#session.Ecodigo#">
          </cfinvoke>
        </cfif>

        <cfif  _invocarComisiones> <!---isdefined ('rsVerificaAgencia.SNcodigo2') and len(trim(#rsVerificaAgencia.SNcodigo2#)) and--->
          <cfif Arguments.InvocarInterfaz718>
            <cfinvoke component="interfacesSoin.Componentes.COM_Invocaciones"  method="invoka718">
                <cfinvokeargument name="ETnumero" value="#ETnumero#">
                <cfinvokeargument name="FCid" value="#Arguments.FCid#">
            </cfinvoke>
          </cfif>
          <cfif Arguments.InvocarInterfaz719>
            <cfinvoke component="interfacesSoin.Componentes.COM_Invocaciones"  method="invoka719">
                <cfinvokeargument name="ETnumero" value="#ETnumero#">
                <cfinvokeargument name="FCid" value="#Arguments.FCid#">
            </cfinvoke>
          </cfif>
        </cfif>

        <cfset _LvarOmitirEnvioFE = false>
        <cftry>
        <cfquery name="rs" datasource="#session.dsn#">
          select 1 from ETransacciones et
          inner join DTransacciones dt
              on et.ETnumero = dt.ETnumero
             and et.FCid = dt.FCid
          inner join sif_interfaces..IE748EnviadosElectronica ie
              on ie.NumDoc = convert(varchar,et.ETserie) || convert(varchar,et.ETdocumento)
          where et.ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
            and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
        </cfquery>
        <cfif rs.recordCount>
          <cfset _LvarOmitirEnvioFE = true>
        </cfif>
          <cfcatch type="any">
          </cfcatch>
        </cftry>


         <!--- Se publica la aplicacion de la factura --->
		  <cfset sePublicoFacturaAplicada = false>
          <cfif rsVerificaEstado.ETexterna eq 'S'>
            <cfset sePublicoFacturaAplicada = true>
              <cfif _LvarOmitirEnvioFE EQ false><!---- Si la factura ya se envio anteriormente no se invoca el cambio estado ----->
                <cfinvoke  method="PublicaFactAplicada" returnvariable="any">
                  <cfinvokeargument name="FCid"         value="#Arguments.FCid#">
                  <cfinvokeargument name="ETnumero"     value="#Arguments.ETnumero#">
                </cfinvoke>
              </cfif>
          </cfif>
        <!--- Se documenta para poder enviar las facturas de credito. --->
        <!--- <cfquery name="rsVerificaDocumentoFA" datasource="#session.dsn#">
          select b.ETnumero,b.FCid, a.Dsaldo
          from Documentos a
              inner join ETransacciones b
                on a.ETnumero = b.ETnumero
          where b.ETnumero = '#Arguments.ETnumero#'
            and b.Ecodigo = #session.Ecodigo#
            and b.FCid = #Arguments.FCid#
        </cfquery>--->
        <!--- Invoca El envio a facturacion electronica, unicamente si el parametro asi lo indica, si no es asi, se invoca desde otro lado--->
        <!--- Esta funcion se va a invocar manual en Notas de Credito, FA_ReFactura.AplicarReFactura como false, para invocarla manual en el APlicacionNotaCredito_sql.cfm --->
        <cfif Arguments.InvocarFacturacionElectronica  and _LvarOmitirEnvioFE EQ false>
            <!--- Invocamos el envio a facturacion electronica WS --->
              <cfinvoke  method="FacturaElectronica" returnvariable="any">
                  <cfinvokeargument name="FCid"         value="#Arguments.FCid#">
                  <cfinvokeargument name="ETnumero"     value="#Arguments.ETnumero#">
                  <cfinvokeargument name="Ecodigo"      value="#session.Ecodigo#">
                  <cfif sePublicoFacturaAplicada>
                    <cfinvokeargument name="reversarAplicacionFactAplicada" value="true">
                  </cfif>
                  <cfinvokeargument name="PrioridadEnvio" value="#Arguments.PrioridadEnvio#">
              </cfinvoke>
        </cfif>
    </cfoutput>

<!---INICIA EL PROCESO DE CONTABILIZACION DESDE LA TAREA PROGRAMADA--->
    <cfelseif Arguments.Contabilizar EQ 'conta'>
    <!----- Se le asigna el numero de documento, manteniendo el consecutivo del talonario ------>
    <!----- Buscamos el ID del talonario asignado a la caja --->
    <cfinvoke  method="SigTalonarioDoc" returnvariable="rsRIsig">
      <cfinvokeargument name="FCid"          value="#Arguments.FCid#">
      <cfinvokeargument name="CCTcodigo"     value="#rsVerificaEstado.CCTcodigo#">
    </cfinvoke>

    <cfquery name="rsUpdate" datasource="#session.dsn#">
       update ETransacciones set ETdocumento = #rsRIsig.RIsig#, ETserie = '#rsRIsig.RIserie#'
       where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
          and ETnumero  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and FCid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and (ETdocumento  is null or ETdocumento = 0)
    </cfquery>

    <!--- Validamos que la nueva factura que se aplicara, NO repita con serie y documento con algun otro documento --->
    <cfquery name="_rsTTransaction" datasource="#session.dsn#">
        select ETserie,ETdocumento,Ecodigo from ETransacciones
        where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
    </cfquery>
    <cfquery name="rsValidaETserieDocumentoRepetido" datasource="#session.dsn#">
        select * from ETransacciones
        where ETserie = <cfqueryparam cfsqltype="cf_sql_varchar" value="#_rsTTransaction.ETserie#">
        and ETdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_rsTTransaction.ETdocumento#">
        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_rsTTransaction.Ecodigo#">
        and ETestado = <cfqueryparam cfsqltype="cf_sql_varchar" value="C">
    </cfquery>
    <!--- Esto se puede dar o bien, porque se genero una serie que ya existia entonces el ETransacciones NO deberia tener asignado el ETdocumento --->
    <!--- El otro caso posible es que, ya se habia asignado el ETdocumento entonces este ETnumero ya deberia tener el ETdocumento --->
    <cfif rsValidaETserieDocumentoRepetido.recordCount GT 0>
      <cf_ErrorCode code="-1" msg="Se genero un numero de serie y documento invalido. ETnumero:#Arguments.ETnumero#. Documento:#_rsTTransaction.ETdocumento# y la serie:#_rsTTransaction.ETserie# </br> Favor Intentar aplicar el documento Nuevamente.">
    </cfif>


		<cfinvoke component="sif.Componentes.FA_posteotransacciones" method="posteo_documentosFA" returnvariable="any">
			  <cfinvokeargument name="FCid"           value="#Arguments.FCid#">
			  <cfinvokeargument name="ETnumero"       value="#Arguments.ETnumero#">
			  <cfinvokeargument name="Ecodigo"        value="#Session.Ecodigo#">
			  <cfinvokeargument name="usuario"        value="#Arguments.Usuario#">
			  <cfinvokeargument name="debug"          value="true">
			  <cfinvokeargument name="INTARC"         value="#INTARC#">
			  <cfinvokeargument name="IntPresup"      value="#IntPresup#">
			  <cfinvokeargument name="Tb_Calculo"     value="#Tb_Calculo#">
			  <cfinvokeargument name="DIFERENCIAL"    value="#DIFERENCIAL#">
			  <cfinvokeargument name="FechaDocumento" value="#rsVerificaEstado.ETfecha#">
              <cfinvokeargument name="CPNAPmoduloOri"	value="#Arguments.CPNAPmoduloOri#">
			  <cfif isdefined("form.NCredito")>
				<cfinvokeargument name="NotCredito"  value="S">
			  <cfelse>
				<cfinvokeargument name="NotCredito"  value="N">
			  </cfif>
			  <cfif isdefined("rsVerificaEstado") and rsVerificaEstado.existe  gt 0>
				<cfinvokeargument name="Importacion"  value="true">
        <cfinvokeargument name="InvocarFacturacionElectronica"  value="true">
        <cfinvokeargument name="PrioridadEnvio"  value="0">
			  </cfif>
		</cfinvoke>

        <cfquery name="rsUpdateContabiliza" datasource="#session.dsn#">
        	update ETransacciones
		  		set ETcontabiliza = 1
            where Ecodigo  = #session.Ecodigo#
              and ETnumero = #Arguments.ETnumero#
              and FCid     = #Arguments.FCid#
        </cfquery>
    </cfif>
</cffunction>

<!--- Debe ser invocado conteniendolo en un CFTRANSACTION --->
<!------------------------------------------------------------------------------------------------------------>
<!--- Aplica recibos de dinero (Cobros, o notas de credito), Pagos --->
<cffunction name="AplicarRecibosDinero">
  <cfargument name="CCTcodigo"    type="string"  required="true">
  <cfargument name="Pcodigo"      type="string"  required="true">
  <cfargument name="CC"           type="numeric" required="false" default="">
  <cfargument name="Preferencia"  type="string"  required="false" default="">
  <cfargument name="Contabilizar" type="string"  required="false" default="aplica">
  <cfargument name="Usuario"      type="string"  required="false" default="#session.Usulogin#">
  <cfargument name="CPNAPmoduloOri"      type="string"  required="false" default="">
  <cfoutput>
  <cf_dbfunction name="to_char" args="p.Pfecha"  returnvariable="Pfecha">
  <cf_dbfunction name="to_char" args="d.Dfecha"  returnvariable="Dfecha">
  <cf_dbfunction name="date_format" args="p.Pfecha,dd-mm-yyyy" returnvariable="LvarPfecha">
  <cf_dbfunction name="date_format" args="d.Dfecha,dd-mm-yyyy" returnvariable="LvarDfecha">
  <!--- ABG. Se modifica ya que la comparacion de fechas es erronea --->
  <!--- Se utiliza el dbfunction y el preservesinglequotes porque si habia diferencia en horas, el sistema da diferencia 1 y daba error ----->
  <cfquery name="rsValida" datasource="#session.DSN#" maxrows="1">
    select
      (case when (#preservesinglequotes(LvarPfecha)#) < (select #preservesinglequotes(LvarDfecha)#
                                                          from Documentos d
                                                          where d.Ecodigo = dp.Ecodigo
                                                            and d.CCTcodigo = dp.Doc_CCTcodigo
                                                            and d.Ddocumento = dp.Ddocumento)
                                                            then 1 else 2 end) as diferencia,
      #preservesinglequotes(LvarPfecha)# as fechaPag,
      (select #preservesinglequotes(LvarDfecha)#
        from Documentos d
        where d.Ecodigo = dp.Ecodigo
          and d.CCTcodigo = dp.Doc_CCTcodigo
          and d.Ddocumento = dp.Ddocumento) as FechaDoc
    from Pagos p
    inner join DPagos dp
      on dp.Ecodigo = p.Ecodigo
      and dp.CCTcodigo = p.CCTcodigo
      and dp.Pcodigo  = p.Pcodigo
    where p.Ecodigo = #Session.Ecodigo#
      and p.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.CCTcodigo#" >
      and p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.Pcodigo#" >
    order by 1
  </cfquery>

  <cfquery name="rsSNid" datasource="#session.dsn#">
    select b.SNid
    from Pagos p
    inner join SNegocios  b
      on p.SNcodigo = b.SNcodigo
    where p.Ecodigo = #Session.Ecodigo#
      and p.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.CCTcodigo#" >
      and p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.Pcodigo#" >
  </cfquery>

  <cfquery name="rsDatos" datasource="#session.dsn#">
    select
      Doc_CCTcodigo,
      Ddocumento,Ptipocambio as TC,
      coalesce(p.CBid,-1) as CBid
    from Pagos p
    inner join DPagos dp
      on dp.Ecodigo = p.Ecodigo
      and dp.CCTcodigo = p.CCTcodigo
      and dp.Pcodigo  = p.Pcodigo
    where p.Ecodigo = #Session.Ecodigo#
      and p.CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.CCTcodigo#" >
      and p.Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.Pcodigo#" >
  </cfquery>
  <cfif isdefined('rsDatos') and rsDatos.recordcount gt 0>
    <cfquery name="rsDocumentos" datasource="#session.dsn#">
      select
        d.FCid,
        d.ETnumero
      from Documentos d
      where   d.Ecodigo = #session.Ecodigo#
        and d.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#rsDatos.Doc_CCTcodigo#" >
        and d.Ddocumento = <cfqueryparam cfsqltype="cf_sql_char"  value="#rsDatos.Ddocumento#" >
    </cfquery>
  </cfif>

  <cfquery name="rsMonedaLoc" datasource="#session.dsn#">
    select e.Mcodigo from Empresas es
    inner join Empresa e
    on es.cliente_empresarial = e.CEcodigo
    where es.Ecodigo = #session.Ecodigo#
  </cfquery>
  <cfset LvarMonedaLocal = rsMonedaLoc.Mcodigo>
  <cfquery  datasource="#session.dsn#">
  update PFPagos
    set FPtc = 1
  where CCTcodigo =  <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.CCTcodigo#" >
    and Pcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.Pcodigo#" >
    and Mcodigo = #LvarMonedaLocal#
    and FPtc <> 1
  </cfquery>


  <!---  A las lineas que tengan vuelto, se les resta al pago el vuelto para hacer los asientos--->
  <cfquery name="upPagosVuelto" datasource="#session.dsn#">
    update PFPagos set FPagoDoc = (FPagoDoc - PFPVuelto)
    where CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.CCTcodigo#" >
      and Pcodigo   = <cfqueryparam cfsqltype="cf_sql_char"  value="#Arguments.Pcodigo#" >
      and Tipo = 'E'
      and PFPVuelto <> 0
  </cfquery>


  <cfinvoke component="sif.fa.operacion.CostosAuto"       Conexion="#session.dsn#"  method="CreaCostos"   returnvariable="Tb_Calculo"/>
  <cfinvoke component="sif.Componentes.CG_GeneraAsiento"  Conexion="#session.dsn#"  method="CreaIntarc" CrearPresupuesto="false" returnvariable="INTARC"/>
  <cfinvoke component= "sif.Componentes.PRES_Presupuesto" Conexion ="#session.dsn#" method="CreaTablaIntPresupuesto"  returnvariable="IntPresup"/>


  <cfif isdefined("rsValida") and rsValida.diferencia eq 3> <!--- Esta validacion  tiene un problema se debe de corregir --->
    <cfthrow message="No se puede aplicar un recibo con fecha menor a la del documento! La Fecha de pago es: #rsValida.fechaPag# y la fecha del documento es #rsValida.FechaDoc#">
  </cfif>

  <!--- ejecuta el proc.--->
  <cfinvoke component="sif.Componentes.CC_PosteoPagosCxC" method="PosteoPagosCxC" returnvariable="status">
    <cfinvokeargument name="Ecodigo"  value="#session.Ecodigo#"/>
    <cfinvokeargument name="CCTcodigo"  value="#Arguments.CCTcodigo#"/>
    <cfinvokeargument name="Pcodigo"  value="#Arguments.Pcodigo#"/>
    <cfinvokeargument name="Preferencia"  value="#Arguments.Preferencia#"/>
    <cfinvokeargument name="usuario"  value="#Arguments.Usuario#"/>
    <cfinvokeargument name="SNid" value="#rsSNid.SNid#"/>
    <cfinvokeargument name="Tb_Calculo" value="#Tb_Calculo#"/>
    <cfinvokeargument name="transaccionActiva"  value="true"/>
    <cfinvokeargument name="INTARC" value="#INTARC#"/>
    <cfinvokeargument name="IntPresup"  value="#IntPresup#"/>
    <cfinvokeargument name="debug"  value="false"/>
    <cfinvokeargument name="PintaAsiento" value="#isdefined('Form.Ver')#"/>
    <cfif isdefined('Arguments.CC') and Len(Trim(Arguments.CC))>
      <cfinvokeargument name="CC" value="#Arguments.CC#"/>
    </cfif>
    <cfinvokeargument name="Contabilizar"  value="#Arguments.Contabilizar#"/>
    <cfinvokeargument name="InvocarFacturacionElectronica"  value="false"/>
    <cfinvokeargument name="PrioridadEnvio"  value="0"/>
    <cfinvokeargument name="CPNAPmoduloOri"  value="#Arguments.CPNAPmoduloOri#"/>

  </cfinvoke>
  <cfif Arguments.Contabilizar eq 'todos' or Arguments.Contabilizar eq 'aplica'>
    <!---Codigo 15836: Maneja Egresos--->
    <cfquery name="rsManejaEgresos" datasource="#session.DSN#">
      select Pvalor
      from Parametros
      where Ecodigo =  #Session.Ecodigo#
        and Pcodigo = 15836
    </cfquery>
    <cfif rsManejaEgresos.Pvalor eq 1>
      <cfquery name="para720" datasource="#session.dsn#">
        select
          case when  VolumenGNCheck 			= 1 then 'S' else 'N' end as IndComVol,
          case when  VolumenGLRCheck 			= 1 then 'S' else 'N' end as IndComVolR,
          case when  VolumenGLRECheck 		= 1 then 'S' else 'N' end as IndComVolRE,
          case when  ProntoPagoCheck 			= 1 then 'S' else 'N' end as IndComPP,
          case when  ProntoPagoClienteCheck 	= 1 then 'S' else 'N' end as IndComPPC,
          case when  montoAgenciaCheck 		= 1 then 'S' else 'N' end as IndComAge,
          dp.DRdocumento as Ddocumento,
          dp.CCTRcodigo as CCTcodigo ,
          sn.SNnumero,
          p.Pcodigo  as DdocumentoR,
          p.CCTcodigo as CCTcodigoR,
          coalesce(p.Ecodigo,0) as Ecodigo
        from HPagos p
        inner join BMovimientos dp
          on dp.Ecodigo = p.Ecodigo
          and dp.CCTcodigo = p.CCTcodigo
          and dp.Ddocumento  = coalesce(p.Pserie #_Cat# p.Pdocumento,p.Pcodigo)
        inner join  COMFacturas comf
          on comf.PcodigoE 	= p.Pcodigo
          and   comf.CCTcodigoE	= p.CCTcodigo
          and   comf.CCTcodigoD	= dp.CCTRcodigo
          and   comf.Ddocumento 	= dp.DRdocumento
        inner join Documentos d
          on dp.Ecodigo = d.Ecodigo
          and dp.DRdocumento = d.Ddocumento
          and dp.CCTRcodigo = d.CCTcodigo
        inner join SNegocios sn
          on sn.SNcodigo = d.SNcodigo
          and sn.Ecodigo= d.Ecodigo
        where p.Ecodigo = #Session.Ecodigo#
          and ltrim(rtrim(p.CCTcodigo)) =  <cfqueryparam cfsqltype="cf_sql_char"  value="#trim(Arguments.CCTcodigo)#" >
          and ltrim(rtrim(p.Pcodigo)) = <cfqueryparam cfsqltype="cf_sql_char"  value="#trim(Arguments.Pcodigo)#" >
          and (VolumenGNCheck = 1 or VolumenGLRCheck = 1 or VolumenGLRECheck = 1
              or ProntoPagoCheck = 1 or ProntoPagoClienteCheck = 1 or montoAgenciaCheck = 1
          ) and PtipoSN = '4'
      </cfquery>


      <cfif isdefined("para720") and para720.recordcount>
        <!--- Invoca Componente de Procesamiento de Interfaz 720. --->
        <cfinvoke component="interfacesSoin.Componentes.COM_CreaLote" method="process" returnvariable="numLote" query="#para720#" TransActiva="true"/>

          <cfquery datasource="#session.dsn#">
            update COMFacturas
            set loteGenerado = '#numLote#'
            where Ecodigo = #Session.Ecodigo#
              and rtrim(CCTcodigoE)	= <cfqueryparam cfsqltype="cf_sql_char"  value="#trim(Arguments.CCTcodigo)#" >
              and rtrim(PcodigoE)	= <cfqueryparam cfsqltype="cf_sql_char"  value="#trim(Arguments.Pcodigo)#" >
          </cfquery>
      </cfif>
      </cfif>
  </cfif>  <!--- Fin del condicional si es conta o todos ----->

  </cfoutput>
</cffunction>
<!---- Web service Nacion: manda a imprimir la factura aplicada ------>
 <cffunction name="PublicaFactAplicada" access="public" returntype="any">
		<cfargument name="ETnumero" type="numeric" required="true">
        <cfargument name="FCid"     type="numeric" required="true">
        <cfargument name="Estado"   type="string"  required="false" default="I">


       <cfquery name="rsRuta" datasource="#session.dsn#">
         select RutaInterfaz as ruta, MetodoInterfaz as metodo from  RutasInterfaces
         where Ecodigo = #session.Ecodigo#
         and NumeroInterfaz = 2
        </cfquery>
        <cfif len(trim(#rsRuta.ruta#)) eq 0>
           <cfthrow message="No se ha logrado obtener la ruta de la interfaz numero 2, de cambio estado facturacion. Favor revisar la tabla de rutas.">
        </cfif>

		<cfquery name="rsDatos" datasource="#session.dsn#">
		  select a.NumDoc, a.CodSistema, a.NumLineaDet,'#arguments.Estado#' as NuevoEstado,
		  c.ETdocumento as NumFactura,c.ETserie as serieFactura, 0 as CambiarEnCajas,
		  1 as CambiarEnSistemaExterno, c.Usulogin
		  from FADRecuperacion a
           inner join DTransacciones b
             on a.DTlinea = b.DTlinea
           inner join ETransacciones c
             on b.ETnumero = c.ETnumero
             and b.FCid =   c.FCid
          where c.ETexterna = 'S'
             and c.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETnumero#">
               and c.FCid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
		</cfquery>

        <cfoutput query="rsDatos">
           <cfsavecontent variable="soapBodyWSC_pub">
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:gnin="GNInterfacesWcf" >
               <soapenv:Header/>
               <soapenv:Body>
                  <gnin:SendCambiaEstadoTransaccion>
                     <gnin:_numDocumento>#rsDatos.NumDoc#</gnin:_numDocumento>
                     <gnin:_codSistema>#rsDatos.CodSistema#</gnin:_codSistema>
                     <gnin:_numLineaDetalle>#rsDatos.NumLineaDet#</gnin:_numLineaDetalle>
                     <gnin:_nuevoEstado>#rsDatos.NuevoEstado#</gnin:_nuevoEstado>
                     <gnin:_numFactura>#rsDatos.NumFactura#</gnin:_numFactura>
                     <gnin:_serieFactura>#rsDatos.serieFactura#</gnin:_serieFactura>
                     <gnin:_indCambiarEnCajas>#rsDatos.CambiarEnCajas#</gnin:_indCambiarEnCajas>
                     <gnin:_indCambiarEnSistemaExterno>#rsDatos.CambiarEnSistemaExterno#</gnin:_indCambiarEnSistemaExterno>
                     <gnin:_usuario>#rsDatos.Usulogin#</gnin:_usuario>
                  </gnin:SendCambiaEstadoTransaccion>
               </soapenv:Body>
            </soapenv:Envelope>
            </cfsavecontent>

            <cfinvoke component="sif.Componentes.Generales" method="AgregarBitacoraWS" returnvariable="idBid">
              <cfinvokeargument name="NumeroInterfaz" value="2">
              <cfinvokeargument name="XmlEnviado" value="#trim(soapBodyWSC_pub)#">
            </cfinvoke>

            <cfhttp url="#rsRuta.ruta#" method="post" result="httpResponse2">
                  <cfhttpparam type="header" name="SOAPAction" value="#rsRuta.metodo#"/>
                  <cfhttpparam type="header" name="accept-encoding" value="no-compression"/>
                  <cfhttpparam type="header" name="charset" value="utf-8">
                  <cfhttpparam type="xml" value="#trim(soapBodyWSC_pub)#"/>
            </cfhttp>

            <cfinvoke component="sif.Componentes.Generales" method="ModificarBitacoraWS">
              <cfinvokeargument name="Bid" value="#idBid#">
              <cfinvokeargument name="XmlRecibido" value="#httpResponse2.fileContent#">
            </cfinvoke>

           <cfoutput>

                <cfset _wsRes = "false">
 				<cfif find( "200", httpResponse2.statusCode )>
                    <cfset soapResponsePubFact = xmlParse( httpResponse2.fileContent ) />
                    <cfset _resultado = #soapResponsePubFact.Envelope.Body.SendCambiaEstadoTransaccionResponse.XmlChildren#>
                    <cfset _wsRes = #_resultado[1].XmlText#>

                <cfelse>
                  <!---  <cfoutput>
                        #httpResponse2.statusCode#
                        <cfthrow message="Hubo un error en la invocacion de la interfaz:#httpResponse2.statusCode# - #httpResponse2.filecontent#">
                    </cfoutput> --->
                       #httpResponse2.statusCode#
                        <cfset MensajeError = "Hubo un error en la invocacion de la interfaz: "&httpResponse2.statusCode&"<br/>"&httpResponse2.filecontent&"<br/>">
                        <cfset MensajeError = MensajeError & "  ARGUMENTOS: <br/>">
                        <cfset MensajeError = MensajeError &  "     - ETnumero: "&Arguments.ETnumero&"<br/>">
                        <cfset MensajeError = MensajeError &  "     - FCid: "&Arguments.FCid&"<br/>">
                        <cfset MensajeError = MensajeError &  "     - Estado: "&Arguments.Estado&"<br/>">
                        <cfset MensajeError = MensajeError &  "     -xml: <pre><code>"&(#soapBodyWSC_pub#)&"</code></pre> <br/>">
                        <cfsavecontent variable="_err">
                              <div style="border: 1px solid blue;width: 50%;margin-left: 25%;text-align: center;font-weight: bold;padding: 1em;font-size: 2em;box-shadow: 5px 5px 40px rgb(0, 0, 248);border-radius: 15px;">
                                Error Inesperado en la interfaz de cambio de estado.
                              </div>
                              <br/>
                        </cfsavecontent>
                        <cfset _err &= '</br>' & MensajeError>
                        <cfthrow message="#_err#">

                </cfif>
                <cfif _wsRes EQ 'false'>
						  <cfset MensajeError = "Hubo un error en la invocacion de la interfaz: "&httpResponse2.statusCode&"<br/>"&httpResponse2.filecontent&"<br/>">
                        <cfset MensajeError = MensajeError & "  ARGUMENTOS: <br/>">
                        <cfset MensajeError = MensajeError &  "     - ETnumero: "&Arguments.ETnumero&"<br/>">
                        <cfset MensajeError = MensajeError &  "     - FCid: "&Arguments.FCid&"<br/>">
                        <cfset MensajeError = MensajeError &  "     - Estado: "&Arguments.Estado&"<br/>">
                        <cfset MensajeError = MensajeError &  "     -xml: <pre><code>"&(#soapBodyWSC_pub#)&"</code></pre> <br/>">
                        <cfsavecontent variable="_err">
                              <div style="border: 1px solid blue;width: 50%;margin-left: 25%;text-align: center;font-weight: bold;padding: 1em;font-size: 2em;box-shadow: 5px 5px 40px rgb(0, 0, 248);border-radius: 15px;">
                                Error Inesperado en la interfaz de cambio de estado.
                              </div>
                              <br/>
                        </cfsavecontent>
                        <cfset _err &= '</br>' & MensajeError>
                        <cfthrow message="#_err#">

                </cfif>
  			</cfoutput>

          </cfoutput>

          <cfreturn true>
	</cffunction>

    <cffunction name="ObtieneCuenta" returntype="any">
        <cfargument name="Tipo"           	type="string" required="yes">
        <cfargument name="FPCuenta"  	  	type="numeric" required="yes">
        <cfargument name="FPdocnumero"      type="string" required="yes">

        <cfif arguments.Tipo EQ 'D'>
            <!---Codigo 15833: para determinar si el pago de documentos de CxC cuando el cliente paga por transferencia o depósito debe crear
            el movimiento en Bancos al aplicarse el pago o el sistema debe validar que el pago ya exista en Bancos--->
             <cfset rsValidarExisteBancos = consultaParametro(#session.Ecodigo#, 'CC',15833)>

            <!---Se usa la transitoria xq si esta el parametro activo, tiene que hacer el asiento con la transitoria debido a que ya existe el asiento de bancos--->
             <cfif rsValidarExisteBancos.valor eq 1>
                 <cfquery name="CuentaE" datasource="#Session.DSN#">
                    select a.Ccuenta as valor
                        from CFinanciera a
                        inner join CuentasBancos b
                            on b.CFcuentaTransitoria = a.CFcuenta
                     where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPCuenta#">
                 </cfquery>
                 <!---Validamos si esta configurada la cuenta transitoria--->
                 <cfif len(trim(#CuentaE.valor#)) eq 0>
                     <cfquery name="CuentaE" datasource="#Session.DSN#">
                        select a.CBcodigo, a.CBdescripcion, a.CBcc, b.Bdescripcion
                            from CuentasBancos a
                            inner join Bancos b
                                on b.Bid = a.Bid
                         where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FPCuenta#">
                     </cfquery>
                    <cfthrow message="La cuenta: #CuentaE.CBcc# con codigo: #CuentaE.CBcodigo# y descripcion : #CuentaE.CBdescripcion# del Banco: #CuentaE.Bdescripcion#
                                      NO tiene definida la cuenta transitoria. Favor definirla en el catalogo de cuentas bancarias">
                </cfif>
            <cfelse>
                <cfquery name="CuentaE" datasource="#Session.DSN#">
                    select Ccuenta as valor from CuentasBancos  where CBid = #arguments.FPCuenta# and Ecodigo = #session.Ecodigo#
                 </cfquery>
            </cfif>
        <cfelseif arguments.Tipo EQ 'F'> <!---F: Diferencia--->
            <cfquery name="CuentaE" datasource="#Session.DSN#">
                select  cf.Ccuenta as valor
                    from  DIFEgresos dife
                     inner join CFinanciera cf
                        on cf.CFcuenta = dife.CFcuenta
                 where dife.Ecodigo 		 	  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and rtrim(dife.DIFEcodigo)   = <cfqueryparam cfsqltype="cf_sql_char" 	 value="#trim(arguments.FPdocnumero)#">
            </cfquery>
        <cfelse>
             <cfset CuentaE = consultaParametro(#session.Ecodigo#, '',650)>
        </cfif>
        <cfreturn #CuentaE#>

    </cffunction>

	<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
    <cffunction name="ObtenerDato" returntype="query">
        <cfargument name="pcodigo" type="numeric" required="true">
        <cfquery name="rs" datasource="#Session.DSN#">
            select Pvalor
            from Parametros
            where Ecodigo = #Session.Ecodigo#
              and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
        </cfquery>
        <cfreturn rs>
    </cffunction>

	<!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
    <cffunction name="ObtenerConceptos" returntype="query">
        <cfargument name="Cid" type="numeric" required="true">
        <cfquery name="rs" datasource="#Session.DSN#">
            select Cid, coalesce(Cformato,'') as Cformato, coalesce(cuentac,'') as cuentac , Ccodigo, Cdescripcion

 			from Conceptos
            where Ecodigo = #Session.Ecodigo#
              and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Cid#">
        </cfquery>
        <cfreturn rs>
    </cffunction>

 <!------------------------------------------------------------------------------------------------------------------------------->
 <!------------------------------------------------------------------------------------------------------------------------------->
 <!---- Web service Nacion: publica en la nube la factura ----->
  <cffunction name="FacturaElectronica" access="public" returntype="any">
	    <cfargument name="ETnumero" type="numeric" required="true">
      <cfargument name="FCid"     type="numeric" required="true">
      <cfargument name="Ecodigo"  type="numeric" required="true">
      <cfargument name="desdeNotaCredito" type="boolean" required="false" default="false"> <!--- Indica si la factura proviene de una Nota de credito --->
      <cfargument name="ENCid" type="numeric" required="false"> <!--- id de la nota de credito --->
      <cfargument name="reversarAplicacionFactAplicada" type="boolean" required="false" default="false">
      <cfargument name="imprimir" type="boolean" required="false" default="true">
      <cfargument name="PrioridadEnvio" type="numeric" required="false" default="0">

      <cfquery name="rsFacturaDigital" datasource="#session.dsn#">
       select Pvalor as usa from Parametros
        where Pcodigo = 16317
          and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#" >
      </cfquery>

      <cfquery name="rs" datasource="#session.dsn#">
        select ETserie + convert(varchar,ETdocumento) as NumeroDocumento
        from ETransacciones
        where ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
          and FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
      </cfquery>
<!--- COMENTADO POR ALVARO CHAVES EN PROYECTO DE AVIACIÓN CIVIL
      ESTO HAY QUE HACER QUE SE PUEDA HABILITAR O NÓ POR PARÁMETRO PUES NO SIEMPRE VA EXISTIR
      LA INTEGRACIÓN CON FACTURACIÓN DIGITAL --->
      <cfif rsFacturaDigital.usa eq 1>
        <cfinvoke component="sif.Componentes.FA_EnvioElectronica" method="AgregarRegistroEnBitacora" returnvariable="_idEnvioEle">
            <cfinvokeargument name="Ecodigo"          value="#Arguments.Ecodigo#">
            <cfinvokeargument name="ETnumero"         value="#Arguments.ETnumero#">
            <cfinvokeargument name="FCid"             value="#Arguments.FCid#">
            <cfinvokeargument name="NumeroDocumento"  value="#Trim(rs.NumeroDocumento)#">
            <cfinvokeargument name="PrioridadEnvio"   value="#Arguments.PrioridadEnvio#">
            <cfinvokeargument name="desdeNotaCredito" value="#Arguments.desdeNotaCredito#">
            <cfif isDefined('Arguments.ENCid')>
              <cfinvokeargument name="ENCid"            value="#Arguments.ENCid#">
            </cfif>
            <cfinvokeargument name="imprimir"         value="#Arguments.imprimir#">
        </cfinvoke>

        <cfinvoke component="sif.Componentes.FA_EnvioElectronica" method="AgregarFacturaConsolaFE">
            <cfinvokeargument name="ETnumero"           value="#Arguments.ETnumero#">
            <cfinvokeargument name="Legado"             value="0">
            <cfinvokeargument name="Estado"             value="0">
            <cfinvokeargument name="Ecodigo"            value="#session.Ecodigo#">
        </cfinvoke>
      </cfif>
      <!---
--->
	</cffunction>


  <!--- INVOCADO DESDE POSTEO TRANSACCIONES --->
  <cffunction name="_InsertArticuloServicioINTARC">
        <cfargument name="LvarETdocumento">
        <cfargument name="LvarCCTcodigo">
        <cfargument name="LvarMonloc">
        <cfargument name="LvarMonedadoc">
        <cfargument name="Anulacion">
        <cfargument name="AnulacionParcial">
        <cfargument name="LvarCuentaTransitoriaGeneral">
        <cfargument name="TBanulacion">
        <cfargument name="lvarETnumero_sub">
        <cfargument name="FCid">
        <cfargument name="Ecodigo">
        <cfargument name="LineasDetalle">
        <cfargument name="INTARC">
        <cfargument name="LvarPeriodo">
        <cfargument name="LvarMes">

      <!-----3c. Detalle (Articulos o Servicios) --Articulos--->
      <cfquery name="rsInsert" datasource="#session.dsn#">
        insert #Arguments.INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE,
        INTllave1,INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona, INTidPersona)
        select 'FAFC', 1, '#Arguments.LvarETdocumento#', '#Arguments.LvarCCTcodigo#',
            ((case when #Arguments.LvarMonloc# != #Arguments.LvarMonedadoc# then round((b.DTtotal+coalesce(b.DTdeslinea,0.00)) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end)<cfif Arguments.AnulacionParcial> * Coalesce(tb.porcentaje,1) </cfif>),
            case when c.CCTtipo = 'D' then <cfif Arguments.AnulacionParcial eq true> 'D' else 'C'<cfelse> 'C' else 'D'</cfif> end,
            case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1
            <cfif arguments.Anulacion> and b.DesTransitoria = 1 </cfif>
            then  'Cuenta transitoria: ' #_Cat# coalesce(DTdescripcion, DTdescalterna) else case when c.CCTtipo = 'C' and coalesce(c.CCTvencim,0) != -1 and d.CFACTransitoria = 1 then 'Cuenta transitoria: ' #_Cat# coalesce(DTdescripcion, DTdescalterna) else coalesce(DTdescripcion, DTdescalterna) end
            end , <cf_dbfunction name="to_char" args="getdate(),112">, a.ETtc,  #LvarPeriodo#, #LvarMes#,
             case when c.CCTtipo = 'D' and coalesce(c.CCTvencim,0)!= -1 and  d.CFACTransitoria = 1 then coalesce(d.CFcuentatransitoria,#Arguments.LvarCuentaTransitoriaGeneral#)
            else case when c.CCTtipo = 'C' and coalesce(c.CCTvencim,0)!= -1  and  d.CFACTransitoria = 1 <cfif arguments.Anulacion> and b.DesTransitoria = 1 </cfif>
             THEN <cfif arguments.Anulacion> b.DcuentaT <cfelse> coalesce(d.CFcuentatransitoria,#Arguments.LvarCuentaTransitoriaGeneral#)</cfif>
             else b.Ccuenta end end,  a.Mcodigo, b.Ocodigo,
             ((b.DTtotal+coalesce(b.DTdeslinea,0.00))<cfif Arguments.AnulacionParcial> * Coalesce(tb.porcentaje,1) </cfif>), <cf_dbfunction name="to_char"  args="a.FCid">, <cf_dbfunction name="to_char" args="a.ETnumero">,
            b.DTdescripcion, '#Arguments.LvarETdocumento#',case when a.CDCcodigo is not null then '03'  else '01' end, case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
        from ETransacciones a, DTransacciones b, CCTransacciones c, CFuncional d , SNegocios sn
        <cfif Arguments.AnulacionParcial>
         ,#Arguments.TBanulacion# tb
        </cfif>
        where  a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
             and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.lvarETnumero_sub#">
          <cfif Arguments.AnulacionParcial>
            and b.DTlinea = tb.DTlinea
          </cfif>
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and a.FCid = b.FCid and a.ETnumero = b.ETnumero and a.Ecodigo = b.Ecodigo and a.Ecodigo = c.Ecodigo and a.CCTcodigo = c.CCTcodigo
          and a.Ecodigo = sn.Ecodigo and a.SNcodigo = sn.SNcodigo and b.CFid = d.CFid  and b.Ecodigo = d.Ecodigo and b.DTtipo = 'A' and (b.DTpreciou * b.DTcant) <> 0 and b.DTborrado = 0
           <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
            and b.DTlinea in (#arguments.LineasDetalle#)
           </cfif>
         </cfquery>

        <!----- 3d. Detalle (Servicios o conceptos) --->
        <cfquery name="rsInsert" datasource="#session.dsn#">
      insert #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, CFcuenta, Mcodigo, Ocodigo, INTMOE,
        INTllave1,INTllave2,INTdescripcion,INTdoc_original,INTtipoPersona, INTidPersona)
        select 'FAFC', 1, '#LvarETdocumento#', '#LvarCCTcodigo#',
            ((case when #LvarMonloc# != #LvarMonedadoc# then round((b.DTtotal+coalesce(b.DTdeslinea,0.00)) * a.ETtc,2) else b.DTtotal+coalesce(b.DTdeslinea,0.00) end) <cfif Arguments.AnulacionParcial> * Coalesce(tb.porcentaje,1) </cfif>),
            case when c.CCTtipo = 'D' then <cfif arguments.AnulacionParcial eq true> 'D' else 'C' <cfelse> 'C' else 'D'</cfif>end,
            case when  c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1 then  'Cuenta transitoria: ' #_Cat# substring(coalesce(DTdescripcion, DTdescalterna),1,50)
            else case when c.CCTtipo = 'C' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1
            <cfif arguments.Anulacion> and b.DesTransitoria = 1 </cfif>
            then 'Cuenta transitoria: ' #_Cat# substring(coalesce(DTdescripcion, DTdescalterna),1,50)
            else substring(coalesce(DTdescripcion, DTdescalterna),1,50) end end,
            <cf_dbfunction name="to_char" args="getdate(),112">, a.ETtc,   #LvarPeriodo#, #LvarMes#,
            case when c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1 then coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#)
            else case when c.CCTtipo = 'C' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1
           <cfif arguments.Anulacion> and b.DesTransitoria = 1 </cfif> then <cfif arguments.Anulacion> b.DcuentaT <cfelse> coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#) </cfif>
            else  b.Ccuenta end end,
			case when c.CCTtipo = 'D' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1 then coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#)
            else case when c.CCTtipo = 'C' and coalesce(c.CCTvencim,0) != -1 and  d.CFACTransitoria = 1
           <cfif arguments.Anulacion> and b.DesTransitoria = 1 </cfif> then <cfif arguments.Anulacion> b.DcuentaT <cfelse> coalesce(d.CFcuentatransitoria,#LvarCuentaTransitoriaGeneral#) </cfif>
            else  b.CFcuenta end end, a.Mcodigo,  b.Ocodigo,
            ((b.DTtotal+coalesce(b.DTdeslinea,0.00)) <cfif Arguments.AnulacionParcial> * Coalesce(tb.porcentaje,1) </cfif>), <cf_dbfunction name="to_char"  args="a.FCid">,  <cf_dbfunction name="to_char"  args="a.ETnumero">,
            b.DTdescripcion, '#LvarETdocumento#', case when a.CDCcodigo is not null then '03' else '01' end,case when a.CDCcodigo is not null then a.CDCcodigo else sn.SNid end
        from ETransacciones a
        inner join DTransacciones b on a.FCid = b.FCid  and a.ETnumero = b.ETnumero
        <cfif Arguments.AnulacionParcial>
          left outer join #Arguments.TBanulacion# tb
              on b.DTlinea = tb.DTlinea
        </cfif>
        inner join CCTransacciones c on a.CCTcodigo = c.CCTcodigo   and a.Ecodigo = c.Ecodigo
        inner join CFuncional d on b.CFid = d.CFid  and b.Ecodigo = d.Ecodigo
          inner join SNegocios sn  on a.Ecodigo = sn.Ecodigo and a.SNcodigo = sn.SNcodigo
        where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
          and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lvarETnumero_sub#">
          and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
          and b.DTtipo = 'S'
          and (b.DTpreciou * b.DTcant) <> 0 and b.DTborrado = 0
          <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
            and b.DTlinea in (#arguments.LineasDetalle#) </cfif>
        </cfquery>

    </cffunction>
    <cffunction name="SigTalonarioDoc" access="public" returntype="query">
     <cfargument name="FCid"       type="numeric">
     <cfargument name="CCTcodigo"  type="string">
     <cfargument name="Tid"        type="numeric">

     <cfif isdefined('Arguments.Tid') and len(trim(Arguments.Tid)) gt 0>
        <cfquery name = "rsTalonario" datasource = "#session.dsn#">
         select #Arguments.Tid# as Tid from dual
        </cfquery>
     <cfelse>
        <cfquery name = "rsTalonario" datasource = "#session.dsn#">
         select Tid from TipoTransaccionCaja where  FCid = #Arguments.FCid# and CCTcodigo = '#Arguments.CCTcodigo#'
        </cfquery>
     </cfif>

      <cfif not rsTalonario.recordCount or rsTalonario.Tid EQ -1>
        <cfset MensajeError = "La Transaccion en aplicacion (#Arguments.CCTcodigo#), no tiene asociado un talonario.">
        <cfset MensajeError &= " para la caja:"&Arguments.FCid>
        <cf_ErrorCode code="-1" msg="#MensajeError#">
      </cfif>

      <cfquery name="rsRIserie" datasource="#session.dsn#">
         select RIserie
         from Talonarios
         where Ecodigo = <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer">
           and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTalonario.Tid#">
      </cfquery>

      <cfquery name="rsUpdate" datasource="#session.dsn#">
        declare @SigVal numeric
        update Talonarios set @SigVal = RIsig + 1, RIsig = RIsig + 1
         where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
           and Tid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsTalonario.Tid#">

         select   @SigVal as SigVal
      </cfquery>

       <cfquery name="rsRIsig" datasource="#session.dsn#">
         select #rsUpdate.SigVal# as RIsig, '#rsRIserie.RIserie#' as RIserie , #rsTalonario.Tid# as Tid
         from dual
      </cfquery>

      <cfreturn rsRIsig>
    </cffunction>

	<cffunction name="CreateTempDiferencial" returntype="string" output="false">
		 <cf_dbtemp name="FacTempDif_V1" returnvariable="DIFERENCIAL" datasource="#session.dsn#">
			<cf_dbtempcol name="INTLIN"    type="numeric"      identity="yes">
			<cf_dbtempcol name="INTORI"    type="char(4)"      mandatory="yes">
			<cf_dbtempcol name="INTREL"    type="int"          mandatory="yes">
			<cf_dbtempcol name="INTDOC"    type="char(20)"     mandatory="yes">
			<cf_dbtempcol name="INTREF"    type="varchar(25)"  mandatory="yes">

			<cf_dbtempcol name="INTMON"    type="money"        mandatory="yes">
			<cf_dbtempcol name="INTTIP"    type="char(1)"      mandatory="yes">

			<cf_dbtempcol name="INTDES"    type="varchar(80)"  mandatory="yes">

			<cf_dbtempcol name="INTFEC"    type="varchar(8)"   mandatory="yes">
			<cf_dbtempcol name="INTCAM"    type="float"        mandatory="yes">
			<cf_dbtempcol name="Periodo"   type="int"          mandatory="yes">
			<cf_dbtempcol name="Mes"       type="int"          mandatory="yes">
			<cf_dbtempcol name="Ccuenta"   type="numeric"      mandatory="yes">

			<cf_dbtempcol name="CFcuenta"  type="numeric"      mandatory="no">
			<cf_dbtempcol name="Mcodigo"   type="numeric"      mandatory="yes">
			<cf_dbtempcol name="Ocodigo"   type="int"          mandatory="yes">
			<cf_dbtempcol name="INTMOE"    type="money"        mandatory="yes">
			<cf_dbtempcol name="TIPO"      type="char(2)"      mandatory="yes">
			<cf_dbtempkey cols="INTLIN">
	  </cf_dbtemp>
	  <cfreturn DIFERENCIAL>
	</cffunction>
</cfcomponent>