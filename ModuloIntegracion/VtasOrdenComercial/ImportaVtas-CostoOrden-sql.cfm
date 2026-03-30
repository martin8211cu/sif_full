
<cf_templateheader title="SIF - Interfaces P.M.I.">
<cfinclude template="/sif/portlets/pNavegacion.cfm">
<cf_web_portlet_start border="true" skin="#Session.Preferences.Skin#" tituloalign="center" titulo='Saldos por Volumen de Ventas'>

<cfsetting enablecfoutputonly="yes">
<cfsetting requesttimeout="900">
<cfset minisifdb       = Application.dsinfo[session.dsn].schema>
<cfset sifinterfacesdb = Application.dsinfo.sifinterfaces.schema>


<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">
<cf_navegacion name="Contrato"  		navegacion="" session default="-1">
<cf_navegacion name="fltTipoDoc" 		navegacion="" session default="-1">
<cf_navegacion name="fltNaturaleza" 	navegacion="" session default="-1">
<cf_navegacion name="Importe" 			navegacion="" session default="-1">
<cf_navegacion name="Observaciones" 	navegacion="" session default="-1">
<cf_navegacion name="Poliza" 	        navegacion="" session default="-1">
<cf_navegacion name="fltMoneda"  	    navegacion="" session default="-1">
<cf_navegacion name="fltOperacion"  	navegacion="" session default="-1">
<cf_navegacion name="ID"  	navegacion="" session default="-1">
    
    
<cfset GvarConexion  = Session.Dsn>
<cfset GvarEcodigo   = Session.Ecodigo>	
<cfset GvarUsuario   = Session.Usuario>
<cfset GvarUsucodigo = Session.Usucodigo>
<cfset varError = false>	

	<cfif isdefined("Form.BorrarMovimiento")>
		<cfset Movims = #ListToArray(Form.ID, ',')#>
		<cfloop index="i" from="1" to="#ArrayLen(Movims)#">
		<cfset IDmov   = "#Movims[i]#">
	    <cftransaction action="begin">
    	    <cfquery datasource="#Session.DSN#">
				delete from ImportVtasCost 
				where ID = #Movims[i]#
			</cfquery>
   		</cftransaction>
	</cfloop>


<!---Arreglo para obtener ID's a Procesar--->
	<cfelseif isdefined("Form.Guardar")>
		<cfset Movims = #ListToArray(Form.ID, ',')#>
		<cfloop index="i" from="1" to="#ArrayLen(Movims)#">
		
        <cfset IDmov   = "#Movims[i]#">
        
        <cftransaction action="begin">
        
<cftry>


<!---Verifica periodo y mes activos en la contabilidad---->				
<cfquery name="rsVerificaPeriodo" datasource="#session.dsn#">
	select (select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value= "#GvarEcodigo#"> and Pcodigo = 60) as Mes,
    (select Pvalor FROM Parametros WHERE Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value= "#GvarEcodigo#"> and Pcodigo = 50) as Año
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

<!---Lista de Movimientos a Importar--->
<cfquery name="Movimiento" datasource="#Session.DSN#">
	select a.ID as ID,
    a.fltPeriodo,
    a.fltMes,
    a.Contrato,
    a.fltTipoDoc,
    a.fltNaturaleza,
    a.Importe,
    a.Observaciones,
    a.Poliza,
    a.fltMoneda,
    a.fltOperacion
	from ImportVtasCost a
    where ID = #Movims[i]#
</cfquery>



<cfquery name="rsUltMesR" datasource="#Session.DSN#">
	Select isnull(max(Mes),1) as Mes from SaldosUtilidad 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Periodo = (select fltPeriodo from ImportVtasCost  where ID = #Movimiento.ID#)
</cfquery>


<cfif (Movimiento.fltMes NEQ rsUltMesR.Mes AND Movimiento.fltMes LT rsUltMesR.Mes) and Movimiento.fltTipoDoc EQ 'PRNF'>
	<cfthrow message="Solo se pueden insertar movimientos FACT para este mes">
</cfif>

<cfif (Movimiento.fltMes GT rsUltMesR.Mes)>
	<cfthrow message="Primero debe generar la utilidad para el mes seleccionado antes de registrar algún movimiento adicional Para la Orden Comercial                      #Movimiento.Contrato#">
</cfif>


			<cfquery name="rsSaldosUti" datasource="#GvarConexion#">
				select ID_Saldo from SaldosUtilidad
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		    	and Periodo = #Movimiento.fltPeriodo#
				and Mes = #Movimiento.fltMes#
				and Clas_Venta = ltrim(rtrim('#Movimiento.fltTipoDoc#'))
    			and Orden_Comercial = ltrim(rtrim('#Movimiento.Contrato#')) 
				and Moneda = '#Movimiento.fltMoneda#'
			</cfquery>

            
				
			<cfif rsSaldosUti.recordcount GT 0>
				<cfquery datasource="#GvarConexion#">
				update SaldosUtilidad
				<cfif '#Movimiento.fltOperacion#' EQ 'I'>
					set Imp_Ingreso_Actual = Imp_Ingreso_Actual
					<cfif '#Movimiento.fltNaturaleza#' EQ 'P'>
						+ '#Movimiento.Importe#'
					<cfelse>
						- '#Movimiento.Importe#'
					</cfif>
				<cfelse>
					set Imp_Costo_Actual = Imp_Costo_Actual 
					<cfif '#Movimiento.fltNaturaleza#' EQ 'P'>
						+ '#Movimiento.Importe#'
					<cfelse>
						- '#Movimiento.Importe#'
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
				'#Movimiento.fltPeriodo#',
				'#Movimiento.fltMes#',
				ltrim(rtrim('#Movimiento.fltTipoDoc#')),
    			ltrim(rtrim('#Movimiento.Contrato#')),
				0,
				0,
				<cfif '#Movimiento.fltOperacion#' EQ 'I'>
					<cfif '#Movimiento.fltNaturaleza#' EQ 'P'>
						'#Movimiento.Importe#',
					<cfelse>
						-1 * '#Movimiento.Importe#',
					</cfif>
					0,
				<cfelse>
					0,
					<cfif '#Movimiento.fltNaturaleza#' EQ 'P'>
						'#Movimiento.Importe#',
					<cfelse>
						-1 * '#Movimiento.Importe#',
					</cfif>
				</cfif>
				'#Movimiento.fltMoneda#',
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
				'#Movimiento.Observaciones#',
			<cfif '#Movimiento.fltOperacion#' EQ 'I'>
				<cfif '#Movimiento.fltNaturaleza#' EQ 'P'>
					'#Movimiento.Importe#',
				<cfelse>
					-1 * '#Movimiento.Importe#',
				</cfif>
			0,
			<cfelse>
			0,
				<cfif '#Movimiento.fltNaturaleza#' EQ 'P'>
					'#Movimiento.Importe#',
				<cfelse>
					-1 * '#Movimiento.Importe#',
				</cfif>
			</cfif>
			'#Movimiento.Poliza#',
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
	where Orden_Comercial = ltrim(rtrim('#Movimiento.Contrato#'))
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
		'#Movimiento.Contrato#',
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
	and Uano = '#Movimiento.fltPeriodo#'
	and Umes = '#Movimiento.fltMes#'
	and Moneda = '#Movimiento.fltMoneda#')
	update UtilidadVarValor set 
	<cfif '#Movimiento.fltOperacion#' EQ 'I'>
		Imp_Ingreso = Imp_Ingreso 
		<cfif '#Movimiento.fltNaturaleza#' EQ 'P'>
			+ '#Movimiento.Importe#'
		<cfelse>
			- '#Movimiento.Importe#'
		</cfif>
	<cfelse>
		Imp_Costo = Imp_Costo 
		<cfif '#Movimiento.fltNaturaleza#' EQ 'P'>
			+ '#Movimiento.Importe#'
		<cfelse>
			- '#Movimiento.Importe#'
		</cfif>
	</cfif>
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> 					    
	<cfif rsVarUtilidad.recordcount GT 0>
		and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarUtilidad.ID_Utilidad#">
	<cfelse>
		and ID_Utilidad = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">
    </cfif>
	and Uano = '#Movimiento.fltPeriodo#'
	and Umes = '#Movimiento.fltMes#'
	and Moneda = '#Movimiento.fltMoneda#'
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
	 	'#Movimiento.fltPeriodo#',
		'#Movimiento.fltMes#',
		'#Movimiento.fltMoneda#',
	 	<cfif '#Movimiento.fltOperacion#' EQ 'I'>
			<cfif '#Movimiento.fltNaturaleza#' EQ 'P'>
				0 + '#Movimiento.Importe#',
			<cfelse>
				0 - '#Movimiento.Importe#',
			</cfif>
		0,
		<cfelse>
		0,
			<cfif '#Movimiento.fltNaturaleza#' EQ 'P'>
				0 + '#Movimiento.Importe#',
			<cfelse>
				0 - '#Movimiento.Importe#',
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
<cfif not varError>
		<cfquery datasource="#Session.DSN#">
			delete ImportVtasCost
		    where ID = #Movimiento.ID#
        </cfquery>
</cfif>  
</cftransaction>
	</cfloop>
	</cfif>

<cfoutput>

<cfif not varError>
            
	<form name="form1" action="ActualizaVtas-CostoOrden-form.cfm" method="post">
	   	<center>

        	<table border="1" align="center">
            	<tr>
                	<td width="100%" align="center">
                   <cfif isdefined("Form.Guardar")>
                    		<strong> SE REGISTRO EXITOSAMENTE EL MOVIMIENTO DE <cfif '#Movimiento.fltOperacion#'  EQ 'I'> INGRESO <cfelse> COSTO</cfif>
                   	   		PARA LA ORDEN '#Movimiento.Contrato#' DEL AÑO '#Movimiento.fltPeriodo#' Y MES '#Movimiento.fltMes#'</strong>
                    <cfelse>   
                    		<strong> SE ELIMINO EXITOSAMENTE EL MOVIMIENTO</strong>
                    </cfif>     
                    </td>
                </tr>
                <tr>
	               	<td width="100%" align="center">
   <input type="button" name="Regresar" value="Regresar" onClick="javascript:location.href='/cfmx/ModuloIntegracion/VtasOrdenComercial/FormActualizaVtas-CostoOrden.cfm'">
                    </td>
                </tr>
            </table>
        </center>
	 </form>
</cfif>
</cfoutput>
