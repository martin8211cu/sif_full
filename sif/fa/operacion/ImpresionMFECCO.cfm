<!--- Se agrega el  complemento  INE para el SAT Mayo 2016
      Se Agrega el  Catlogo  de Métodos de PAgo del  SAT Junio 2016
	   Se configura el  RFC Generico para Socios Extranjeros 11OCT2016
	  Realizó: Israel Rodriguez---->

        <!---Llamamos al componente de Ruta --->
     <cf_foldersFacturacion name = "ruta">
     
    <cfprocessingdirective pageencoding="UTF-8">
    <!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
    <html xmlns="http://www.w3.org/1999/xhtml">
    <body>
      <cfoutput>
        <cfif not isdefined("btnDownload")>
          <cf_templatecss>
        </cfif>
      </cfoutput>

      <!--- RFC EMPRESA --->
      <cfquery name="rsRFCEmpresa" datasource="#session.DSN#">
        select EIdentificacion from Empresas
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
      </cfquery>
      <cfif isdefined('form.OImpresionID')>
      <cfquery name="rsDatosfac" datasource="#session.DSN#">
        SELECT distinct c.SNnombre, c.SNid, c.id_direccion,
        case when substring(c.SNidentificacion,1,9)  = 'EXT010101' then 'XEXX010101000'
        when right(RTRIM(c.SNidentificacion),3) = 'EXT' then 'XEXX010101000'

                else c.SNidentificacion
                end as SNidentificacion, d.direccion1 as SNdireccion, COALESCE(d.direccion2, '') as SNdireccion2,
            OItotal, OIieps, OItotal as OItotalLetras, OIimpuesto, OIdescuento,
                    OItotal + OIdescuento - OIimpuesto - OIieps as OIsubtotal,
            ltrim(rtrim(convert(char,OIfecha,102)))+' '+convert(char,OIfecha,108) as OIfecha,
                    substring(convert(char, OIfecha, 112),7,2)+'/'+
              case
            when substring(convert(char, OIfecha, 112),5,2) = '01' then 'Ene'
            when substring(convert(char, OIfecha, 112),5,2) = '02' then 'Feb'
            when substring(convert(char, OIfecha, 112),5,2) = '03' then 'Mar'
            when substring(convert(char, OIfecha, 112),5,2) = '04' then 'Abr'
            when substring(convert(char, OIfecha, 112),5,2) = '05' then 'May'
            when substring(convert(char, OIfecha, 112),5,2) = '06' then 'Jun'
            when substring(convert(char, OIfecha, 112),5,2) = '07' then 'Jul'
            when substring(convert(char, OIfecha, 112),5,2) = '08' then 'Ago'
            when substring(convert(char, OIfecha, 112),5,2) = '09' then 'Sep'
            when substring(convert(char, OIfecha, 112),5,2) = '10' then 'Oct'
            when substring(convert(char, OIfecha, 112),5,2) = '11' then 'Nov'
            when substring(convert(char, OIfecha, 112),5,2) = '12' then 'Dic'
              end+'/'+
            substring(convert(char, OIfecha, 112),1,4)+' '+
            substring(convert(varchar,OIfecha,114),1,8) as fecfac,

            LTRIM(RTRIM(OIDdescripcion)) as OIDdescripcion, LTRIM(RTRIM(upper(OIDdescnalterna))) as OIDdescnalterna ,
            OIDCantidad,OIDtotal,OIDPrecioUni,  OIObservacion,Observaciones,
            OIDdescuento, OIdiasvencimiento,m.Miso4217,f.PFTcodigo,pft.PFTtipo,
            OIvencimiento,'C.P.'+codPostal +', '+ciudad+','+estado as dir,
            a.OImpresionID as NUMERODOC,c.SNemail,
                    ltrim(rtrim(seriefacele)) as serie, ltrim(rtrim(foliofacele)) as fac1,  CCTcodigo,
            case CCTcodigo
              when  'FC' then
                'FE_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele))
              ELSE CCTCodigo+'_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele))
            end as fac,
            ltrim(rtrim(numcerfacele)) AS numcerfacele,
            anoaprofacele,NUMaprofacele,
            ltrim(rtrim(cadorifacele)) as cadena,ltrim(rtrim(fe.SelloDigital)) as sello,
            TP.nombre_TipoPago,TP.TipoPagoSAT,RF.nombre_RegFiscal,m.Mnombre,OItipoCambio, Cta_tipoPago,OIDetalle,Udescripcion,
            fe.timbre, fe.selloSAT, fe.certificadoSAT, fe.cadenaSAT, fe.fechaTimbrado
            ,coalesce(OIieps,0) OIieps ,b.codIEPS, coalesce(b.OIMontoIEPSLinea,0) as OIMontoIEPSLinea,
        c.usaINE, c.SNIdContabilidadINE, c.SNTipoPoliticoINE, a.OITipoProcesoINE, a.OIComiteAmbito, a.OIEntidad, a.OIIdContabilidadINE, a.c_metPago,
        con.ClaveSAT, u.ClaveSAT as UniSAT
          <!--- coalesce(''+dp.Pnombre+' '+dp.Papellido1+' '+dp.Papellido2,'') as NombreUsu--->
        FROM FAEOrdenImpresion a
            inner join FADOrdenImpresion b
            on a.OImpresionID = b.OImpresionID
            and a.Ecodigo = b.Ecodigo
            <!---JARR se agrego este inner para obtener el SN corporativo--->
            INNER JOIN SNegocios sn
            on a.SNcodigo = sn.SNcodigo
            and a.Ecodigo = sn.Ecodigo 
            INNER JOIN SNegocios c
            on C.SNid = CASE WHEN sn.SNidPadre is null
                             THEN sn.SNid
                        ELSE sn.SNidPadre
                        END 
            and a.Ecodigo = c.Ecodigo
            LEFT JOIN  DireccionesSIF d
            on a.id_direccionFact = d.id_direccion
            LEFT JOIN  Monedas m
            on a.Mcodigo = m.Mcodigo
              INNER JOIN FAPreFacturaE f
              on a.OIdocumento = f.DdocumentoREF
                    and a.Ecodigo = f.Ecodigo
              INNER JOIN FAPFTransacciones pft
                    on f.Ecodigo = pft.Ecodigo
                    and f.PFTcodigo = pft.PFTcodigo
              INNER JOIN FAPreFacturaD pfd on f.Ecodigo=pfd.Ecodigo
                    and f.IDpreFactura=pfd.IDpreFactura and pfd.Linea = b.OIDetalle
              INNER JOIN (
                  select Aid,null as Cid,Ucodigo,Ecodigo, ClaveSAT
                  from Articulos
                  where Ecodigo = #Session.Ecodigo#
                  union
                  select null as Aid, Cid,Ucodigo,Ecodigo, ClaveSAT 
                  from Conceptos
                  where Ecodigo = #Session.Ecodigo#
              ) con ON pfd.Ecodigo =con.Ecodigo AND (con.Cid=pfd.Cid or con.Aid = pfd.Aid) and pfd.Linea = b.OIDetalle
              INNER JOIN Unidades u on u.Ecodigo=con.Ecodigo
                    and con.Ucodigo= u.Ucodigo
              LEFT JOIN FATipoPago TP
                    on TP.Ecodigo = a.Ecodigo and TP.codigo_TipoPago = a.codigo_TipoPago
              LEFT JOIN FARegFiscal RF
                    on RF.Ecodigo = a.Ecodigo and RF.ClaveSAT = a.codigo_RegFiscal
               inner join FA_CFDI_Emitido fe
                    on a.Ecodigo = fe.Ecodigo and a.OImpresionID =fe.OImpresionID
        WHERE a.OImpresionID =  #OImpresionID# and a.Ecodigo=#session.Ecodigo#
                    and fe.stsTimbre=1
                    order by OIDetalle
      </cfquery>
        <cfset lVarTipoPago  = numberformat(rsDatosfac.TipoPagoSAT,"00") & ' ' &rsDatosfac.nombre_TipoPago>
        <cfset reciboPagoCxC = 0>
	<cfelseif isdefined("form.iddoccompensacion") AND #form.iddoccompensacion# GT 0>
		<!--- COMPENSACION DE DOCUMENTOS --->
		<cfset documentoPago = Session.DocPago>
		<cfset form.isCompensacion = true>
		<cfquery name="rsDatosfac" datasource="#session.dsn#">
			SELECT top 1 e.idDocCompensacion,
			           e.Ecodigo,
			           e.CCTcodigo,
			           e.DocCompensacion AS Pcodigo,
			           e.Mcodigo AS McodigoP,
			           e.SNcodigo,
			           hcc.Dtipocambio AS OItipoCambio,
			           cc.Dmonto AS Ptotal,
			           cp.CPTcodigo AS Doc_CCTcodigo,
			           cp.Ddocumento AS DocumentoPagado,
			           cp.Dmonto AS MontoPagoDoc,
			           cp.Dmonto AS DPmontodoc,
			           hcp.Dtipocambio AS DPtipocambio,
			           cp.Dmonto AS DPtotal,
			           ltrim(rtrim(SUBSTRING(ltrim(rtrim(convert(char,getdate(), 120))), 1, 10)+'T'+convert(char,getdate(), 108))) AS fecfac,
			           CASE
			               WHEN CONVERT(char, TblMb.Dfecha, 108) = '00:00:00' THEN LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, TblMb.Dfecha, 120))), 1, 10) + 'T12:00:00'))
			               ELSE LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, TblMb.Dfecha, 120))), 1, 10) + 'T' + CONVERT(char, TblMb.Dfecha, 108)))
			           END AS fechaAplicaPago,
			           LTRIM(RTRIM(SUBSTRING(LTRIM(RTRIM(CONVERT(char, GETDATE(), 120))), 1, 10) + 'T' + CONVERT(char, GETDATE(), 108))) AS FechaEnc,
			           '17' AS CodTipoPago,
			           sn.SNnombre,
			           sn.SNIdentificacion,
			           sn.SNdireccion,
			           sn.SNid,
			           sn.id_direccion,
			           d.direccion2 AS SNdireccion2,
			           sn.usaINE,
			           'C.P.'+d.codPostal +', '+d.ciudad+','+d.estado AS dir,
			           m.Mnombre,
			           sn.SNemail,
			           b.timbre,
			           b.docPago,
			           b.SelloDigital AS sello,
			           b.certificadoSAT,
			           b.cadenaSAT,
			           b.selloSAT,
			           b.Serie,
			           b.Folio AS fac1,
			           b.fechaTimbrado,
			           c.NoCertificado AS numcerfacele,
			           rf.nombre_RegFiscal,
			           CASE
			               WHEN d.direccion1 <> '' THEN CONCAT(d.direccion1, d.direccion2, ', ', d.ciudad, ', ', d.estado, ', C.P. ', d.codPostal)
			               ELSE sn.SNdireccion
			           END AS DireccionCompleta,
			           b.Serie + convert(varchar,b.Folio) + '_' +'#documentoPago#' AS fac,
			           b.xmlTimbrado
			FROM DocCompensacion e
			INNER JOIN DocCompensacionDCxC cc ON e.idDocCompensacion = cc.idDocCompensacion
			AND e.Ecodigo = cc.Ecodigo
			INNER JOIN HDocumentos hcc ON hcc.Ddocumento = cc.Ddocumento
			AND hcc.Ecodigo = cc.Ecodigo
			INNER JOIN DocCompensacionDCxP cp ON e.idDocCompensacion = cp.idDocCompensacion
			INNER JOIN HEDocumentosCP hcp ON hcp.Ddocumento = cp.Ddocumento
			AND hcp.Ecodigo = cc.Ecodigo
      INNER JOIN SNegocios ssn
        on e.SNcodigo = ssn.SNcodigo
        and e.Ecodigo = ssn.Ecodigo 
			INNER JOIN SNegocios sn  
        on sn.SNid = CASE WHEN ssn.SNidPadre is null
                             THEN ssn.SNid
                        ELSE ssn.SNidPadre
                        END 
        and  e.Ecodigo=sn.Ecodigo
			LEFT JOIN FA_CFDI_Emitido b ON e.Ecodigo=b.Ecodigo
			AND e.DocCompensacion=b.docPago
			LEFT JOIN RH_CFDI_Certificados c ON b.Ecodigo=c.Ecodigo
			INNER JOIN FARegFiscal rf ON rf.Ecodigo=e.Ecodigo
			LEFT JOIN DireccionesSIF d ON sn.id_direccion = d.id_direccion
			LEFT JOIN Monedas m ON e.Mcodigo = m.Mcodigo
			INNER JOIN
			  (SELECT b.Dfecha,
			          b.Ecodigo,
			          b.Ddocumento
			   FROM BMovimientos b
			   INNER JOIN CCTransacciones t ON t.Ecodigo = b.Ecodigo
			   AND t.CCTcodigo = b.CCTcodigo
			   WHERE t.CCTtipo = 'C') TblMb ON TblMb.Ecodigo = e.Ecodigo
			AND e.DocCompensacion = TblMb.Ddocumento
			WHERE e.idDocCompensacion = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.idDocCompensacion#">
			AND e.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			ORDER BY fechaTimbrado DESC
		</cfquery>
		<cfset reciboPagoCxC = 2>
    <cfelse>
      <cfset documentoPago = Session.DocPago>
      <cfquery name="rsDatosfac" datasource="#session.dsn#">
         select ep.Ecodigo, ep.CCTcodigo, ltrim(rtrim(ep.Pcodigo)) as Pcodigo, ep.Ocodigo, ep.Mcodigo as McodigoP, ep.SNcodigo,
         ep.Ptipocambio as OItipoCambio, ep.Ptotal, ep.CBid, dp.DPid, dp.Doc_CCTcodigo, dp.Ddocumento DocumentoPagado, dp.DPmonto MontoPagoDoc,
         dp.DPmontodoc, dp.DPtipocambio, dp.DPtotal,
         ltrim(rtrim(SUBSTRING(ltrim(rtrim(convert(char,getdate(),120))),1,10)+'T'+convert(char,getdate(),108))) as fecfac,
         sn.SNnombre, sn.SNIdentificacion, sn.SNdireccion, sn.SNid, sn.id_direccion, d.direccion2 as SNdireccion2, sn.usaINE,
           'C.P.'+d.codPostal +', '+d.ciudad+','+d.estado as dir, m.Mnombre,sn.SNemail,
           b.timbre, b.docPago, b.SelloDigital as sello, b.certificadoSAT, b.cadenaSAT, b.selloSAT, b.Serie, b.Folio as fac1,
           b.fechaTimbrado, c.NoCertificado as numcerfacele, rf.nombre_RegFiscal,
           b.Serie + convert(varchar,b.Folio) + '_' +'#documentoPago#' as fac, b.xmlTimbrado
         from Pagos ep
              inner join DPagos dp on ep.Ecodigo=dp.Ecodigo and ep.CCTcodigo=dp.CCTcodigo and ep.Pcodigo=dp.Pcodigo
               INNER JOIN SNegocios ssn
                on ep.SNcodigo = ssn.SNcodigo
                and ep.Ecodigo = ssn.Ecodigo 
               INNER JOIN SNegocios sn 
                on sn.SNid = CASE WHEN ssn.SNidPadre is null
                                 THEN ssn.SNid
                            ELSE ssn.SNidPadre
                            END 
              and  ep.Ecodigo=sn.Ecodigo
           inner join FA_CFDI_Emitido b on  ep.Ecodigo=b.Ecodigo and ep.Pcodigo=b.docPago
           inner join RH_CFDI_Certificados c on b.Ecodigo=c.Ecodigo
           inner join FARegFiscal rf on rf.Ecodigo=ep.Ecodigo
           left JOIN  DireccionesSIF d on sn.id_direccion = d.id_direccion
           left JOIN  Monedas m on ep.Mcodigo = m.Mcodigo
         where ep.Ecodigo   = #session.Ecodigo#
        and  dp.Pcodigo   = <cfqueryparam cfsqltype="cf_sql_varchar" value="#documentoPago#">
      </cfquery>
      <cfif isdefined('rsDatosfac') and rsDatosfac.RecordCount GT 0>
        <cfset reciboPagoCxC =1>
      <cfelse>
        <cfquery name="rsDatosfac" datasource="#session.dsn#">
           SELECT TOP 1 ef.Ecodigo,
                     ef.CCTcodigo,
                     ltrim(rtrim(ef.Ddocumento)) AS Pcodigo,
                     ef.Mcodigo AS McodigoP,
                     ef.SNcodigo,
                     ef.EFtipocambio AS OItipoCambio,
                     ef.EFtotal AS Ptotal,
                     df.CCTRcodigo AS Doc_CCTcodigo,
                     df.DRdocumento AS DocumentoPagado,
                     df.DFmonto AS MontoPagoDoc,
                     df.DFmontodoc AS DPmontodoc,
                     df.DFtipocambio AS DPtipocambio,
                     df.DFtotal AS DPtotal,
           		     ltrim(rtrim(SUBSTRING(ltrim(rtrim(convert(char,getdate(),120))),1,10)+'T'+convert(char,getdate(),108))) as fecfac,
                     sn.SNnombre,
                     sn.SNIdentificacion,
                     sn.SNdireccion,
                     sn.SNid,
                     sn.id_direccion,
                     d.direccion2 AS SNdireccion2,
                     sn.usaINE,
                     'C.P.'+d.codPostal +', '+d.ciudad+','+d.estado AS dir,
                     m.Mnombre,
                     sn.SNemail,
                     b.timbre,
                     b.docPago,
                     b.SelloDigital AS sello,
                     b.certificadoSAT,
                     b.cadenaSAT,
                     b.selloSAT,
                     b.Serie,
                     b.Folio AS fac1,
                     b.fechaTimbrado,
                     c.NoCertificado AS numcerfacele,
                     rf.nombre_RegFiscal,
                     case
                      when d.direccion1 <> '' THEN CONCAT(d.direccion1, d.direccion2, ', ', d.ciudad, ', ', d.estado, ', C.P. ', d.codPostal)
                      else sn.SNdireccion
                      end as DireccionCompleta,
                     b.Serie + convert(varchar,b.Folio) + '_' +'#documentoPago#' AS fac,
                     b.xmlTimbrado
           from <cfif isdefined("lvarRegenera") AND #lvarRegenera#>HEFavor<cfelse>EFavor</cfif> ef
          INNER JOIN <cfif isdefined("lvarRegenera") AND #lvarRegenera#>HDFavor<cfelse>DFavor</cfif> df ON ef.Ecodigo = df.Ecodigo
          AND ef.CCTcodigo=df.CCTcodigo
          AND ef.Ddocumento=df.Ddocumento
          INNER JOIN SNegocios ssn
                on ef.SNcodigo = ssn.SNcodigo
                and ef.Ecodigo = ssn.Ecodigo 
          INNER JOIN SNegocios sn 
                on sn.SNid = CASE WHEN ssn.SNidPadre is null
                                 THEN ssn.SNid
                            ELSE ssn.SNidPadre
                            END 
              and  ef.Ecodigo=sn.Ecodigo
          LEFT JOIN FA_CFDI_Emitido b ON ef.Ecodigo=b.Ecodigo
          AND ef.Ddocumento=b.docPago
           left join RH_CFDI_Certificados c on b.Ecodigo=c.Ecodigo
           inner join FARegFiscal rf on rf.Ecodigo=ef.Ecodigo
           left JOIN  DireccionesSIF d on sn.id_direccion = d.id_direccion
           left JOIN  Monedas m on ef.Mcodigo = m.Mcodigo
          WHERE ef.Ecodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.ecodigo#">
           and  ef.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#documentoPago#">
           <cfif isdefined("lvarRegenera") AND #lvarRegenera#>AND ef.Cancelado = 0</cfif>
          ORDER BY fechaTimbrado DESC
        </cfquery>

        <cfif isdefined('rsDatosfac') and rsDatosfac.RecordCount GT 0>
          <cfset reciboPagoCxC =2>
        </cfif>
      </cfif>
    </cfif>


      <!--- VALIDA DIRECCIONES FISCALES --->
      <!--- VARIABLES --->
      <cfparam name="rsValFiscE.DirecFisc"        default="0">
      <cfparam name="rsValFiscR.DirecFisc"        default="0">
      <cfparam name="rsDatosEmpresa.NumInt"       default="">
      <cfparam name="rsDatosEmpresa.Localidad"    default="">
      <cfparam name="rsDatosEmpresa.Referencia"   default="">
      <cfparam name="rsDomFiscCliente.NumInt"     default="">
      <cfparam name="rsDomFiscCliente.Localidad"  default="">
      <cfparam name="rsDomFiscCliente.Referencia" default="">
      <!--- VALIDA DOMICILIO FISCAL EMISOR--->
      <cfquery name="rsValFiscE" datasource="#session.dsn#">
          SELECT  DirecFisc
          FROM    Empresas
          WHERE   Ecodigo = #session.Ecodigo#
      </cfquery>

      <!--- VALIDA DOMICILIO FISCAL CLIENTE --->
      <cfquery name="rsValFiscR" datasource="#session.DSN#">
        SELECT  d.SNDireccionFiscal as DirecFisc
        FROM  SNegocios s
            INNER JOIN SNDirecciones d
            ON s.SNid = d.SNid
        WHERE   s.SNid = #rsDatosfac.SNid#
      </cfquery>

      <!--- EMPRESA --->
      <cfif rsValFiscE.DirecFisc EQ 1>
        <cfquery name="rsDatosEmpresa" datasource="#session.dsn#">
            SELECT  e.Enombre, Calle, NumExt, NumInt, Colonia, Localidad, Referencia, Delegacion, es.Estado, Pais, es.CodPostal, ciudad
            FROM    Empresas es
            inner join Empresa e
              on es.Ecodigo = e.Ereferencia
            inner join Direcciones d
              on e.id_direccion = d.id_direccion
            WHERE   es.Ecodigo = #session.Ecodigo#
        </cfquery>
      <cfelse>
        <cfquery name="rsDatosEmpresa" datasource="#session.dsn#">
            select a.Enombre, b.direccion1, b.direccion2, b.ciudad, b.estado, b.CSATcodigo codPostal,
            a.Etelefono1,a.Efax,a.Eidentificacion,a.Enumlicencia
            from Empresa a
            INNER JOIN Direcciones b
            on a.id_direccion = b.id_direccion
            where a.Ecodigo = #session.Ecodigosdc#
        </cfquery>
      </cfif>

      <!--- DOMICILIO FISCAL CLIENTE --->
      <cfquery name="rsDomFiscCliente" datasource="#session.DSN#">
          SELECT  Calle, NumExt, NumInt, Colonia, Localidad, Referencia, MunicipioDelegacion as Delegacion, estado, p.Pnombre as Pais, codPostal
          FROM    DireccionesSIF d
                  INNER JOIN Pais p
                  ON d.Ppais = p.Ppais
                  INNER JOIN SNegocios s
                  ON d.id_direccion = s.id_direccion
          WHERE d.id_direccion = #rsDatosfac.id_direccion#
      </cfquery>
    <cfif reciboPagoCxC EQ 0>
      <cfquery name="qr" datasource="#session.DSN#">
          SELECT codigoQR from
              FAPreFacturaE f inner join FA_CFDI_Emitido fe
              on fe.Serie=f.seriefacele and fe.Folio=f.foliofacele
          WHERE f.oidocumento = #OImpresionID# and fe.Ecodigo=#session.Ecodigo#
      </cfquery>
    </cfif>
      <!--- <cf_dump var=#qr.codigoQR#> --->
      <cfquery name="logo" datasource="#session.DSN#">
          Select  Elogo
          From  Empresa
          where Ereferencia = #Session.Ecodigo#
      </cfquery>

      <cfset file_path = "#ExpandPath( GetContextRoot() )#">
      <cfif REFind('(cfmx)$',file_path) gt 0>
        <cfset file_path = "#Replace(file_path,'cfmx','')#">
      <cfelse>
        <cfset file_path = "#file_path#\">
      </cfif>
      <cffile action="write" file="#ruta#/lastLogo.jpg" output="#logo.Elogo#" addnewline="No" >

    <!--- TIpo de Comprobante--->
    <cfquery name="q_Comprobante" datasource="#session.DSN#">
          Select  case ClaveSAT
              when 'I' then 'Ingreso'
              when 'E' then 'Egreso'
              when 'T' then 'Traslado'
              when 'P' then 'Pago'
              else 'UNKNOWN' end as TipoComprobante
          From  CCTransacciones
          where ecodigo = #Session.Ecodigo# and CCTcodigo = '#rsDatosfac.CCTcodigo#'
      </cfquery>
      <!---<cf_dump var="#rsDatosfac#">--->
      <!--- Proceso  Temporal para cambiar la Razón Social de acuerdo a la seleccion  de la Empresa para CCOM--->
        <cfset lVarNombreEmisor = rsDatosEmpresa.Enombre>
        <!---<cfif session.Ecodigo EQ 3>
          <cfif form.EmpFact EQ 1>
            <cfset lVarNombreEmisor = "Clear Channel Outdoor Mexico S.A. de C.V.">
          <cfelseif form.empfact EQ 2>
            <cfset lVarNombreEmisor = "OUTDOOR MEXICO SERVICIOS PUBLICITARIOS S. DE R.L. DE C.V.">
          <cfelse>
             <cfset lVarNombreEmisor = rsDatosEmpresa.Enombre>
          </cfif>
        </cfif>--->

      <cfif isdefined('rsDatosfac.xmltimbrado')>
        <cfset xmltimbrado = '#rsDatosfac.xmltimbrado#'>
        <cfset xmltimbrado = XmlParse(xmltimbrado)>
        <cfinclude template="impresionReciboPago.cfm">
      <cfelse>

      <!--- Parametro para obtener nombre la plantilla a usar --->
      <cfquery name="rsPlanFac" datasource="#session.DSN#">
          select isnull(Pvalor,'FEPlantilla_1') as Pvalor
          from Parametros
          where Ecodigo = #session.Ecodigo#
            and Pcodigo = 17000
      </cfquery>
      <!---JARR 20/03/2019 Invocamos el generador de la plantilla de la factura --->
      <!--- Si no se ha parametrizado se toma la plantilla default --->
      <cfif isdefined("rsPlanFac") and rsPlanFac.recordcount GT 0 and rsPlanFac.Pvalor NEQ ''>
          <cfset  LobjDocXML = CreateObject("component", "sif.fa.Plantillas.#rsPlanFac.Pvalor#")>
          <cfset  LobjDocXML.init(DSN=Session.DSN, Ecodigo=Session.Ecodigo, Ecodigosdc=Session.Ecodigosdc)>
          <cfset  LobjDocXML.generarDocumento(Session.DSN,Session.Ecodigo,Session.Ecodigosdc,OImpresionID)>
      <cfelse>
          <cfset  LobjDocXML = CreateObject("component", "sif.fa.Plantillas.FEPlantilla_1")>
          <cfset  LobjDocXML.init(DSN=Session.DSN, Ecodigo=Session.Ecodigo, Ecodigosdc=Session.Ecodigosdc)>
          <cfset  LobjDocXML.generarDocumento(Session.DSN,Session.Ecodigo,Session.Ecodigosdc,OImpresionID)>
      </cfif><!--- Fin if rsPlanFac --->


    </cfif>


       <cfset archivo = "#ruta#/#rsDatosfac.fac#.xml">

      <cfif rsDatosfac.snemail neq "">
        <cftry>
          <!--- INICIO CAMBIO: OPARRALES 2018-09-10 Modificacion para enviar correo con archivos y quede registrada la accion en BD --->

          <!--- Obtiene el Correo configurado en PSO de la cuenta origen en Servicios --->
            <cfquery name="rsCorreoApp" datasource="#session.dsn#">
              select valor
              from PGlobal
              where
              parametro = <cfqueryparam cfsqltype="cf_sql_varchar" value="correo.cuenta">
            </cfquery>
            <!---Fin  Obtiene el Correo configurado en PSO de la cuenta origen en Servicios --->

          <cfquery name="insertSmtpQueue" datasource="#session.dsn#">
            insert INTO SMTPQueue (SMTPremitente, SMTPdestinatario, SMTPasunto, SMTPtexto, SMTPhtml)
            values (<cfqueryparam cfsqltype="cf_sql_varchar" value='#rsCorreoApp.valor#'>,
              <cfqueryparam cfsqltype="cf_sql_varchar" value='#rsDatosfac.snemail#'>,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="Factura Electronica #rsDatosfac.fac#">,
              <cfqueryparam cfsqltype="cf_sql_varchar" value="Se envio la Factura Electronica Num. Factura-#rsDatosfac.fac#">, 1)
            <cf_dbidentity1 datasource="#session.dsn#">
          </cfquery>
          <cf_dbidentity2 datasource="#session.dsn#" name="insertSmtpQueue" returnvariable="msg_id">

          <cfset SMTPmime1 = "application/pdf">
          <cfquery datasource="#session.dsn#" name="insertSMTPAttachment">
            insert into SMTPAttachment(
                    SMTPid
                    , SMTPmime
                    , SMTPlocalURL
                    , SMTPnombre
                ) values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#msg_id#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#SMTPmime1#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#ruta#/#TRIM(rsDatosfac.fac)#.pdf">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#TRIM(rsDatosfac.fac)#.pdf">
                )
          </cfquery>

          <cfset SMTPmime2 = "application/xml">
          <cfquery datasource="#session.dsn#" name="insertSMTPAttachment2">
            insert into SMTPAttachment(
                    SMTPid
                    , SMTPmime
                    , SMTPlocalURL
                    , SMTPnombre
                ) values (
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#msg_id#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#SMTPmime2#">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#ruta#/#rsDatosfac.fac#T.xml">
                    , <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosfac.fac#T.xml">
                )
          </cfquery>

          <!--- FIN CAMBIO: OPARRALES 2018-09-10 Modificacion para enviar correo con archivos y quede registrada la accion en BD --->
        <cfcatch>
          <cfoutput>
            <cfthrow detail="Error en validaci&oacuten de correo: " message="#cfcatch.detail#, #cfcatch.message#">
          </cfoutput>
        </cfcatch>
        </cftry>
      </cfif>

    <!---     fin del codigo de enviar mails --->
     <cfif ReciboPagoCxC Eq 0>
      <cfquery name="rsupdfac" datasource="#session.DSN#">
            update FAPreFacturaE
            set enviamail =1
            FROM FAEOrdenImpresion a, FAPreFacturaE f
              where a.OIdocumento = f.DdocumentoREF
            and   a.OImpresionID =  #OImpresionID#
         </cfquery>
    </cfif>
    </body>
    </html>

    <cffunction name="getMetodoPago" returntype="string">
      <cfargument name="codigo" required="true" type="string">

      <cfquery name="rsMetPago" datasource="sifcontrol">
        select  CSATcodigo as Codigo,CSATdescripcion as Descripcion
        from CSATMetPago
        where CSATcodigo = '#arguments.codigo#'
      </cfquery>

      <cfreturn rsMetPago.Descripcion>
    </cffunction>

    <cffunction name="getUsoCFDI" returntype="string">
      <cfargument name="codigo" required="true" type="string">

      <cfquery name="rsUsoCFDI" datasource="sifcontrol">
        select  CSATcodigo as c_UsoCFDI, CSATdescripcion as Descripcion from CSATUsoCFDI
        where CSATcodigo = '#arguments.codigo#'
      </cfquery>

      <cfreturn rsUsoCFDI.Descripcion>
    </cffunction>