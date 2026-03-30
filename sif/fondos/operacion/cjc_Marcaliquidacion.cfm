<!--- Verificar si la transaccion esta en S o en N para realizar la opracion contraria --->
<cfquery datasource="#session.Fondos.dsn#" name="rs">
Select CJX04IND
from CJX004
WHERE CJM00COD ='#CJM00COD#' 
  AND CJX04NUM =#CJX04NUM#
</cfquery>

<cfif rs.CJX04IND eq "S">
	<cfset valor = "N">
	<cfset usrmk = "">
<cfelse>
	<cfset valor = "S">
	<cfset usrmk = #session.usuario#>
</cfif>

<cftransaction>
<cftry>
	<cfquery datasource="#session.Fondos.dsn#" name="valida">
		Select count(1) as recibido
		from CJX004
		where CJM00COD ='#CJM00COD#' 
  		  and CJX04NUM =#CJX04NUM#
  		  and (CJX04RED is NOT null or CJX04URE is NOT null)
	</cfquery>
	<cfif valida.recibido gt 0>
		<cfquery datasource="#session.Fondos.dsn#">
			Update CJX004
			set CJX04IND = <cfqueryparam cfsqltype="cf_sql_varchar" value="#valor#">,
				CJX04UMK = <cfqueryparam cfsqltype="cf_sql_varchar" value="#usrmk#">
			WHERE CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CJM00COD#"> 
		  	AND CJX04NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#CJX04NUM#">
		</cfquery>
	<cfelse>
			<cfquery datasource="#session.Fondos.dsn#">
				Update CJX004
				set CJX04IND = 'N'	
				WHERE CJM00COD = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CJM00COD#"> 
		  		AND CJX04NUM = <cfqueryparam cfsqltype="cf_sql_integer" value="#CJX04NUM#">
			</cfquery>
			<script language="JavaScript">
				alert("No es posible seleecionar el documento, ya que el mismo no ha sido recibido");
				parent.form2.DCM['<cfoutput>#URL.indice#</cfoutput>'].checked=false;
			</script>
			<cfabort>
	</cfif>
	
	<cfcatch type="any">
		<cftransaction action="rollback"/>
		<script language="JavaScript">
			var  mensaje = new String("<cfoutput>#trim(cfcatch.Detail)#</cfoutput>");
			mensaje = mensaje.substring(40,300)
			alert(mensaje)
			history.back()
		</script>
		<cfabort>
	</cfcatch>

</cftry>
<cftransaction action="commit"/>
</cftransaction>
