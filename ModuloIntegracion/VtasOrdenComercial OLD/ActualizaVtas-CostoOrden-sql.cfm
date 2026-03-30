<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Saldos por Volumen de Ventas'>

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">
<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>

<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">
<cf_navegacion name="fltTipoVenta" 		navegacion="" session default="-1">
<cf_navegacion name="Contrato"  		navegacion="" session default="-1">
<cf_navegacion name="fltTipoDoc" 		navegacion="" session default="-1">
<cf_navegacion name="fltNaturaleza" 	navegacion="" session default="-1">
<cf_navegacion name="Importe" 			navegacion="" session default="-1">
<cf_navegacion name="Observaciones" 	navegacion="" session default="-1">
<cf_navegacion name="Poliza" 	        navegacion="" session default="-1">
<cf_navegacion name="fltMoneda"  	    navegacion="" session default="-1">
<cf_navegacion name="fltOperacion"  	navegacion="" session default="-1">

<cfset GvarConexion  = Session.Dsn>
<cfset GvarEcodigo   = Session.Ecodigo>	
<cfset GvarUsuario   = Session.Usuario>
<cfset GvarUsucodigo = Session.Usucodigo>
<cfset varError = false>	

<cftransaction action="begin">
<cftry>
<!---Verifica periodo y mes activos en la contabilidad---->				
<cfquery name="rsVerificaPeriodo" datasource="#session.dsn#">
	select (select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                 "#GvarEcodigo#"> and Pcodigo = 60) as Mes,
    (select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value=                    "#GvarEcodigo#"> and Pcodigo = 50) as Año
</cfquery>

<!---<!----Valida que el mes haya sido cerrado---->
<cfset Valido = false>				
<cfif form.fltPeriodo LT rsVerificaPeriodo.Año>
 	<cfset Valido = true>
<cfelseif rsVerificaPeriodo.Año EQ form.fltPeriodo and form.fltMes LT rsVerificaPeriodo.Mes>
 	<cfset Valido = true>
</cfif>--->

<!---Valida periodo actual
<cfif form.fltPeriodo NEQ #rsVerificaPeriodo.Año#>
	<cfthrow message="Solo puede afecta el periodo #rsVerificaPeriodo.Año#">
</cfif>--->

<!---<cfif Valido EQ false>
	<cfthrow message="El mes contable que desea afectar aun no ha sido cerrado.">		
</cfif>--->
	
<!---QUITAR EL COMENTARIO CUANDO ESTEN AL CORRIENTE CON LOS MESES---->
<cfquery name="rsUltMesR" datasource="#Session.DSN#">
	Select isnull(max(Mes),1) as Mes from SaldosUtilidad 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
</cfquery>

<cfif (form.fltMes NEQ rsUltMesR.Mes AND form.fltMes LT rsUltMesR.Mes) and form.fltTipoDoc EQ 'PRNF'>
	<cfthrow message="Solo se pueden insertar movimientos FACT para este mes">
</cfif>

<cfif (form.fltMes GT rsUltMesR.Mes)>
	<cfthrow message="Primero debe generar la utilidad para el mes seleccionado antes de registrar algún movimiento adicional">
</cfif>

			<cfquery name="rsSaldosUti" datasource="#GvarConexion#">
				select ID_Saldo from SaldosUtilidad 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		    	and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
				and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
				and Clas_Venta = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoDoc#">))
    			and Orden_Comercial = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Contrato#">)) 
				and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltMoneda#">				
			</cfquery>
					
					
			<cfif rsSaldosUti.recordcount GT 0>
				<cfquery datasource="#GvarConexion#">
				update SaldosUtilidad
				<cfif form.fltOperacion EQ 'I'>
					set Imp_Ingreso_Actual = Imp_Ingreso_Actual
					<cfif form.fltNaturaleza EQ 'P'>
						+ <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">
					<cfelse>
						- <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">
					</cfif>
				<cfelse>
					set Imp_Costo_Actual = Imp_Costo_Actual 
					<cfif form.fltNaturaleza EQ 'P'>
						+ <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">
					<cfelse>
						- <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">
					</cfif>
				</cfif>
				where ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosUti.ID_Saldo#">
				</cfquery>
			<cfelse>
				<cfquery name="EncSalUti" datasource="#GvarConexion#">
				insert into SaldosUtilidad
				(Ecodigo,
				Periodo,
				Mes, 
				Clas_Venta,
				Orden_Comercial,
				Imp_Ingreso,
				Imp_Costo,
				Imp_Ingreso_Actual,
				Imp_Costo_Actual,
				Moneda,
				Usuario)
				values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
				ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoDoc#">)),
    			ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Contrato#">)),
				0,
				0,
				<cfif form.fltOperacion EQ 'I'>
					<cfif form.fltNaturaleza EQ 'P'>
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
					<cfelse>
						-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
					</cfif>
					0,
				<cfelse>
					0,
					<cfif form.fltNaturaleza EQ 'P'>
						<cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
					<cfelse>
						-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
					</cfif>
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltMoneda#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)
				<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
			</cfquery>
			<cf_dbidentity2 name="EncSalUti" verificar_transaccion="false" datasource="#GvarConexion#">
		</cfif>
		
		<!---Inserta tabla SaldosUtilidadMov--->
		<!---Obtiene ultimo ID del detalle para el registro registro--->
		<cfquery name="rsMaximo" datasource="#GvarConexion#">
			select coalesce(max(ID_Saldo_Det), 0) + 1 as Maximo from SaldosUtilidadMov
			where
			<cfif rsSaldosUti.recordcount GT 0>
				ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosUti.ID_Saldo#">
				<cfset IDS = #rsSaldosUti.ID_Saldo#>
			<cfelse>
				ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EncSalUti.identity#">
				<cfset IDS = #EncSalUti.identity#>
			</cfif> 
		</cfquery>	
		

		<!---Inserta el movimiento--->
		<cfquery datasource="#GvarConexion#">
			insert into SaldosUtilidadMov
			(ID_Saldo_Det,
			ID_Saldo,
			Observaciones,
			Imp_Ingreso_Nuevo,
			Imp_Costo_Nuevo,
			Poliza_Ref,
			Usuario,			
			Fecha_Actualizacion)
			values
			(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaximo.Maximo#">,			
			<cfif rsSaldosUti.recordcount GT 0>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosUti.ID_Saldo#">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#EncSalUti.identity#">,
			</cfif> 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
			<cfif form.fltOperacion EQ 'I'>
				<cfif form.fltNaturaleza EQ 'P'>
					<cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
				<cfelse>
					-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
				</cfif>
			0,
			<cfelse>
			0,
				<cfif form.fltNaturaleza EQ 'P'>
					<cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
				<cfelse>
					-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
				</cfif>
			</cfif>
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poliza#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
			getdate())
		</cfquery>				
	<cfset IDD = #rsMaximo.Maximo#>	
	
<!---Actualiza o inserta Utilidad---->
<!--- FUNCION GETCECODIGO --->
<cfquery name="rsCEcodigo" datasource="#GvarConexion#">
	select CEcodigo, Ecodigo 
	from Empresa E
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
</cfquery>
					
<cfif rsCEcodigo.recordcount EQ 0>
	<cfthrow message="No existe el codigo para la empresa">
</cfif>
				
<!----Valida si la variable ya existe--->
<cfquery name="rsVarUtilidad" datasource="#GvarConexion#">
	select ID_Utilidad from UtilidadVar 
	where Orden_Comercial = ltrim(rtrim(<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Contrato#">))
</cfquery>

<!----Inserta a la tabla de AnexoVar---->
<cfif rsVarUtilidad.recordcount EQ 0>
	<cfquery name="insEncR" datasource="#GvarConexion#">
		insert into UtilidadVar
	    (CEcodigo,
		Orden_Comercial,
  	    BMfecha,                                                                  
		BMUsucodigo)
		values
		(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Contrato#">,
		getdate(),
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)   
		<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
	</cfquery>
<cf_dbidentity2 name="insEncR" verificar_transaccion="false" datasource="#GvarConexion#">
</cfif>	

 				
<cfquery datasource="#GvarConexion#">
	if exists (select 1 from UtilidadVarValor 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
 	<cfif rsVarUtilidad.recordcount GT 0>
		and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarUtilidad.ID_Utilidad#">
	<cfelse>
		and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">								 	</cfif>
	and Uano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
	and Umes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
	and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltMoneda#">)
	update UtilidadVarValor set 
	<cfif form.fltOperacion EQ 'I'>
		Imp_Ingreso = Imp_Ingreso 
		<cfif form.fltNaturaleza EQ 'P'>
			+ <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">
		<cfelse>
			- <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">
		</cfif>
	<cfelse>
		Imp_Costo = Imp_Costo 
		<cfif form.fltNaturaleza EQ 'P'>
			+ <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">
		<cfelse>
			- <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">
		</cfif>
	</cfif>
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> 					    
	<cfif rsVarUtilidad.recordcount GT 0>
		and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarUtilidad.ID_Utilidad#">
	<cfelse>
		and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">								 	</cfif>
	and Uano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
	and Umes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
	and Moneda = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltMoneda#">
	else insert into UtilidadVarValor
		(ID_Utilidad,
		 Ecodigo,
		 Uano,
		 Umes,
		 Moneda,
		 Imp_Ingreso,
		 Imp_Costo,
		 BMfecha,
		 BMUsucodigo)
		values
		(<cfif rsVarUtilidad.recordcount GT 0>
	 		<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarUtilidad.ID_Utilidad#">,	
	 	<cfelse>
		 	<cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">,								 							     	</cfif>
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
	 	<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltMoneda#">,
	 	<cfif form.fltOperacion EQ 'I'>
			<cfif form.fltNaturaleza EQ 'P'>
				0 + <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
			<cfelse>
				0 - <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
			</cfif>
		0,
		<cfelse>
		0,
			<cfif form.fltNaturaleza EQ 'P'>
				0 + <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
			<cfelse>
				0 - <cfqueryparam cfsqltype="cf_sql_float" value="#form.Importe#">,
			</cfif>
		</cfif>
 	 	getdate(),
	 	<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)
	</cfquery>
	
	
<cftransaction action="commit"/>

		<cfcatch>
		<cftransaction action="rollback"/>
   		<cfset varError = true>			
		<cfif isdefined("cfcatch.Message")>
			<cfset Mensaje="#cfcatch.Message#">
       	<cfelse>
 	       <cfset Mensaje="">
        </cfif>
        <cfif isdefined("cfcatch.Detail")>
	       <cfset Detalle="#cfcatch.Detail#">
    	<cfelse>
            <cfset Detalle="">
        </cfif>
        <cfif isdefined("cfcatch.sql")>
           	<cfset SQL="#cfcatch.sql#">
	    <cfelse>
    	    <cfset SQL="">
        </cfif>
        <cfif isdefined("cfcatch.where")>
            <cfset PARAM="#cfcatch.where#">
	    <cfelse>
    	    <cfset PARAM="">
        </cfif>
        <cfif isdefined("cfcatch.StackTrace")>
            <cfset PILA="#cfcatch.StackTrace#">
	    <cfelse>
    	   <cfset PILA="">
        </cfif>
           <cfset MensajeError= #Mensaje# & #Detalle#>
		<cfthrow message="#MensajeError#">
		</cfcatch>
</cftry>
</cftransaction>

<cfoutput>
<cfif not varError>
	<form name="form1" action="ActualizaVtas-CostoOrden-form.cfm" method="post">
	   	<center>
        	<table border="1" align="center">
            	<tr>
                	<td width="100%" align="center">
                    	<strong> SE REGISTRO EXITOSAMENTE EL MOVIMIENTO DE <cfif #form.fltOperacion#  EQ 'I'> INGRESO <cfelse> COSTO</cfif> #IDD# PARA LA ORDEN #form.Contrato# DEL MES DE #form.fltMes#</strong>
                    </td>
                </tr>
                <tr>
	               	<td width="100%" align="center">
                    	<input type="submit" name="btnRegresa" value="Regresar" />
                    </td>
                </tr>
            </table>
        </center>
	 </form>
</cfif>
</cfoutput>
