<cfcomponent>
	<cffunction name="Recibo_de_Productos_en_Transito" access="public" returntype="query" output="false">
		<!---- Definición de Parámetros --->
		<cfargument name='ERTid' 			type='numeric' 	required='true'>				 <!--- Código del Almacén Inicial ---->
		<cfargument name='Ecodigo'			type='numeric' 	required='true'>				 <!--- Código empresa ---->
		<cfargument name='Usuario' 		type='numeric' 	required='false'>				 <!--- Código del Almacén Final ---->
		<cfargument name='Localizacion' 	type='string' 	required='false' default="">   <!--- Código del Artículo Inicial ---->
		<cfargument name='login' 			type='string' 	required='false' default="">   <!--- Código del Artículo Final ---->
		<cfargument name='debug' 			type='string' 	required='false' default="N">
		
		
<!---Create Table #NIVELES(
    IDtemp	 		int null,					--- ID temporal de la transaccion
    valor 			varchar(20) null,			--- Valor en el Nivel
    PCEcatid 		numeric null,				--- Codigo del Catalogo
    PCDcatid 		numeric null,				--- Codigo del Detalle de Catalogo (al Identificar Tipo y Valor)
    PCNdep	 		int null,					--- Nivel del cual depende el catalogo a utilizar
    PCDCniv 		int not null,				--- Numero del Nivel Financiero
    CcuentaF 		numeric null,				--- Codigo de la Cuenta Generada
    CformatoF 		varchar(100) null,			--- Formato de la Cuenta a Generar
    PCDCnivC 		int null,					--- Numero del Nivel Contable
    CcuentaC 		numeric null,				--- Codigo de la Cuenta Generada
    CformatoC 		varchar(100) null,			--- Formato de la Cuenta a Generar
    PCDCnivP 		int null,					--- Numero del Nivel Presupuesto
    CcuentaP 		numeric null,				--- Codigo de la Cuenta Generada
    CformatoP 		varchar(100) null,			--- Formato de la Cuenta a Generar
    Cdescripcion 	varchar(80) null,			--- Descripcion de la Cuenta a Generar
    Ocodigo		 	int null					--- Codigo de Oficina
)		--->

<cf_dbfunction name="OP_concat"	returnvariable="_Cat">		

		<cfquery name="rsPeriodo" datasource="#session.DSN#">
			select <cf_dbfunction name="to_integer" args="Pvalor"> as Periodo
			from Parametros
			where Ecodigo =  #Arguments.Ecodigo# 
 			and Pcodigo = 50		
		</cfquery>
		<cfset Periodo = rsPeriodo.Periodo>
		
		<cfquery name="rsMes" datasource="#session.DSN#">
			select <cf_dbfunction name="to_integer" args="Pvalor"> as Mes
			from Parametros
			where Ecodigo =  #Arguments.Ecodigo# 
 			and Pcodigo = 60		
		</cfquery>
		<cfset Mes = rsMes.Mes>

		<cfquery name="rsERecibeTransito" datasource="#session.DSN#">
			select ERTdocref as EDdocref, ERTdocref as  ERTdocref
			from ERecibeTransito
			where ERTid = #Arguments.ERTid#		
		</cfquery>

	<cf_dbtemp name="temp_NIVELES" returnvariable="NIVELES" datasource="#session.dsn#">
		<cf_dbtempcol name="IDtemp"		    type="integer"   	   mandatory="no">
		<cf_dbtempcol name="valor"				 type="varchar(20)"		mandatory="no">
		<cf_dbtempcol name="PCEcatid"			 type="numeric" 			mandatory="no">
		<cf_dbtempcol name="PCDcatid"			 type="numeric" 			mandatory="no">	
		<cf_dbtempcol name="PCNdep"  			 type="integer" 			mandatory="no">
		<cf_dbtempcol name="PCDCniv"		 	 type="integer" 			mandatory="yes">
		<cf_dbtempcol name="CcuentaF"  		 type="numeric"	 		mandatory="no">
		<cf_dbtempcol name="CformatoF"  		 type="varchar(100)"		mandatory="no">
		<cf_dbtempcol name="PCDCnivC"  		 type="integer"	 		mandatory="no">
		<cf_dbtempcol name="CcuentaC"			 type="numeric"	 		mandatory="no">	
		<cf_dbtempcol name="CformatoC" 		 type="varchar(100)" 	mandatory="no">
		<cf_dbtempcol name="PCDCnivP"			 type="integer" 			mandatory="no">	
		<cf_dbtempcol name="CcuentaP"  		 type="numeric" 			mandatory="no">
		<cf_dbtempcol name="CformatoP"		 type="varchar(100)" 	mandatory="no">
		<cf_dbtempcol name="Cdescripcion"	 type="varchar(80)" 		mandatory="no">
		<cf_dbtempcol name="Ocodigo"  		 type="integer"			mandatory="no">
	</cf_dbtemp>
	
	<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC"></cfinvoke>
	
		<cf_dbtemp name="temp_asiento" returnvariable="asiento" datasource="#session.dsn#">
		<cf_dbtempcol name="IDcontable"	 type="numeric"   	   mandatory="yes">
		<cf_dbtempcol name="Cconcepto"	 type="integer"			mandatory="no">
		<cf_dbtempcol name="Edocumento"   type="integer" 			mandatory="no">
		<cf_dbtempcol name="Eperiodo"		 type="integer" 			mandatory="yes">
		<cf_dbtempcol name="Emes"  		 type="integer"			mandatory="yes">
	</cf_dbtemp>


	<cf_dbtemp name="temp_IdKardex" returnvariable="IdKardex" datasource="#session.dsn#">
		<cf_dbtempcol name="Kid"				type="numeric" 			mandatory="yes">
		<cf_dbtempcol name="IDcontable"		type="numeric" 			mandatory="no">
	</cf_dbtemp>
		
	<cf_dbtemp name="temp_Articulos" returnvariable="Articulos" datasource="#session.dsn#">
		<cf_dbtempcol name="Ecodigo"		   	type="integer"   	   mandatory="no">
		<cf_dbtempcol name="Aid"					type="numeric"			mandatory="no">
		<cf_dbtempcol name="linea"					type="numeric" 		mandatory="yes">
		<cf_dbtempcol name="Alm_Aid"				type="numeric" 		mandatory="no">	
		<cf_dbtempcol name="Ocodigo"  			type="integer" 		mandatory="no">
		<cf_dbtempcol name="cant"					type="float" 			mandatory="no">
		<cf_dbtempcol name="Dcodigo"  			type="integer"	 		mandatory="yes">
		<cf_dbtempcol name="ERTdocref"  			type="varchar(20)"	mandatory="yes">
		<cf_dbtempcol name="KtipoES"  			type="char(1)"	 		mandatory="yes">
		<cf_dbtempcol name="Tid"					type="numeric"	 		mandatory="no">	
		<cf_dbtempcol name="Kunidades" 			type="float" 			mandatory="no">
		<cf_dbtempcol name="DRTlinea"				type="numeric" 		mandatory="no">	
		<cf_dbtempcol name="ERTid"  				type="numeric" 		mandatory="no">
		<cf_dbtempcol name="McodigoOrigen"		type="numeric" 		mandatory="no">
		<cf_dbtempcol name="McodigoValuacion" 	type="numeric"			mandatory="no">
		<cf_dbtempcol name="costolinloc"  		type="money"			mandatory="no">
		<cf_dbtempcol name="costolinori"  		type="money"			mandatory="no">
		<cf_dbtempcol name="costolinval"  		type="money"			mandatory="no">
	</cf_dbtemp>
	
	
<!----- Validaciones Preposteo
-- 1) Invocar el Posteo de lineas de Inventario en transito Recibidas--->
		<cfquery name="rslineaTR" datasource="#session.DSN#">
			select 1 
           from ERecibeTransito
           where ERTid = #Arguments.ERTid#
	    		and  Ecodigo = #Arguments.Ecodigo#
		</cfquery>

		<cftransaction>
		<cfif rslineaTR.recordcount gt 0> 
			<cfquery  name="rs_Dato" datasource="#session.DSN#">
			   select 1 as lin, 0 as error, <cf_dbfunction name="now"> as Fecha, 'Documento de Recibo de Tránsito: ' as descripcion 
				from dual
			</cfquery>
			
			<cfquery name="rs_Mcodigo" datasource="#session.DSN#">
			   select Mcodigo as Monloc
				from Empresas 
				where Ecodigo = #Arguments.Ecodigo#
			</cfquery>
			
	<!--- Moneda y Tipo de Cambio de Valuación--->
			<cfquery  name="rs_McodigoValuacion" datasource="#session.DSN#">
			   select <cf_dbfunction name="to_number" args="Pvalor"> as McodigoValuacion
				 from Parametros 
				 where Ecodigo = #Arguments.Ecodigo#
					and Pcodigo = 441
			</cfquery>
			
		<cfset McodigoValuacion = rs_McodigoValuacion.McodigoValuacion>
		
			<cfif len(trim(McodigoValuacion)) eq 0>
				<p>Error 40000! Error en IN_PosteoLin. No se ha definido la Moneda de Valuacion de Inventarios. Proceso Cancelado!</p>
			</cfif>
		
		<cfquery  name="rsDoc" datasource="#session.DSN#">
			select ERTdocref as ERTdocref
			from ERecibeTransito
			where ERTid =  #Arguments.ERTid#
		</cfquery>
		
	<!---- Insert de los Articulos que llegaron del proceso de Rercibir Tránsito--->	
		<cf_dbfunction name="now" returnvariable="Fecha">
		<cfquery name="rsArt" datasource="#session.DSN#">
			select  
				b.DRTlinea as linea, 
				b.Aid 	  as Aid, 
				b.Alm_Aid  as Alm_Aid, 
				c.Ocodigo  as Ocodigo, 
				b.DRTcantidad as DRTcantidad, 
				c.Dcodigo  as Dcodigo, 
				coalesce(a.ERTdocref, 'Rt'#_Cat#  <cf_dbfunction name="to_char" args="#Fecha#">) as ERTdocref,
	<!---isnull(a.ERTdocref,'Rt'+ convert(varchar,getdate(),103) ),--->
				b.Tid      as Tid, 
				b.DRTlinea as DRTlinea, 
				b.ERTid    as ERTid 
			from ERecibeTransito a, DRecibeTransito b, Almacen c
			where a.ERTid = #Arguments.ERTid#
			  and a.ERTid  = b.ERTid
			  and b.Alm_Aid = c.Aid
		</cfquery>
		
	<cfif rsArt.recordcount gt 0>	
		<cfquery datasource="#session.DSN#">
			insert into #Articulos# 
			(
				Ecodigo, 
				linea ,
				Aid,  
				Alm_Aid, 
				Ocodigo, 
				cant, 
				Dcodigo, 
				ERTdocref, 
				KtipoES, 
				Tid, 
				DRTlinea, 
				ERTid, 
				Kunidades
			)
			values
			(
			#Arguments.Ecodigo#,
			#rsArt.linea#,
			#rsArt.Aid#,
			#rsArt.Alm_Aid#,
			#rsArt.Ocodigo#,
			#rsArt.DRTcantidad#,
			#rsArt.Dcodigo#,
			'#rsArt.ERTdocref#',
			'E', 
			#rsArt.Tid#,
			#rsArt.DRTlinea#,
			#rsArt.ERTid#,
			0		
			)
		</cfquery>
	</cfif>
		
		<cfquery  name="rs_Art01" datasource="#session.DSN#">
			select min(linea) as linea from #Articulos#
		</cfquery>
		
		<cfif rs_Art01.recordcount gt 0 and len(trim(rs_Art01.linea)) neq 0>
			<cfquery  name="rs_Art02" datasource="#session.DSN#">
				select 
				a.linea as linea,
				t.Tfecha as Fecha,
				coalesce(a.costolinval,0) as costolinval,
				a.McodigoValuacion as McodigoValuacion,
				a.ERTdocref as EDdocref, 
				a.Dcodigo as Dcodigo,
				a.Aid 		as Aid, 
				a.Alm_Aid 	as Alm_Aid, 
				a.Ocodigo 	as Ocodigo,  
				a.cant 		as DTcantidad, 
				a.Dcodigo 	as depto, 
				a.KtipoES 	as TipoES, 
				a.ERTdocref as ERTdocref, 
				Mcodigo 		as McodigoOrigen,
				<cf_dbfunction name="to_float" args="case when Tcantidad = 0 then 0.00 else a.cant * TcostoLinea / Tcantidad end, 2">as costolinori,
				<cf_dbfunction name="to_float" args="case when Tcantidad = 0 then 0.00 else a.cant * TcostoLinea / Tcantidad * Ttipocambio end, 2"> as costolinloc,
				t.Ttipocambio as Dtipocambio,		<!----- El tipo de cambio del documento se grabó en CxP--->
				t.TtipocambioVal	as tcValuacion 	<!----- El tipo de cambio de valuacion se grabó en CxP--->
			 from #Articulos# a
				inner join Transito t 
					on t.Tid = a.Tid
			where a.linea = #rs_Art01.linea#
			</cfquery> 
			
			<cfinvoke component="sif.Componentes.IN_PosteoLin" method="CreaIdKardex"  returnvariable="IDKARDEX"/>
			<cfinvoke component	= "sif.Componentes.IN_PosteoLin" method = "IN_PosteoLin"  returnvariable	= "LvarCOSTOS"
				Ecodigo		= "#Arguments.Ecodigo#"
				Aid			= "#rs_Art02.Aid#"
				Alm_Aid		= "#rs_Art02.Alm_Aid#"
				Tipo_Mov		= "E"
				Tipo_ES		= "#rs_Art02.TipoES#" 
				Cantidad		= "#rs_Art02.DTcantidad#"
				CostoOrigen		= "#rs_Art02.costolinori#" 
				CostoLocal		= "#rs_Art02.costolinloc#" 
				McodigoOrigen	= "#rs_Art02.McodigoOrigen#" 
				tcValuacion		= "#rs_Art02.tcValuacion#"
				FechaDoc			= "#rs_Art02.Fecha#"
				Dcodigo			= "#rs_Art02.Dcodigo#"
				Ocodigo			= "#rs_Art02.Ocodigo#"
				TipoCambio		= "1"
				Referencia		= "INV"
				ObtenerCosto	= "false"
				TipoDoc			= ""
				Documento		= "#rs_Art02.ERTdocref#"
				Debug			= "false"
				McodigoValuacion  = "#rs_Art02.McodigoValuacion#"
				costoValuacion	   = "#rs_Art02.costolinval#"	
                Usucodigo ="#session.Usucodigo#"<!--- Usuario --->
				transaccionactiva	= "true"
			/><!----- Costo TOTAL de la linea del Movimiento en Moneda Valuacion--->
			
			
	<!---/* Credito a la cuenta de Inventario en Transito por el monto */
	
				Ecodigo int, 
				Aid numeric null,
				linea numeric,
				Alm_Aid numeric,
				Ocodigo int,
				cant float,
				Dcodigo int not null,
				ERTdocref varchar(20) not  null,
				KtipoES char(1) not null,
				Tid numeric,
				Kunidades float,
				DRTlinea numeric,
				ERTid numeric,
				McodigoOrigen numeric null,
				McodigoValuacion numeric null,
				costolinloc money null,
				costolinori money null,
				costolinval money null--->
	
	
		<cfquery  name="rs_credito" datasource="#session.DSN#">
			select
				'#rs_Art02.ERTdocref#' as ERTdocref, 
				'Recepcion de Producto' #_cat# a.Acodigo as INTDES, 
				#Periodo# 				as Periodo, 
				#Mes# 					as Mes, 
				iac.IACtransito 		as Ccuenta, 
				#rs_Art02.Ocodigo#  as Ocodigo, 
				#McodigoValuacion# 	as Mcodigo, 
				#rs_Art02.tcValuacion# as INTCAM,  
				#rs_Art02.costolinval# as INTMOE, 
				#rs_Art02.costolinloc# as INTMON
			from Articulos a, Existencias e, IAContables iac
			where a.Aid = e.Aid
				and a.Ecodigo = #Arguments.Ecodigo#
				and e.Aid = #rs_Art02.Aid#
				and e.Alm_Aid = #rs_Art02.Alm_Aid#
				and e.Ecodigo = #Arguments.Ecodigo#
				and iac.IACcodigo = e.IACcodigo
				and iac.Ecodigo = e.Ecodigo
		</cfquery>
		
		<cfloop query="rs_credito">
			<cfquery datasource="#session.DSN#">
				insert into #INTARC#
				(
					INTORI, 
					INTREL, 
					INTDOC, 
					INTREF, 
					INTTIP, 
					INTDES, 
					INTFEC, 
					Periodo, 
					Mes, 
					Ccuenta, 
					Ocodigo, 
					Mcodigo, 
					INTCAM, 
					INTMOE, 
					INTMON
				)
				values
				(
				'INRP', 
					0, 
					'#rs_credito.ERTdocref#', 
					'#rs_credito.ERTdocref#', 
					'C', 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rs_credito.INTDES,80)#">, 
					<cf_dbfunction name="to_char" len="8" args="#Fecha#">,
					#rs_credito.Periodo#, 
					#rs_credito.Mes#, 
					#rs_credito.Ccuenta#, 
					#rs_credito.Ocodigo#, 
					#rs_credito.Mcodigo#, 
					#rs_credito.INTCAM#, 
					#rs_credito.INTMOE#, 
					#rs_credito.INTMON#
				)
			</cfquery>
		</cfloop>
			
	<!---/* Debito a la cuenta de Inventario por el monto */--->	
	
		<cfquery  name="rs_Debito" datasource="#session.DSN#">
			select
				'#rs_Art02.ERTdocref#'    						as ERTdocref, 
				'Recepcion de Producto' #_cat# a.Acodigo as INTDES, 
				#Periodo# 											as Periodo, 
				#Mes# 												as Mes, 
				iac.IACinventario 								as Ccuenta, 
				#rs_Art02.Ocodigo#  							as Ocodigo, 
				#McodigoValuacion# 								as Mcodigo, 
				#rs_Art02.tcValuacion# 							as INTCAM,  
				#rs_Art02.costolinval# 						as INTMOE, 
				#rs_Art02.costolinloc# 						as INTMON
			from Articulos a, Existencias e, IAContables iac
			where a.Aid = e.Aid
				and a.Ecodigo = #Arguments.Ecodigo#
				and e.Aid = #rs_Art02.Aid#
				and e.Alm_Aid = #rs_Art02.Alm_Aid#
				and e.Ecodigo = #Arguments.Ecodigo#
				and iac.IACcodigo = e.IACcodigo
				and iac.Ecodigo = e.Ecodigo
		</cfquery>
		
		<cfloop query="rs_Debito">
			<cfquery datasource="#session.DSN#">
				insert into #INTARC#
				(
					INTORI, 
					INTREL, 
					INTDOC, 
					INTREF, 
					INTTIP, 
					INTDES, 
					INTFEC, 
					Periodo, 
					Mes, 
					Ccuenta, 
					Ocodigo, 
					Mcodigo, 
					INTCAM, 
					INTMOE, 
					INTMON
				)
				values
				(
				'INRP', 
					0, 
					'#rs_Debito.ERTdocref#', 
					'#rs_Debito.ERTdocref#', 
					'D', 
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#left(rs_credito.INTDES,80)#">,
					<cf_dbfunction name="to_char" len="8" args="#Fecha#">,
					#rs_Debito.Periodo#, 
					#rs_Debito.Mes#, 
					#rs_Debito.Ccuenta#, 
					#rs_Debito.Ocodigo#, 
					#rs_Debito.Mcodigo#, 
					#rs_Debito.INTCAM#, 
					#rs_Debito.INTMOE#, 
					#rs_Debito.INTMON#
				)
			</cfquery>
		</cfloop>
		
			<cfquery name="rs_Verifica" datasource="#session.dsn#">
				select count(1) from #Articulos#	where linea = #rs_Art02.linea#
			</cfquery>
			
			<cfif rs_Verifica.recordcount gt 0>
				 <cfquery datasource="#session.dsn#">
					 update #Articulos#
					  set costolinloc = coalesce(#rs_Art02.costolinloc#,0.00),
						costolinval 	= coalesce(#rs_Art02.costolinval#,0.00),
						costolinori 	= coalesce(#rs_Art02.costolinori#,0.00),
						Kunidades = (select Eexistencia from Existencias b where b.Ecodigo = Ecodigo and Aid = #rs_Art02.Aid# and Alm_Aid = #rs_Art02.Alm_Aid#)
					where linea = #rs_Art02.linea#
				</cfquery>
			<cfelse>
				<p>Error 40000! Error en IN_PosteoLin. No se ha definido la Moneda de Valuacion de Inventarios. Proceso Cancelado!</p>
			</cfif>
		</cfif>
	</cfif>	
	
	<!---select @linea = min(linea) from #Articulos where linea > @linea--->
	
	<!----- 3) Invocar la Generacion del Asiento Contable--->
	
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
				<cfinvokeargument name="Conexion" value="#session.DSN#"/>
				<cfinvokeargument name="Ecodigo" value="#Arguments.Ecodigo#"/>
				<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#"/>
				<cfinvokeargument name="IP" value="#session.sitio.ip#"/>
				<cfinvokeargument name="Usuario" value="#Arguments.login#"/>
				<cfinvokeargument name="Oorigen" value="INRP"/>						
				<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
				<cfinvokeargument name="Emes" value="#Mes#"/>
				<cfinvokeargument name="Efecha" value="#now()#"/>
				<cfinvokeargument name="Edescripcion" value="Recepcion de Producto en Transito"/>
				<cfinvokeargument name="Edocbase" value="#rsArt.ERTdocref#"/>
				<cfinvokeargument name="Ereferencia" value="#rsArt.ERTdocref#"/>
				<cfinvokeargument name="Debug" value="false"/>
			</cfinvoke>		
			
	<!-----4) Una vez realizado todo, se actualiza el campo de Aplicado del Proceso. esto en INV_PosteoRecibeTransito--->
	
				<cfquery datasource="#session.dsn#">
					update ERecibeTransito 
						set ERTaplicado = 1
					where ERTid =  #Arguments.ERTid#
				</cfquery>
				
	
	<!----- 6) Actualizar el costo de la Recepcion con las unidades y el costo de la linea--->
			<cfquery name="rs_DRT" datasource="#session.dsn#">
				select 
					 a.costolinval, 
					 a.cant,
					 a.Kunidades
				from #Articulos# a
					inner join DRecibeTransito b
					on b.DRTlinea = a.DRTlinea
						and b.ERTid = a.ERTid
				</cfquery>
				
			<cfif rs_DRT.recordcount gt 0>
				<cfquery datasource="#session.dsn#">
					update DRecibeTransito
						set Kcosto = #rs_DRT.costolinval#, 
						DRTcostoU = case when #rs_DRT.cant# != 0 then <cf_dbfunction name="to_float" args="#rs_DRT.costolinval# / #rs_DRT.cant#, 6">else 0 end,
						Kunidades = #rs_DRT.Kunidades#
				</cfquery>
			</cfif>
		
				<cfquery datasource="#session.dsn#">
					update #IdKardex# 
						set IDcontable = #IDcontable#
				</cfquery>
	
				<cfquery  name="rs_Kardex" datasource="#session.dsn#">
					select b.IDcontable from Kardex a inner join #IdKardex# b
					on a.Kid = b.Kid
				</cfquery>
				
				<cfif rs_Kardex.recordcount gt 0>
				<cfquery datasource="#session.dsn#">		
						update Kardex 
						set IDcontable = #rs_Kardex.IDcontable#
				</cfquery>
				</cfif>
				
				<cfquery name="rs_Reporte" datasource="#session.dsn#">
					select 
						DRTlinea, 
						ERTid, 
						Alm_Aid, 
						Tid, 
						DRTcantidad, 
						Aid, 
						DRTfecha, 
						Ddocumento, 
						DRTcostoU, 
						Ucodigo, 
						Kunidades, 
						Kcosto, 
						DRTembarque, 
						DRTgananciaperdida, 
						BMUsucodigo 
					from DRecibeTransito 
					where ERTid = #Arguments.ERTid#
				</cfquery>
				
				<cfif arguments.debug EQ 'S'>
					<cf_dump var="#rs_Reporte#">
					<cf_abort errorInterfaz="">
				<cfelse>
					<cftransaction action="commit"/>
					<cfquery datasource="#session.DSN#">
						delete from #Articulos#
					</cfquery>	
					<cfquery datasource="#session.DSN#">
						delete from #asiento#
					</cfquery>				
				</cfif>															
				<cfreturn rs_Reporte>
		</cftransaction>
	</cffunction>
</cfcomponent>