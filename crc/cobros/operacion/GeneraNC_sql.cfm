<!--- Incluir datos de la tesoreria de la empresa --->
<cfinclude template="../../../sif/tesoreria/Solicitudes/TESid_Ecodigo.cfm">

<cftry>
	<cftransaction>
		<cfset crcGenerarNC= createObject("component", "crc.Componentes.pago.CRCGeneraNC")>
		<cfset CodigoDocumento = crcGenerarNC.CreaNC(CentroFuncionalID=form.CBOCFID, ConceptoId=form.CID, Monto=form.comisionTotal)>
	
		<cfquery datasource="#session.dsn#">
			insert into CRCGenerarNC (ETnumero,Ddocumento,Ecodigo,createdat,Usucrea)
			select e.ETnumero,'#CodigoDocumento#',#session.ecodigo#,CURRENT_TIMESTAMP,#session.usucodigo#
				from ETransacciones e
				where e.ETnumero in (#form.ETnumeros#) group by e.ETnumero;
		</cfquery>
		
	</cftransaction>
<cfcatch type="any">
	<cftransaction action="rollback">
		<cfrethrow>
</cfcatch>
</cftry>




<script>
	window.location.replace('GeneraNC.cfm');
</script>
