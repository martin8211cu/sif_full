<cfif isdefined('form.btnConsultar')>
	<!--- Creaci[on de la tabla temporal de trabajo para agregar los dos bloques de registros, 
		1) Los totales por clasificacion de articulos
		2) Los totales por debitos importados por estacion y por dia --->
	<cf_dbtemp name="reporteTMP" returnvariable="reporteTMP" datasource="#session.DSN#">
		<cf_dbtempcol name="totDebitos" type="money" mandatory="yes">
		<cf_dbtempcol name="totCreditos" type="money" mandatory="yes">
		<cf_dbtempcol name="Ccodigo" type="int" mandatory="yes">		
		<cf_dbtempcol name="Cdescripcion" type="varchar(80)" mandatory="no">
		<cf_dbtempcol name="Odescripcion" type="varchar(60)" mandatory="no">
		<cf_dbtempcol name="tipo" type="varchar(1)" mandatory="yes">
		<cf_dbtempcol name="cuenta"	type="varchar(100)"	mandatory="yes" > 
	</cf_dbtemp>

	<cfquery name="rsReporteClas" datasource="#session.DSN#">
			insert into #reporteTMP# (totDebitos,totCreditos,Ccodigo,Cdescripcion,Odescripcion,tipo,cuenta)
			select 
				0 as totDebitos
				, sum((coalesce(b.Unidades_vendidas,0) * (coalesce(b.Precio,0)) - b.Descuento) + 
					(((coalesce(b.Unidades_vendidas,0) * (coalesce(b.Precio,0))) * coalesce(c1.Iporcentaje,0)) / 100
					)) as totCreditos
				, d.Ccodigo
				, d.Cdescripcion
				, b1.Odescripcion
				, 'C' as tipo
				,  cc.Cformato as cuenta
			from ESalidaProd a
				inner join DSalidaProd b
					on b.Ecodigo=a.Ecodigo	
						and b.ID_salprod=a.ID_salprod
			
				inner join Oficinas b1
					on b1.Ecodigo=b.Ecodigo
						and b1.Ocodigo=a.Ocodigo		
			
				inner join Articulos c
					on c.Ecodigo=b.Ecodigo
						and c.Aid=b.Aid

				inner join Artxpista ap
					on ap.Ecodigo=c.Ecodigo
						and ap.Aid=c.Aid
						and ap.Pista_id=a.Pista_id
						and ap.Estado=1						
			
				left outer join Impuestos c1
					on c1.Ecodigo=c.Ecodigo
						and c1.Icodigo=c.Icodigo	
			
				inner join Clasificaciones d
					on d.Ecodigo=c.Ecodigo
						and d.Ccodigo=c.Ccodigo
						

				inner join Existencias ex
					on ex.Ecodigo=c.Ecodigo
						and ex.Aid=c.Aid
						and ex.Alm_Aid=ap.Alm_Aid
	
				left outer join IAContables iac
					on iac.Ecodigo=ex.Ecodigo
						and iac.IACcodigo=ex.IACcodigo

				left outer join CContables cc
					on cc.Ecodigo=iac.Ecodigo
						and cc.Ccuenta=iac.IACingventa						
			
			where a.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
				<cfif isdefined('form.rdPosteada') and form.rdPosteada EQ 1>
					and a.SPestado=10
				<cfelse>
					and a.SPestado=0					
				</cfif>			
				<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''>
					and a.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">								
				</cfif>	
				<cfif isdefined('form.SPfecha') and form.SPfecha NEQ ''>
					and a.SPfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.SPfecha)#">								
				</cfif>					
			group by d.Ccodigo, d.Cdescripcion, b1.Odescripcion,cc.Cformato
	</cfquery>
	
<cfquery name="rsReporteDebs" datasource="#session.DSN#">
		insert into #reporteTMP# (totDebitos,totCreditos,Ccodigo,Cdescripcion,Odescripcion,tipo,cuenta)
		select 
			coalesce(TDCtotal,0) as totDebitos
			, 0 as totCreditos
			, -1 as Ccodigo
			, TDCdesc as Cdescripcion
			, g.Odescripcion
			, e.TDCtipo as tipo
			, h.CFformato as cuenta
		from TotDebitosCreditos e
			inner join ESalidaProd f
				on f.Ecodigo=e.Ecodigo
					and f.ID_salprod=e.ID_salprod
					<cfif isdefined('form.rdPosteada') and form.rdPosteada EQ 1>
						and f.SPestado=10
					<cfelse>
						and f.SPestado=0
					</cfif>			
					<cfif isdefined('form.f_Ocodigo') and form.f_Ocodigo NEQ ''>
						and f.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.f_Ocodigo#">								
					</cfif>	
					<cfif isdefined('form.SPfecha') and form.SPfecha NEQ ''>
						and f.SPfecha = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#LSParseDateTime(form.SPfecha)#">								
					</cfif>	

			inner join Oficinas g
				on g.Ecodigo=f.Ecodigo
					and g.Ocodigo=f.Ocodigo

			inner join CFinanciera h
				on h.Ecodigo=g.Ecodigo
					and h.CFformato=e.TDCformato

		where e.Ecodigo=<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">	
	</cfquery>

	<cfquery name="rsReporte" datasource="#session.DSN#">
		Select  totDebitos,totCreditos,Ccodigo,Cdescripcion,Odescripcion,tipo,cuenta 
		from #reporteTMP#
	</cfquery>
	

	<cfif rsReporte.recordcount GT 10000>
		<br>
		<br>
		Se genero un reporte más grande de lo permitido.  Se abortó el proceso
		<br>
		<br>
		<cfabort>
	</cfif>
	
<!---	
<cfdump var="#form#">
<cfdump var="#rsReporte#">

<cfabort>	
  --->
	<cfquery name="rsEmpresa" datasource="#session.DSN#">
		select Edescripcion 
		from Empresas
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
	</cfquery>
	
	<!--- INVOCA EL REPORTE --->
	
	<cfif isdefined('rsReporte') and rsReporte.recordCount GT 0>
		<cfreport format="#form.formato#" template= "consolidadoVentas.cfr" query="rsReporte">
			<cfreportparam name="fecha" value="#form.SPfecha#">
			<cfreportparam name="Edesc" value="#rsEmpresa.Edescripcion#">
		</cfreport>
	<cfelse>
		<table width="70%"  border="0" cellspacing="0" cellpadding="0" align="center">
		  <tr><td>&nbsp;</td></tr>
		  <tr><td>&nbsp;</td></tr>
		  <tr><td align="center"><strong>**** No se encontr&oacute; informaci&oacute;n para el reporte **** </strong></td></tr>
		  <tr><td>&nbsp;</td></tr>
		  <tr><td>&nbsp;</td></tr>
		  <tr><td align="center"><input name="Regresar" type="button" onClick="javascript: regresar();" value="Regresar"></td></tr>			  
		</table>
	</cfif>
</cfif>	

<script language="javascript" type="text/javascript">
	function regresar(){
		document.href=history.back();
		return false;
	}
</script>
