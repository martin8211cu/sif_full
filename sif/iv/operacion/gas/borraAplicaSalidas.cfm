<cfset varAction = 'capturaSalidas.cfm'>

<cffunction name="revSalidasVendedores" access="public" returntype="boolean" output="true">
	<!--- Aqui se revisa que las salidas reportadas del articulo (Unidades_vendidas + Unidades_despachadas) sea igual
			a la suma de las unidades reportadas en las ventas de los vendedores de la estacion --->
	<cfset resp = true>
	<cfquery name="rsSalidas" datasource="#session.DSN#">
		Select 
			b.ID_dsalprod
			, rtrim(ar.Acodigo) as Acodigo
			, sum(Unidades_vendidas + Unidades_despachadas) as cantSal
			, coalesce(
				(   select sum(c.DDScantidad)
					from DDSalidaProd c
				    where c.ID_dsalprod = b.ID_dsalprod
			     ), 0
				)
			 as DDScantidad
		from ESalidaProd a
					inner join DSalidaProd b
								inner join Articulos ar
										on ar.Aid = b.Aid
				       on b.ID_salprod = a.ID_salprod
		where a.Ecodigo= #session.Ecodigo# 
		  and a.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
		  and a.SPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">						
		group by b.ID_dsalprod, Acodigo
		having 
				sum(Unidades_vendidas + Unidades_despachadas) 
			<>
				coalesce(
					(   select sum(c.DDScantidad)
						from DDSalidaProd c
						where c.ID_dsalprod = b.ID_dsalprod
					 ), 0
					)
	</cfquery>

	<cfif isdefined('rsSalidas') and rsSalidas.recordCount GT 0>
		<cfset cods="">	
		<cfloop query="rsSalidas">
			<cfif rsSalidas.cantSal NEQ rsSalidas.DDScantidad>
				<cfif cods EQ ''>
					<cfset cods = rsSalidas.Acodigo>			
				<cfelse>
					<cfset cods = cods & "," & rsSalidas.Acodigo>
				</cfif>
			</cfif>	
		</cfloop>
		
		<cfif cods NEQ ''>
			<cf_errorCode	code = "50405"
							msg  = "El total de salidas de los articulos ( <cfoutput>@errorDat_1@</cfoutput> ) es distinta a la registrada en las unidades vendidas por los vendedores de la estación"
							errorDat_1="#cods#"
			>
			<cfset resp = false>
		</cfif>
	</cfif>

	<cfreturn resp>
</cffunction>

<cfif isdefined("Form.btnBorrar")>
	<!--- Borra Registro de ventas por vendedores --->
	<cfquery datasource="#session.DSN#">
		delete from DDSalidaProd
		where ID_dsalprod in (
					select a.ID_dsalprod
					from DSalidaProd a
						inner join ESalidaProd b
							on b.Ecodigo=a.Ecodigo
								and a.ID_salprod=b.ID_salprod
								and b.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
								and b.SPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">
					where a.Ecodigo= #session.Ecodigo# 
				)
	</cfquery>
	<!--- Borra Detalles de las ventas --->
	<cfquery datasource="#session.DSN#">
		delete from DSalidaProd
		where Ecodigo= #session.Ecodigo# 
			and ID_salprod in (
				select ID_salprod
				from ESalidaProd 
				where Ecodigo= #session.Ecodigo# 
					and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
					and SPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">
			)
	</cfquery>		

	<!--- Borra los totales de cuentas --->
	<cfquery datasource="#session.DSN#">
		delete from TotDebitosCreditos
		where Ecodigo= #session.Ecodigo# 
			and ID_salprod in (
				select ID_salprod
				from ESalidaProd 
				where Ecodigo= #session.Ecodigo# 
					and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
					and SPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">			
			)
	</cfquery>	
	
	<!--- Borra el encabezado de las ventas --->
	<cfquery datasource="#session.DSN#">
		delete from ESalidaProd
		where Ecodigo= #session.Ecodigo# 
			and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
			and SPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">	
	</cfquery>
<cfelseif isdefined("Form.btnAplicar")>
	<cfset revSal = revSalidasVendedores()>
	
	<cfif revSal>
		<cfquery name="data" datasource="#session.DSN#">
			select a.ID_dsalprod, b.Ocodigo, c.Dcodigo, a.Alm_ai, a.Aid, ( coalesce(a.Unidades_vendidas, 0) + coalesce(a.Unidades_despachadas, 0) ) as total 
			from DSalidaProd a
				inner join ESalidaProd b
					on b.ID_salprod=a.ID_salprod
						and b.Ecodigo=a.Ecodigo
			
				inner join Almacen c
					on c.Aid=a.Alm_ai
						and c.Ecodigo=b.Ecodigo

			where a.Ecodigo= #session.Ecodigo# 
				and b.Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
				and b.SPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">	
				and coalesce(a.Unidades_vendidas, 0) + coalesce(a.Unidades_despachadas, 0)  > 0
		</cfquery>
		<cfif data.recordcount gt 0>
			<cftransaction>
				<cfinvoke component="sif.Componentes.IN_PosteoLin" method="CreaIdKardex">
				<cfoutput query="data">
					<cfinvoke component="sif.Componentes.IN_PosteoLin" method="IN_PosteoLin">
						<cfinvokeargument name="Aid" value="#data.Aid#" >
						<cfinvokeargument name="Alm_Aid" value="#data.Alm_ai#" >
						<cfinvokeargument name="Ocodigo" value="#data.Ocodigo#" >
						<cfinvokeargument name="Dcodigo" value="#data.Dcodigo#" >
						<cfinvokeargument name="Tipo_Mov" value="S" >
						<cfinvokeargument name="Tipo_ES" value="S" >
						<cfinvokeargument name="Cantidad" value="#data.total#" >
						<cfinvokeargument name="IDdocorig" value="#data.ID_dsalprod#" >
                        <cfinvokeargument name="Usucodigo" value="#session.Usucodigo#" >
						<cfinvokeargument name="TransaccionActiva" value="true" >
					</cfinvoke>
				</cfoutput> 
				
<!---	-------------------------------------------------------------------------------------------------------------	--->
<!---	----------------------------------	REGISTRO CONTABLE DE LA VENTA	-----------------------------------------	--->								
<!---	-------------------------------------------------------------------------------------------------------------	--->

				<!---	*******************  carga de valores fijos *********************	--->
 				<cfquery name="RSOrigen" datasource="#session.DSN#">
					select  Cconcepto  from  ConceptoContable
					where Ecodigo = #session.Ecodigo# 
					and  Oorigen = 'FAFC'
				</cfquery>
				<cfset Concepto = RSOrigen.Cconcepto>
				
				<cfquery name="RSMoneda" datasource="#session.DSN#">
					select Mcodigo from Empresas 
					where Ecodigo = #session.Ecodigo# 
				</cfquery>
				<cfset Moneda = RSMoneda.Mcodigo>
				
				<cfquery name="RSAnno" datasource="#session.DSN#">
					select Pvalor from Parametros  
					where  Pcodigo = 50 
					and Ecodigo  = #session.Ecodigo# 
				</cfquery>						
				<cfset Periodo   = RSAnno.Pvalor>
				
				<cfquery name="RSMes" datasource="#session.DSN#">
					select Pvalor from Parametros  
					where  Pcodigo = 60 
					and Ecodigo  = #session.Ecodigo# 
				</cfquery>	
				<cfset Mes         = RSMes.Pvalor>
				<cfset TipoCambio  = 1>
				
				<!--- 1. Validaciones --->
				<cfif Mes EQ 0 or Periodo EQ 0>
					<cf_errorCode	code = "50406" msg = "No se ha definido el parámetro de Período o Mes para los sistemas Auxiliares. El proceso ha sido cancelado">
					<cfabort>
				</cfif>
			
				<!---	******************* Creación de la tabla INTARC ******************	--->
				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" returnvariable="Intarc" method="CreaIntarc" >
					<cfinvokeargument name="Conexion" value="#session.DSN#"/>
				</cfinvoke>
				
				<!---	Movimientos de las tablas ESalProd y TotDebitosCreditos	--->
				<cfquery name="rsInsertINTARC1" datasource="#session.DSN#">
					insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)								
					select 
							'FAFC',
							1 as INTREL,
							<cf_dbfunction name="to_char"	args="e.ID_salprod"> as INTDOC,
							<cf_dbfunction name="to_char"	args="e.ID_salprod"> as INTREF,
							d.TDCtotal as INTMON,
							d.TDCtipo as INTTIP,
							coalesce(d.TDCdesc, d.TDCformato) as INTDES,
							e.SPfecha as INTFEC,
							1.00 as INTCAM,
							#Periodo# as Periodo,
							#Mes# as Mes,
							coalesce((
								select min(cf.Ccuenta) 
								from CFinanciera cf
								where cf.CFformato = d.TDCformato
								  and cf.Ecodigo = e.Ecodigo
								), 0) as Ccuenta,
							#Moneda# as Mcodigo,
							e.Ocodigo as Ocodigo,
							d.TDCtotal as INTMOE
					from ESalidaProd e
						inner join TotDebitosCreditos d
								on d.ID_salprod = e.ID_salprod
					where e.Ecodigo =  #session.Ecodigo# 
					and e.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
					and e.SPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">
				</cfquery>					
					
				<!---	Ventas	--->
                <cfinclude template="../../../Utiles/sifConcat.cfm">
				<cfquery name="rsInsertINTARC1" datasource="#session.DSN#">
					insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)								
					select 
							'FAFC',
							1 as INTREL,
							<cf_dbfunction name="to_char"	args="e.ID_salprod)"> as INTDOC,
							<cf_dbfunction name="to_char"	args="e.ID_salprod"> as INTREF,
							d.Ingreso as INTMON,
							'C' as INTTIP,
							'Venta de Producto: ' #_Cat# a.Acodigo #_Cat# ' Fecha: ' #_Cat# <cf_dbfunction name="to_sdateDMY"	args="e.SPfecha"> as INTDES,
							e.SPfecha as INTFEC,
							1.00 as INTCAM,
							#Periodo# as Periodo,
							#Mes# as Mes,
							c.IACingventa as Ccuenta,
							#Moneda# as Mcodigo,
							e.Ocodigo as Ocodigo,
							d.Ingreso as INTMOE
					from ESalidaProd e
						inner join DSalidaProd d
							on d.ID_salprod = e.ID_salprod
						inner join Articulos a
							on a.Aid = d.Aid
								inner join Existencias ex
									on ex.Aid = d.Aid
									and ex.Alm_Aid = d.Alm_ai
											inner join IAContables c
												on c.IACcodigo = ex.IACcodigo
												and c.Ecodigo = ex.Ecodigo
					where e.Ecodigo =  #session.Ecodigo# 
					and e.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
					and e.SPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">
					and d.Ingreso <> 0
				</cfquery>					

				<!---	Impuestos	--->
				<cfquery name="rsInsertINTARC1" datasource="#session.DSN#">
					insert INTO #Intarc# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Mcodigo, Ocodigo, INTMOE)								
					select 
							'FAFC',
							1 as INTREL,
							<cf_dbfunction name="to_char"	args="e.ID_salprod"> as INTDOC,
							<cf_dbfunction name="to_char"	args="e.ID_salprod"> as INTREF,
							round(d.Ingreso * i.Iporcentaje / 100, 2) as INTMON,
							'C' as INTTIP,
							i.Idescripcion  #_Cat# ' de Producto ' #_Cat# a.Acodigo as INTDES,
							e.SPfecha as INTFEC,
							1.00 as INTCAM,
							#Periodo# as Periodo,
							#Mes# as Mes,
							i.Ccuenta as Ccuenta,
							#Moneda# as Mcodigo,
							e.Ocodigo as Ocodigo,
							round(d.Ingreso * i.Iporcentaje / 100, 2) as INTMOE
					from ESalidaProd e
						inner join DSalidaProd d
							on d.ID_salprod = e.ID_salprod
						inner join Articulos a
							on a.Aid = d.Aid
						inner join Impuestos i
							on i.Ecodigo = a.Ecodigo
							and i.Icodigo = a.Icodigo
				  where e.Ecodigo =  #session.Ecodigo# 
					and e.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
					and e.SPfecha = <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">
					and d.Ingreso <> 0
				</cfquery>					

				<cfquery datasource="#Session.DSN#">
					update #Intarc#
					set 
						Cformato = ((select min(c.Cformato) from CContables c where c.Ccuenta = #Intarc#.Ccuenta)),
						CFcuenta = ((select min(cf.CFcuenta) from CFinanciera cf where cf.Ccuenta = #Intarc#.Ccuenta))
				</cfquery>
								
				<cfquery name="DELINTARC" datasource="#session.DSN#">
					delete  from #Intarc#
					where INTMON = 0
				</cfquery>
				
				<!---	******************* insert #INTARC CREDITO  ******************	--->
				<cfquery name="RSINTARC" datasource="#session.DSN#">
					select count(1) as Cantidad  from #Intarc#
				</cfquery>
				
				<!---	******************* insert #INTARC CREDITO  ******************	--->
				<cfif isdefined('RSINTARC') and RSINTARC.Cantidad GT 0>
  					<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="IDcontable">
						<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
						<cfinvokeargument name="Oorigen" value="FAFC"/>
						<cfinvokeargument name="Eperiodo" value="#Periodo#"/>
						<cfinvokeargument name="Emes" value="#Mes#"/>
						<cfinvokeargument name="Efecha" value="#form.fSPfecha#"/>
						<cfinvokeargument name="Edescripcion" value="FAFC Documento de Facturación Fecha: #LsDateformat(form.fSPfecha, "DD/MM/YYYY")#]"/>
						<cfinvokeargument name="Edocbase" value="null"/>
						<cfinvokeargument name="Ereferencia" value="null"/>
					</cfinvoke>
					
					Cambio del estado a aplicada  
					<cfquery name="update" datasource="#session.DSN#">
						update ESalidaProd
							set SPestado = 10 
						where Ecodigo= #session.Ecodigo# 
							and Ocodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">
							and SPfecha=<cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.fSPfecha)#">	
					</cfquery>
				<cfelse>	
					<script language="JavaScript">
						alert('No hay información para procesar')
						history.back()
					</script>
					<cfabort>					
				</cfif> 
			</cftransaction>	
		</cfif>
	</cfif><!--- revision si las unidades de salida por ventas son iguales a las reportadas por los vendedores --->				
</cfif>

<form action="<cfoutput>#varAction#</cfoutput>" method="post" name="sql">
	<input name="f_Ocodigo" type="hidden" value="<cfif isdefined("form.Ocodigo") and len(trim(form.Ocodigo))><cfoutput>#form.Ocodigo#</cfoutput></cfif>">
	<input name="fSPfecha" type="hidden" value="<cfif isdefined("form.SPfecha") and len(trim(form.SPfecha))><cfoutput>#form.SPfecha#</cfoutput></cfif>">	
	<cfif isdefined('form.btnConsultar')>
		<input name="btnConsultar" type="hidden" value="Consultar">
	</cfif>	
</form>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

