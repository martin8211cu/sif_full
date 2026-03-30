<cfcomponent output="yes">
      <cf_dbfunction name="OP_concat"	returnvariable="_Cat">

<!---- Llenar la tabla de documentos Posteados de CxC ----->
       <cffunction name="InsertarDocumentosCxC" output="yes"  access="public" returntype="any">
        <cfargument name="CCTcodigo"      		type="string"   required="yes">
        <cfargument name="Ddocumento"      		type="string"   required="yes">
        <cfargument name="AnulacionParcial"     type="boolean"  required="yes">
        <cfargument name="TotalDetalles"        type="numeric"  required="yes">
        <cfargument name="Anulacion"      		type="boolean"  required="yes">
        <cfargument name="Vencimiento"     		type="numeric"  required="yes">
        <cfargument name="Contado"       		type="numeric"  required="yes" hint="1=Contado, 0=No es de contado">
        <cfargument name="Cuentacaja"       	type="numeric"  required="yes">
        <cfargument name="Retencion"       		type="numeric"  required="yes">
        <cfargument name="id_direccion"       	type="numeric"  required="no">
        <cfargument name="FCid"       		    type="numeric"  required="yes">
        <cfargument name="ETnumero"       		type="numeric"  required="yes">
        <cfargument name="Ecodigo"       		type="numeric"  required="yes">

       	<cfquery name="rsDatosIns" datasource="#session.dsn#">
             select fe.FechaVencimientoPago, fe.RESNidCobrador, fe.RESNidVendedor ,et.ETfecha
             from ETransacciones et
             inner join DTransacciones  dt
               on et.ETnumero = dt.ETnumero
              and et.FCid     = dt.FCid
              and et.Ecodigo  = dt.Ecodigo
            inner join FADRecuperacion fd
              on fd.DTlinea   = dt.DTlinea
             and fd.Ecodigo   = dt.Ecodigo
            inner join FAERecuperacion fe
               on fe.FAERid   = fd.FAERid
             and fe.Ecodigo   = fd.Ecodigo
           where et.ETnumero  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETnumero#">
             and et.FCid      =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
       	</cfquery>

        <!--- Se obtiene alguno de los vendedores registrados en el detalle de la factura ----->
        <cfquery name="rsVendedor" datasource="#session.dsn#">
             select dt.FVid
             from ETransacciones et
             inner join DTransacciones  dt
               on et.ETnumero = dt.ETnumero
              and et.FCid     = dt.FCid
              and et.Ecodigo  = dt.Ecodigo
           where et.ETnumero  =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.ETnumero#">
             and et.FCid      =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#arguments.FCid#">
             and dt.FVid is not null
             and dt.DTborrado <> 1
       	</cfquery>

        <cfif #arguments.Contado# Neq 1 and len(trim(#rsDatosIns.ETfecha#)) neq 0>
			<!--- mes auxiliar --->
            <cfquery name="mes" datasource="#session.DSN#">
                select Pvalor
                from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and Pcodigo = 60
            </cfquery>
            <!--- periodo auxiliar --->
            <cfquery name="periodo" datasource="#session.DSN#">
                select Pvalor
                from Parametros
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                and Pcodigo = 50
            </cfquery>

			<!---<cfthrow message="No existe la fecha en ETransacciones por lo cual no se puede validar el mes y periodo">--->

            <cfset LvarPeriodo = datepart("yyyy",rsDatosIns.ETfecha)>
            <cfset LvarMes = datepart("m",rsDatosIns.ETfecha)>

            <cfif mes.Pvalor neq LvarMes>
                <cfthrow message="El mes de la factura #LvarMes# es diferente al mes de auxiliares: #mes.Pvalor#. Favor verificar fechas">
            </cfif>
            <cfif periodo.Pvalor neq LvarPeriodo>
                <cfthrow message="El Periodo de la factura #LvarPeriodo# es diferente al periodo de auxiliares: #periodo.Pvalor#. Favor verificar fechas">
            </cfif>


        </cfif>
        <cfquery name="rsVerificaDocumento" datasource="#session.dsn#">
          select *
          from Documentos
          where
            Ecodigo = #Arguments.Ecodigo#
            and CCTcodigo = '#arguments.CCTcodigo#'
            and Ddocumento = '#arguments.Ddocumento#'
        </cfquery>

        <cfif rsVerificaDocumento.recordCount GT 0>
          <cfthrow message="El documento #arguments.Ddocumento#, con la transacción #arguments.CCTcodigo# ya existe.">
        </cfif>

        <cfquery name="rsInsert" datasource="#session.dsn#">
          insert Documentos (FCid, CFid, ETnumero, Ecodigo, CCTcodigo,Ddocumento,  Ocodigo,  SNcodigo, Mcodigo, Dtipocambio, Dtotal, Dsaldo, Dfecha, Dvencimiento,
                Ccuenta, Dtcultrev, Dusuario, Rcodigo, Dmontoretori, Dtref, Ddocref, DEdiasVencimiento, DEdiasMoratorio, TESDPaprobadoPendiente, EDtipocambioVal, EDtipocambioFecha,
                id_direccionFact, ETnombreDoc,DEobservacion,CDCcodigo,SNcodigoAgencia,Dlote,Dexterna,Dretporigen,DEidCobrador,DEidVendedor )
            select a.FCid, a.CFid,a.ETnumero, a.Ecodigo,'#arguments.CCTcodigo#','#arguments.Ddocumento#',a.Ocodigo, a.SNcodigo,
            a.Mcodigo, a.ETtc,
             <cfif isdefined('arguments.AnulacionParcial') and arguments.AnulacionParcial eq true>
                <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="#arguments.TotalDetalles#">,
              <cfelse>
                a.ETtotal ,
              </cfif>
              <cfif not Arguments.Anulacion>
                a.ETtotal,
              <cfelse>
                <cf_jdbcQuery_param cfsqltype="cf_sql_money" value="0">,
              </cfif>
              <cfif #arguments.Contado# eq 1>
              	#now()#,
              <cfelse>
               	a.ETfecha,
             </cfif>
              <cfif  #arguments.Contado# eq 1>
               	#now()#,
              <cfelse>
                   <!---- Si el el registro de ETransacciones tiene algun ligamen con FAEREcuperacion se pone la fecha de vencimiento de esta ultima. Sino el proceso sigue igual ---->
				   <cfif isdefined('rsDatosIns') and rsDatosIns.recordcount gt 0 and len(trim(#rsDatosIns.FechaVencimientoPago#)) gt 0>
                       <cf_jdbcquery_param cfsqltype="cf_sql_date" value="#rsDatosIns.FechaVencimientoPago#">,
                   <cfelse>
                      dateadd(dd, #arguments.Vencimiento#, a.ETfecha),
                   </cfif>
              </cfif>
              case when #arguments.Contado# = 1 then #arguments.Cuentacaja# else coalesce( sn.SNcuentacxc,a.Ccuenta) end,
              a.ETtc,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="#Arguments.usuario#">,
              case when a.Rcodigo <> null or a.Rcodigo <> '-1' then a.Rcodigo else null end,
              a.ETmontoRetencion , null, null, 0, 0, 0, a.ETtc,<cf_dbfunction name="now">,
              <cfif isdefined('arguments.id_direccion') and LEN(TRIM(arguments.id_direccion)) GT 0>
                #arguments.id_direccion#,
              <cfelse>
                 a.id_direccion,
              </cfif>
              a.ETnombredoc, a.ETobs,a.CDCcodigo,SNcodigo2,ETlote,ETexterna, 0
				<!---- Si Existe en FAERecuperacion uso ese cobrador sino se deja como estaba original ---->
                <cfif isdefined('rsDatosIns') and rsDatosIns.recordcount gt 0 and len(trim(#rsDatosIns.RESNidCobrador#)) gt 0>
                   ,(select DEid from RolEmpleadoSNegocios resnT where resnT.RESNid = #rsDatosIns.RESNidCobrador#)
                <cfelse>
                   ,(select DEid from RolEmpleadoSNegocios resnT where resnT.RESNid = a.RESNidCobrador)
                </cfif>
				<!--- ID vendedor --->
                <cfif isdefined('rsDatosIns') and rsDatosIns.recordcount gt 0 and len(trim(#rsDatosIns.RESNidVendedor#)) gt 0>
                   ,(select DEid from RolEmpleadoSNegocios resnT where resnT.RESNid = #rsDatosIns.RESNidVendedor#)
                <cfelseif isdefined('rsVendedor') and rsVendedor.recordcount gt 0 and len(trim(rsVendedor.FVid))  >
                   ,(select DEid from RolEmpleadoSNegocios resnT where resnT.RESNid = #rsVendedor.FVid#)
                <cfelse>
                  , null
                </cfif>

               from ETransacciones a
                     inner join CCTransacciones b
                        on a.Ecodigo = b.Ecodigo
                       and a.CCTcodigo = b.CCTcodigo
                     inner join SNegocios sn
                       on a.SNcodigo = sn.SNcodigo
                      and a.Ecodigo = sn.Ecodigo
                Left outer join  CuentasSocios c
                      on  a.Ecodigo = c.Ecodigo
                      and a.SNcodigo = c.SNcodigo
                      and a.CCTcodigo = c.CCTcodigo
                where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
                 and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
                  and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
            </cfquery>
      </cffunction>

<!---- Detalle del Documento ----->
       <cffunction name="InsertarDetDocumentosCxC" output="yes"  access="public" returntype="any">
        <cfargument name="CCTcodigo"      	    	type="string"   required="yes">
        <cfargument name="Ddocumento"      	    	type="string"   required="yes">
        <cfargument name="TienePagos"               type="boolean"  required="yes">
        <cfargument name="CuentaTransitoriaGeneral" type="numeric"  required="yes">
        <cfargument name="FCid"       		        type="numeric"  required="yes">
        <cfargument name="ETnumero"       		    type="numeric"  required="yes">
        <cfargument name="Ecodigo"       		    type="numeric"  required="yes">

       <cfquery name="rsInsert" datasource="#session.dsn#">
     insert DDocumentos ( Ecodigo,  CCTcodigo, Ddocumento, CCTRcodigo,  DRdocumento, DDlinea,  DDtotal, DDcodartcon, DDcantidad, DDpreciou, DDcostolin, DDdesclinea, DDtipo,DDescripcion,DDdescalterna,
        Alm_Aid, Dcodigo, Ccuenta, CFid, Ocodigo,DTlinea, DcuentaT, DesTransitoria,FPAEid, CFComplemento,Icodigo, DDimpuesto)
    select <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">,'#arguments.CCTcodigo#','#arguments.Ddocumento#','#arguments.CCTcodigo#','#arguments.Ddocumento#',b.DTlinea,
        b.DTtotal, case when b.Aid is null then b.Cid else b.Aid end, b.DTcant, b.DTpreciou, 0.00, b.DTdeslinea, b.DTtipo, b.DTdescripcion,b.DTdescalterna, b.Alm_Aid,
        b.Dcodigo, b.Ccuenta, b.CFid, b.Ocodigo,b.DTlinea, <cfif #arguments.TienePagos#>null,0 <cfelse> case when cf.CFACTransitoria = 1 then coalesce(cf.CFcuentatransitoria,#arguments.CuentaTransitoriaGeneral#) else null end, cf.CFACTransitoria
        </cfif>,b.FPAEid, b.CFComplemento,b.Icodigo, b.DTimpuesto
    from ETransacciones a
        inner join DTransacciones b
             on a.FCid = b.FCid
            and a.ETnumero = b.ETnumero
            and b.DTborrado = 0
        inner join CFuncional cf
            on b.CFid = cf.CFid
    where a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.FCid#">
    and a.ETnumero = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.ETnumero#">
      and a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.Ecodigo#">
     </cfquery>
</cffunction>
<!---- Historico del Documento ----->
       <cffunction name="InsertarHDocumentosCxC" output="yes"  access="public" returntype="any">
        <cfargument name="HDid"           type="numeric"  required="yes">
        <cfargument name="CCTcodigo"      type="string"   required="yes">
        <cfargument name="Ddocumento"     type="string"   required="yes">
        <cfargument name="Ecodigo"        type="numeric"  required="yes">
        <cfargument name="CC_calculoLin"  type="string"   required="yes">

 <cfquery name="rsSQL" datasource="#session.dsn#">
	insert into HDDocumentos (HDid,Ecodigo, CCTcodigo,Ddocumento, CCTRcodigo, DRdocumento, DDlinea, DDtotal, DDcodartcon, DDcantidad, DDpreciou,
						DDcostolin,	DDdesclinea,DDtipo,	DDescripcion,DDdescalterna,	Alm_Aid,Dcodigo,Ccuenta,CFid,Icodigo,OCid, OCTid, OCIid,
						DDid,DocrefIM,CCTcodigoIM,cantdiasmora,ContractNo,DDimpuesto,DDdescdoc,Ocodigo,DcuentaT,DesTransitoria,DTlinea,CFComplemento
					)
        select  #arguments.HDid#  ,	Ecodigo, CCTcodigo, Ddocumento, CCTRcodigo, DRdocumento, DDlinea, DDtotal, DDcodartcon, DDcantidad,
						DDpreciou,  DDcostolin,	DDdesclinea,DDtipo,DDescripcion,DDdescalterna,Alm_Aid,Dcodigo,Ccuenta,CFid,	Icodigo,
						OCid, OCTid, OCIid,	DDid,DocrefIM,CCTcodigoIM,cantdiasmora,ContractNo,
						coalesce(coalesce( DDimpuesto,(select sum(impuesto) from #arguments.CC_calculoLin# where DDid	= d.DDid)),0.00),
						coalesce((select sum(descuentoDoc) from #arguments.CC_calculoLin# where DDid	= d.DDid),0.00)
                        ,Ocodigo,DcuentaT,DesTransitoria,DTlinea,CFComplemento from DDocumentos d
				 where Ecodigo = #Arguments.Ecodigo# and CCTcodigo	= '#arguments.CCTcodigo#' and Ddocumento	= '#arguments.Ddocumento#'
       	</cfquery>
</cffunction>

<!---- Consulta Documento ----->
       <cffunction name="ConsultaDoc" output="yes"  access="public" returntype="query">
        <cfargument name="Ecodigo"        type="numeric"  required="yes">
        <cfargument name="CCTcodigo"      type="string"   required="yes">
        <cfargument name="Ddocumento"     type="string"   required="yes">
        <cfargument name="SNcodigo"       type="numeric"  required="yes">

       <cfquery name = "rsConsultaDoc" datasource ="#session.dsn#">
          select count(1) as existe from  Documentos
        	 where Ecodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
        	  and CCTcodigo  = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
              and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
              and SNcodigo   = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.SNcodigo#">
        </cfquery>
        <cfreturn rsConsultaDoc>
</cffunction>
<!---- Inserta Documento 2 ----->
       <cffunction name="InsertarDocumento2" output="yes"  access="public" returntype="any">
        <cfargument name="Ecodigo"        type="numeric"  required="yes">
        <cfargument name="CCTcodigo"      type="string"   required="yes">
        <cfargument name="Ddocumento"     type="string"   required="yes">

				<cfquery name="rsInserta" datasource="#session.dsn#">
				     insert Documentos(Ecodigo, CCTcodigo ,Ddocumento ,Ocodigo ,SNcodigo ,Mcodigo ,Ccuenta ,Rcodigo
							,Icodigo ,Dtipocambio ,Dtotal ,Dsaldo ,Dfecha ,Dvencimiento ,DfechaAplicacion ,Dtcultrev ,Dusuario
							,Dtref ,Ddocref ,Dmontoretori ,Dretporigen ,Dreferencia ,DEidVendedor ,DEidCobrador ,id_direccionFact
							,id_direccionEnvio ,CFid ,DEdiasVencimiento ,DEordenCompra ,DEnumReclamo ,DEobservacion ,DEdiasMoratorio
							,BMUsucodigo ,TESDPaprobadoPendiente ,EDtipocambioFecha ,EDtipocambioVal ,EDid ,CDCcodigo
							,TESRPTCid ,TESRPTCietu ,FCid ,ETnumero ,ETnombreDoc)
							select Ecodigo, CCTcodigo ,Ddocumento ,Ocodigo ,SNcodigo ,Mcodigo ,Ccuenta ,Rcodigo
							,Icodigo ,Dtipocambio ,Dtotal ,Dsaldo ,Dfecha ,Dvencimiento ,DfechaAplicacion ,Dtcultrev ,Dusuario
							,Dtref ,Ddocref ,Dmontoretori ,Dretporigen ,Dreferencia ,DEidVendedor ,DEidCobrador ,id_direccionFact
							,id_direccionEnvio ,CFid ,DEdiasVencimiento ,DEordenCompra ,DEnumReclamo ,DEobservacion ,DEdiasMoratorio
							,BMUsucodigo ,0.00  as TESDPaprobadoPendiente ,EDtipocambioFecha ,EDtipocambioVal ,EDid ,CDCcodigo
							,TESRPTCid ,TESRPTCietu ,FCid ,ETnumero ,ETnombreDoc
							from HDocumentos
							where	CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.CCTcodigo#">
							and Ddocumento = <cfqueryparam cfsqltype="cf_sql_char" value="#arguments.Ddocumento#">
							and  Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#arguments.Ecodigo#">
				</cfquery>
</cffunction>
</cfcomponent>