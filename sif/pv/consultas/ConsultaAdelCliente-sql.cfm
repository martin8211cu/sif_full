<cfif not isdefined('form.CDCcodigo') or len(form.CDCcodigo) lt 1>
	<table width="100%">
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">Debe de Escoger un cliente para realizar esta consulta.</td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
			<td align="center">Por favor regrese y seleccione el cliente </td>
		</tr>
		<tr><td>&nbsp;</td></tr>
		<tr>
		<td align="center">
			<input type="button" class="btnAnterior" value="Regresar" onclick="javascript: location.href = 'ConsultAdelCliente.cfm';"/>
		</td>
		</tr>
	</table>
	<cfabort>
</cfif> 
<cfinclude template="../../Utiles/sifConcat.cfm">
<cfquery name="rsReporte" datasource="#session.DSN#" maxrows="10001">
	select 
		 A.FAX01NTR     as Transaccion,
		 A.FAX01STA     as Estado,
		 H.Oficodigo    as Oficina, 
		 H.Odescripcion as Ofic_descrip,
		 D.FAM01CODD    as CodigoCaja, 
		 B.FAX14DOC     as Documento,
		 A.FAX01FEC     as FechaFactura,
		 ((
			select ltrim(rtrim(E.CDCidentificacion)) #_Cat# ' - ' #_Cat# ltrim(rtrim(E.CDCnombre)) 
			from ClientesDetallistasCorp as E <!--- clientes --->
			where E.CDCcodigo = A.CDCcodigo
		 ))as Cliente,
		 coalesce(B.FAX14MAP, 0.00) as Aplicado,
		 coalesce(A.FAX01FCAM, 1.0) as TipoCambio,
		 coalesce(A.FAX01TOT,  0.0) as TotalLinea,
		 case when A.FAX01TPG = 1 then 'Crédito' else 'Contado' end as TipoPago,
		 G.Miso4217 as CodigoMoneda
	from FAX001 as A
		inner join FAX014 B
		on B.FAX01NTR = A.FAX01NTR
		and B.FAM01COD = A.FAM01COD
		and B.Ecodigo = A.Ecodigo
	
		inner join Oficinas as H 
		on    A.Ocodigo = H.Ocodigo
		and A.Ecodigo = H.Ecodigo
	
		inner join FAM001 as D  
		on    A.FAM01COD = D.FAM01COD
		and A.Ecodigo = D.Ecodigo
	
		inner join Monedas as G <!--- monedas --->
		on  G.Mcodigo = A.Mcodigo

where A.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	and A.FAX01STA IN ('T', 'C')
	<!--- FILTRO DE CLIENTE --->
	<cfif isdefined("form.CDCcodigo") and len(trim(form.CDCcodigo))>
		and A.CDCcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CDCcodigo#">
	</cfif>

	<!--- FILTRO DE CAJA --->
	<cfif isdefined("form.FAM01COD") and len(form.FAM01COD) GT 0>
		and A.FAM01COD = <cfqueryparam cfsqltype="cf_sql_char" value="#form.CDCcodigo#">
	</cfif>

	<!--- FILTRO DE Fecha Inicial --->
	<cfif isdefined("form.FAX14FEC_ini") and len(form.FAX14FEC_ini) GT 0 and isdate(form.FAX14FEC_ini)>
		and A.FAX01FEC >= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FAX14FEC_ini#">
	</cfif>

	<!--- FILTRO DE Fecha Final --->
	<cfif isdefined("form.FAX14FEC_fin") and len(form.FAX14FEC_fin) GT 0 and isdate(form.FAX14FEC_fin)>
		and A.FAX01FEC <= <cfqueryparam cfsqltype="cf_sql_date" value="#form.FAX14FEC_fin#">
	</cfif>

	<cfif isdefined("form.FAX14DOC") and len(form.FAX14DOC)>
		and B.FAX14DOC = <cfqueryparam cfsqltype="cf_sql_char" value="#form.FAX14DOC#">
	</cfif>
</cfquery>

<cfif rsReporte.recordcount GT 10000>
	<!--- Generar en una tabla HTML que el reporte genera más de 10.000 registros.  Debe ser más específico en la consulta --->
	<cf_errorCode	code = "50569" msg = "Generar en una tabla HTML que el reporte genera más de 10.000 registros. Debe ser más específico en la consulta">
	<cfabort>
</cfif>

<cfif rsReporte.recordcount GT 500>
	<!--- Salida forzada a HTML cuando el formato es mayor a 500 registros --->
	<cfset form.Formato = 3>
</cfif>

<!--- DETERMINA EL TIPO DE FORMATO EN QUE SE RELAIZARA EL REPORTE --->
<cfif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 2>
	<cfset formatos = "pdf">
<cfelseif isdefined("form.Formato") and len(trim(form.Formato)) and form.Formato EQ 3>
	<cfset formatos = "HTML">
</cfif>

<cfif ucase(formatos) NEQ "HTML">
	<!--- INVOCA EL REPORTE --->
	<cfreport format="#formato#" template= "ConsultaAdelantosCliente.cfr" query="rsReporte">
		<cfreportparam name="Ecodigo" value="#session.Ecodigo#">
		<cfreportparam name="Edescripcion" value="#session.Enombre#">
	</cfreport>
	<cfabort>
</cfif>

<!--- Aqui hay que pintar la tabla con la información requerida --->
<!--- --->
	

