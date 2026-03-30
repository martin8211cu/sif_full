
<form action="LiqSaldos-ListaOrdenes.cfm" method="post" name="sql" id="sql"></form>

<cfoutput>
	<cfset items = '' >
	<cfloop collection="#Form#" item="i">
		<cfif FindNoCase("DOlinea_", i) NEQ 0>
			<cfset items = items & Iif(Len(Trim(items)), DE(","), DE("")) & Trim(StructFind(Form, i))>						
		</cfif>		
	</cfloop>

	<cfif not len(trim(items))>
		<script language="javascript1.2" type="text/javascript">
			alert('No ha Seleccionado ningún Item');
		</script>
		<!---
		<script language="javascript1.2" type="text/javascript">
			location.href = "LiqSaldos-ListaOrdenes.cfm";
		</script>
		--->
	<cfelse>	
		<cfset ordenes = '' >
		<cfloop list="#items#" index="i" delimiters=",">
			<!--- Query update de la cant.liquidada el usuario, la fecha y la justificacion del la liquidacion ---->
			<cfquery name="update" datasource="#Session.DSN#">
				update DOrdenCM
				set DOcantsurtida = DOcantidad,
					DOcantliq = <cfqueryparam cfsqltype="cf_sql_float" value="#form['saldo_#i#']#">,
					DOjustificacionliq = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.DOjustificacionliq#">,
					Usucodigoliq = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">,
					fechaliq = <cfqueryparam cfsqltype="cf_sql_timestamp" value="#Now()#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
					and DOlinea = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			</cfquery>			
		</cfloop>				
	</cfif> <!--- Fin del si se selecciono(chekeo) algun item --->
	<script language="javascript1.2" type="text/javascript">
		location.href = "LiqSaldos-ListaOrdenes.cfm";
	</script>
</cfoutput>


<!---- Cambiar el estado de la orden de compra 
<!--- Query para traer los EOidorden de las lineas chekeadas --->
<cfquery name="rsIdOrden" datasource="#Session.DSN#">
	select EOidorden
	from DOrdenCM
	where DOlinea = #i#
		and Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>
<cfif ListFindNoCase(ordenes,rsIdOrden.EOidorden,',') eq 0>
	<cfset ordenes = ordenes & ",#rsIdOrden.EOidorden#" >
</cfif>

<!--- Query para cambiar el estado de la orden cuando ya no quedan lineas con saldos ---->		
<cfloop list="#ordenes#" index="i" delimiters=",">
	<br>
	**********************************
	<cfquery name="rslineasSaldo" datasource="#Session.DSN#">
		select distinct a.EOidorden,a.EOnumero, a.Observaciones, a.EOfecha, m.CMTOdescripcion,b.DOcantidad,b.DOcantsurtida
		from EOrdenCM a
			inner join CMTipoOrden m
				on a.CMTOcodigo = m.CMTOcodigo
				and a.Ecodigo = m.Ecodigo
			left outer join DOrdenCM b
				on a.EOidorden = b.EOidorden
				and a.Ecodigo = b.Ecodigo
		where a.EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			and a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			and DOcantliq > 0
	</cfquery>
	<cfif rslineasSaldo.RecordCount EQ 0 > <!--- Si hay lineas en la orden ---->
		<!--- Query update del estado de la orden ---->
		<cfquery name="update" datasource="#Session.DSN#">
			update EOrdenCM
			set EOestado = EOestado
			where EOidorden = <cfqueryparam cfsqltype="cf_sql_numeric" value="#i#">
			and a.Ecodigo= <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#"> 
		</cfquery>				
	</cfif>
	<cfdump var="#rslineasSaldo#">
</cfloop>	
--->	
