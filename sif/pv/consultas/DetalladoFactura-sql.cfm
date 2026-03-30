
<!--- Creado por: 	  Rebeca Corrales Alfaro  --->
<!--- Fecha: 		  25/05/2005  4:00 p.m. --->
<!--- 
	Modificado por: Ana Villavicencio
 	Fecha: 03 de Octubre del 2005
 	Motivo: Cambiar la consulta para el reporte, este debe tomar en cuenta las facturas tipo 1 (FAX01TIP = 1).
			El nombre del cliente depende del tipo de factura, ya se credito o contado, si es crédito debe de 
			tomar el nombre de SNegocios y si es contado se toma de ClientesDetallistasCorp.
 --->
 
<cfif isdefined("url.FechaI") and len(url.FechaI)>
	<cfset LvarFechaI = createdate(right(url.FechaI,4),mid(url.FechaI,4,2),left(url.FechaI,2))>
</cfif>

<cfif isdefined("url.FechaF") and len(url.FechaF)>
	<cfset LvarFechaF = createdate(right(url.FechaF,4),mid(url.FechaF,4,2),left(url.FechaF,2))>
	<cfset LvarFechaF = dateadd('d',1,LvarFechaF)>
	<cfset LvarFechaF = dateadd('s',-1,LvarFechaF)>
</cfif>
 

<!--- VERIFICA QUE LAS FACTURA INICIAL SEA MENOR QUE LA FACTURA FINAL, Y SI NO LAS INVIERTE--->

<cfif isdefined("url.FAX11DOCI") and len(trim(url.FAX11DOCI)) and isdefined("url.FAX11DOCF") and len(trim(url.FAX11DOCF))>
	<cfif FAX11DOCI gt FAX11DOCF >
		<cfset tmp2 = url.FAX11DOCI >
		<cfset url.FAX11DOCI = url.FAX11DOCF >
		<cfset url.FAX11DOCF = tmp2 >
	</cfif>
</cfif>

<cfquery name="rsReporte" datasource="#session.DSN#">
	select count(1) as cantidad
	from FAX001 as A
			inner join FAM001 as D     
			 on D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo
			<cfif isdefined("url.FAM01CODD") and len(trim(url.FAM01CODD))>
			and D.FAM01CODD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD#">
			</cfif> 	

			inner join Monedas as G 
			 on G.Mcodigo = A.Mcodigo
			
			inner join Oficinas as H 
			 on H.Ecodigo = A.Ecodigo
			and H.Ocodigo = A.Ocodigo
 
			inner join FAX004 as B      
					left outer join FAM021 as F 
					 on F.FAX04CVD = B.FAX04CVD
					and F.Ecodigo = B.Ecodigo

			on B.FAM01COD = A.FAM01COD
			and B.FAX01NTR = A.FAX01NTR
			and B.Ecodigo  = A.Ecodigo
 
	where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and A.FAX01TIP in ('1','4')
	<!--- FILTROS DE FECHAS --->
	<cfif isdefined("url.FechaI") and len(trim(url.FechaI))>
		and A.FAX01FEC >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaI#">
	</cfif> 
	<cfif isdefined("url.FechaF") and len(trim(url.FechaF))>
		and A.FAX01FEC <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaF#">
	</cfif> 
	<!--- FILTRO DE OFICINA--->
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
	</cfif>
	<!--- FILTRO DE FACTURAS ---> 
	<cfif isdefined("url.FAX11DOCI") and len(url.FAX11DOCI) and isdefined("url.FAX11DOCF") and len(url.FAX11DOCF)>
	  and A.FAX01DOC >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FAX11DOCI#">
	  and A.FAX01DOC <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FAX11DOCF#">
	<cfelseif isdefined("url.FAX11DOCI") and len(url.FAX11DOCI)>
	  and A.FAX01DOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FAX11DOCI#">
	<cfelseif isdefined("url.FAX11DOCF") and len(url.FAX11DOCF)>
	  and A.FAX01DOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FAX11DOCF#">
	</cfif>
</cfquery>
<cfif rsReporte.cantidad GT 3000>
	<table border="0" cellpadding="0" cellspacing="0" width="100%">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		
		<tr valign="top" align="center" style="font-size:16px"> 
			<td align="center" ><strong>El n&uacute;mero de Documentos Resultantes (<cfoutput>#rsReporte.cantidad#</cfoutput>)</strong></td>
		</tr>
		<tr valign="top" align="center" style="font-size:16px"> 
			<td>
				<strong>en la consulta excede el l&iacute;mite permitido de 3000 registros.</strong>
			</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr valign="top" align="center" style="font-size:16px"> 
			<td align="center" ><strong>Delimite la consulta con filtros m&aacute;s detallados.</strong>
			</td>
		</tr>
	</table>
	<cfabort>
</cfif>

<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsReporte" datasource="#session.DSN#">
	select 
		A.FAX01NTR as Transaccion,
		H.Oficodigo as Oficina, 
		H.Odescripcion as Ofic_descrip,
		rtrim(D.FAM01CODD) as CodigoCaja, 
		A.FAX01DOC as Documento,
		A.FAX01FEC as FechaFactura,
		case A.FAX01TPG
			when 1 then 
				(( select rtrim(sn.SNnumero) #_Cat# '-' #_Cat# sn.SNnombre from SNegocios sn where sn.Ecodigo = A.Ecodigo and sn.SNcodigo = A.SNcodigo))
			else
				(( select rtrim(cc.CDCidentificacion) #_Cat# '-' #_Cat# cc.CDCnombre from ClientesDetallistasCorp cc where cc.CDCcodigo = A.CDCcodigo ))
		end as Cliente,		
		coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
		case 
			when A.FAX01TPG = 1 
			then 'Crédito'
			else 'Contado'
		end as TipoPago,
		G.Miso4217 as CodigoMoneda, 
		B.FAX04TIP as TipoItem,
		case 
			when B.FAX04TIP = 'A' 
			then (select Acodigo from Articulos ar where ar.Aid = B.Aid and ar.Ecodigo = B.Ecodigo)
			when B.FAX04TIP = 'S' 
			then (select Ccodigo from Conceptos co where co.Cid = B.Aid and co.Ecodigo = B.Ecodigo)
			else FAX04DCOD
		end as CodigoDet,
		B.FAX04DES as Descripcion,
		B.FAX04CAN as Cantidad,
		B.FAX04PRE as PrecioUnitario,
		B.FAX04CAN * B.FAX04PRE as PrecioBruto,
		B.FAX04DESC as Descuento,
		((B.FAX04CAN * B.FAX04PRE) - B.FAX04DESC) as PrecioNeto,
		(round(B.FAX04TOT * B.FAX04IMP / 100, 2)) as Impuesto,
		round(B.FAX04TOT + (round(B.FAX04TOT * B.FAX04IMP / 100, 2)), 2) as TotalLinea,
		ltrim(rtrim(B.FAX04CVD)) #_Cat# ' - ' #_Cat# ltrim(rtrim(F.FAM21NOM)) as Vendedor,
		(
		case 
			when A.SNcodigo is not null 
			then 'Socio relacionado: '#_Cat#(select convert(varchar ,SNnumero) #_Cat# SNnombre from SNegocios where Ecodigo = A.Ecodigo and SNcodigo= A.SNcodigo)  end ) as socio_relacionado
	from FAX001 as A
			inner join FAM001 as D     
			 on D.FAM01COD = A.FAM01COD
			and D.Ecodigo  = A.Ecodigo
			<cfif isdefined("url.FAM01CODD") and len(trim(url.FAM01CODD))>
			and D.FAM01CODD = <cfqueryparam cfsqltype="cf_sql_char" value="#url.FAM01CODD#">
			</cfif> 	

			inner join Monedas as G 
			 on G.Mcodigo = A.Mcodigo
			
			inner join Oficinas as H 
			 on H.Ecodigo = A.Ecodigo
			and H.Ocodigo = A.Ocodigo
 
			inner join FAX004 as B      
					left outer join FAM021 as F 
					 on F.FAX04CVD = B.FAX04CVD
					and F.Ecodigo = B.Ecodigo

			on B.FAM01COD = A.FAM01COD
			and B.FAX01NTR = A.FAX01NTR
			and B.Ecodigo  = A.Ecodigo
 
	where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and A.FAX01TIP in ('1','4')
	<!--- FILTROS DE FECHAS --->
	<cfif isdefined("url.FechaI") and len(trim(url.FechaI))>
		and A.FAX01FEC >= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaI#">
	</cfif> 
	<cfif isdefined("url.FechaF") and len(trim(url.FechaF))>
		and A.FAX01FEC <= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LvarFechaF#">
	</cfif> 
	<!--- FILTRO DE OFICINA--->
	<cfif isdefined("url.Ocodigo") and len(trim(url.Ocodigo))>
		and A.Ocodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.Ocodigo#">
	</cfif>
	<!--- FILTRO DE FACTURAS ---> 
	<cfif isdefined("url.FAX11DOCI") and len(url.FAX11DOCI) and isdefined("url.FAX11DOCF") and len(url.FAX11DOCF)>
	  and A.FAX01DOC >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FAX11DOCI#">
	  and A.FAX01DOC <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FAX11DOCF#">
	<cfelseif isdefined("url.FAX11DOCI") and len(url.FAX11DOCI)>
	  and A.FAX01DOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FAX11DOCI#">
	<cfelseif isdefined("url.FAX11DOCF") and len(url.FAX11DOCF)>
	  and A.FAX01DOC = <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.FAX11DOCF#">
	</cfif>
</cfquery>


<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
	<cfset formatos = "pdf">
</cfif>

<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>

<cfreport format="#formato#" template= "DetalladoFacturas.cfr" query="rsReporte">
	<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
	<cfreportparam name="Edescripcion" value="#rsEmpresa.Edescripcion#">
</cfreport>

