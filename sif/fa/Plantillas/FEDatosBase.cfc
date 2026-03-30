<!--- Componente base para layout de Factura Electronica--->

<cfcomponent initmethod = init>
    <cfset This.DSN          = ''>
		<cfset This.Ecodigo      = ''>
		<cfset This.Ecodigosdc   = ''>
    
    <cffunction name="init" access="public" output="no" returntype="FEDatosBase">  
			<cfargument name="DSN" 	   type="string" default="#Session.DSN#" >
			<cfargument name="Ecodigo" type="string" default="#Session.Ecodigo#" >
			<cfargument name="Ecodigosdc" type="integer" default="#Session.Ecodigosdc#" >
			<cfset This.DSN 	= arguments.DSN>
			<cfset This.Ecodigo = arguments.Ecodigo>
			<cfset This.Ecodigosdc = arguments.Ecodigosdc>
			<cfreturn this>
		</cffunction>

	<cffunction name = "getDatosFactura">
	    <cfargument  name="OImpresionID" type = "numeric">
	    <cfquery name="rsDatosfac" datasource="#This.DSN#">
			SELECT distinct c.SNnombre, c.SNid, c.id_direccion,
				case substring(c.SNidentificacion,1,9) 
				when 'EXT010101' then 'XEXX010101000'
					else c.SNidentificacion
				end as SNidentificacion, c.SNidentificacion2,
				d.direccion1 as SNdireccion, d.direccion2 as SNdireccion2,
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
							else left(seriefacele,2)+'_'+convert(varchar,a.Ecodigo)+'_'+ltrim(rtrim(seriefacele))+ltrim(rtrim(foliofacele)) 
						end as fac,
						ltrim(rtrim(numcerfacele)) AS numcerfacele,
				anoaprofacele,NUMaprofacele,
				ltrim(rtrim(cadorifacele)) as cadena,ltrim(rtrim(fe.SelloDigital)) as sello,
				TP.nombre_TipoPago,TP.TipoPagoSAT,RF.nombre_RegFiscal,m.Mnombre,OItipoCambio, Cta_tipoPago,OIDetalle,Udescripcion,
				fe.timbre, fe.selloSAT, fe.certificadoSAT, fe.cadenaSAT, fe.fechaTimbrado
				,coalesce(OIieps,0) OIieps ,b.codIEPS, coalesce(b.OIMontoIEPSLinea,0) as OIMontoIEPSLinea,
				c.usaINE, c.SNIdContabilidadINE, c.SNTipoPoliticoINE, a.OITipoProcesoINE, a.OIComiteAmbito, a.OIEntidad, a.OIIdContabilidadINE 
			, con.ClaveSAT, u.ClaveSAT as UniSAT, a.c_metPago, a.codigo_RegFiscal as regimenFiscal, pfd.IdImpuesto as objImpuesto,
			ref.CSATdescripcion as descRegFis,
			 f.DatosContacto,
			/*f.NumDatoBancarios,*/
			f.NumOrdenServicio,
			f.NumOrdenCompra, 
			coalesce(''+dp.Pnombre+' '+dp.Papellido1+' '+dp.Papellido2,'') as NombreUsu,
			coalesce(a.OIMRetencion, 0) as OIMRetencion
				FROM FAEOrdenImpresion a   
						inner join FADOrdenImpresion b
						on a.OImpresionID = b.OImpresionID
						and a.Ecodigo = b.Ecodigo
						INNER JOIN SNegocios ssn
	                      on a.SNcodigo = ssn.SNcodigo
	                      and a.Ecodigo = ssn.Ecodigo 
						INNER JOIN SNegocios c
						on c.SNid = CASE WHEN ssn.SNidPadre is null
	                                 THEN ssn.SNid
	                            	ELSE ssn.SNidPadre
	                            	END 
						and c.Ecodigo=a.Ecodigo
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
				INNER JOIN (
                  select Aid,null as Cid,Ucodigo,Ecodigo, ClaveSAT
                  from Articulos
                  where Ecodigo = #This.Ecodigo#
                  union
                  select null as Aid, Cid,Ucodigo,Ecodigo, ClaveSAT 
                  from Conceptos
                  where Ecodigo = #This.Ecodigo#
              ) con ON pfd.Ecodigo =con.Ecodigo AND (con.Cid=pfd.Cid or con.Aid = pfd.Aid)
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
				left join CSATRegFiscal ref
					on a.codigo_RegFiscal = ref.CSATcodigo

				WHERE a.OImpresionID =  #arguments.OImpresionID# and 
				    a.Ecodigo=#This.Ecodigo#
						and fe.stsTimbre=1
						order by OIDetalle
		</cfquery>
		<cfreturn rsDatosfac>
	</cffunction>

  <cffunction  name="getRFCEmpresa">
	    <cfquery name="rsRFCEmpresa" datasource="#This.DSN#">
				select EIdentificacion from Empresas
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#This.Ecodigo#">
			</cfquery>
			<cfreturn rsRFCEmpresa>
	</cffunction>

	<cffunction  name="getRegFiscalReceptor">
	<cfargument  name="OImpresionID" type = "numeric">
	    <cfquery name="rsRF" datasource="#This.DSN#">
				select RF.CSATdescripcion from FAEOrdenImpresion a
				INNER JOIN FAPreFacturaE f
						on f.oidocumento = a.OImpresionID
						INNER JOIN FAPreFacturaD pfd on f.Ecodigo=pfd.Ecodigo 
						and f.IDpreFactura=pfd.IDpreFactura
						inner join SNegocios SN on SN.SNcodigo = f.SNcodigo
				inner join CSATRegFiscal RF on RF.IdRegFiscal = SN.IdRegimenFiscal
				WHERE a.OImpresionID =  #arguments.OImpresionID#
			</cfquery>
			<cfreturn rsRF>
	</cffunction>

 	<cffunction  name="getDirFiscE">
	    <cfquery name="rsDirFiscE" datasource="#This.DSN#">
				SELECT  DirecFisc
				FROM    Empresas
				WHERE   Ecodigo = #This.Ecodigo#
			</cfquery>
		<cfreturn rsDirFiscE>
	</cffunction>

	<cffunction  name="getDirFiscCliente">
	    <cfargument  name="SNid" type = "numeric">
	    <cfquery name="rsDicFiscSN" datasource="#This.DSN#">
				SELECT  d.SNDireccionFiscal as DirecFisc
				FROM  SNegocios s 
					INNER JOIN SNDirecciones d 
					ON s.SNid = d.SNid
				WHERE   s.SNid = #arguments.SNid#
			</cfquery>
			<cfreturn rsDicFiscSN>
	</cffunction>

	<cffunction  name="getDatosEmpresa">
	    <cfargument  name="DirecFisc" type = "numeric">
		<cfif arguments.DirecFisc EQ 1>
			<cfquery name="rsDatosEmpresa" datasource="#This.DSN#">
				SELECT  e.Enombre, Calle, NumExt, NumInt, Colonia, Localidad, Referencia, Delegacion, es.Estado, Pais, es.CodPostal, ciudad
				FROM    Empresas es
				inner join Empresa e
				on es.Ecodigo = e.Ereferencia
				inner join Direcciones d
				on e.id_direccion = d.id_direccion
				WHERE   es.Ecodigo = #This.Ecodigo#
			</cfquery>
		<cfelse>
			<cfquery name="rsDatosEmpresa" datasource="#This.dsn#">
				select a.Enombre, b.direccion1, b.direccion2, b.ciudad, b.estado, b.CSATcodigo codPostal,
				a.Etelefono1,a.Efax,a.Eidentificacion,a.Enumlicencia
				from Empresa a
				INNER JOIN Direcciones b
				on a.id_direccion = b.id_direccion
				where a.Ecodigo = #This.Ecodigosdc#
			</cfquery>
		</cfif>
		<cfreturn rsDatosEmpresa>
	</cffunction>

	<cffunction  name="getDomFiscCliente">
	    <cfargument  name="id_direccion" type = "numeric">
	    <cfquery name="rsDomFiscCliente" datasource="#This.DSN#">
			SELECT  Calle, NumExt, NumInt, Colonia, Localidad, Referencia, MunicipioDelegacion as Delegacion, Estado, p.Pnombre as Pais, codPostal
			FROM    DireccionesSIF d
					INNER JOIN Pais p
					ON d.Ppais = p.Ppais
					INNER JOIN SNegocios s
					ON d.id_direccion = s.id_direccion
			WHERE d.id_direccion = #arguments.id_direccion#
		</cfquery>
		<cfreturn rsDomFiscCliente>
	</cffunction>

	<cffunction  name="getQRCode">
	    <cfargument  name="OImpresionID" type = "numeric">
	    <cfquery name="rsQR" datasource="#This.DSN#">
			SELECT codigoQR from 
				FAPreFacturaE f inner join FA_CFDI_Emitido fe
				on fe.Serie=f.seriefacele and fe.Folio=f.foliofacele
			    WHERE f.oidocumento = #arguments.OImpresionID# and fe.Ecodigo=#This.Ecodigo#
		</cfquery>
		<cfreturn rsQR>
	</cffunction>

	<cffunction  name="getLogoEmpresa">
	    <cfquery name="rsLogo" datasource="#This.DSN#">
			Select  Elogo , Ecodigo
			From  Empresa 
			where Ereferencia = #This.Ecodigo#
		</cfquery>
		<cfreturn rsLogo>
	</cffunction>

	<cffunction  name="getTipoComprobante">
	    <cfargument  name="CCTcodigo" type="string">
	    <cfquery name="rsComprobante" datasource="#This.DSN#">
			Select  case ClaveSAT
				when 'I' then 'Ingreso'
				when 'E' then 'Egreso'
				when 'T' then 'Traslado'
				when 'P' then 'Pago'
				else 'UNKNOWN' end as TipoComprobante,
				ClaveSAT
			From  CCTransacciones
			where ecodigo = #This.Ecodigo# and CCTcodigo = '#arguments.CCTcodigo#'
		</cfquery>
		<cfreturn rsComprobante>
	</cffunction>

	<cffunction  name="getDocumentosRelacionados">
	    <cfargument  name="timbre" type="string">
	    <cfquery name="rsDocsRelacionados" datasource="#This.dsn#">
            select 
                  FAR.TipoRelacion
                , TR.CSATdescripcion
                , FAR.TimbreDocRel 
              from FA_CFDI_Relacionado FAR
                inner join FA_CFDI_Emitido FAE
                  on FAE.OImpresionID = FAR.OImpresionID
                left join CSATTipoRel TR
                  on TR.CSATcodigo = FAR.TipoRelacion
            where FAE.timbre = '#arguments.timbre#'
        </cfquery>
		<cfreturn rsDocsRelacionados>
	</cffunction>

	<cffunction name="getMetodoPago" returntype="string">
		<cfargument name="codigo" required="true" type="string">
		<cfquery name="rsMetPago" datasource="sifcontrol">
			select  CSATcodigo as Codigo, CSATdescripcion as Descripcion 
			from CSATMetPago
			where CSATcodigo = '#arguments.codigo#'
		</cfquery>
		<cfreturn "#rsMetPago.Codigo# #rsMetPago.Descripcion#">
	</cffunction>

	<cffunction name="getUsoCFDI" returntype="string">
		<cfargument name="codigo" required="true" type="string">
		<cfquery name="rsUsoCFDI" datasource="sifcontrol">
			select  CSATcodigo as c_UsoCFDI, CSATdescripcion as Descripcion from CSATUsoCFDI
			where CSATcodigo = '#arguments.codigo#'
		</cfquery>
		<cfreturn "#rsUsoCFDI.c_UsoCFDI# #rsUsoCFDI.Descripcion#">
	</cffunction>




	<cffunction name="getDatosImpuestos" returntype="query">
            <cfargument name="OImpresionID" type="numeric">
            <cfquery name="rsDatosfac" datasource="#session.DSN#">
                SELECT  
                        ROUND((ROUND(OIDtotal,2) * i.TasaOCuota),2) as OIDtotalCalc,
                        i.TipoFactor, i.ClaveSAT as IClaveSAT, i.TasaOCuota,i.Iporcentaje,
							i.Idescripcion as Nombre,
                        Round(coalesce(b.OIMontoIEPSLinea,0),2) as OIMontoIEPSLinea, 
                        ieps.TipoFactor as TipoFactorIeps, ieps.ClaveSAT as ClaveSATIeps, ieps.TasaOCuota as TasaOCuotaIeps, ieps.Iporcentaje as IporcentajeIeps,
							ieps.Idescripcion as NombreIeps
               		FROM FADOrdenImpresion b    
                        INNER JOIN Impuestos i
                                on b.Icodigo = i.Icodigo
                                and b.Ecodigo = i.Ecodigo
                        left JOIN Impuestos ieps
                                on b.codIEPS = ieps.Icodigo
                                and b.Ecodigo = ieps.Ecodigo
					WHERE  b.OImpresionID =  #arguments.OImpresionID#
									and b.Ecodigo = #session.Ecodigo#
            </cfquery>


			<cfquery name="rsImpuestos" dbtype="query">
				select TipoFactor, TasaOCuota, iporcentaje, Nombre, IClaveSAT, sum(OIDtotalCalc) <!--- OIDtotalCalc ---> OIDtotal
					from rsDatosFac
					group by TipoFactor, TasaOCuota, iporcentaje, Nombre,IClaveSAT
                union
                select TipoFactorIeps, TasaOCuotaIeps, IporcentajeIeps, NombreIeps, ClaveSATIeps, sum(OIMontoIEPSLinea) <!--- OIDtotalCalc ---> OIDtotal
					from rsDatosFac 
                    where ClaveSATIeps != '' 
					group by TipoFactorIeps, TasaOCuotaIeps, IporcentajeIeps, NombreIeps, ClaveSATIeps
				order by IClaveSAT
			</cfquery>
			<cfreturn rsImpuestos>

        </cffunction>

		

</cfcomponent>