<cfif isdefined("Form.chk")>
    <cfloop index="LvarLin" list="#Form.chk#" delimiters=",">
       <cfset LvarDetOC = #ListToArray(LvarLin, "|")#>
	   <cfset LvarPos1IDdocumento = LvarDetOC[1]>
	   <cfset LvarPos2IDRemision = LvarDetOC[2]>
       <cfquery name = "rsLineasDeRemision" datasource = "#session.DSN#">
           select ddrem.linea from DDocumentosCPR ddrem where
           ddrem.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos2IDRemision#">
       </cfquery>
       
       <cfloop query="rsLineasDeRemision">
            <cfset lineaRemision = #rsLineasDeRemision.linea#>
            <cftransaction>
                <cfquery name="rsLineaRem" datasource="#Session.DSN#">
                    select Icodigo, codIEPS,CFid from DDocumentosCPR
                        where Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lineaRemision#">
                </cfquery>
                <cfquery name="rsExistImpAndIEPS" datasource="#Session.DSN#">
                    select * from DDocumentosCxP 
                        where Icodigo = '#rsLineaRem.Icodigo#' and 
                        <cfif len(trim(rsLineaRem.codIEPS)) EQ 0>
                            codIEPS is null
                        <cfelse>
                        codIEPS = '#rsLineaRem.codIEPS#'
                        </cfif>
                         and CFid= #rsLineaRem.CFid#
                            and IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
                            
                </cfquery>

                <cfset LINEA_FACTURA_GLOBAL = 0>
                <cfif rsExistImpAndIEPS.recordCount EQ 0>
                    <!--- Insertar linea de la remision en la linea de la factura --->
                    <cfquery name="rsInsert" datasource="#Session.DSN#">
                        insert into DDocumentosCxP (IDdocumento, Cid, Alm_Aid, Ecodigo, Dcodigo, Ccuenta, CFcuenta, CFid, Aid, DDdescripcion, DDdescalterna,
                                    DDcantidad, DDpreciou, DDdesclinea, DDporcdesclin, DDtotallinea, DDtipo, Icodigo, Ucodigo, FPAEid, CFComplemento, PCGDid, OBOid,codIEPS,DDMontoIeps, 
                                    CPDCid, CTDContid)
                            select	#LvarPos1IDdocumento# as IDdocumento,
                                    a.Cid,
                                    a.Alm_Aid,
                                    a.Ecodigo,
                                    null as Dcodigo,
                                    (
                                        select cfin.Ccuenta
                                        from CFinanciera cfin
                                        where cfin.CFcuenta = a.CFcuenta
                                    ),
                                    a.CFcuenta,
                                    a.CFid,
                                    a.Aid,
                                    a.DDdescripcion,
                                    LEFT(LTRIM(RTRIM(a.DDdescalterna)),255) as DDdescalterna,
                                    a.DDcantidad,
                                    a.DDpreciou,
                                    a.DDdesclinea,
                                    a.DDporcdesclin,
                                    a.DDtotallinea,
                                    a.DDtipo,
                                    a.Icodigo,
                                    null as Ucodigo,
                                    a.FPAEid,
                                    a.CFComplemento,
                                    a.PCGDid,
                                    a.OBOid,
                                    a.codIEPS,
                                    a.DDMontoIeps as IEPS,
                                    a.CPDCid,
                                    a.CTDContid
                            from DDocumentosCPR a
                                left join CFuncional cf
                                    on cf.CFid = a.CFid
                                    and cf.Ecodigo = a.Ecodigo
                            where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and a.Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lineaRemision#">

                            SELECT SCOPE_IDENTITY() as lastLineaRemision
                    </cfquery>
                    <!--- Actualizar la linea de la orden asociada a la de la remision--->
                    <cfquery name = "rsUpdateLineaRemision" datasource="#Session.DSN#">
                        update DDocumentosCPR set DFacturalinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsInsert.lastLineaRemision#">
                            where Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lineaRemision#">
                    </cfquery>
                    <cfset LINEA_FACTURA_GLOBAL = #rsInsert.lastLineaRemision#>
                <cfelse>
                    <cfquery name = "rsDataLineaRemision" datasource="#Session.DSN#">
                        select a.DDpreciou, a.DDdesclinea, a.DDporcdesclin, a.DDtotallinea, a.DDMontoIeps
                            from DDocumentosCPR a
                                where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                                and a.Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lineaRemision#">
                    </cfquery> 
                    <!--- Sumar los valores de la linea de la factura con la de la remision --->
                    <cfquery name = "rsUpdateLineaRemision" datasource="#Session.DSN#">
                        update DDocumentosCxP set DDDESCLINEA = (DDDESCLINEA + #rsDataLineaRemision.DDDESCLINEA#),
                            DDMONTOIEPS = (DDMONTOIEPS + #rsDataLineaRemision.DDMONTOIEPS#), 
                            DDPORCDESCLIN = (DDPORCDESCLIN + #rsDataLineaRemision.DDPORCDESCLIN#),
                            DDPRECIOU = (DDPRECIOU + #rsDataLineaRemision.DDPRECIOU#),
                            DDTOTALLINEA = (DDTOTALLINEA + #rsDataLineaRemision.DDTOTALLINEA#)
                            where Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistImpAndIEPS.Linea#">
                    </cfquery>
                    <!--- Actualizar la linea de la remision asociada a la de la factura --->
                    <cfquery name = "rsUpdateLineaRemision" datasource="#Session.DSN#">
                        update DDocumentosCPR set DFacturalinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsExistImpAndIEPS.Linea#">
                            where Linea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#lineaRemision#">
                    </cfquery>
                    <cfset LINEA_FACTURA_GLOBAL = #rsExistImpAndIEPS.Linea#>
                </cfif>

                <!--- Elimina el descuento si es mayor que el total linea --->
                    <!---<cfquery datasource="#session.DSN#">
                        update DDocumentosCxP
                        set DDdesclinea		= 0
                            , DDporcdesclin	= 0
                        where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
                        and DRemisionlinea 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#lineaRemision#">
                        and DDdesclinea 	> DDcantidad * DDpreciou
                    </cfquery>--->

                    <!--- Calcula el total linea --->
                    <!---<cfquery datasource="#session.DSN#">
                        update DDocumentosCxP
                        set DDtotallinea		= round((DDcantidad * DDpreciou)- DDdesclinea,2)
                        where IDdocumento	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
                        and DRemisionlinea 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#lineaRemision#">
                    </cfquery>--->

                    <cfquery name="rsTotalImpuesto" datasource="#session.DSN#">
                        select coalesce(sum(case when (b.DDtipo = 'S' or b.DDtipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN  
                                    round(DDtotallinea * d.DIporcentaje/100,2)
                            when c.IEscalonado = 0 then 
                                    round(DDtotallinea * d.DIporcentaje/100,2)
                            else  
                                round((DDtotallinea+ round(DDtotallinea * COALESCE(di.ValorCalculo/100,0),2)) * d.DIporcentaje/100,2) 
                            end),0) as TotalImpuesto				
                        from EDocumentosCxP a left outer join DDocumentosCxP b
                        on a.IDdocumento = b.IDdocumento and
                            a.Ecodigo = b.Ecodigo left outer join Impuestos c
                        on a.Ecodigo = c.Ecodigo and
                            b.Icodigo = c.Icodigo left outer join DImpuestos d
                        on c.Ecodigo = d.Ecodigo and
                            b.Icodigo = d.Icodigo
                        left join Impuestos di
                            on b.Ecodigo=di.Ecodigo
                            and b.codIEPS=di.Icodigo
                        left join Conceptos e
                            on e.Cid = b.Cid				
                        left join Articulos f
                            on f.Aid= b.Aid		 
                        where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
                        and  c.Icompuesto = 1
                    </cfquery>

                    <cfquery name="rsTotalImpuesto1" datasource="#session.DSN#">
                        select coalesce(sum(case when (b.DDtipo = 'S' or b.DDtipo = 'A') and (e.afectaIVA = 1 or f.afectaIVA = 1) THEN  
                                    round(DDtotallinea * c.Iporcentaje/100,2)
                            when c.IEscalonado = 0 then 
                                    round(DDtotallinea * c.Iporcentaje/100,2)
                            else  
                                round((DDtotallinea+ round(DDtotallinea * COALESCE(di.ValorCalculo/100,0),2)) * c.Iporcentaje/100,2) 
                            end),0) as TotalImpuesto
                        from EDocumentosCxP a left outer join DDocumentosCxP b
                        on a.Ecodigo = b.Ecodigo and
                            a.IDdocumento = b.IDdocumento left outer join Impuestos c
                        on b.Ecodigo = c.Ecodigo and
                            b.Icodigo = c.Icodigo
                        left join Impuestos di
                            on a.Ecodigo=di.Ecodigo
                            and b.codIEPS=di.Icodigo
                        left join Conceptos e
                            on e.Cid = b.Cid				
                        left join Articulos f
                            on f.Aid= b.Aid		 
                        where a.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
                        and c.Icompuesto = 0
                    </cfquery>

                    <cfquery name="rsTotal" datasource="#session.DSN#">
                        select coalesce(sum(a.DDtotallinea),0.00) as Total
                        from DDocumentosCxP a inner join EDocumentosCxP b
                        on a.IDdocumento = b.IDdocumento
                        and a.Ecodigo = b.Ecodigo
                        where b.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
                    </cfquery>

                    <cfquery name="rsTotalIEPS" datasource="#session.DSN#">
                        --select coalesce(sum(round(a.DDtotallinea * COALESCE(d.ValorCalculo/100,0),2)),0) as MotoIEPS 
                        select coalesce(sum(round(a.DDMontoIeps,2)),0) as MotoIEPS
                        from DDocumentosCxP a inner join EDocumentosCxP b
                        on a.IDdocumento = b.IDdocumento
                        and a.Ecodigo = b.Ecodigo
                        left join Impuestos d
                        on a.Ecodigo=d.Ecodigo
                        and a.codIEPS=d.Icodigo  
                        where b.IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
                    </cfquery>

                    <!--- ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
                    <cfquery name="rsUpdateE" datasource="#session.DSN#">
                        update EDocumentosCxP
                            set EDimpuesto = round(#rsTotalImpuesto.TotalImpuesto# + #rsTotalImpuesto1.TotalImpuesto#,2)
                                ,EDtotal = #rsTotal.Total#
                                    + round(#rsTotalImpuesto.TotalImpuesto# + #rsTotalImpuesto1.TotalImpuesto#,2)
                                    -  EDdescuento + #rsTotalIEPS.MotoIEPS#
                                ,EDTiEPS = #rsTotalIEPS.MotoIEPS# 		  
                        where IDdocumento = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarPos1IDdocumento#">
                        and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                    </cfquery>

            </cftransaction>
        </cfloop>
    </cfloop>

    <script language="JavaScript" type="text/javascript">
		if (window.opener.funcRefrescar) {window.opener.funcRefrescar()}
		window.close();
	</script>
</cfif>