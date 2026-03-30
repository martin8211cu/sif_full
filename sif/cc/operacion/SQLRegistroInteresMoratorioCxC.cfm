<!---------
	Modificado por: Ana Villavicencio
	Fecha de modificación: 28 de junio del 2005
	Motivo:	corrección de error en la asignación de las cuentas contables para aplicar el interes moratorio.
			Si el cliente no tiene cuentas contables asignadas, producía el error.  Se agregó la validación 
			de las cuentas contables del cliente. Si no tiene cancela el proceso.<cf_dump var="#form#">
----------->
<!--- FUNCION QUE TOMA EL FORMATO DE UNA CUENTA Y APLICA LA MASCARA---> 
<cfset action = 'RegistroInteresMoratorioCxC.cfm'>
<cffunction name="AplicarMascara" access="public" output="true" returntype="string">
	<cfargument name="cuenta"   type="string" required="true">
	<cfargument name="objgasto" type="string" required="true">

	<cfset vCuenta = arguments.cuenta >
	<cfset vObjgasto = arguments.objgasto >

	<cfif len(trim(vCuenta))>
		<cfloop condition="Find('?',vCuenta,0) neq 0">
			<cfif len(trim(vObjgasto))>
				<cfset caracter = mid(vObjgasto, 1, 1) >
				<cfset vObjgasto = mid(vObjgasto, 2, len(vObjgasto)) >
				<cfset vCuenta = replace(vCuenta,'?',caracter) >
			<cfelse>
				<cfbreak>
			</cfif>
		</cfloop>
	</cfif>
	<cfreturn vCuenta >
</cffunction>				

<cfif isdefined('Aplicar')>
	<!--- CONSULTA LA DESCRIPCION DEL  CONCEPTO --->
	<cfquery name="rsConceptoDesc" datasource="#session.DSN#">
		select Cdescripcion
		from Conceptos
		where Ecodigo =  #session.Ecodigo# 
		  and Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.Cid#">
	</cfquery>
	<cfquery name="rsImpuesto" datasource="#session.DSN#">
		select Iporcentaje as Porcentaje, Icompuesto
		from Impuestos
		where Ecodigo =  #session.Ecodigo# 
		  and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
	</cfquery>
	<cfif rsImpuesto.Icompuesto>
		<cfquery name="rsImpuesto" datasource="#session.DSN#">
			select DIporcentaje as Porcentaje
			from DImpuestos
			where Ecodigo =  #session.Ecodigo# 
			  and Icodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">
		</cfquery>
	</cfif>

	<!--- SI EL CHECK ESTA ACTIVO SE HACE UN DOCUMENTO DE MOROSIDAD POR CADA SOCIO/DIRECCION 
			se tiene una lista TotalMorosidad que trae monto|moneda|socio|direccion
		  SE TIENE Q ACTUALIZAR EL DOCUMENTO EN EL CAMPO DEdiasMoratorio 
		  SI NO ENTONCES CREA UN DOCUMENTO DE MOROSIDAD POR CADA DOCUMENTO SELECCIONADO
		   	se tiene una lista chk_DocCliente que trae moneda|socio|direccion|CCTcodigo|CCTdescripcion|documento|monto|fechavencimiento|
	--->
	
	<cfif isdefined('form.chk_AgrupaxCliente') and form.chk_AgrupaxCliente EQ 'on'>

	<!--- AGRUPADO POR CLIENTE/DIRECCION --->
		<cfset chequeados = ListToArray(Form.TotalMorosidad, ',')>
		<cfset cuantos = ArrayLen(chequeados)>
		<cfloop index="CountVar" from="1" to="#cuantos#">
			<!--- TOMA UNO A UNO LOS ELEMENTOS DE TOTALMOROSIDAD --->
			<cfset valores = ListToArray(chequeados[CountVar],'|')>
			<cfif valores[1] GT 0>
				<cftransaction>
					<cfset Lvar_Monto = valores[1]>
					<cfset Lvar_Moneda = valores[2]>
					<cfset Lvar_Socio = valores[3]>
					<cfset Lvar_Direccion = valores[4]>
					<cfset nombreDoc = #Form.DocIntMora# & '-' & #CountVar#>
					<!--- VERIFICA Q NO EXISTA EL DOCUMENTO --->
					<cfquery name="rsExisteEncab" datasource="#Session.DSN#">
						select 1 
						from Documentos
						where Ecodigo =  #session.Ecodigo# 
						  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoD#"> 
						  and rtrim(ltrim(Ddocumento)) = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#NombreDoc#">))
						  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Socio#">
					</cfquery>
					<cfif isdefined('rsExisteEncab') and rsExisteEncab.RecordCount EQ 1> 
						<cftransaction action="rollback"/>
						<cf_errorCode	code = "50188" msg = "El documento ya existe. Proceso cancelado.">
					</cfif>	
					<!--- TRAE LOS DATOS DEL SOCIO --->	
					<cfquery name="rsdatos" datasource="#session.DSN#">
						select  snd.id_direccion,
								snd.SNnombre,
								sn.SNcuentacxc, 
								sn.SNdiasMoraCC, 
								sn.cuentac,
								sn.SNcodigo,
								snd.DEidVendedor,
								snd.DEidCobrador,
								snd.SNDCFcuentaCliente
						from SNegocios sn
						inner join SNDirecciones snd
							on snd.SNid = sn.SNid
							and snd.id_direccion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Direccion#">
						where sn.Ecodigo =  #session.Ecodigo# 
						  and sn.SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Socio#">
					</cfquery>
					<!--- TRAE LA CUENTA CONTABLE DEL CONCEPTO --->
					<cfquery name="rsCuentaConcepto" datasource="#session.DSN#">
						select b.Dcodigo, b.Ccuenta,c.Cdescripcion, a.Cformato, a.cuentac
						from Conceptos a, CuentasConceptos b, CContables c
						where a.Ecodigo =  #session.Ecodigo# 
						  and a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
						  and a.Ecodigo = b.Ecodigo
						  and a.Ecodigo = c.Ecodigo
						  and b.Ecodigo = c.Ecodigo
						  and b.Ccuenta = c.Ccuenta
						  and a.Cid = b.Cid					
					</cfquery>
					<cfset CuentaContableC = 0>
					<cfif isdefined('rsCuentaConcepto') and rsCuentaConcepto.RecordCount GT 0>
						<cfif isdefined('rsCuentaConcepto.Cformato') and LEN(rsCuentaConcepto.Cformato) GT 0>
							<cfset cuentaConcepto = AplicarMascara(rsCuentaConcepto.Cformato,rsdatos.cuentac)>
							<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" 
									  returnvariable="LvarError">
								<cfinvokeargument name="Lprm_Cmayor" value="#Left(cuentaConcepto,4)#"/>							
								<cfinvokeargument name="Lprm_Cdetalle" value="#mid(cuentaConcepto,6,100)#"/>
								<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
								</cfinvoke>
							<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
								<cftransaction action="rollback"/>
								<cf_errorCode	code = "50189" msg = "La Cuenta Financiera no existe o el Socio no tiene Cuenta Complemento. Verifique.">
							<cfelse>
								<cfquery name="rsCuentaC" datasource="#session.DSN#">
									select coalesce(Ccuenta, -1) as Ccuenta
									from CFinanciera 
									where Ecodigo =  #session.Ecodigo# 
									  and CFformato = <cfqueryparam  cfsqltype="cf_sql_varchar"value="#cuentaConcepto#">
								</cfquery>
								<cfif isdefined('rsCuentaC') and rsCuentaC.RecordCount GT 0>
									<cfset CuentaContableC = rsCuentaC.Ccuenta>
								</cfif>
							</cfif>
						<cfelse>
							<cfset CuentaContableC = rsCuentaConcepto.Ccuenta>
						</cfif>
					<cfelse>
						<cfif CuentaContableC EQ 0> 
							<cftransaction action="rollback"/>
							<cf_errorCode	code = "50190" msg = "No hay Cuentas Contables asignadas al Concepto. Proceso cancelado.">
						</cfif>	
					</cfif>
					<!--- TRAE EL TIPO DE CAMBIO --->
					<cfquery name="rsMonLocal" datasource="#session.DSN#">
						select Mcodigo
						from Empresas
						where Ecodigo =  #session.Ecodigo# 
					</cfquery>
					<cfif isdefined('rsMonLocal') and rsMonLocal.Mcodigo EQ Lvar_Moneda>
						<cfset TipoCambio = 1.00>
					<cfelse>
						<cfquery name="rsTipoCambio" datasource="#session.DSN#">
							select TCventa as TCventa
							from Htipocambio
							where Ecodigo =  #session.Ecodigo# 
							  and Hfecha  <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Corte#">
							  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Moneda#">
							order by Hfecha desc
						</cfquery>
						<cfif rsTipocambio.RecordCount GT 0>
							<cfset TipoCambio = rsTipoCambio.TCventa>				
						<cfelse>
							<cfset TipoCambio = 1.00>				
						</cfif>
					</cfif>
	
					<!--- TRAE LA CUENTA CONTABLE DEL SOCIO SEGUN LA TRANSACCION --->
					<cfquery name="rsCuentasSocios" datasource="#Session.DSN#">
						select b.CCTcodigo, b.CCTdescripcion, c.Ccuenta, c.Cdescripcion, c.Cformato
						  from CuentasSocios a
							inner join CCTransacciones b
							   on a.CCTcodigo = b.CCTcodigo
						      and a.Ecodigo = b.Ecodigo
							inner join CContables c
							   on a.Ccuenta = c.Ccuenta
						      and a.Ecodigo = c.Ecodigo
						Where a.Ecodigo  =  #session.Ecodigo# 
						  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.SNcodigo#">
						  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CCTcodigoD#"> 
					</cfquery>	
					
					<cfif LEN(rsCuentasSocios.Ccuenta) EQ 0 and LEN(rsDatos.SNcuentacxc) EQ 0> 
						<cftransaction action="rollback"/>
						<cf_errorCode	code = "50191"
										msg  = "No hay Cuentas Contables asignadas al Cliente @errorDat_1@. Proceso cancelado."
										errorDat_1="#rsDatos.SNnombre#"
						>
					</cfif>	
					<cfif isdefined('form.chk_DocCliente')>
						<cfset chequeado = ListToArray(Form.chk_DocCliente, ',')>
						<cfset valor = ListToArray(chequeado[1],'|')>
						<cfset oficina = valor[9]>
					</cfif>
					
					<!--- ENCABEZADO DEL DOCUMENTO DE INTERES MORATORIO  --->
					<cfquery name="InsertaDoc" datasource="#session.DSN#">
						insert into EDocumentosCxC
						(Ecodigo, 
						 CCTcodigo, 
						 EDdocumento, 
						 SNcodigo, 
						 Mcodigo, 
						 EDtipocambio, 
						 Icodigo,
						 EDtotal, 
						 EDdescuento,
						 EDporcdesc,
						 EDimpuesto,
						 Ocodigo, 
						 Ccuenta, 
						 EDfecha, 
						 EDusuario, 
						 EDvencimiento, 
						 DEidVendedor, 
						 DEidCobrador, 
						 DEdiasVencimiento, 
						 DEobservacion, 
						 id_direccionFact, 
						 id_direccionEnvio, 
						 BMUsucodigo) 
						values ( 
							 #session.Ecodigo# ,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoD#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DocIntMora#-#CountVar#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Socio#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Moneda#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#TipoCambio#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">, 
							<cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_Monto#">,
							0.00,
							0.00,
							0.00,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#oficina#">,
							<cfif isdefined('rsDatos') and rsDatos.SNDCFcuentaCliente GT 0> <!--- CUENTA DE LA DIRECCION --->
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.SNDCFcuentaCliente#">,
							<cfelseif isdefined('rsCuentasSocios') and rsCuentasSocios.RecordCount GT 0><!--- CUENTA DE LA TRANSACCION --->
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentasSocios.Ccuenta#">,
							<cfelse>																	<!--- CUENTA DEL SOCIO --->
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.SNcuentacxc#">,
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
							<cfif isdefined('rsdatos.DEidvendedor') and LEN(rsdatos.DEidvendedor) GT 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.DEidvendedor#">,
							<cfelse>
								null,
							</cfif>
							<cfif isdefined('rsdatos.DEidvendedor') and LEN(rsdatos.DEidcobrador) GT 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.DEidcobrador#">,
							<cfelse>
								null,
							</cfif>
							0,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Factura de Interés Moratorio - #rsdatos.SNnombre#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Direccion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Direccion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="InsertaDoc">
					<cfset IDDoc = InsertaDoc.identity>
					<cfset Lvar_Impuesto = 0.00>
					<!--- GENERA UNA LINEA DE DETALLE POR CADA DOCUMENTO --->
					<cfif isdefined('Form.chk_DocCliente')>
						<cfset chequeadosD = ListToArray(Form.chk_DocCliente, ',')>
						<cfset cuantosD = ArrayLen(chequeadosD)>
						<cfloop index="CountVarD" from="1" to="#cuantosD#">
							<cfset valoresD = ListToArray(chequeadosD[CountVarD],'|')>
							<cfif valoresD[2] EQ Lvar_Socio and valoresD[3] EQ Lvar_Direccion and valoresD[1] EQ Lvar_Moneda>
								 <!--- TRAE LOS DATOS DEL DOCUMENTO PARA EL CALCULO DE LOS DIAS CALCULADOS PARA EL INTERES MORATORIO --->	
								<cfquery name="rsDias" datasource="#session.DSN#">
									select a.Dvencimiento, a.DEdiasMoratorio, b.SNdiasMoraCC, 
										a.Dfecha, a.CCTcodigo, a.Ddocumento, a.Dsaldo
									 from Documentos a
									   inner join SNegocios b
									  	on a.Ecodigo  = b.Ecodigo
									   and a.SNcodigo = b.SNcodigo 
									where a.Ecodigo =  #session.Ecodigo# 
									  and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#valoresD[6]#">	
									  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#valoresD[4]#">	
									  
								</cfquery>
								<cfset Descripcion = rsDias.CCTcodigo & ' ' & rsDias.Ddocumento & ' ' & LSDateFormat(rsDias.Dfecha,'dd/mm/yyyy') & ' ' & LSCurrencyFormat(rsDias.Dsaldo,'none')> 
								<cfset DiasCorte = DateDiff('d',LSParseDAteTime(LSDateFormat(rsDias.Dvencimiento,'dd/mm/yyyy')),LSParseDateTime(form.Corte))>
								<cfset DiasCalculadosIM = DiasCorte - rsDias.SNdiasMoraCC - rsDias.DEdiasMoratorio>
								
								<!--- HACE EL CALCULO DEL MONTO DEL INTERES MORATORIO --->
								<cfif isdefined('form.DiasVenc') and form.DiasVenc EQ 0>
								<!--- SI LOS DIAS ES CERO --->
								<!--- Impuesto = Saldo de la transaccion * % Tasa interés * %Impuesto --->
								<!--- Morosidad = (Saldo de la transaccion * % Tasa interés) + Impuesto --->
									<!--- SE HACE UN CICLO PARA EL CALCULO DE LOS IMPUESTOS --->
									<cfloop query="rsImpuesto">
										<cfset Lvar_Impuesto =  Lvar_Impuesto + (valoresD[7] * (form.Tasa/100) * (rsImpuesto.Porcentaje/100))>
									</cfloop>
									<cfset Lvar_Morosidad = (valoresD[7] * (form.Tasa/100))>
									<cfset Lvar_MorosidadImp = (valoresD[7] * (form.Tasa/100)) + (round(Lvar_Impuesto*100)/100)>
								<cfelse>
								<!--- SI LOS DIAS ES MAYOR A CERO --->
								<!--- Impuesto = Saldo de la transaccion * (% Tasa interés/30) * Dias * %Impuesto --->
								<!--- Morosidad = (Saldo de la transaccion * (% Tasa interés/30) * Dias) + Impuesto --->
									<cfloop query="rsImpuesto">
										<cfset Lvar_Impuesto =  Lvar_Impuesto + (valoresD[7] * ((form.Tasa/100)/30) * form.DiasVenc * (rsImpuesto.Porcentaje/100))>
									</cfloop>
									<cfset Lvar_Morosidad = (valoresD[7] * ((form.Tasa/100)/30) * form.DiasVenc)>
									<cfset Lvar_MorosidadImp = (valoresD[7] * ((form.Tasa/100)/30) * form.DiasVenc)+ (round(Lvar_Impuesto*100)/100)>
								</cfif>
								
						
								<!--- DETALLE DEL DOCUMENTO DE INTERES MORATORIO --->
								<cfquery name="insertD" datasource="#Session.DSN#" >
									insert into DDocumentosCxC
										(	EDid,
											Cid,
											Ccuenta, 
											Ecodigo, 
											DDdescripcion, 
											DDdescalterna,
											DDcantidad, 
											DDpreciou, 
											DDtotallinea, 
											DDdesclinea,
											DDporcdesclin,
											DDtipo, 
											Icodigo,
											DocrefIM,
											CCTcodigoIM,
											cantdiasmora,
											BMUsucodigo)
										values (
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#IDDoc#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaContableC#">,
										 #session.Ecodigo# ,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#Descripcion#">,
										<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConceptoDesc.Cdescripcion#">,
										1,
										<cfqueryparam cfsqltype="cf_sql_money" value="#round(Lvar_Morosidad*100)/100#">,
										<cfqueryparam cfsqltype="cf_sql_money" value="#round(Lvar_Morosidad*100)/100#">,
										0.00,
										0.00,
										<cfqueryparam cfsqltype="cf_sql_char" value="S">,
										<cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">,
										<cfqueryparam cfsqltype="cf_sql_char" value="#valoresD[6]#">,
										<cfqueryparam cfsqltype="cf_sql_char" value="#valoresD[4]#">,
										<cfqueryparam cfsqltype="cf_sql_integer" value="#DiasCalculadosIM#">,
										<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
									) 
								</cfquery>
							</cfif>
						</cfloop>
						<!--- CALCULO DEL IMPUESTO --->
						<!--- ****************************************************************************************** --->
						<cf_dbtemp name="TT_Impuestos" returnvariable="TT_Impuestos" datasource="#session.dsn#">
						  <cf_dbtempcol name="Icodigo" type="char(5)"> 
						  <cf_dbtempcol name="DDtotallinea" type="money">
						  <cf_dbtempcol name="Porcentaje" type="float"> 
						   <cf_dbtempcol name="DDlinea" type="numeric"> 
						   <cf_dbtempcol name="Impuesto" type="money"> 
						</cf_dbtemp>
				
						<cfquery name="rsImpuestos" datasource="#session.DSN#">
							insert into #TT_Impuestos#(Icodigo, DDtotallinea,Porcentaje,DDlinea,Impuesto)
							select d.DIcodigo, round(b.DDtotallinea,2), d.DIporcentaje,b.DDlinea,b.DDtotallinea*d.DIporcentaje/100.00
							from EDocumentosCxC a 
								inner join DDocumentosCxC b
									  on b.EDid    = a.EDid
									 and b.Ecodigo = a.Ecodigo
								inner join Impuestos c
									  on c.Ecodigo = b.Ecodigo
									 and c.Icodigo = b.Icodigo 
								inner join DImpuestos d
									on d.Ecodigo = c.Ecodigo 
								   and d.Icodigo = c.Icodigo
							where a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDDoc#">
							  and  c.Icompuesto = 1
						</cfquery>
						
						<cfquery name="rsTotalImpuesto" datasource="#session.DSN#">
							insert into #TT_Impuestos#(Icodigo, DDtotallinea,Porcentaje,DDlinea,Impuesto)
							select c.Icodigo, round(b.DDtotallinea,2), c.Iporcentaje, DDlinea, b.DDtotallinea*c.Iporcentaje/100.00
							from EDocumentosCxC a 
								inner join DDocumentosCxC b
									  on b.Ecodigo = a.Ecodigo
									 and b.EDid    = a.EDid 
								inner join Impuestos c
									  on c.Ecodigo = b.Ecodigo
									 and c.Icodigo = b.Icodigo
							where a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDDoc#">
							  and c.Icompuesto = 0
						</cfquery>
						<cfquery name="rsConsulta" datasource="#session.DSN#">
							select *
							from #TT_Impuestos#
						</cfquery>
						<cfquery name="rsTotalImpuestos" datasource="#session.DSN#">
							select round(sum(DDtotallinea) * Porcentaje / 100.00,2) as TotalImpuestos
							from #TT_Impuestos#
							group by Icodigo, Porcentaje
						</cfquery>
						<cfquery name="rsTotalI" dbtype="query">
							select sum(TotalImpuestos)	 as TotalImpuestos
							from rsTotalImpuestos
						</cfquery>
						<cfif rsTotalI.RecordCount GT 0>
							<cfset TotalImpuestos = rsTotalI.TotalImpuestos>
						<cfelse>
							<cfset TotalImpuestos = 0.00>
						</cfif>
						<cfquery name="rsTotal" datasource="#session.DSN#">
							select coalesce(sum(a.DDtotallinea),0.00) as Total
							from DDocumentosCxC a 
								inner join EDocumentosCxC b
								   on b.EDid    = a.EDid
								  and b.Ecodigo = a.Ecodigo
							where a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDDoc#">
						</cfquery>

						<!--- ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
						<cfquery name="rsUpdateE" datasource="#session.DSN#">
							update EDocumentosCxC 
							set EDimpuesto = #TotalImpuestos#
								,EDtotal    = #rsTotal.Total#
											+ #TotalImpuestos#
						   where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDDoc#">
							 and Ecodigo =  #session.Ecodigo# 
						</cfquery> 
						<!--- ****************************************************************************************** --->
					</cfif>
				</cftransaction>
			</cfif>
		</cfloop>
	<cfelse>
		<!--- GENERACION DE INTERES MORATORIO POR DOCUMENTO SELECCIONADO --->
		<cfif isdefined('Form.chk_DocCliente')>
			<cfset chequeados = ListToArray(Form.chk_DocCliente, ',')>
			<cfset cuantos = ArrayLen(chequeados)>
			<cfloop index="CountVar" from="1" to="#cuantos#">
				<cfset valores = ListToArray(chequeados[CountVar],'|')>
				<cfset nombreDoc = #Form.DocIntMora# & '-' & #CountVar#>
				<cfset Lvar_Moneda = valores[1]>
				<cfset Lvar_Socio = valores[2]>
				<cfset Lvar_Direccion = valores[3]>
				<cfset Lvar_CCTcodigo = valores[4]>
				<cfset Lvar_Ddocumento = valores[6]>
				<cfset Lvar_Saldo = valores[7]>
				
				<!--- VERIFICA Q NO EXISTA EL DOCUMENTO --->
				<cfquery name="rsExisteEncab" datasource="#Session.DSN#">
					select 1 
					from Documentos
					where Ecodigo =  #session.Ecodigo# 
					  and CCTcodigo = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CCTcodigoD#">
					  and rtrim(ltrim(Ddocumento)) = rtrim(ltrim(<cfqueryparam cfsqltype="cf_sql_char" value="#NombreDoc#">))
					  and SNcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Socio#">
				</cfquery>
				<cfif isdefined('rsExisteEncab') and rsExisteEncab.RecordCount EQ 1> 
					<cftransaction action="rollback"/>
					<cf_errorCode	code = "50188" msg = "El documento ya existe. Proceso cancelado.">
				</cfif>	
				<!--- TRAE LOS DATOS DE LA DIRECCION DEL DOCUMENTO --->	
				<cfquery name="rsCuentaDir" datasource="#session.DSN#">
					select SNDCFcuentaCliente
					from SNDirecciones
					where Ecodigo 	  	=  #session.Ecodigo# 
					  and SNcodigo 	  	= <cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Socio#">
					  and id_direccion 	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Direccion#">
				</cfquery>
				<!--- TRAE LOS DATOS DEL DOCUMENTO --->	
				<cfquery name="rsdatos" datasource="#session.DSN#">
						select a.Ocodigo, a.Mcodigo, a.SNcodigo, a.DEidVendedor, a.DEidCobrador, a.Ddocumento, 
								a.CCTcodigo, b.SNnombre, a.Dfecha,
							   b.SNcuentacxc, a.Dvencimiento, a.DEdiasMoratorio, a.Dsaldo, b.SNdiasMoraCC, b.cuentac,
							   a.id_direccionFact as id_direccionFact, 
							   a.id_direccionEnvio as id_direccionEnvio
						from Documentos a
						  inner join SNegocios b
						     on a.Ecodigo  = b.Ecodigo
						    and a.SNcodigo = b.SNcodigo
						where a.Ecodigo =  #session.Ecodigo# 
						  and a.Ddocumento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_Ddocumento#">	
						  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Lvar_CCTcodigo#">	
						  
				</cfquery>
				<cfset Descripcion = rsdatos.CCTcodigo & ' ' & rsdatos.Ddocumento & ' ' & LSDateFormat(rsdatos.Dfecha,'dd/mm/yyyy') & ' ' & LSCurrencyFormat(rsdatos.Dsaldo,'none')> 
				<cfset DiasCorte = DateDiff('d',LSParseDAteTime(LSDateFormat(rsdatos.Dvencimiento,'dd/mm/yyyy')),LSParseDateTime(form.Corte))>
				<cfset DiasCalculadosIM = DiasCorte - rsdatos.SNdiasMoraCC - rsdatos.DEdiasMoratorio>

					<!--- TRAE LA CUENTA CONTABLE DEL CONCEPTO --->
					<cfquery name="rsCuentaConcepto" datasource="#session.DSN#">
						select b.Dcodigo, b.Ccuenta,c.Cdescripcion, a.Cformato, a.cuentac
						from Conceptos a
						  inner join CuentasConceptos b
						  	 on a.Cid = b.Cid	 
							and a.Ecodigo = b.Ecodigo
						  inner join CContables c
						   	  on b.Ccuenta = c.Ccuenta 
						     and b.Ecodigo = c.Ecodigo
						where a.Ecodigo =  #session.Ecodigo# 
						  and a.Cid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">
					</cfquery>
					<cfset CuentaContableC = 0>
					<cfif isdefined('rsCuentaConcepto') and rsCuentaConcepto.RecordCount GT 0>
						<cfif isdefined('rsCuentaConcepto.Cformato') and LEN(rsCuentaConcepto.Cformato) GT 0>
							<cfset cuentaConcepto = AplicarMascara(rsCuentaConcepto.Cformato,rsdatos.cuentac)>
							<cfinvoke component="sif.Componentes.PC_GeneraCuentaFinanciera" method="fnGeneraCuentaFinanciera" 
									  returnvariable="LvarError">
								<cfinvokeargument name="Lprm_Cmayor" value="#Left(cuentaConcepto,4)#"/>							
								<cfinvokeargument name="Lprm_Cdetalle" value="#mid(cuentaConcepto,6,100)#"/>
								<cfinvokeargument name="Lprm_TransaccionActiva" value="true"/>
								</cfinvoke>
							<cfif LvarError neq 'NEW' and LvarError neq 'OLD'>
								<cftransaction action="rollback"/>
								<cf_errorCode	code = "50189" msg = "La Cuenta Financiera no existe o el Socio no tiene Cuenta Complemento. Verifique.">
							<cfelse>
								<cfquery name="rsCuentaC" datasource="#session.DSN#">
									select coalesce(Ccuenta, -1) as Ccuenta
									from CFinanciera 
									where Ecodigo =  #session.Ecodigo# 
									  and CFformato = <cfqueryparam  cfsqltype="cf_sql_varchar"value="#cuentaConcepto#">
								</cfquery>
								<cfif isdefined('rsCuentaC') and rsCuentaC.RecordCount GT 0>
									<cfset CuentaContableC = rsCuentaC.Ccuenta>
								</cfif>
							</cfif>
						<cfelse>
							<cfset CuentaContableC = rsCuentaConcepto.Ccuenta>
						</cfif>
					<cfelse>
						<cfif CuentaContableC EQ 0> 
							<cftransaction action="rollback"/>
							<cf_errorCode	code = "50190" msg = "No hay Cuentas Contables asignadas al Concepto. Proceso cancelado.">
						</cfif>	
					</cfif>

				<!--- TRAE EL TIPO DE CAMBIO --->
				<cfquery name="rsMonLocal" datasource="#session.DSN#">
					select Mcodigo
					from Empresas
					where Ecodigo =  #session.Ecodigo# 
				</cfquery>
				<cfif isdefined('rsMonLocal') and rsMonLocal.Mcodigo EQ rsdatos.Mcodigo>
					<cfset TipoCambio = 1.00>
				<cfelse>
					<cfquery name="rsTipoCambio" datasource="#session.DSN#">
						select TCventa as TCventa
						from Htipocambio
						where Ecodigo =  #session.Ecodigo# 
						  and Hfecha  <=  <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Form.Corte#">
						  and Mcodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsdatos.Mcodigo#">
						order by Hfecha desc
					</cfquery>
					<cfif rsTipocambio.RecordCount GT 0>
						<cfset TipoCambio = rsTipoCambio.TCventa>				
					<cfelse>
						<cfset TipoCambio = 1.00>				
					</cfif>
					
				</cfif>
				
				<!--- TRAE LA CUENTA CONTABLE DEL SOCIO POR TRANSACCION --->
				<cfquery name="rsCuentasSocios" datasource="#Session.DSN#">
					select b.CCTcodigo, b.CCTdescripcion, c.Ccuenta, c.Cdescripcion, c.Cformato
					from SNCCTcuentas a
					  inner join CCTransacciones b
					      on a.CCTcodigo = b.CCTcodigo
					     and a.Ecodigo   = b.Ecodigo
					  inner join CContables c
					      on a.CFcuenta = c.Ccuenta
					     and a.Ecodigo  = c.Ecodigo
					Where a.Ecodigo  =  #session.Ecodigo# 
					  and a.SNcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.SNcodigo#">
					  and a.CCTcodigo = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CCTcodigoD#">
				</cfquery>	

				<cfif LEN(rsCuentasSocios.Ccuenta) EQ 0 and LEN(rsDatos.SNcuentacxc) EQ 0> 
					<cftransaction action="rollback"/>
					<cf_errorCode	code = "50191"
									msg  = "No hay Cuentas Contables asignadas al Cliente @errorDat_1@. Proceso cancelado."
									errorDat_1="#rsDatos.SNnombre#"
					>
				</cfif>	
				<cfset Lvar_Impuesto = 0.00>
				<!--- HACE EL CALCULO DEL MONTO DEL INTERES MORATORIO --->
				<cfif isdefined('form.DiasVenc') and form.DiasVenc EQ 0>
				<!--- SI LOS DIAS ES CERO --->
				<!--- Impuesto = Saldo de la transaccion * % Tasa interés * %Impuesto --->
				<!--- Morosidad = (Saldo de la transaccion * % Tasa interés) + Impuesto --->
					<!--- SE HACE UN CICLO PARA EL CALCULO DE LOS IMPUESTOS --->
					<cfloop query="rsImpuesto">
						<cfset Lvar_Impuesto =  Lvar_Impuesto + (round((Lvar_Saldo * (form.Tasa/100) * (rsImpuesto.Porcentaje/100))*100)/100)>
					</cfloop>
					<cfset Lvar_Morosidad = (Lvar_Saldo * (form.Tasa/100))>
					<cfset Lvar_MorosidadImp = (Lvar_Saldo * (form.Tasa/100)) + Lvar_Impuesto>
				<cfelse>
				<!--- SI LOS DIAS ES MAYOR A CERO --->
				<!--- Impuesto = Saldo de la transaccion * (% Tasa interés/30) * Dias * %Impuesto --->
				<!--- Morosidad = (Saldo de la transaccion * (% Tasa interés/30) * Dias) + Impuesto --->
					<!--- SE HACE UN CICLO PARA EL CALCULO DE LOS IMPUESTOS --->
					<cfloop query="rsImpuesto">
					<cfset Lvar_Impuesto =  Lvar_Impuesto + (round((Lvar_Saldo * ((form.Tasa/100)/30) * form.DiasVenc * (rsImpuesto.Porcentaje/100))*100)/100)>
					</cfloop>
					<cfset Lvar_Morosidad = (Lvar_Saldo * ((form.Tasa/100)/30) * form.DiasVenc)>
					<cfset Lvar_MorosidadImp = (Lvar_Saldo * ((form.Tasa/100)/30) * form.DiasVenc)+ Lvar_Impuesto>
				</cfif>

				<cfif Lvar_Morosidad GTE 0 >
					<cftransaction >
					<!--- ENCABEZADO DEL DOCUMENTO DE INTERES MORATORIO  --->
					<cfquery name="InsertaDoc" datasource="#session.DSN#">
						insert into EDocumentosCxC
						(Ecodigo, 
						 CCTcodigo, 
						 EDdocumento, 
						 SNcodigo, 
						 Mcodigo, 
						 EDtipocambio, 
						 EDtotal, 
						 EDdescuento,
						 EDporcdesc,
						 EDimpuesto,
						 Ocodigo, 
						 Ccuenta, 
						 EDfecha, 
						 EDusuario, 
						 EDvencimiento, 
						 DEidVendedor, 
						 DEidCobrador, 
						 DEdiasVencimiento, 
						 DEobservacion, 
						 id_direccionFact, 
						 id_direccionEnvio, 
						 BMUsucodigo) 
						values ( 
							 #session.Ecodigo# ,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.CCTcodigoD#">, 
							<cfqueryparam cfsqltype="cf_sql_char" value="#Form.DocIntMora#-#CountVar#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#Lvar_Socio#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Moneda#">,
							<cfqueryparam cfsqltype="cf_sql_float" value="#TipoCambio#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_MorosidadImp#">,
							0.00,
							0.00,
							0.00,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#rsdatos.Ocodigo#">,
							<cfif isdefined('rsCuentaDir') and LEN(TRIM(rsCuentaDir.SNDCFcuentaCliente))> <!--- CUENTA DE LA DIRECCION --->
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaDir.SNDCFcuentaCliente#">,
							<cfelseif isdefined('rsCuentasSocios') and rsCuentasSocios.RecordCount GT 0><!--- CUENTA DE LA TRANSACCION --->
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentasSocios.Ccuenta#">,
							<cfelse>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.SNcuentacxc#">, <!--- CUENTA DEL SOCIO --->
							</cfif>
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Session.usuario#">,
							<cfqueryparam cfsqltype="cf_sql_date" value="#Now()#">,
							<cfif isdefined('rsdatos.DEidvendedor') and LEN(rsdatos.DEidvendedor) GT 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.DEidvendedor#">,
							<cfelse>
								null,
							</cfif>
							<cfif isdefined('rsdatos.DEidvendedor') and LEN(rsdatos.DEidcobrador) GT 0>
								<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsdatos.DEidcobrador#">,
							<cfelse>
								null,
							</cfif>
							0,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="Factura de Interés Moratorio - #rsdatos.SNnombre#     Documento #rsdatos.CCTcodigo# - #rsdatos.Ddocumento#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Direccion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#Lvar_Direccion#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
						<cf_dbidentity1 datasource="#session.DSN#">
					</cfquery>
					<cf_dbidentity2 datasource="#session.DSN#" name="InsertaDoc">
					<cfset IDDoc = InsertaDoc.identity>
					<!--- DETALLE DEL DOCUMENTO DE INTERES MORATORIO --->
					<cfquery name="insertD" datasource="#Session.DSN#" >
						insert into DDocumentosCxC
							(	EDid,
								Cid,
								Ccuenta, 
								Ecodigo, 
								DDdescripcion, 
								DDdescalterna,
								DDcantidad, 
								DDpreciou, 
								DDtotallinea, 
								DDdesclinea,
								DDporcdesclin,
								DDtipo, 
								Icodigo,
								DocrefIM,
								CCTcodigoIM,
								cantdiasmora,
								BMUsucodigo)
							values (
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#IDDoc#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Cid#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#CuentaContableC#">,
							 #session.Ecodigo# ,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#Descripcion#">,
							<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsConceptoDesc.Cdescripcion#">,
							1,
							<cfqueryparam cfsqltype="cf_sql_money" value="#round(Lvar_Morosidad*100)/100#">,
							<cfqueryparam cfsqltype="cf_sql_money" value="#round(Lvar_Morosidad*100)/100#">,
							0.00,
							0.00,
							<cfqueryparam cfsqltype="cf_sql_char" value="S">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#form.Icodigo#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_Ddocumento#">,
							<cfqueryparam cfsqltype="cf_sql_char" value="#Lvar_CCTcodigo#">,
							<cfqueryparam cfsqltype="cf_sql_integer" value="#DiasCalculadosIM#">,
							<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
						) 
					</cfquery>
					<!--- CALCULO DEL IMPUESTO --->
					<!--- ****************************************************************************************** --->
					<cf_dbtemp name="TT_Impuestos" returnvariable="TT_Impuestos" datasource="#session.dsn#">
					  <cf_dbtempcol name="Icodigo" type="char(5)"> 
					  <cf_dbtempcol name="DDtotallinea" type="money">
					  <cf_dbtempcol name="Porcentaje" type="float"> 
					   <cf_dbtempcol name="DDlinea" type="numeric"> 
					   <cf_dbtempcol name="Impuesto" type="money"> 
					</cf_dbtemp>
			
					<cfquery name="rsImpuestos" datasource="#session.DSN#">
						insert into #TT_Impuestos#(Icodigo, DDtotallinea,Porcentaje,DDlinea,Impuesto)
						select d.DIcodigo, round(b.DDtotallinea,2), d.DIporcentaje,b.DDlinea,b.DDtotallinea*d.DIporcentaje/100.00
						from EDocumentosCxC a 
							inner join DDocumentosCxC b
								  on b.EDid    = a.EDid
								 and b.Ecodigo = a.Ecodigo
							inner join Impuestos c
								  on c.Ecodigo = b.Ecodigo
								 and c.Icodigo = b.Icodigo 
							inner join DImpuestos d
								on d.Ecodigo = c.Ecodigo 
							   and d.Icodigo = c.Icodigo
						where a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDDoc#">
						  and  c.Icompuesto = 1
					</cfquery>
					
					<cfquery name="rsTotalImpuesto" datasource="#session.DSN#">
						insert into #TT_Impuestos#(Icodigo, DDtotallinea,Porcentaje,DDlinea,Impuesto)
						select c.Icodigo, round(b.DDtotallinea,2), c.Iporcentaje, DDlinea, b.DDtotallinea*c.Iporcentaje/100.00
						from EDocumentosCxC a 
							inner join DDocumentosCxC b
								  on b.Ecodigo = a.Ecodigo
								 and b.EDid    = a.EDid 
							inner join Impuestos c
								  on c.Ecodigo = b.Ecodigo
								 and c.Icodigo = b.Icodigo
						where a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDDoc#">
						  and c.Icompuesto = 0
					</cfquery>
					<cfquery name="rsConsulta" datasource="#session.DSN#">
						select *
						from #TT_Impuestos#
					</cfquery>
					<cfquery name="rsTotalImpuestos" datasource="#session.DSN#">
						select round(sum(DDtotallinea) * Porcentaje / 100.00,2) as TotalImpuestos
						from #TT_Impuestos#
						group by Icodigo, Porcentaje
					</cfquery>
					<cfquery name="rsTotalI" dbtype="query">
						select sum(TotalImpuestos)	 as TotalImpuestos
						from rsTotalImpuestos
					</cfquery>
					
					<cfif rsTotalI.RecordCount GT 0>
						<cfset TotalImpuestos = rsTotalI.TotalImpuestos>
					<cfelse>
						<cfset TotalImpuestos = 0.00>
					</cfif>
					<cfquery name="rsTotal" datasource="#session.DSN#">
						select coalesce(sum(a.DDtotallinea),0.00) as Total
						from DDocumentosCxC a 
							inner join EDocumentosCxC b
							   on b.EDid    = a.EDid
							  and b.Ecodigo = a.Ecodigo
						where a.EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDDoc#">
					</cfquery>

					<!--- ACTUALIZA EL ENCABEZADO DEL DOCUMENTO CON LOS TOTALES --->
					<cfquery name="rsUpdateE" datasource="#session.DSN#">
						update EDocumentosCxC 
						set EDimpuesto = #TotalImpuestos#
							,EDtotal    = #rsTotal.Total#
										+ #TotalImpuestos#
					   where EDid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#IDDoc#">
						 and Ecodigo =  #session.Ecodigo# 
					</cfquery>  
					<!--- ****************************************************************************************** --->
						
					</cftransaction>
				</cfif>
			</cfloop> 
		</cfif>
	</cfif>
	<cfset action = 'FinRegistroInteresMoratorioCxC.cfm'>
</cfif>

<cfoutput>

<form action="#action#" method="post" name="sql">
		<cfif not isdefined('Form.Aplicar')>
			<cfif isdefined("Form.Agregar")>
				<input name="Agregar" type="hidden" value="#Form.Agregar#">   
			</cfif>
			<cfif isdefined("Form.Filtrar")>
				<input name="Filtrar" type="hidden" value="#Form.Filtrar#">   
			</cfif> 	
			<cfif isdefined("Form.SNcodigo") and LEN(Form.SNcodigo) GT 0>
				<input name="SNcodigo" type="hidden" value="#Form.SNcodigo#">
			</cfif>
			<cfif isdefined("Form.SNcodigo2") and LEN(Form.SNcodigo2) GT 0>
				<input name="SNcodigo2" type="hidden" value="#Form.SNcodigo2#">
			</cfif>		
			<cfif isdefined("Form.SNnumero") and LEN(Form.SNnumero) GT 0>
				<input name="SNnumero" type="hidden" value="#Form.SNnumero#">
			</cfif>
			<cfif isdefined("Form.SNnumero2") and LEN(Form.SNnumero2) GT 0>
				<input name="SNnumero2" type="hidden" value="#Form.SNnumero2#">
			</cfif>		

			<cfif isdefined("Form.CCTcodigoE") and LEN(Form.CCTcodigoE) GT 0>
				<input name="CCTcodigoE" type="hidden" value="#Form.CCTcodigoE#">
			</cfif>
			<cfif isdefined("Form.CCTcodigo") and LEN(Form.CCTcodigo) GT 0>
				<input name="CCTcodigo" type="hidden" value="#Form.CCTcodigo#">
			</cfif>
			<cfif isdefined("Form.Documento") and LEN(Form.Documento) GT 0>
				<input name="Documento" type="hidden" value="#Form.Documento#">
			</cfif>
			<cfif isdefined("Form.DocIntMora") and LEN(Form.DocIntMora) GT 0>
				<input name="DocIntMora" type="hidden" value="#Form.DocIntMora#">
			</cfif>		
			<cfif isdefined("Form.Corte") and LEN(Form.Corte) GT 0>
				<input name="Corte" type="hidden" value="#Form.Corte#">
			</cfif>	
			<cfif isdefined("Form.Tasa") and LEN(Form.Tasa) GT 0>
				<input name="Tasa" type="hidden" value="#Form.Tasa#">
			</cfif>	
			<cfif isdefined("Form.Cid") and LEN(Form.Cid) GT 0>
				<input name="Cid" type="hidden" value="#Form.Cid#">
			</cfif>
			<cfif isdefined("form.SNCEid") and form.SNCEid GT 0>
				<input name="SNCEid" type="hidden" value="#form.SNCEid#">
			</cfif>
			<cfif isdefined('form.DiasVenc') and LEN(TRIM(form.DiasVenc)) GT 0>
				<input name="DiasVenc" type="hidden" value="#form.DiasVenc#">
			</cfif>
			<cfif isdefined('form.SNCDid1') and form.SNCDid1 GT 0>
				<input name="SNCDid1" type="hidden" value="#form.SNCDid1#">
			</cfif>
			<cfif isdefined('form.SNCDid2') and form.SNCDid2 GT 0>
				<input name="SNCDid2" type="hidden" value="#form.SNCDid2#">
			</cfif>
			<cfif isdefined('form.SNCDvalor1') and form.SNCDvalor1 GT 0>
				<input name="SNCDvalor1" type="hidden" value="#form.SNCDvalor1#">
			</cfif>
			<cfif isdefined('form.SNCDvalor2') and form.SNCDvalor2 GT 0>
				<input name="SNCDvalor2" type="hidden" value="#form.SNCDvalor2#">
			</cfif>

			<cfif isdefined('form.chk_AgrupaxCliente')>
				<input name="chk_AgrupaxCliente" type="hidden" value="#form.chk_AgrupaxCliente#">
			</cfif>
		<cfelse>
			<input name="Aplicados" type="hidden" value="Aplicados">
		</cfif>
		
</form>
	</cfoutput>

<HTML><head></head><body><script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script></body></HTML>

