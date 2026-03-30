


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
  <cfset  LobjDocXML.init(Session.DSN, Session.Ecodigo, Session.Ecodigosdc)>
  <cfset  LobjDocXML.generarDocumento(Session.DSN,Session.Ecodigo,Session.Ecodigosdc,OImpresionID)>
<cfelse>
  <cfset  LobjDocXML = CreateObject("component", "sif.fa.Plantillas.FEPlantilla_1")>
  <cfset  LobjDocXML.init(Session.DSN, Session.Ecodigo, Session.Ecodigosdc)>
  <cfset  LobjDocXML.generarDocumento(Session.DSN,Session.Ecodigo,Session.Ecodigosdc,OImpresionID)>
</cfif><!--- Fin if rsPlanFac --->

<cfquery name="rsDatosfac" datasource="#session.DSN#">
  SELECT distinct SNnombre, SNid, c.id_direccion,
      case substring(SNidentificacion,1,9) 
      when 'EXT010101' then 'XEXX010101000'
          else SNidentificacion
          end as SNidentificacion, d.direccion1 as SNdireccion, d.direccion2 as SNdireccion2,
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
      a.OImpresionID as NUMERODOC,SNemail,
              ltrim(rtrim(seriefacele)) as serie, ltrim(rtrim(foliofacele)) as fac1,  CCTcodigo,
      case CCTcodigo
      when  'FA' then
                  'FE_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele))  
      when  'FC' then
      'FE_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele))  
      when  'ND' then
      'ND_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele)) 
      when  'NC' then
      'NC_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele)) 
      else left(seriefacele,2)+'_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele)) 
      end as fac,
      ltrim(rtrim(numcerfacele)) AS numcerfacele,
      anoaprofacele,NUMaprofacele,
      ltrim(rtrim(cadorifacele)) as cadena,ltrim(rtrim(fe.SelloDigital)) as sello,
      TP.nombre_TipoPago,TP.TipoPagoSAT,RF.nombre_RegFiscal,m.Mnombre,OItipoCambio, Cta_tipoPago,OIDetalle,Udescripcion,
      fe.timbre, fe.selloSAT, fe.certificadoSAT, fe.cadenaSAT, fe.fechaTimbrado
      ,coalesce(OIieps,0) OIieps ,b.codIEPS, coalesce(b.OIMontoIEPSLinea,0) as OIMontoIEPSLinea,
  c.usaINE, c.SNIdContabilidadINE, c.SNTipoPoliticoINE, a.OITipoProcesoINE, a.OIComiteAmbito, a.OIEntidad, a.OIIdContabilidadINE 
  , con.ClaveSAT, u.ClaveSAT as UniSAT, a.c_metPago,
   /* f.DatosContacto,
    f.NumDatoBancarios,
    f.NumOrdenServicio,
    f.NumOrdenCompra, */
    coalesce(''+dp.Pnombre+' '+dp.Papellido1+' '+dp.Papellido2,'') as NombreUsu 
  FROM FAEOrdenImpresion a   
      inner join FADOrdenImpresion b
      on a.OImpresionID = b.OImpresionID
      and a.Ecodigo = b.Ecodigo
      INNER JOIN SNegocios c
      on a.SNcodigo = c.SNcodigo
      and a.Ecodigo = c.Ecodigo
      LEFT JOIN  DireccionesSIF d
      on a.id_direccionFact = d.id_direccion
      LEFT JOIN  Monedas m
      on a.Mcodigo = m.Mcodigo
        INNER JOIN FAPreFacturaE f
        on a.OImpresionID = f.oidocumento
              and a.Ecodigo = f.Ecodigo
        INNER JOIN FAPFTransacciones pft
              on f.Ecodigo = pft.Ecodigo
              and f.PFTcodigo = pft.PFTcodigo
        INNER JOIN FAPreFacturaD pfd on f.Ecodigo=pfd.Ecodigo 
              and f.IDpreFactura=pfd.IDpreFactura and pfd.Linea = b.OIDetalle
        INNER JOIN Conceptos con on pfd.Ecodigo =con.Ecodigo 
              and con.Cid=pfd.Cid
        INNER JOIN Unidades u on u.Ecodigo=con.Ecodigo 
              and con.Ucodigo= u.Ucodigo 
        LEFT JOIN FATipoPago TP 
              on TP.Ecodigo = a.Ecodigo and TP.codigo_TipoPago = a.codigo_TipoPago
        LEFT JOIN FARegFiscal RF 
              on RF.Ecodigo = a.Ecodigo and RF.codigo_RegFiscal = a.codigo_RegFiscal
         inner join FA_CFDI_Emitido fe
              on a.Ecodigo = fe.Ecodigo and a.OImpresionID =fe.OImpresionID
          left outer join Usuario usu
          on  usu.Usucodigo = f.BMUsucodigo
          AND usu.CEcodigo = f.Ecodigo
          left outer join DatosPersonales dp
          on dp.datos_personales = usu.datos_personales
  WHERE a.OImpresionID =  #OImpresionID# and a.Ecodigo=#session.Ecodigo#
              and fe.stsTimbre=1
              order by OIDetalle
</cfquery>

<cf_throw message="Archivo generado c:\enviar\#Session.FileCEmpresa#\#Session.Ecodigo#\#rsDatosfac.fac#.pdf ">
