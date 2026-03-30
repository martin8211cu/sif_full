<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>
<cfif not isdefined("rsEPD")>
	<cfinclude template="polizaDesalmacenaje-config.cfm">
	<cfinclude template="polizaDesalmacenaje-dbcommon.cfm">
</cfif>
<cfoutput>
<cf_sifHTML2Word>
<style type="text/css">
	.topline {
		border-top-width: 1px;
		border-top-style: solid;
		
		border-right-style: none;
		
		border-bottom-style: none;
		
		border-left-style: none;
		
		border-top-color: ##CCCCCC;
		
		font-size:10px;
	}
	.letra {
		font-size:11px;
	}
	td { font-size:9px;	}
</style>
<table width="100%" border="0" cellspacing="0" cellpadding="1" style="padding-left: 5px; padding-right: 10px" align="center">
	<tr> 
	<td colspan="16" align="center"><strong style="font-family:'Times New Roman', Times, serif; font-size:15pt; font-variant:small-caps; font-weight:bolder; padding-left:20px">#session.Enombre#</strong></td>
	</tr>
	<tr> 
	<td colspan="16" class="letra" align="center"><b><font size="2">C&aacute;lculo de Importaci&oacute;n</font></b></td>
	</tr>
	<tr>
	<td colspan="16" align="center" class="letra"><b>Fecha de la Consulta:</b> #LSDateFormat(Now(), 'dd/mm/yyyy')# &nbsp; <b>Hora:&nbsp;</b>#TimeFormat(Now(),'medium')#</td>
	</tr>
</table>

<br>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="16" class="SubTitulo" align="center" style="text-transform:uppercase ">P&oacute;liza de Desalmacenaje</td>
	</tr>
</table>

<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<!--- Orden de Compra de la póliza --->
		<td width="1%" nowrap><strong>Orden de Compra &nbsp;:&nbsp;</strong></td>
		<!--- Descripción de la póliza --->
		<td colspan="3"><table border="0" cellspacing="0" cellpadding="0"><tr><td>#HTMLEditFormat(rsEPD.EPDdescripcion)#</td></tr></table></td>
		<!--- Número de la póliza --->
		<td width="1%" nowrap><strong>N&uacute;mero Desalmacenaje&nbsp;:&nbsp;</strong></td>
		<td>#HTMLEditFormat(rsEPD.EPDnumero)#</td>
	</tr>
	<tr>
		<!--- Observaciones --->
		<td width="1%" nowrap><strong>Observaciones &nbsp;:&nbsp;</strong></td>
		<td colspan="3"><table border="0" cellspacing="0" cellpadding="0"><tr><td>#HTMLEditFormat(rsEPD.EPDobservaciones)#</td></tr></table></td>
		<!--- Tracking de embarque de la póliza --->
		<td width="1%" nowrap><strong>N&uacute;mero Embarque&nbsp;:&nbsp;</strong></td>
		<td>#HTMLEditFormat(rsEPD.EPembarque)#</td>
	</tr>
	
	<!---Validacion de Campos Obligatorios, para el seguimiento de tracking seleccionado
                     en caso de que no se suministren no se permite cerrar la poliza--->
		<cfquery name="rsValidarSeguimiento" datasource="#session.DSN#">
		  Select Coalesce(Pvalor,'N') as Pvalor
			from Parametros 
		   where Pcodigo = 15652
			 and Mcodigo = 'CM'
			 and Ecodigo = #session.Ecodigo# 
		</cfquery> 		
	<cfif rsValidarSeguimiento.Pvalor eq 'S'>
	<!---Campos requeridos segun catalogo de actividad de Tracking--->
			<cfquery name="rsCamposAvalidar" datasource="sifpublica">
				select 	(select count(1) from CMActividadTracking where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and ETA_R = 1) as ETA_R,
							(select count(1) from CMActividadTracking where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and ETA_A = 1) as ETA_A,
							(select count(1) from CMActividadTracking where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and ETS = 1) as ETS,
							(select count(1) from CMActividadTracking where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#"> and CMATFDO = 1) as CMATFDO
			</cfquery>
			<cfset varETA_R = 0><cfset varETA_A 	= 0>
			<cfset varETS  	 =	0><cfset varCMATFDO  	=	0>
			<!---Asignacion de Campos obligatorios--->
			<cfloop query="rsCamposAvalidar">
				<cfif rsCamposAvalidar.ETA_R gt 0><cfset varETA_R	= 1></cfif>
				<cfif rsCamposAvalidar.ETA_A gt 0><cfset varETA_A = 1></cfif>
				<cfif rsCamposAvalidar.ETS gt 0><cfset varETS =	1></cfif>
				<cfif rsCamposAvalidar.CMATFDO gt 0><cfset varCMATFDO =	1></cfif>
			</cfloop>
			
			<cf_dbdatabase name ="database" table="DTracking" datasource="sifpublica" returnvariable="DtrackingTable">
			<cf_dbdatabase name ="database" table="CMActividadTracking" datasource="sifpublica" returnvariable="ActividadTrackingTable">
			<cfquery name="rsValidaSeguimiento" datasource="#session.dsn#">
				select  	atk.ETA_R,
								atk.ETA_A,
								atk.CMATFDO,
								atk.ETS
				from #DtrackingTable# a
					inner join ETracking et
						on et.ETidtracking = a.ETidtracking
					left join #ActividadTrackingTable# atk
						on atk.CMATid      	= a.CMATid
						and atk.Ecodigo  	= a.Ecodigo
				where a.ETidtracking = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsEPD.idTracking#">
			</cfquery>

			<cfset act1 = 0><!---ETA_R--->
			<cfset act2 = 0><!---ETA_A--->
			<cfset act3 = 0><!---ETS--->
			<cfset act4 = 0><!---CMATFDO--->
			<cfloop query="rsValidaSeguimiento">
				<cfif varETA_R eq 1 and rsValidaSeguimiento.ETA_R gt 0><cfset act1 = act1+1></cfif>
				<cfif varETA_A eq 1 and rsValidaSeguimiento.ETA_A gt 0><cfset act2 = act2+1></cfif>
				<cfif varETS eq 1 and rsValidaSeguimiento.ETS gt 0><cfset act3 = act3+1></cfif>
				<cfif varCMATFDO eq 1 and rsValidaSeguimiento.CMATFDO gt 0><cfset act4= act4+1></cfif>
			</cfloop>
			<!---Campos necesarios a mostrar--->
			<cfset CamposRequeridos = "">
			<cfif varETA_R eq 1 and act1 lt 1>
					<cfif CamposRequeridos eq ""><cfset CamposRequeridos = CamposRequeridos &"ETA Real"><cfelse><cfset CamposRequeridos = CamposRequeridos &", ETA Real"></cfif>
				</cfif>
				<cfif varETA_A eq 1 and act2 lt 1>
					<cfif CamposRequeridos eq ""><cfset CamposRequeridos = CamposRequeridos& "ETA Actualizado"><cfelse><cfset CamposRequeridos = CamposRequeridos &", ETA Actualizado"></cfif>
				</cfif>
				<cfif varETS eq 1 and act3 lt 1>
					<cfif CamposRequeridos eq ""><cfset CamposRequeridos = CamposRequeridos& "Salida del puerto Origen"><cfelse><cfset CamposRequeridos = CamposRequeridos &", Salida del puerto origen"></cfif>
				</cfif>
				<cfif varCMATFDO eq 1 and act4 lt 1>
					<cfif CamposRequeridos eq ""><cfset CamposRequeridos = CamposRequeridos& "Envío de los Documentos a la aduana"><cfelse><cfset CamposRequeridos = CamposRequeridos &", Envío de los documentos a la aduana"></cfif>
				</cfif>
			<!---Mensaje para el usuario sobre los campos requeridos--->
			<tr style="display:<cfif CamposRequeridos neq "">line<cfelse>none</cfif>;">
				<td colspan="4" align="right">&nbsp;</td>
				<td colspan="2" align="left">
						El tracking de la p&oacute;liza, no tiene la(s)  siguiente(s) actividad(es) de seguimiento requerida(s):<br>
					<i style="font-size:9px; color:red;">#CamposRequeridos#</i>
				</td>
			</tr>
		</cfif>
		<tr>
		<!--- Agencia aduanal --->
		<td width="1%" nowrap><strong>Agencia Aduanal&nbsp;:&nbsp;</strong></td>
		<td>#HTMLEditFormat(rsEPD.CMAAdescripcion)#</td>
		<!--- Aduana --->
		<td width="1%" nowrap><strong>Aduana&nbsp;:&nbsp;</strong></td>
		<td>#HTMLEditFormat(rsEPD.CMAdescripcion)#</td>
		<!--- Exportador (Socio de negocios) --->
		<td width="1%" nowrap><strong>Exportador&nbsp;:&nbsp;</strong></td>
		<td>#rsEPD.SNnumero# - #rsEPD.SNnombre#</td>
	</tr>
	<tr>
		<!--- Fecha de la póliza --->
		<td width="1%" nowrap><strong>Fecha&nbsp;:&nbsp;</strong></td>
		<td>#LSDateFormat(rsEPD.EPDfecha,'dd/mm/yyyy')#</td>
		<!--- País de origen --->
		<td width="1%" nowrap><strong>Pa&iacute;s de Origen&nbsp;:&nbsp;</strong></td>
		<td>#HTMLEditFormat(rsEPD.paisori)#</td>
		<!--- País de procedencia --->
		<td width="1%" nowrap><strong>Pa&iacute;s de Procedencia&nbsp;:&nbsp;</strong></td>
		<td>#HTMLEditFormat(rsEPD.paisproc)#</td>
	</tr>
	<tr>
		<!--- Cantidad de bultos --->
		<td width="1%" nowrap><strong>Cantidad de Bultos&nbsp;:&nbsp;</strong></td>
		<td>#rsEPD.EPDtotbultos#</td>
		<!--- Peso bruto --->
		<td width="1%" nowrap><strong>Peso Bruto (kg)&nbsp;:&nbsp;</strong></td>
		<td>#LSCurrencyFormat(rsEPD.EPDpesobruto,'none')#</td>
		<!--- Peso neto --->
		<td width="1%" nowrap><strong>Peso Neto (kg)&nbsp;:&nbsp;</strong></td>
		<td>#LSCurrencyFormat(rsEPD.EPDpesoneto,'none')#</td>
	</tr>
	<tr>
	<td><strong>Moneda:</strong></td>
	<cfquery name="rsMonedas" datasource="#session.DSN#">
		select b.Mnombre
		from Empresas a 
			inner join Monedas b
				on a.Mcodigo = b.Mcodigo
				and a.Ecodigo = b.Ecodigo
		where a.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">					
	</cfquery>
	<td>#rsMonedas.Mnombre#</td>
	<td><strong>Tipo de Cambio Póliza:</strong></td>
	<td>#LSCurrencyFormat(rsEPD.EPDtcref,'none')#</td>
	</tr>
</table>
<!---     L  I  S  T  A     D  E     D  E  T  A  L  L  E  S     D  E     L  A     P  O  L  I  Z  A     --->
<br><table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr><td colspan="16" class="SubTitulo" align="center" style="text-transform:uppercase ">Lista de detalles de la P&oacute;liza</td></tr>
</table>
<table width="100%" cellpadding="1" cellspacing="0">
	<tr>
		<td class="tituloListas" align="left"><strong>C&oacute;digo</strong></td>
		<td class="tituloListas" align="left"><strong>No Orden</strong></td>
		<td class="tituloListas" align="right"><strong>Cantidad</strong></td>
		<td class="tituloListas" align="right"><strong>Unidad</strong></td>
		<td class="tituloListas" align="right"><strong>FOB</strong></td>
		<td class="tituloListas" align="right"><strong>Fletes <br> Exterior</strong></td>
		<td class="tituloListas" align="right"><strong>Seguros <br> Exterior</strong></td>
		<td class="tituloListas" align="right"><strong>Seguro propio</strong></td>
		<td class="tituloListas" align="right"><strong>CIF</strong></td>
		<td class="tituloListas" align="right"><strong>Fletes <br> Internos</strong></td>
		<td class="tituloListas" align="right"><strong>Seguros <br> Internos</strong></td>
		<td class="tituloListas" align="right"><strong>Gastos</strong></td>
		<td class="tituloListas" align="right"><strong>Total <br> Impuestos</strong></td>
		<td class="tituloListas" align="right"><strong>Impuesto <br> Recuperable</strong></td>
		<td class="tituloListas" align="right"><strong>Costo Total</strong></td>
		<td class="tituloListas" align="right"><strong>Costo Unitario</strong></td>
	</tr>
	
	<cfset FOB_total = 0>
	<cfset fletesExterior = 0>
	<cfset segurosExterior = 0>
	<cfset seguroPropio = 0>
	<cfset CIF_total = 0>
	<cfset fletesInternos = 0>
	<cfset segurosInternos = 0>
	<cfset aduanas_total = 0>	
	<cfset impuestos_total = 0>
	<cfset impuesto_recuperable = 0>
	<cfset costo_total = 0>
	<cfloop query="rsLDPD">
		<tr>
			<td colspan="14">
				<table width="100%" cellpadding="0" cellspacing="2%"><tr>
					<td width="2%"><strong>Item:</strong></td>
					<td width="98%" colspan="13">#rsLDPD.DPDdescripcion#</td>
				</tr></table>
			</td>	
		</tr>
		<tr class="<cfif rsLDPD.CurrentRow mod 2>listaPar<cfelse>listaNon</cfif>" >
			<!--- Código del artículo o del concepto --->
			<td align="left">#rsLDPD.codigo#</td>
			<!--- Orden de Compra --->
			<td align="left" >#rsLDPD.EOnumero#</td>
			<!--- Cantidad desalmacenada --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.DPDcantidad,'none')#</td>
			<!--- Unidad --->
			<td  align="right">#rsLDPD.Udescripcion#</td>
			<!--- Monto fob --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.DPDmontofobreal,'none')#</td>
			<!--- Fletes en el exterior --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.DPDfletesprorrat,'none')#</td>
			<!--- Seguros en el exterior --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.DPDsegurosprorrat,'none')#</td>
			<!--- Seguro propio --->
			<td align="right">#LSCurrencyFormat(rsLDPD.DPseguropropio,'none')#</td>
			<!--- Cif --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.DPDmontocifreal,'none')#</td>
			<!--- Fletes internos --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.DPDfletesreal,'none')#</td>
			<!--- Seguros internos --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.DPDsegurosreal,'none')#</td>
			<!--- Aduanales (Gastos) --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.DPDaduanalesreal,'none')#</td>
			<!--- Impuestos --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.DPDimpuestosreal + rsLDPD.DPDimpuestosrecup,'none')#</td>
			<!--- Impuesto recuperable --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.DPDimpuestosrecup,'none')#</td>
			<!--- Monto total --->
			<td  align="right">#LSCurrencyFormat(rsLDPD.montoreal,'none')#</td>
			<!--- Costo unitario --->
			<td  align="right">#LvarOBJ_PrecioU.enCF_RPT(rsLDPD.costounitario)#</td>
		</tr>
		<cfset FOB_total = FOB_total + rsLDPD.DPDmontofobreal>
		<cfset fletesExterior = fletesExterior + rsLDPD.DPDfletesprorrat>
		<cfset segurosExterior = segurosExterior + rsLDPD.DPDsegurosprorrat>
		<cfset seguroPropio = seguroPropio + rsLDPD.DPseguropropio>
		<cfset CIF_total = CIF_total + rsLDPD.DPDmontocifreal>	
		<cfset fletesInternos = fletesInternos + rsLDPD.DPDfletesreal>
		<cfset segurosInternos = segurosInternos + rsLDPD.DPDsegurosreal>
		<cfset aduanas_total = aduanas_total + rsLDPD.DPDaduanalesreal>	
		<cfset impuestos_total = impuestos_total + rsLDPD.DPDimpuestosreal + rsLDPD.DPDimpuestosrecup>
		<cfset impuesto_recuperable = impuesto_recuperable + rsLDPD.DPDimpuestosrecup>
		<cfset costo_total = costo_total + rsLDPD.montoreal>
	</cfloop>
	<!--- Totales de los ítems desalmacenados --->
	<tr style="background-color:##CCCCCC;" height="20">
		<td class="topline" colspan="4"><strong>Total</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(FOB_total,'none')#</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(fletesExterior,'none')#</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(segurosExterior,'none')#</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(seguroPropio,'none')#</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(CIF_total,'none')#</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(fletesInternos,'none')#</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(segurosInternos,'none')#</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(aduanas_total,'none')#</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(impuestos_total,'none')#</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(impuesto_recuperable,'none')#</strong></td>
		<td class="topline" align="right"><strong>#LSCurrencyFormat(costo_total,'none')#</strong></td>
		<td class="topline" align="right">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="16">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="16" class="SubTitulo" align="center" style="text-transform:uppercase ">Lista de facturas de la P&oacute;liza</td>
	</tr>
	<!--- Facturas de la póliza --->
	<tr>
		<td align="left" width="10" class="TituloListas"><strong>Factura</strong></td>
		<td align="left" width="10" class="TituloListas"><strong>L.</strong></td>
		<td align="left" width="10" class="TituloListas"><strong>C&oacute;digo</strong></td>
		<td align="left" width="10" class="TituloListas"><strong>&nbsp;</strong></td>
		<td colspan="11" align="left" class="TituloListas"><strong>Descripci&oacute;n</strong></td>
		<td align="right" class="TituloListas"><strong>Monto</strong></td>
	</tr>
	<cfset MontoTotal = 0.00>
	<cfloop query="rsFacturas">
	<tr>
		<!--- Número de documento --->
		<td align="left">#Ddocumento#</td>
		<!--- Consecutivo de la línea --->
		<td align="left">#DDIconsecutivo#</td>
		<!--- Código del concepto --->
		<td align="left">#Ccodigo#</td>
		<td align="left">&nbsp;</td>
		<!--- Concepto --->
		<td colspan="11" align="left">#Concepto#</td>
		<!--- Monto --->
		<td align="right">#LSCurrencyFormat(Monto,'none')#</td>
		<cfset MontoTotal = MontoTotal + Monto>
	</tr>
	</cfloop>
	<!--- Total de las facturas de la póliza --->
	<tr style="background-color:##CCCCCC;" height="20">
		<td align="left" colspan="15"><strong>Total</strong></td>
		<td align="right"><strong>#LSCurrencyFormat(MontoTotal,'none')#</strong></td>
	</tr>
	<tr>
		<td colspan="16">&nbsp;</td>
	</tr>
	
	<!--- Impuestos de la póliza --->
	<tr>
		<td colspan="16" class="SubTitulo" align="center" style="text-transform:uppercase ">Lista de impuestos de la P&oacute;liza</td>
	</tr>
	<tr>
 		<td align="left" width="10" class="TituloListas"><strong>Factura</strong></td>
		<td align="left" width="10" class="TituloListas"><strong>L.</strong></td>
		<td align="left" width="10" class="TituloListas"><strong>C&oacute;digo</strong></td>
		<td align="left" width="10" class="TituloListas"><strong>&nbsp;</strong></td>
		<td colspan="11" align="left" class="TituloListas"><strong>Descripci&oacute;n</strong></td>
		<td align="right" class="TituloListas"><strong>Monto</strong></td>
	</tr>
	<cfset MontoTotal = 0.00>
	<cfloop query="rsImpuestos">
	<tr>
		<!--- Número de documento --->
		<td align="left">#Ddocumento#</td>
		<!--- Consecutivo de la línea --->
		<td align="left">#DDIconsecutivo#</td>
		<!--- Código del impuesto --->
		<td align="left">#Icodigo#</td>
		<td align="left">&nbsp;</td>
		<!--- Descripción del impuesto --->
		<td colspan="11" align="left">#Idescripcion#</td>
		<!--- Monto --->
		<td align="right">#LSCurrencyFormat(CMIPmonto,'none')#</td>
		<cfset MontoTotal = MontoTotal + CMIPmonto>
	</tr>
	</cfloop>
	<!--- Total de los impuestos --->
	<tr style="background-color:##CCCCCC;" height="20">
		<td align="left" colspan="15"><strong>Total</strong></td>
		<td align="right"><strong>#LSCurrencyFormat(MontoTotal,'none')#</strong></td>
	</tr>
</table>
<br>
<table width="100%"  border="0" cellspacing="0" cellpadding="0">
	<tr>
		<td colspan="16" class="SubTitulo" align="center" style="text-transform:uppercase; border-bottom:0">--- <cfif not isdefined("url.imprime")>Fin de la Consulta<cfelse>Fin del Reporte</cfif> ---</td>
	</tr>
</table>
</cf_sifHTML2Word>
<cfparam name="PermiteCierrePoliza" default="false">
<cfif PermiteCierrePoliza>
	<cfset LvarLeyenda = 'Información del Cierre de la Póliza'>
    <cfif rsEPD.PermiteDesParcial eq 1>
        <cfset LvarLeyenda = 'Creación póliza desalmacenaje parcial'>
    </cfif>
        <br><form action="../operacion/polizaDesalmacenaje-sql.cfm" method="post" name="form1" onsubmit="return funcValidaCantidades();">
        <input type="hidden" name="EPDid" value="#rsEPD.EPDid#">
        <input type="hidden" name="ETidtracking" value="#trim(rsEPD.EPembarque)#">
        <fieldset><legend><cfoutput>#LvarLeyenda#</cfoutput></legend>
        <table width="100%"  border="0" cellspacing="0" cellpadding="0">
        <cfif not isdefined("url.imprime") and rsEPD.EPDestado eq 0 and rsEPD.PermiteDesParcial eq 0>
          <tr>
                <td width="14%" align="right" nowrap><strong>C. Funcional:</strong>&nbsp;</td>
                <td width="8%">
                    <cf_rhcfuncional>
                </td>
        
                <td width="14%" align="right"><strong>Almac&eacute;n:</strong>&nbsp;</td>
                <td width="19%">
                    <select name="Aid" onChange="cambiaAlmacen();" tabindex="1">
                        <option value=""></option>
                        <cfloop query="rsAlmacen">
                            <option value="#rsAlmacen.Aid#">#rsAlmacen.Bdescripcion#</option>
                        </cfloop>
                    </select>
                </td>
                <td width="16%" align="right"><strong>Usuario:&nbsp;</strong></td>
                <td width="29%">
                    <cf_sifusuarioE size="40">
                </td>
          </tr>
        <cfelse>
            <cfinclude template="polizaDesalmacenaje_Parcial.cfm">
        </cfif>
          <tr>
            <td colspan="16">&nbsp;</td>
          </tr>
          <tr>
            <td align="center" colspan="16">
			<cfset accion = 0>
            <cfif not isdefined("url.imprime") and rsEPD.EPDestado eq 0 and rsEPD.PermiteDesParcial eq 1>
                <input type="hidden" name="DesalmacenajeParcial" value="1" />
                <input type="submit" name="CierrePoliza" value="Relacionar con Pólizas nuevas" onClick="javascript:return funcAplicar();" alt="Le permite crear pólizas identicas a la original con el mismo número de trackin y la posibilidad de cambiar las cantidades de las líneas">
				<cfset accion = 0>
             <cfelse>
                <input type="submit" name="CierrePoliza" value="Cerrar Póliza" onClick="javascript:return funcAplicar();">
				<cfset accion = 1>
            </cfif>
                <input type="submit" name="Regresar" value="Regresar" onClick="javascript:return funcRegresar();">
            </td>
          </tr>
        </table>
        <br>
        <cfif not isdefined("url.imprime") and rsEPD.EPDestado eq 0 and rsEPD.PermiteDesParcial eq 1>
             <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
              <tr>
                <td colspan="">* Esta P&oacute;liza <strong>generar&aacute;</strong> autom&aacute;ticamente una póliza de desalmacenaje parcial (hija) a la cual se le podrá cambiar las cantidades y se recalcularán los respectivos montos.</td>
              </tr>
            </table>
        <cfelse>
            <table width="100%"  border="0" cellspacing="0" cellpadding="0" class="Ayuda">
              <tr>
                <td colspan="">* Esta P&oacute;liza <strong>generar&aacute;</strong> autom&aacute;ticamente el documento de <strong>recepci&oacute;n</strong> correspondiente, listo para su respectiva revisi&oacute;n.</td>
              </tr>
            </table>
        </cfif>
        </fieldset>
        </form>
		<script language="javascript" type="text/javascript">
			/*Función del botón Facturas para ir al mantenimiento de Facturas*/
			function funcAplicar(){
				<cfif rsValidarSeguimiento.Pvalor eq 'S'>
					<cfoutput>var #ToScript(CamposRequeridos ,"camposR")#;</cfoutput>
					if(camposR != "" ){
						<cfif accion eq 0><cfset descripcionAccion = "relacionar con pólizas nuevas">
						<cfelse><cfset descripcionAccion = "cerrar la póliza"></cfif>
						<cfoutput>var #ToScript(descripcionAccion,"descripcion")#</cfoutput>
						alert("No se puede "+descripcion+", debido a que el tracking relacionado,\nno tiene la(s) siguiente(s)  actividad(es) de seguimiento requerida(s):\n"+camposR);
						return false;
					}
				</cfif>
			  <cfif not isdefined("url.imprime") and rsEPD.EPDestado eq 0 and rsEPD.PermiteDesParcial eq 0>
				if (document.form1.CFid.value==''&&document.form1.Aid.value==''){
					alert("Debe seleccionar el centro funcional o el almacén de recepción.");
					return false;
				}
				if (document.form1.Usucodigo.value==''){
					alert("Debe seleccionar el usuario");
					return false;
				}
			  </cfif>
				return confirm("#JSStringFormat('¿Está seguro de que desea Aplicar esta Póliza de Desalmacenaje, y Generar el Cálculo de la Importación Respectivo?')#");
			}
			function funcValidaCantidades(){
				<cfloop query="rsLDPD">
					if (document.form1.DPDcantidad_#DOlinea#.value<0||document.form1.DPDcantidad_#DOlinea#.value>#rsLDPD.DPDcantidad#){
						alert("Para la DOlinea #DOlinea# se permite desalmacenar desde 0 hasta #rsLDPD.DPDcantidad#, por favor ingrese un valor dentro de ese rango e intente de nuevo.");	
						return false;
					}
				</cfloop>
				return true;
			}
			<cfif not isdefined("url.imprime") and rsEPD.EPDestado eq 0 and rsEPD.PermiteDesParcial eq 0>
				function cambiaAlmacen(){
					document.form1.CFid.value = '';
					document.form1.CFcodigo.value = '';
					document.form1.CFdescripcion.value = '';
				}
			
				function funcCFcodigo(){
					document.form1.Aid.value = '';
				}
			</cfif>
			/*Función del botón Regresar para ir al mantenimiento de Facturas*/
			function funcRegresar(){
				document.form1.action = "../operacion/polizaDesalmacenaje.cfm";
				return true;
			}
			function funcNuevaPoliza(){
				document.form1.action = "../operacion/polizaDesalmacenaje.cfm";
				return true;
			}
		</script>
	</cfif>
</cfoutput>