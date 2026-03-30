<cfset LvarOBJ_PrecioU = createObject("Component","sif.Componentes.CM_PrecioU").init()>

<cfif isdefined("Form.EDIid")>
	<cfset EDIid = Form.EDIid>
</cfif>
<cfif isdefined("url.EDIid")>
	<cfset EDIid = url.EDIid>
</cfif>
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsEncabezado" datasource="#session.DSN#">
	select Ddocumento,SNnombre,SNnumero,EDIfecha,Mnombre ,EDItc,
	case when A.EDIestado = 60 then 'Anulada' when A.EDIestado = 0 then 'Pendiente' when A.EDIestado = 10 then 'Aplicada' end as Estado,EDIestado,
    case when A.EDItipo = 'N' then 'Nota de Crédito' when A.EDItipo = 'F' then 'Factura' when A.EDItipo = 'D' then 'Nota de Débito' end as tipo,
	DPD.Pnombre #_Cat# ' ' #_Cat# DPD.Papellido1 #_Cat# ' ' #_Cat# DPD.Papellido2 as Digitador,
	DPA.Pnombre #_Cat# ' ' #_Cat# DPA.Papellido1 #_Cat# ' ' #_Cat# DPA.Papellido2 as Anulador,
	EDobservaciones,EDmotivoanul
	from EDocumentosI A
	inner join Monedas C 			
			on C.Ecodigo = A.Ecodigo 
			and C.Mcodigo = A.Mcodigo
	inner join SNegocios D 			
			on D.Ecodigo = A.Ecodigo 
			and D.SNcodigo = A.SNcodigo
	inner join Usuario UD 			
			on UD.Usucodigo = A.Usucodigo
	inner join DatosPersonales DPD 			
			on DPD.datos_personales = UD.datos_personales
	left outer join Usuario UA 			
			on UA.Usucodigo = A.BMUsucodigo  
	left outer  join DatosPersonales DPA			
			on DPA.datos_personales = UA.datos_personales
	where  A.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and EDIid      = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIid#"> 
</cfquery>

<cfquery name="rsDetalle" datasource="#session.DSN#">
	select 	A.DDlinea ,
			coalesce(CFformato,'-') as CFformato,
			DDIcantidad,
			#LvarOBJ_PrecioU.enSQL_AS("DDIpreciou")#,
			DDItotallinea,
			case when A.Aid is not null then
				coalesce((select B.Acodigo from Articulos B where B.Ecodigo = A.Ecodigo and B.Aid = A.Aid),'-')
				when A.Cid is not null then
				coalesce((select C.Ccodigo from Conceptos C where C.Ecodigo = A.Ecodigo and C.Cid = A.Cid),'-')
				else '-'
			end as Codigo,
			case when A.Aid is not null then
				coalesce((select B.Adescripcion from  Articulos B where B.Ecodigo = A.Ecodigo and B.Aid = A.Aid),'-')
				when A.Cid is not null then
				coalesce((select C.Cdescripcion  from  Conceptos C where C.Ecodigo = A.Ecodigo and C.Cid = A.Cid),'-')
				when A.Icodigo is not null then A.Icodigo
				else coalesce((select DOCM.DOdescripcion from DOrdenCM DOCM where DOCM.DOlinea = A.DOlinea), '-')
			end as descripcion,
			A.DDIporcdesc,
			((A.DDIpreciou * A.DDIcantidad)*DDIporcdesc/100) as MontoDescuento
	from DDocumentosI A 
	left outer join CFinanciera D			
		on D.Ecodigo = A.Ecodigo 
		and D.CFcuenta = A.CFcuenta
	where A.Ecodigo  = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		and EDIid    = <cfqueryparam cfsqltype="cf_sql_numeric" value="#EDIid#"> 
</cfquery>

<cfinclude template="AREA_HEADER.cfm"><br>
<cfoutput>
<table width="100%" align="left"  border="0" cellspacing="0" cellpadding="2">
	<tr>
		<td colspan="4" class="tituloListas"><strong>Datos de la Transacci&oacute;n </strong></td>
	</tr>
  <tr>
		<td width="20%" valign="top"><strong>N&uacute;mero de Documento&nbsp;:&nbsp;</strong></td>
		<td width="30%" valign="top">#rsEncabezado.Ddocumento#</td>
		<td width="20%" valign="top"><strong>Tipo de Documento &nbsp;:&nbsp;</strong></td>
		<td width="30%" valign="top">#rsEncabezado.tipo#</td>
  </tr>
  <tr>
		<td valign="top"><strong>Fecha del Documento:&nbsp;</strong></td>
		<td valign="top">#LSDateFormat(rsEncabezado.EDIfecha,'dd/mm/yyyy')#</td>
		<td valign="top"><strong>Proveedor&nbsp;:&nbsp;</strong></td>
		<td valign="top">#rsEncabezado.SNnumero# - #rsEncabezado.SNnombre#</td>
  </tr>
 	<tr>
		<td valign="top"><strong>Tipo de Cambio&nbsp;:&nbsp;</strong></td>
		<td valign="top">#LSCurrencyFormat(rsEncabezado.EDItc,'none')#</td> 
		<td valign="top"><strong>Moneda&nbsp;:&nbsp;</strong></td>
		<td valign="top">#rsEncabezado.Mnombre#</td>
  </tr>
 	<tr>
		<td valign="top"><strong>Estado:&nbsp;</strong></td>
		<td valign="top">#rsEncabezado.Estado#</td> 
		<td valign="top"><strong>Creada Por:&nbsp;</strong></td>
		<td valign="top">#rsEncabezado.Digitador#</td> 
  </tr>
  <cfif isdefined("rsEncabezado.EDIestado") and rsEncabezado.EDIestado EQ 60>
		<tr>
			<td valign="top"><strong>Anulada por:&nbsp;</strong></td>
			<td  colspan="3" valign="top">#rsEncabezado.Anulador#</td> 
	  </tr>
  </cfif>
 	<tr>
		<td valign="top"><strong>Observaciones&nbsp;:&nbsp;</strong></td>
		<td valign="top" colspan="3">#rsEncabezado.EDobservaciones#</td>
  	</tr>
 	<cfif isdefined("rsEncabezado.EDIestado") and rsEncabezado.EDIestado EQ 60>
		<tr>
			<td valign="top"><strong>Motivo de la anulaci&oacute;n&nbsp;:&nbsp;</strong></td>
			<td valign="top" colspan="3">#rsEncabezado.EDmotivoanul#</td>
		</tr>	
	</cfif>
	<tr>
			
	<tr>
		<td colspan="4">&nbsp;</td>
	</tr>
	<tr>
		<td colspan="4" style="border-bottom: 1px solid black;" ><strong>Detalles de la <strong>Transacci&oacute;n</strong></strong></td>
	</tr>
	<tr>
		<td colspan="4">
			<table width="100%" align="center"  border="0" cellspacing="0" cellpadding="2">
				<tr>
					<td nowrap width="5%" class="tituloListas" style="padding-right: 5px;  border-left: 1px solid black; border-bottom: 1px solid black;">Línea</td>
					<td nowrap width="10%" class="tituloListas" style="padding-right: 5px;  border-bottom: 1px solid black; border-left: 1px solid black;">C&oacute;digo</td>
					<td nowrap width="30%" class="tituloListas" style="padding-right: 5px;  border-bottom: 1px solid black; border-left: 1px solid black;">Bien/Servicio</td>
					<td nowrap width="40%" class="tituloListas" style="padding-right: 5px;  border-bottom: 1px solid black; border-left: 1px solid black;">Cuenta</td>
					<td nowrap width="2%" align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Cantidad</td>
					<td nowrap width="3%" align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Precio Unitario</td>
					<td nowrap width="3%" align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">% Descuento</td>
					<td nowrap width="3%" align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">Monto Descuento</td>
					<td nowrap width="5%" align="right" class="tituloListas" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid black;">Total</td>
				</tr>
				<cfset Total = 0 >
 				<cfloop query="rsDetalle">
					<tr>	
						<td nowrap width="5%" align="left"  style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">#rsDetalle.DDlinea#</td> 
						<td nowrap width="10%" align="left" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">#trim(rsDetalle.Codigo)#</td>
						<td nowrap width="30%" align="left" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">#trim(rsDetalle.descripcion)#</td>
						<td nowrap width="40%" align="left" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">#trim(rsDetalle.CFformato)#</td>
						<td nowrap width="2%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">#LSNumberFormat(rsDetalle.DDIcantidad,',9.00')#</td>
						<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">#LvarOBJ_PrecioU.enCF(rsDetalle.DDIpreciou)#</td>
						<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">#LSNumberFormat(rsDetalle.DDIporcdesc,',9.0000')#</td>
						<td nowrap width="3%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black;">#LSNumberFormat(rsDetalle.MontoDescuento,',9.0000')#</td>
						<td nowrap width="5%" align="right" style="padding-right: 5px; border-bottom: 1px solid black; border-left: 1px solid black; border-right: 1px solid black; ">#LSNumberFormat(rsDetalle.DDItotallinea,',9.00')#</td>
					</tr> 		
					<cfset Total = Total + rsDetalle.DDItotallinea >
				</cfloop>
					<tr>	
						<td colspan="7" >&nbsp;</td> 
					</tr> 				
					<tr>	
						<td colspan="5" >&nbsp;</td> 
						<td ><strong>Total</strong></td> 
						<td align="right">#LSNumberFormat(Total,',9.00')#</td> 
					</tr> 				
			</table>
		</td>
	</tr>
</table>	
</cfoutput>
