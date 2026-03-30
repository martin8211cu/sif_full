<cfif not fnObtieneDatosConvenio(url.QPvtaTagid)>
	<script language="javascript1.2" type="text/javascript">
			alert('No hay datos');
			location.href = 'QPassVenTemp.cfm?_';
	</script>
	<cfabort>
</cfif>
<!--- <cfdump var="#rsDatosVenta#"> --->
<cfset fnImprimeConvenio(#session.dsn#,#url.QPvtaTagid#)>

<html>
<head>
<style>
	@media print {
		.noprint 
		{
			display: none;
		}
	}
	a { text-decoration:none;color:black; }
	a:hover { text-decoration:underline;color:black; }
</style>
</head>
<body onLoad="window.print();">

<table id="Imprimir" width="100%" cellpadding="0" cellspacing="0" border="0" >
	<cfoutput>
	<tr> 
		<td align="right" nowrap>
			<a href="javascript:location.href='QPassVenTemp.cfm?_';" tabindex="-1">
				<img src="/cfmx/sif/imagenes/back.gif"
				alt="Regresar"
				name="Regresar"
				class="noprint"
				border="0" align="absmiddle">
			</a>
		</td>
	</tr>
	<tr><td><hr></td></tr>
	</cfoutput>
</table>
		
<cfif ParametroImpresionPdf>
	<cfdocument format="pdf" orientation="portrait">
	<cfoutput>
		#LvarContrato#
	</cfoutput>
	</cfdocument>
<cfelse>
	<cfoutput>
		#LvarContrato#
	</cfoutput>
</cfif>

	<cffunction name="fnImprimeConvenio" access="private" output="no">
    	<cfargument name="Conexion" 		type="string"  required="yes">
        <cfargument name="QPvtaTagid" 		type="numeric" required="yes">
        <cfargument name="BMUsucodigo"  	type="numeric" default="#session.Usucodigo#">
        <cfargument name="Ecodigo"  		type="numeric" default="#session.Ecodigo#">

 		<cfquery name="_rsInserCont" datasource="#Arguments.Conexion#">
            select 
                QPVtaContid,   
				QPvtaTagid,     
				QPVtaCcontrato,
				Ecodigo,         
				BMFecha,       
				BMUsucodigo, 
				ts_rversion  
            from QPVtaContrato
            where Ecodigo = #Arguments.Ecodigo#
              and QPvtaTagid = #Arguments.QPvtaTagid#
        </cfquery>
		<cfif _rsInserCont.recordcount GT 0>
        	<cfthrow message="El Contrato ya se ingreso al sistema">
        </cfif>

         <cfquery  datasource="#Arguments.Conexion#">
            insert into QPVtaContrato (
				QPvtaTagid,QPVtaCcontrato,Ecodigo,BMFecha,BMUsucodigo
				)
            select
                t.QPvtaTagid, '#LvarContrato#' ,#Arguments.Ecodigo#,#now()#, #Arguments.BMusucodigo#
            from QPventaTags t
            where t.QPvtaTagid = #Arguments.QPvtaTagid#
        </cfquery><!--- --->
        
	<!--- ********************************************************************************************************************************** --->
    	<!--- Inserta en la tabla QPMovCuenta todas las causas marcadas como venta --->
        <cfquery name="rs" datasource="#Arguments.Conexion#">
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
              and a.Ecodigo = #Arguments.Ecodigo#
              and a.QPCtipo = 4		<!--- Solamente rubros que correspondan a cargos por venta --->
        </cfquery>

        <!--- <cfdump var="#rs#">
        <cfquery name="rsdebug" datasource="#session.dsn#">
            select * from QPMovCuenta where QPTidTag = #rsDatosVenta.QPTidTag#
        </cfquery>
        <cfdump var="#rsdebug#" label="QPMovCuenta antes de insertar movimientos"> --->
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
                    where Ecodigo = #arguments.Ecodigo#
                    and QPCid = #LvarQPCid# <!--- indica si la causa es la que se usa en la importación de movimientos de Autopostas del Sol (ADS) --->
                </cfquery>
                <cfset LvarQPMovid = rsMovimiento.QPMovid>
        
                <!--- <cfdump var="#rsMovimiento#"> --->

                <cfquery datasource="#session.DSN#">
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
                        QPTPAN  
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
                        <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsDatosVenta.QPTPAN#">
                    )
                </cfquery>
                <!--- Si la venta es tipo PostPago se acepta la venta de una vez --->
                <!--- <cfif rs.QPvtaConvTipo eq 1><!--- 1: PostPago, 2: PrePago --->
                	<!--- actualiza el estado de la venta en 1: Aplicada --->
                    <cfquery datasource="#session.dsn#">
                        update QPventaTags
                        set QPvtaEstado = 1
                        where QPvtaTagid = #Arguments.QPvtaTagid#
                    </cfquery>
                    
                    <!--- Actualiza el estado del TAG a 4: Vendido y Activo --->
                    <cfquery datasource="#session.dsn#">
                        update QPassTag
                        set QPTEstadoActivacion = 4
                        where QPTidTag =  #rsDatosVenta.QPTidTag#
                    </cfquery>
                </cfif> --->
                <!--- <cfquery name="rsdebug" datasource="#session.dsn#">
					select * from QPMovCuenta where QPTidTag = #rsDatosVenta.QPTidTag#
				</cfquery>
				<cfdump var="#rsdebug#" label="QPMovCuenta dentro del ciclo"> --->
                <!--- ********************************************************************************************************************************** --->
            </cfloop>
            <cftransaction action="commit"/>
        </cftransaction>
	</cffunction>	

<cffunction name="fnObtieneDatosConvenio" access="private" output="false" hint="Obtiene los Datos de Convenio y Genera el documento" returntype="boolean">
	<cfargument name="QPvtaTagid" type="numeric" required="yes">
	<cfset ParametroImpresionPdf = false>

	<cfquery name="rsDatosVenta" datasource="#session.dsn#">
		select
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
		where QPvtaTagid = #Arguments.QPvtaTagid#
		  and a.QPvtaEstado = 0
	</cfquery>

	<cfif rsDatosVenta.recordcount EQ 1 and len(trim(rsDatosVenta.QPvtaConvid))>
		<cfquery name="rsTipoConvenio" datasource="#session.dsn#">
			select QPvtaConvCont,QPvtaConvPrecioTag
			from QPventaConvenio
			where QPvtaConvid = #rsDatosVenta.QPvtaConvid#
		</cfquery>
	<cfelse>
		<cfreturn false>
	</cfif>

	<cfset dia = datepart('d', now())>
	<cfset mes = datepart('m', now())>
	<cfset periodo = datepart('yyyy', now())>
	
	<cfif rsTipoConvenio.recordcount EQ 1>
		<cfset LvarContrato = rsTipoConvenio.QPvtaConvCont>
		<cfset LvarContrato = replacenocase(LvarContrato, "?nombre?", "#rsDatosVenta.QPcteNombre#", "all")>
		<cfset LvarContrato = replacenocase(LvarContrato, "?dia?", "#dia#", "all")>
		<cfset LvarContrato = replacenocase(LvarContrato, "?mes?", "#mes#", "all")>
		<cfset LvarContrato = replacenocase(LvarContrato, "?periodo?", "#periodo#", "all")>
		<cfset LvarContrato = replacenocase(LvarContrato, "?tag?", "#rsDatosVenta.QPTPAN#", "all")>
		<cfset LvarContrato = replacenocase(LvarContrato, "?placa?", "#rsDatosVenta.QPvtaTagPlaca#", "all")>
		<cfset LvarContrato = replacenocase(LvarContrato, "?identificacion?", "#rsDatosVenta.QPcteDocumento#", "all")>
		<cfset LvarContrato = replacenocase(LvarContrato, "?telefono1?", "#rsDatosVenta.QPcteTelefono1#", "all")>
		<cfset LvarContrato = replacenocase(LvarContrato, "?telefono2?", "#rsDatosVenta.QPcteTelefono2#", "all")>
		<cfset LvarContrato = replacenocase(LvarContrato, "?correo?", "#rsDatosVenta.QPcteCorreo#", "all")>
		<cfset LvarContrato = replacenocase(LvarContrato, "?cuenta?", "#rsDatosVenta.QPctaBancoNum#", "all")>
	<cfelse>
		<cfset LvarContrato = "El convenio indicado no existe en la tabla de tipos de convenio">
	</cfif>	
	<cfreturn true>
</cffunction>
</body>
</html>