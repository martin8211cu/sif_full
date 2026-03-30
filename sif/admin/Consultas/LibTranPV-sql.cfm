<!--- 	
	Modificado por Gustavo Fonseca Hernndez.
		Fecha: 11-5-2006.
		Motivo: Se guarda el SNcodigo y el tab en el form para que al hacer cambio mantenga el socio y el tab que
		esta utilizando el usuario.

	Hecho Por:	Rodolfo Jimnez Jara
		Fecha:		26/08/2005
		Motivo:		Grabar Liberacin de  Crdito
		Fecha:		29/08/2005
		Motivo: 	Grabar la Anulacion del Tramite liberado
 --->
<cfif IsDefined("form.btnGrabar")>
	<cfquery datasource="#session.dsn#">
		insert into FALiberaCredito  
		(Ecodigo ,FAX01NTR ,FAM01COD ,FAX01NTE ,MontoMax ,Mcodigo ,IPMaq ,Motivo  ,FechaFactura ,CCTcodigo ,Ddocumento ,MontoUtilizado ,
		LibFecha ,BMUsucodigo ,LibAnulada ,MotivoAnula  ,LibFechaAnula , IPMaqAnula , BMUsucodigoAnul, SNcodigo, SNid)
		   values(	
		   		<cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
				<cfif isdefined("form.FAX01NTR") and len(trim(form.FAX01NTR)) NEQ 0 >
					<cfqueryparam cfsqltype= "cf_sql_integer" value="#form.FAX01NTR#">,
				<cfelse>
					null, 
				</cfif>
				<cfif isdefined("form.FAM01COD") and len(trim(form.FAM01COD)) NEQ 0 >
					<cfqueryparam cfsqltype="cf_sql_char" value="#Form.FAM01COD#">,		
				<cfelse>
					null,
				</cfif>
				<cfif isdefined("form.FAX01NTE") and len(trim(form.FAX01NTE)) NEQ 0 >
					<cfqueryparam cfsqltype= "cf_sql_char" value="#form.FAX01NTE#">,
				<cfelse>
					null,
				</cfif>
				<cfif isdefined("form.MontoMax") and len(trim(form.MontoMax)) NEQ 0 >
					<cfqueryparam cfsqltype="cf_sql_double" value="#form.MontoMax#">,
				<cfelse>
					0,
				</cfif>
				
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.Mcodigo#">,
				<cfqueryparam cfsqltype= "cf_sql_char" value="#session.sitio.ip#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Motivo#">,
				null,
				null,
				null,
				0,
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
				0,
				null,
				null,
				null,
				null, 
				<cfqueryparam cfsqltype="cf_sql_integer" value="#form.SNcodigoconsultado#">,
				<cfqueryparam cfsqltype="cf_sql_numeric" value="#form.SNid#">)
	</cfquery>
</cfif>

<cfif IsDefined("form.MotivoAnulacion") and len(trim(form.MotivoAnulacion))>

	<cfquery datasource="#session.dsn#">
		update FALiberaCredito
		set LibAnulada 	= 1,
		MotivoAnula 	= <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.MotivoAnulacion#">,
		LibFechaAnula 	= <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
		IPMaqAnula 		= <cfqueryparam cfsqltype= "cf_sql_char" value="#session.sitio.ip#">,
		BMUsucodigoAnul = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">
		where FALiberaCreditoID = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.FALiberaCreditoID#">

	</cfquery>
</cfif>
<!--- invoca a la pantalla con los parametros correspodientes a cada  proceso--->
<form action="LibTranPV.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('Form.SNcodigo') and len(trim(Form.SNcodigo)) NEQ 0>
			<input type="hidden" name="SNcodigo" value="#form.SNcodigo#">	
		</cfif>
		<cfif isdefined('Form.SNcodigoconsultado') and len(trim(Form.SNcodigoconsultado)) NEQ 0>
			<input type="hidden" name="SNcodigo" value="#form.SNcodigoconsultado#">	
		</cfif>
		<cfif isdefined('form.SNnumero') and LEN(trim(form.SNnumero))>
			<input type="hidden" name="SNnumero" value="#form.SNnumero#">	
		</cfif>
		<cfif isdefined('form.tab') and LEN(trim(form.tab))>
			<input type="hidden" name="tab" value="#form.tab#">	
		</cfif>
	</cfoutput>
</form>


<html>
	<head>
	<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>

	<body>
		<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
	</body>
</html>


