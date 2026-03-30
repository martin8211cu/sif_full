<!--- Selecciona la caja que se va a cerrar --->
<!--- caso 1. la caja existe en la session--->
<cf_importlibs>
<style type="text/css">
  .listaPar2 {  background-color: #F5F5F5; vertical-align: middle; text-indent: 10px; padding-top: 2px; padding-bottom: 2px}

	.botonesEdicion{
		padding-right: 2em;
	}
	.botones input{
		margin-left:1em;
	}

	.cajaMonedas{
		border:thin solid #0079C1;
		box-shadow: 2px 2px 5px #888888;
		margin:2em;
		font-size: 1.25em;
		padding-left:0;
		padding-right:0;

	}

	.cajaMonedas header{
		background-color: #0079C1;
		color: white;
		padding: 0.45em;
		width:100%;
	}

	.cajaMonedas li{
		list-style: none;
		margin-left: -15;
		width:100%;
	}
	.cajaMonedas label{
		display: inline-block;
		font-style: normal;
		font-weight: bold;
		margin:0;
		text-align: right;
		width: 6em;
	}
	.cajaMonedas p{
		display: inline;
		font-style: normal;
		font-weight: normal;
		margin: 0;
		padding: 0;
	}
	.cajaMonedas .footer{
		font-size: 1.2em;
		padding-left:0px;
		padding-right:0px;
	}
	.cajaMonedas .contenido{
		font-size: 0.7 em;
		padding-left:2px;
		padding-right:2px;
		width:100%;

	}
	.cajaMonedas ul
	{
		 margin:0;
		 padding:0;
	}
		.cajaMonedas li
	{
		 margin:0;
		 padding:0;
	}
  .secciones{
	text-align:left;text-decoration:underline; font-weight:bold;
	 }
</style>
<style media="print">
	.cajaMonedas{
		border:thin solid #0079C1;
		padding: 0.1em;
  	}
 	.cajaMonedas input{
 		border:none !important;
 	}
 	.SistemaContenedor{
		border:none;
	}
  	.noPrint{
		display:none;
	}
	.SistemaContenedor input{
	 	border:0 !important;
	}
	.secciones{
		display:block;
		text-align:center !important;
	}
	.breadcrumb{
		display:none;
	}
	.portlet_tdcontenido{
		border:none;
	}
</style>
<cf_dbfunction name="op_concat" returnvariable= "_CNCT">
<cfif NOT isdefined("session.Caja")and not isdefined('RolAdministrador')>
  	<cflocation addtoken="no" url="../catalogos/AbrirCaja.cfm?CJC=1">
<cfelseif NOT isdefined("CajaVer") and isdefined('RolAdministrador')>
    	<cflocation addtoken="no" url="../catalogos/AbrirCaja.cfm?CJC=2">
</cfif>
<cfif isdefined("CajaVer") and isdefined('RolAdministrador') and isdefined('IdCaja')>
      <cfset form.FCid = IdCaja>
<cfelse>
	<cfif isdefined("session.Caja") and len(trim(session.Caja)) gt 0>
          <cfset form.FCid = session.Caja >
    <!--- no hay session y la caja esta en la tabla de cajas activas. Se supone que un usuario solo abre una caja a la vez. --->
    <cfelse>
        <cfquery name="rsCajasActivas" datasource="#session.DSN#">
            select convert(varchar, FCid) as FCid
            from FCajasActivas
            where EUcodigo = #session.Usucodigo#
        </cfquery>
        <cfif rsCajasActivas.RecordCount gt 0 >
            <cfset form.FCid = rsCajasActivas.FCid >
        <cfelse>
            <cfif isdefined("form.sFCid") and form.sFCid neq -1 >
                <cfset form.FCid = form.sFCid >
            <cfelse>
                <cfquery name="rsCajasUsuario" datasource="#session.DSN#">
                    select convert(varchar, a.FCid ) as FCid, FCdesc
                    from UsuariosCaja a, FCajas b
                    where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                    and a.FCid=b.FCid
                    and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
                </cfquery>
                <cfif rsCajasUsuario.RecordCount gt 0 >
                    <!--- Dibujar algo que me diga que escoja la caja --->
                    <cfset caja = 1 >
                <cfelse>
                    <cfset caja = 0 >
                </cfif>
            </cfif>
        </cfif>
    </cfif>
</cfif>

<cfquery name="rsMonedaLocal" datasource="#Session.DSN#">
	select convert(varchar,a.Mcodigo) as Mcodigo, m.Msimbolo from Empresas a
    inner join Monedas m
    on a.Mcodigo = m.Mcodigo
   and a.Ecodigo = m.Ecodigo
	where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
</cfquery>

<cfif isdefined("form.FCid") and len(trim(form.FCid)) gt 0>

			<!--- determina si hay cierre pendiente, para esta caja--->
			<cfquery name="rsCierre" datasource="#session.DSN#">
				select convert(varchar, max(FACid)) as FACid
				from FACierres
				where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				and FACestado='P'
			</cfquery>

			<cfif rsCierre.RecordCount gt 0 and len(trim(rsCierre.FACid)) gt 0>
				<cfset modo = 'CAMBIO' >
				<!--- datos para el modo cambio--->
				<cfquery name="rsDatos" datasource="#session.DSN#">
					select convert(varchar, b.FACid) as FACid, a.FADCminicial, a.FADCcontado, a.FADCfcredito, a.FADCefectivo, a.FADCcheques,
						   a.FADCvouchers, a.FADCdepositos, a.FADCdocumentos, a.FADCdiferencias, a.FADCncredito,
                           convert(varchar, FCAfecha) as FCAfecha,
						   convert(varchar, a.Mcodigo) as Mcodigo, FADCtc
					from FADCierres a, FACierres b
					where a.FACid=b.FACid
					  and a.FACid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCierre.FACid#">
					  and b.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				</cfquery>
			<cfelse>
				<cfset modo = 'ALTA' >
			</cfif>

			<!--- descripcion de la caja--->
			<cfquery name="rsCaja" datasource="#session.DSN#">
				select rtrim(FCcodigo)+', '+FCdesc as FCcaja,isnull(MontoFondeo,0) MontoFondeo
				from FCajas
				where FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
			</cfquery>

			<!--- EUcodigo del usuario de la caja--->
			<cfquery name="rsEucodigo" datasource="#session.DSN#">
				select convert(varchar, EUcodigo) as EUcodigo
				from UsuariosCaja a, FCajas b
				where b.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				and a.Usucodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
				and a.Ulocalizacion=<cfqueryparam cfsqltype="cf_sql_char" value="#session.Ulocalizacion#">
				and a.FCid=b.FCid
			</cfquery>

			<!--- monedas registradas en pagos --->
			<cfquery name="rsMonedasP" datasource="#session.DSN#">
				select distinct b.Mcodigo, c.Mnombre , c.Miso4217, c.Msimbolo
				from ETransacciones a, FPagos b, Monedas c
				where a.FCid=b.FCid
				  and a.ETnumero=b.ETnumero
				  and b.Mcodigo=c.Mcodigo
				  and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				  and ETestado='C'
				  and FACid is null
             UNION ALL
               	select distinct b.Mcodigo, c.Mnombre , c.Miso4217, c.Msimbolo
				from HPagos a, PFPagos b, Monedas c
				where a.FCid=b.FCid
				  and a.Pcodigo=b.Pcodigo
   				  and a.CCTcodigo=b.CCTcodigo
				  and b.Mcodigo=c.Mcodigo
				  and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				  and FACid is null
                  and b.Mcodigo not in ( select distinct b.Mcodigo
                                        from ETransacciones a, FPagos b, Monedas c
                                        where a.FCid=b.FCid
                                          and a.ETnumero=b.ETnumero
                                          and b.Mcodigo=c.Mcodigo
                                          and a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                          and ETestado='C'
                                          and FACid is null)
			</cfquery>

			<!--- Monedas registradas en las facturas--->
			<cfquery name="rsMonedasT" datasource="#session.DSN#">
			    select distinct Mcodigo,Mnombre,Miso4217,Msimbolo from (
				select distinct a.Mcodigo, c.Mnombre , c.Miso4217, c.Msimbolo
				from ETransacciones a
                 inner join Monedas c
                    on a.Mcodigo=c.Mcodigo
                  and a.Ecodigo = c.Ecodigo
				where  a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				  and a.ETestado='C'
				  and a.FACid is null
                 union all
               select distinct a.Mcodigo, c.Mnombre , c.Miso4217, c.Msimbolo
				from HPagos a
                 inner join Monedas c
              	  on a.Mcodigo=c.Mcodigo
                  and a.Ecodigo = c.Ecodigo
				where a.FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				  and a.FACid is null
                  and a.Mcodigo not in ( select distinct Mcodigo
                                            from ETransacciones
                                          where  FCid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                              and ETestado='C'
                                              and FACid is null
                                         )
               union all
               select distinct
			        m.Mcodigo,
			        m.Mnombre,
			        m.Miso4217,
			        m.Msimbolo
				from EPagosExtraordinarios ep
				inner join DPagosExtraordinarios dp
				    on ep.EPEid = dp.EPEid
				inner join Monedas m
				    on dp.Ecodigo = m.Ecodigo
				   and dp.Mcodigo = m.Mcodigo
				where ep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and ep.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				  and ep.FACid IS NULL) as tablaTemp
			</cfquery>

			<cfset rsMonedasPP = QueryNew("Mcodigo, Mnombre,Miso4217, Msimbolo")>
            <cfset rsMonedasPT = QueryNew("Mcodigo, Mnombre,Miso4217, Msimbolo")>
			<!--- Moneas registradas en los pagos--->
			<cfloop query="rsMonedasP">
				<!--- Agrega la fila procesada --->
				<cfset fila = QueryAddRow(rsMonedasPP, 1)>
				<cfset tmp  = QuerySetCell(rsMonedasPP, "Mcodigo", #rsMonedasP.Mcodigo#) >
				<cfset tmp  = QuerySetCell(rsMonedasPP, "Mnombre", #rsMonedasP.Mnombre#) >
                <cfset tmp  = QuerySetCell(rsMonedasPP, "Miso4217", #rsMonedasP.Miso4217#) >
                <cfset tmp  = QuerySetCell(rsMonedasPP, "Msimbolo", #rsMonedasP.Msimbolo#) >
			</cfloop>

			<!--- Moneas registradas en las transacciones y que no existan en el query --->
			<cfloop query="rsMonedasPT">
				<!--- agrega la moneda solo si no existe --->
				<cfquery name="rsExisteMoneda" dbtype="query" >
					select Mcodigo from rsMonedasT where Mcodigo=#rsMonedasT.Mcodigo#
				</cfquery>
				<cfif rsExisteMoneda.RecordCount eq 0>
					<!--- Agrega la fila procesada --->
					<cfset fila = QueryAddRow(rsMonedasPT, 1)>
					<cfset tmp  = QuerySetCell(rsMonedasPT, "Mcodigo", #rsMonedasT.Mcodigo#) >
					<cfset tmp  = QuerySetCell(rsMonedasPT, "Mnombre", #rsMonedasT.Mnombre#) >
                    <cfset tmp  = QuerySetCell(rsMonedasPT, "Miso4217",#rsMonedasT.Miso4217#) >
                    <cfset tmp  = QuerySetCell(rsMonedasPT, "Msimbolo", #rsMonedasT.Msimbolo#) >
				</cfif>
			</cfloop>
			<cfquery name="rsMonedaLocal" datasource="#session.DSN#">
				select convert(varchar, Mcodigo) as Mcodigo
				from Empresas
				where Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>

			<form action="CierreCaja_sql.cfm" name="form1" method="post" onSubmit="javascript: return validar();" >
			<table width="100%" border="0" cellspacing="0" cellpadding="0">
			  <cfoutput>
			  <tr>
				<td colspan="3"><div align="center"><strong><font size="2">Caja: #rsCaja.FCcaja#</font></strong></div></td>
			  </tr>
			  <tr>
				<td colspan="3"><div align="center"><strong><font size="2">Fecha de Cierre: #LSDateFormat(Now(), 'dd/mm/yyyy')#</font></strong></div></td>
			  </tr>

			  <tr>
				<td colspan="3">
					<input type="hidden" name="FACid" value="<cfif modo neq 'ALTA'>#rsCierre.FACid#</cfif>">
					<input type="hidden" name="EUcodigo" value="#rsEucodigo.EUcodigo#">
				</td>
			  </tr>

			  <!--- Pintado dinamico del form --->
			  <cfset index = 1 >

			  <cfif rsMonedasT.RecordCount gt 0>

             <cfquery name = "rsRemesas" datasource = "#session.dsn#">
               select * from ERemesas
               where FCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
               and FACid is null
               and REstado = 'A'
             </cfquery>

             <cfquery name="rsRemesaConEfectivoOCheque" datasource="#session.dsn#">
             	select 1
		          from FPagos a
		          inner join ETransacciones b
		            on a.FCid = b.FCid
		           and a.ETnumero = b.ETnumero
		           and b.FACid is null
		           and b.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
		           and b.ETestado = 'C'
		           and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		           and a.Tipo in ('E','C')
		          union
		           select 1
		           from PFPagos a
		            inner join HPagos p
		            on a.CCTcodigo = p.CCTcodigo
		            and a.Pcodigo = p.Pcodigo
		            and p.FACid IS NULL
		            and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
		            and p.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
		            and a.Tipo in ('E','C')
             </cfquery>

             <input type="hidden" name="mostrarMensajeRemesaPendiente" value="0">
             <cfif rsRemesas.recordcount EQ 0 and rsRemesaConEfectivoOCheque.recordCount>
                <input type="hidden" name="mostrarMensajeRemesaPendiente" value="1">
             </cfif>

			  <!--- Ciclo para pintar el saldo en cada moneda --->
			<cfoutput>
				<div class="row">
					<cfloop query="rsMonedasT">
						<cfquery name="rsPagos" datasource="#session.dsn#">
                            select
                                sum(ETtotal - coalesce(ETmontoRetencion,0)) as MontoOriginal,
                                  m.Msimbolo, m.Miso4217,
                                  'Nota de Credito' as Origen
                                  , 'C' as tipo
                                  ,m.Mcodigo
                                from  ETransacciones et
                                 inner join Monedas m
                                   on et.Mcodigo = m.Mcodigo
                                  and et.Ecodigo = m.Ecodigo
                                inner join CCTransacciones ct
                                  on et.CCTcodigo = ct.CCTcodigo
                                 and et.Ecodigo = ct.Ecodigo
                              where et.Mcodigo = #Mcodigo#
                                and et.FACid IS NULL
                                and et.ETestado = 'C'
                                and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                and et.ETesLiquidacion = 0
                                and ct.CCTtipo = 'C'
                                group by m.Msimbolo,m.Miso4217,m.Mcodigo
                          UNION ALL
							select
                                sum(ETtotal- coalesce(ETmontoRetencion,0)) as MontoOriginal,
                                  m.Msimbolo,m.Miso4217,
                                  'Facturas de credito' as Origen
                                  , 'H' as tipo
                                  ,m.Mcodigo
                                from  ETransacciones et
                                inner join Monedas m
                                  on  et.Mcodigo = m.Mcodigo
                                  and et.Ecodigo = m.Ecodigo
                                inner join CCTransacciones ct
                                  on et.CCTcodigo = ct.CCTcodigo
                                 and et.Ecodigo   = ct.Ecodigo
                               where et.Mcodigo = #Mcodigo#
                                and et.ETesLiquidacion = 0
                                and et.FACid IS NULL
                                and et.ETestado = 'C'
                                and coalesce(ct.CCTvencim,0) <> -1
                                and ct.CCTtipo = 'D'
                                and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                group by m.Msimbolo,m.Miso4217,m.Mcodigo
                         UNION ALL
							select
                                sum(ETtotal- coalesce(ETmontoRetencion,0)) as MontoOriginal,
                                  m.Msimbolo,m.Miso4217,
                                  'Facturas de contado' as Origen
                                  , 'F' as tipo
                                  ,m.Mcodigo
                                from  ETransacciones et
                                inner join Monedas m
                                  on  et.Mcodigo = m.Mcodigo
                                  and et.Ecodigo = m.Ecodigo
                                inner join CCTransacciones ct
                                  on et.CCTcodigo = ct.CCTcodigo
                                 and et.Ecodigo   = ct.Ecodigo
                               where et.Mcodigo = #Mcodigo#
                                and et.ETesLiquidacion = 0
                                and et.FACid IS NULL
                                and et.ETestado = 'C'
                                and ct.CCTvencim = -1
                                and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                group by m.Msimbolo,m.Miso4217,m.Mcodigo
                            UNION ALL
                            select (coalesce(a.MontoOriginal,0) + coalesce(b.MontoOriginal,0))  as MontoOriginal, c.Msimbolo,c.Miso4217,
                                  'Liquidacion cobradores',
                                  'L',
                                  c.Mcodigo
                              from (
                                        select coalesce(  sum(Ptotal) ,0) as MontoOriginal , #Mcodigo#  as Moneda
                                            from  HPagos p
                                           inner join FALiquidacionRuteros  f
                                               on f.NumLote = p.Plote
                                              and f.Ecodigo = p.Ecodigo
                                           where p.Mcodigo = #Mcodigo#
                                            and PesLiquidacion = 1
                                             and p.FACid IS NULL
                                             and f.estado = 'P'
                                             and f.FACid is null
                                             and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                      ) as b
                             inner join  (
                                                select
                                                   coalesce(sum(ETtotal- coalesce(ETmontoRetencion,0)) ,0) as MontoOriginal , #Mcodigo#   as Moneda
                                                    from  ETransacciones et
                                                   inner join FALiquidacionRuteros  f
                                                     on f.NumLote = et.ETlote
                                                    and f.Ecodigo = et.Ecodigo
                                                    where et.Mcodigo = #Mcodigo#
                                                    and et.FACid IS NULL
                                                    and et.ETestado = 'C'
                                                    and f.estado = 'P'
                                                    and f.FACid is null
                                                   and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                                                    and et.ETesLiquidacion = 1
                                                   ) as a
                                        on a.Moneda= b.Moneda
                             inner join Monedas c
                              on c.Mcodigo = #Mcodigo#
                        UNION ALL

                          select  (coalesce(a.MontoOriginal,0)
                     <!----	 + coalesce(b.MontoOriginal,0)----->
                           - coalesce(c.MontoComision,0))  as MontoOriginal,
                               m.Msimbolo,m.Miso4217,
                                  'Recibos' as Origen ,
                                 'R' as tipo,
                                  a.Mcodigo
                               from  (
                                        select
                                           coalesce( sum(Dtotalref - coalesce(BMmontoretori,0)),0) as MontoOriginal,
                                             #Mcodigo# as Mcodigo

                                            from  HPagos p
                                           inner join BMovimientos b
                                                   on p.Ecodigo = b.Ecodigo
                                                   and p.CCTcodigo = b.CCTcodigo
                                                   and p.Pserie + convert(char,ltrim(p.Pdocumento))   = b.Ddocumento
                                            inner join CCTransacciones t
                                                  on b.CCTcodigo = t.CCTcodigo
                                                  and b.Ecodigo = t.Ecodigo
                                                  and coalesce(t.CCTvencim,0) != -1

                                            where p.Mcodigo = #Mcodigo#
                                            and PesLiquidacion = 0
                                             and p.FACid IS NULL
                                             and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">

                                     ) as a
                       <!----    inner join
                                        (select coalesce(sum(Dtotalref - coalesce(BMmontoretori,0)),0) as MontoOriginal,
                                                   #Mcodigo# as Mcodigo
                                                from  HPagos p
                                               inner join BMovimientos b
                                                 on p.Ecodigo = b.Ecodigo
                                              and p.Pserie + convert(char,ltrim(p.Pdocumento))    = b.DRdocumento

                                               inner join CCTransacciones t
                                                  on b.CCTcodigo = t.CCTcodigo
                                                  and b.Ecodigo = t.Ecodigo
                                                  and coalesce(t.CCTvencim,0) != -1

                                                where p.Mcodigo = #Mcodigo#
                                               and PesLiquidacion = 0
                                                 and p.FACid IS NULL
                                                 and b.CCTRcodigo not in('CE','DT')
                                                 and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">

                                         )  as b
                            on a.Mcodigo = b.Mcodigo----->

                          inner join
                               (
                                        select
                                            coalesce(sum(
                                                      case when  VolumenGNCheck 		= 1 then VolumenGN 			else 0 end
                                                    + case when  VolumenGLRCheck 		= 1 then VolumenGLR 		else 0 end
                                                    + case when  VolumenGLRECheck 		= 1 then VolumenGLRE 		else 0 end
                                                    + case when  ProntoPagoCheck 		= 1 then ProntoPago 		else 0 end
                                                    + case when  ProntoPagoClienteCheck	= 1 then ProntoPagoCliente	else 0 end
                                                    + case when  montoAgenciaCheck 		= 1 then montoAgencia 		else 0 end
                                                    ) ,0) as MontoComision,
												#Mcodigo#	 as Mcodigo

                                            from  HPagos p
                                           inner join COMFacturas b
                                                   on p.Ecodigo = b.Ecodigo
                                                   and p.CCTcodigo = b.CCTcodigoE
                                                   and p.Pcodigo = b.PcodigoE

                                            where p.Mcodigo = #Mcodigo#
                                            and PesLiquidacion = 0
                                             and p.FACid IS NULL
                                             and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">

                                     ) as c
                                  on a.Mcodigo = c.Mcodigo
                            inner join Monedas m
                              on m.Mcodigo = #Mcodigo#
                  UNION ALL
                          select
                                sum(Ptotal) as MontoOriginal,
                                  m.Msimbolo,m.Miso4217,
                                  'Devoluciones' as Origen
                                  , 'D' as tipo
                                 ,m.Mcodigo
                            from  HPagos p
                               inner join Monedas m
                                on p.Mcodigo = m.Mcodigo
                               and p.Ecodigo = m.Ecodigo
                              inner join BMovimientos bm
                                 on p.CCTcodigo = bm.CCTRcodigo
                               and p.Pcodigo = bm.DRdocumento
                               and p.Ecodigo = bm.Ecodigo
                               inner join SNegocios sn
                                on p.SNcodigo = sn.SNcodigo
                               and p.Ecodigo  = sn.Ecodigo
                                where p.Mcodigo = #Mcodigo#
                                 and PesLiquidacion = 0
                                 and coalesce(PfacturaContado,'N') = 'D'
                                 and p.FACid IS NULL
                                 and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                              group by m.Msimbolo,m.Miso4217,m.Mcodigo
       			<!--- Cuentas por Cobrar Empleados --->
       			UNION ALL
       					select
					        sum(dp.DPEmonto) as MontoOriginal,
					        m.Msimbolo,
					        m.Miso4217,
					        'CxC Empleados' as Origen,
					        'CxCE' as tipo,
					        m.Mcodigo
						from EPagosExtraordinarios ep
						inner join DPagosExtraordinarios dp
						    on ep.EPEid = dp.EPEid
						inner join Monedas m
						    on dp.Ecodigo = m.Ecodigo
						   and dp.Mcodigo = m.Mcodigo
						where dp.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
						  and ep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
						  and ep.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
						  and ep.FACid IS NULL
						group by m.Msimbolo,m.Miso4217,m.Mcodigo
       			</cfquery>
            <tr>
             <td colspan="3">
		       <div id="listaRecibosMostrar"  >
                 <cfif isdefined('rsPagos') and rsPagos.recordcount eq 0>
                   <h5 class="secciones"> Montos por tipo de documento</h5>
                 </cfif>
						<div class="cajaMonedas col-xs-10 col-sm-4 col-md-4">
							<header>
								<strong>Documentos facturados #Mnombre# (#Miso4217#)</strong>
							</header>
							<div class="contenido">
									<cfset total = 0>
                                    <table border="0" width="100%">
									<cfloop query="rsPagos">
                                        <tr>
                                         <td width="10px">
											<label>
												<cfswitch expression="#Tipo#">
													<cfcase value="F">
														Fac. Cont:
													</cfcase>
													<cfcase value="L">
														Liquidación:
													</cfcase>
													<cfcase value="R">
														Recibos:
													</cfcase>
													<cfcase value="C">
														Nota. Créd:
													</cfcase>
                                                   <cfcase value="D">
														Devoluciones:
													</cfcase>
                                                    <cfcase value="H">
														Fac. Créd:
													</cfcase>
													<cfcase value="CxCE">
														CxC.Empleados:
													</cfcase>
													<cfdefaultcase>
														*Otros:
													</cfdefaultcase>
												</cfswitch>
											</label>
                                            </td>
                                            <td width="15px">
											<p>#Msimbolo# #LSNumberFormat(MontoOriginal, ',9.00')#</p>
                                            </td>
                                            <td width="10px">
                                            <input type="hidden" value="#Tipo#" id="tipo" name="tipo"/>
                                            <cfif MontoOriginal gt 0.00>
                                              <p onclick="levantarPop('#Mcodigo#','#Tipo#','D','#form.FCid#');" style="cursor:pointer;  color:##09C;"> <i class="fa fa-search noPrint"></i> </p>
                                            </cfif>
                                            </td>
										</tr>
                                        <cfif Tipo neq 'C' and Tipo neq 'H'>
  										  <cfset total += MontoOriginal>
                                        </cfif>
									</cfloop>
									<tr>
                                        <td width="10px">
											<label>
												Fondeo
											</label>
										</td>
										<td width="15px">
											<p>#Msimbolo# #LSNumberFormat(rsCaja.MontoFondeo, ',9.99')#</p>
											<input type="hidden" name="MontoFondeo" value="#LSNumberFormat(rsCaja.MontoFondeo, ',9.99')#"
										</td>
										<td width="10px">
											
										</td>
									</tr>
                                    <tr>
                                       <td width="10px" >&nbsp;

                                       </td>
                                      <td width="15px">&nbsp;

                                       </td>
                                       <td width="10px">
                                       </td>
                                      </tr>
                                      <tr>
                                       <td width="10px" class="footer">
                                        <label>Total:</label>
                                       </td>
                                       <td width="15px" class="footer">
                                        <strong>#Msimbolo##LSNumberFormat(total+rsCaja.MontoFondeo,',9.99')#</strong>
                                        <input type="hidden" value="#total#" id="total_#Miso4217#"/>
                                        </td>
                                        <td width="10px" >
                                        <span id="check_#Miso4217#"  class="fa fa-check" style="color:##0C3; display:none;"></span>
                                       </td>
                                      </tr>
                                 </table>
							<hr style="margin:0;padding:0"/>
                           </div>
						</div>
					</cfloop>
				</div>
			</cfoutput>
			</div>
		<hr/>
		<div id="Mensajes" style="text-align:center"></div>
		</td>
      </tr>
	  <tr><td>
      <cfif isdefined('rsPagos') and rsPagos.recordcount eq 0>
      <div id="listaRecibosMostrar" >
         	<h5 class="secciones" > Montos por medio de pago</h5>
      </div>
      </cfif>
      </td></tr>
      <tr>
       <td>

            <cfquery name="rsSQL" datasource="#session.dsn#">
			     select
                      coalesce(sum(coalesce(PFPVuelto * p.Ptipocambio,0)),0) as vuelto
                    from PFPagos a
                    inner join HPagos p
                      on a.Pcodigo = p.Pcodigo
                     and a.CCTcodigo     = p.CCTcodigo
                   where p.FACid IS NULL
                and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
            </cfquery>
            <cfif session.Usulogin eq 'ymena'>
           <!---  <cfdump var="#rsSQL#">--->
            </cfif>

            <cfquery name="rsVueltos" datasource="#session.dsn#">
			     select
                      coalesce(sum(coalesce(FPVuelto * et.ETtc,0)),0)  + #rsSQL.vuelto#  as vuelto
                    from FPagos a
                    inner join ETransacciones et
                      on a.ETnumero = et.ETnumero
                     and a.FCid     = et.FCid
                   where
                    et.FACid IS NULL
                    and et.ETestado = 'C'
                    and ETgeneraVuelto = 1
                    and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
            </cfquery>
             <cfif session.Usulogin eq 'ymena'>
          <!---   <cfdump var="#rsVueltos#">--->
            </cfif>



        <cfif rsMonedasP.RecordCount gt 0>
          	<cfloop query="rsMonedasP">
              <cfquery name="rsPagos" datasource="#session.dsn#">
               select
                sum(FPmontoori) as MontoOriginal,
                  m.Msimbolo,m.Miso4217,
                  'Efectivo' as Origen
                  ,  a.Tipo as tipo
                  ,m.Mcodigo
                from PFPagos a
                inner join HPagos p
                on a.CCTcodigo = p.CCTcodigo
                and a.Pcodigo = p.Pcodigo
               inner join Monedas m
                on a.Mcodigo = m.Mcodigo
               left outer join ERemesas re
                 on a.ERid = re.ERid
                where a.Mcodigo = #Mcodigo#
                 and p.FACid IS NULL
                 and (a.ERid IS NULL or re.REstado <> 'A' )
                 and p.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                group by m.Msimbolo,m.Miso4217, a.Tipo,m.Mcodigo
                 union all
			     select
                    sum(FPmontoori)
                         as MontoOriginal,
                      m.Msimbolo,m.Miso4217,
                      'Efectivo'  as Origen
                      , a.Tipo as tipo
                      ,m.Mcodigo
                    from FPagos a
                    inner join ETransacciones et
                      on a.ETnumero = et.ETnumero
                     and a.FCid     = et.FCid
                    inner join Monedas m
                      on  a.Mcodigo = m.Mcodigo
                    left outer join ERemesas re
                      on a.ERid = re.ERid
                   where a.Mcodigo = #Mcodigo#
                    and et.FACid IS NULL
                    and et.ETestado = 'C'
                    and (a.ERid IS NULL or re.REstado <> 'A' )
                    and et.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                    group by m.Msimbolo,m.Miso4217, a.Tipo,m.Mcodigo
                <!----- Incluyo remesas como medio de pago ----->
                 union all
                   select
                     sum(MntEfectivo + MntCheque) as MontoOriginal,
                      m.Msimbolo,m.Miso4217,
                      'Remesas'  as Origen
                      ,'R' as tipo
                      ,m.Mcodigo
                    from ERemesas a
                      inner join Monedas m
                      on  a.Mcodigo = m.Mcodigo
                   where a.Mcodigo = #Mcodigo#
                    and a.FACid IS NULL
                    and a.REstado = 'A'
                    and a.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                    group by m.Msimbolo,m.Miso4217,m.Mcodigo
               UNION ALL
   					select
				        sum(dp.DPEmonto) as MontoOriginal,
				        m.Msimbolo,
				        m.Miso4217,
				        'CxC Empleados' as Origen,
				        dp.DPEformapago as tipo,
				        m.Mcodigo
					from EPagosExtraordinarios ep
					inner join DPagosExtraordinarios dp
					    on ep.EPEid = dp.EPEid
					inner join Monedas m
					    on dp.Ecodigo = m.Ecodigo
					   and dp.Mcodigo = m.Mcodigo
					where dp.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
					  and ep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
					  and ep.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
					  and ep.FACid IS NULL
					group by m.Msimbolo,m.Miso4217,m.Mcodigo,dp.DPEformapago
			</cfquery>
        <!---   <cfdump var="#rsPagos#">--->
            <cfif isdefined('rsVueltos') and rsVueltos.recordcount gt 0 and rsMonedaLocal.Mcodigo eq Mcodigo>
			  <cfset Lvarvuelto =  rsVueltos.vuelto >

            <cfelse>
              <cfset Lvarvuelto =  0>
            </cfif>

             <cfquery name="rsEfectivoRemesas" datasource="#session.dsn#">
			     select
                    coalesce(sum(coalesce(MntEfectivo,0)),0) as EfectivoRem
                    from ERemesas re
                    inner join Monedas m
                      on re.Mcodigo = m.Mcodigo
                   where re.Mcodigo = #Mcodigo#
                    and m.Ecodigo  = #session.Ecodigo#
                    and re.FACid is null
                    and re.FCid =  <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
                   and re.REstado = 'A'
            </cfquery>
            <cfif rsEfectivoRemesas.recordCount>
            	<cfset _EfectivoRem = rsEfectivoRemesas.EfectivoRem>
            <cfelse>
            	<cfset _EfectivoRem = 0>
            </cfif>

            <!--- Montos pagados en efectivo de los Extraordinarios CxC Empleados --->
            <cfquery name="rsEfectivoCxCExtraordinario" datasource="#session.dsn#">
            	select coalesce(sum(coalesce(dp.DPEmonto,0)),0) as MontoEfectivo
            	from EPagosExtraordinarios ep
				inner join DPagosExtraordinarios dp
				    on ep.EPEid = dp.EPEid
				inner join Monedas m
				    on dp.Ecodigo = m.Ecodigo
				   and dp.Mcodigo = m.Mcodigo
				where dp.Mcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Mcodigo#">
				  and ep.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
				  and ep.FCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FCid#">
				  and ep.FACid IS NULL
				  and dp.DPEformapago = 'E' <!--- Efectivo --->
            </cfquery>
            <cfif rsEfectivoCxCExtraordinario.recordCount>
            	<cfset _EfectivoCxCEmpleados = rsEfectivoCxCExtraordinario.MontoEfectivo>
            <cfelse>
            	<cfset _EfectivoCxCEmpleados = 0>
            </cfif>

            <cfquery name="rsPagos1" dbtype="query">
                select Tipo
                from rsPagos
                group by Tipo
            </cfquery>

						<div class="cajaMonedas col-xs-10 col-sm-5 col-md-6">
							<header>
								<strong>Medios de pagos en #Mnombre# (#Miso4217#)</strong>
							</header>
							<div class="contenido">
                            <cfset LvarMsimbolo = ''>
							<cfset total = 0>
                            <cfset PayEfectivo = 0>
                            <cfset PayTarjeta = 0>
                            <cfset PayDeposito = 0>
                            <cfset PayDiferencia = 0>
                            <cfset PayCheque = 0>
                            <cfset PayRemesas= 0>
                            <cfset PayDocumento = 0>
                            <cfset PayCxCExtraordinario = 0>
                            <cfset MontoTarjeta= 0>
							<cfset MontoDiferencias = 0>
                            <cfset MontoRemesas = 0>
                            <cfset MontoDepositos = 0>
                            <cfset MontoDocumentos = 0>
                            <cfset MontoCxCExtraordinario = 0>

                            <cfloop query="rsPagos">
                                  <cfswitch expression="#Tipo#">
                                            <cfcase value="C">
                                                <cfset PayCheque     = PayCheque + MontoOriginal>
                                            </cfcase>
                                            <cfcase value="E">
                                                <cfset PayEfectivo   = PayEfectivo + MontoOriginal <!---- Lvarvuelto--->>
                                            </cfcase>
                                            <cfcase value="T">
                                                <cfset PayTarjeta    = PayTarjeta + MontoOriginal>
                                                <cfset MontoTarjeta  = MontoTarjeta + MontoOriginal>
                                            </cfcase>
                                            <cfcase value="D">
                                                <cfset PayDeposito   = PayDeposito + MontoOriginal>
                                                <cfset MontoDepositos = MontoDepositos + MontoOriginal>
                                            </cfcase>
                                            <cfcase value="A">
                                                <cfset PayDocumento  = PayDocumento + MontoOriginal>
                                                <cfset MontoDocumentos = MontoDocumentos + MontoOriginal>
                                            </cfcase>
                                             <cfcase value="F">
                                                <cfset PayDiferencia = PayDiferencia + MontoOriginal>
                                                <cfset MontoDiferencias = MontoDiferencias + MontoOriginal>
                                            </cfcase>
                                            <cfcase value="R">
                                                <cfset PayRemesas   = PayRemesas + MontoOriginal>
                                                <cfset MontoRemesas = MontoRemesas + MontoOriginal>
                                            </cfcase>
                                            <cfcase value="CxCE">
                                            	<cfset MontoCxCExtraordinario = MontoCxCExtraordinario + MontoOriginal>
                                            	<cfset PayCxCExtraordinario = PayCxCExtraordinario + MontoOriginal>
                                            </cfcase>
                                        </cfswitch>

                                  <cfset LvarMsimbolo = Msimbolo>
                                  <cfset LvarMiso4217 = Miso4217>
                                  <cfset LvarMcodigo  = Mcodigo>
                             </cfloop>

               <cfset PayEfectivo   = PayEfectivo  - Lvarvuelto - _EfectivoRem + _EfectivoCxCEmpleados>

                                    <table border="0" width="100%">
									<cfloop query="rsPagos1">
                                        <tr>
                                         <td width="10px">
                                         <cfif  isdefined('RolAdministrador')><!--- SI ES Supervisor --->
											<label>
												<cfswitch expression="#Tipo#">
													<cfcase value="F">
														Diferencia:
													</cfcase>
                                                    <cfcase value="D">
														Depositos:
													</cfcase>
													<cfcase value="E">
														Efectivo:
													</cfcase>
													<cfcase value="T">
														Tarjetas:
													</cfcase>
													<cfcase value="C">
														Cheques:
													</cfcase>
                                                    <cfcase value="A">
														Documentos:
													</cfcase>
                                                    <cfcase value="R">
														Remesas:
													</cfcase>
													<cfcase value="CxCE">
														CxC Empleados 2:
													</cfcase>
												</cfswitch>
											</label>
                                           <cfelse>
                                              <label>
												<cfswitch expression="#Tipo#">
                                                    <cfcase value="R">
														Remesas:
													</cfcase>
												</cfswitch>
											</label>
                                           </cfif>
                                            </td>
                                            <td width="15px">
                                            <cfif  isdefined('RolAdministrador')><!---SI NOOO es Supervisor --->
											  <p>#LvarMsimbolo#
                                            </cfif>
                                            <cfswitch expression="#Tipo#">
													<cfcase value="F">
                                                      <cfif  isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
														 #LSNumberFormat(PayDiferencia, ',9.00')#
                                                      </cfif>
                                                  <input name="montoSys_F_#LvarMiso4217#" type="hidden" value="#PayDiferencia#"/>
                                                         <cfset total += PayDiferencia>
													</cfcase>
                                                    <cfcase value="D">
                                                      <cfif  isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
														 #LSNumberFormat(PayDeposito, ',9.00')#
                                                      </cfif>
                                                  <input name="montoSys_D_#LvarMiso4217#" type="hidden" value="#PayDeposito#"/>
                                                         <cfset total += PayDeposito>
													</cfcase>
													<cfcase value="E">
                                                      <cfif  isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
														 #LSNumberFormat(PayEfectivo, ',9.00')#
                                                      </cfif>
                                                  <input name="montoSys_E_#LvarMiso4217#" type="hidden" value="#PayEfectivo#"/>
                                                         <cfset total += PayEfectivo>
													</cfcase>
													<cfcase value="T">
                                                      <cfif  isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
														 #LSNumberFormat(PayTarjeta, ',9.00')#
                                                      </cfif>
                                                   <input name="montoSys_T_#LvarMiso4217#" type="hidden" value="#PayTarjeta#"/>
                                                         <cfset total += PayTarjeta>
													</cfcase>
													<cfcase value="C">
                                                      <cfif  isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
														 #LSNumberFormat(PayCheque, ',9.00')#
                                                      </cfif>
                                                   <input name="montoSys_C_#LvarMiso4217#" type="hidden" value="#PayCheque#"/>
                                                         <cfset total += PayCheque>
													</cfcase>
                                                    <cfcase value="A">
                                                      <cfif  isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
														 #LSNumberFormat(PayDocumento, ',9.00')#
                                                      </cfif>
                                                   <input name="montoSys_A_#LvarMiso4217#" type="hidden" value="#PayDocumento#"/>
                                                         <cfset total += PayDocumento>
													</cfcase>
                                                    <cfcase value="R">
														 #LSNumberFormat(PayRemesas, ',9.00')#
                                                   <input name="montoSys_R_#LvarMiso4217#" type="hidden" value="#PayRemesas#"/>
                                                         <cfset total += PayRemesas>
													</cfcase>
													<cfcase value="CxCE">
														<cfif  isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
															#LSNumberFormat(PayCxCExtraordinario, ',9.00')#
														</cfif>
														<input name="montoSys_CxCE_#LvarMiso4217#" type="hidden" value="#PayCxCExtraordinario#"/>
                                                         <cfset total += PayCxCExtraordinario>
													</cfcase>
												</cfswitch>
                                            </p>
                                            </td>
                                            <td width="10px">
                                               <input name="tipo_Doc" type="hidden" value="#Tipo#"/>
                                              <cfif Tipo eq 'F'>
	                                              <cfif  isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
	                                               <cf_monto name="Monto_#Tipo#_#LvarMiso4217#" readonly="true" value="#PayDiferencia#"  class="Doc_input_#LvarMiso4217#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
	                                               <p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>
	                                              <cfelseif Tipo eq 'R'>
	                                               <cf_monto name="Monto_#Tipo#_#LvarMiso4217#" readonly="true" value="#PayRemesas#"  class="Doc_input_#LvarMiso4217#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
	                                               <p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>
	                                              <cfelseif Tipo eq 'T'>
	                                               <cf_monto name="Monto_#Tipo##LvarMiso4217#" readonly="true" value="#PayTarjeta#"  class="Doc_input#LvarMiso4217#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
	                                               <p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>
	                                              <cfelseif Tipo eq 'E' or Tipo eq 'C'>
	                                               <cf_monto name="Monto_#Tipo#_#LvarMiso4217#" readonly="true" value="0.00"  class="Doc_input_#LvarMiso4217#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
	                                               <p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>
	                                              <cfelseif Tipo eq 'CxCE'>
	                                                <cf_monto name="Monto_#Tipo#_#LvarMiso4217#" readonly="true" value="0.00"  class="Doc_input_#LvarMiso4217#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
	                                                <p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>
	                                              <cfelse>
	                                                  <input type="hidden" name="Monto_#Tipo#_#LvarMiso4217#" value="#PayDiferencia#"/>
	                                              </cfif>
                                              <cfelse>

                                                    <cfif Tipo eq 'T' and isdefined('RolAdministrador')>
                                                   <cf_monto name="Monto_#Tipo#_#LvarMiso4217#"  class="Doc_input_#LvarMiso4217#" value="#PayTarjeta#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
                                                   <p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>
                                                    <cfelseif Tipo eq 'T' and not isdefined('RolAdministrador')>
                                                         <input type="hidden" name="Monto_#Tipo#_#LvarMiso4217#" value="#PayTarjeta#"/>
                                                     </cfif>

                                                  <cfif Tipo eq 'F' and isdefined('RolAdministrador')>
                                                   <cf_monto name="Monto_#Tipo#_#LvarMiso4217#"  class="Doc_input_#LvarMiso4217#" value="#PayDiferencia#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
                                                   <p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>

                                                    <cfelseif Tipo eq 'F' and not isdefined('RolAdministrador')>
                                                         <input type="hidden" name="Monto_#Tipo#_#LvarMiso4217#" value="#PayDiferencia#"/>
                                                    </cfif>
                                                    <cfif Tipo eq 'E' and isdefined('RolAdministrador')>
                                                   <cf_monto name="Monto_#Tipo#_#LvarMiso4217#"  class="Doc_input_#LvarMiso4217#" value="#PayEfectivo#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
                                                   <p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>               <cfelseif Tipo eq 'E' and not isdefined('RolAdministrador')>
                                                         <input type="hidden" name="Monto_#Tipo#_#LvarMiso4217#" value="#PayEfectivo#"/>
                                                    </cfif>
                                                    <cfif Tipo eq 'A' and isdefined('RolAdministrador')>
                                                   <cf_monto name="Monto_#Tipo#_#LvarMiso4217#"  class="Doc_input_#LvarMiso4217#" value="#PayDocumento#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
                                                   <p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>
                                                    <cfelseif Tipo eq 'A' and not isdefined('RolAdministrador')>
                                                         <input type="hidden" name="Monto_#Tipo#_#LvarMiso4217#" value="#PayDocumento#"/>
                                                     </cfif>
                                                     <cfif Tipo eq 'D' and isdefined('RolAdministrador')>
                                                   <cf_monto name="Monto_#Tipo#_#LvarMiso4217#"  class="Doc_input_#LvarMiso4217#" value="#PayDeposito#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
                                                   <p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>
                                                    <cfelseif Tipo eq 'D' and not isdefined('RolAdministrador')>
                                                         <input type="hidden" name="Monto_#Tipo#_#LvarMiso4217#" value="#PayDeposito#"/>
                                                    <cfelseif Tipo EQ 'CxCE' and isdefined('RolAdministrador')> <!--- danny --->
                                                    	<cf_monto name="Monto_#Tipo#_#LvarMiso4217#"  class="Doc_input_#LvarMiso4217#" value="#PayCxCExtraordinario#" id="Monto_#Tipo#" size="20" onChange="asignarTotal('Doc_input_#LvarMiso4217#','Doc_Dif_#LvarMiso4217#','doc_total_#LvarMiso4217#','doc_check_#LvarMiso4217#','doc_sob_#LvarMiso4217#','doc_falt_#LvarMiso4217#')">
                                                   		<p onclick="levantarPop('#LvarMcodigo#','#Tipo#','P','#form.FCid#');" style="cursor:pointer; color:##09C;"><i class="fa fa-search noPrint"></i></p>
                                                    </cfif>
                                            </cfif>
                                            </td>
										</tr>

									</cfloop>
                                     <cfset totalInicial = LSParseNumber(total) -  (LSParseNumber(MontoDiferencias) + LSParseNumber(MontoRemesas) + LSParseNumber(MontoTarjeta) + LSParseNumber(MontoDepositos) + LSParseNumber(MontoDocumentos) + LSParseNumber(MontoCxCExtraordinario))> <!--- danny --->
									 
									 <tr>
                                       <td width="10px" >&nbsp;

                                       </td>
                                      <td width="15px">&nbsp;

                                       </td>
                                       <td width="10px">



                                        <cfif isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
                                         <label>
                                         <cfif totalInicial lt 0>
                                        <span id="doc_sob_#Miso4217#"  style="color: ##0C0;">Sobrante</span>
                                        <cfelseif  totalInicial gt 0>
                                        <span id="doc_falt_#Miso4217#" style="color: ##F00;">Faltante</span>
                                        </cfif>
                                         <!---Diferencia:--->
                                        </label>
                                        </cfif>
                                       </td>
                                      </tr>
                                      <tr>
                                       <td width="10px" class="footer">

                                        <cfif isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
                                        <label>Total:</label>
                                        </cfif>
                                       </td>
                                       <td width="15px" class="footer">
                                        <cfif isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
                                        <strong>#Msimbolo##LSNumberFormat(total,',9.00')#</strong>
                                        </cfif>
                                         <input type="hidden" value="#total#" id="doc_total_#Miso4217#"/>
                                         <input type="hidden" value="#Miso4217#" id="moneda" name="moneda"/>
                                        </td>
                                        <td width="10px" >
                                        <cfset ValorInicial = #totalInicial# * -1>
										
                                         <cfif  isdefined('RolAdministrador') ><!--- SI  ES Supervisor --->
                                             <cf_monto name="Doc_Dif_#Miso4217#" id="Doc_Dif_#Miso4217#" value="#ValorInicial#" size="20" readonly="true">
                                         <cfelse>
                                             <input type="hidden" name="Doc_Dif_#Miso4217#" id="Doc_Dif_#Miso4217#" value="#ValorInicial#"  />
                                         </cfif>
                                       </td>
                                      </tr>
                                 </table>
							<hr style="margin:0;padding:0"/>

                           </div>
						</div>

					</cfloop>
        </cfif>
         </td>
     </tr>
      <tr class="noPrint">
        <cfif modo eq 'ALTA'>
            <td colspan="3" nowrap align="center">
                <!--- <input type="button" class="btnImprimir" onclick="window.print(); return false;" name="btnImprimir" value="Imprimir"> --->
                <input type="button" class="btnNormal" onclick="getReportes(#form.FCid#); return false;" name="btnReportes" value="Reportes">
            <!---    <input type="submit" class="btnNormal" name="btnAceptar" value="Aceptar">--->
              <cfif  not isdefined('RolAdministrador')>
                <input type="submit" class="btnNormal"   name="btnTerminar" value="Terminar">
                <input type="reset"  class="btnLimpiar" name="btnLimpiar" value="Limpiar">
              </cfif>
                <input type="button" class="btnAnterior" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
            </td>
        <cfelse>
            <td colspan="3" nowrap align="center">
                <input type="button" class="btnImprimir" onclick="window.print(); return false;" name="btnImprimir" value="Imprimir">
                <input type="button" class="btnNormal"   onclick="getReportes(#form.FCid#); return false;" name="btnReportes" value="Reportes">
               <!--- <input type="submit" class="btnGuardar" name="btnModificar" value="Guardar">--->
              <cfif  not isdefined('RolAdministrador')>
                <input type="submit" class="btnNormal"   name="btnTerminar" value="Terminar">
                <input type="reset"  class="btnLimpiar"  name="btnLimpiar" value="Limpiar">
              </cfif>
                <input type="button" class="btnAnterior" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
            </td>
        </cfif>
      </tr>
           <cfif isdefined('rsPagos') and rsPagos.recordcount gt 0>
             <cfset LvarLiberar = 0>
           </cfif>
             <input type="hidden" name="liberar" value="#LvarLiberar#" />
  <cfelse>
       <tr><td>&nbsp;</td></tr>
       <tr><td colspan="3" align="center"><strong><font size="2" color="##FF0000">No existen datos para el Cierre</font></strong></td></tr>
       <tr><td>&nbsp;</td></tr>
       <tr>
         <td nowrap align="center">
             <input type="button" class="btnAnterior" name="btnRegresar" value="Regresar" onClick="javascript: regresar();">
             <cfif  not isdefined('RolAdministrador')>
             <input type="submit" class="btnAnterior" name="btnLiberar" value="Liberar caja y Regresar">
                 <cfif isdefined('rsMonedasT') and rsMonedasT.recordcount eq 0>
                    <cfset LvarLiberar = 1>
                 </cfif>
                 <input type="hidden" name="liberar" value="#LvarLiberar#" />
             </cfif>


         </td>
       </tr>
  </cfif>
    <tr><td><input type="hidden" name="FCid" value="#form.FCid#"></td></tr>
  </cfoutput>
</table>
</form>
<cfelse>
	<script language="JavaScript1.2" type="text/javascript">
		function regresar(){
			document.form2.action = "/cfmx/sif/fa/operacion/listaTransaccionesFA.cfm";
			document.form2.submit();
		}
	</script>
	<form action="" name="form2" method="post">
	<table width="100%">
	<cfif caja eq 1 >
		<tr>
			<td align="right" width="50%"><font size="2">Seleccione la Caja para el Cierre:&nbsp;</font></td>
			<td align="left" width="50%">
				<select name="sFCid" onChange="javascript:document.form2.submit();">
					<option value="-1">--Seleccionar Caja--</option>
					<cfoutput query="rsCajasUsuario" >
						<option value="#rsCajasUsuario.FCid#">#rsCajasUsuario.FCdesc#</option>
					</cfoutput>
				</select>
			</td>
		</tr>
	<cfelse>
        <tr><td align="center">&nbsp;</td></tr>
		<tr><td align="center"><font size="2" color="##FF0000"><b>No se han autorizado Cajas para este Usuario.</b></font></td></tr>
	</cfif>
		<tr><td>&nbsp;</td></tr>
		<tr><td align="center" colspan="2"><input class="btnAnterior" type="button" name="btnRegresar" value="Regresar" onClick="javascript: regresar();"></td></tr>
	  </table>
	</form>
</cfif>
  <cf_Confirm width="92" index="1" title="Información detallada de los montos" botones="Imprimir, Cancelar" funciones="ImprimirDetalle">
	 	<div id="detallesDiv" style="max-height:430px; overflow:scroll">

        </div>
    </cf_Confirm>
   <cf_Confirm width="92" index="2" title="Información del sistema" botones="Cancelar">
	 	<div id="infoAlert" style="max-height:430px;">
            <h5 style="color:#F30; text-align:left;">La caja tiene un cierre pendiente pero el usuario no es responsable de esta caja <i class="fa fa-frown-o"></i></h5>
        </div>
    </cf_Confirm>

    <iframe id="print_frame" name="print_frame" width="0" height="0" frameborder="0" src="about:blank"></iframe>

			<script language="JavaScript1.2" src="../../js/utilesMonto.js"></script>
			<script language="JavaScript1.2" type="text/javascript">

				$(document).ready(function(){
					$('.iconoSistema').parents('table').first().addClass('noPrint');
				});

				function Cancelar(){}

			   //Asigna la diferencia de la suma de los montos por documento - el total de lo registrado por los cajeros.
				function asignarTotal(clase,id_total,id_montoOri,id_check,id_sob,id_falt){
					var total = 0;
				    var diferencia= 0;
					var temp;
					$('.' + clase ).each(function(){
						var temp = parseFloat(normalizarMonto($(this).val()));
						total += temp;
					});

					diferencia = total - parseFloat(normalizarMonto($('#' + id_montoOri).val()));
					diferencia = diferencia.toFixed(2);
					if(diferencia == 0.00)
					{
						 $('#' + id_check).show();
						 $('#' + id_sob).hide();
  					     $('#' + id_falt).hide();
					}
					   else
					{
						 $('#' + id_check).hide();
						 if(diferencia > 0)
						 {
						  $('#' + id_sob).show();
						  $('#' + id_falt).hide();
					     }
						if(diferencia < 0 )
						 {
							 $('#' + id_falt).show();
							 $('#' + id_sob).hide();
					     }

					}

					$('#' + id_total)
									  .val(diferencia)
									  .blur();
				}

				function normalizarMonto(monto) {
				  //debugger;
				  monto = monto.toString();
				  monto = monto.split(',').join('');
				  monto = monto.split('.').join('.');
				  return monto;
				}

			   function levantarPop(moneda,tipo,ubicacion,Caja) {
				PopUpAbrir1();
				$('#detallesDiv').html('<div style="text-align:center;"> <h3 style="display: inline;"> Cargando ... </h3><i class="fa fa-spinner fa-spin fa-4x center"></i></div>');
   				 $('#detallesDiv').load('DetallesMontos.cfm?moneda='+ moneda +'&tipo=' + tipo + '&ubicacion=' + ubicacion + '&caja=' + Caja);

				}

				function habilitar(){
					var total   = document.form1.elements.length;
					for (var i=0; i<total; i++){
						if ( document.form1.elements[i].type ==  'text' ){
							if ( document.form1.elements[i].disabled ) {
								document.form1.elements[i].disabled = false;
							}
							document.form1.elements[i].value = qf(document.form1.elements[i].value);
						}
					}
				}

        <!-----VALIDAR ---->
     	function validar(){
				debugger;
				if (document.form1.mostrarMensajeRemesaPendiente.value == 1)
				{
				  alert("No se ha realizado ninguna remesa para esta caja. No se puede realizar el cierre.");
				  return false;
				}

              <cfoutput query="rsMonedasP">
			     if (document.form1.Doc_Dif_#Miso4217#.value < 0)
				 {
					 if(!confirm("¿El cierre de caja va a generar un faltante de " + document.form1.Doc_Dif_#Miso4217#.value + " , desea continuar?"))
					  {
						  return false;
					  }
				 }
			  </cfoutput>

              <cfoutput query="rsMonedasP">
			     if (document.form1.Doc_Dif_#Miso4217#.value > 0)
				 {
					 if(!confirm("¿El cierre de caja va a generar un sobrante de " + document.form1.Doc_Dif_#Miso4217#.value + " , desea continuar?"))
					  {
						  return false;
					  }
				 }
			  </cfoutput>
			  
				if (document.form1.liberar.value == 0)
				{

					 if(!confirm("¿Desea aplicar el cierre de la caja:  <cfoutput>#rsCaja.FCcaja#</cfoutput> ? "))
					  {
						  return false;
					  }


					var total   = document.form1.elements.length;
					var mensaje = 'Se presentaron los siguientes errores:\n\n';
					var error = false;
					for (var i=0; i<total; i++){
						if ( document.form1.elements[i].type ==  'text' ){
							if ( document.form1.elements[i].value == '' ) {
								error    = true;
								mensaje +=  ' - ' + document.form1.elements[i].alt + ' es requerido. \n'
							}
						}
					}

					if (error){
						alert(mensaje);
					}
					else{
						habilitar();
					}

					return !error;
				  }<!----- Fin del  si liberar != 1 ---->
				}

				function diferencias (pcontado, pdinero, moneda){
					var contado = new Number(qf(pcontado))
					var dinero  = new Number(qf(pdinero))
					var diferencia = Math.abs(contado - dinero);
					eval('document.form1.FADCdiferencias_' + moneda).value = diferencia;
					fm(eval('document.form1.FADCdiferencias_' + moneda), 2);
				}

				function total_documentos(moneda){
					var contado  = new Number(qf(eval('document.form1.FADCcontado_' + moneda + '.value')));
					eval('document.form1.totalFADCcontado_' + moneda).value = contado;
					fm(eval('document.form1.totalFADCcontado_' + moneda), 2);

					//calcula las diferencias
					diferencias(eval('document.form1.totalFADCcontado_' + moneda).value, eval('document.form1.totalFADCdinero_' + moneda).value, moneda);
				}

				function ftotal_dinero(moneda){
					var efectivo   = new Number(qf(eval('document.form1.FADCefectivo_' + moneda + '.value')));
					var cheques    = new Number(qf(eval('document.form1.FADCcheques_' + moneda + '.value')));
					var vouchers   = new Number(qf(eval('document.form1.FADCvouchers_' + moneda + '.value')));
					var depositos  = new Number(qf(eval('document.form1.FADCdepositos_' + moneda + '.value')));
					var documentos = new Number(qf(eval('document.form1.FADCdocumentos_' + moneda + '.value')));

					eval('document.form1.totalFADCdinero_' + moneda).value = efectivo + cheques + vouchers + depositos + documentos;
					fm(eval('document.form1.totalFADCdinero_' + moneda), 2);

					// calcula las diferencias
					diferencias(eval('document.form1.totalFADCcontado_' + moneda).value, eval('document.form1.totalFADCdinero_' + moneda).value, moneda);
				}

				function calculos(moneda){
					// tipo de cambio
					var tc = new Number(qf(eval("document.form1.FADCtc_" + moneda + ".value")));

					// facturas
					var contado   = new Number(qf(eval("document.form1.FADCcontado_" + moneda + ".value"))*tc );

					// efectivo
					var efectivo   = new Number(qf(eval("document.form1.FADCefectivo_" + moneda + ".value"))*tc );
					var cheques    = new Number(qf(eval("document.form1.FADCcheques_" + moneda + ".value"))*tc );
					var vouchers   = new Number(qf(eval("document.form1.FADCvouchers_" + moneda + ".value"))*tc );
					var depositos  = new Number(qf(eval("document.form1.FADCdepositos_" + moneda + ".value"))*tc );
					var documentos = new Number(qf(eval("document.form1.FADCdocumentos_" + moneda + ".value"))*tc );
					var total_efectivo =  efectivo + cheques + vouchers + depositos + documentos;

					// credito
					var facturas  = new Number(qf(eval("document.form1.FADCfcredito_" + moneda + ".value"))*tc );
					var notas = new Number(qf(eval("document.form1.FADCncredito_" + moneda + ".value"))*tc );
					var total_credito = facturas - notas;

					// hacer un objeto oculto donde ponga los resultados y los modifique cada vez que recalcula
					return new Array(contado, total_efectivo, total_credito);
				}

			/*
				function total(moneda){}
				function total2(moneda){alert(moneda)}
				*/

				function total(){
				// RESULTADO
				// Calcula los montos totales, en moneda local, al tipo de cambio que se capturo para cada moneda.
				// datos[0] = facturas de contado
				// datos[1] = total de efectivo
				// datos[2] = total de credito

					moneda = document.form1.Mcodigo.value;
					total_docs    = 0;
					total_dinero  = 0;
					total_credito = 0;

					// es un arreglo de monedas
					if (document.form1.Mcodigo.length >= 1){
						for (var i=0; i<document.form1.Mcodigo.length; i++ ){
							datos = calculos(document.form1.Mcodigo[i].value);
							total_docs    = parseFloat(total_docs)   +  parseFloat(datos[0]);
							total_dinero  = parseFloat(total_dinero) + parseFloat(datos[1]);
							total_credito = parseFloat(total_credito) + parseFloat(datos[2]);
						}
					}
					// es una sola moneda
					else{
						datos = calculos(moneda);
							total_docs    = parseFloat(total_docs)   +  parseFloat(datos[0]);
							total_dinero  = parseFloat(total_dinero) + parseFloat(datos[1]);
							total_credito = parseFloat(total_credito) + parseFloat(datos[2]);
					}



					document.form1.tFAcontado.value   = fm(total_docs, 2);
					document.form1.tFAdinero.value    = fm(total_dinero, 2);
					document.form1.tcFAcredito.value  = fm(total_credito, 2);
					document.form1.tdFAcredito.value  = fm(total_credito, 2);
					document.form1.tContado.value     = fm(total_docs+total_credito, 2);
					document.form1.tDinero.value      = fm(total_dinero+total_credito, 2);
				}

				function regresar(){

					<cfif  not isdefined('RolAdministrador')>
					   document.form1.action = "/cfmx/sif/fa/operacion/listaTransaccionesFA.cfm";
					<cfelse>
					  document.form1.action = "/cfmx/sif/fa/operacion/CierreCaja-supervisor.cfm";
					</cfif>
					document.form1.submit();
				}
				function ImprimirDetalle(){
					window.frames['print_frame'].document.body.innerHTML = $('#detallesDiv').html();
					window.frames["print_frame"].window.focus();
					window.frames["print_frame"].window.print();
				    //var originalContents = document.body.innerHTML;
				    //document.body.innerHTML = printContents;
				    //window.print();
				    //document.body.innerHTML = originalContents;
				}
				function getReportes(caja)
				{
				   window.location.assign("/cfmx/crc/cobros/consultas/reporteCierre.cfm?caja=" + caja);
				}
				function Cancelar(){
					PopUpCerrar1();
					PopUpCerrar2();
				}
			</script>