<!--- 
	1. trae los valores de cierre para la (Caja) FAM01COD indicada
<cfinvoke 
		component="sif.pv.Componentes.pv_FA_Trae_Valores_Cierre"
		method="Cierre" returnvariable="rs">
		<cfinvokeargument name="FAM01COD" value="#FAM01COD#"/> 
		
</cfinvoke>
--->

<cfcomponent output="no">
	<cffunction name="Cierre" access="public" output="false" returntype="query">
		<cfargument name="FAM01COD"  	type="string"  	required="no">
		<cfargument name="FechaCierre" 	type="date" 	required="yes">
		<cfargument name="conexion" type="string"  required="no" default="#Session.DSN#">

		<!--- Declaracion de variables  --->
		<cfset BDEfectivo1 		= 0 >
		<cfset BDCheques   		= 0 >
		<cfset BDVouchers  		= 0 >
		<cfset BDCartaPromesa 	= 0 >
		<cfset BDAdelantosApli  = 0 >
		<cfset BDDepositos  	= 0 >
		<cfset BDFContado  		= 0 > 
		<cfset BDAdelantos  	= 0 > 
		<cfset BDRecibosCxC  	= 0 > 
		<cfset BDNCredito  	    = 0 > 
		<cfset BDFCredito  	    = 0 > 
		<cfset BDNCCredito      = 0 > 
		<cfset BDDocOferta      = 0 > 
		<cfset BDNCGeneradas    = 0 > 
		<cfset Efectivo1 		= 0 >
		<cfset Cheques 		    = 0 >
		<cfset Vouchers 		= 0 >
		<cfset CartaPromesa 	= 0 >
		<cfset Depositos 		= 0 >
		<cfset FContado 	    = 0 >
		<cfset Adelantos 	    = 0 >
		<cfset RecibosCxC 	    = 0 >
		<cfset NCredito 	    = 0 >
		<cfset AdelantosApli 	= 0 >
		<cfset Faltante 		= 0 >
		<cfset FCredito 		= 0 >
		<cfset NCCredito 		= 0 >
		<cfset DocOferta 		= 0 >
		<cfset DocNCGeneradas 	= 0 >
		
		<!---<cfset FECHA1           = CreateDate(DatePart('yyyy',Now()),DatePart('m',Now()), DatePart('d',Now()))>
		<cfif Arguments.Fecha LT Fecha1>
			<cfset Fecha1 = Arguments.Fecha>
		</cfif>
		<cfset FECHA2   		= DateAdd('d', 1,  FECHA1)> 
		<cfset FECHA2   		= DateAdd('s', -1, FECHA2)>---> 
		
		<cfset FECHA1           = CreateDate(DatePart('yyyy',Now()),DatePart('m',Now()), DatePart('d',Now()))>
			<cfset FECHA2   		= DateAdd('d', 1,  FECHA1)> 
			<cfset FECHA2   		= DateAdd('s', -1, FECHA2)> 

			<!--- 1. Efectivo --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(convert(money, c.FAX12TOTMF * b.FAX01FCAM)),0) as MontoLOC
				FROM FAX001 b
					inner join FAX012 c
					on c.FAX01NTR   = b.FAX01NTR	
				   and c.FAM01COD   = b.FAM01COD
				   and c.Ecodigo    = b.Ecodigo
				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T' <!--- ---- Estatus de Terminado ---> 
				  and c.FAX12TIP   = 'EF'  <!--- ----** Efectivo --->
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfif RsmontoLocal.recordcount GT 0>
				<cfset BDEfectivo1 = BDEfectivo1 +  RsmontoLocal.MontoLOC>
			</cfif>

			<!--- 1.1 Reintegros (vuelto) en efectivo dado por la caja  --->
			<cfquery name="RsmontoLocalCam" datasource="#Arguments.conexion#">
				select   coalesce(sum(convert(money, c.FAX10CAM * b.FAX01FCAM)),0) as MontoLOC
				FROM FAX001 b
					inner join FAX010 c
					on c.FAX01NTR   = b.FAX01NTR	
				   and c.FAM01COD   = b.FAM01COD
				   and c.Ecodigo    = b.Ecodigo
				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T' <!--- ---- Estatus de Terminado ---> 
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			
			<cfif RsmontoLocalCam.recordcount GT 0>
				<cfset BDEfectivo1 = BDEfectivo1 -  RsmontoLocalCam.MontoLOC>
			</cfif>
			
			<!--- 2. Cheques --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(convert(money, FAX12TOTMF * b.FAX01FCAM)),0) as MontoLOC
				FROM FAX001 b
					inner join FAX012 c
					on c.FAX01NTR   = b.FAX01NTR	
				   and c.FAM01COD   = b.FAM01COD
				   and c.Ecodigo    = b.Ecodigo
				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T' <!--- ---- Estatus de Terminado  --->
				  and c.FAX12TIP   = 'CK'  <!--- ----** Cheques --->
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfset BDCheques = BDCheques +  RsmontoLocal.MontoLOC>

			<!--- 3. Vouchers --->
			 <cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(convert(money, FAX12TOTMF * b.FAX01FCAM)),0) as MontoLOC
				FROM FAX001 b
					inner join FAX012 c
					 on c.FAX01NTR   = b.FAX01NTR	
					and c.FAM01COD   = b.FAM01COD
					and c.Ecodigo    = b.Ecodigo

					inner join FATarjetas d
					on d.FATid      = c.FATid

				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T' <!--- ---- Estatus de Terminado ---> 
				  and c.FAX12TIP   = 'TC'  <!--- ----** Tarjeta de Credito --->
				  and d.FATtiptarjeta <> 'O' 
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfset BDVouchers = BDVouchers +  RsmontoLocal.MontoLOC>
		
			<!--- 3.1 Documentos de Oferta  (Bonos) --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(convert(money, FAX12TOTMF * b.FAX01FCAM)),0) as MontoLOC
				FROM FAX001 b
					inner join FAX012 c
						 on c.FAX01NTR   = b.FAX01NTR	
						and c.FAM01COD   = b.FAM01COD
						and c.Ecodigo    = b.Ecodigo
						and c.FAX12TIP   = 'BN'         <!--- Bonos o Cupones --->
					<!---
					inner join FATarjetas d
						 on d.FATid      = c.FATid
						and d.FATtiptarjeta = 'O' 
					--->
				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T'          <!--- ---- Estatus de Terminado ---> 
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>	
			<cfset BDDocOferta = BDDocOferta +  RsmontoLocal.MontoLOC>		 

			<!--- 4. Cartas Promesa --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(round(convert(money, FAX12TOTMF * b.FAX01FCAM ),2)),0) as MontoLOC
				FROM FAX001 b
					inner join FAX012 c
					on  c.FAX01NTR   = b.FAX01NTR	
					and c.FAM01COD   = b.FAM01COD
					and c.Ecodigo    = b.Ecodigo

				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T' <!--- ---- Estatus de Terminado  --->
				  and c.FAX12TIP   = 'CP'  <!--- ----** Cartas Promesa --->
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfset BDCartaPromesa = BDCartaPromesa +  RsmontoLocal.MontoLOC>

			<!--- 5. Adelantos Aplicados --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(convert(money, FAX12TOTMF * b.FAX01FCAM)),0) as MontoLOC
				FROM FAX001 b
					inner join FAX012 c
					 on c.FAX01NTR   = b.FAX01NTR	
					and c.FAM01COD   = b.FAM01COD
					and c.Ecodigo    = b.Ecodigo
				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T' <!--- ---- Estatus de Terminado ---> 
				  and c.FAX12TIP   = 'AD'  <!--- ----** Adelantos Aplicados --->
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfset BDAdelantosApli = BDAdelantosApli -  RsmontoLocal.MontoLOC>
			
			<!--- 6. Depósitos Bancarios --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(convert(money, FAX12TOTMF * b.FAX01FCAM)),0) as MontoLOC
				FROM FAX001 b
					inner join FAX012 c
					 on c.FAX01NTR   = b.FAX01NTR	
					and c.FAM01COD   = b.FAM01COD
					and c.Ecodigo    = b.Ecodigo
				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T' <!--- ---- Estatus de Terminado  --->
				  and c.FAX12TIP   = 'DB'  <!--- ----** Depositos Bancarios --->
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfset BDDepositos = BDDepositos +  RsmontoLocal.MontoLOC>			
			
			<!--- 7. Facturas de Contado --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(coalesce(b.FAX01TOT,0) * b.FAX01FCAM),0) as MontoLOC
				FROM FAX001 b
				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T' <!--- ---- Estatus de Terminado  --->
				  and b.FAX01TIP   = '1' <!--- ---- Factura --->  
				  and b.FAX01TPG   = 0   <!--- ---- Facturas de Contado --->
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfset BDFContado = BDFContado +  RsmontoLocal.MontoLOC>			

			<!--- 8. Facturas de Crédito  --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(coalesce(b.FAX01TOT,0) * b.FAX01FCAM),0) as MontoLOC
				FROM FAX001 b
				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T' <!--- ---- Estatus de Terminado  --->
				  and b.FAX01TIP   = '1' <!--- ---- Factura --->  
				  and b.FAX01TPG   = 1   <!--- ---- Facturas de Credito --->
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfset BDFCredito = BDFCredito +  RsmontoLocal.MontoLOC>

			<!--- 9. Adelantos (Documentos) --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX01TOT * b.FAX01FCAM),0) as MontoLOC
				FROM FAX001 b
				where b.FAM01COD     = '#Arguments.FAM01COD#'
				  and b.Ecodigo      = #Session.Ecodigo#
			  	  and b.FAX01STA     = 'T'
				  and b.FAX01TIP     in ('9', '3')
				  and b.FAX01FEC     <= #FECHA2#
			</cfquery>
			<cfset BDAdelantos = BDAdelantos +  RsmontoLocal.MontoLOC>	
			
			<!--- 10. Recibos de CxC  --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX01TOT * b.FAX01FCAM),0) as MontoLOC
				FROM FAX001 b
				where b.FAM01COD   = '#Arguments.FAM01COD#'
			  	  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01STA   = 'T'
				  and b.FAX01TIP   = '2'
				  and b.FAX01FEC   <= #FECHA2#
			</cfquery>
			<cfset BDRecibosCxC = BDRecibosCxC +  RsmontoLocal.MontoLOC>				
			
			<!--- 11. Recibos de Documentos por Cobrar  --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(c.FAX07DMON * b.FAX01FCAM),0) as MontoLOC
				FROM FAX001 b
					inner join FAX007D c
					 on c.FAX01NTR      = b.FAX01NTR
					and c.FAM01COD      = b.FAM01COD
					and c.Ecodigo       =  b.Ecodigo
				where b.FAM01COD      = '#Arguments.FAM01COD#'
				  and b.FAX01STA      = 'T'
				  and b.FAX01TIP      = 'D'
			  	  and b.Ecodigo       = #Session.Ecodigo#
				  and b.FAX01FEC      <= #FECHA2#
			</cfquery>
			<cfset BDRecibosCxC = BDRecibosCxC +  RsmontoLocal.MontoLOC>	
			
			<!--- 12. Notas de Crédito  en Efectivo --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(convert(money, FAX01TOT * b.FAX01FCAM)),0) as MontoLOC
				FROM FAX001 b
				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.FAX01TIP   in ('4', '0')
				  and b.FAX01STA   = 'T'
				  and b.FAX01TPG   = 0
			  	  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfset BDNCredito = BDNCredito +  RsmontoLocal.MontoLOC>

			<!--- 13. Notas de Crédito al Crédito  --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select   coalesce(sum(convert(money, FAX01TOT * b.FAX01FCAM)),0) as MontoLOC
				FROM FAX001 b
				where b.FAM01COD   = '#Arguments.FAM01COD#'
				  and b.FAX01TIP   = '4'
				  and b.FAX01STA   = 'T'
				  and b.FAX01TPG   = 1
			  	  and b.Ecodigo    = #Session.Ecodigo#
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfset BDNCCredito = BDNCCredito +  RsmontoLocal.MontoLOC>

			<!--- 
				Mauricio Esquivel:  2 Mayo 2009:
				Se adiciona una condicion al "join" por cliente,
				para evitar que si muestren dos anticipos si se tralada a otro cliente
			--->
			<!--- 14. Notas de credito generadas como Anticipos --->
			<cfquery name="RsmontoLocal" datasource="#Arguments.conexion#">
				select coalesce(sum(d.FAX14MON * b.FAX01FCAM),0) as MontoLOC
				FROM FAX001 b
					inner join FAX014 d
					 on d.FAX01NTR 	 = b.FAX01NTR
					and d.FAM01COD   = b.FAM01COD
					and d.Ecodigo    = b.Ecodigo
					and d.CDCcodigo	 = b.CDCcodigo
				where b.FAM01COD     = '#Arguments.FAM01COD#'
			  	  and b.Ecodigo      = #Session.Ecodigo#
				  and b.FAX01STA     = 'T'
				  and b.FAX01TIP     in ('1', '4')
				  and b.FAX01TPG     = 0
				  and d.FAX14TDC     <> 'CR'
				  and b.FAX01FEC	<= #FECHA2#
			</cfquery>
			<cfset BDNCGeneradas = BDNCGeneradas +  RsmontoLocal.MontoLOC>
			
			<!---****** Valores de la FAX015     ******--->
			
			<!--- 1. Efectivo  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 2
				and b.FAM30LIN = 1
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'
			</cfquery>
			<cfset Efectivo1 = Efectivo1 +  Rsmonto.Monto>
			
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 2
				and b.FAM30LIN = 6
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset Efectivo1 = Efectivo1 +  Rsmonto.Monto>			

			<!--- 2. Cheques  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 2
				and b.FAM30LIN = 2
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset Cheques = Cheques +  Rsmonto.Monto>
			
			<!--- 3. Vouchers  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 2
				and b.FAM30LIN = 3
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset Vouchers = Vouchers +  Rsmonto.Monto>			

			<!--- 4. Cartas Promesa  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 2
				and b.FAM30LIN = 4
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset CartaPromesa = CartaPromesa +  Rsmonto.Monto>	

			<!---  5. Depósitos Bancarios  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 2
				and b.FAM30LIN = 5
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset Depositos = Depositos +  Rsmonto.Monto>	

			<!---  6. Facturas de Contado  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 1
				and b.FAM30LIN = 1
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset FContado = FContado +  Rsmonto.Monto>	
			
			<!---  7. Adelantos (Documentos)  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 1
				and b.FAM30LIN = 2
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset Adelantos = Adelantos +  Rsmonto.Monto>				

			<!---  8. Recidos de CxC  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 1
				and b.FAM30LIN = 3
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset RecibosCxC = RecibosCxC +  Rsmonto.Monto>	

			<!---  9. Notas de Crédito  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 1
				and b.FAM30LIN = 4
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset NCredito = NCredito +  Rsmonto.Monto>	
			
			<!---  10. Adelantos Aplicados  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 1
				and b.FAM30LIN = 5
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset AdelantosApli = AdelantosApli +  Rsmonto.Monto>	
			
			<!--- 
			<!---  11. Faltantes y Sobrantes Manuales  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 2
				and b.FAM30LIN = 99
				and b.FAX15SCO is null
				and b.Mcodigo is null
				and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset Faltante = Faltante +  Rsmonto.Monto>	
			--->

			<!---  12. Facturas de Crédito  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 3
				and b.FAM30LIN = 1
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset FCredito = FCredito +  Rsmonto.Monto>	
			
			<!---  13. Notas de Credito al Credito  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 3
				and b.FAM30LIN = 2
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset NCCredito = NCCredito +  Rsmonto.Monto>			
			
			<!---  14. Documentos de Oferta  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 2
				and b.FAM30LIN = 7
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset DocOferta = DocOferta +  Rsmonto.Monto>
			
			<!---  10. NC Generadas por Caja.  --->
			<cfquery name="Rsmonto" datasource="#Arguments.conexion#">
				select   coalesce(sum(b.FAX15MON),0) as Monto
				FROM FAX015 b
				where b.FAM30CTO = 1
				and b.FAM30LIN = 6
				and b.FAX15SCO is null
				and b.Mcodigo is null
			  	and b.Ecodigo    = #Session.Ecodigo#
				and b.FAM01COD = '#Arguments.FAM01COD#'

			</cfquery>
			<cfset DocNCGeneradas = DocNCGeneradas +  Rsmonto.Monto>			

			<cfset Faltante = 
				(Efectivo1  +   Cheques  +   Vouchers  +   CartaPromesa +    Depositos +   DocOferta) - 
				(BDEfectivo1 +  BDCheques +  BDVouchers +  BDCartaPromesa +  BDDepositos + BDDocOferta)>
									
			<!--- Retorna todos los datos  --->
			<cfquery name="RsDatos" datasource="#Arguments.conexion#">
				select 
				#Efectivo1# as Efectivo1,
				#BDEfectivo1# as BDEfectivo1,
				#Efectivo1# - #BDEfectivo1# as Efectivo1div, 
				#Cheques# as Cheques,
				#BDCheques# as BDCheques, 
				#Cheques# - #BDCheques# as Chequesdiv,
				#Vouchers# as Vouchers,
				#BDVouchers# as BDVouchers,
				#Vouchers# - #BDVouchers# as Vouchersdiv,
				#CartaPromesa# as CartaPromesa,
				#BDCartaPromesa# as BDCartaPromesa,
				#CartaPromesa# - #BDCartaPromesa# as CartaPromesadiv,
				#Depositos# as Depositos,
				#BDDepositos# as BDDepositos,
				#Depositos# - #BDDepositos# as Depositosdiv,
				#DocOferta# as DocOferta,
				#BDDocOferta# as BDDocOferta,
				#DocOferta# - #BDDocOferta# as DocOfertadiv,
				round(#Efectivo1#,2) + round(#Cheques#,2) + round(#Vouchers#,2) + round(#CartaPromesa#,2) + round(#Depositos#,2) + round(#DocOferta#,2)  as TotalValores,
				round(#BDEfectivo1#,2) + round(#BDCheques#,2) + round(#BDVouchers#,2) + round(#BDCartaPromesa#,2) + round(#BDDepositos#,2) + round(#BDDocOferta#,2)  as BDTotalValores,
				round((#Efectivo1# - #BDEfectivo1#),2) +
				round((#Cheques# - #BDCheques#),2) +
				round((#Vouchers# - #BDVouchers#),2) +
				round((#CartaPromesa# - #BDCartaPromesa#),2) +
				round((#Depositos# - #BDDepositos#),2) +
				round((#DocOferta# - #BDDocOferta#),2) as TotalValoresdiv,
				#FContado# as FContado,
				#BDFContado# as BDFContado,
				#FContado# - #BDFContado# as FContadodiv,
				#DocNCGeneradas# as DocNCGeneradas,
				#BDNCGeneradas# as BDNCGeneradas,
				#DocNCGeneradas# - #BDNCGeneradas# as DocNCGeneradasdiv,
				#Adelantos# as Adelantos,
				#BDAdelantos# as BDAdelantos,
				#Adelantos# - #BDAdelantos# as Adelantosdiv,
				#RecibosCxC# as RecibosCxC,
				#BDRecibosCxC# as BDRecibosCxC,
				#RecibosCxC# - #BDRecibosCxC# as RecibosCxCdiv,
				#NCCredito# as NCCredito,
				#BDNCCredito# as BDNCCredito,
				#NCCredito# - #BDNCCredito#  as NCCreditodiv,
				#AdelantosApli# as AdelantosApli,
				#BDAdelantosApli# as BDAdelantosApli,
				#AdelantosApli# - #BDAdelantosApli# as AdelantosAplidiv,
				round(#FContado#,2) + round(#DocNCGeneradas#,2) + round(#Adelantos#,2) + round(#RecibosCxC#,2) + round(#NCredito#,2) + round(#AdelantosApli#,2) as TotalDocumentos,
				round(#BDFContado#,2) + round(#BDNCGeneradas#,2) + round(#BDAdelantos#,2) + round(#BDRecibosCxC#,2) + round(#BDNCredito#,2) + round(#BDAdelantosApli#,2) as BDTotalDocumentos,
				round((#FContado# - #BDFContado#),2) +
				round((#DocNCGeneradas# - #BDNCGeneradas#),2) +
				round((#Adelantos# - #BDAdelantos#),2) +
				round((#RecibosCxC# - #BDRecibosCxC#),2) +
				round((#NCredito# - #BDNCredito#),2) +
				round((#AdelantosApli# - #BDAdelantosApli#),2)  as TotalDocumentosdiv,
				round(#Faltante#,2) as Faltante,
				#FCredito# as FCredito,
				#BDFCredito# as BDFCredito,
				#FCredito# - #BDFCredito# as BDFCreditodiv,
				#NCredito# as NCredito,
				#BDNCredito# as BDNCredito, 
				#NCredito# - #BDNCredito# as NCreditodiv
			</cfquery>
		<cfreturn RsDatos>	
	</cffunction>
</cfcomponent>
