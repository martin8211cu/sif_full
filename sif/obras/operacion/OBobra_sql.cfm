<cfparam name="url.OP" default="">
<cfparam name="url.OBOid" default="-1">
<!---=====Abrir Obra=====--->
<cfif url.OP EQ "A">
	<cftransaction>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select d.PCEcatid as PCEcatidObr, PCDcatidObr
					,PCEempresa
			  from OBobra o
				inner join PCDCatalogo d
					inner join PCECatalogo e
					   on e.PCEcatid = d.PCEcatid
				   on d.PCDcatid = o.PCDcatidObr
			 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBOid#">
		</cfquery>
	
		<cfquery datasource="#session.dsn#">
			update PCDCatalogo
			   set PCDactivo = 1
			 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.PCEcatidObr#">
			   and PCDcatid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.PCDcatidObr#">
			 <cfif rsSQL.PCEempresa EQ '1'>
			   and Ecodigo = #session.Ecodigo#
			 </cfif>
		</cfquery>

		<cfquery datasource="#session.dsn#" name="rsSQL">
			select OBOestado
			  from OBobra
			 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBOid#">
			   and OBOestado in ('0','2')
		</cfquery>
		<cfquery datasource="#session.dsn#">
			update OBobra
			   set OBOestado = '1'
			<cfif  rsSQL.OBOestado EQ "0">
			   	 <!--- Apertura --->
				 , OBOfechaAbierto 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 , UsucodigoAbierto	= #session.Usucodigo#
			<cfelse>
			   	 <!--- Reactivacion --->
				 , OBOfechaReabierto 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 , UsucodigoReabierto	= #session.Usucodigo#
			</cfif>
			 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBOid#">
			   and OBOestado in ('0','2')
		</cfquery>
	</cftransaction>
	
	<script>
		alert('La obra ha sido Abierta y se han desbloqueado todas sus cuentas financieras activas');
		location.href="OBobra.cfm?OBOid=<cfoutput>#url.OBOid#</cfoutput>";
	</script>
<!---=====Cerrar Obra=====--->
<cfelseif url.OP EQ "C">
	<cftransaction>
		<cfquery name="rsSQL" datasource="#session.dsn#">
			select d.PCEcatid as PCEcatidObr, PCDcatidObr
					,PCEempresa
			  from OBobra o
				inner join PCDCatalogo d
					inner join PCECatalogo e
					   on e.PCEcatid = d.PCEcatid
				   on d.PCDcatid = o.PCDcatidObr
			 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBOid#">
		</cfquery>
	
		<cfquery datasource="#session.dsn#">
			update PCDCatalogo
			   set PCDactivo = 0
			 where PCEcatid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsSQL.PCEcatidObr#">
			   and PCDcatid = <cfqueryparam cfsqltype="cf_sql_varchar" value="#rsSQL.PCDcatidObr#">
			 <cfif rsSQL.PCEempresa EQ '1'>
			   and Ecodigo = #session.Ecodigo#
			 </cfif>
		</cfquery>
	
		<cfquery datasource="#session.dsn#" name="rsForm_OBetapa">
			update OBobra
			   set OBOestado = '2'
				 , OBOfechaCerrado 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">
				 , UsucodigoCerrado	= #session.Usucodigo#
			 where OBOid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#url.OBOid#">
			   and OBOestado = '1'
		</cfquery>
	</cftransaction>
	
	<script>
		alert('La obra ha sido Cerrada y se han bloqueado todas sus cuentas financieras');
		location.href="OBobra.cfm?OBOid=<cfoutput>#url.OBOid#</cfoutput>";
	</script>
<!---=====Generar Cuentas=====--->
<cfelseif url.OP EQ "G">
	<cfinvoke component="sif.obras.Componentes.OB_obras" method="fnGeneraCtasObra" OBEid="#url.OBOid#" irA="OBobra.cfm">
<cfelseif url.OP EQ "L">
	<script>
		alert('El proceso de Liquidación no ha sido implementado todavía');
		location.href="OBobra.cfm?OBOid=<cfoutput>#url.OBOid#</cfoutput>";
	</script>
</cfif>
