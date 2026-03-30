<cfset LvarCBesTCE =0>
<cfif isdefined("url.LvarCBesTCE")	and not isdefined("form.LvarCBesTCE")>
	<cfset LvarCBesTCE = url.LvarCBesTCE >
</cfif>
<cfif isdefined("url.pagenum_lista")	and not isdefined("form.pagenum_lista")>
	<cfset form.pagenum_lista = url.pagenum_lista >
</cfif>

<cfif isdefined("url.EMusuario") and not isdefined("form.EMusuario")>
	<cfset form.EMusuario = url.EMusuario>	 
</cfif>

<cfif isdefined("url.filtro_EMdocumento")	and not isdefined("form.filtro_EMdocumento")>
	<cfset form.filtro_EMdocumento = url.filtro_EMdocumento >
</cfif>

<cfif isdefined("url.filtro_CBid")	and not isdefined("form.filtro_CBid")>
	<cfset form.filtro_CBid = url.filtro_CBid >
</cfif>

<cfif isdefined("url.filtro_BTid")	and not isdefined("form.filtro_BTid")>
	<cfset form.filtro_BTid = url.filtro_BTid >
</cfif>

<cfif isdefined("url.filtro_EMdescripcion")	and not isdefined("form.filtro_EMdescripcion")>
	<cfset form.filtro_EMdescripcion = url.filtro_EMdescripcion >
</cfif>

<cfif isdefined("url.filtro_EMfecha")	and not isdefined("form.filtro_EMfecha")>
	<cfset form.filtro_EMfecha = url.filtro_EMfecha >
</cfif>

<cfif isdefined("url.filtro_usuario")	and not isdefined("form.filtro_usuario")>
	<cfset form.filtro_usuario = url.filtro_usuario >
</cfif>

<cfif isdefined("url.filtro_DMdescripcion") and not isdefined("form.filtro_DMdescripcion") >
	<cfset form.filtro_DMdescripcion = url.filtro_DMdescripcion >
</cfif>	

<cfif isdefined("url.filtro_Cdescripcion") and not isdefined("form.filtro_Cdescripcion") >
	<cfset form.filtro_Cdescripcion = url.filtro_Cdescripcion >
</cfif>	

<!--- ==================================================================================== --->
<!--- ==================================================================================== --->

<!--- 	DEFINICION DEL MODO --->
<cfset modo="ALTA">
<cfif isdefined("Form.EMid") and len(trim(form.EMid))>
	<cfset modo="CAMBIO">
<cfelseif isdefined("url.EMid") and len(trim(url.EMid))>
	<cfset modo="CAMBIO">
    <cfset Form.EMid=url.EMid>
</cfif>

<cfif isdefined("url.ECid") and len(trim(url.ECid))>
    <cfset Form.ECid=url.ECid>
</cfif>


<!--- 	CONSULTAS --->

	<cfquery name="rsDatos" datasource="#Session.DSN#">
        select a.ECid,
			a.ECdescripcion, <!--- estado de cuenta --->
			c.Bdescripcion, <!--- banco --->
			b.CBid, b.CBcodigo, b.CBdescripcion, <!--- cuenta bancaria --->
			d.Cformato,  <!--- formato de cuenta --->
			a.Bid,
            m.Mnombre, b.Mcodigo	
        from ECuentaBancaria a
        inner join CuentasBancos b
        	on  b.CBid = a.CBid 
        inner join Bancos c 
        	on c.Bid = b.Bid 
        inner join CContables d 
        	on d.Ccuenta = b.Ccuenta   
        inner join Monedas m 
			on m.Mcodigo = b.Mcodigo
        where b.Ecodigo = #Session.Ecodigo#
        <!---Tarjeta de Credito 1 o CuentasBancarias 0--->	
          and b.CBesTCE = #LvarCBesTCE#
          and a.ECid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.ECid#">
	</cfquery>
    

	<cfquery name="rsPeriodoAux" datasource="#Session.DSN#">
        select Pvalor 
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 50
    </cfquery>
    
    <cfquery name="rsMesAux" datasource="#Session.DSN#">
        select Pvalor 
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 60
    </cfquery>
    
    <cfset LvarPeriodoAux=rsPeriodoAux.Pvalor>
    <cfset LvarMesAux=rsMesAux.Pvalor>
    <cfif rsMesAux.Pvalor eq 1>
    	<cfset LvarMesAuxAnt=12>
        <cfset LvarPeriodoAuxAnt=rsPeriodoAux.Pvalor-1> 
    <cfelse>    
    	<cfset LvarMesAuxAnt=rsMesAux.Pvalor-1>
        <cfset LvarPeriodoAuxAnt=rsPeriodoAux.Pvalor> 
    </cfif>
    <cfset LvarFecha='#LvarPeriodoAux#-#LvarMesAux#-01'>
    <cfset LvarFechaAnt='#LvarPeriodoAuxAnt#-#LvarMesAuxAnt#-01'>

	<cfquery name="rsPeriodoCont" datasource="#Session.DSN#">
        select Pvalor 
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 30
    </cfquery>
    
    <cfquery name="rsMesCont" datasource="#Session.DSN#">
        select Pvalor 
        from Parametros
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
        and Pcodigo = 40
    </cfquery>
    
    <cfset LvarPeriodoCont=rsPeriodoCont.Pvalor>
    <cfset LvarMesCont=rsMesCont.Pvalor>
    <cfset LvarFechaCont='#LvarPeriodoCont#-#LvarMesCont#-01'>
    
    <!---Trae la moneda local--->
    <cfquery name="rsMonedaEmpresa" datasource="#Session.DSN#">
        select Mcodigo, Edescripcion as nameEmpr from Empresas 
        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
    </cfquery>
<cfset empresaNombre=rsMonedaEmpresa.nameEmpr>

    <cfif rsMonedaEmpresa.Mcodigo neq rsDatos.Mcodigo>
        <cfquery name="rsTipoCambio" datasource="#session.DSN#">
            select Mes,TCEtipocambio,TCEtipocambioventa,TCEtipocambioprom
            from TipoCambioEmpresa 
            where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
              and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarPeriodoAuxAnt#">
              <!---and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#LvarMesAux#">--->
              and Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatos.Mcodigo#">
              order by Mes desc
        </cfquery>
        <cfset LvarTC= rsTipoCambio.TCEtipocambio>
    <cfelse>
        <cfset LvarTC= 1>
    </cfif>                  

    
<!--- 	CONSULTA DE ENCABEZADO --->
<cfset Aplicar = "">
<cfif modo neq "ALTA">
	<cfset varCBesTCE=0>
		<cfif isdefined('LvarTCE')><!---  varTCE  indica si el query es para TCE o bancos--->
				<cfset varCBesTCE=1>
		</cfif>
	<cfquery datasource="#Session.DSN#" name="rsForm">
		select 
			a.EMid, 
			a.ts_rversion, 
			a.EMdocumento, 
			a.EMusuario,
			a.EMdescripcion, 
			a.EMfecha, 
			a.BTid, 
			b.Bid, 
			b.Ocodigo, 
			b.CBid, 
			b.CBcodigo, 
			b.CBdescripcion, 
			c.Mcodigo, 
			c.Mnombre, 
			a.EMtipocambio, 
			a.EMreferencia, 
			a.EMtotal,
			a.SNid,
			a.SNcodigo,
			a.id_direccion,
			coalesce(a.TpoSocio,0) as TpoSocio,
			a.TpoTransaccion,
			a.Documento,
			d.BTtipo,
			a.CDCcodigo	
		from EMovimientos a
			inner join CuentasBancos b
				on b.Ecodigo	=	a.Ecodigo
				and b.CBid		=	a.CBid
			inner join  Monedas c
				on c.Ecodigo 	= 	b.Ecodigo
				and c.Mcodigo 	=	b.Mcodigo
			inner join  BTransacciones d
				on a.Ecodigo 	= 	d.Ecodigo
				and a.BTid   	=	d.BTid	
		where a.EMid 			= 	<cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
        and b.CBesTCE           =   <cfqueryparam value="#varCBesTCE#" cfsqltype="cf_sql_bit"> 
		and a.Ecodigo			=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	</cfquery>
	<!--- 	CONSULTA SI EL MOVIMIENTO TIENE LINEAS PARA PERMITIR APLICAR --->
	<cfquery datasource="#Session.DSN#" name="rsFormLineas">
		select 1 as lineas 
		from DMovimientos
		  where EMid = <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric">
	</cfquery>
	<cfif rsFormLineas.recordcount GT 0>
		<cfset Aplicar = ", Aplicar, Imprimir">
	</cfif>
</cfif>

	<!--- 	TRANSACCIONES BANCARIAS --->
	<cfset varCBesTCE=0><!---  varTCE  indica si es para para TCE o bancos--->
		<cfif isdefined('LvarTCE')>
			<cfset varCBesTCE=1>
		</cfif>
		
<cfquery datasource="#Session.DSN#" name="rsBTransacciones">
	select BTid, BTtipo, 
			case 
				when BTtipo = 'C' then '-CR: ' else '+DB: '
			end
			<cf_dbfunction name="OP_concat">
			BTdescripcion
			as BTdescripcion
	from BTransacciones
	where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
	and BTtce=<cfqueryparam value="#varCBesTCE#" cfsqltype="cf_sql_bit" >
	order by 2 desc
</cfquery>

<!--- 	BANCOS --->
<cfquery datasource="#Session.DSN#" name="rsBancos">
	select Bid, Bdescripcion 
	from Bancos 
	where Ecodigo	=	<cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
    and Bid = #rsDatos.Bid#
	order by 2
</cfquery>

<!--- 	CONSULTA DEL DETALLE --->
<cfif modo neq "ALTA" and rsForm.TpoSocio eq 0>
	
		<cfquery datasource="#Session.DSN#" name="rsDForm">	
			select a.EMid, a.DMlinea, a.ts_rversion, 
				a.DMdescripcion, a.Ccuenta,a.CFcuenta, a.DMmonto, 
				b.Cformato, b.Cdescripcion, 
				c.CFid, c.CFcodigo, c.CFdescripcion
				,cpt.TESRPTCid, cpt.SNid, cpt.TESBid, cpt.CDCcodigo
			from DMovimientos a
				inner join CContables b
					on b.Ccuenta = a.Ccuenta
				left outer join CFuncional c
					on c.CFid = a.CFid
				left join TESRPTcontables cpt
					 on cpt.EMid	= a.EMid
					and cpt.Dlinea	= a.DMlinea
			where a.EMid    			= <cfqueryparam value="#Form.EMid#" cfsqltype="cf_sql_numeric"> 
				and a.Ecodigo			= <cfqueryparam value="#Session.Ecodigo#" cfsqltype="cf_sql_integer" >
		</cfquery>

</cfif>
<!--- 	CONTABILIZACION MANUAL O AUTOMÁTICA 
		CONTABILIZAR AUTOMATICAMENTE (Pvalor = N) IMPLICA REQUERIR EL CF Y NO LA CUENTA Y VICEVERSA
--->
<cfquery name="rsIndicador" datasource="#session.DSN#">
	select Pvalor from Parametros 
	where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype="cf_sql_integer" >	
		and Pcodigo = 2 
</cfquery>
<cfset ContabilizaAutomatico = false>
<cfif rsIndicador.recordcount gt 0 and rsIndicador.Pvalor eq "N">
	<cfset ContabilizaAutomatico = true>
</cfif>

<cfoutput>
<cf_htmlReportsHeaders title="" filename="MovimientoPerioroAnterior#session.usucodigo#.xls" irA="javascript:window.close();" download="yes" preview="no">
<style>
 .encabezado td
 {
	border-bottom:1px solid ##fafafa;
	background:##D7DCE0;
 }
 .detalle td
 {
	border-bottom:1px solid ##D7DCE0;
 }
 .detalle .par
 {
	background:##fafafa;
 }
 .detalle .non
 {
	background:##fff;
 }
</style>
<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="1" style="border:0px;">
	<tr>
		<td>
			<table width="60%" align="center" cellpadding="0" cellspacing="0" border="0">
				<tr>
					<td align="center"><span style="font-size:18px;font-weight:bold;">#empresaNombre#</span></td>
				</tr>
				<tr>
					<td align="center"><span style="font-size:14px;font-weight:bold;">Reporte Movimiento Periodo Anterior</span></td>
				</tr>
				<tr>
					<td align="center"><span style="font-size:11px;font-weight:bold;">Fecha:&nbsp;#LSDateFormat(Now(),'dd/mm/yyyy')#</span></td>
				</tr>
				<tr>
					<td align="center">&nbsp;</td>
				</tr>				
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table width="98%" align="center"  border="0" cellspacing="0" cellpadding="1" style="border:0px;">
				<tr>
					<td class="subTitulo" align="center" bgcolor="##f5f5f5">Encabezado del Movimiento</td>
				</tr>
			</table>
			<table width="98%" class="encabezado" border="0" cellspacing="0" cellpadding="1" align="center" style="border:0px; background:lightgray;">
				<tr>
					<td><strong>Documento:&nbsp;</strong></td><td nowrap >#rsForm.EMdocumento#</td>
					<td><strong>Descripci&oacute;n:&nbsp;</strong></td><td nowrap>#rsForm.EMdescripcion#</td>	
					<td><strong>Fecha:&nbsp;</strong></td>
					<td nowrap>
						<cfif modo neq "ALTA">
							#LSDateFormat(rsForm.EMfecha,'dd/mm/yyyy')#
						<cfelse>
							#LSDateFormat(LvarFechaAnt,'dd/mm/yyyy')#
						</cfif>
					</td>
				</tr>
				<tr>
					<td colspan="1"><strong>Transacci&oacute;n Bco:&nbsp;</strong></td>
					<td colspan="3" nowrap>
						<cfloop query="rsBTransacciones">
							<cfif modo neq "ALTA" and rsForm.BTid eq rsBTransacciones.BTid><span  title="#rsBTransacciones.BTtipo#">#rsBTransacciones.BTdescripcion#</span></cfif>
						</cfloop>
					</td>
					<td><strong>Banco:&nbsp;</strong></td>
					<td nowrap>#rsBancos.Bdescripcion#</td>
				</tr>
				<tr>					
					<td><strong>Cuenta Bancaria:&nbsp;</strong></td>
					<td nowrap>#rsDatos.CBcodigo# #rsDatos.CBdescripcion#</td>	
					<td><strong>Moneda:&nbsp;</strong></td>
					<td nowrap>#rsDatos.Mnombre#</td>
					<td><strong>Tipo de Cambio:&nbsp;</strong></td>
					<td nowrap>
						<cfif isdefined('LvarTCE') AND LEN(TRIM(#LvarTCE#)) GT 0>	<!--- CON TARJETAS DE CREDITO--->
							
								<cfquery name="rsTipoCambioTCE" datasource="#session.dsn#">
									 select round(coalesce((case when cb.Mcodigo = e.Mcodigo then 1.00 else tc.TCcompra end), 1.0000),4) as EMtipocambio
									from CuentasBancos cb 
											inner join Moneda mo
												on cb.Mcodigo=mo.Mcodigo
										  inner join CBTarjetaCredito tj
												on cb.CBTCid = tj.CBTCid
										 inner join DatosEmpleado de
				
												on tj.DEid=de.DEid
										 inner join Empresas e
												on e.Ecodigo = cb.Ecodigo
										left outer join Htipocambio tc
												on 	tc.Ecodigo = cb.Ecodigo
										and tc.Mcodigo = cb.Mcodigo
										and tc.Hfecha  <= <cfqueryparam value="#rsForm.EMfecha#" cfsqltype="cf_sql_date">
										and tc.Hfechah >  <cfqueryparam value="#rsForm.EMfecha#" cfsqltype="cf_sql_date">                                  
									 where cb.Ecodigo=#session.Ecodigo# 
											and cb.CBesTCE = 1 
											and cb.CBid =<cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	  
								</cfquery>
					
								#rsTipoCambioTCE.EMtipocambio#	
						<cfelse>	
							<!--- CON CUENTAS BANCARIAS--->
							#LvarTC# 
						</cfif>	
					</td>
				</tr>
				<tr>
					<td><strong>Tipo:&nbsp;</strong></td>
					<td nowrap>
						<cfif modo eq "ALTA">
							Bancos
						<cfelse>
							<cfif len(trim(Aplicar))>
								<cfswitch expression="#rsForm.TpoSocio#">
									<cfcase value="0">
										Bancos
									</cfcase>
									<cfcase value="1">
										Movimientos Cliente
									</cfcase>
									<cfcase value="2">
										Movimientos Proveedor
									</cfcase>
									<cfcase value="3">
										Mov. Documentos Proveedor
									</cfcase>
									<cfcase value="4">
										Mov. Documentos Proveedor
									</cfcase>
								</cfswitch>
							<cfelse>
								<cfif rsForm.TpoSocio eq 0> Bancos</cfif>
								<cfif rsForm.TpoSocio eq 1> Cliente</cfif>
								<cfif rsForm.TpoSocio eq 2> Proveedor</cfif>
							</cfif>
						</cfif>	</td>
					<td nowrap><strong>Referencia:&nbsp;</strong></td>
					<td nowrap>#rsForm.EMreferencia#</td>
					<td nowrap><strong>Total:</strong></td>
					<td>
						#rsForm.EMtotal#
					</td>
				</tr>
			</table>
			
			
			
		</td>
	</tr>
	<tr>
		<td>&nbsp;</td>
	</tr>
	<!---- Detalle del  reporte --->
	<tr>
		<td>
			<table width="98%" align="center" class="detalle"  border="0" cellspacing="0" cellpadding="1" style="border:0px;">
				<tr bgcolor="##D7DCE0">
					<td><b>Descripci&oacute;n</b></td>
					<td><b>Cuenta</b></td>
					<td><b>Descripci&oacute;n</b></td>
					<td align="center"><b>Monto</b></td>
				</tr>	
				<cfset parnon=1>
				<cfloop query="rsDForm">
					<tr class="<cfif parnon eq 1>non<cfset parnon=0><cfelse>par<cfset parnon=1></cfif>">
						<td>#DMdescripcion#</td>
						<td>#Cformato#</td>
						<td>#CFdescripcion#</td>
						<td align="right">#DMmonto#</td>
					</tr>
				</cfloop>
			</table>
		</td>
	</tr>
	<!--- fin detalle reporte--->
</table>



	

</cfoutput>