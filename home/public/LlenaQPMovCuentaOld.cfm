<cfoutput>Inicio del proceso...</cfoutput> <br>

<cfset LvarEcodigo = 1> <!--- 1 Desarrollo, 2 Producción --->

<cfquery name="rsDatosVenta" datasource="#session.dsn#">
		select
			c.QPcteDireccion,
			c.QPcteCorreo,
			c.QPcteTelefono1,
			c.QPcteTelefono2,
			a.QPvtaTagPlaca,
			d.QPTEstadoActivacion,
			a.QPvtaTagFecha,
			s.QPctaSaldosSaldo,
			a.QPvtaTagid,
			a.QPvtaConvid,
			u.Usulogin,
			case s.QPctaSaldosTipo when 2 then 'Prepago' when 1 then 'PostPago' else '' end as QPctaSaldosTipo,			
			((
				select min(b.QPctaBancoNum)
				from QPcuentaBanco b 
				where b.QPctaBancoid = s.QPctaBancoid
			)) as QPctaBancoNum
			,
			d.QPTPAN,
			c.QPcteDocumento,
			c.QPcteNombre,
			o.Odescripcion,
			a.BMFecha,   
			a.QPvtaAutoriza,
			a.Ecodigo,             
			a.QPTidTag,        
			a.QPcteid,        
			a.QPctaSaldosid,  
			a.Ocodigo,        
			a.BMusucodigo,
			a.QPvtaEstado 
		from QPventaTags a
			inner join QPassTag d
				on d.QPTidTag = a.QPTidTag

			inner join QPcliente c 
				on c.QPcteid = a.QPcteid 

			inner join QPcuentaSaldos s
				on s.QPctaSaldosid = a.QPctaSaldosid 

			inner join Oficinas o
				on o.Ecodigo = a.Ecodigo
				and o.Ocodigo = a.Ocodigo

			inner join Usuario u
				on a.BMusucodigo = u.Usucodigo
			inner join DatosPersonales p
				on p.datos_personales = u.datos_personales
		where a.Ecodigo = #LvarEcodigo#
		  and a.QPvtaEstado = 1
	</cfquery>

 <cfloop query="rsDatosVenta">
    <!--- Inserta en la tabla QPMovCuenta todas las causas marcadas como venta --->
    <cfquery name="rs" datasource="#session.DSN#">
        select 
            co.QPvtaConvid,
            a.QPCid, 
            a.QPCdescripcion, 
            a.QPCmonto,
            a.Mcodigo,
            co.QPvtaConvTipo <!--- 1: PostPago, 2: PrePago --->
        from QPventaConvenio co
            inner join QPCausaxConvenio c
                on co.QPvtaConvid = c.QPvtaConvid
    
            inner join  QPCausa a
                on a.QPCid = c.QPCid
    
        where co.QPvtaConvid = #rsDatosVenta.QPvtaConvid#
          and a.Ecodigo = #LvarEcodigo#
          and a.QPCtipo = 4		<!--- Solamente rubros que correspondan a cargos por venta --->
    </cfquery>
    <cftransaction>
        <cfloop query="rs">
            <cfif len(trim(rs.QPCid)) LT 1>
                <cfreturn 0>
            </cfif>
            
            <cfset LvarQPCid = rs.qPCid>
            <cfset LvarQPCdescripcion = rs.QPCdescripcion>
            <cfset LvarQPCmonto = rs.QPCmonto>
            <cfset LvarMcodigo= rs.Mcodigo>
            
            <!--- Obtiene el movimiento que contiene la categoría marcada para la importación de movimientos de Autopostas del Sol (ADS) --->
            <cfquery name="rsMovimiento" datasource="#session.DSN#">
                select min(QPMovid) as QPMovid
                from QPCausaxMovimiento
                where Ecodigo = #LvarEcodigo#
                and QPCid = #LvarQPCid# <!--- indica si la causa es la que se usa en la importación de movimientos de Autopostas del Sol (ADS) --->
            </cfquery>
            <cfset LvarQPMovid = rsMovimiento.QPMovid>
    
            <!--- <cfdump var="#rsMovimiento#"> --->
            <cf_dbfunction name="op_concat" returnvariable="_Cat">
            <!--- <cfquery datasource="#session.DSN#">
                insert into QPMovCuenta 
                (
                    QPCid,     
                    QPctaSaldosid,
                    QPcteid,         
                    QPMovid,       
                    QPTidTag,     
                    QPMCFInclusion, 
                    QPMCFProcesa,  
                    QPMCFAfectacion,
                    Mcodigo,         
                    QPMCMonto,  
                    QPMCMontoLoc, 
                    BMFecha,
                    QPTPAN,
                    QPMCdescripcion  
                 )
                values(
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarQPCid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosVenta.QPctaSaldosid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric"   value="#rsDatosVenta.QPcteid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#LvarQPMovid#">,
                    <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsDatosVenta.QPTidTag#">,
                    #now()#,
                    null,
                    null,
                    #LvarMcodigo#,
                    <cfqueryparam cfsqltype="cf_sql_money" value="#LvarQPCmonto * -1#">,
                    0,
                    #now()#,
                    <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosVenta.QPTPAN#">,
                    'Venta TAG' #_Cat# ' ' #_Cat# '#rsDatosVenta.QPTPAN#'
                )
            </cfquery> --->
            
            <cfquery name="rsdebug" datasource="#session.DSN#">
            	select 
		            #LvarQPCid# as LvarQPCid,
                    #rsDatosVenta.QPctaSaldosid# as QPctaSaldosid,
                    #rsDatosVenta.QPcteid# as QPcteid,
                    #LvarQPMovid# as LvarQPMovid,
                    #rsDatosVenta.QPTidTag# as QPTidTag,
                    #now()# as QPMCFInclusion,
                    null as QPMCFProcesa,
                    null as QPMCFAfectacion,
                    #LvarMcodigo# as Moneda,
                    #LvarQPCmonto * -1# as LvarQPCmonto,
                    0 as QPMCMontoLoc,
                    #now()# as BMFecha,
                    '#rsDatosVenta.QPTPAN#' as QPTPAN,
                    'Venta TAG' #_Cat# ' ' #_Cat# '#rsDatosVenta.QPTPAN#' as QPMCdescripcion
                    
                from dual
            </cfquery>
             <cfdump var="#rsdebug#">
            <!--- ********************************************************************************************************************************** --->
        </cfloop>
        <cftransaction action="commit"/>
    </cftransaction>
    <!--- Llama a QPAfectaSaldos para que procese los movimientos --->
    <!--- <cfinvoke component="sif.QPass.Componentes.QPAfectaSaldos" returnvariable="Resultado" method="ProcesaMovimiento">
        <cfinvokeargument name="Conexion" value="minisif">
    </cfinvoke>
    
    <!--- Se pone la fecha de hoy en el parametro para que no los considere en el DTS y no mande los montos a Bloquear por que ya fueron rebajados --->
    <cfquery name="rsParametro" datasource="#session.DSN#">
        select Pvalor
        from QPParametros
        where Ecodigo = #LvarEcodigo#
          and Pcodigo = 9998
    </cfquery>
    
    <cftransaction>
		<cfif rsParametro.recordcount eq 0>
            <cfset LvarFechaDesde = createdate(2009, 7, 9)>
            <cfquery datasource="#session.DSN#">
                insert QPParametros (Ecodigo, Pcodigo, Pvalor, Pdescripcion, Mcodigo)
                values (#LvarEcodigo#, 9998, #LvarFechaDesde#, 'Hora de la ultima ejecucion de Transferencias con el Banco', 'QP')
            </cfquery>
        <cfelse>
            <cfset LvarFechaDesde = createdate(2009, 7, 9)>
            <cfquery datasource="#session.DSN#">
                update QPParametros 
                set Pvalor =  #LvarFechaDesde#
                where Ecodigo = #LvarEcodigo#
                  and Pcodigo = 9998
            </cfquery>
        </cfif>
        <cftransaction action="commit"/>
	</cftransaction> --->
</cfloop> 
<cfoutput>Fin del proceso</cfoutput>   
