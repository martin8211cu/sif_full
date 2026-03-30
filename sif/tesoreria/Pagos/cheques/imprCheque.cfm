<cf_navegacion name="TESCFLid">
<cfset LvarReimpresionEspecial = false>
<style type="text/css">
<!--
.style1 {
	font-size: 16px;
	font-weight: bold;
	text-align:center;
}
-->
</style>
<cfif isdefined('Reimpresion')>
	<cfquery name="rsSQL" datasource="#session.dsn#">
		select TESCFLespecial
		  from TEScontrolFormulariosL
		 where TESid	= #session.Tesoreria.TESid#
		   and TESCFLid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
	</cfquery>
	<cfset LvarReimpresionEspecial = rsSQL.TESCFLespecial EQ "1">
</cfif>
<cfquery datasource="#session.dsn#" name="rsForm">
    Select TESCFLid, cfl.CBid, Edescripcion as empPago, Bdescripcion as bcoPago, Mnombre as monPago, CBcodigo, cfl.TESMPcodigo, TESMPdescripcion, TESCFLfecha,
            case TESCFLestado
                when 0 then '<strong>En preparacion</strong>'
                when 1 then '<strong>En impresión</strong>'
                when 2 then '<strong>No Emitido</strong>'
                when 3 then '<strong>Emitido</strong>'
            end as Estado,
            FMT01COD, cfl.TESCFLestado, TESCFLcancelarAIni, TESCFLcancelarAFin, TESCFLimpresoIni, TESCFLimpresoFin, TESCFLcancelarDIni, TESCFLcancelarDFin,
            cfl.TESCFTnumInicial, cft.TESCFTnumFinal, cft.TESCFTultimo,
            case cft.TESCFTultimo
                when 0 then cft.TESCFTnumInicial
                else cft.TESCFTultimo+1
            end as TESCFTsiguiente,
            Miso4217
    from TEScontrolFormulariosL cfl
        inner join TEScuentasBancos tcb
            inner join CuentasBancos cb
                inner join Monedas m
                     on m.Mcodigo 	= cb.Mcodigo
                    and m.Ecodigo  	= cb.Ecodigo
                inner join Bancos b
                     on b.Ecodigo 	= cb.Ecodigo
                    and b.Bid  		= cb.Bid
                inner join Empresas e
                    on e.Ecodigo	= cb.Ecodigo
                 on cb.CBid=tcb.CBid
             on tcb.TESid	= cfl.TESid
            and tcb.CBid	= cfl.CBid
            and tcb.TESCBactiva = 1
        inner join TESmedioPago mp
             on mp.TESid		= cfl.TESid
            and mp.CBid			= cfl.CBid
            and mp.TESMPcodigo 	= cfl.TESMPcodigo
        left join TEScontrolFormulariosT cft
             on cft.TESid		= cfl.TESid
            and cft.CBid			= cfl.CBid
            and cft.TESMPcodigo 	= cfl.TESMPcodigo
            and cft.TESCFTnumInicial= cfl.TESCFTnumInicial
    where cfl.TESid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
      and cb.CBesTCE = <cfqueryparam value="0" cfsqltype="cf_sql_bit">			
      and TESCFLid=<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">					
</cfquery>
<cfquery datasource="#session.dsn#" name="rsTESOP">
    <cfif isdefined('Reimpresion')>
        select count(1) as cantidad
        from TEScontrolFormulariosD
        where TESid				  = #session.Tesoreria.TESid#
          and CBid			      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	
          and TESMPcodigo		  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">	
          and TESCFLidReimpresion = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TESCFLid#">
    <cfelse>
        select count(1) as cantidad
          from TESordenPago
         where TESid		= #session.Tesoreria.TESid#
           and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	
           and TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">	
           and TESCFLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TESCFLid#">	
     </cfif>
</cfquery>
<cfquery datasource="#session.dsn#" name="rsOPs">
    select count(1) as cantidad, sum(round(op.TESOPtotalPago,2)) as total<!---, count(distinct TESTDreferencia) as conReferencia--->
      from TESordenPago op
        <!---left join TEStransferenciasD td
             on td.TESid 	= op.TESid
            and td.TESOPid 	= op.TESOPid
            and td.TESTLid	= op.TESTLid
            and td.TESTDestado <> 3--->
     where op.TESid		= #session.Tesoreria.TESid#
       and op.CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">	
       and op.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">	
       and op.TESCFLid		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.TESCFLid#">	
</cfquery>

<cfoutput>
    <table width="100%" border="0" cellspacing="0" cellpadding="0">
        <tr><td class="style1" colspan="4">Lote de <cfif isdefined('Reimpresion')>Reimpresi&oacute;n<cfelse>Impresi&oacute;n</cfif> de Cheques</td></tr>	  
        <tr>
            <td valign="top">Numero Lote:</td>
            <td valign="top"><strong>#rsForm.TESCFLid#</strong></td>
            <td valign="top">Cuenta Bancaria de Pago:</td>
            <td valign="top"><strong>#rsForm.CBcodigo#</strong></td>
        </tr>		  
        <tr>
            <td valign="top">Estado del Lote:</td>
            <td valign="top"><strong>#rsForm.Estado#</strong></td>
            <td valign="top">Moneda de Pago:</td>
            <td valign="top"><strong>#rsForm.monPago#</strong></td>
        </tr>		  
        <tr>
            <td valign="top">Empresa de Pago:</td>
            <td valign="top"><strong>#rsForm.empPago#</strong></td>
            <td valign="top">Medio de Pago:</td>
            <td valign="top"><strong>#rsForm.TESMPdescripcion#</strong></td>
        </tr>		  
        <tr>
            <td valign="top">Banco de Pago:</td>
            <td valign="top"><strong>#rsForm.bcoPago#</strong></td>
            <td valign="top">Monto Total de OPs en Lote:&nbsp:</td>
            <td valign="top"><strong>#NumberFormat(rsOPs.total,",9.99")#</strong></td>
        </tr>		  
		<cfif isdefined("url.btnSeleccionarOP")>
			<cfset sbListaCheques("SEL")>
		<cfelseif rsForm.TESCFLestado EQ "0">
			<!--- EN PREPARACION --->
			<cfif rsTESOP.cantidad GT 0>
                <cfset LvarCantidades = fnVerificaFechas()>
                <cfif LvarCantidades.OtrosMeses GT 0>
                    <cfset LvarDisabled = "disabled">
                <cfelse>
                    <cfset LvarDisabled = "">
                </cfif>
                <cfset LvarActualizarFecha = (LvarCantidades.OtrosMeses GT 0 OR LvarCantidades.OtrosDias NEQ 0) AND not isdefined("reimpresion")>
            </cfif>
			<cfif isdefined("LvarActualizarFecha") AND LvarActualizarFecha>
				<tr><td colspan="4" align="center" style="color:##CC0000;">Existen Órdenes de Pago con Fechas de Pago diferentes a la fecha actual</td></tr>
			</cfif>
			<cfif isdefined("LvarDisabled") AND LvarDisabled EQ "disabled">
				<tr><td colspan="4" align="center" style="color:##CC0000;">Existen Órdenes de Pago con Fechas de Pago que no correponden ni al mes actual ni al siguiente de auxiliares<BR>(No se puede mandar a imprimir)</td></tr>
			</cfif>
			<cfset sbListaCheques('0')>
		<cfelseif rsForm.TESCFLestado EQ "1">
			<!--- EN IMPRESION --->
			<cfset LvarCantidades = fnVerificaFechas()>
        
            <cfif LvarCantidades.OtrosMeses GT 0>
                <cfset LvarDisabled = "disabled">
            <cfelse>
                <cfset LvarDisabled = "">
            </cfif>
            <cfset LvarActualizarFecha = (LvarCantidades.OtrosMeses GT 0 OR LvarCantidades.OtrosDias NEQ 0) AND not isdefined("reimpresion")>
			<cfif isdefined("LvarActualizarFecha") AND LvarActualizarFecha>
				<tr><td colspan="4" align="center" style="color:##CC0000;">Existen Órdenes de Pago con Fechas de Pago diferentes a la fecha actual</td></tr>
			</cfif>
			<cfif isdefined("LvarDisabled") AND LvarDisabled EQ "disabled">
				<tr><td colspan="2" align="center" style="color:##CC0000;">Existen Órdenes de Pago con Fechas de Pago que no correponden ni al mes actual ni al siguiente de auxiliares<BR>(No se puede mandar a imprimir)</td></tr>  
			</cfif>
            <tr><td colspan="2" align="center"><cfset sbListaCheques('1')></td></tr>
		<cfelseif rsForm.TESCFLestado EQ "2">
			<!--- RESULTADO DE LA IMPRESION --->
			<cfquery name="rsDocs" datasource="#session.dsn#">
				select count(1) as cantidad
					 , max(TESCFDnumFormulario) as ultimo
				  from TEScontrolFormulariosD
				 where TESid			= #session.Tesoreria.TESid#
				   and CBid				= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
				   and TESMPcodigo		= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
				   and TESCFLid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
				   and TESCFDestado		= 0
			</cfquery>
			<cfset sbListaCheques('2')>
		</cfif>
		</table>
	</cfoutput>
<cffunction name="sbListaCheques" output="true">
	<cfargument name="Estado" type="string" default="no">
	<cfinclude template="../../../Utiles/sifConcat.cfm">
    <table width="100%">
	<cfif Arguments.Estado EQ 'SEL'>
		<cfquery name="rsIC" datasource="#session.dsn#">
			<cfif isdefined('Reimpresion')>
				select TESOPid, cfd.TESCFDnumFormulario as ID, 
						TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(TESOPbeneficiarioSuf,'') as TESOPbeneficiario, 
						TESOPfechaPago, TESOPtotalPago
				from TEScontrolFormulariosD cfd
				
				left outer join TESordenPago op
				  on cfd.TESOPid = op.TESOPid and
					 cfd.CBid = op.CBidPago and
					 cfd.TESMPcodigo = op.TESMPcodigo
					 
				where cfd.TESid		= #session.Tesoreria.TESid#
				   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#"> 
				   and <cf_dbfunction name="Date_Format" args="TESCFDfechaEmision,YYYYMMDD"> = '#DateFormat(Now(),'YYYYMMDD')#'
				   and TESCFDestado = 1
				   and cfd.TESCFLidReimpresion is null
			<cfelse>
				SELECT TESOPid, TESOPid as ID, TESOPnumero, TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(TESOPbeneficiarioSuf,'') as TESOPbeneficiario, TESOPfechaPago, TESOPtotalPago
				 FROM TESordenPago
				 where TESid		= #session.Tesoreria.TESid#
				   and CBidPago		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
				   and TESCFLid		IS null
				   and TESOPestado = 11
				   and (
						TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
						OR	TESMPcodigo	is null
					   )
			  </cfif>
		</cfquery>
		<cfif isdefined('Reimpresion')>
			<cfset etiqueta = "Num.Cheque">
			<cfset etiquetaDat = "ID">
		<cfelse>
			<cfset etiqueta = "Num.Orden">
			<cfset etiquetaDat = "TESOPnumero">
		</cfif>
        <tr><td colspan="4">&nbsp;</td></tr>  
        <tr><td align="center" colspan="4">
				<cfif isdefined('Reimpresion')>
					<strong>Lista de Cheques del d&iacute;a</strong>
				<cfelse>
					<strong>Lista de Ordenes de Pago enviadas a Emisión sin Lote de Impresión Asignadas</strong>
				</cfif>
		</td></tr>
        <tr><td colspan="4" align="center" nowrap>
        	<table width="100%">
                <cfloop query="rsIC">
                	<tr>
                        <td class="tituloListas" align="center"><strong>#etiqueta#</strong></td>
                        <td class="tituloListas" align="center"><strong>Fecha Pago</strong></td>
                        <td class="tituloListas" align="center"><strong>Beneficiario</strong></td>
                        <td class="tituloListas" align="center"><strong>Monto<BR>#replace(rsForm.monPago,",","")#</strong></td>
                    </tr>
                	<tr class="<cfif rsIC.currentrow mod 2 eq 0>ListaNon<cfelse>ListaPar</cfif>">
                        <td align="center">#etiquetaDat#</td>
                        <td>#rsIC.TESOPfechaPago#</td>
                        <td>#rsIC.TESOPbeneficiario#</td>
                        <td align="right">#NumberFormat(rsIC.TESOPtotalPago,",0.00")#</td>
                	</tr>
                    <tr><td>&nbsp;</td><td colspan="6"><cfset sbPoneDetalle(rsIC.TESOPid)></td></tr>
                </cfloop>
            </table>	
        </td></tr>
	<cfelseif Arguments.Estado EQ '0'>
		<cfquery name="rsIC" datasource="#session.dsn#">
			<cfif isdefined('Reimpresion')>
				select TESOPid,
					cfd.TESCFDnumFormulario as ID, 
				<cfif LvarReimpresionEspecial>
					<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> as TESOPfechaPago,
				<cfelse>
					op.TESOPfechaPago, 
				</cfif>
					op.TESOPtotalPago
				  , TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(TESOPbeneficiarioSuf,'') as TESOPbeneficiario
				  , case when <cf_dbfunction name="length"	args="op.TESEcodigo"> > 1 then 
						'<span onclick="sbVer(''E'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Endoso
                 <!---     , case when len(op.TESOPobservaciones) > 1 then  --->
				  , case when <cf_dbfunction name="islobnotnull" args="op.TESOPobservaciones"> then  
						'<span onclick="sbVer(''O'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Entrega
				  , case when <cf_dbfunction name="length"	args="op.TESOPinstruccion"> > 1 then 
						'<span onclick="sbVer(''I'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as AlBanco
				<cfif LvarReimpresionEspecial>
				  , ''
				<cfelse>
				  , '<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("¿Desea excluir el Cheque de este Lote de Impresion?")) return false; location.href="impresionCheques_sql.cfm?btnExcluirOP=1&Reimpresion=1&TESCFLid=#form.TESCFLid#&TESCFDnumFormulario=' #_Cat# <cf_dbfunction name="to_Char" args="cfd.TESCFDnumFormulario">#_Cat# '";''>' 
				</cfif>
					as Borrar
				  from TEScontrolFormulariosD cfd
					left outer join TESordenPago op
						 on op.TESOPid		= cfd.TESOPid 
						and op.CBidPago		= cfd.CBid
						and op.TESMPcodigo	= cfd.TESMPcodigo
				where cfd.TESid					= #session.Tesoreria.TESid#
				  and cfd.CBid					= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#rsForm.CBid#">
				  and cfd.TESMPcodigo			= <cfqueryparam cfsqltype="cf_sql_varchar"	value="#rsForm.TESMPcodigo#">
				  and cfd.TESCFLidReimpresion	= <cfqueryparam cfsqltype="cf_sql_numeric"	value="#form.TESCFLid#">
				<cfif NOT LvarReimpresionEspecial>
				  and <cf_dbfunction name="to_sdate" args="cfd.TESCFDfechaEmision">	= <cfqueryparam cfsqltype="cf_sql_date"		value="#Now()#">
				</cfif>
				  and cfd.TESCFDestado   		= 1
			<cfelse>
				select TESOPid,
				    op.TESOPnumero as ID, 
					op.TESOPfechaPago, 
					op.TESOPtotalPago,
				   	op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario
				  , case when <cf_dbfunction name="length"	args="op.TESEcodigo"> > 1 then 
						'<span onclick="sbVer(''E'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Endoso
                  <!---  , case when len(op.TESOPobservaciones) > 1 then  --->
				  , case when <cf_dbfunction name="islobnotnull" args="op.TESOPobservaciones"> then  
						'<span onclick="sbVer(''O'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Entrega
				  , case when <cf_dbfunction name="length"	args="op.TESOPinstruccion"> > 1 then 
						'<span onclick="sbVer(''I'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as AlBanco
				  , '<img src=''/cfmx/sif/imagenes/Borrar01_S.gif'' width=''16'' height=''16'' style=''cursor:pointer;'' onClick=''document.nosubmit=true; if (!confirm("¿Desea excluir la Orden de Compra de este Lote de Impresion?")) return false; location.href="impresionCheques_sql.cfm?btnExcluirOP=1&TESCFLid=#form.TESCFLid#&TESOPid=' #_Cat# <cf_dbfunction name="to_Char" args="TESOPid"> #_Cat# '";''>'
					 as Borrar
				 FROM TESordenPago op
				where TESid	   = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
				  and TESCFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
			</cfif>
		</cfquery>
		<cfif isdefined('Reimpresion')>
			<cfset etiqueta = "Num.Cheque">
		<cfelse>
			<cfset etiqueta = "Num.Orden">
		</cfif>
		<cfset MontoMoneda = Replace(rsForm.monPago,',',' -','all')>
        <tr><td colspan="4">&nbsp;</td></tr>  
        <tr><td colspan="4" align="center" nowrap>
        	<table width="100%">
                <cfloop query="rsIC">
                	<tr>
                        <td class="tituloListas" align="center"><strong>#etiqueta#</strong></td>
                        <td class="tituloListas" align="center"><strong>Fecha<br />Pago</strong></td>
                        <td class="tituloListas" align="center"><strong>Beneficiario</strong></td>
                        <td class="tituloListas" align="center"><strong>Monto<BR>#MontoMoneda#</strong></td>
                        <td class="tituloListas" align="center"><strong>Endoso</strong></td>
                        <td class="tituloListas" align="center"><strong>Entrega</strong></td>
                        <td class="tituloListas" align="center"><strong>Al Banco</strong></td>
                    </tr>
                	<tr class="<cfif rsIC.currentrow mod 2 eq 0>ListaNon<cfelse>ListaPar</cfif>">
                        <td align="center">#rsIC.ID#</td>
                        <td>#rsIC.TESOPfechaPago#</td>
                        <td>#rsIC.TESOPbeneficiario#</td>
                        <td align="right">#NumberFormat(rsIC.TESOPtotalPago,",0.00")#</td>
                        <td align="right">#rsIC.Endoso#</td>
                        <td align="right">#rsIC.Entrega#</td>
                        <td align="right">#rsIC.AlBanco#</td>
                	</tr>
                    <tr><td>&nbsp;</td><td colspan="6"><cfset sbPoneDetalle(rsIC.TESOPid)></td></tr>
                </cfloop>
            </table>	
        </td></tr>
	<cfelseif Arguments.Estado EQ '1'>
		<cfquery name="rsIC" datasource="#session.dsn#">
			select op.TESOPid, cfd.TESCFDnumFormulario as Cheque
				<cfif isdefined('Reimpresion')>
				  ,	viejo.TESCFDnumFormulario as VIEJO
				</cfif>
				  , op.TESOPnumero
				<cfif LvarReimpresionEspecial>
				  ,	<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> as TESOPfechaPago
				<cfelse>
				  ,	op.TESOPfechaPago
				</cfif>
				  , op.TESOPtotalPago
				  ,	op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario
				  , case when <cf_dbfunction name="length"	args="op.TESEcodigo"> > 1 then 				  
						'<span onclick="sbVer(''E'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Endoso
				  <!--- , case when len(op.TESOPobservaciones) > 1 then  --->
                  , case when <cf_dbfunction name="islobnotnull" args="op.TESOPobservaciones"> then  
						'<span onclick="sbVer(''O'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Entrega
				  , case when <cf_dbfunction name="length"	args="op.TESOPinstruccion"> > 1 then 
						'<span onclick="sbVer(''I'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as AlBanco
				  , ' ' as Blanco
			  from TEScontrolFormulariosD cfd
				inner join TESordenPago op
				  on cfd.TESOPid 	   	= op.TESOPid
				 and cfd.CBid 	   		= op.CBidPago
				 and cfd.TESMPcodigo 	= op.TESMPcodigo
		<cfif isdefined('Reimpresion')>
				inner join TEScontrolFormulariosD viejo
					 on viejo.TESid					= cfd.TESid
					and viejo.CBid					= cfd.CBid
					and viejo.TESMPcodigo			= cfd.TESMPcodigo
					and viejo.TESCFLidReimpresion	= cfd.TESCFLid
					and viejo.TESOPid				= cfd.TESOPid
					and viejo.TESCFDestado   		= 1
		</cfif>
			where cfd.TESid			= #session.Tesoreria.TESid#
			  and cfd.CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
			  and cfd.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
			  and cfd.TESCFLid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfset MontoMoneda = Replace(rsForm.monPago,',',' -','all')>
		<cfif isdefined('Reimpresion')>
			<cfset etiqueta = "Num.Cheque<BR>a Anular">
			<cfset etiquetaDat = "VIEJO">
		<cfelse>
			<cfset etiqueta = " ">
			<cfset etiquetaDat = "Blanco">
		</cfif>
        <tr><td colspan="4">&nbsp;</td></tr>  
        <tr><td colspan="4" align="center" nowrap>
        	<table width="100%">
                <cfloop query="rsIC">
                	<tr>
                        <td class="tituloListas" align="center"><strong>Num. Cheque<BR>a Imprimir</strong></td>
                        <td class="tituloListas" align="center"><strong>#etiqueta#</strong></td>
                        <td class="tituloListas" align="center"><strong>Num.Orden</strong></td>
                        <td class="tituloListas" align="center"><strong>Fecha<br />Pago</strong></td>
                        <td class="tituloListas" align="center"><strong>Beneficiario</strong></td>
                        <td class="tituloListas" align="center"><strong>Monto<BR>#MontoMoneda#</strong></td>
                        <td class="tituloListas" align="center"><strong>Endoso</strong></td>
                        <td class="tituloListas" align="center"><strong>Entrega</strong></td>
                        <td class="tituloListas" align="center"><strong>Al Banco</strong></td>
                    </tr>
                	<tr class="<cfif rsIC.currentrow mod 2 eq 0>ListaNon<cfelse>ListaPar</cfif>">
                        <td align="center">#rsIC.Cheque#</td>
                        <td>#etiquetaDat#</td>
                        <td>#rsIC.TESOPnumero#</td>
                        <td align="right">#rsIC.TESOPtotalPago#</td>
                        <td align="right">#rsIC.TESOPfechaPago#</td>
                        <td align="right">#rsIC.TESOPbeneficiario#</td>
                        <td align="right">#NumberFormat(rsIC.TESOPtotalPago,",0.00")#</td>
                        <td align="right">#rsIC.Endoso#</td>
                        <td align="right">#rsIC.Entrega#</td>
                        <td align="right">#rsIC.AlBanco#</td>
                	</tr>
                    <tr><td>&nbsp;</td><td colspan="6"><cfset sbPoneDetalle(rsIC.TESOPid)></td></tr>
                </cfloop>
            </table>	
        </td></tr>
	<cfelseif Arguments.Estado EQ '2'>
		<cfquery name="rsIC" datasource="#session.dsn#">
			select TESOPid,
					cfd.TESCFDnumFormulario as Cheque
				<cfif isdefined('Reimpresion')>
				  ,	viejo.TESCFDnumFormulario as VIEJO
				</cfif>
				  , ' ' as Blanco
				  , op.TESOPnumero
				<cfif LvarReimpresionEspecial>
				  ,	<cfqueryparam cfsqltype="cf_sql_date" value="#now()#"> as TESOPfechaPago
				<cfelse>
				  ,	op.TESOPfechaPago
				</cfif>
				  , op.TESOPtotalPago
				  ,	op.TESOPbeneficiario #_Cat# ' ' #_Cat# coalesce(op.TESOPbeneficiarioSuf,'') as TESOPbeneficiario
				  , case when <cf_dbfunction name="length"	args="op.TESEcodigo"> > 1 then 
						'<span onclick="sbVer(''E'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Endoso
	<!---			  , case when len(op.TESOPobservaciones) > 1 then  --->
                  , case when <cf_dbfunction name="islobnotnull" args="op.TESOPobservaciones"> then  
						'<span onclick="sbVer(''O'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as Entrega
				  , case when <cf_dbfunction name="length"	args="op.TESOPinstruccion"> > 1 then 
						'<span onclick="sbVer(''I'',' #_Cat# <cf_dbfunction name="to_Char" args="op.TESOPid"> #_Cat# ');" style="cursor:pointer;">SÍ</span>' 
					end as AlBanco
			  from TEScontrolFormulariosD cfd
				inner join TESordenPago op
				  on cfd.TESOPid 	   	= op.TESOPid
				 and cfd.CBid 	   		= op.CBidPago
				 and cfd.TESMPcodigo 	= op.TESMPcodigo
		<cfif isdefined('Reimpresion')>
				inner join TEScontrolFormulariosD viejo
					 on viejo.TESid					= cfd.TESid
					and viejo.CBid					= cfd.CBid
					and viejo.TESMPcodigo			= cfd.TESMPcodigo
					and viejo.TESCFLidReimpresion	= cfd.TESCFLid
					and viejo.TESOPid				= cfd.TESOPid
					and viejo.TESCFDestado   		= 1
		</cfif>
			where cfd.TESid			= #session.Tesoreria.TESid#
			  and cfd.CBid			= <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsForm.CBid#">
			  and cfd.TESMPcodigo	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsForm.TESMPcodigo#">
			  and cfd.TESCFLid 		= <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">
		</cfquery>
		<cfset MontoMoneda = Replace(rsForm.monPago,',',' -','all')>
		<cfif isdefined('Reimpresion')>
			<cfset etiqueta = "Num.Cheque<BR>a Anular">
			<cfset etiquetaDat = "VIEJO">
		<cfelse>
			<cfset etiqueta = " ">
			<cfset etiquetaDat = "Blanco">
		</cfif>
        <tr><td colspan="4">&nbsp;</td></tr>  
        <tr><td colspan="4" align="center" nowrap>
        	<table width="100%">
                <cfloop query="rsIC">
                	<tr>
                        <td class="tituloListas" align="center"><strong>Num. Cheque<BR>a Imprimir</strong></td>
                        <td class="tituloListas" align="center"><strong>#etiqueta#</strong></td>
                        <td class="tituloListas" align="center"><strong>Num.Orden</strong></td>
                        <td class="tituloListas" align="center"><strong>Fecha<br />Pago</strong></td>
                        <td class="tituloListas" align="center"><strong>Beneficiario</strong></td>
                        <td class="tituloListas" align="center"><strong>Monto<BR>#MontoMoneda#</strong></td>
                        <td class="tituloListas" align="center"><strong>Endoso</strong></td>
                        <td class="tituloListas" align="center"><strong>Entrega</strong></td>
                        <td class="tituloListas" align="center"><strong>Al Banco</strong></td>
                    </tr>
                	<tr class="<cfif rsIC.currentrow mod 2 eq 0>ListaNon<cfelse>ListaPar</cfif>">
                        <td align="center">#rsIC.Cheque#</td>
                        <td>#etiquetaDat#</td>
                        <td>#rsIC.TESOPnumero#</td>
                        <td align="right">#rsIC.TESOPfechaPago#</td>
                        <td align="right">#rsIC.TESOPbeneficiario#</td>
                        <td align="right">#NumberFormat(rsIC.TESOPtotalPago,",0.00")#</td>
                        <td align="right">#rsIC.Endoso#</td>
                        <td align="right">#rsIC.Entrega#</td>
                        <td align="right">#rsIC.AlBanco#</td>
                	</tr>
                    <tr><td>&nbsp;</td><td colspan="6"><cfset sbPoneDetalle(rsIC.TESOPid)></td></tr>
                </cfloop>
            </table>	
        </td></tr>
	</cfif>
</cffunction>

<cffunction name="fnVerificaFechas" output="false" returntype="struct">
	<cfif rsTESOP.cantidad EQ 0>
		<cfset LvarCantidades.OtrosMeses	= -1>
		<cfset LvarCantidades.OtrosDias		= -1>
	<cfelse>
		<!--- VERIFICA LA FECHA --->
		<cfquery name="rsParametros" datasource="#session.DSN#">
			select 	<cf_dbfunction name="to_number" args="p1.Pvalor"> as AuxPeriodo,
					<cf_dbfunction name="to_number" args="p2.Pvalor"> as AuxMes
			  from Parametros p1, Parametros p2, Empresas e
			 where p1.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and p1.Mcodigo = 'GN'
			   and p1.Pcodigo = 50		

			   and p2.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			   and p2.Mcodigo = 'GN'
			   and p2.Pcodigo = 60
		</cfquery>			

		<cfset LvarPrimerDiaAux		= createdate(rsParametros.AuxPeriodo,rsParametros.AuxMes,1)>
		<cfset LvarPrimerDiaSigAux	= dateadd("m",1 ,LvarPrimerDiaAux)>

		<cfquery datasource="#session.dsn#" name="rsSQL">
			select count(1) as cantidad
			  FROM TESordenPago op
			 where TESid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
			   and TESCFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
			   and <cf_dbfunction name="Date_Format" args="TESOPfechaPago,YYYYMM"> <> '#DateFormat(LvarPrimerDiaAux,"YYYYMM")#'
			   and <cf_dbfunction name="Date_Format" args="TESOPfechaPago,YYYYMM"> <> '#DateFormat(LvarPrimerDiaSigAux,"YYYYMM")#'
		</cfquery>
		<cfset LvarCantidades.OtrosMeses = rsSQL.cantidad>

		<cfquery datasource="#session.dsn#" name="rsSQL">
			select count(1) as cantidad
			  FROM TESordenPago op
			 where TESid	= <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Tesoreria.TESid#">	
			   and TESCFLid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.TESCFLid#">	
			   and <cf_dbfunction name="Date_Format" args="TESOPfechaPago,YYYYMMDD"> <> '#DateFormat(now(),"YYYYMMDD")#'
		</cfquery>
		<cfset LvarCantidades.OtrosDias = rsSQL.cantidad>
	</cfif>
	
	<cfreturn LvarCantidades>
</cffunction>

<cffunction name="sbPoneDetalle" output="true" returntype="void">
	<cfargument name="TESOPid" type="numeric" required="yes">
    
	<cfquery datasource="#session.dsn#" name="rsSolicitudes">
		select 
			sp.TESOPid,
			sp.TESSPid,
			dp.TESDPid,
			op.CBidPago,
			mp.Mnombre, mp.Miso4217 as Miso4217Pago, mep.Miso4217 as Miso4217EmpresaPago,
			sp.TESSPnumero,
			sp.TESSPfechaPagar,
			e.Edescripcion,
			dp.TESDPmoduloOri,
			dp.TESDPdocumentoOri, 
			dp.TESDPreferenciaOri,
			dp.Miso4217Ori,
			dp.TESDPmontoAprobadoOri,
			case when coalesce(op.TESOPtipoCambioPago, 0) 	= 0 then 1 else op.TESOPtipoCambioPago 		end as TESOPtipoCambioPago,
			case when coalesce(dp.TESDPtipoCambioOri, 0) 	= 0 then 1 else dp.TESDPtipoCambioOri 		end as TESDPtipoCambioOri,
			case when coalesce(dp.TESDPfactorConversion, 0) = 0	then 1 else dp.TESDPfactorConversion	end as TESDPfactorConversion,
			coalesce(dp.TESDPmontoPago, 0) as TESDPmontoPago,
			case sp.TESSPtipoDocumento
				when 0 		then 'Manual'
				when 5 		then 'ManualCF' 
				when 1 		then 'CxP' 
				when 2 		then 'Antic.CxP' 
				when 3 		then 'Antic.CxC' 
				when 4 		then 'Antic.POS' 
				when 6 		then 'Antic.GE' 
				when 7 		then 'Liqui.GE' 
				when 8		then 'Fondo.CCh' 
				when 9 		then 'Reint.CCh' 
				when 10		then 'TEF Bcos' 
				when 100 	then 'Interfaz' 
				else 'Otro'
			end as TIPO,
			dp.TESDPmontoPagoLocal,
			cpc.CPCid, cpc.TESDPmontoSolicitadoOri as CPCoriginal, cpc.CPClocal
		from TESordenPago op
			left join TESdetallePago dp
				inner join Empresas e
				  on e.Ecodigo = dp.EcodigoOri
				inner join Monedas me
					 on me.Miso4217	= dp.Miso4217Ori
					and me.Ecodigo	= dp.EcodigoOri
				inner join Monedas m
					 on m.Miso4217	= dp.Miso4217Ori
					and m.Ecodigo	= dp.EcodigoOri
				inner join TESsolicitudPago sp
				  on sp.TESid 	= dp.TESid
				 and sp.TESSPid = dp.TESSPid
				inner join CFinanciera cf
					 on cf.Ecodigo  = dp.EcodigoOri
					and cf.CFcuenta = dp.CFcuentaDB
			  on dp.TESid 	= op.TESid
			 and dp.TESOPid = op.TESOPid
			left join TESdetallePagoCPC cpc
				inner join CPCesion c on c.CPCid = cpc.CPCid
				inner join Monedas mc on mc.Mcodigo = c.Mcodigo
			   on TESDPidNew		= dp.TESDPid
			  and mc.Miso4217		<> dp.Miso4217Ori
			  and me.Miso4217		in (dp.Miso4217Ori,mc.Miso4217)
			  and op.Miso4217Pago	in (dp.Miso4217Ori,mc.Miso4217)
			left join Empresas ep
				inner join Monedas mep
				   on mep.Mcodigo = ep.Mcodigo
				  and mep.Ecodigo = ep.Ecodigo
			  on ep.Ecodigo = op.EcodigoPago
			left join Monedas mp
			  on mp.Miso4217	= op.Miso4217Pago
			 and mp.Ecodigo		= op.EcodigoPago
		where op.TESid = #session.tesoreria.TESid#
		  and op.TESOPid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.TESOPid#">
		  and op.TESOPestado in (10,11)
	</cfquery>	
    <cfif rsSolicitudes..recordcount EQ 0>
    	<cfreturn>
    </cfif>
	<table align="center" border="0" cellspacing="0" cellpadding="0" width="100%">
		<tr>
			<td class="tituloListas" align="left"><strong>Num.<BR>Solicitud</strong></td>
			<td class="tituloListas" align="left"><strong>Origen</strong></td>
			<td class="tituloListas" align="left"><strong>Documento</strong></td>
			<td class="tituloListas" align="right"><strong>Monto<BR>Documento</strong></td>
			<td class="tituloListas" align="center"><strong>Tipo&nbsp;Cambio<BR>Documento</strong></td>
			<td class="tituloListas" align="center"><strong>Factor<BR>Conversion</strong></td>
			<td class="tituloListas" align="right"><strong>Monto Pago<cfif rsSolicitudes.CBidPago NEQ ""><BR><cfoutput>#rsSolicitudes.Mnombre#<BR>(#rsSolicitudes.Miso4217Pago#)</cfoutput></cfif></strong></td>
		</tr>
		<cfset LvarTotalSP = 0>
		<cfset LvarLista = "ListaPar">
		<cfset LvarSolicitud = "">
		<cfloop query="rsSolicitudes">
			<cfset LvarTotalSP = LvarTotalSP + TESDPmontoPago>
			<cfif LvarLista NEQ "ListaPar">
				<cfset LvarLista = "ListaPar">
			<cfelse>
				<cfset LvarLista = "ListaNon">
			</cfif>
			<cfif LvarSolicitud NEQ rsSolicitudes.TESSPid>
				<cfset LvarSolicitud = rsSolicitudes.TESSPid>
				<tr class="#LvarLista#">
					<td align="left" nowrap>
						#TESSPnumero#
					</td>
					<td align="center" nowrap>
						#TIPO#
					</td>
                    <td align="center" nowrap colspan="5"></td>
					<cfif LvarLista NEQ "ListaPar">
						<cfset LvarLista = "ListaPar">
					<cfelse>
						<cfset LvarLista = "ListaNon">
					</cfif>
				</tr>
			</cfif>
			<tr class="#LvarLista#">
				<td>&nbsp;</td>
				<td align="center" nowrap>
					#TESDPmoduloOri#
				</td>
				<td align="left" nowrap>
					#TESDPdocumentoOri#
				</td>
                <td align="right" nowrap>
					<input name="TESDPmontoAprobadoOri_#TESDPid#" id="TESDPmontoAprobadoOri_#TESDPid#"
						value="#NumberFormat(TESDPmontoAprobadoOri,",0.00")#"
						class="#LvarLista#"
						style="text-align:right; border:none; padding-left:0px;"
						readonly="yes"
						tabindex="-1"
					> #Miso4217Ori#
				</td>
				<td align="right" nowrap>
					<cfif CBidPago EQ "">
                        <cfset LvarTC = 0>
                        <cfset LvarFC = 0>
                        <cfset LvarMP = 0>
                    <cfelseif CPCid NEQ "">
                        <cfset LvarTC = TESDPtipoCambioOri>
                        <cfset LvarFC = TESDPfactorConversion>
                        <cfset LvarMP = TESDPmontoAprobadoOri>
                    <cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
                        <cfset LvarTC = 1>
                        <cfset LvarFC = 1/TESOPtipoCambioPago>
                        <cfset LvarMP = TESDPmontoAprobadoOri/TESOPtipoCambioPago>
                    <cfelseif Miso4217Ori EQ Miso4217Pago>
                        <cfset LvarTC = TESOPtipoCambioPago>
                        <cfset LvarFC = 1>
                        <cfset LvarMP = TESDPmontoAprobadoOri>
                    <cfelseif Miso4217Pago EQ Miso4217EmpresaPago>
                        <cfset LvarTC = TESOPtipoCambioPago>
                        <cfset LvarFC = TESDPfactorConversion>
                        <cfset LvarMP = TESDPmontoPago>
                    <cfelse>
                        <cfset LvarTC = TESOPtipoCambioPago>
                        <cfset LvarFC = TESDPfactorConversion>
                        <cfset LvarMP = TESDPmontoPago>
                    </cfif>
                    <cfif CBidPago EQ "">
                            <input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
                                value="0"
                                size="8"
                                class="#LvarLista#"
                                style="text-align:right; display:none; padding-left:0px;"
                                readonly="yes"
                                tabindex="-1"
                            > 
                    <cfelseif CPCid NEQ "">
                            <input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
                                value="#NumberFormat(TESDPtipoCambioOri,",0.0000")#"
                                size="8"
                                class="#LvarLista#"
                                style="text-align:right; border:none; padding-left:0px;"
                                readonly="yes"
                                tabindex="-1"
                            > #Miso4217EmpresaPago#s/#Miso4217Ori#
                    <cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
                            <input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
                                value="1.0000"
                                size="8"
                                class="#LvarLista#"
                                style="text-align:right; display:none; padding-left:0px;"
                                readonly="yes"
                                tabindex="-1"
                            > n/a
                    <cfelseif Miso4217Ori EQ Miso4217Pago>
                            <input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
                                value="#NumberFormat(TESOPtipoCambioPago,",0.0000")#"
                                size="8"
                                class="#LvarLista#"
                                style="text-align:right; border:none; padding-left:0px;"
                                readonly="yes"
                                tabindex="-1"
                            > #Miso4217EmpresaPago#s/#Miso4217Ori#
                    <cfelse>
                            <input name="TESDPtipoCambioOri_#TESDPid#" id="TESDPtipoCambioOri_#TESDPid#"
                                value="#NumberFormat(TESDPtipoCambioOri,",0.0000")#"
                                size="8"
                                style="text-align:right;"
                                onFocus="this.value=qf(this); this.select(); LvarValueOri = this.value;" 
                                onBlur="if (LvarValueOri != this.value) {sbCambioTC(this); GvarCambiado = true;} fm(this,4);" 
                                onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                            > #Miso4217EmpresaPago#s/#Miso4217Ori#
                    </cfif>
				</td>
				<td align="right" nowrap>
					<cfif CBidPago EQ "">
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
                            size="8"
                            class="#LvarLista#"
                            style="text-align:right; display:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        >
                    <cfelseif CPCid NEQ "">
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
                            size="8"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        > #Miso4217Pago#s/#Miso4217Ori#
                    <cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#NumberFormat(1/TESOPtipoCambioPago,",0.0000")#"
                            size="8"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        > #Miso4217Pago#s/#Miso4217Ori#
                    <cfelseif Miso4217Ori EQ Miso4217Pago>
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#1.0000#"
                            size="8"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px; display:none;"
                            readonly="yes"
                            tabindex="-1"
                        > n/a
                    <cfelseif Miso4217Pago EQ Miso4217EmpresaPago>
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
                            size="8"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        > #Miso4217Pago#s/#Miso4217Ori#
                    <cfelse>
                        <input name="TESDPfactorConversion_#TESDPid#" id="TESDPfactorConversion_#TESDPid#"
                            value="#NumberFormat(TESDPfactorConversion,",0.0000")#"
                            size="8"
                            style="text-align:right;"
                            onFocus="this.value=qf(this); this.select();" 
                            onChange="javascript: sbCambioFC(this); fm(this,4); GvarCambiado = true;" 
                            onKeyUp="if(snumber(this,event,4)){ if(Key(event)=='13') {this.blur();}}"
                        > #Miso4217Pago#s/#Miso4217Ori#
                    </cfif>
             	</td>
				<cfif CBidPago EQ "">
                    <td align="right" nowrap>
                        <input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
                            value="0.00"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        >
                        #Miso4217Pago#
                    </td>
                <cfelseif CPCid NEQ "">
                    <td align="right" nowrap>
                        <input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
                            value="#NumberFormat(TESDPmontoAprobadoOri,",0.00")#"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        >
                        #Miso4217Pago#
                    </td>
                <cfelseif Miso4217Ori EQ Miso4217EmpresaPago>
                    <td align="right" nowrap>
                        <input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
                            value="#NumberFormat(TESDPmontoAprobadoOri/TESOPtipoCambioPago,",0.00")#"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        >
                        #Miso4217Pago#
                    </td>
                <cfelseif Miso4217Ori EQ Miso4217Pago>
                    <td align="right" nowrap>
                        <input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
                            value="#NumberFormat(TESDPmontoAprobadoOri,",0.00")#"
                            class="#LvarLista#"
                            style="text-align:right; border:none; padding-left:0px;"
                            readonly="yes"
                            tabindex="-1"
                        >
                        #Miso4217Pago#
                    </td>
                <cfelse>
                    <td align="right" nowrap>
                        <input name="TESDPmontoPago_#TESDPid#" id="TESDPmontoPago_#TESDPid#"
                            value="#NumberFormat(TESDPmontoPago,",0.00")#"
                            size="17"
                            style="text-align:right;"
                            onFocus="this.value=qf(this); this.select();" 
                            onBlur="javascript: sbCambioMonto(this); fm(this,2);" 
                            onKeyUp="if(snumber(this,event,2)){ if(Key(event)=='13') {this.blur();}}"
                            onChange="GvarCambiado = true;"
                        >
                        #Miso4217Pago#
                    </td>
                </cfif>
			</tr>
		</cfloop>
	</table>
</cffunction>