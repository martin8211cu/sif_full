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

<cfquery name="datos" datasource="#Session.DSN#">
	select * from #table_name#
</cfquery>
<!--- <cf_dump var="#table_name#"> --->
<!---cfquery datasource="#session.dsn#">
	Delete From ErrorProceso Where Ecodigo = #Session.Ecodigo# and Spcodigo = '#Session.menues.SPCODIGO#' and Usucodigo = #session.Usucodigo#
</cfquery--->
<cfobject component="sif/Componentes/ErrorProceso" name="errorP">
<cfinvoke component="#errorP#" method="delErrors" returnvariable="error">
	<cfinvokeargument name="Spcodigo" value="#Session.menues.SPCODIGO#">
	<cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
</cfinvoke>

<cfloop query="datos" >
	<cfset formatoCuenta = JavaCast("string",#datos.Formato#)>
	<cfset formatoCuenta = replacenocase(#formatoCuenta#,chr(32),'','ALL')>
	<cfset formatoCuenta = replacenocase(#formatoCuenta#,chr(160),'','ALL')>

	<cfquery name="verificaCuenta" datasource="#Session.DSN#">
		select CCuentaSAT
		from CECuentasSAT
		where CAgrupador = #Session.CAgrupador#
		and (Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> or Ecodigo is null )
		and Ltrim(Rtrim(CCuentaSAT)) = '#trim(datos.Agrupador)#'
	</cfquery>

	<cfquery name="verificaFormato" datasource="#Session.DSN#">
		select *
		from CContables
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
		and Cformato = '#trim(formatoCuenta)#'
	</cfquery>

	<cfif #verificaCuenta.RecordCount# eq 0>
		<!---cfquery datasource="#session.dsn#">
			Insert Into ErrorProceso(Valor,Descripcion,Ecodigo,Spcodigo,Usucodigo)
			Values('#datos.Agrupador#|#datos.RecordCount#|#datos.CurrentRow#|1','La cuenta sat no se encontró dentro de las ya registradas',#Session.Ecodigo#,'#Session.menues.SPCODIGO#',#session.Usucodigo#)
		</cfquery--->
		<cfinvoke component="#errorP#" method="insertErrors" returnvariable="error">
	        <cfinvokeargument name="Spcodigo" value="#Session.menues.SPCODIGO#">
	        <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
	        <cfinvokeargument name="Descripcion" value="La cuenta SAT no se encontró dentro de las cuentas del Mapeo. Favor de verificar">
	        <cfinvokeargument name="Valor" value="#datos.Agrupador#|#datos.RecordCount#|#datos.CurrentRow#|1">
        </cfinvoke>
	</cfif>
	<cfif #verificaFormato.RecordCount# eq 0>
		<!---cfquery datasource="#session.dsn#">
			Insert Into ErrorProceso(Valor,Descripcion,Ecodigo,Spcodigo,Usucodigo)
			Values('#datos.Formato#|#datos.RecordCount#|#datos.CurrentRow#|2','La cuenta no se encontró dentro de las ya registradas',#Session.Ecodigo#,'#Session.menues.SPCODIGO#',#session.Usucodigo#)
		</cfquery--->
		<cfinvoke component="#errorP#" method="insertErrors" returnvariable="error">
	        <cfinvokeargument name="Spcodigo" value="#Session.menues.SPCODIGO#">
	        <cfinvokeargument name="Ecodigo" value="#Session.Ecodigo#">
	        <cfinvokeargument name="Descripcion" value="La cuenta no se encontró dentro de las cuentas de la Empresa. Favor de verificar">
	        <cfinvokeargument name="Valor" value="#datos.Formato#|#datos.RecordCount#|#datos.CurrentRow#|2">
        </cfinvoke>
	</cfif>
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
	<cfquery name="datosalta" datasource="#Session.DSN#">
		SELECT Agrupador,Formato FROM #table_name#
    </cfquery>
	<cfloop query="datosalta">
		<cfset formatoCuenta = JavaCast("string",#datosalta.Formato#)>
        <cfset formatoCuenta = replacenocase(#formatoCuenta#,chr(32),'','ALL')>
        <cfset formatoCuenta = replacenocase(#formatoCuenta#,chr(160),'','ALL')>
		<cfquery name="cleve" datasource="#Session.DSN#">
			SELECT Ccuenta
	        FROM CContables
	        WHERE Cformato=<cfqueryparam cfsqltype="CF_SQL_CHAR" value="#formatoCuenta#">
	        	and Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#">
	    </cfquery >

        <cfif #cleve.RecordCount# GT 0>
			<cfquery name="existe" datasource="#Session.DSN#">
				select * from CEMapeoSAT where Ccuenta=#cleve.Ccuenta# and CAgrupador=#Session.CAgrupador# and Ecodigo = #Session.Ecodigo#
	        </cfquery>

	        <cfset agrupadorCuenta = JavaCast("string",#datosalta.Agrupador#)>
	        <cfset agrupadorCuenta = replacenocase(#agrupadorCuenta#,chr(32),'','ALL')>
	        <cfset agrupadorCuenta = replacenocase(#agrupadorCuenta#,chr(160),'','ALL')>
	        <cfif #existe.RecordCount# EQ 0>
		        <cfquery datasource="#Session.DSN#">
			        INSERT INTO CEMapeoSAT(CCuentaSAT, CAgrupador, Ccuenta, Ecodigo, BMUsucodigo, FechaGeneracion)
                    VALUES(#agrupadorCuenta#, '#Session.CAgrupador#', #cleve.Ccuenta#, #Session.Ecodigo#, #session.Usucodigo#, SYSDATETIME())
	            </cfquery>
	    	<cfelse>
	            <cfquery datasource="#Session.DSN#">
		            UPDATE CEMapeoSAT SET CCuentaSAT = #agrupadorCuenta#  , UsucodigoModifica= #session.Usucodigo# ,FechaModificacion= SYSDATETIME()
		            WHERE CAgrupador = '#Session.CAgrupador#' AND Ccuenta= #cleve.Ccuenta# and Ecodigo = #Session.Ecodigo#
	            </cfquery>
	        </cfif>
        </cfif>
    </cfloop>
    <cflock timeout=20 scope="Session" type="Exclusive">
		<cfset StructDelete(session, "CAgrupador")>
    </cflock>
</cfif>








