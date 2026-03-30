<!--- 
	Creado por: Ana Villavicencio 
	Fecha: 09 de agosto del 2006
	Motivo: Nuevo reporte de Documentos de InterÃ©s Moratorio Generados
 --->
<!--- CONSULTA QUE TRAE LOS DATOS DEL REPORTE DEPENDIENDI DEL TIPO DEL REPORTE (RESUMIDO O DETALLADO) --->
<cfquery name="rsReporte" datasource="#session.DSN#">
	select 	distinct m.Mnombre, 
			m.Mcodigo, 
			snd.SNDcodigo,
			snd.SNnombre,
			snd.id_direccion, 
			d.Ddocumento, 
			d.CCTcodigo,
			d.Dfecha,
			d.Dvencimiento,
			d.Dtotal,
			d.Dsaldo,
			d.DEobservacion
			<cfif isdefined('url.TipoReporte') and url.TipoReporte EQ 1>			
			,dd.DocrefIM,
			dd.CCTcodigoIM,
			dd.DDtotal,
			d2.Dfecha as FechaDetalle,
			d2.Dvencimiento as FechaVencDetalle
			</cfif>
	from HDocumentos d
		inner join HDDocumentos dd
			on dd.Ecodigo = d.Ecodigo
			and dd.CCTcodigo = d.CCTcodigo
			and dd.Ddocumento = d.Ddocumento
		  	and dd.DocrefIM is not null
			and dd.CCTcodigoIM is not null

		inner join SNegocios s
			on s.Ecodigo = d.Ecodigo
			and s.SNcodigo = d.SNcodigo
			<cfif isdefined('url.SNnumero') and Len(trim(url.SNnumero)) and not isdefined('url.SNnumero2')>
				and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
			</cfif>
	
			<cfif isdefined('url.SNnumerob2') and Len(trim(url.SNnumerob2)) and not isdefined('url.SNnumero')>
				and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero2#">
			</cfif>
	
			<cfif isdefined('url.SNnumero') and Len(trim(url.SNnumero)) and isdefined('url.SNnumero2') and Len(trim(url.SNnumero2))>
				<cfif url.SNnumero LTE url.SNnumero2>
				   and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
				   and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero2#">
				<cfelse>
				   and s.SNnumero <= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero#">
				   and s.SNnumero >= <cfqueryparam cfsqltype="cf_sql_varchar" value="#url.SNnumero2#">
				</cfif>
			</cfif>
		inner join Monedas m
			on m.Mcodigo = d.Mcodigo

		inner join SNDirecciones snd
			on snd.SNid = s.SNid
			and snd.id_direccion = d.id_direccionFact
		<cfif isdefined('url.TipoReporte') and url.TipoReporte EQ 1>
		inner join HDocumentos d2
			on d2.Ecodigo = dd.Ecodigo
			and d2.CCTcodigo = dd.CCTcodigoIM
			and d2.Ddocumento = dd.DocrefIM
		</cfif>
	where d.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
	  and d.Dfecha between <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaI)#">  
					   and <cfqueryparam cfsqltype="cf_sql_date" value="#lsparsedatetime(url.fechaF)#">
	order by m.Mcodigo, Mnombre, snd.id_direccion

</cfquery>
<!--- VERIFICACION DE LA CANTIDAD DE REGISTROS GENERADOS POR LA CONSULTA --->
<cfif isdefined("rsReporte") and rsReporte.recordcount gt 5000>
	<cf_errorCode	code = "50196" msg = "Se han generado mas de 5000 registros para este reporte.">
	<cfabort>
</cfif>

<!--- VERIFICA EL TIPO DE REPORTE PARA REFERENCIAR EL CFR --->
<cfset nombreReporteJR = "">
<cfif isdefined('url.TipoReporte') and url.TipoReporte EQ 0>
	<cfset reporte = 'DocInteresMoratorioRes.cfr'>
	<cfset nombreReporteJR = "DocInteresMoratorioRes">
<cfelse>
	<cfset reporte = 'DocInteresMoratorioDet.cfr'>
	<cfset nombreReporteJR = "DocInteresMoratorioDet">
</cfif>

<!--- VERIFICA EL FORMATO DEL REPORTE --->
<cfif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 1>
	<cfset formatos = "flashpaper">
<cfelseif isdefined("url.Formato") and len(trim(url.Formato)) and url.Formato EQ 2>
	<cfset formatos = "pdf">
</cfif>

<!--- BUSCA EL NOMBRE DE LA EMPRESA --->
<cfquery name="rsEmpresa" datasource="#session.DSN#">
	select Edescripcion
	from Empresas
	where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
</cfquery>



<!--- LLAMADA AL REPORTE Y ENVIA LOS PARAMETROS --->
<cfquery name="rsactivatejsreports" datasource="#Session.DSN#">
		select Pvalor as valParam
		from Parametros
		where Pcodigo = 20007
		and Ecodigo = #Session.Ecodigo#
	</cfquery>
	<cfset coldfusionV = mid(Server.ColdFusion.ProductVersion, "1", "4")>
    <cfif rsactivatejsreports.valParam EQ 1 AND coldfusionV EQ 2018>
	  <cfset typeRep = 1>
	  <cfif formatos EQ "pdf">
		<cfset typeRep = 2>
	  </cfif>
	  <cf_js_reports_service_tag queryReport = "#rsReporte#" 
		isLink = False 
		typeReport = #typeRep#
		fileName = "cc.reportes.#nombreReporteJR#"/>
	<cfelse>
<cfreport format="#formatos#" template= "#reporte#" query="rsReporte">
	<cfif isdefined("rsEmpresa") and rsEmpresa.recordcount gt 0>
		<cfreportparam name="Empresa" value="#rsEmpresa.Edescripcion#">
	</cfif>
</cfreport>
</cfif>







