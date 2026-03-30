<cfoutput>
	<cfset Cortes = createObject('component', 'crc.Componentes.cortes.CRCCortes')>
	<cfset currentCorte = Cortes.GetCorte(Now(), "#form.tipo#","#session.dsn#",session.ecodigo)>


	<!--- se valida que el valor resultante sea mayor o igual que cero--->
	<cfquery name="qCuenta" datasource="#session.dsn#">
		select MontoAprobado from CRCCuentas  where id = #form.id#
	</cfquery>
<cfset aumento = form.AumentoCred>
<cfif isdefined("form.disminuir")>
	<cfset aumento = aumento * -1>
</cfif>
	<cfset loc.CaluloMenorCero = ''>
	<cfif qCuenta.recordCount gt 0 >
	 
		<cfset loc.Calculo = qCuenta.MontoAprobado + form.AumentoCred>
		<cfif loc.Calculo  gt 0 >
			<cfset mensaje = "Aumento">
			<cfif form.AumentoCred lt 0><cfset mensaje = "Disminucion"></cfif>
			<cfquery name="q_usuario" datasource="#session.DSN#">
				select A.llave from UsuarioReferencia A 
					inner join DatosEmpleado B 
						on A.llave = B.DEid 
				where A.Usucodigo = #session.usucodigo# and STabla = 'DatosEmpleado';
			</cfquery>
			
			<cfset mensaje = '#mensaje# de la Linea de Credito por #LSCurrencyFormat(Abs(NumberFormat(form.AumentoCred,"0.00")))#'>
			<cfset Incidencia = createObject('component', 'crc.Componentes.incidencias.CRCIncidencia')>
			<cfset nuevaIncidencia = Incidencia.crearIncidencia(CuentaID=form.id,Mensaje="#mensaje#")>

			<cfquery datasource="#session.dsn#">
				update CRCCuentas set MontoAprobado = round(MontoAprobado + #aumento#,2) where id = #form.id#
			</cfquery>
		
		<cfelse>
			<cfset loc.CaluloMenorCero = "El valor resultante no puede ser menor que cero">

		</cfif>
			 

	</cfif>


	<!---VALIDADOR--->

	<form action="LineaCredito.cfm" method="post" name="sql">
		<input name="modo" type="hidden" value="CAMBIO">
		<input name="id" type="hidden" value="#form.id#">
		<input name="resultT" type="hidden" value="#loc.CaluloMenorCero#">
	</form>
</cfoutput>

<HTML>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"></head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
