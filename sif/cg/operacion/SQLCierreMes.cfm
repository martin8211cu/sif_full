<!--- 
	Cierre de Mes de Contabilidad General
	
		1. Controlar que no se pueda ejecutar dos veces el cierre de mes. Se usa una variable de application para garantizar que no se esté ejecutando
			Esto se realiza con la bandera en application
			La bandera se enciende al inicio y se apaga al finalizar
		2. Presentar mensaje de proceso en ejecución
		3. Ejecutar el cierre.
		4. Si hay error, se presenta la pantalla respectiva
 --->
 
<cfset Session.debug = false>
<cfset LvarEmes = 0>
<cfset LvarEperiodo = 0>
<cfset LvarVerifica = 0>

<html><head><title>Procesando Cierre de Mes...</title></head>
<body>
<p><center>
<img src="/cfmx/sif/imagenes/esperese.gif" alt="Un momento por favor.... Realizando el Cierre de Mes...." width="320" height="90" border="0">
</center></p>

<!---<cfflush interval="32">--->

<cfif isdefined("Form.btnCierre")>
	<cflock name="LockCierreMes" type="exclusive" timeout="20" throwontimeout="no">
		<cfif not isdefined("application.LockCierreMes")>
			<cfset application.LockCierreMes = 0>
			<cfset application.LockCierreMesHora = dateadd("m", -1, now())>
		</cfif>
		<cfif application.LockCierreMes eq 1 and datediff('n', application.lockCierreMesHora, now()) LT 60>
			<cfset LvarVerifica = -1>
		<cfelse>
			<cfset application.LockCierreMes = 1>
			<cfset application.LockCierreMesHora = now()>
		</cfif>
	</cflock>

	<cfif LvarVerifica eq 0>
		<cfset LvarVerifica = fnVerificaAsientos()>
	</cfif>

	<cfif LvarVerifica EQ 0>
		<p align="center"> Procesando el Cierre de Mes ..... </p>
		<p align="center"> Por Favor espere a que el proceso est&eacute; completo.</p>
		<p align="center"> El proceso puede durar varios minutos.</p>
		<cftry>
			<cfinvoke component="sif.Componentes.Contabilidad" method="Cierre_Mes" 
				Ecodigo="#Session.Ecodigo#" 
				debug="false">
			</cfinvoke>		
			
			<cfset showMessage="true">
			<cfcatch type="any">
				<cftransaction action="rollback" />
				<cflock name="LockCierreMes" type="exclusive" timeout="20" throwontimeout="no">
					<cfset application.LockCierreMes = 0>
                    <cfset LvarVerifica = -100>
				</cflock>
				<cfinclude template="../../errorPages/BDerror.cfm"> 
			</cfcatch>
		</cftry>
	</cfif>
</cfif>
<form action="/cfmx/sif/cg/MenuCG.cfm" method="post" name="sql">
	<cfif isdefined("showMessage")>
		<input name="showMessage" type="hidden" value="true">
	</cfif>
	<input name="Pagina" type="hidden" value="<cfif isdefined("Form.Pagina")><cfoutput>#Form.Pagina#</cfoutput></cfif>">
</form>

<cfif LvarVerifica GTE 0>
	<cflock name="LockCierreMes" type="exclusive" timeout="20" throwontimeout="no">
		<cfset application.LockCierreMes = 0>
	</cflock>
</cfif>

<cfif LvarVerifica EQ 200000>
	<p align="center"> No se ha realizado el Cierre de Auxiliares! </p>
	<p align="center"> Procese el cierre de Mes de auxiliares antes de procesar el Cierre de Mes Contable! </p>
<cfelseif LvarVerifica EQ -100>
	<p align="center"> Se produjo un error en el Proceso de cierre de Mes! </p>
	<p align="center"> Verifique por favor los errores en el M&oacute; de Administraci&oacute;n. </p>
<cfelseif LvarVerifica GT 0>
	<p align="center"> Existen <cfoutput>#numberformat(LvarVerifica, ",")#</cfoutput> Asientos Pendientes de Aplicar para el Mes a Cerrar </p>
	<p align="center"> Aplique los Asientos pendientes antes de procesar el Cierre de Mes </p>
<cfelseif LvarVerifica LT 0>
	<p align="center"> Se est&aacute; ejecutando otro proceso de cierre de mes. </p>
	<p align="center"> Espere que el proceso de cierre de mes termine antes de ejecutarlo nuevamente!</p>
	<p align="center"> Hora Actual: <cfoutput> #now()# Hora Cierre Anterior: #application.lockCierreMesHora#</cfoutput></p>
<cfelse>
	<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</cfif>
</body>
</HTML>

<cffunction name="fnVerificaAsientos" access="private" output="no" returntype="numeric">		
	<cfquery name="rs" datasource="#session.dsn#">
		select Pvalor 
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 30
	</cfquery>
	<cfset LvarEPeriodo = rs.Pvalor>
	<cfquery name="rs" datasource="#session.dsn#">
		select Pvalor 
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 40
	</cfquery>
	<cfset LvarEMes = rs.Pvalor>

	<cfquery name="rs" datasource="#session.dsn#">
		select Pvalor 
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 50
	</cfquery>
	<cfset LvarAPeriodo = rs.Pvalor>
	
	<cfquery name="rs" datasource="#session.dsn#">
		select Pvalor 
		from Parametros
		where Ecodigo = #session.Ecodigo#
		  and Pcodigo = 60
	</cfquery>
	<cfset LvarAMes = rs.Pvalor>

	<cfif LvarAMes EQ LvarEmes and LvarAPeriodo EQ LvarEPeriodo>
		<cfreturn 200000>
	</cfif>
	
	<cfquery name="rs" datasource="#session.dsn#">
		select count(1) as Cantidad
		from EContables
		where Ecodigo  = #session.Ecodigo#
		  and Eperiodo = #LvarEPeriodo#
		  and Emes     = #LvarEmes#
                  and ECtipo   <>  1
	</cfquery>
	<cfif rs.Cantidad GT 0>
		<cfreturn rs.Cantidad>
	<cfelse>
		<cfreturn 0>
	</cfif>
</cffunction>
