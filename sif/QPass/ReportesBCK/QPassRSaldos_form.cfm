		 <cfquery name="rsEmpresa" datasource="#session.dsn#">
			  select Enombre
			  from Empresa
			  where CEcodigo = #session.CEcodigo#
		 </cfquery>
			
			 <cfif isdefined ('form.QPLfechaSaldoH') and len(trim(form.QPLfechaSaldoH))>
				  <cfset LvarFechaFin = DateAdd("d", 1, #dateformat(form.QPLfechaSaldoH,'dd/mm/yyyy')#)>
				  <cfset LvarFechaFin = DateAdd("s", -1, #LvarFechaFin#)>
			 </cfif>
			 
		<cfquery datasource="#session.DSN#" name="rsVenta">
            select 
                mc.QPMCSaldoMonedaLocal as saldo,
                m.Mnombre as Moneda,
					 mc.QPMCFInclusion as Fecha_corte,
                co.QPvtaConvDesc as convenio,
                d.QPTPAN as Quick_Pass,
                c.QPcteNombre as Nombre,
                tc.QPtipoCteDes as tipo_identificacion,
                c.QPcteDocumento as identificacion,
                a.QPvtaTagPlaca as placa,
                
                ((
                    select min(b.QPctaBancoNum)
                    from QPcuentaBanco b
                    where b.QPctaBancoid = s.QPctaBancoid
                )) as cuenta,
            
                c.QPCente as ente,
                c.QPcteTelefono1 as Tel_casa,
                c.QPcteTelefono2 as Tel_cel,
                c.QPcteCorreo as correo,
                o.Odescripcion as sucursal,
                e.QPEdescripcion as estado_tag,
                case d.QPTEstadoActivacion when 1 then 'En Banco / Almacen o Sucursal'
                when 2 then 'Recuperado ( En poder del banco por recuperacion )'
                when 3 then 'En proceso de Venta ( Asignado a Cliente pero no Activado )'
                when 4 then 'Vendido y Activo'
                when 5 then 'Vendido e Inactivo'
                when 6 then 'Vendido y Retirado'
                when 7 then 'Robado o Extraviado'
                when 8 then 'En traslado sucurcal/PuntoVenta'
                when 9 then 'Asignado a Promotor'
                when 90 then 'Eliminado'
                else '' end as Trazabilidad,
                case d.QPTlista when 'B' then 'Blanca'
                when 'G' then 'Gris'
                when 'N' then 'Negra'
                else '' end as color_lista,
                s.QPctaSaldosTipo,
                a.QPcteid,
                a.QPctaSaldosid
          
			   from QPventaTags a
                inner join QPventaConvenio co
               	 on co.QPvtaConvid = a.QPvtaConvid
                inner join QPassTag d
                    inner join QPassEstado e
                   	on e.QPidEstado = d.QPidEstado
                	 on d.QPTidTag = a.QPTidTag
                
                inner join QPcliente c
                    inner join QPtipoCliente tc
                    on tc.QPtipoCteid = c.QPtipoCteid
                	on c.QPcteid = a.QPcteid
					 
                inner join QPcuentaSaldos s 
					 left outer join QPMovCuenta mc
 						 on mc.QPctaSaldosid = s.QPctaSaldosid

 						and mc.QPMCid = 
						(
							select max(QPMCid) 
                       	from QPMovCuenta m 
                       	where m.QPTidTag = mc.QPTidTag
                  )

                inner join Monedas m 
                   on m.Mcodigo = s.Mcodigo
 					on s.QPctaSaldosid = a.QPctaSaldosid 
					 		
                inner join Oficinas o
               	 on o.Ecodigo = a.Ecodigo
               	 and o.Ocodigo = a.Ocodigo
        
            where a.Ecodigo = #session.Ecodigo#
            and a.QPvtaEstado = 1
            <cfif isdefined('form.Oficina')and len(trim(form.Oficina))>
            and a.Ocodigo = #form.Oficina#
            </cfif>
        
			<cfif isdefined("form.QPLfechaSaldoD") and len(trim(form.QPLfechaSaldoD)) and isdefined("form.QPLfechaSaldoH") and len(trim(form.QPLfechaSaldoH))>
				and mc.QPMCFInclusion between <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.QPLfechaSaldoD)#"> and #LvarFechaFin#
			
			<cfelseif isdefined("form.QPLfechaSaldoD") and len(trim(form.QPLfechaSaldoD))>
				and mc.QPMCFInclusion >= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.QPLfechaSaldoD)#">
			
			<cfelseif isdefined("form.QPLfechaSaldoH") and len(trim(form.QPLfechaSaldoH))>
				and mc.QPMCFInclusion <= <cfqueryparam cfsqltype="cf_sql_date" value="#LSParseDateTime(form.QPLfechaSaldoH)#">
			</cfif>
            order by mc.QPMCFInclusion desc
        </cfquery>

	<cfcontent type="application/vnd.ms-excel">
	<cfheader name="Content-Disposition" value="attachment; filename=Saldos_#dateformat(now(),'dd-mm-yyy')#_#hour(now())#_#Minute(now())#_#second(now())#.xls">
	<cfset getPageContext().getResponse().setHeader("Cache-Control", "public")>

	<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN"
		"http://www.w3.org/TR/html4/loose.dtd">
	<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40">
		<head>
			<title>Consulta Recuperacion Cobranza</title>
			<style type="text/css">
				table
				{mso-displayed-decimal-separator:"\.";
				mso-displayed-thousand-separator:"\,";}
				.numWithoutDec {mso-number-format:”\#\,\#\#0?;text-align:right;}
				.numWith2Dec {mso-number-format:Standard;text-align:right}
				.date {mso-number-format:”mm\/dd\/yyyy\;\@”}
			</style>
			<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1">
			<meta http-equiv="content-language" content="es" />
		</head>
		
		<cfset LvarColSpan = 19>
		<cfset cantidad = 0>
		<cfset total = 0>
		<cfset totalC = 0>

	<cfif rsVenta.recordCount EQ 0>
		<cfset totalC = 0>
	<cfelse>
		<cfquery name="rsTotalClientes" dbtype="query">
			select count(distinct QPcteid) as clientes
			  from rsVenta
		</cfquery>	
		<cfset totalC = rsTotalClientes.clientes>
	</cfif>
					
	<cfloop query="rsVenta">
		<cfquery name="rsTotalSaldos" datasource="#session.dsn#">
			select sum(QPctaSaldosSaldo) as QPctaSaldosSaldo 
			from QPcuentaSaldos  
			where QPctaSaldosid = #rsVenta.QPctaSaldosid#    	
			and QPctaSaldosTipo = 2
		</cfquery>
				<cfset LvarMonto = rsTotalSaldos.QPctaSaldosSaldo>
				<cfset total = total + #numberformat(LvarMonto, "9.00")#>	
	</cfloop>

	<cffunction name="fnCantQuickPass" access="private" output="yes">
		<cfset cantidad = cantidad + 1>
	</cffunction>

		<table>
			<cfoutput>
			<tr>
				  <td align="center" colspan="#LvarColSpan#" class="tituloListas"><strong>#rsEmpresa.Enombre#</strong></td>
			</tr>
			 <cfloop query="rsVenta">
					<cfset fnCantQuickPass()>
			 </cfloop>
        <tr align="center">
            <td align="center" style="width:1%" colspan="#LvarColSpan#" class="tituloListas">
                <strong>Desde:#form.QPLfechaSaldoD# hasta:#form.QPLfechaSaldoH#</strong>
            </td>
        </tr>
        <tr align="center">
            <td align="center" colspan="#LvarColSpan#" class="tituloListas">
                <strong>Total de Saldo Prepago: #total# #rsVenta.Moneda#</strong>
            </td>
        </tr>
		  <tr align="center">
            <td align="center" colspan="#LvarColSpan#" class="tituloListas">
                <strong>Total de Clientes: #totalC#</strong>
            </td>
        </tr>
        <tr align="center">
            <td align="center" colspan="#LvarColSpan#" class="tituloListas">
                <strong>Cantidad de Dispositivos: #cantidad#</strong>
            </td>
        </tr>
			<tr>
				  <td align="center" colspan="#LvarColSpan#" class="tituloListas"><strong>Sistema de Telepeaje QuickPass</strong></td>
			</tr>

			<tr>
				<td colspan="15">&nbsp;</td>
			</tr>
			</cfoutput>
	 		<tr nowrap="nowrap" align="center" class="tituloListas">
		      <td colspan="0" align="left" nowrap="nowrap">Fecha de Corte</td>
            <td colspan="0" align="left">Convenio</td>
				<td colspan="0" align="left">Saldo Prepago</td>
            <td colspan="0" align="left">QuickPass</td>
            <td colspan="0" align="left">Cliente</td>
            <td colspan="0" align="left" nowrap="nowrap">Tipo de Identificaci&oacute;n</td>
            <td colspan="0" align="left">Identificaci&oacute;n</td>
            <td colspan="0" align="left">Placa</td>
            <td colspan="0" align="left" nowrap="nowrap">Número de Cuenta</td>
            <td colspan="0" align="left">Ente</td>
            <td colspan="0" align="left">Teléfono</td>
            <td colspan="0" align="left">Celular</td>
            <td colspan="0" align="left">Email</td>
            <td colspan="0" align="left" nowrap="nowrap">Sucursal de la venta</td>
            <td colspan="0" align="left" nowrap="nowrap">Estado del TAG</td>
            <td colspan="0" align="left" nowrap="nowrap">Trazabilidad del TAG</td>
            <td colspan="0" align="left" nowrap="nowrap">Color de Lista Vigente</td>
			</tr>
            <cfflush interval="24">
			<cfoutput query="rsVenta">
				<tr>
					<td x:date>#DateFormat(rsVenta.Fecha_corte,'dd/mm/yyyy')#</td>
					<td x:str>#rsVenta.convenio#</td>
					<td x:date>#LSNumberFormat(rsVenta.saldo, ',9.00')#</td>
					<td x:str>#rsVenta.Quick_Pass#</td>
					<td x:str>#rsVenta.Nombre#</td> 
					<td x:str>#rsVenta.tipo_identificacion#</td>
					<td x:str>#rsVenta.identificacion#</td>
					<td x:str>#rsVenta.placa#</td>
					<td x:str><cfif #rsVenta.QPctaSaldosTipo# eq 1>#rsVenta.cuenta#<cfelse>N/A </cfif></td>
					<td x:str><cfif #rsVenta.QPctaSaldosTipo# eq 1>#rsVenta.ente#<cfelse>N/A </cfif></td>
					<td x:str>#rsVenta.Tel_casa#</td>
					<td x:str>#rsVenta.Tel_cel#</td>
					<td x:str>#rsVenta.correo#</td>
					<td x:str>#rsVenta.sucursal#</td>
					<td x:str>#rsVenta.estado_tag#</td>
					<td x:str>#rsVenta.Trazabilidad#</td>
					<td x:str>#rsVenta.color_lista#</td>
				</tr>
			</cfoutput>
		</table>
	</html>




