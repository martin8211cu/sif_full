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
<cf_navegacion name="Ccodigo"    		navegacion="" session default="-1">
<cf_navegacion name="fltTipoDoc" 		navegacion="" session default="-1">
<cf_navegacion name="fltNaturaleza" 	navegacion="" session default="-1">
<cf_navegacion name="Volumen" 			navegacion="" session default="-1">
<cf_navegacion name="Observaciones" 	navegacion="" session default="-1">
<cf_navegacion name="Poliza" 	navegacion="" session default="-1">
<cf_navegacion name="Grupo1"  	        navegacion="" session default="-1">

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

<!----Valida que el mes haya sido cerrado---->
<cfset Valido = false>				
<cfif form.fltPeriodo LT rsVerificaPeriodo.Año>
 	<cfset Valido = true>
<cfelseif rsVerificaPeriodo.Año EQ form.fltPeriodo and form.fltMes LT rsVerificaPeriodo.Mes>
 	<cfset Valido = true>
</cfif>

<!---Valida periodo actual--->
<cfif form.fltPeriodo NEQ #rsVerificaPeriodo.Año#>
	<cfthrow message="Solo puede afecta el periodo #rsVerificaPeriodo.Año#">
</cfif>

	<cfif Valido EQ true>
			<cfquery name="rsSaldosVol" datasource="#GvarConexion#">
				select ID_Saldo from SaldosVolumen 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		    	and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
				and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
				and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoVenta#">
    			and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccodigo#"> 
				and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoDoc#">
			</cfquery>
			
			<cfif rsSaldosVol.recordcount GT 0>
				<cfquery datasource="#GvarConexion#">
				update SaldosVolumen set Volumen_Actual = Volumen_Actual
				<cfif form.fltNaturaleza EQ 'P'>
					+ <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">
				<cfelse>
					- <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">
				</cfif>
				where ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosVol.ID_Saldo#">
				</cfquery>
			<cfelse>
				<cfquery name="EncSalVol" datasource="#GvarConexion#">
				insert into SaldosVolumen
				(Ecodigo,
				Periodo,
				Mes, 
				Clas_Venta,
				Producto,
				Tipo_Documento,
				Volumen_Documento,
				Volumen_Actual,
				Usuario)
				values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoVenta#">,
    			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoDoc#">,
				0,
				<cfif form.fltNaturaleza EQ 'P'>
					<cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">,
				<cfelse>
					-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)
				<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
			</cfquery>
			<cf_dbidentity2 name="EncSalVol" verificar_transaccion="false" datasource="#GvarConexion#">
			</cfif>
			
		<!---Inserta tabla SaldosVolumenMov--->
		<!---Obtiene ultimo ID del detalle para el registro registro--->
		<cfquery name="rsMaximo" datasource="#GvarConexion#">
			select coalesce(max(ID_Saldo_Det), 0) + 1 as Maximo from SaldosVolumenMov
			where
			<cfif rsSaldosVol.recordcount GT 0>
				ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosVol.ID_Saldo#">
				<cfset IDS = #rsSaldosVol.ID_Saldo#>
			<cfelse>
				ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EncSalVol.identity#">
				<cfset IDS = #EncSalVol.identity#>
			</cfif> 
		</cfquery>		
		
		<!---Inserta el movimiento--->
		<cfquery datasource="#GvarConexion#">
			insert into SaldosVolumenMov
			(ID_Saldo_Det,
			ID_Saldo,
			Observaciones,
			Volumen_Nuevo,
			Poliza_Ref,
			Usuario,			
			Fecha_Actualizacion)
			values
			(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaximo.Maximo#">,			
			<cfif rsSaldosVol.recordcount GT 0>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosVol.ID_Saldo#">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#EncSalVol.identity#">,
			</cfif> 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poliza#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
			getdate())
		</cfquery>				
	<cfelse>
		<cfthrow message="El mes contable que desea afectar aun no ha sido cerrado.">		
	</cfif>
<cfset IDD = #rsMaximo.Maximo#>	
	
<!----QUITAR EL COMENTARIO CUANDO ESTEN AL CORRIENTE CON LOS MESES
<cfquery name="rsUltMes" datasource="#Session.DSN#">
	Select isnull(max(Mes),1) as Mes from    SaldosVolumen
	where Volumen_Documento = Volumen_Actual 
	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
</cfquery>

<cfif (form.fltMes NEQ rsUltMes.Mes AND form.fltMes LT rsUltMes.Mes) and form.fltTipoDoc EQ 'PRNF'>
	<cfthrow message="Solo se pueden insertar movimientos FACT para este mes">
</cfif>---->
	
<!---Actualiza o inserta variables de Anexos---->
<!----Obtiene valore para la clave---->
<cfset Clave = form.fltTipoVenta & form.Ccodigo>
								
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
<cfquery name="rsVarAnexo" datasource="#GvarConexion#">
	select AVid from AnexoVar 
	where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Clave#">
</cfquery>

<!----Inserta a la tabla de AnexoVar---->
<cfif rsVarAnexo.recordcount EQ 0>
	<cfquery name="insEncR" datasource="#GvarConexion#">
		insert into AnexoVar
	    (CEcodigo,
		Ecodigo,                                                                       
		AVnombre,
  	    AVdescripcion,                                                                 
		AVtipo,  
		BMfecha,                                                                  
		BMUsucodigo,
		AVusar_oficina,          
		AVvalor_anual,       
		AVvalor_arrastrar)
		values
		(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Clave#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#Clave#">,
		'F',
		getdate(),
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
		0,
		0,
		0)   
		<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
	</cfquery>
<cf_dbidentity2 name="insEncR" verificar_transaccion="false" datasource="#GvarConexion#">
</cfif>	

				       				 				
<cfquery datasource="#GvarConexion#">
	if exists (select 1 from AnexoVarValor 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
 	<cfif rsVarAnexo.recordcount GT 0>
		and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexo.AVid#">
	<cfelse>
		and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">								 							    </cfif>
	and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
	and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
	update AnexoVarValor set AVvalor = 
	convert (varchar(50),(convert(float,AVvalor)  								                        					    <cfif form.fltNaturaleza EQ 'P'>
		+ <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">)) 
	<cfelse>
		- <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">))
	</cfif>
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> 					    
	<cfif rsVarAnexo.recordcount GT 0>
		and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexo.AVid#">
	<cfelse>
		and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">								 							    </cfif>	
	and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
	and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
	else insert into AnexoVarValor
	(AVid,
	 AVano,
	 AVmes,
	 Ecodigo,                                                                  
	 Ocodigo,                                                                  
	 AVvalor,
	 BMfecha,
	 BMUsucodigo,                                                              
	 GOid,
	 GEid)
	values
	(<cfif rsVarAnexo.recordcount GT 0>
	 	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexo.AVid#">,	
	 <cfelse>
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncR.identity#">,								 							     </cfif>
	 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
	 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
	 <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
	 -1,
	 <cfif form.fltNaturaleza EQ 'P'>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Volumen#">, 
	 <cfelse>
		convert (varchar(50),(-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">)),
	 </cfif>
 	 getdate(),
	 <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
	 -1,
 	 -1)   
</cfquery>

<!---Inserta variable de tipo de cambio --->
<!---Obtener el tipo de cambio--->
<cfquery name="rsTipoCambio" datasource="#GvarConexion#">	
	select tce.Ecodigo, tce.Periodo, tce.Mes, m.Miso4217, m.Mnombre, tce.TCEtipocambio 
	from TipoCambioEmpresa  tce	 
	inner join Monedas m
	on m.Mcodigo=tce.Mcodigo
	and m.Ecodigo=tce.Ecodigo	
	where tce.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
	and tce.Periodo= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltPeriodo#">
	and tce.Mes= <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltMes#">
	and m.Miso4217=<cfqueryparam cfsqltype="cf_sql_varchar" value="USD">
</cfquery>
		
<!----Obtiene valore para la clave del tipo de cambio---->
<cfset ClaveTC = "TC-" & rsTipoCambio.Miso4217>
								
<!---Obtiene la descripción del registro--->
<cfset DescripcionTC = rsTipoCambio.Mnombre>
			
<!----Valida si la variable ya existe--->
<cfquery name="rsVarAnexoTC" datasource="#GvarConexion#">
	select AVid from AnexoVar 
	where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveTC#">
</cfquery>
	
<!---Inserta variable y valor en las tablas de Anexos---->
<cfif rsVarAnexoTC.recordcount EQ 0>
	<cfquery name="insEncTC"datasource="#GvarConexion#">
		insert into AnexoVar
		(CEcodigo,
		Ecodigo,                                                                       
		AVnombre,
    	AVdescripcion,                                                                 
		AVtipo,  
		BMfecha,                                                                  
		BMUsucodigo,
		AVusar_oficina,          
		AVvalor_anual,       
		AVvalor_arrastrar)
		values
		(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveTC#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#DescripcionTC#">,
		'F',
		getdate(),
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
		0,
		0,	
		0)   
		<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
	</cfquery>
	<cf_dbidentity2 name="insEncTC" verificar_transaccion="false" datasource="#GvarConexion#">
</cfif>
                     
	
<cfquery datasource="#GvarConexion#">
	if exists (select 1 from AnexoVarValor 
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
			   <cfif rsVarAnexoTC.recordcount GT 0>
				 and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoTC.AVid#">
			   <cfelse>
			     and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncTC.identity#">															       		   </cfif>
			    and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltPeriodo#">
				and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltMes#">)
				update AnexoVarValor set AVvalor = 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTipoCambio.TCEtipocambio#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> 					                <cfif rsVarAnexoTC.recordcount GT 0>
					and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoTC.AVid#">
				<cfelse>
					and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncTC.identity#">								 				</cfif>
				and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltPeriodo#">
				and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltMes#">
				else insert into AnexoVarValor
				(AVid,
				 AVano,
				 AVmes,
				 Ecodigo,                                                                  
				 Ocodigo,                                                                  
				 AVvalor,
				 BMfecha,
				 BMUsucodigo,                                                              
				 GOid,
				 GEid)
				values
				(<cfif rsVarAnexoTC.recordcount GT 0>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoTC.AVid#">,
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_integer" value="#insEncTC.identity#">,								 							                </cfif>
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltPeriodo#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Form.fltMes#">,
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
				 -1,
				 <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsTipoCambio.TCEtipocambio#">,
				 getdate(),
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
				 -1,
				 -1)   
</cfquery>						
		

<!---Inserta registros si se indica que es una acualización de NASA--->
<cfif isdefined("form.Grupo1") and ltrim(trim(form.Grupo1)) EQ 'Nasa'>
			<cfquery name="rsSaldosVolN" datasource="#GvarConexion#">
				select ID_Saldo from SaldosVolumen 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
		    	and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
				and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
				and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="VNA">
    			and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccodigo#"> 
				and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoDoc#">
			</cfquery>
			
			<cfif rsSaldosVolN.recordcount GT 0>
				<cfquery datasource="#GvarConexion#">
				update SaldosVolumen set Volumen_Actual = Volumen_Actual
				<cfif form.fltNaturaleza EQ 'P'>
					+ <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">
				<cfelse>
					- <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">
				</cfif>
				where ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosVolN.ID_Saldo#">
				</cfquery>
			<cfelse>
				<cfquery name="EncSalVolN" datasource="#GvarConexion#">
				insert into SaldosVolumen
				(Ecodigo,
				Periodo,
				Mes, 
				Clas_Venta,
				Producto,
				Tipo_Documento,
				Volumen_Documento,
				Volumen_Actual,
				Usuario)
				values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="VNA">,
    			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoDoc#">,
				0,
				<cfif form.fltNaturaleza EQ 'P'>
					<cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">,
				<cfelse>
					-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)
				<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
			</cfquery>
			<cf_dbidentity2 name="EncSalVolN" verificar_transaccion="false" datasource="#GvarConexion#">
			</cfif>
			
		<!---INSERT TABLA MOVIMIENTOS--->
		<!---Obtiene ultimo ID del detalle para el registro registro--->
		<cfquery name="rsMaximoN" datasource="#GvarConexion#">
			select coalesce(max(ID_Saldo_Det), 0) + 1 as Maximo from SaldosVolumenMov
			where
			<cfif rsSaldosVol.recordcount GT 0>
				ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosVolN.ID_Saldo#">
			<cfelse>
				ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EncSalVolN.identity#">
			</cfif> 
		</cfquery>

		<!---Inserta el movimiento--->
		<cfquery datasource="#GvarConexion#">
			insert into SaldosVolumenMov
			(ID_Saldo_Det,
			ID_Saldo,
			Observaciones,
			Volumen_Nuevo,
			Poliza_Ref,
			Usuario,
			Fecha_Actualizacion)
			values
			(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaximoN.Maximo#">,			
			<cfif rsSaldosVolN.recordcount GT 0>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosVolN.ID_Saldo#">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#EncSalVolN.identity#">,
			</cfif> 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poliza#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
			getdate())
		</cfquery>				

<!---Actualiza o inserta variables de Anexos---->
<!----Obtiene valore para la clave---->
<cfset ClaveN = 'VNA' & form.Ccodigo>
								
<!----Valida si la variable ya existe--->
<cfquery name="rsVarAnexoN" datasource="#GvarConexion#">
	select AVid from AnexoVar 
	where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveN#">
</cfquery>

<!----Inserta a la tabla de AnexoVar---->
<cfif rsVarAnexoN.recordcount EQ 0>
	<cfquery name="insEncRN" datasource="#GvarConexion#">
		insert into AnexoVar
	    (CEcodigo,
		Ecodigo,                                                                       
		AVnombre,
  	    AVdescripcion,                                                                 
		AVtipo,  
		BMfecha,                                                                  
		BMUsucodigo,
		AVusar_oficina,          
		AVvalor_anual,       
		AVvalor_arrastrar)
		values
		(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveN#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveN#">,
		'F',
		getdate(),
		<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
		0,
		0,
		0)   
		<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
	</cfquery>
<cf_dbidentity2 name="insEncRN" verificar_transaccion="false" datasource="#GvarConexion#">
</cfif>	

				       				 				
<cfquery datasource="#GvarConexion#">
	if exists (select 1 from AnexoVarValor 
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
 	<cfif rsVarAnexoN.recordcount GT 0>
		and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoN.AVid#">
	<cfelse>
		and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncRN.identity#">								 							    </cfif>
	and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
	and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
	update AnexoVarValor set AVvalor = 
	convert (varchar(50),(convert(float,AVvalor)  								                        					    <cfif form.fltNaturaleza EQ 'P'>
		+ <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">)) 
	<cfelse>
		- <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">))
	</cfif>
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> 					    
	<cfif rsVarAnexoN.recordcount GT 0>
		and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoN.AVid#">
	<cfelse>
		and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncRN.identity#">								 							    </cfif>	
	and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
	and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
	else insert into AnexoVarValor
	(AVid,
	 AVano,
	 AVmes,
	 Ecodigo,                                                                  
	 Ocodigo,                                                                  
	 AVvalor,
	 BMfecha,
	 BMUsucodigo,                                                              
	 GOid,
	 GEid)
	values
	(<cfif rsVarAnexoN.recordcount GT 0>
	 	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoN.AVid#">,	
	 <cfelse>
		 <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncRN.identity#">,								 							     </cfif>
	 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
	 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
	 <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
	 -1,
	 <cfif form.fltNaturaleza EQ 'P'>
		<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Volumen#">, 
	 <cfelse>
		convert (varchar(50),(-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">)),
	 </cfif>
 	 getdate(),
	 <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
	 -1,
 	 -1)   
</cfquery>
</cfif><!---Cierra IF de Nasa--->


<!---Inserta registros de MEXPAN---->
<cfif isdefined("form.Grupo1") and ltrim(trim(form.Grupo1)) EQ 'Intercompañia'>
<cfquery name="rsEquiv" datasource="#GvarConexion#">
	select distinct(EQUidSIF) 
    from #sifinterfacesdb#..SIFLD_Equivalencia
    where SIScodigo = 'ICTS'
    and CATcodigo = 'SOCIO_ANEX'
	and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
</cfquery>
						
<cfif rsEquiv.recordcount GT 0>
	<cfloop query="rsEquiv">
		<cfquery name="rsSaldosVolI" datasource="#GvarConexion#">
				select ID_Saldo from SaldosVolumen 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#">
		    	and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
				and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
				and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoVenta#">
    			and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccodigo#"> 
				and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoDoc#">
		</cfquery>
			
		<cfif rsSaldosVolI.recordcount GT 0>
				<cfquery datasource="#GvarConexion#">
				update SaldosVolumen set Volumen_Actual = Volumen_Actual
				<cfif form.fltNaturaleza EQ 'P'>
					- <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">				
				<cfelse>
					+ <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">
				</cfif>
				where ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosVolI.ID_Saldo#">
				</cfquery>
		<cfelse>
				<cfquery name="EncSalVolI" datasource="#GvarConexion#">
				insert into SaldosVolumen
				(Ecodigo,
				Periodo,
				Mes, 
				Clas_Venta,
				Producto,
				Tipo_Documento,
				Volumen_Documento,
				Volumen_Actual,
				Usuario)
				values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoVenta#">,
    			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Ccodigo#">, 
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoDoc#">,
				0,
				<cfif form.fltNaturaleza EQ 'P'>
					-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">,				
				<cfelse>
					<cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">,	
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">)
				<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
			</cfquery>
			<cf_dbidentity2 name="EncSalVolI" verificar_transaccion="false" datasource="#GvarConexion#">
		</cfif>
	
		<!---INSERT TABLA MOVIMIENTOS--->
		<!---Obtiene ultimo ID del detalle para el registro registro--->
		<cfquery name="rsMaximoI" datasource="#GvarConexion#">
			select coalesce(max(ID_Saldo_Det), 0) + 1 as Maximo from SaldosVolumenMov
			where
			<cfif rsSaldosVolI.recordcount GT 0>
				ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosVolI.ID_Saldo#">
			<cfelse>
				ID_Saldo = <cfqueryparam cfsqltype="cf_sql_integer" value="#EncSalVolI.identity#">
			</cfif> 
		</cfquery>

		<!---Inserta el movimiento--->
		<cfquery datasource="#GvarConexion#">
			insert into SaldosVolumenMov
			(ID_Saldo_Det,
			ID_Saldo,
			Observaciones,
			Volumen_Nuevo,
			Poliza_Ref,
			Usuario,
			Fecha_Actualizacion)
			values
			(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsMaximoI.Maximo#">,			
			<cfif rsSaldosVol.recordcount GT 0>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsSaldosVolI.ID_Saldo#">,
			<cfelse>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#EncSalVolI.identity#">,
			</cfif> 
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Observaciones#">,
			<cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">,
			<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Poliza#">,
			<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
			getdate())
		</cfquery>				

		<!---Actualiza o inserta variables de Anexos---->
		<!----Obtiene valore para la clave---->
		<cfset ClaveI = form.fltTipoVenta & form.Ccodigo>
								
		<!----Valida si la variable ya existe--->
		<cfquery name="rsVarAnexoI" datasource="#GvarConexion#">
			select AVid from AnexoVar 
			where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveI#">
		</cfquery>
		
		<!----Inserta a la tabla de AnexoVar---->
		<cfif rsVarAnexoI.recordcount EQ 0>
			<cfquery name="insEncRI" datasource="#GvarConexion#">
				insert into AnexoVar
			    (CEcodigo,
				Ecodigo,                                                                       
				AVnombre,
		  	    AVdescripcion,                                                                 
				AVtipo,  
				BMfecha,                                                                  
				BMUsucodigo,
				AVusar_oficina,          
				AVvalor_anual,       
				AVvalor_arrastrar)
				values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveI#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#ClaveI#">,
				'F',
				getdate(),
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
				0,
				0,
				0)   
				<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
			</cfquery>
		<cf_dbidentity2 name="insEncRI" verificar_transaccion="false" datasource="#GvarConexion#">
		</cfif>	

		<cfquery datasource="#GvarConexion#">
			if exists (select 1 from AnexoVarValor 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#">
		 	<cfif rsVarAnexoI.recordcount GT 0>
				and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoI.AVid#">
			<cfelse>
				and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncRI.identity#">																			    		</cfif>
			and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
			and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">)
			update AnexoVarValor set AVvalor = 
			convert (varchar(50),(convert(float,AVvalor)  								                        														    		<cfif form.fltNaturaleza EQ 'P'>
				- <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">))
			<cfelse>
				+ <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">))				
			</cfif>
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#"> 					    
			<cfif rsVarAnexoI.recordcount GT 0>
				and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoI.AVid#">
			<cfelse>
				and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncRI.identity#">												            </cfif>	
			and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
			and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
			else insert into AnexoVarValor
			(AVid,
			 AVano,
			 AVmes,
			 Ecodigo,                                                                  
			 Ocodigo,                                                                  
			 AVvalor,
			 BMfecha,
			 BMUsucodigo,                                                              
			 GOid,
			 GEid)
			values
			(<cfif rsVarAnexoI.recordcount GT 0>
	 			<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoI.AVid#">,	
			 <cfelse>
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncRI.identity#">,								 							    		 </cfif>
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">,
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#">,
			 -1,
			 <cfif form.fltNaturaleza EQ 'P'>
				convert (varchar(50),(-1 * <cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">)),
			 <cfelse>
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Volumen#">, 				
			 </cfif>
		 	 getdate(),
			 <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
			 -1,
		 	 -1)   
		</cfquery>
	</cfloop>
</cfif>

<!---SUMA EL NUEVO VOLUMEN AL MES ACTUAL Y LOS SIGUIENTES----->
<cfquery name="rsEquivI" datasource="#GvarConexion#">
	select distinct(EQUidSIF) 
    from #sifinterfacesdb#..SIFLD_Equivalencia
    where SIScodigo = 'ICTS'
    and CATcodigo = 'SOCIO_ANEX'
	and EQUempSIF = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
</cfquery>

<cfif rsEquivI.recordcount GT 0>
	<cfloop query="rsEquivI">
		<cfquery name="rsVolI" datasource="#GvarConexion#">
			select distinct(AVmes) as Mes from AnexoVarValor
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquivI.EQUidSIF#">
			and AVmes > <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
			and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
		</cfquery>

		<cfif rsVolI.recordcount GT 0>
		<cfloop query="rsVolI">
			<!----Valida si la variable ya existe--->
			<cfquery name="rsVarAnexoAI" datasource="#GvarConexion#">
				select AVid from AnexoVar 
				where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsEquivI.EQUidSIF#-#form.fltTipoVenta##form.Ccodigo#">
		</cfquery>
			
		<cfif rsVarAnexoAI.recordcount EQ 0>
			<cfquery name="insEncAI" datasource="#GvarConexion#">
				insert into AnexoVar
				(CEcodigo,
				Ecodigo,                                                                       
				AVnombre,
			    AVdescripcion,                                                                 
				AVtipo,  
				BMfecha,                                                                  
				BMUsucodigo,
				AVusar_oficina,          
				AVvalor_anual,       
				AVvalor_arrastrar)
				values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquivI.EQUidSIF#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoVenta##form.Ccodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoVenta##form.Ccodigo#">,
				'F',
				getdate(),
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
				0,
				0,	
				0)   
				<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
    	    </cfquery>
		<cf_dbidentity2 name="insEncA" verificar_transaccion="false" datasource="#GvarConexion#">										
		</cfif>
				
		<cfquery datasource="#GvarConexion#">
			if exists (select 1 from AnexoVarValor 
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquivI.EQUidSIF#">
 			   <cfif rsVarAnexoAI.recordcount GT 0>
					and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoAI.AVid#">
			   <cfelse>
					and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncAI.identity#">
			   </cfif>
			and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
		    and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolI.Mes#">)
			update AnexoVarValor set AVvalor = 
			convert (varchar(50),(convert(float,AVvalor) + 								        	            		       		<cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">)) 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquivI.EQUidSIF#"> 						            <cfif rsVarAnexoAI.recordcount GT 0>
				and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoAI.AVid#">
			<cfelse>
				and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncAI.identity#">
			</cfif>																 	 					            
			and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
			and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolI.Mes#">
	  		else insert into AnexoVarValor
				 (AVid,
				 AVano,
				 AVmes,
				 Ecodigo,                                                                  
				 Ocodigo,                                                                  
				 AVvalor,
				 BMfecha,
				 BMUsucodigo,                                                              
				 GOid,
				 GEid)
				values
				(<cfif rsVarAnexoAI.recordcount GT 0>
				 	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoAI.AVid#">,
			 	<cfelse>
				 	<cfqueryparam cfsqltype="cf_sql_integer" value="#insEncAI.identity#">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolI.Mes#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquivI.EQUidSIF#">,
				-1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Volumen#">,
				getdate(),
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
				-1,
				-1)   
		</cfquery>	
		</cfloop>
	</cfif>	
	</cfloop>
</cfif>	
</cfif>	<!---Cierra If MEXPAN--->

<!---SUMA EL NUEVO VOLUMEN AL MES ACTUAL Y LOS SIGUIENTES----->
<cfquery name="rsVolM" datasource="#GvarConexion#">
	select distinct(AVmes) as Mes from AnexoVarValor
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
	and AVmes > <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
	and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
</cfquery>

<cfif rsVolM.recordcount GT 0>
	<cfloop query="rsVolM">
		<!----Valida si la variable ya existe--->
		
		<cfquery name="rsVarAnexoA" datasource="#GvarConexion#">
			select AVid from AnexoVar 
			where AVnombre = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoVenta##form.Ccodigo#">
		</cfquery>
			
		<cfif rsVarAnexoA.recordcount EQ 0>
			<cfquery name="insEncA" datasource="#GvarConexion#">
				insert into AnexoVar
				(CEcodigo,
				Ecodigo,                                                                       
				AVnombre,
			    AVdescripcion,                                                                 
				AVtipo,  
				BMfecha,                                                                  
				BMUsucodigo,
				AVusar_oficina,          
				AVvalor_anual,       
				AVvalor_arrastrar)
				values
				(<cfqueryparam cfsqltype="cf_sql_integer" value="#rsCEcodigo.CEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoVenta##form.Ccodigo#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.fltTipoVenta##form.Ccodigo#">,
				'F',
				getdate(),
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
				0,
				0,	
				0)   
				<cf_dbidentity1 verificar_transaccion="false" datasource="#GvarConexion#">
    	    </cfquery>
		<cf_dbidentity2 name="insEncA" verificar_transaccion="false" datasource="#GvarConexion#">										
		</cfif>
				
		<cfquery datasource="#GvarConexion#">
			if exists (select 1 from AnexoVarValor 
			   where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">
 			   <cfif rsVarAnexoA.recordcount GT 0>
					and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoA.AVid#">
			   <cfelse>
					and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncA.identity#">
			   </cfif>
			and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
		    and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolM.Mes#">)
			update AnexoVarValor set AVvalor = 
			convert (varchar(50),(convert(float,AVvalor) + 								        	            		       		<cfqueryparam cfsqltype="cf_sql_float" value="#form.Volumen#">)) 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#"> 						            <cfif rsVarAnexoA.recordcount GT 0>
				and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoA.AVid#">
			<cfelse>
				and AVid = <cfqueryparam cfsqltype="cf_sql_integer" value="#insEncA.identity#">
			</cfif>																 	 					            
			and AVano = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">
			and AVmes = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolM.Mes#">
	  		else insert into AnexoVarValor
				 (AVid,
				 AVano,
				 AVmes,
				 Ecodigo,                                                                  
				 Ocodigo,                                                                  
				 AVvalor,
				 BMfecha,
				 BMUsucodigo,                                                              
				 GOid,
				 GEid)
				values
				(<cfif rsVarAnexoA.recordcount GT 0>
				 	<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVarAnexoA.AVid#">,
			 	<cfelse>
				 	<cfqueryparam cfsqltype="cf_sql_integer" value="#insEncA.identity#">,
				</cfif>
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#rsVolM.Mes#">,
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarEcodigo#">,
				-1,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Volumen#">,
				getdate(),
				<cfqueryparam cfsqltype="cf_sql_integer" value="#GvarUsucodigo#">,
				-1,
				-1)   
		</cfquery>	
	</cfloop>
</cfif>

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
	<form name="form1" action="ActualizaSaldosVolumen-form.cfm" method="post">
	   	<center>
        	<table border="1" align="center">
            	<tr>
                	<td width="100%" align="center">
                    	<strong> SE REGISTRO EXITOSAMENTE EL MOVIMIENTO #IDS#-#IDD#</strong>
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
