<!---Bandera que impide que el exportador de Archivo de nomina haga submit para lanzar el Archivo a pantalla--->
<cf_navegacion name="NoRecargar" default="true">
<cf_navegacion name="Action" default="">
<cf_navegacion name="Param" default="">
<cf_navegacion name="ERNid">
<cf_navegacion name="Doc">
<cf_navegacion name="EIid">
<cf_navegacion name="Fecha">
<cf_navegacion name="DocComision">
<cf_navegacion name="MontoComision">
<cf_dbfunction name="OP_concat"	returnvariable="_Cat">
<cfset LvarTC = 1.00>

<!---►►Busca el pago de nomina en Bancos◄◄--->
<cfquery name="rsDocBancos" datasource="#session.dsn#">
    select EMid, EMdocumento, EMreferencia
        from EMovimientos 
    where ERNid = #form.ERNid#
      and EIid  = #form.EIid#
</cfquery>

<cfquery name="rsNominas" datasource="#session.dsn#">
    select no.ERNid,no.Ecodigo, no.RCNid, tn.Tdescripcion, cp.CPdesde, cp.CPhasta , no.Bid, 
        Coalesce(em.ERNid,0) Generado,
        Coalesce(no.BMUsucodigo,#session.Usucodigo#) as BMUsucodigo, ba.CBid, ba.Ocodigo, 
        tn.Tdescripcion as EMdescripcion,
        <cf_dbfunction name="now"> as FechaPago,
        0 as TpoSocio,1 as TipoCambio,'#session.Usulogin#' as EMusuario,no.HERNdescripcion as EMreferencia,
        no.Tcodigo,
        cp.CPcodigo,
        tn.Mcodigo,
        -1 as CFid,
        -1 as EMselect,
        -1 as CDCcodigo,
        -1 as SNcodigo,
        -1 as id_direccion,
        -1 as SNid,
        -1 as TpoTransaccion
        
        from HERNomina no
            inner join TiposNomina tn 
                on tn.Ecodigo  = no.Ecodigo
               and tn.Tcodigo  = no.Tcodigo
            inner join CalendarioPagos cp
                on cp.CPid     = no.RCNid  
            inner join CuentasBancos ba
                on ba.CBcc = no.CBcc
            left outer join EMovimientos em
                on em.ERNid = no.ERNid
    where no.Ecodigo = #session.Ecodigo#
      and no.ERNid   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERNid#">
</cfquery>


<cfset LvarDoc = "#trim(rsNominas.Tcodigo)#:#trim(rsNominas.CPcodigo)#">
<!---Transaccion Bancaria pago de Salarios--->
<cfinvoke component="sif.Componentes.Parametros" method="Get" returnvariable="Param15780">
    <cfinvokeargument name="Pcodigo" value="15780">
    <cfinvokeargument name="Default" value="-1">
</cfinvoke>
<!---Generar Movimiento Bancario de Nomina Resumido o lineas por Empleado/Cuenta--->
<cfinvoke component="sif.Componentes.Parametros" method="Get" returnvariable="Param15781">
    <cfinvokeargument name="Pcodigo" value="15781">
    <cfinvokeargument name="Default" value="N">
</cfinvoke>
<cfif not len(trim(Param15780)) or Param15780 EQ -1>
    <cfthrow message="No se ha Definido el parametro 15780: Transacción para Pago de Salarios">
</cfif>
<!---Se Busca los exportadores bancarios de nomina--->
<cfquery name="rsExportadores" datasource="#session.dsn#">
select a.EIid, b.Bdescripcion, a.RHEdescripcion, ei.EIcfexporta, ei.EIcodigo, a.RHComisionBancaria
    from RHExportaciones a
        inner join Bancos b
            on b.Bid = a.Bid
        inner join <cf_dbdatabase table="EImportador" datasource="sifcontrol"> ei
            on ei.EIid = a.EIid
    where a.Ecodigo = #session.Ecodigo#
      and a.Inactivo <> 1 
      and a.EIid = #form.EIid#
</cfquery>
<cfset url.Bid 			  = rsNominas.Bid>
<cfset URL.estado 	 	  = 'h'>
<cfset URL.UpdateParam210 = false>
<cfset url.EIid = rsExportadores.EIid>

<cfinclude template="#rsExportadores.EIcfexporta#">

<!---►►Generar y Regenerar◄◄--->
<cfif ListFind('G,R',form.Action)>
   
    <!---►►Crea tabla Temportal para Distribucion de los Gastos, Integracion con Tesoreria◄◄--->
    <cfinvoke component="rh.Componentes.RH_PagoNomina" method="CrearTemporalTesoreria" returnvariable="tmpDistribucionTES"/>
     
    <!---►►Se genera la distribucion de las deducciones entre las cuentas de gasto◄◄---> 
    <cfinvoke component="rh.Componentes.RH_PagoNomina" method="GeneraDistribucionTesoreria">
    	<cfinvokeargument name="Tabla"     value="#tmpDistribucionTES#">
        <cfinvokeargument name="ERNid" 	   value="#form.ERNid#">
        <cfinvokeargument name="Detallado" value="#Param15781 EQ 'N'#">
        <cfinvokeargument name="DEids" 	   value="#ValueList(rsEmpleados.DEid)#">
        <cfinvokeargument name="EIid" 	   value="#form.EIid#">
        <cfinvokeargument name="Bid" 	   value="#rsNominas.Bid#">
        <cfinvokeargument name="RCNid"       value="#rsNominas.RCNid#">
        <cfif isdefined('URL.ForzarDEid')>
            <cfinvokeargument name="ForzarDEid"        value="#URL.ForzarDEid#">
        </cfif>
    </cfinvoke>

 	<!---►Obtiene todos las lineas de detalles◄◄--->
   	<cfif Param15781 EQ 'S'>
   		<cfquery name="rsTmpPagoSalario" datasource="#session.dsn#">
            select Ccuenta,CFcuenta, CFid, Dcodigo, SUM(MontoLiquido) as DMmonto, -1 as PCGDid , Descripcion as DMdescripcion
            from #tmpDistribucionTES#
            group by Ccuenta,CFcuenta, CFid, Dcodigo, Descripcion
        </cfquery>
   	<cfelse>
       <cfquery name="rsTmpPagoSalario" datasource="#session.dsn#">
            select Ccuenta,CFcuenta, CFid, Dcodigo, MontoLiquido as DMmonto, -1 as PCGDid , Descripcion as DMdescripcion
            from #tmpDistribucionTES#
       </cfquery>
   	</cfif>

   <cfquery name="rsDetalle" dbtype="query">
    	select SUM(DMmonto) as Total
        from rsTmpPagoSalario
   </cfquery>
   
   <!---Codigos de Bancos Adicionales--->
    <cfquery name="rsAddBancos" datasource="#session.DSN#">
        Select Bid_add
        from RHExportacionBancos 
        where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
        and EIid in (<cfqueryparam cfsqltype="cf_sql_numeric" value="#url.EIid#" list="yes">)
    </cfquery>
    
    <cfif isdefined("rsAddBancos.Bid_add") and len(trim( valueList(rsAddBancos.Bid_add)))>
        <cfset vBids = valueList(rsAddBancos.Bid_add)>
    <cfelse>
        <cfset vBids = url.Bid >
    </cfif>
    <!---►►NOMINA: Obtienen el total den Encabezado, deberia ser siempre igual◄◄--->
    <cfquery datasource="#session.dsn#" name="rsEncabezado">
        select SUM(a.montores *(deb.LCporc/100)) as  Total
        	from RCuentasTipo a
				left outer join HLiquidoCalculo deb
					on deb.DEid = a.DEid 
					and deb.RCNid = a.RCNid
					and deb.Bid in (<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#vBids#">)
				inner join CFinanciera b
					on b.CFcuenta = a.CFcuenta
				inner join DatosEmpleado c
					on c.DEid = a.DEid
				left outer join CIncidentes d
					on d.CIid = a.referencia
        where a.DEid in (#ValueList(rsEmpleados.DEid)#)
		  and (select Count(1)	
		  		from #tmpDistribucionTES# d
					where d.DEid  = a.DEid 
				   and d.RCNid = a.RCNid
				) > 0
          and a.tiporeg in (80,85) <!---►►Salario Liquido◄◄--->
          and a.RCNid = (select RCNid 
          				from HERNomina 
                       where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERNid#">)
         
    </cfquery>
 
 	<cfif ABS(rsDetalle.Total - rsEncabezado.Total) GT 0.01>
    	<cfquery name="rsTmpPagoSalario" datasource="#session.dsn#">
            select a.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2, SUM(a.MontoBruto) MontoBruto, SUM(a.MontoDeducir) MontoDeducir, SUM(a.MontoLiquido) MontoLiquido, 
            (select SUM(b.montores *(deb.LCporc/100)) as  Total
				from RCuentasTipo b 
					left outer join HLiquidoCalculo deb
						on deb.DEid = b.DEid 
					   and deb.RCNid = b.RCNid
          			   and deb.Bid in (<cfqueryparam list="yes" cfsqltype="cf_sql_numeric" value="#vBids#">)
			 where b.DEid = a.DEid 
			   and b.RCNid = a.RCNid 
			   and b.tiporeg in (80,85)) MontoRealLiquido
            from #tmpDistribucionTES# a 
				inner join DatosEmpleado de
					on de.DEid = a.DEid
            group by a.RCNid, a.DEid, de.DEidentificacion, de.DEnombre, de.DEapellido1, de.DEapellido2
       	</cfquery>

        <cfoutput>
             <table>
                    <tr>
                        <td colspan="4">
                           <strong> La Suma de los Salarios menos deducciones es de (#LSNumberFormat(rsDetalle.Total,'999,999,999.999')#), distinto a la suma de salario liquidos (#LSNumberFormat(rsEncabezado.Total,'999,999,999.999')#) , DIferencia {#LSNumberFormat(rsDetalle.Total - rsEncabezado.Total,'999,999,999.999')#)}</strong>
                        </td>
                    </tr>
                    <tr>
						<td>Empleado</td>
                    	<td>Monto Bruto</td>
                        <td>Monto Deducir</td>
                        <td>Monto Liquido</td>
                        <td>Monto Pagado</td>
                        <td>Diferencia</td>
                    </tr>
                <cfloop query="rsTmpPagoSalario">
					<cfif rsTmpPagoSalario.MontoLiquido - rsTmpPagoSalario.MontoRealLiquido NEQ 0>
						<tr>
							<td>#rsTmpPagoSalario.DEidentificacion#-#rsTmpPagoSalario.DEnombre# #rsTmpPagoSalario.DEapellido1# #rsTmpPagoSalario.DEapellido2#</td>
							<td>#LSNumberFormat(rsTmpPagoSalario.MontoBruto,'999,999,999.999')#</td>
							<td>#LSNumberFormat(rsTmpPagoSalario.MontoDeducir,'999,999,999.999')#</td>
							<td>#LSNumberFormat(rsTmpPagoSalario.MontoLiquido,'999,999,999.999')#</td>
							<td>#LSNumberFormat(rsTmpPagoSalario.MontoRealLiquido,'999,999,999.999')#</td>
							<td>#LSNumberFormat(rsTmpPagoSalario.MontoLiquido - rsTmpPagoSalario.MontoRealLiquido,'999,999,999.999')#</td>
						</tr>
					</cfif>
                </cfloop>
             </table>
		
        </cfoutput>
        <cfabort>
    </cfif>

    <cfif rsExportadores.RHComisionBancaria EQ 1>
        <cfquery name="rsCuentaBancaria" datasource="#Session.DSN#">
            select Ecodigo, Ocodigo, 
            Mcodigo, Ccuenta, Ccuentacom, CFcuentacom
            from CuentasBancos
            where Ecodigo = #Session.Ecodigo#
              and CBid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsNominas.CBid#">
              and Bid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsNominas.Bid#">
              and CBesTCE = <cf_jdbcquery_param cfsqltype="cf_sql_bit" value="0">               
        </cfquery>

        <cfif Len(Trim(rsCuentaBancaria.CFcuentacom)) or Len(Trim(rsCuentaBancaria.Ccuentacom))>
            <cfquery name="rsCuentaComision" datasource="#Session.DSN#">
                select CFcuenta, Ccuenta, CFdescripcion, CFformato, Ecodigo from CFinanciera
                where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
                  <cfif Len(Trim(rsCuentaBancaria.CFcuentacom))>
                    and CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaBancaria.CFcuentacom#">
                  <cfelse>
                    and Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCuentaBancaria.Ccuentacom#">
                  </cfif>
            </cfquery>
        <cfelse>
            <cfthrow message="La cuenta de comisión no esta configurada. Verificar el catalogo de Cuentas Bancarias en el Módulo de Bancos">
        </cfif>

        <cfquery name="rsOficina" datasource="#session.DSN#">
            select  min(b.Dcodigo) as Dcodigo, min(b.CFid) as CFid
            from CuentasBancos a 
                inner join CFuncional b
                    on a.Ocodigo = b.Ocodigo
                    and a.Ecodigo = b.Ecodigo
            where a.Ecodigo = #Session.Ecodigo#
              and a.CBid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsNominas.CBid#">
              and a.Bid = <cf_jdbcquery_param cfsqltype="cf_sql_numeric" value="#rsNominas.Bid#">
              and a.CBesTCE = <cf_jdbcquery_param cfsqltype="cf_sql_bit" value="0">    
        </cfquery>
    </cfif>
    
	<cftransaction>
		<cfif ListFind('R',form.Action)>
            <cfinvoke component="sif.Componentes.MB_Banco" method="DropEMovimientos">
                <!--- En caso de que exista comision hay dos registros en rsDocBancos --->
                <cfloop query="rsDocBancos"> 
                    <cfinvokeargument name="EMid" value="#rsDocBancos.EMid#">	
                </cfloop>
            </cfinvoke>
        </cfif>
        <cfinvoke component="sif.Componentes.MB_Banco" method="SetEMovimientos" returnvariable="LvarEMid">
            <cfinvokeargument name="conexion"  		value="#session.dsn#">
            <cfinvokeargument name="Ecodigo"    	value="#rsNominas.Ecodigo#">
            <cfinvokeargument name="Usucodigo" 		value="#rsNominas.BMUsucodigo#">
            <cfinvokeargument name="BTid" 			value="#Param15780#">
            <cfinvokeargument name="CBid"  			value="#rsNominas.CBid#">
            <cfinvokeargument name="CFid"  			value="#rsNominas.CFid#">
            <cfinvokeargument name="Ocodigo"   		value="#rsNominas.Ocodigo#">
            <cfinvokeargument name="EMtipocambio" 	value="#rsNominas.TipoCambio#">
            <cfinvokeargument name="EMdocumento" 	value="#form.Doc#">
            <cfinvokeargument name="EMtotal" 		value="#rsDetalle.Total#">
            <cfinvokeargument name="EMreferencia" 	value="#rsNominas.EMreferencia#">
            <cfinvokeargument name="EMfecha" 		value="#LSParseDateTime(form.Fecha)#">
            <cfinvokeargument name="EMdescripcion" 	value="#rsNominas.EMdescripcion#">
            <cfinvokeargument name="EMusuario"		value="#rsNominas.EMusuario#">
            <cfinvokeargument name="EMselect"  		value="#rsNominas.EMselect#">
            <cfinvokeargument name="TpoSocio"   	value="#rsNominas.TpoSocio#">
            <cfinvokeargument name="CDCcodigo"  	value="#rsNominas.CDCcodigo#">
            <cfinvokeargument name="SNcodigo"  		value="#rsNominas.SNcodigo#">
            <cfinvokeargument name="id_direccion"  	value="#rsNominas.id_direccion#">
            <cfinvokeargument name="TpoTransaccion" value="#rsNominas.TpoTransaccion#">
            <cfinvokeargument name="Documento" 		value="#form.Doc#">
            <cfinvokeargument name="SNid"   		value="#rsNominas.SNid#">
            <cfinvokeargument name="ERNid"   		value="#form.ERNid#">
            <cfinvokeargument name="EIid"   		value="#form.EIid#">
        </cfinvoke>
        <cfloop query="rsTmpPagoSalario">
            <cfinvoke component="sif.Componentes.MB_Banco" method="SetDMovimientos">
                <cfinvokeargument name="conexion"  		value="#session.dsn#">
                <cfinvokeargument name="Ecodigo"    	value="#rsNominas.Ecodigo#">	
                <cfinvokeargument name="Usucodigo" 		value="#rsNominas.BMUsucodigo#">
                <cfinvokeargument name="EMid" 			value="#LvarEMid#">
                <cfinvokeargument name="Ccuenta" 		value="#rsTmpPagoSalario.Ccuenta#">
                <cfinvokeargument name="Dcodigo" 		value="#rsTmpPagoSalario.Dcodigo#">
                <cfinvokeargument name="CFid" 			value="#rsTmpPagoSalario.CFid#">
                <cfinvokeargument name="DMmonto" 		value="#rsTmpPagoSalario.DMmonto#">
                <cfinvokeargument name="DMdescripcion" 	value="#rsTmpPagoSalario.DMdescripcion#">
                <cfinvokeargument name="PCGDid" 		value="#rsTmpPagoSalario.PCGDid#">
                <cfinvokeargument name="CFcuenta" 		value="#rsTmpPagoSalario.CFcuenta#">
            </cfinvoke>
        </cfloop>

        <cfif rsExportadores.RHComisionBancaria EQ 1>
            <!--- En caso de tener RHComisionBancaria inserta en EMovimientos --->
             <cfinvoke component="sif.Componentes.MB_Banco" method="SetEMovimientos" returnvariable="LvarEMidC">
                <cfinvokeargument name="conexion"       value="#session.dsn#">
                <cfinvokeargument name="Ecodigo"        value="#rsNominas.Ecodigo#">
                <cfinvokeargument name="Usucodigo"      value="#rsNominas.BMUsucodigo#">
                <cfinvokeargument name="BTid"           value="#Param15780#">
                <cfinvokeargument name="CBid"           value="#rsNominas.CBid#">
                <cfinvokeargument name="CFid"           value="#rsNominas.CFid#">
                <cfinvokeargument name="Ocodigo"        value="#rsNominas.Ocodigo#">
                <cfinvokeargument name="EMtipocambio"   value="#rsNominas.TipoCambio#">
				
                <cfinvokeargument name="EMdocumento"    value="#form.DocComision#">
                <cfinvokeargument name="EMtotal"        value="#form.MontoComision#">
                <cfinvokeargument name="EMreferencia"   value="Comision">
                <cfinvokeargument name="EMfecha"        value="#LSParseDateTime(form.Fecha)#">
                <cfinvokeargument name="EMdescripcion"  value="#rsNominas.EMdescripcion#">
                <cfinvokeargument name="EMusuario"      value="#rsNominas.EMusuario#">
                <cfinvokeargument name="EMselect"       value="#rsNominas.EMselect#">
                <cfinvokeargument name="TpoSocio"       value="#rsNominas.TpoSocio#">
                <cfinvokeargument name="CDCcodigo"      value="#rsNominas.CDCcodigo#">
                <cfinvokeargument name="SNcodigo"       value="#rsNominas.SNcodigo#">
                <cfinvokeargument name="id_direccion"   value="#rsNominas.id_direccion#">
                <cfinvokeargument name="TpoTransaccion" value="#rsNominas.TpoTransaccion#">
                <cfinvokeargument name="Documento"      value="#form.DocComision#">
                <cfinvokeargument name="SNid"           value="#rsNominas.SNid#">
                <cfinvokeargument name="ERNid"          value="#form.ERNid#">
                <cfinvokeargument name="EIid"           value="#form.EIid#">
            </cfinvoke>

            <cfinvoke component="sif.Componentes.MB_Banco" method="SetDMovimientos">
                <cfinvokeargument name="conexion"       value="#session.dsn#">
                <cfinvokeargument name="Ecodigo"        value="#rsNominas.Ecodigo#">    
                <cfinvokeargument name="Usucodigo"      value="#rsNominas.BMUsucodigo#">
                <cfinvokeargument name="EMid"           value="#LvarEMidC#">
                <cfinvokeargument name="Ccuenta"        value="#rsCuentaComision.Ccuenta#">
                <cfinvokeargument name="Dcodigo"        value="#rsOficina.Dcodigo#">
                <cfinvokeargument name="CFid"           value="#rsOficina.CFid#">
                <cfinvokeargument name="DMmonto"        value="#form.MontoComision#">
                <cfinvokeargument name="DMdescripcion"  value="Comision">
                <cfinvokeargument name="PCGDid"         value="-1">
                <cfinvokeargument name="CFcuenta"       value="#rsCuentaComision.CFcuenta#">
            </cfinvoke>
        </cfif>

        <cfquery datasource="#session.dsn#">
        	update HERNomina 
            	set HERNestado = 6 <!---Enviando Pago--->
          	where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERNid#">
        </cfquery>
    </cftransaction>

<!---►►Aplicar◄◄--->    
<cfelseif ListFind('A,V',form.Action)>
 
    <!---►►Se Crea la tabla de Presupuesto◄◄--->
	<cfinvoke component="sif.Componentes.PRES_Presupuesto" returnvariable="INT_PRESUPUESTO" method="CreaTablaIntPresupuesto" >
        <cfinvokeargument name="conIdentity" value="true" />
    </cfinvoke>
        
	<!---►►Crea tabla Temporal para Distribucion de los Gastos, Integracion con Tesoreria◄◄--->
    <cfinvoke component="rh.Componentes.RH_PagoNomina" method="CrearTemporalTesoreria" returnvariable="tmpDistribucionTES"/>


    <!---►►Se genera la distribucion de las deducciones entre las cuentas de gasto◄◄---> 
    <cfinvoke component="rh.Componentes.RH_PagoNomina" method="GeneraDistribucionTesoreria">
			<cfinvokeargument name="Tabla"     value="#tmpDistribucionTES#">
			<cfinvokeargument name="ERNid" 	   value="#form.ERNid#">
			<cfinvokeargument name="Detallado" value="False">
			<cfinvokeargument name="DEids" 	   value="#ValueList(rsEmpleados.DEid)#">
			<cfinvokeargument name="EIid" 	   value="#form.EIid#">
			<cfinvokeargument name="Bid" 	   value="#rsNominas.Bid#">
            <cfinvokeargument name="RCNid"       value="#rsNominas.RCNid#">
		<cfif isdefined('URL.ForzarDEid')>
			<cfinvokeargument name="ForzarDEid" 	   value="#URL.ForzarDEid#">
		</cfif>
    </cfinvoke>


    <cfquery name="rsDocumentos" datasource="#session.dsn#">
        select RHEnumero, Periodo, Mes, NAP_Compromiso, NapsDesCompromiso,NapsPagadoLiquido,IDcontableLiquido
          from RHEjecucion
         where RCNid = (select RCNid 
                          from HERNomina 
                        where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERNid#">)
        order by Periodo, Mes
    </cfquery>
    <cfoutput>
		<cfsavecontent variable="SaldoNap">
			(select nd.CPNAPDmonto-nd.CPNAPDutilizado
				  from CPNAPdetalle nd
					 where nd.CFcuenta = a.CFcuenta
						and nd.Ocodigo  = a.Ocodigo
						and nd.CPNAPnum = #rsDocumentos.NAP_Compromiso#)
		</cfsavecontent>
	</cfoutput>
  
    <cfquery datasource="#session.dsn#" name="rs">
       
       insert into #Request.intPresupuesto# 
            (
                ModuloOrigen,
                NumeroDocumento,
                NumeroReferencia,
                FechaDocumento,
                AnoDocumento,
                MesDocumento,
                CFcuenta,
                Ocodigo,
                Mcodigo,
                MontoOrigen,
                TipoCambio,
                Monto,
                TipoMovimiento,
				NAPreferencia, 
                LINreferencia
            )
	select 'RHPN', '#LvarDoc#', '#rsDocumentos.Periodo#/#rsDocumentos.Mes#', 
			<cfqueryparam cfsqltype="cf_sql_date" value="#form.Fecha#">, 
			#rsDocumentos.Periodo#, 
            #rsDocumentos.Mes#,
			a.CFcuenta, a.Ocodigo,
			#rsNominas.Mcodigo#, 
            <!---20150831 Si el monto a descomprometer es mayor al saldo del NAP se descompromete dicho saldo, esta situaccion se presenta
            cuando el salario liquido es superior al salario bruto producto de devolucion de dinero (deducciones, renta, CCSS, etc) --->
            case when (sum(round(a.MontoLiquido,2)) > #SaldoNap#) then 
                -#SaldoNap#
            else 
                -sum(round(a.MontoLiquido,2)) 
            end,
            #LvarTC#, 

            case when (sum(round(a.MontoLiquido,2)) > #SaldoNap#)
             then 
                 - (#SaldoNap# *#LvarTC# )
              else 
			  	-sum(round(a.MontoLiquido*#LvarTC#,2)) 
            end,
			'CC',
            #rsDocumentos.NAP_Compromiso# as NAPreferencia,  
			<!---La Linea del Compromiso a referenciar--->
			(select nd.CPNAPDlinea
			  from CPNAPdetalle nd
                 where nd.CFcuenta  = a.CFcuenta
					and nd.Ocodigo  = a.Ocodigo
					and nd.CPNAPnum = #rsDocumentos.NAP_Compromiso#) as LINreferencia
            
        from #tmpDistribucionTES# a
        inner join CFinanciera b1
            on a.CFcuenta = b1.CFcuenta
                and b1.CPcuenta is not null
        group by a.CFcuenta, a.Ocodigo
        <!--- 20160520 Las Linea menores a cero no forman parte del compormiso generado en la finalizacion de la nomina por lo que no se debe hacer el descopromiso --->
        having round(case when (sum(round(a.MontoLiquido,2)) > #SaldoNap#) then 
                #SaldoNap#
                else 
                    sum(round(a.MontoLiquido,2)) 
                end,2) > 0
     </cfquery>


     <!--- <cf_dump var="#rs#"> --->

    
    <cfquery datasource="#session.dsn#" name="rs">
    	select count(1) as ok
        from #Request.intPresupuesto# a
        inner join CFinanciera b
            on a.CFcuenta=b.CFcuenta
            and b.CPcuenta is not null
    </cfquery>
    
	<cftransaction>
    	
		<cfif rs.ok>
            
            <cfinvoke component="sif.Componentes.PRES_Presupuesto"  method="ControlPresupuestario" returnvariable="LvarNAP">
                <cfinvokeargument name="ModuloOrigen"  		value="RHPN"/>
                <cfinvokeargument name="NumeroDocumento" 	value="#LvarDoc#"/>
                <cfinvokeargument name="NumeroReferencia" 	value="Descompromiso:#rsExportadores.EIcodigo#"/>
                <cfinvokeargument name="FechaDocumento" 	value="#form.Fecha#"/>
                <cfinvokeargument name="AnoDocumento"		value="#rsDocumentos.Periodo#"/>
                <cfinvokeargument name="MesDocumento"		value="#rsDocumentos.Mes#"/>
            </cfinvoke>
        <cfelse>
        	<cfset LvarNAP = 0>
	    </cfif>
        
        <cfquery name="rsQuery" datasource="#session.dsn#">
            Update RHEjecucion 
				set NapsDesCompromiso = Coalesce(NapsDesCompromiso,'')
            <cfif LEN(TRIM(rsDocumentos.NapsDesCompromiso))>
            	#_Cat# ','
            </cfif>
            	#_Cat# '#LvarNAP#'
			where RCNid = (select RCNid 
                            from HERNomina 
                           where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERNid#">)
    	</cfquery>


        <!--- <cfif form.Action EQ 'V' >
            pinte
        <cfelseif rsExportadores.RHComisionBancaria EQ 1 and isdefined('form.DOCCOMISION')>
            comision
        <cfelse>
            siempre
        </cfif> --->

        <cfif form.Action EQ 'V' and not isdefined('form.DOCCOMISION')>
           <!---Realiza la aplicacion del movimientos en bancos y genera asiento y presupuesto--->
            <cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
                <cfinvokeargument name="EMid"               value="#rsDocBancos.EMid#"/>
                <cfinvokeargument name="transaccionActiva"  value="True"/> 
                <cfinvokeargument name="PintaAsiento"       value="#form.Action EQ 'V'#"/>
                <cfinvokeargument name="Oorigen"            value="RHPN"/>
                <cfinvokeargument name="ContaAfectaPagado"  value="1"/>
            </cfinvoke> 
        </cfif>

        <cfif form.Action EQ 'V' and isdefined('form.DOCCOMISION')>
            <cfquery name="rsDocComBancos" dbtype="query">
                select EMid, EMdocumento
                    from rsDocBancos 
                where EMreferencia = 'Comision'
            </cfquery> 
       
            <!---Realiza la aplicacion del movimientos en bancos y genera asiento y presupuesto para la comision--->
            <cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
                <cfinvokeargument name="EMid"               value="#rsDocComBancos.EMid#"/>
                <cfinvokeargument name="transaccionActiva"  value="True"/> 
                <cfinvokeargument name="PintaAsiento"       value="#form.Action EQ 'V'#"/>
                <cfinvokeargument name="ContaAfectaPagado"  value="1"/>
            </cfinvoke> 
        </cfif>

        <cfif rsExportadores.RHComisionBancaria EQ 1 and isdefined('form.DOCCOMISION') and form.DOCCOMISION NEQ "">
            <cfquery name="rsDocComBancos" dbtype="query">
                select EMid, EMdocumento
                    from rsDocBancos 
                where EMreferencia = 'Comision'
            </cfquery> 
       
            <!---Realiza la aplicacion del movimientos en bancos y genera asiento y presupuesto para la comision--->
            <cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
                <cfinvokeargument name="EMid"               value="#rsDocComBancos.EMid#"/>
                <cfinvokeargument name="transaccionActiva"  value="True"/> 
                <cfinvokeargument name="PintaAsiento"       value="#form.Action EQ 'V'#"/>
                <cfinvokeargument name="ContaAfectaPagado"  value="1"/>
            </cfinvoke> 

            <!---Realiza la aplicacion del movimientos en bancos y genera asiento y presupuesto--->
            <cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
                <cfinvokeargument name="EMid"               value="#rsDocBancos.EMid#"/>
                <cfinvokeargument name="transaccionActiva"  value="True"/> 
                <cfinvokeargument name="PintaAsiento"       value="#form.Action EQ 'V'#"/>
                <cfinvokeargument name="Oorigen"            value="RHPN"/>
                <cfinvokeargument name="ContaAfectaPagado"  value="1"/>
            </cfinvoke> 
        </cfif>

        <cfif rsExportadores.RHComisionBancaria EQ 0 and not isdefined('form.DOCCOMISION')>
            <!---Realiza la aplicacion del movimientos en bancos y genera asiento y presupuesto--->
            <cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
                <cfinvokeargument name="EMid"               value="#rsDocBancos.EMid#"/>
                <cfinvokeargument name="transaccionActiva"  value="True"/> 
                <cfinvokeargument name="PintaAsiento"       value="#form.Action EQ 'V'#"/>
                <cfinvokeargument name="Oorigen"            value="RHPN"/>
                <cfinvokeargument name="ContaAfectaPagado"  value="1"/>
            </cfinvoke> 
        </cfif>
     

        <!--- <cfif form.Action EQ 'V' and not isdefined('form.DOCCOMISION')>
           <!---Realiza la aplicacion del movimientos en bancos y genera asiento y presupuesto--->
            <cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
                <cfinvokeargument name="EMid" 				value="#rsDocBancos.EMid#"/>
                <cfinvokeargument name="transaccionActiva" 	value="True"/> 
                <cfinvokeargument name="PintaAsiento" 		value="#form.Action EQ 'V'#"/>
                <cfinvokeargument name="Oorigen"            value="RHPN"/>
            </cfinvoke>	
        </cfif>

        <cfif rsExportadores.RHComisionBancaria EQ 1>
             <cfquery name="rsDocComBancos" dbtype="query">
                select EMid, EMdocumento
                    from rsDocBancos 
                where EMreferencia = 'Comision'
            </cfquery> 
       
            <!---Realiza la aplicacion del movimientos en bancos y genera asiento y presupuesto para la comision--->
            <cfinvoke component="sif.Componentes.CP_MBPosteoMovimientosB" method="PosteoMovimientos">
                <cfinvokeargument name="EMid"               value="#rsDocComBancos.EMid#"/>
                <cfinvokeargument name="transaccionActiva"  value="True"/> 
                <cfinvokeargument name="PintaAsiento"       value="#form.Action EQ 'V'#"/>
            </cfinvoke> 
        </cfif> --->

        
 
		<cfif isdefined('Request.LvarIDcontableGenerado')>
            <cfquery name="rsQuery" datasource="#session.dsn#">
                Update RHEjecucion 
                    set NapsPagadoLiquido = Coalesce(NapsPagadoLiquido,'')
                <cfif LEN(TRIM(rsDocumentos.NapsPagadoLiquido))>
                    #_Cat# ','
                </cfif>
                    #_Cat# <cf_dbfunction name="to_char" args="(select x.NAP from EContables x where x.IDcontable = #Request.LvarIDcontableGenerado#)">
                where RCNid = (select RCNid 
                                from HERNomina 
                               where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERNid#">)
            </cfquery>   
			<cfquery name="rsQuery" datasource="#session.dsn#">
				Update RHEjecucion 
					set IDcontableLiquido = Coalesce(IDcontableLiquido,'')
				<cfif LEN(TRIM(rsDocumentos.IDcontableLiquido))>
					#_Cat# ','
				</cfif>
					#_Cat# '#Request.LvarIDcontableGenerado#'
				where RCNid = (select RCNid 
								from HERNomina 
							   where ERNid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.ERNid#">)
    		</cfquery>	
		<cfelse>
			<cfthrow message="No se pudo recuperar el Id contable del Salario liquido">
		</cfif>
    
    </cftransaction>
<!---►►Ninguna Accion◄◄--->
<cfelse>

</cfif>
<cfoutput>
<cflocation addtoken="no" url="ConfirmPago.cfm?#Param#">
</cfoutput>