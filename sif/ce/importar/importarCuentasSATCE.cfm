<!--- VALIDA QUE EL ARCHIVO A IMPORTAR NO VENGA VACIO --->



<cfquery name="rsCheck1" datasource="#Session.DSN#">
	select count(1) as Cantidad
	from #table_name#
</cfquery>

<cfif isdefined("rsCheck1") and  rsCheck1.Cantidad EQ 0>
	<cfquery name="INS_Error" datasource="#session.DSN#">
		insert into #ERRORES_TEMP# (Mensaje,ErrorNum)
		values('El archivo de importaci&oacute;n no tiene l&iacute;neas',1)
	</cfquery>
</cfif>

<cfquery name="rsNEC" datasource="#session.DSN#">
	select upper(rtrim(ltrim(tem.Clasificacion))) Clasificacion
	from #table_name# tem
	left join CEClasificacionCuentasSAT ts
		on upper(rtrim(ltrim(tem.Clasificacion))) = upper(rtrim(ltrim(ts.Descripcion)))
	where ts.Descripcion is null
</cfquery>

<cfobject component="sif/Componentes/ErrorProceso" name="errorP">
<cfinvoke component="#errorP#" method="delErrors" returnvariable="error">
	<cfinvokeargument name="Spcodigo" value="#Session.menues.SPCODIGO#">
	<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
</cfinvoke>
<cfloop query="rsNEC">
	<cfinvoke component="#errorP#" method="insertErrors" returnvariable="error">
	    <cfinvokeargument name="Spcodigo" value="#Session.menues.SPCODIGO#">
	    <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
	    <cfinvokeargument name="Descripcion" value="La Clasificación #rsNEC.Clasificacion# no existe en el Catálogo Clasificación de Cuentas al SAT">
	    <cfinvokeargument name="Valor" value="#rsNEC.Clasificacion#|#rsNEC.RecordCount#|#rsNEC.CurrentRow#|2">
    </cfinvoke>
</cfloop>


<cfquery name="errores" datasource="#session.dsn#">
	select * from ErrorProceso where Ecodigo = #Session.Ecodigo# and Spcodigo = '#Session.menues.SPCODIGO#' and Usucodigo = #session.Usucodigo#
</cfquery>

<cfif #errores.RecordCount# neq 0>
	<cfoutput>
		<script type="text/javascript">
			location.replace ( "../../sif/ce/importar/importar-status.cfm" );
	    </script>
    </cfoutput>
<cfelse>

	<cfquery name="numColUpd" datasource="#Session.DSN#">
	select tem.CCuentaSAT, tem.NombreCuenta, tem.Clasificacion from #table_name# tem, CECuentasSAT cec where tem.CCuentaSAT=cec.CCuentaSAT and cec.CAgrupador='#session.CAgrupador#'
	</cfquery>

	<cfloop query="numColUpd">
		<cfquery name="updBan" datasource="#Session.DSN#">
		  UPDATE CECuentasSAT SET NombreCuenta='#numColUpd.NombreCuenta#', Clasificacion='#replace(numColUpd.Clasificacion,'"','','ALL')#', UsucodigoModifica=#session.Usucodigo#, FechaModificacion=SYSDATETIME() WHERE CCuentaSAT='#numColUpd.CCuentaSAT#' AND CAgrupador='#session.CAgrupador#'
		</cfquery>
	</cfloop>

	<cfquery name="numColIns" datasource="#Session.DSN#">
		SELECT temIn.CCuentaSAT FROM #table_name# temIn
		EXCEPT
		SELECT tem.CCuentaSAT FROM #table_name# tem, CECuentasSAT cec WHERE tem.CCuentaSAT=cec.CCuentaSAT AND cec.CAgrupador='#session.CAgrupador#'
	</cfquery>

	<cfloop query="numColIns">
		<cfquery name="datIns" datasource="#Session.DSN#">
			SELECT * FROM #table_name# WHERE CCuentaSAT='#numColIns.CCuentaSAT#'
		</cfquery>
		<cfquery name="temDat" datasource="#Session.DSN#">
	       INSERT INTO CECuentasSAT(CCuentaSAT, CAgrupador,NombreCuenta,Clasificacion,Ecodigo,BMUsucodigo,FechaGeneracion)
	       VALUES('#datIns.CCuentaSAT#','#session.CAgrupador#',
	       '#replace(datIns.NombreCuenta,'"','','ALL')#','#datIns.Clasificacion#',
	       (select Ecodigo from CEAgrupadorCuentasSAT where CAgrupador = <cfqueryparam cfsqltype="cf_sql_varchar" value="#session.CAgrupador#">),
	       #session.Usucodigo#,SYSDATETIME())
		</cfquery>

	</cfloop>

	<cflock timeout=20 scope="Session" type="Exclusive">
	    <cfset StructDelete(session, "CAgrupador")>
	</cflock>
</cfif>


