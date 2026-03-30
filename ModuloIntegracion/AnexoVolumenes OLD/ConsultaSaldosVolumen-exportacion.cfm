<cfset minisifdb = Application.dsinfo[session.dsn].schema>

<cfsetting requesttimeout="3600"> 
<cfparam name="url.formato" default="HTML">
<cfif not IsDefined("url.Regresa")>
	<cfset url.Regresa="Reversion.cfm">
</cfif>

<cf_navegacion name="fltPeriodo" 		navegacion="" session default="-1">
<cf_navegacion name="fltMes" 		    navegacion="" session default="-1">
<cf_navegacion name="fltTipoVenta" 		navegacion="" session default="-1">
<cf_navegacion name="fltProducto" 		navegacion="" session default="-1">
<cf_navegacion name="fltTipoDoc" 		navegacion="" session default="-1">
<cf_navegacion name="Grupo1" 		navegacion="" session default="-1">
<cf_navegacion name="MovAd" 		navegacion="" session default="-1">

<cfquery name="rsReversion" datasource="#Session.DSN#">
	select SE.ID_Saldo as Registro, Ecodigo, Periodo, Case Mes when 1 then 'Enero' when 2 then 'Febrero' when 3 then 	    'Marzo' when 4 then 'Abril' when 5 then 'Mayo'
    when 6 then 'Junio' when 7 then 'Julio' when 8 then 'Agosto' when 9 then 'Septiembre' when 10 then 'Octubre' when 11    then 'Noviembre' when 12 then 'Diciembre' end as Mes, Clas_Venta + Producto as Clave, case Tipo_Documento when 'PRFC'    then 'FACT' when 'PRNF' then 'NOFACT' end as Tipo_Documento,
    convert(varchar, convert (money,Volumen_Documento), 1) as Volumen_Documento, convert (varchar, convert    (money,Volumen_Actual), 1) as Volumen_Actual, convert (varchar, convert (money, Volumen_Nuevo),1) as Volumen_Nuevo,    Poliza_Ref, Observaciones, Usulogin as Usuario, convert(varchar(15), Fecha_Actualizacion, 103)    as Fecha	  
    from SaldosVolumen SE
    left join SaldosVolumenMov SD on SE.ID_Saldo = SD.ID_Saldo
    left join Usuario U on SD.Usuario = U.Usucodigo
    where 1=1
	<cfif form.Grupo1 EQ 'Ninguno' or form.Grupo1 EQ 'Nasa'>
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		<cfelseif form.Grupo1 EQ 'Intercompañia'>
			<cfif rsEquiv.recordcount EQ 1>
				and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#rsEquiv.EQUidSIF#">
			<cfelseif rsEquiv.recordcount GT 1>
				and Ecodigo in (#Ecodigo#)
		</cfif>
	</cfif>
	<cfif form.fltPeriodo neq -1>
		and Periodo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltPeriodo#"> 
	</cfif>
	<cfif form.fltMes neq -1>
		and Mes = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.fltMes#">
	</cfif>
	<cfif form.fltTipoVenta neq -1 and form.Grupo1 EQ 'Ninguno'>
    	and  Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltTipoVenta)#">
	<cfelseif form.fltTipoVenta neq -1 and form.Grupo1 EQ 'Nasa'>
		and Clas_Venta in (<cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltTipoVenta)#">,
		<cfqueryparam cfsqltype="cf_sql_varchar" value="VNA">)
	<cfelseif form.fltTipoVenta eq -1 and form.Grupo1 EQ 'Nasa'>
		and Clas_Venta = <cfqueryparam cfsqltype="cf_sql_varchar" value="VNA">						
	</cfif>
	<cfif form.fltProducto neq -1>
	   	and Producto = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltProducto)#">
	</cfif>
	<cfif form.fltTipoDoc neq -1>
	   	and Tipo_Documento = <cfqueryparam cfsqltype="cf_sql_varchar" value="#trim(form.fltTipoDoc)#">
	</cfif>
	<cfif isdefined("form.chkMovAd") and form.chkMovAd EQ 1>
						and Volumen_Actual != Volumen_Documento
	</cfif>
	order by Periodo, Mes, Producto
</cfquery>

<cfif isdefined("rsReversion") and rsReversion.recordcount gt 15000 and url.formato NEQ "HTML">
	<cfthrow message="Se han generado mas de 15000 registros para este reporte."	 detail="Se deben de utilizar los filtros con un rango mas pequeño.">
	<cfabort>
</cfif>

<cfif rsReversion.recordcount EQ 0>
	<cfthrow message="No existen registros que mostrar">
</cfif>

<cfif url.formato EQ "HTML">
		<cf_htmlreportsheaders
			title="Volumenes de Venta" 
			filename="VolumenVenta-#rsReversion.Ecodigo#.xls" 
			ira="../AnexoVolumenes/ConsultaSaldosVolumen-form.cfm">

		<cf_templatecss>
		<cfflush interval="512">
		<cfoutput>

				<table width="130%" cellpadding="0" cellspacing="0"  bgcolor="##99CCFF">
					<tr>
						<td colspan="12">&nbsp;</td>
						<td align="right"><strong>#DateFormat(now(),"DD/MM/YYYY")#</strong></td>
					</tr>					
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>"PMI"</strong>	
						</td>
					</tr>
					<tr>
						<td style="font-size:16px" align="center" colspan="3">
						<strong>Volumenes de Venta en Barriles</strong>
						</td>
					</tr>
					<tr>
						<td colspan="3">&nbsp;</td>
					</tr>
					</table>
					<table width="130%">
					<tr>
						<td nowrap align="rigth"><strong>Registro</strong></td>
						<td nowrap align="rigth"><strong>Ecodigo</strong></td>
						<td nowrap align="rigth"><strong>Periodo</strong></td>
						<td nowrap align="rigth"><strong>Mes</strong></td>
						<td nowrap align="rigth"><strong>Clave</strong></td>
						<td nowrap align="rigth"><strong>Tipo Documento</strong></td>
						<td nowrap align="rigth"><strong>Volumen Documento</strong></td>
						<td nowrap align="rigth"><strong>Volumen Actual</strong></td>
						<td nowrap align="rigth"><strong>Volumen Movimiento</strong></td>
						<td nowrap align="rigth"><strong>Poliza Referencia</strong></td>
						<td nowrap align="rigth"><strong>Observaciones</strong></td>
						<td nowrap align="rigth"><strong>Usuario</strong></td>
						<td nowrap align="rigth"><strong>Fecha</strong></td>
					</tr>
					<tr><td colspan="7">&nbsp;</td></tr>
					<cfloop query="rsReversion">
						<tr>
							<td nowrap>#rsReversion.Registro#</td>
							<td nowrap>#rsReversion.Ecodigo#</td>
							<td nowrap>#rsReversion.Periodo#</td>
							<td nowrap>#rsReversion.Mes#</td>
							<td nowrap>#rsReversion.Clave#</td>
							<td nowrap>#rsReversion.Tipo_Documento#</td>
							<td nowrap>#rsReversion.Volumen_Documento#</td>
							<td nowrap>#rsReversion.Volumen_Actual#</td>
							<td nowrap>#rsReversion.Volumen_Nuevo#</td>
							<td nowrap>#rsReversion.Poliza_Ref#</td>
							<td nowrap>#rsReversion.Observaciones#</td>
							<td nowrap>#rsReversion.Usuario#</td>
							<td nowrap>#rsReversion.Fecha#</td>
						</tr>
					</cfloop>
		</cfoutput>
</cfif>


