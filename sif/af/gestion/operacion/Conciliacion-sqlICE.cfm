<!---
	Sistema Financiero Integral
	Gestión de Activos Fijos
	Conciliacion de Activos Fijos
	Fecha de Creación: Ene/2006
	Desarrollado por: Dorian Abarca Gómez

	Aplicar Grupo de Transaccioes
	Que Cumpla Con: Empresa, Periodo, Mes, Concepto, Doc. Generando:
		1. Adquisición cuando la placa no exista
		2. Mejora cuando la placa exista
		3. Retiro cuando la placa exista y el monto sea negativo.
--->

<cfsetting requesttimeout="3600">
<cfset Request.Debug = False>
<cfset params="?sql=1">
<cfinclude template="ErroresConciliacion-ver.cfm">

<!---CONTINÚA CON EL PROCESO INCOMPLETO DE CONCILIACIÓN--->
<cfif isdefined("url.btnContinuar")>
	<cfif fnProcesoIncompleto(session.dsn, session.ecodigo)>
		<p align="left">Concluyendo el proceso de Conciliacion Anterior que no termino .... Por favor espere
		<cfflush interval="20">

		<cfquery name="rsCicloAdquisiciones" datasource="#session.dsn#">
			Select 	ea.IDcontable,
					ea.EAcpidtrans, 	
					ea.EAcpdoc, 	
					ea.EAcplinea,
					((
						select min(DSplaca)
						from DSActivosAdq ds
						where ds.Ecodigo     = ea.Ecodigo
						  and ds.EAcpidtrans = ea.EAcpidtrans
						  and ds.EAcpdoc     = ea.EAcpdoc
						  and ds.EAcplinea   = ea.EAcplinea 
					)) 
					as GATplaca
			from EAadquisicion ea
			where ea.Ecodigo  = #session.Ecodigo#
			  and ea.EAstatus = -1				
			order by EAcpdoc, EAcplinea
		</cfquery>

		<cfset LvarResOk = fnProcesaAdquisiciones(true)>
		<script language="javascript" type="text/javascript">
			alert("Proceso terminado con Éxito");
			document.location.href="Conciliacion.cfm";
		</script>
	<cfelse>
		<table align="center" border="0">
			<tr><td align="center"><font color="navy"><strong>No existen transacciones incompletas!!</strong></font></td></tr>
			<tr><td align="center"><input type="button" name="btncerrar" value="Regresar" onClick="javascript:document.location.href='Conciliacion.cfm'"></td></tr>
		</table>
		<cfabort>
	</cfif> 
</cfif>

<!---PROCESO DE APLICAR CONCIALICIÓN--->
<cfif isdefined("form.btnAplicar")>
	<cfif fnProcesoIncompleto(session.dsn, session.ecodigo)>
		<table align="center" border="0">
		  <tr>
			<td align="center"><font color="navy"><strong>La Aplicación de conciliación quedo inconclusa, favor aplique el proceso de continuar!!</strong></font></td>
		  </tr>
		  <tr><td align="center"><input type="button" name="btncerrar" value="Regresar" onClick="javascript:document.location.href='Conciliacion.cfm'"></td></tr>
		</table>
		<cfabort>
	</cfif>
	<!--- Construye form.chk cuando no viene. Esto sucede cuando viene de la pantalla de operacion y no de la lista --->
	<cfif not isdefined("form.chk")      and isdefined("form.btnAplicar") 
		and isdefined("form.GATPeriodo") and len(trim(form.GATPeriodo)) 
		and isdefined("form.GATmes") 	 and len(trim(form.GATmes)) 
		and isdefined("form.Cconcepto")  and len(trim(form.Cconcepto))
		and isdefined("form.Edocumento") and len(trim(form.Edocumento))>
		<cfset arr_chk = ArrayNew(1)>
		<cfset ArrayAppend(arr_chk, form.GATPeriodo)>
		<cfset ArrayAppend(arr_chk, form.GATmes)>
		<cfset ArrayAppend(arr_chk, form.Cconcepto)>
		<cfset ArrayAppend(arr_chk, form.Edocumento)>
		<cfset form.chk = ArrayToList(arr_chk,'|')>
	</cfif>
	
	<cfset HayAjustes = false>

	<cfif not isdefined("form.NoRev")>
		<!--- Revision inicial de asientos de ajuste --->		
		<cfloop list="#form.chk#" index="llave">
			<cfscript>
				arr_llave = ListToArray(llave,'|');
				item = StructNew();
				StructInsert(item, "Periodo", arr_llave[1]);
				StructInsert(item, "Mes", arr_llave[2]);
				StructInsert(item, "Concepto", arr_llave[3]);
				StructInsert(item, "Documento", arr_llave[4]);
			</cfscript>	
			
		<cfif fnDocumentoNoConciliado(session.dsn, session.ecodigo, item.Periodo, item.Mes, item.Concepto, item.Documento)>
			<table align="center" border="0">
				<tr>
					<td align="center"><font color="navy"><strong>El documento <cfoutput> #item.Concepto#-#item.Documento# </cfoutput>no se encuentra conciliado.
					</strong></font></td>
				</tr>
				<tr>
					<td align="center"><font color="navy"><strong>Es necesario conciliar el documento para realizar las funciones</strong></font></td></tr>
				<tr>
					<td align="center"><input type="button" name="btncerrar" value="Regresar" onClick="javascript:document.location.href='Conciliacion.cfm'"></td>
				</tr>
		  </table>
			<cfabort>
		</cfif>
			<!--- VERIFICA SI ES NECESARIO HACER ASIENTOS DE AJUSTE --->
			<cfset Ajuste = fnVerificaAsientoAjuste(session.dsn, session.ecodigo, item.Periodo, item.Mes, item.Concepto, item.Documento)>
			<cfif Ajuste>
				<cfset HayAjustes = true>
			</cfif>	
		</cfloop>
	</cfif>

	<cfif HayAjustes>
		<!--- Se le pregunta al usuario si desea generar el asiento de ajuste --->
		<cfset paramURL = "?VerPopUp=1&BOTONSEL=" & form.BOTONSEL>
		<cfset paramURL = paramURL & "&BTNAPLICAR=" & form.BTNAPLICAR>
		<cfset paramURL = paramURL & "&CCONCEPTO=" & form.CCONCEPTO>
		<cfset paramURL = paramURL & "&CHK=" & form.CHK>
		<cfset paramURL = paramURL & "&EDOCUMENTO=" & form.EDOCUMENTO>
		<cfset paramURL = paramURL & "&FIELDNAMES=" & form.FIELDNAMES>
		<cfset paramURL = paramURL & "&GATMES=" & form.GATMES>
		<cfset paramURL = paramURL & "&GATPERIODO=" & form.GATPERIODO>

		<cfif isdefined("form.CDESCRIPCION")>
			<cfset paramURL = paramURL & "&CDESCRIPCION=" & form.CDESCRIPCION>
		</cfif>
		<cfif isdefined("form.ECODIGO")>
			<cfset paramURL = paramURL & "&ECODIGO=" & form.ECODIGO>
		</cfif>
		<cfif isdefined("form.ESTADO")>
			<cfset paramURL = paramURL & "&ESTADO=" & form.ESTADO>
		</cfif>
		<cfif isdefined("form.FILTRO_CDESCRIPCION")>
			<cfset paramURL = paramURL & "&FILTRO_CDESCRIPCION=" & form.FILTRO_CDESCRIPCION>
		</cfif>
		<cfif isdefined("form.FILTRO_EDOCUMENTO")>
			<cfset paramURL = paramURL & "&FILTRO_EDOCUMENTO=" & form.FILTRO_EDOCUMENTO>			
		</cfif>
		<cfif isdefined("form.FILTRO_ESTADO")>
			<cfset paramURL = paramURL & "&FILTRO_ESTADO=" & form.FILTRO_ESTADO>
		</cfif>
		<cfif isdefined("form.FILTRO_GATPERIODO")>
			<cfset paramURL = paramURL & "&FILTRO_GATPERIODO=" & form.FILTRO_GATPERIODO>
		</cfif>
		<cfif isdefined("form.FILTRO_MES")>			
			<cfset paramURL = paramURL & "&FILTRO_MES=" & form.FILTRO_MES>
		</cfif>
		<cfif isdefined("form.HFILTRO_CDESCRIPCION")>			
			<cfset paramURL = paramURL & "&HFILTRO_CDESCRIPCION=" & form.HFILTRO_CDESCRIPCION>
		</cfif>
		<cfif isdefined("form.HFILTRO_EDOCUMENTO")>			
			<cfset paramURL = paramURL & "&HFILTRO_EDOCUMENTO=" & form.HFILTRO_EDOCUMENTO>
		</cfif>
		<cfif isdefined("form.HFILTRO_ESTADO")>			
			<cfset paramURL = paramURL & "&HFILTRO_ESTADO=" & form.HFILTRO_ESTADO>
		</cfif>
		<cfif isdefined("form.HFILTRO_GATPERIODO")>			
			<cfset paramURL = paramURL & "&HFILTRO_GATPERIODO=" & form.HFILTRO_GATPERIODO>
		</cfif>
		<cfif isdefined("form.HFILTRO_MES")>
			<cfset paramURL = paramURL & "&HFILTRO_MES=" & form.HFILTRO_MES>
		</cfif>
		<cfif isdefined("form.IMG")>
			<cfset paramURL = paramURL & "&IMG=" & form.IMG>
		</cfif>
		<cfif isdefined("form.INACTIVECOL")>
			<cfset paramURL = paramURL & "&INACTIVECOL=" & form.INACTIVECOL>
		</cfif>
		<cfif isdefined("form.MES")>
			<cfset paramURL = paramURL & "&MES=" & form.MES>
		</cfif>
		<cfif isdefined("form.MODO")>
			<cfset paramURL = paramURL & "&MODO=" & form.MODO>
		</cfif>
		<cfif isdefined("form.PAGENUM")>
			<cfset paramURL = paramURL & "&PAGENUM=" & form.PAGENUM>
		</cfif>
		<cfif isdefined("form.STARTROW")>
			<cfset paramURL = paramURL & "&STARTROW=" & form.STARTROW>
		</cfif>

		<cflocation url="Conciliacion.cfm#paramURL#">
		<cfabort>
	</cfif>

	<cfset fnAplicarConciliacion()>
	<script language="javascript" type="text/javascript">
		alert("Proceso terminado con Éxito");
		document.location.href="Conciliacion.cfm";
	</script>
     
<cfelseif isdefined("form.btnConciliar")>
	<!---Conciliar Grupo de Transaccioes que Cumpla Con: Empresa, Periodo, Mes, Concepto, Doc. --->

	<!---Valida que no hayan registros del documento por conciliar que tengan estado menor a 1 (Completo)--->
	<cfquery name="rsValida1" datasource="#session.dsn#">
		select count(1) as Cantidad
		from GATransacciones a
		where a.Ecodigo = #Session.Ecodigo#
		and   a.GATperiodo = #Form.GATperiodo#
		and   a.GATmes = #Form.GATmes#
		and   a.Cconcepto = #Form.Cconcepto#
		and   a.Edocumento = #Form.Edocumento#
		and   a.GATestado < 1
	</cfquery>
	<cfif rsValida1.Cantidad GT 0>
		<cf_errorCode	code = "50059" msg = "La Transacción se encuentra sin Completar, todas las cuentas de la Transacción deben encontrarse Completas para conciliar la Transacción, Proceso Cancelado!">
	</cfif>
	<!---
			Valida que todas las cuentas de las transacciones estén en la tabla de
			Cuentas de Mayor de Gestion documento por conciliar que tengan
	--->
	<cfquery name="rsValida2A" datasource="#session.dsn#">
		select count(1) as Cantidad
		from GATransacciones a
		where a.Ecodigo     = #Session.Ecodigo#
		and   a.GATperiodo  = #Form.GATperiodo#
		and   a.GATmes      = #Form.GATmes#
		and   a.Cconcepto   = #Form.Cconcepto#
		and   a.Edocumento  = #Form.Edocumento#
	</cfquery>
	
	<cfquery name="rsValida2B" datasource="#session.dsn#">
		select count(1) as Cantidad
		from GATransacciones a
			inner join CFinanciera b
				inner join GACMayor c
					on c.Ecodigo = b.Ecodigo
					and c.Cmayor = b.Cmayor
			on b.CFcuenta=a.CFcuenta				
		where a.Ecodigo    = #Session.Ecodigo#
		and   a.GATperiodo = #Form.GATperiodo#
		and   a.GATmes     = #Form.GATmes#
		and   a.Cconcepto  = #Form.Cconcepto#
		and   a.Edocumento = #Form.Edocumento#
		and   b.CFformato like c.Cmascara
	</cfquery>
	<cfif rsValida2A.Cantidad neq rsValida2B.Cantidad>
		<cf_errorCode	code = "50060" msg = "Existen cuentas en las transacciones que no son válidas para el proceso de Conciliación. Valide las cuentas con el catálogo de cuentas de mayor de gestión. Proceso Cancelado!">
	</cfif>
	
	<!---
		Valida que todas las cuentas del Asiento que esten en la tabla de Cuentas de Mayor de Gestion estén en el conjunto de Transacciones
		Se incluye condición para que solamente se cuenten las cuentas que tienen saldo + o - y no tome en cuenta lo que da cero porque estas son cuentas que se auto-anulan a nivel de asiento.
	--->

	<cfquery name="rsValida3A" datasource="#session.dsn#">
		select a.Ccuenta, sum(a.Dlocal * (case a.Dmovimiento when 'D' then 1.00 else -1.00 end)) as Monto, count(1) as Cantidad
		from HDContables a
			inner join CFinanciera b
				inner join GACMayor c
					on  c.Ecodigo = b.Ecodigo
					and c.Cmayor =  b.Cmayor
			on b.CFcuenta = a.CFcuenta
		where a.Ecodigo     = #Session.Ecodigo#
		and   a.Eperiodo    = #Form.GATperiodo#
		and   a.Emes        = #Form.GATmes#
		and   a.Cconcepto   = #Form.Cconcepto#
		and   a.Edocumento  = #Form.Edocumento#
		and   b.CFformato like c.Cmascara
		group by a.Ccuenta
		having sum(a.Dlocal * (case a.Dmovimiento when 'D' then 1.00 else -1.00 end)) <> 0.00
	</cfquery>

	<cfquery name="rsValida3B" datasource="#session.dsn#">
		select count(distinct b.Ccuenta) as Cantidad
		from GATransacciones a
			inner join CFinanciera b
				on  b.Ecodigo  = a.Ecodigo
				and b.CFcuenta = a.CFcuenta				
		where a.Ecodigo    = #Session.Ecodigo#
		and   a.GATperiodo = #Form.GATperiodo#
		and   a.GATmes     = #Form.GATmes#
		and   a.Cconcepto  = #Form.Cconcepto#
		and   a.Edocumento = #Form.Edocumento#
	</cfquery>

	<cfif rsValida3A.Recordcount neq rsValida3B.Cantidad>
		<cf_errorCode	code = "50061" msg = "Existen cuentas en el asiento contable que deberían estar en las transacciones. Valide las cuentas con el catálogo de cuentas de mayor de gestión. Proceso Cancelado!">
	</cfif>

	<!--- Inicia Proceso de Conciliacion.  no requiere transacción  --->
	<cf_dbtemp name="ConAFsql_v2" returnvariable="CONCILIAR" datasource="#session.dsn#">
		<cf_dbtempcol name="IDcontable" 	type="numeric"	      mandatory="yes">
		<cf_dbtempcol name="Ecodigo"  		type="integer"        mandatory="yes">
		<cf_dbtempcol name="GATperiodo"  	type="integer"        mandatory="yes">
		<cf_dbtempcol name="GATmes"  		type="integer"        mandatory="yes">
		<cf_dbtempcol name="Cconcepto"  	type="integer"        mandatory="yes">
		<cf_dbtempcol name="Ocodigo"  		type="integer"        mandatory="yes">
		<cf_dbtempcol name="Edocumento"  	type="integer"        mandatory="yes">
		<cf_dbtempcol name="CFcuenta"  		type="numeric"        mandatory="yes">
		<cf_dbtempcol name="MontoGestion"  	type="money"  	      mandatory="yes">
		<cf_dbtempcol name="MontoAsiento"  	type="money"  	      mandatory="yes">
		<cf_dbtempcol name="Conciliado"  	type="numeric"        mandatory="yes">
		<cf_dbtempkey cols="IDcontable,Ocodigo,CFcuenta">
	</cf_dbtemp>

	<cfquery name="rsHDContables" datasource="#Session.Dsn#">
		insert into #CONCILIAR# (
				IDcontable,
				Ecodigo,
				GATperiodo,
				GATmes,
				Cconcepto,
				Ocodigo,
				Edocumento,
				CFcuenta,
				MontoGestion,
				MontoAsiento,
				Conciliado)
		select 	a.IDcontable,
				a.Ecodigo,
				a.GATperiodo,
				a.GATmes,
				a.Cconcepto,
				a.Ocodigo,
				a.Edocumento,
				a.CFcuenta,
				coalesce(sum(a.GATmonto),0.00) as MontoGestion, 
				000000000.0000 as MontoAsiento,
				0 as Conciliado
		from GATransacciones a
			inner join CFinanciera c
			on c.CFcuenta = a.CFcuenta

			inner join Oficinas d
			on d.Ecodigo = a.Ecodigo
			and d.Ocodigo = a.Ocodigo

		where a.Ecodigo   = #Session.Ecodigo#
		and a.GATperiodo  = #Form.GATperiodo#
		and a.GATmes      = #Form.GATmes#
		and a.Cconcepto   = #Form.Cconcepto#
		and a.Edocumento  = #Form.Edocumento#

		group by a.IDcontable,
				a.Ecodigo,
				a.GATperiodo,
				a.GATmes,
				a.Cconcepto,
				a.Ocodigo,
				a.Edocumento,
				a.CFcuenta			
	</cfquery>	

	<cfquery datasource="#Session.Dsn#">
		update #CONCILIAR#
			set MontoAsiento = coalesce(( 
				select sum(b.Dlocal * (case b.Dmovimiento when 'D' then 1 else -1 end) )
				from HDContables b
				where  b.IDcontable = #CONCILIAR#.IDcontable
				and    b.Ocodigo = #CONCILIAR#.Ocodigo
				and    b.CFcuenta = #CONCILIAR#.CFcuenta
			), 0.00)
	</cfquery>
	<cfquery datasource="#Session.Dsn#">
		update #CONCILIAR#
		set Conciliado = 1
		where MontoAsiento = MontoGestion
	</cfquery>	
	
	<cfquery name="rsVerConciliados" datasource="#Session.Dsn#">		
		select count(1) as total 
		from #CONCILIAR#
		where Conciliado = 0
	</cfquery>

	<cfif rsVerConciliados.total eq 0>
		<cfquery name="rsVerConciliados" datasource="#Session.Dsn#">			
			update GATransacciones
			set GATestado = 2
			where Ecodigo = #Session.Ecodigo#
			and GATperiodo = #Form.GATPeriodo#
			and GATmes = #Form.GATMes#
			and Cconcepto = #Form.Cconcepto#
			and Edocumento = #Form.Edocumento#
		</cfquery>
	</cfif>
	
	<cfquery name="rsConciliado" datasource="#Session.Dsn#">
		select c.CFformato, a.MontoAsiento, a.MontoGestion
		from  #CONCILIAR# a
			inner join CFinanciera c
			on c.CFcuenta = a.CFcuenta
		where a.Conciliado = 0
	</cfquery>

	<!--- Borrar la tabla temporal, porque la conexión queda abierta y por esto no se borran los registros --->
	<cfquery datasource="#Session.DSN#">
		delete from #CONCILIAR#
	</cfquery>

	<cfif rsConciliado.RecordCount GT 0>
		<cfset LvarMensajeConciliacion = "Error, El monto del asiento no es igual al monto gestionado. Proceso Cancelado!">
		<cfloop query="rsConciliado">
			<cfset LvarMensajeConciliacion = LvarMensajeConciliacion & "<BR>" & "Cuenta: " & rsConciliado.CFformato>
			<cfset LvarMensajeConciliacion = LvarMensajeConciliacion & " Asiento: " & numberformat(rsConciliado.MontoAsiento, ",9.00")>
			<cfset LvarMensajeConciliacion = LvarMensajeConciliacion & " Gestion: " & numberformat(rsConciliado.MontoGestion, ",9.00")>
		</cfloop>
		<cfthrow message="#LvarMensajeConciliacion#">
	</cfif>	
	
	<!---*******************************************
	*****Termina Proceso de Conciliacion************
	********************************************--->
	<cfset params=params&"&GATPeriodo=#Form.GATPeriodo#">
	<cfset params=params&"&GATMes=#Form.GATMes#">
	<cfset params=params&"&Cconcepto=#Form.Cconcepto#">
	<cfset params=params&"&EDocumento=#Form.EDocumento#">
</cfif>

<cfif not isdefined("NOLOCATION") or form.NOLOCATION neq "S">
	<cflocation url="Conciliacion.cfm#params#">
<cfelse>
	<script>
		window.opener.location = 'Conciliacion.cfm?sql=1';
		window.close();
	</script>
</cfif>

<cffunction access="private" name="fnAplicarConciliacion" returntype="any">
	<p align="left">Iniciando el proceso de Aplicacion de la Conciliacion       .... Por favor espere</p>
	<cfflush interval="20">

	<p align="left">Obeniendo los datos generales para el proceso de aplicacion .... Por favor espere</p>

	<!---Moneda Local de la empresa--->
	<cfset LvarMonedaEmpresa = ObtieneMonedaEmpresa(session.dsn, session.Ecodigo)>
	<!---Periodo y Mes de Auxiliares--->
	<cfset LvarPeriodoAux    = ObtienePeriodoActual(session.dsn, session.Ecodigo)>
	<cfset LvarMesAux        = ObtienemesActual(session.dsn, session.Ecodigo)>
	
	<!---Obtiene el Parametro que inidica si el retiro se aplica de forma automática --->
	<cfset aplicarret = 1>
	<cfquery name="rsParamRet" datasource="#session.dsn#">
		select Pvalor as RetAuto
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		and Pcodigo = 960
		and Mcodigo = 'AF'
	</cfquery>				
	<cfif rsParamRet.recordcount gt 0>
		<cfset aplicarret = rsParamRet.RetAuto>
	</cfif>				
	
	<p align="left">Generando la tabla temporal para el procesamiento           .... Por favor espere</p>
	<cf_dbtemp name="tmpGAAdq_v2" returnvariable="GAADQUISICIONES" datasource="#session.dsn#">				
		<cf_dbtempcol name="ID"    			type="numeric"        identity="yes">		
		<cf_dbtempcol name="Ecodigo"  		type="integer"        mandatory="yes">
		<cf_dbtempcol name="EAcpidtrans"  	type="varchar(50)"    mandatory="yes">
		<cf_dbtempcol name="EAcpdoc"  		type="varchar(50)"    mandatory="yes">
		<cf_dbtempcol name="EAcplinea"  	type="numeric"        mandatory="yes">
		<cf_dbtempcol name="Ocodigo"  		type="integer"        mandatory="yes">
		<cf_dbtempcol name="Aid"  			type="numeric"        mandatory="no">
		<cf_dbtempcol name="EAPeriodo"  	type="integer"        mandatory="yes">
		<cf_dbtempcol name="EAmes"  		type="integer"        mandatory="yes">
		<cf_dbtempcol name="EAFecha"  		type="datetime"       mandatory="yes">
		<cf_dbtempcol name="Mcodigo"  		type="numeric"        mandatory="yes">
		<cf_dbtempcol name="EAtipocambio"  	type="float"          mandatory="yes">
		<cf_dbtempcol name="Ccuenta"  		type="numeric"        mandatory="yes">
		<cf_dbtempcol name="SNcodigo"  		type="integer"        mandatory="no">
		<cf_dbtempcol name="EAdescripcion"  type="varchar(100)"   mandatory="yes">
		<cf_dbtempcol name="EAcantidad"  	type="float"          mandatory="yes">
		<cf_dbtempcol name="EAtotalori"  	type="money"          mandatory="yes">
		<cf_dbtempcol name="EAtotalloc"  	type="money"          mandatory="yes">
		<cf_dbtempcol name="EAstatus"  		type="integer"        mandatory="yes">
		<cf_dbtempcol name="EAselect"  		type="integer"        mandatory="yes">
		<cf_dbtempcol name="Usucodigo"  	type="numeric"        mandatory="yes">
		<cf_dbtempcol name="BMUsucodigo"  	type="numeric"        mandatory="no">		
		<cf_dbtempcol name="AFMid"  		type="numeric"        mandatory="no">
		<cf_dbtempcol name="AFMMid"  		type="numeric"        mandatory="no">		
		<cf_dbtempcol name="CFid"  			type="numeric"        mandatory="no">
		<cf_dbtempcol name="DEid"  			type="numeric"        mandatory="no">
		<cf_dbtempcol name="AFCcodigo"  	type="integer"        mandatory="no">
		<cf_dbtempcol name="ACcodigo"  		type="integer"        mandatory="no">		
		<cf_dbtempcol name="ACid"  			type="integer"        mandatory="no">
		<cf_dbtempcol name="GATdescripcion" type="varchar(100)"   mandatory="no">
		<cf_dbtempcol name="GATserie"  		type="varchar(50)"    mandatory="no">
		<cf_dbtempcol name="GATplaca"  		type="varchar(20)"    mandatory="no">		
		<cf_dbtempcol name="GATfechainidep"	type="datetime"       mandatory="no">
		<cf_dbtempcol name="GATfechainirev"	type="datetime"       mandatory="no">		
		<cf_dbtempcol name="IDcontable"		type="numeric"        mandatory="yes">						
		<cf_dbtempkey cols="ID, Ecodigo, EAcpidtrans, EAcpdoc, EAcplinea">
	</cf_dbtemp>

	<!--- Procesa C/U de las llaves (Empresa,Periodo, Mes, Concepto, Documento) Contenidas en la varible form.chk
			Ejemplo de valor de form.chk:
				Periodo|Mes|Concepto|Documento,
				Periodo|Mes|Concepto|Documento,etc
	--->
	<cfloop list="#form.chk#" index="llave">
		<cfscript>
			arr_llave = ListToArray(llave,'|');
			item = StructNew();
			StructInsert(item, "Periodo", arr_llave[1]);
			StructInsert(item, "Mes", arr_llave[2]);
			StructInsert(item, "Concepto", arr_llave[3]);
			StructInsert(item, "Documento", arr_llave[4]);
		</cfscript>

		<p align="left">&nbsp;&nbsp;&nbsp;Procesando Asiento <cfoutput>#item.Concepto#-#item.Documento# : #timeformat(now(), "HH:mm:ss.l")#</cfoutput> ....</p>

		<!--- Borra registros de la tabla temporal por si se procesa varias veces el ciclo --->
		<cfquery datasource="#session.dsn#">
			delete from #GAADQUISICIONES#
		</cfquery>

		<!--- 
			Realizar las validaciones del proceso:
				Se utiliza el componente ErroresConciliacion-ver.cfm
					Si no está conciliado, se presenta el error del caso
					Si tiene errores, se muestran estos en la tabla de salida
		--->
		

		<cfset rsERR          = fnVerificaConciliacion( session.dsn, session.ecodigo, item.Periodo, item.Mes, item.Concepto, item.Documento)>
		<cfif rsErr.recordcount GT 0>
				<table border="0" align="center" width="100%">
				<tr>
					<td colspan="2" align="center"><strong>Listado de Errores</strong></td>
				</tr>
				<tr>
					<td colspan="2">
					
						<table border="0" align="center">
						<tr>
							<td><strong>Concepto:&nbsp;&nbsp;</strong></td>
							<td><cfoutput>#item.Concepto#</cfoutput></td>
							<td><strong>Periodo:&nbsp;&nbsp;</strong></td>
							<td><cfoutput>#item.Periodo#</cfoutput></td>
						</tr>			
						<tr>
							<td width="10%"><strong>Documento:&nbsp;&nbsp;</strong></td>
							<td width="90%"><cfoutput>#item.Documento#</cfoutput></td>
							<td><strong>Mes:&nbsp;&nbsp;</strong></td>
							<td><cfoutput>#item.Mes#</cfoutput></td>
						</tr>
						</table>
				
					</td>
				</tr>
				<tr>
					<td colspan="2"><hr></td>
				</tr>
				<tr>
					<td colspan="2">
						<table align="center" width="100%">
							<tr>
								<td bgcolor="silver"><strong>Mensaje de Error</strong></td>
								<td bgcolor="silver"><strong>Valor</strong></td>
							</tr>
							<cfloop query="rsErr">
							<tr>
								<td><cfoutput>#rsErr.MsgError#</cfoutput></td>
								<td><cfoutput>#rsErr.Valor#</cfoutput></td>
							</tr>
							</cfloop>				
						</table>
					</td>
				</tr>	
				<tr>
					<td colspan="2"><hr></td>
				</tr>	
				<tr>
					<td colspan="2" align="center"><input type="button" name="btncerrar" value="Regresar" onClick="javascript:document.location.href= 'Conciliacion.cfm'"> </td>
				</tr>	
				<tr>
					<td colspan="2"><hr></td>
				</tr>	
				</table>
			<cfabort>
		</cfif>
		<!--- 
			Fin de Realizar las validaciones del proceso:
		--->

		<!--- Pone todos los registros de ese concepto-documento en cero--->
		<cfquery datasource="#session.dsn#">
			UPDATE GATransacciones
			set GATdiferencias = 0
			where Ecodigo    = #Session.Ecodigo#
			  and GATperiodo = #item.Periodo#
			  and GATmes     = #item.Mes#
			  and Cconcepto  = #item.Concepto#
			  and Edocumento = #item.Documento#
		</cfquery>		

		<!--- VERIFICA SI ES NECESARIO HACER ASIENTOS DE AJUSTE --->
		<cfset AsientosAjuste = false>
		<cfquery name="rsAstAjustes" datasource="#session.dsn#">
			Select count(1) as Cantidad
			from GATransacciones a
			where a.OcodigoAnt is not null
			  and a.Ecodigo      = #Session.Ecodigo#
			  and a.GATperiodo   = #item.Periodo#
			  and a.GATmes       = #item.Mes#
			  and a.Cconcepto    = #item.Concepto#
			  and a.Edocumento   = #item.Documento#	
			  and a.Ocodigo     <> a.OcodigoAnt
		</cfquery>

		<cfif rsAstAjustes.Cantidad gt 0>
			<cfset AsientosAjuste = true>
		</cfif>

		<!---Cuenta la cantidad de detalles de la transacción para poder realizar varias validaciones posteriores --->
		<cfquery name="rsValida" datasource="#session.dsn#">
			select count(1) as counta
			from GATransacciones a
			where a.Ecodigo   = #Session.Ecodigo#
			and a.GATperiodo  = #item.Periodo#
			and a.GATmes      = #item.Mes#
			and a.Cconcepto   = #item.Concepto#
			and a.Edocumento  = #item.Documento#
		</cfquery>
		<cfset LvarNumeroTransacciones = rsValida.counta>

		<cfquery name="rsGATransacciones" datasource="#session.dsn#">
			select 	a.ID, 			a.GATperiodo, 	a.GATmes, 		a.GATplaca,  
					a.GATmonto, 	a.GATvutil,		a.IDcontable,	c.Aid, a.AFRmotivo
			from GATransacciones a
				inner join Activos c
				on c.Ecodigo = a.Ecodigo
				and c.Aplaca = a.GATplaca
			where a.Ecodigo    = #Session.Ecodigo#
			  and a.GATperiodo = #item.Periodo#
			  and a.GATmes     = #item.Mes#
			  and a.Cconcepto  = #item.Concepto#
			  and a.Edocumento = #item.Documento#
			order by a.GATmonto DESC
		</cfquery>
		
		<!--- Cantidad de Adquisiciones --->
		<cfquery name="rsCantAdq" datasource="#session.dsn#">
			Select count(1) as total_ADQ
			from GATransacciones a
			where a.Ecodigo    = #Session.Ecodigo#
			  and a.GATperiodo = #item.Periodo#
			  and a.GATmes     = #item.Mes#
			  and a.Cconcepto  = #item.Concepto#
			  and a.Edocumento = #item.Documento#
			  and a.GATmonto > 0
				and not exists(
					Select 1
					from Activos b
					where b.Aplaca = a.GATplaca
					  and b.Ecodigo = a.Ecodigo
				  )
		</cfquery>

		<!--- Cantidad de Mejoras --->
		<cfquery name="rsCantMej" datasource="#session.dsn#">
			Select count(1) as total_MEJ
			from GATransacciones a
			where a.Ecodigo    = #Session.Ecodigo#
			and   a.GATperiodo = #item.Periodo#
			and   a.GATmes     = #item.Mes#
			and   a.Cconcepto  = #item.Concepto#
			and   a.Edocumento = #item.Documento#
			and   a.GATmonto > 0
			and exists(
					Select 1
					from Activos b
					where b.Aplaca = a.GATplaca
					  and b.Ecodigo = a.Ecodigo
				  )
		</cfquery>

		<!--- Cantidad de Retiros --->
		<cfquery name="rsCantRet" datasource="#session.dsn#">
			Select count(1) as total_RET
			from GATransacciones a
			where a.Ecodigo = #Session.Ecodigo#
				and a.GATperiodo = #item.Periodo#
				and a.GATmes = #item.Mes#
				and a.Cconcepto = #item.Concepto#
				and a.Edocumento = #item.Documento#
				and GATmonto < 0
				and exists(
					Select 1
					from Activos b
					where b.Aplaca = a.GATplaca
					  and b.Ecodigo = a.Ecodigo
				  )
		</cfquery>
		<cfset Total_Transacciones = rsCantMej.total_MEJ + rsCantRet.total_RET>
		<cfif Total_Transacciones neq rsGATransacciones.recordcount>
			<cf_errorCode	code = "50062"
							msg  = "Existen activos en Gestion de AF que podrian tener datos inconsistentes (@errorDat_1@ - @errorDat_2@)"
							errorDat_1="#Total_Transacciones#"
							errorDat_2="#rsGATransacciones.recordcount#"
			>
		</cfif>

		<cfif AsientosAjuste>
			<p align="left">&nbsp;&nbsp;&nbsp;Generando el asiento de ajuste</p>
			<!--- Crea tabla temportal TAG para crear tablas temporales, devuelve un string con el nombre de la tabla creada en la variable "temp_table"--->
			<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="CreaIntarc" returnvariable="INTARC">
					<cfinvokeargument name="Conexion" value="#session.DSN#"/>
			</cfinvoke>
			<cfset fnContabilizaAjusteConciliacion()>
		</cfif>

		<!--- inserta los documentos de responsabilidad para aquellas placas que no lo tienen --->
		<p align="left">&nbsp;&nbsp;&nbsp;Inserta los documentos de responsabilidad para aquellas placas que no lo tienen ...</p>
		<cfquery datasource="#session.dsn#">
			insert into CRDocumentoResponsabilidad 
				(Ecodigo, CRTDid, DEid, CFid, 
				ACcodigo, ACid, CRCCid, AFMid, 
				AFMMid, CRDRplaca, CRDRdescripcion, CRDRdescdetallada, 
				CRDRfdocumento, AFCcodigo, 
				CRDRdocori, CRDRestado, CRDRserie, Monto,
				CRDRfalta, BMUsucodigo)
			select Ecodigo, CRTDid, DEid, CFid, 
				ACcodigo, ACid, CRCCid, AFMid, 
				AFMMid, GATplaca, GATdescripcion, GATdescripcion, 
				GATfecha, AFCcodigo, 
				GATReferencia, 10, GATserie, GATmonto, 
				<cfqueryparam cfsqltype="cf_sql_date" value="#now()#">, 
				#session.usucodigo#
			from GATransacciones a
			where a.Ecodigo = #Session.Ecodigo#
			and a.GATperiodo = #item.Periodo#
			and a.GATmes = #item.Mes#
			and a.Cconcepto = #item.Concepto#
			and a.Edocumento = #item.Documento#
			and not exists( 
					select 1
					from CRDocumentoResponsabilidad b
					where b.Ecodigo  = a.Ecodigo
					  and b.CRDRplaca = a.GATplaca
					  and b.CRDRestado = 10)
			and not exists( 
					select 1
					from Activos d
						inner join AFResponsables c
						on c.Ecodigo = d.Ecodigo
						and c.Aid = d.Aid
						and <cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> between c.AFRfini and c.AFRffin
					where d.Ecodigo = a.Ecodigo
					  and d.Aplaca  = a.GATplaca)
		</cfquery>
		<cf_dbfunction name="length" args="a.GATmes" returnvariable="LenGATmes">
        <cf_dbfunction name="srepeat" args="'0';2-#LenGATmes#"  returnvariable="GATmes" delimiters=";" >
		<cf_dbfunction name="to_char"	args="a.GATperiodo" returnvariable="GATperiodoC">
		<cf_dbfunction name="to_char"	args="a.GATmes" returnvariable="GATmesC">
		<cf_dbfunction name="to_char"	args="a.Cconcepto" returnvariable="CconceptoC">
		<cf_dbfunction name="to_char"	args="a.Edocumento" returnvariable="EdocumentoC">
		<cfquery datasource="#session.dsn#">
			insert into #GAADQUISICIONES#
				(Ecodigo, 	EAcpidtrans, 	EAcpdoc, 		EAcplinea, 
				Ocodigo, 	Aid, 			EAPeriodo, 		EAmes, 
				EAFecha, 	Mcodigo, 		EAtipocambio, 	Ccuenta, 
				SNcodigo, 	EAdescripcion, 	EAcantidad, 	EAtotalori, 
				EAtotalloc, EAstatus, 		EAselect, 		Usucodigo, 
				BMUsucodigo,														
				AFMid, 		 AFMMid,		 CFid, 			 DEid,
				AFCcodigo, 	 ACcodigo, 		 ACid, 			 GATdescripcion,
				GATserie, 	 GATplaca, 		 GATfechainidep, GATfechainirev,
				IDcontable)
			Select 	
				a.Ecodigo, 
				'GA', 
				<cf_dbfunction name="concat" args="#GATperiodoC# ° #PreserveSingleQuotes(GATmes)# ° #GATmesC# ° #CconceptoC# ° '-' ° #EdocumentoC#" delimiters="°">,
				a.ID, 
				a.Ocodigo, 
				null, 
				#LvarPeriodoAux#, 
				#LvarMesAux#, 
				a.GATfecha, 
				#LvarMonedaEmpresa#, 
				1.00, 
				(select min(Ccuenta) 
				 from CFinanciera 
				 where Ecodigo = a.Ecodigo 
					and CFcuenta = a.CFcuenta) as Ccuenta, 
				null, 
				'Activos Fijos Adquiridos por Gestion de Activos Fijos.', 
				1, 
				a.GATmonto, 
				a.GATmonto, 
				1, 
				0, 
				#session.usucodigo#,
				#session.usucodigo#,							
				a.AFMid, 
				a.AFMMid, 
				a.CFid, 							
				a.DEid, 							
				a.AFCcodigo, 
				a.ACcodigo, 							
				a.ACid, 
				a.GATdescripcion, 
				a.GATserie, 
				a.GATplaca, 							
				a.GATfechainidep, 
				a.GATfechainirev,
				a.IDcontable
			from GATransacciones a
			where a.Ecodigo = #Session.Ecodigo#
			and a.GATperiodo = #item.Periodo#
			and a.GATmes = #item.Mes#
			and a.Cconcepto = #item.Concepto#
			and a.Edocumento = #item.Documento#
			and a.GATmonto > 0.00
			and not exists(
				Select 1
				from Activos b
				where a.GATplaca = b.Aplaca
				  and a.Ecodigo = b.Ecodigo
			  )
		</cfquery>
		
		<cfquery name="rsUPDATE" datasource="#session.dsn#">			
			update #GAADQUISICIONES#
			set EAcplinea = (
					select count(1) 
					from #GAADQUISICIONES# x
					where x.ID <= #GAADQUISICIONES#.ID
				)						
		</cfquery>
		<cftransaction>
			<p align="left">&nbsp;&nbsp;&nbsp;Generando las relaciones. Aplica Mejoras y Retiros</p>
			<cfset fnGeneraRelacionesActivos()>
			<cfif AsientosAjuste>
				<!--- Crea la FechaAux a partir del periodo / mes de auxiliares y le pone el último día del mes ---> 
				<cfset rsFechaAux.value = CreateDate(LvarPeriodoAux, LvarMesAux, 1)>
				<cfset rsFechaAux.value = DateAdd("m",1,rsFechaAux.value)>
				<cfset rsFechaAux.value = DateAdd("d",-1,rsFechaAux.value)>
				
				<!--- Obtiene la minima oficina para la empresa. (La oficina se le manda al genera asiento para que agrupe) --->
				<cfquery name="rsMinOficina" datasource="#session.dsn#">
					Select Min(Ocodigo) as MinOcodigo
					from Oficinas
					where Ecodigo = #Session.Ecodigo#
				</cfquery>
				<cfif isdefined("rsMinOficina") and rsMinOficina.recordcount GT 0>
					<cfset LvarOcodigo = rsMinOficina.MinOcodigo>
				<cfelse>
					<cfset LvarOcodigo = -100>
				</cfif>
	
				<p align="left">&nbsp;&nbsp;&nbsp;Aplicando el asiento de ajuste ...</p>

				<cfinvoke component="sif.Componentes.CG_GeneraAsiento" method="GeneraAsiento" returnvariable="res_GeneraAsiento">
					<cfinvokeargument name="Conexion" value="#session.DSN#"/>
					<cfinvokeargument name="Ecodigo" value="#session.Ecodigo#"/>
					<cfinvokeargument name="Usucodigo" value="#session.Usucodigo#"/>
					<cfinvokeargument name="IP" value="#session.sitio.ip#"/>
					<cfinvokeargument name="Usuario" value="#session.Usuario#"/>
					<cfinvokeargument name="Oorigen" value="AFGA"/>						
					<cfinvokeargument name="Eperiodo" value="#item.Periodo#"/>
					<cfinvokeargument name="Emes" value="#item.Mes#"/>
					<cfinvokeargument name="Efecha" value="#rsFechaAux.value#"/>
					<cfinvokeargument name="Edescripcion" value="Asiento de Ajuste de Gestion de Activos: #Vdoc#"/>
					<cfinvokeargument name="Edocbase" value="#Vdoc#"/>
					<cfinvokeargument name="Ereferencia" value="GA"/>
					<cfinvokeargument name="Ocodigo" value="#LvarOcodigo#"/>
					<cfinvokeargument name="Debug" value="false"/>
				</cfinvoke>		
			</cfif>
		</cftransaction>			

		<!--- Cambio a procesamiento de cada activo en un ciclo con transacción atómica --->
		<cfquery name="rsCicloAdquisiciones" datasource="#session.dsn#">
			Select 	IDcontable,
					EAcpidtrans, 	
					EAcpdoc, 	
					EAcplinea,
					GATplaca
			from #GAADQUISICIONES#
			order by EAcplinea
		</cfquery>

		<cfset LvarResOk = fnProcesaAdquisiciones(true)>

		<!--- Borra registros de la tabla temporal por si se procesa varias veces el ciclo --->
		<cfquery datasource="#session.dsn#">
			delete from #GAADQUISICIONES#
		</cfquery>
		<cfif AsientosAjuste>
			<cfquery datasource="#session.dsn#">
				delete from #INTARC#
			</cfquery>
		</cfif>
	</cfloop>
</cffunction>

<cffunction name="fnProcesaAdquisiciones" access="private" returntype="any">
	<cfargument name="mostrarresultados" type="boolean" default="false">

	<cfset LvarResultadoOK    = false>
	<cfset LvarRegistrosTotal = rsCicloAdquisiciones.recordcount>
	<cfset LvarContador       = 0>

	<p align="left">&nbsp;&nbsp;&nbsp;Procesando las Adquisiciones de Activo Fijo:</p>
	 	
	<cfloop query="rsCicloAdquisiciones">
			<cfset LvarIDcontable  = rsCicloAdquisiciones.IDcontable>
			<cfset LvarEAcpidtrans = rsCicloAdquisiciones.EAcpidtrans>
			<cfset LvarEAcpdoc     = rsCicloAdquisiciones.EAcpdoc>
			<cfset LvarEAcplinea   = rsCicloAdquisiciones.EAcplinea>
			<cfset LvarGATPlaca    = rsCicloAdquisiciones.GATplaca>

			<cfset LvarContador       = LvarContador + 1>

			<cfoutput>
				<p align="left">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Procesando Placa #LvarGATPlaca# Hora: #Timeformat(now(), 'hh:mm:ss:l')#  Numero: #LvarContador# de #LvarRegistrosTotal#</p>
			</cfoutput>

			<cftransaction>
				<cfinvoke 
					component="sif.Componentes.AF_AltaActivosAdq" 
					method="AF_AltaActivosAdq" 
					TransaccionActiva="true" 
					Contabilizar="false"
					IDcontable="#lvarIDcontable#"
					EAcpidtrans="#LvarEAcpidtrans#"
					EAcpdoc="#LvarEAcpdoc#"
					EAcplinea="#LvarEAcplinea#"
					Ecodigo="#session.Ecodigo#"
					VerificarConciliacionAct="false"
					/>
			</cftransaction>
	</cfloop>
	<cfreturn LvarResultadoOk>
</cffunction>

<cffunction name="fnGeneraRelacionesActivos" access="private" returntype="any">

		<!---
			Inicio Ciclo de Proceso de Item para los activos existentes:
			
			Loop para todas las Transacciones por Procesar de mejora o retiro que cumplan con la llave del item (form.chk) actual 
			Las transacciones de Adquisición se procesan con la tabla temporal.
		--->

		<cfloop query="rsGATransacciones">
			<cfset Lvar_Procesa_Retiro = false>
			<cfset Lvar_Procesa_Mejora = false>

			<cfif rsGATransacciones.GATmonto LT 0>
				<cfset Lvar_Procesa_Retiro = true>
			<cfelseif  rsGATransacciones.GATmonto GTE 0>
				<cfset Lvar_Procesa_Mejora = true>
			</cfif>

			<cfset LvarMesesVutil = rsGATransacciones.GATvutil>
			<cfset LvarID =  rsGATransacciones.ID>
			<cfset LvarPlaca = rsGATransacciones.GATplaca>
			<cfset LvarAid = rsGATransacciones.Aid>
			
			<cfif Lvar_Procesa_Mejora>

				<!--- M  E  J  O  R  A     D  E     A  C  T  I  V  O     F  I  J  O:  Procesa Adqusición de Activo Fijo Sin Contabilizar--->
				<cfif LvarMesesVutil eq 0>
					<!--- verifica que si el Activo tiene un saldo de vida útil en cero (Totalmente depreciado), en este caso se asigna la vida util de la clase
							Se incluye el join con la tabla de clases para validar solo activos depreciables. Los no depreciables pueden mejorar montos sin necesidad de tocar Vida Util. 
					--->
					<cfquery datasource="#session.dsn#" name="saldovuAct">
						select b.AFSsaldovutiladq, c.ACdepreciable, c.ACvutil
						from Activos a
							inner join AFSaldos b
									inner join AClasificacion c
									on  c.Ecodigo  = b.Ecodigo
									and c.ACcodigo = b.ACcodigo
									and c.ACid     = b.ACid
							on  b.Aid        = a.Aid
							and b.Ecodigo    = a.Ecodigo
							and b.AFSperiodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsGATransacciones.GATperiodo#">
							and b.AFSmes     = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsGATransacciones.GATmes#">
						where a.Ecodigo = #Session.Ecodigo#
						  and a.Aplaca 	= '#LvarPlaca#'
					</cfquery>					
				
					<cfif saldovuAct.recordcount gt 0 and saldovuAct.AFSsaldovutiladq eq 0 and saldovuAct.ACdepreciable eq "S" and LvarMesesVutil eq 0>
						<cfset LvarMesesVutil = saldovuAct.ACvutil>
						<cfset rsGATransacciones.GATvutil = LvarMesesVutil>
						
						<cfquery datasource="#session.dsn#" name="Updsaldovu">
							update GATransacciones
							set GATvutil = #LvarMesesVutil#
							where ID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarID#">
						</cfquery>

					</cfif>					
				</cfif>				
				<cfset AGTPid = 0>
				<cfinvoke 
					component="sif.Componentes.AF_MejoraActivos" 
					method="AltaRelacion"
					returnvariable="AGTPid"
					TransaccionActiva="true"
					AGTPdescripcion="MEJORA POR GESTION AF: #item.Periodo##RepeatString('0',2-len(item.Mes))##item.Mes##item.Concepto#-#item.Documento#"
					AGTPrazon="MEJORA IMPORTADA POR MÓDULO DE GESTIÓN DE ACTIVOS FIJOS."/>
				<cfif AGTPid EQ 0>
					<cf_errorCode	code = "50063"
									msg  = "Error al dar de Alta la Transaccion de Mejora, Error 1, No se pudo Insertar el Encabezado del documento para la placa @errorDat_1@, Proceso Cancelado!"
									errorDat_1="#rsGATransacciones.GATplaca#"
					>
				</cfif>
				<cfinvoke 
					component="sif.Componentes.AF_MejoraActivos" 
					method="AltaActivo"
					returnvariable="ADTPlinea"
					TransaccionActiva="true"
					AGTPid="#AGTPid#"
					Aid="#LvarAid#"
					AGTPrazon="MEJORA #rsGATransacciones.GATplaca#"/>
				<cfif ADTPlinea EQ 0>
					<cf_errorCode	code = "50064"
									msg  = "Error al dar de Alta el detalle de la Transaccion de Mejora, Error 2, No se pudo Insertar el Detalle del documento para la placa @errorDat_1@, Proceso Cancelado!"
									errorDat_1="#GATransacciones.GATplaca#"
					>
				</cfif>
				<cfquery datasource="#session.dsn#">
					update ADTProceso
					set   TAmontolocmej = <cfqueryparam cfsqltype="cf_sql_money" value="#replace(rsGATransacciones.GATmonto,',','','all')#">,
						  TAvutil = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesesVutil#">
					where AGTPid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPid#">
					  and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ADTPlinea#">
					  and Ecodigo   = #Session.Ecodigo#
					  and IDtrans   = 2
				</cfquery>					
				<cfinvoke 
					component="sif.Componentes.AF_ContabilizarMejora" 
					method="AF_ContabilizarMejora"
					returnvariable="rsContabilizaMejora" 
					TransaccionActiva="true"
					Contabilizar="false"
					IDcontable="#rsGATransacciones.IDcontable#"
					AGTPid="#AGTPid#"/>

			<cfelseif Lvar_Procesa_Retiro>
				<!--- R  E  T  I  R  O     D  E     A  C  T  I  V  O     F  I  J  O:  Procesa Retiro de Activo Fijo Sin Contabilizar--->
				
				<cfif aplicarret eq 1>
					<cfinvoke 
						component="sif.Componentes.AF_RetiroActivos" 
						method="AltaRelacion"
						returnvariable="AGTPid"
						AGTPdescripcion="RETIRO POR GESTION AF: #item.Periodo##RepeatString('0',2-len(item.Mes))##item.Mes##item.Concepto#-#item.Documento#"
						AFRmotivo="#rsGATransacciones.AFRmotivo#"
						AGTPrazon="RETIRO IMPORTADO POR MÓDULO DE GESTIÓN DE ACTIVOS FIJOS."
						TransaccionActiva="true"/>
				
				<cfelse>				
					<cfif not isdefined("Insencabezado_ret")>
						<cfinvoke 
							component="sif.Componentes.AF_RetiroActivos" 
							method="AltaRelacion"
							returnvariable="AGTPid"
							AGTPdescripcion="RETIRO POR GESTION AF: #item.Periodo##RepeatString('0',2-len(item.Mes))##item.Mes##item.Concepto#-#item.Documento#"
							AFRmotivo="#rsGATransacciones.AFRmotivo#"
							AGTPrazon="RETIRO IMPORTADO POR MÓDULO DE GESTIÓN DE ACTIVOS FIJOS."
							TransaccionActiva="true"/>
						<cfset Insencabezado_ret=1>
						<cfset AGTPidGen = AGTPid>
					</cfif>
				</cfif>
					
				<cfquery name="valida1" datasource="#session.dsn#">
					select 1 
					from AGTProceso 
					where Ecodigo = #session.Ecodigo# and AGTPid = #AGTPid#
				</cfquery>
				<cfif valida1.recordcount eq 0>
					<cf_errorCode	code = "50065" msg = "No se pudo agregar el encabezado, Proceso Cancelado!">
				</cfif>
				
				<cfquery name="rsExisteActivo" datasource="#session.dsn#">
					select Aid
					from ADTProceso
					where Ecodigo = #Session.Ecodigo#
					  and AGTPid  = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPid#">
					  and Aid     = <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarAid#">
				</cfquery>
				
				<cfif rsExisteActivo.recordCount>
					<cf_errorCode	code = "50066"
									msg  = "El Activo @errorDat_1@ ya fué agregado en transaccion de Retiro, Proceso Cancelado!"
									errorDat_1="#LvarPlaca#"
					>>
				</cfif>
					
				<cfinvoke 
					component="sif.Componentes.AF_RetiroActivos" 
					method="AltaActivo"
					returnvariable="ADTPlinea"
					AGTPid="#AGTPid#"
					ADTPrazon="RETIRO DE #rsGATransacciones.GATplaca#."
					Aid="#LvarAid#"
					TransaccionActiva="true"/>
				
				<cfquery name="valida2" datasource="#session.dsn#">
					select 1 from ADTProceso where Ecodigo = #session.Ecodigo# and AGTPid = #AGTPid# and ADTPlinea = #ADTPlinea#
				</cfquery>
				<cfif valida2.recordcount eq 0>
					<cf_errorCode	code = "50067"
									msg  = "No se pudo agregar el detalle para la placa @errorDat_1@, Proceso Cancelado!"
									errorDat_1="#rsGATransacciones.GATplaca#"
					>
				</cfif>

				<!---Proceso especial para definir el monto--->
				<cfset QuerySetCell(rsGATransacciones,"GATmonto", -rsGATransacciones.GATmonto, rsGATransacciones.CurrentRow)>
				
				<cfquery name="rsADTProceso" datasource="#session.dsn#">
					select TAmontolocadq, TAmontolocmej, TAmontolocrev,
						   TAdepacumadq ,TAdepacummej ,TAdepacumrev						   
					from ADTProceso
					where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPid#">
					and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ADTPlinea#">
					and Ecodigo = #Session.Ecodigo#
					and IDtrans = 5
				</cfquery>
				
				<cfset Lvar_TAmontolocadq = rsADTProceso.TAmontolocadq>
				<cfset Lvar_TAmontolocmej = rsADTProceso.TAmontolocmej>
				<cfset Lvar_TAmontolocrev = rsADTProceso.TAmontolocrev>
				
				<cfset Lvar_TAmontolocadqDEP = rsADTProceso.TAdepacumadq>
				<cfset Lvar_TAmontolocmejDEP = rsADTProceso.TAdepacummej>
				<cfset Lvar_TAmontolocrevDEP = rsADTProceso.TAdepacumrev>				
				
				<!--- Verifica que el monto de GA no sea mayor que el valor en libros --->
				<cfif rsGATransacciones.GATmonto - Lvar_TAmontolocadq - Lvar_TAmontolocmej gt Lvar_TAmontolocrev>
					<cf_errorCode	code = "50068"
									msg  = "El monto a retirar para la placa @errorDat_1@ es mayor que el valor en libros del Activo, Proceso Cancelado!"
									errorDat_1="#rsGATransacciones.GATplaca#"
					>
				</cfif>
				
				<!--- Verifica que el monto de GA no sea mayor que el costo (ADQUISICION) --->
				<cfif rsGATransacciones.GATmonto gt (Lvar_TAmontolocadq + Lvar_TAmontolocmej)>
					<cf_errorCode	code = "50069"
									msg  = "El monto a retirar para la placa @errorDat_1@ es mayor que el costo del Activo, Proceso Cancelado!"
									errorDat_1="#rsGATransacciones.GATplaca#"
					>
				</cfif>
				
				<!--- Calcula a que porcentaje del costo, equivale el monto del retiro --->
				<cfset porcentajecosto = (abs(rsGATransacciones.GATmonto) * 100) / (Lvar_TAmontolocadq + Lvar_TAmontolocmej)>
				
				<!--- Calcula los montos a restar de acuerdo al porcentaje(%) --->
				<cfset Lvar_TAmontolocadq_proc = (Lvar_TAmontolocadq * porcentajecosto)/100>				
				<cfset Lvar_TAmontolocmej_proc = (Lvar_TAmontolocmej * porcentajecosto)/100>
				<cfset Lvar_TAmontolocrev_proc = (Lvar_TAmontolocrev * porcentajecosto)/100>
				
				<cfset Lvar_TAmontolocadqDEP_proc = (Lvar_TAmontolocadqDEP * porcentajecosto)/100>				
				<cfset Lvar_TAmontolocmejDEP_proc = (Lvar_TAmontolocmejDEP * porcentajecosto)/100>
				<cfset Lvar_TAmontolocrevDEP_proc = (Lvar_TAmontolocrevDEP * porcentajecosto)/100>

				<cfquery datasource="#session.dsn#">
					update ADTProceso
					set   TAmontolocadq = <cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_TAmontolocadq_proc#">
						, TAmontolocmej = <cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_TAmontolocmej_proc#">
						, TAmontolocrev = <cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_TAmontolocrev_proc#">

						, TAmontodepadq = <cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_TAmontolocadqDEP_proc#">
						, TAmontodepmej  = <cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_TAmontolocmejDEP_proc#">
						, TAmontodeprev	= <cfqueryparam cfsqltype="cf_sql_money" value="#Lvar_TAmontolocrevDEP_proc#">

					where AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPid#">
					  and ADTPlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#ADTPlinea#">
					  and Ecodigo = #Session.Ecodigo#
					  and IDtrans = 5
				</cfquery>
				
				<cfif Request.Debug>
					<cfquery name="rsEcont" datasource="#session.dsn#">
						select count(1) as c from EContables where Ecodigo = #Session.Ecodigo#
					</cfquery>
					<cfdump var="#rsEcont.c#">
				</cfif>
				
				<cfif aplicarret eq 1>
					
					<!--- Se validan en la cola los activos --->
					<cfquery name="rsVerCola" datasource="#session.dsn#">
						select a.Aid, c.Aplaca
						from ADTProceso a, Activos c
						where a.Ecodigo = #Session.Ecodigo# 
						  and a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPid#">
						  and a.Aid = c.Aid
						  and a.Ecodigo = c.Ecodigo
						  and exists(Select 1
									 from CRColaTransacciones b
									 where a.Aid = b.Aid
									   and a.Ecodigo = b.Ecodigo
									)
					</cfquery>
					
					<cfif rsVerCola.recordcount gt 0>
						<cfset ListaPlacas = "">
						<cfloop query="rsVerCola">
							<cfif ListaPlacas eq "">
								<cfset ListaPlacas = rsVerCola.Aplaca>
							<cfelse>
								<cfset ListaPlacas = ListaPlacas & "," & rsVerCola.Aplaca>
							</cfif>
						</cfloop>
						<cf_errorCode	code = "50070"
										msg  = "Algunos de los Activos dentro de la transacción de retiro, se encuentran dentro de transacciones pendientes en la cola de procesos de Activos. Placas: @errorDat_1@"
										errorDat_1="#ListaPlacas#"
						>
					</cfif>
					
					<!--- SE APLICA EL RETIRO --->				
					<cfinvoke 
						component="sif.Componentes.AF_ContabilizarRetiro" 
						method="AF_ContabilizarRetiro" 
						returnvariable="rsResultadosRT"
						TransaccionActiva="true"
						Contabilizar="false"
						IDcontable="#rsGATransacciones.IDcontable#"
						AGTPid="#AGTPid#"/>
					
					<cfif Request.Debug>
						<cfquery name="rsEcont" datasource="#session.dsn#">
							select count(1) as c from EContables where Ecodigo = #Session.Ecodigo#
						</cfquery>
						<cfdump var="#rsEcont.c#">
						<cfdump var="#Lvar_TAmontolocadq#">
						<cfdump var="#Lvar_TAmontolocmej#">
						<cfdump var="#Lvar_TAmontolocrev#">				
						<cfdump var="#ADTPlinea#">
						<cf_dump var="#AGTPid#">
					</cfif>
				<cfelse>
					<!--- Se marca el retiro para que llegue a AF desde un sistema externo --->
					<cfquery name="valida1" datasource="#session.dsn#">
						update AGTProceso 
						set AGTPexterno = 1
						where Ecodigo = #session.Ecodigo# 
						  and AGTPid = #AGTPid#
					</cfquery>					
				</cfif>
			<cfelse>
				<cf_errorCode	code = "50071" msg = "La Transacción No está Definida, Proceso Cancelado!">
			</cfif>
			<!---Termina Ciclo de Proceso de Item--->
		</cfloop>
		
		<!--- 
			Si los retiros no se estan aplicando de manera directa desde Gestion se valida contra la cola la transaccion pendiente que se generó, 
			para ver si hay Activos dentro de algun proceso de cola pendiente. 
		--->
		<cfif aplicarret neq 1 and isdefined("AGTPidGen")>
			<cfquery name="rsVerCola" datasource="#session.dsn#">
				select a.Aid, c.Aplaca
				from ADTProceso a, Activos c
				where a.Ecodigo = #Session.Ecodigo# 
				  and a.AGTPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#AGTPidGen#">
				  and a.Aid = c.Aid
				  and a.Ecodigo = c.Ecodigo
				  and a.IDtrans = 5
				  and exists(Select 1
							 from CRColaTransacciones b
							 where a.Aid = b.Aid
							   and a.Ecodigo = b.Ecodigo
							)
			</cfquery>
			<cfif rsVerCola.recordcount gt 0>
				<cfset ListaPlacas = "">
				<cfloop query="rsVerCola">
					<cfset ListaPlacas = ListaPlacas & "," & rsVerCola.Aplaca>
				</cfloop>
				<cf_errorCode	code = "50072"
								msg  = "Activos en la transacción de retiro se encuentran en transacciones pendientes en la cola de procesos de Activos. Placas: @errorDat_1@"
								errorDat_1="#ListaPlacas#"
				>
			</cfif>		
		</cfif>
		
		<!---Inserta en Bitácora de Transaciones--->
		<cfquery datasource="#session.dsn#">
			insert into GABTransacciones (
				ID, Ecodigo, Cconcepto, GATperiodo, GATmes, 
				Edocumento, GATfecha, GATdescripcion, Ocodigo, 
				ACid, ACcodigo, AFMid, AFMMid, GATserie, GATplaca, 
				GATfechainidep, GATfechainirev, CFid, GATmonto, 
				fechaalta, BMUsucodigo, Referencia1, Referencia2, Referencia3, 
				CFcuenta, AFCcodigo, GATestado, GATReferencia, 
				CRCCid, CRTDid, DEid, GATvutil, IDcontable)
			select 
				ID, Ecodigo, Cconcepto, GATperiodo, GATmes, 
				Edocumento, GATfecha, GATdescripcion, Ocodigo, 
				ACid, ACcodigo, AFMid, AFMMid, GATserie, GATplaca, 
				GATfechainidep, GATfechainirev, CFid, GATmonto, 
				fechaalta, BMUsucodigo, Referencia1, Referencia2, Referencia3, 
				CFcuenta, AFCcodigo, GATestado, GATReferencia, 
				CRCCid, CRTDid, DEid, GATvutil, IDcontable
			from GATransacciones 
			where Ecodigo = #Session.Ecodigo#
			  and GATperiodo = #item.Periodo#
			  and GATmes = #item.Mes#
			  and Cconcepto = #item.Concepto#
			  and Edocumento = #item.Documento#
		</cfquery>

		<!--- Se graban las transacciones de Adquisición para procesamiento posterior --->
		<cfquery datasource="#session.dsn#">
			insert into EAadquisicion 
				(Ecodigo, 	EAcpidtrans, 	EAcpdoc, 		EAcplinea, 
				Ocodigo, 	Aid, 			EAPeriodo, 		EAmes, 
				EAFecha, 	Mcodigo, 		EAtipocambio, 	Ccuenta, 
				SNcodigo, 	EAdescripcion, 	EAcantidad, 	EAtotalori, 
				EAtotalloc, EAstatus, 		EAselect, 		Usucodigo, 
				BMUsucodigo, BMfechaproceso, IDcontable)
			select	Ecodigo, 	EAcpidtrans, 	EAcpdoc, 		EAcplinea, 
					Ocodigo, 	Aid, 			EAPeriodo, 		EAmes, 
					EAFecha, 	Mcodigo, 		EAtipocambio, 	Ccuenta, 
					SNcodigo, 	EAdescripcion, 	EAcantidad, 	EAtotalori, 
					EAtotalloc, -1, 			EAselect, 		Usucodigo, 
					BMUsucodigo, <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
					IDcontable 		 dd					
			from 	#GAADQUISICIONES#		
			order by EAcplinea
		</cfquery>


		<cfquery datasource="#session.dsn#">
			insert into DAadquisicion 
				(Ecodigo, 	EAcpidtrans, 	EAcpdoc, 	EAcplinea, 
				DAlinea, 	DAtc, 			DAmonto, 	Usucodigo, 	
				BMUsucodigo)
			select 	Ecodigo, 	EAcpidtrans, 	EAcpdoc, 	EAcplinea,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="1">, 
					<cfqueryparam cfsqltype="cf_sql_money" value="1.00">, 
					EAtotalloc,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,	
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			from #GAADQUISICIONES#	
			order by EAcplinea					
		</cfquery>
			
		<cfquery datasource="#session.dsn#">
			insert into DSActivosAdq 
				(Ecodigo, 		EAcpidtrans, 	EAcpdoc, 	EAcplinea, 
				DAlinea, 		AFMid, 			AFMMid, 	CFid, 
				DEid, 			Alm_Aid, 		Aid, 		Mcodigo, 
				AFCcodigo, 		DSAtc, 			SNcodigo, 	ACcodigo, 
				ACid, 			DSdescripcion, 	DSserie, 	DSplaca, 
				DSfechainidep, 	DSfechainirev, 	DSmonto, 	Status, CRDRid, 
				Usucodigo, 		BMUsucodigo)
			select 	Ecodigo, 		
					EAcpidtrans, 	
					EAcpdoc, 	
					EAcplinea, 
					<cfqueryparam cfsqltype="cf_sql_integer" value="1">, 		
					AFMid, 			
					AFMMid, 		
					CFid, 		
					DEid, 			
					null as Alm_Aid, 
					null as Aid, 			
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMonedaEmpresa#">,
					AFCcodigo, 		
					<cfqueryparam cfsqltype="cf_sql_float" value="1.00"> as DSAtc, 
					null as SNcodigo, 	
					ACcodigo, 
					ACid, 			
					GATdescripcion, 	
					GATserie, 	
					GATplaca, 
					GATfechainidep, 	
					GATfechainirev, 	
					EAtotalloc, 	
					<cfqueryparam cfsqltype="cf_sql_integer" value="1"> as Status,
					(
						select max(b.CRDRid) 
						from CRDocumentoResponsabilidad b 
						where b.CRDRplaca = #GAADQUISICIONES#.GATplaca
					) as CRDRid, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.usucodigo#">
			from #GAADQUISICIONES#
			order by EAcplinea 
		</cfquery>
	
		<!---Borra Transaciones de Trabajo--->
		<cfquery datasource="#session.dsn#">
			delete from GATransacciones 
			where Ecodigo     = #Session.Ecodigo#
			  and GATperiodo  = #item.Periodo#
			  and GATmes      = #item.Mes#
			  and Cconcepto   = #item.Concepto#
			  and Edocumento  = #item.Documento#
		</cfquery>

</cffunction>

<cffunction name="fnContabilizaAjusteConciliacion" access="private" returntype="any">
	<cfset Vdoc = item.Periodo & RepeatString('0',2-len(item.Mes)) & item.Mes & item.Concepto & "-" & item.Documento>
	<cf_dbfunction name="now" returnvariable="hoy">
	<cf_dbfunction name="sPart"	 args="cf.CFdescripcion,1,38"  returnvariable="CFdescripcion">
	<cf_dbfunction name="concat" args="'Ajuste Contable: ' +rtrim(cf.CFcodigo)+ '-' + rtrim(#CFdescripcion#)"  returnvariable="INTDES_DO" delimiters= "+">
	
	<!--- Débito a la Oficina de GA anterior --->.
	<cfquery name="rstemp" datasource="#session.dsn#">
		insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
		select 
				'AFGA',
				1,
				<cfqueryparam cfsqltype="cf_sql_char" value="#item.Periodo##RepeatString('0',2-len(item.Mes))##item.Mes##item.Concepto#-#item.Documento#">,
				cf.CFcodigo,
				sum(round(a.GATmonto, 2)),
				'C',
				<cf_dbfunction name="sPart"	 args="#PreserveSingleQuotes(INTDES_DO)#;1;80" delimiters=";">,
				<cf_dbfunction name="date_format"	args="#hoy#,yyyymmdd">,
				1.00,
				<cfqueryparam value="#item.Periodo#" cfsqltype="cf_sql_integer">, 
				<cfqueryparam value="#item.Mes#" cfsqltype="cf_sql_integer">,
				cc.Ccuenta,
				null,
				null,
				<cfqueryparam value="#LvarMonedaEmpresa#" cfsqltype="cf_sql_numeric">,
				a.OcodigoAnt,
				sum(round(a.GATmonto, 2))
				
		from GATransacciones a
				inner join CFuncional cf
					 on cf.CFid = a.CFid
					and cf.Ecodigo = a.Ecodigo

				inner join CFinanciera cc
					  on cc.CFcuenta = a.CFcuenta
					 and cc.Ecodigo = a.Ecodigo
					 
		where a.OcodigoAnt is not null
		  and a.Ocodigo 	!= a.OcodigoAnt
		  and a.Ecodigo 	= #Session.Ecodigo#
		  and a.GATperiodo 	= #item.Periodo#
		  and a.GATmes 		= #item.Mes#
		  and a.Cconcepto 	= #item.Concepto#
		  and a.Edocumento	= #item.Documento#				

		group by cf.CFcodigo, cf.CFdescripcion,	cc.Ccuenta, a.OcodigoAnt
	</cfquery>
	
	<!--- Crédito a la Oficina de GA actual --->
	<cfquery name="rstemp" datasource="#session.dsn#">
		insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, Ccuenta, Cgasto, Cformato, Mcodigo, Ocodigo, INTMOE)
		select 
				'AFGA',
				1,
				<cfqueryparam cfsqltype="cf_sql_char" value="#item.Periodo##RepeatString('0',2-len(item.Mes))##item.Mes##item.Concepto#-#item.Documento#">,
				cf.CFcodigo,
				sum(round(a.GATmonto, 2)),
				'D',
				<cf_dbfunction name="sPart"	 args="#PreserveSingleQuotes(INTDES_DO)#;1;80" delimiters=";">,
				<cf_dbfunction name="date_format"	args="#hoy#,yyyymmdd">,
				1.00,
				<cfqueryparam value="#item.Periodo#" cfsqltype="cf_sql_integer">, 
				<cfqueryparam value="#item.Mes#" cfsqltype="cf_sql_integer">,
				<!---cc.Ccuenta,--->
				cl.ACcadq,
				null,
				null,
				<cfqueryparam value="#LvarMonedaEmpresa#" cfsqltype="cf_sql_numeric">,
				a.Ocodigo,
				sum(round(a.GATmonto, 2))
				
		from GATransacciones a

				inner join AClasificacion cl
					on cl.Ecodigo 	= a.Ecodigo
					and cl.ACcodigo = a.ACcodigo
					and cl.ACid 	= a.ACid					
		
				inner join CFuncional cf
					 on cf.CFid = a.CFid
					and cf.Ecodigo = a.Ecodigo

				inner join CFinanciera cc
					  on cc.CFcuenta = a.CFcuenta
					 and cc.Ecodigo = a.Ecodigo
					 
		where a.OcodigoAnt is not null
		  and a.Ocodigo 	!= a.OcodigoAnt
		  and a.Ecodigo 	= #Session.Ecodigo#
		  and a.GATperiodo 	= #item.Periodo#
		  and a.GATmes 		= #item.Mes#
		  and a.Cconcepto 	= #item.Concepto#
		  and a.Edocumento	= #item.Documento#				

		group by cf.CFcodigo, cf.CFdescripcion,	cl.ACcadq, a.Ocodigo       <!---, a.CFcuenta  cc.Ccuenta,--->
	</cfquery>		
	
	<!--- ***************************************************************
	** BALANCE POR OFICINAS: Busca en la tabla CuentaBalanceOficina *****
	*****************************************************************--->				
	<cfquery name="rsHayCuentasBalanceOficina" datasource="#session.dsn#">
		select 1
		from CuentaBalanceOficina
		where Ecodigo = #Session.Ecodigo#
	</cfquery>
	
	<cfif rsHayCuentasBalanceOficina.recordcount GT 0>
	
		<!--- Validacion de que todas las cuentas de relacion existan --->
		<cfquery name="rsVerCuentasBalanceOficina" datasource="#session.dsn#">
			Select 	ofi1.Oficodigo, ofi1.Odescripcion, 
					ofi2.Oficodigo, ofi2.Odescripcion
			from GATransacciones a
					inner join Oficinas ofi1
						on ofi1.Ocodigo = a.Ocodigo
					   and ofi1.Ecodigo = a.Ecodigo
					   
					inner join Oficinas ofi2
						on ofi2.Ocodigo = a.OcodigoAnt
					   and ofi2.Ecodigo = a.Ecodigo
			where a.OcodigoAnt is not null
			  and a.Ocodigo != a.OcodigoAnt
			  and a.Ecodigo = #Session.Ecodigo#
			  and a.GATperiodo = #item.Periodo#
			  and a.GATmes = #item.Mes#
			  and a.Cconcepto = #item.Concepto#
			  and a.Edocumento = #item.Documento#				
			  and (not exists (	select 1
								from CuentaBalanceOficina cb
										inner join ConceptoContable b
											 on b.Ecodigo = cb.Ecodigo
											and b.Cconcepto = cb.Cconcepto
											and b.Oorigen = 'AFGA'
								where cb.Ecodigo     = a.Ecodigo
								  and cb.Ocodigoori  = a.OcodigoAnt
								  and cb.Ocodigodest = a.Ocodigo)

			   or not exists (	select 1
								from CuentaBalanceOficina cb
										inner join ConceptoContable b
											 on b.Ecodigo = cb.Ecodigo
											and b.Cconcepto = cb.Cconcepto
											and b.Oorigen = 'AFGA'
								where cb.Ecodigo     = a.Ecodigo
								  and cb.Ocodigoori  = a.Ocodigo
								  and cb.Ocodigodest = a.OcodigoAnt) 
				  )
		</cfquery>
		
		<cfif rsVerCuentasBalanceOficina.recordcount gt 0>
			<cf_errorCode	code = "50073" msg = "Existen Oficinas que no tienen definidas las cuentas de relacion">
		</cfif>				
			
		<cfset LvarNumDoc = item.Periodo & RepeatString('0',2-len(item.Mes)) & item.Mes & item.Concepto & "-" & item.Documento>	
		<cf_dbfunction name="to_char" args="#LvarNumDoc#"  returnvariable="LvarNumDocC">
		<cf_dbfunction name="now" returnvariable="hoy">
				
		<!--- 2.3.9 Debito Oficina 1(#Odescripcion1#), Balance Oficina, Cuenta por Cobrar a la Oficina 2 --->
		<cf_dbfunction name="concat" args="'Debito Oficina: '+ ofi1.Oficodigo+'-'+ofi1.Odescripcion+', Balance Oficina Cuenta por Cobrar a la Oficina: '+ ofi2.Oficodigo+'-'+ofi2.Odescripcion+' , Activo '+a.GATplaca+'.'" delimiters="+" returnvariable="INTDES">
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, CFcuenta, Ccuenta, Mcodigo, Ocodigo, INTMOE)
			select 
					'AFGA', 
					1, 
					<cf_dbfunction name="sPart"	args="#PreserveSingleQuotes(LvarNumDocC)#;1;20" delimiters=";">, 
					'AJ',
					round(a.GATmonto,2), 
					'D', 
					<cf_dbfunction name="sPart"	args="#PreserveSingleQuotes(INTDES)#;1;80" delimiters=";">,
					
					<cf_dbfunction name="date_format"	args="#hoy#,yyyymmdd">,
					1.00,  
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Periodo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#item.Mes#">, 
					cb.CFcuentacxc, 
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMonedaEmpresa#">,
					a.OcodigoAnt, 
					round(a.GATmonto,2)
			from GATransacciones a					
					inner join CuentaBalanceOficina cb
						 on cb.Ecodigo     = a.Ecodigo
						and cb.Ocodigoori  = a.OcodigoAnt
						and cb.Ocodigodest = a.Ocodigo								
						
					inner join Oficinas ofi1
						 on ofi1.Ocodigo = a.Ocodigo
							and ofi1.Ecodigo = a.Ecodigo
					   
					inner join Oficinas ofi2
						 on ofi2.Ocodigo = a.OcodigoAnt
							and ofi1.Ecodigo = a.Ecodigo

					inner join ConceptoContable b
						 on b.Ecodigo = cb.Ecodigo
						and b.Cconcepto = cb.Cconcepto
						and b.Oorigen = 'AFGA'
			
			where a.OcodigoAnt is not null
			  and a.Ocodigo != a.OcodigoAnt
			  and a.Ecodigo = #Session.Ecodigo#
			  and a.GATperiodo = #item.Periodo#
			  and a.GATmes = #item.Mes#
			  and a.Cconcepto = #item.Concepto#
			  and a.Edocumento = #item.Documento#
		</cfquery>
		<!--- 2.3.10 Crédito, Balance Oficina, Cuenta Pagar a la Oficina 1 --->
		<cf_dbfunction name="concat"	args="'Credito Oficina: '+ ofi2.Oficodigo+'-'+ofi2.Odescripcion+', Balance Oficina,'+'Cuenta por Pagar a la Oficina: '+ ofi1.Oficodigo+'-'+ofi1.Odescripcion+' , Activo '+ a.GATplaca+'.'" delimiters="+" returnvariable="INTDES2">
		<cfquery datasource="#session.dsn#">
			insert into #INTARC# ( INTORI, INTREL, INTDOC, INTREF, INTMON, INTTIP, INTDES, INTFEC, INTCAM, Periodo, Mes, CFcuenta, Ccuenta, Mcodigo, Ocodigo, INTMOE)
			select 
					'AFGA', 
					1, 
					<cf_dbfunction name="sPart"	args="#PreserveSingleQuotes(LvarNumDocC)#;1;20" delimiters=";">, 
					'AJ',
					round(a.GATmonto,2), 
					'C', 
					<cf_dbfunction name="sPart"	args="#PreserveSingleQuotes(INTDES2)#;1;80" delimiters=";">,
					
					<cf_dbfunction name="date_format"	args="#hoy#,yyyymmdd">,
					1.00,  
					#item.Periodo#, 
					#item.Mes#, 
					cb.CFcuentacxp,
					0,
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarMonedaEmpresa#">,
					a.Ocodigo,
					round(a.GATmonto,2)
			from GATransacciones a					
					inner join CuentaBalanceOficina cb
						 on cb.Ecodigo     = a.Ecodigo
						and cb.Ocodigoori  = a.Ocodigo
						and cb.Ocodigodest = a.OcodigoAnt	
						
					inner join Oficinas ofi1
						 on ofi1.Ocodigo = a.Ocodigo
							and ofi1.Ecodigo = a.Ecodigo
					   
					inner join Oficinas ofi2
						 on ofi2.Ocodigo = a.OcodigoAnt
							and ofi1.Ecodigo = a.Ecodigo
						
					inner join ConceptoContable b
						 on b.Ecodigo = cb.Ecodigo
						and b.Cconcepto = cb.Cconcepto
						and b.Oorigen = 'AFGA'
			
			where a.OcodigoAnt is not null
			  and a.Ocodigo != a.OcodigoAnt
			  and a.Ecodigo = #Session.Ecodigo#
			  and a.GATperiodo = #item.Periodo#
			  and a.GATmes = #item.Mes#
			  and a.Cconcepto = #item.Concepto#
			  and a.Edocumento = #item.Documento#
		</cfquery>
	</cfif>			
</cffunction>

