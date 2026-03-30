<!---
	Catalogo de Status de las tarjetas de credito
	Creado por Hector Garcia Beita
	Fecha: 22/07/2011
--->

 <cfif IsDefined("form.StatusTC")>
	<cfset reqRef=1>
<cfelse>
	<cfset reqRef=0>
</cfif>
 
<!---UPDATE--->
<cfif IsDefined("form.Cambio")>
<cftransaction>
		<cf_dbtimestamp
			datasource="#session.dsn#"
			table="CBStatusTarjetaCredito" 
			redirect="TCEStatusTarjetas.cfm"
			timestamp="#form.ts_rversion#"
			field1="CBSTid" 
			type1="numeric" 
			value1="#form.CBSTid#">
	
	<cfquery name="checkAvailable" datasource="#session.dsn#">
    select count(1) as Total from CBStatusTarjetaCredito
    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
	  and CBSTcodigo = <cfqueryparam value="#Form.CodigoTarjeta#" cfsqltype="cf_sql_varchar">
      and CBSTid <> <cfqueryparam value="#form.CBSTid#" cfsqltype="cf_sql_numeric">
    </cfquery>
	<cfif checkAvailable.Total eq 0>
        <cfquery name="update" datasource="#session.DSN#">
          update CBStatusTarjetaCredito	
          set  CBSTcodigo = <cfqueryparam value="#form.CodigoTarjeta#" cfsqltype="cf_sql_varchar">
              ,CBSTDescripcion = <cfqueryparam value="#Form.Descripcion#" cfsqltype="cf_sql_varchar">
              ,BMUsucodigo= <cfqueryparam value="#session.Usucodigo#" cfsqltype="cf_sql_numeric">
              ,CBSTActiva = #reqRef#
          where CBSTid = <cfqueryparam value="#form.CBSTid#" cfsqltype="cf_sql_numeric">
        </cfquery> 
	<cfelse>
		<cfthrow message="El codigo: #Form.CodigoTarjeta#, ya se encuentra en uso">        
	</cfif>
</cftransaction>
    	
<!---DELETE--->
<cfelseif IsDefined("form.Baja")>

    <cfquery datasource="#session.dsn#" name="checkST">
        Select count(1) as Total
        from CBTarjetaCredito
        where CBSTid = <cfqueryparam value="#Form.CBSTid#" cfsqltype="cf_sql_numeric">
	</cfquery>
    
	<cfif checkST.Total eq 0>
    
        <cfquery datasource="#session.dsn#">
             delete from CBStatusTarjetaCredito
             where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
             and CBSTid = <cfqueryparam value="#Form.CBSTid#" cfsqltype="cf_sql_numeric">
        </cfquery>
    
    <cfelse>
	    <cfthrow message="No es posible eliminar el Status, porque está siendo utilizado">
    </cfif>    
    
 <!---INSERT--->
<cfelseif IsDefined("form.Alta")>
	<cfquery name="checkAvailable" datasource="#session.dsn#">
    select count(1) as Total from CBStatusTarjetaCredito
    where Ecodigo = <cfqueryparam value="#session.Ecodigo#" cfsqltype = "cf_sql_integer"> 
		and CBSTcodigo = <cfqueryparam value="#Form.CodigoTarjeta#" cfsqltype="cf_sql_varchar">
    </cfquery>
	<cfif checkAvailable.Total eq 0>
      <cfquery datasource="#session.dsn#">
          insert into CBStatusTarjetaCredito(CBSTcodigo, CBSTDescripcion, CBSTActiva, Ecodigo, BMUsucodigo)
          values(	
                   <cfqueryparam cfsqltype="cf_sql_varchar"  value="#form.CodigoTarjeta#">,
                   <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.Descripcion#">,
                   #reqRef#,
                   <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">,
                   <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.Usucodigo#">)
      </cfquery>
     <cfelse>
     	<cfthrow message="El codigo: #Form.CodigoTarjeta#, ya se encuentra en uso">
     </cfif>
  </cfif>

 <form action="TCEStatusTarjetas.cfm" method="post" name="sql">
	<cfoutput>
		<cfif isdefined('form.Cambio') and not isdefined('form.Alta') and not isdefined('form.Baja')>
			<input name="CodigoTarjeta" type="hidden" value="#form.CodigoTarjeta#"> 
		</cfif>
				
		<cfif isdefined('form.Descripcion_U') and len(trim(form.Descripcion_U))>
			<input type="hidden" name="Descripcion_U" value="#form.Descripcion_U#">	
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
