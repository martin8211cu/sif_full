<!---************************ --->
<!---** AREA DE VARIABLES  ** --->
<!---************************ --->
<cfset modo = "ALTA">
<!---*********************************** --->
<!---** VARIFICACION DE CAMPOS Y ABC  ** --->
<!---*********************************** --->
<cfif not isdefined("form.Nuevo")>
	<cftry>
	<cfquery datasource="#session.Fondos.dsn#"  name="sql" >	
		set nocount on	
<!---******************************************************************************************* --->
<!---** 											ALTA 									  ** --->
<!---******************************************************************************************* --->
		<cfif isdefined("form.Alta") >
        	INSERT CJP002(CJM00COD,CJP02IMP,CJP02ORD)
			VALUES (
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CJM00COD#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CJP02IMP#" >,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CJP02ORD#" >
			)				
<!---******************************************************************************************* --->
<!---** 											CAMBIO 									  ** --->
<!---******************************************************************************************* --->
		<cfelseif isdefined("form.Cambio")>
			UPDATE CJP002 SET 
			CJP02IMP =	<cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CJP02IMP#" >,
			CJP02ORD =	<cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.CJP02ORD#" >
			WHERE CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CJM00COD#" >	
			  AND   timestamp = convert(varbinary,#lcase(Form.timestamp)#)
			<cfset modo = "CAMBIO">
<!---******************************************************************************************* --->
<!---** 											BAJA 									  ** --->
<!---******************************************************************************************* --->
		<cfelseif isdefined("form.Baja")>
			DELETE CJP002 
			WHERE CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.CJM00COD#" >	
			  AND   timestamp = convert(varbinary,#lcase(Form.timestamp)#)
	    </cfif>	
<!---******************************************************************************************* --->
<!---** 											BAJA RELACION							  ** --->
<!---******************************************************************************************* --->
	set nocount off
	</cfquery>
	<cfcatch type="any">
				
 		<script language="JavaScript">
		   var  mensaje = "<cfoutput>#trim(cfcatch.Detail)#</cfoutput>"
		   mensaje = mensaje.substring(40,300)
		   alert(mensaje)
		   history.back()
		</script> 		
		<cfabort>
		
	</cfcatch>
	</cftry>	
<!---******************************************************************************************* --->	
<cfelse>
	<cflocation url="../catalogos/cjc_ParamGlobal.cfm?modo=#modo#">
</cfif>
<!---************************ --->
<!---** STATUS DE RETORNO  ** --->
<!---************************ --->
<cfif modo eq "CAMBIO">
	<cflocation url="../catalogos/cjc_ParamGlobal.cfm?modo=#modo#&CJM00COD=#form.CJM00COD#">
<cfelse>
	<cflocation url="../catalogos/cjc_ParamGlobal.cfm?modo=#modo#">
</cfif>


 
