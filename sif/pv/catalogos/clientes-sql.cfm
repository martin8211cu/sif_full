<cfset params="">

<cfif IsDefined("form.Cambio")>
	<cf_dbtimestamp datasource="#session.dsn#"
		table="ClientesDetallistasCorp"
		redirect="clientes.cfm"
		timestamp="#form.ts_rversion#"
			
		field1="CDCcodigo"
		type1="numeric"
		value1="#form.CDCcodigo#" >
	
	<cfquery name="update" datasource="#session.DSN#">
		update ClientesDetallistasCorp  set
                CDCidentificacion = <cfqueryparam value="#Form.CDCidentificacion #" cfsqltype="cf_sql_char">,
                CDCtipo 		  = <cfqueryparam value="#Form.CDCtipo#" cfsqltype="cf_sql_char">,
                CDCnombre 		  = <cfqueryparam value="#Form.CDCnombre#" cfsqltype="cf_sql_varchar">,
			<cfif isdefined('form.CDCdireccion') and form.CDCdireccion NEQ ''>
				CDCdireccion 	  = <cfqueryparam value="#Form.CDCdireccion#" cfsqltype="cf_sql_varchar">,
			<cfelse>
				CDCdireccion      = null,
			</cfif>
			<cfif isdefined('form.Pais') and form.Pais NEQ ''>
				Ppais 			 = <cfqueryparam value="#Form.Pais#" cfsqltype="cf_sql_varchar">,
			<cfelse>
				Ppais 			 = null,
			</cfif>
			<cfif isdefined('form.CDCfechanac') and form.CDCfechanac NEQ ''>
				CDCfechaNac 	 = <cfqueryparam value="#LSParseDateTime(Form.CDCfechanac)#" cfsqltype="cf_sql_timestamp">,
			<cfelse>
				CDCfechaNac 	 = null,
			</cfif>
			<cfif isdefined('form.CDCtelefono') and form.CDCtelefono NEQ ''>
				CDCtelefono 	= <cfqueryparam value="#Form.CDCtelefono#" cfsqltype="cf_sql_varchar">,
			<cfelse>
				CDCtelefono 	= null,
			</cfif>
			<cfif isdefined('form.CDCFax') and form.CDCFax NEQ ''>
				CDCFax 			= <cfqueryparam value="#Form.CDCFax#" cfsqltype="cf_sql_varchar">,
			<cfelse>
				CDCFax 			= null,
			</cfif>
				CDCporcdesc 	= <cfqueryparam value="#Form.CDCporcdesc#" cfsqltype="cf_sql_money">,
				CDCExentoImp 	= <cfif isdefined('form.CDCExentoImp')> 1, <cfelse> 0, </cfif>
			<cfif isdefined('form.CDCemail') and form.CDCemail NEQ ''>
				CDCemail 		= <cfqueryparam value="#Form.CDCemail#" cfsqltype="cf_sql_varchar">,
			<cfelse>
				CDCemail 		= null,
			</cfif>
			<cfif isdefined('form.LOCidioma') and form.LOCidioma NEQ ''>
			    LOCidioma 		= <cfqueryparam value="#Form.LOCidioma#" cfsqltype="cf_sql_char">,
			<cfelse>
				LOCidioma 		= null,
			</cfif>
				BMUsucodigo		= <cfqueryparam value="#session.Usucodigo#" cfsqltype = "cf_sql_numeric">,
                SNMid 			= <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Form.SNMid#" 		voidnull>
				
			where CEcodigo = <cfqueryparam value="#session.CEcodigo#" cfsqltype = "cf_sql_numeric"> 
			and CDCcodigo = <cfqueryparam value="#Form.CDCcodigo#" cfsqltype = "cf_sql_numeric">
    </cfquery>
		
<cfelseif IsDefined("form.Baja")>
	
    <cfquery name="FACSnegocios" datasource="#session.dsn#">
    	select count(1) Cantidad 
        	from FACSnegocios
        where CDCcodigo = <cfqueryparam cfsqltype= "cf_sql_numeric"  value="#Form.CDCcodigo#">
    </cfquery>
    <cfif FACSnegocios.Cantidad  GT 0>
    	<cfthrow message="El clientes detallistas corporativos que desea eliminar posee clientes de crédito asociados.">
    </cfif>
    <cfquery datasource="#session.dsn#">
		delete from ClientesDetallistasCorp
		where CEcodigo  = <cfqueryparam cfsqltype = "cf_sql_numeric" value="#session.CEcodigo#" > 
		  and CDCcodigo = <cfqueryparam cfsqltype= "cf_sql_numeric"  value="#Form.CDCcodigo#">
	</cfquery>

<cfelseif IsDefined("form.Alta")>
	<cfquery datasource="#session.dsn#" name="rsInsert">
		insert into ClientesDetallistasCorp(CEcodigo,CDCidentificacion, CDCtipo, CDCnombre,  CDCdireccion, 
			Ppais,CDCfechaNac, CDCtelefono, CDCFax, CDCporcdesc, CDCExentoImp, CDCemail, LOCidioma,  CDCfecha, BMUsucodigo,SNMid)
			values(	<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">,
			<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CDCidentificacion#">,
			<cfqueryparam cfsqltype= "cf_sql_char" value="#form.CDCtipo#">,
			<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.CDCnombre#">,
			<cfif isdefined('form.CDCdireccion') and form.CDCdireccion NEQ ''>
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.CDCdireccion#">,
			<cfelse>
				null,
			</cfif>	
			<cfif isdefined('form.Ppais') and form.Ppais NEQ ''>
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.Ppais#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined('form.CDCfechanac') and form.CDCfechanac NEQ ''>
				<cfqueryparam cfsqltype="cf_sql_timestamp" value="#form.CDCfechanac#">,
			<cfelse>
				null,
			</cfif>				
			<cfif isdefined('form.CDCtelefono') and form.CDCtelefono NEQ ''>
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.CDCtelefono#">,
			<cfelse>
				null,
			</cfif>
			<cfif isdefined('form.CDCFax') and form.CDCFax NEQ ''>
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.CDCFax#">,
			<cfelse>
				null,
			</cfif>				
			<cfqueryparam cfsqltype= "cf_sql_money" value="#form.CDCporcdesc#">,
			<cfif isdefined('form.CDCExentoImp')>
				1,
			<cfelse>
				0,
			</cfif>
			<cfif isdefined('form.CDCemail') and form.CDCemail NEQ ''>
				<cfqueryparam cfsqltype= "cf_sql_varchar" value="#form.CDCemail#">,
			<cfelse>
				null,
			</cfif>	
			<cfif isdefined('form.LOCidioma') and form.LOCidioma NEQ ''>
				<cfqueryparam cfsqltype= "cf_sql_char" value="#form.LOCidioma#">,
			<cfelse>
				null,
			</cfif>	
			<cfqueryparam cfsqltype="cf_sql_timestamp" value="#now()#">,
			<cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">,
            <cf_jdbcquery_param cfsqltype="cf_sql_numeric" 	value="#Form.SNMid#" voidnull>)
    	<cf_dbidentity1>
    </cfquery>
		<cf_dbidentity2 name="rsInsert">
</cfif>


<form action="clientes.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio')>
			<input name="CDCcodigo" type="hidden" value="#form.CDCcodigo#"> 	
		</cfif>
        <cfif isdefined('form.Alta')>
			<input name="CDCcodigo" type="hidden" value="#rsInsert.identity#"> 	
		</cfif>

		<cfif isdefined('form.CDCidentificacion_F') and len(trim(form.CDCidentificacion_F))>
			<input type="hidden" name="CDCidentificacion_F" value="#form.CDCidentificacion_F#">	
		</cfif>
		<cfif isdefined('form.CDCnombre_F') and len(trim(form.CDCnombre_F))>
			<input type="hidden" name="CDCnombre_F" value="#form.CDCnombre_F#">	
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