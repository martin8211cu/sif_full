<!--- 
	* Carga para el usuario en session los id's de Solicitante y Comprador, 
	* lo hace solamente si estan definidos para el usuario y este proceso 
	* se ejecuta cada vez que el usuario ingresa por primer vez a una empresa.
	* Crea la variables de session EcodigoAnterior, session.Compras.solicitante y
	* session.Compras.comprador. Las dos ultimas las crea solo si el usuario esta 
	* definido como solicitante o comprador.

	* Modificado por: Rodolfo Jiménez Jara  23 de Junio 2005 
	* Motivo: Cambio de seguridad, por si el solicitante está activo o no
--->

<!--- Solicitudes de Compra  --->
<cfif not isdefined("session.EcodigoAnterior")>
	<cfset session.EcodigoAnterior = '' >
</cfif>
<!--- Verifica datos de comprador --->
<cfif session.Ecodigo neq session.EcodigoAnterior >
	<cfset session.EcodigoAnterior = session.Ecodigo >

	<!--- Componente de Seguridad --->
	<cfinvoke component="home.Componentes.Seguridad" method="init" returnvariable="sec">
	<cfset _solicitante = sec.getUsuarioByCod (session.Usucodigo, session.EcodigoSDC, 'CMSolicitantes')>
	<cfif _solicitante.recordCount gt 0 and len(trim(_solicitante.llave))>
		
		<!--- Recupera si el solicitante está activo o no --->
		<cfquery name="rsCMSolicitantes" datasource="#session.DSN#">
			select CMSestado
			from CMSolicitantes
			where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
			  and CMSid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#_solicitante.llave#">
			  and CMSestado = 1
		</cfquery>
		<cfif rsCMSolicitantes.recordCount gt 0 and len(trim(rsCMSolicitantes.CMSestado))>
			<cfset session.Compras.solicitante = _solicitante.llave >
		<cfelse>
			<cfset session.Compras.solicitante = '' >
		</cfif>
	<cfelse>
		<cfset session.Compras.solicitante = '' >
	</cfif>

	<cfset _comprador = sec.getUsuarioByCod (session.Usucodigo, session.EcodigoSDC, 'CMCompradores')>
	<cfif _comprador.recordCount gt 0 and len(trim(_comprador.llave))>
		<cfset session.Compras.comprador = _comprador.llave >
	<cfelse>
		<cfset session.Compras.comprador = '' >
	</cfif>
	
	<!--- Recupera el nivel maximo de clasificaciones de articulos --->
	<cfquery name="data1" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo=530
	</cfquery>
	<cfif data1.recordCount gt 0 and len(trim(data1.Pvalor))>
		<cfset session.compras.NivelMaxA = data1.Pvalor >
	<cfelse>
		<cfset session.compras.NivelMaxA = 1 >
	</cfif>

	<!--- Recupera el nivel maximo de clasificaciones de servicios --->
	<cfquery name="data2" datasource="#session.DSN#">
		select Pvalor
		from Parametros
		where Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Ecodigo#">
		and Pcodigo=540
	</cfquery>
	<cfif data2.recordCount gt 0 and len(trim(data2.Pvalor))>
		<cfset session.compras.NivelMaxS = data2.Pvalor >
	<cfelse>
		<cfset session.compras.NivelMaxS = 1 >
	</cfif>
	
</cfif>