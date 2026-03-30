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

<cfquery name="numColUpd" datasource="#Session.DSN#">
select tem.Clave, tem.Nombre_Corto, tem.Nombre from #table_name# tem, CEBancos ceb where tem.Clave=ceb.Clave
</cfquery>

<cfloop query="numColUpd">
	<cfquery name="updBan" datasource="#Session.DSN#">
	  UPDATE CEBancos SET Nombre_Corto='#numColUpd.Nombre_Corto#', Nombre='#replace(numColUpd.Nombre,'"','','ALL')#', UsucodigoModifica=#session.Usucodigo#, FechaModificacion=SYSDATETIME() WHERE Clave=#numColUpd.Clave#
	</cfquery>
</cfloop>


<cfquery name="numColIns" datasource="#Session.DSN#">
	SELECT temIn.Clave FROM #table_name# temIn
	EXCEPT
	SELECT tem.Clave FROM #table_name# tem, CEBancos ceb WHERE tem.Clave=ceb.Clave
</cfquery>

<cfloop query="numColIns">
	<cfquery name="datIns" datasource="#Session.DSN#">
		SELECT * FROM #table_name# WHERE Clave=#numColIns.Clave#
	</cfquery>
	<cfquery name="temDat" datasource="#Session.DSN#">
       INSERT INTO CEBancos(Clave,Nombre_Corto,Nombre,BMUsucodigo,FechaGeneracion)
       VALUES(RIGHT('000' + Ltrim(Rtrim('#datIns.Clave#')),3),'#datIns.Nombre_Corto#','#replace(datIns.Nombre,'"','','ALL')#',#session.Usucodigo#,SYSDATETIME())
	</cfquery>

</cfloop>
