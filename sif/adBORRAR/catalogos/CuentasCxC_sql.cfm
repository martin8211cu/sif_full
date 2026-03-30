<cfset params = "">
<cfif isdefined("form.CFcuenta") and  len(trim(Form.CFcuenta)) EQ 0 and not isdefined('form.NUEVO') and not isdefined("form.BAJA")>
    <cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('La cuenta Cuenta Finaciera es Invalida. Proceso Cancelado!')#" addtoken="no">
<cfelseif not isdefined("form.CFcuenta") and isdefined("form.CBid")>
    <cfquery name="rsCBcuenta" datasource="#session.DSN#">
        select Ccuenta 
        from CuentasBancos  
        where CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#">
    </cfquery>
    
    <cfquery name="rsCFcuenta" datasource="#session.dsn#">
        select min(CFcuenta) as CFcuenta
        from CFinanciera
        where Ccuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#rsCBcuenta.Ccuenta#">
    </cfquery>
    <cfset form.CFcuenta = rsCFcuenta.CFcuenta>
</cfif>

<!---AGREGAR--->
<cfif isdefined("Form.Alta")>
	<cftransaction>
		<cfquery name="rsinsert" datasource="#Session.DSN#">
			insert into CuentasCxC 
				(Ecodigo, CodigoCatalogoCxC, Descripcion_Cuenta, CFcuenta, Usucodigo, Fecha, CBid)
			values (
				 <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">,
				 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CodigoCatalogoCxC#">, 
				 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DescripcionCuenta#">, 
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">, 
				 <cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Usucodigo#">, 
				 <cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
                 <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#" null="#len(form.CBid) eq 0#">
				 )
			<cf_dbidentity1 datasource="#session.DSN#">
		</cfquery>
			<cf_dbidentity2 datasource="#session.DSN#" name="rsinsert">		
	</cftransaction>
<!---ELIMINAR--->
<cfelseif isdefined("Form.Baja")>
	<cfquery datasource="#Session.DSN#">
		Delete from CuentasCxC 
			where Ecodigo = #Session.Ecodigo#
			and CodigoCatalogoCxC =  <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CodigoCatalogoCxC#">
	</cfquery>
<!---CAMBIAR--->
<cfelseif isdefined("Form.Cambio")>
	<cfif len(trim(Form.CFcuenta)) EQ 0>
		<cfif len(trim(Form.CFcuentaAnterior)) NEQ 0>
			<cfset Form.CFcuenta = Form.CFcuentaAnterior>
		<cfelse>
			<cflocation url="../../errorPages/BDerror.cfm?errType=0&errMsg=#URLEncodedFormat('La cuenta Cuenta Finaciera es Invalida. Proceso Cancelado!')#" addtoken="no">
		</cfif>
	</cfif>
	<cfquery datasource="#Session.DSN#">
		update CuentasCxC
		set Descripcion_Cuenta = <cfqueryparam cfsqltype="cf_sql_char" value="#Form.DescripcionCuenta#">,
		CFcuenta = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Form.CFcuenta#">,
        CBid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CBid#" null="#len(form.CBid) eq 0#">
		where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
		and CodigoCatalogoCxC =  <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CodigoCatalogoCxC#">
	</cfquery>
	<cfquery name="rsupdate" datasource="#Session.DSN#">
		select ID, CBid from CuentasCxC 		
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			and CodigoCatalogoCxC =  <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CodigoCatalogoCxC#">
	</cfquery>
	<cfset params="ID="&rsupdate.ID&"&CBid="&rsupdate.CBid>
</cfif>
<cfif isdefined("form.CBid") and len(trim(form.CBid))>
	<cflocation url="/cfmx/sif/cc/catalogos/CuentaBancos.cfm?#params#">
<cfelse>
	<cflocation url="CuentasCxC.cfm?#params#">
</cfif>
