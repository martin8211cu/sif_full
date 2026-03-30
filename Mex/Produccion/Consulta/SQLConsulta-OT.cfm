<cfif isDefined("Form.Aceptar")>
	<cfquery name="rsProdOTDatos" datasource="#Session.DSN#">
        select p.OTcodigo,a.APDescripcion,p.OTseq, p.Artid,Pentrada,Psalida,Pmerma 
        from Prod_Inventario p
        inner join Prod_Proceso c on c.Ecodigo=p.Ecodigo and p.OTcodigo=c.OTcodigo and p.OTseq=c.OTseq
        inner join Prod_Area a on p.Ecodigo=a.Ecodigo and c.APcodigo=a.APcodigo
        inner join Prod_insumo i on i.Ecodigo=p.Ecodigo and i.Artid=p.Artid
        where p.Ecodigo=<cfqueryparam cfsqltype="cf_sql_numeric" value="#Session.Ecodigo#"> and
        	  p.OTcodigo=<cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.OTcodigo#"> and
              i.MPseguimiento=1
        order by p.OTcodigo,p.OTseq
    </cfquery>
    <table>
        <tr>
            <td>#rsProdOTDatos.OTcodigo#</td>
        </tr>
    </table>
	<!--- Inserta un registro en la tabla de Parámetros 
	<cffunction name="insertCuenta" >		
		<cfargument name="pcodigo"      type="numeric" required="true">
		<cfargument name="mcodigo"      type="string" required="true">
		<cfargument name="pdescripcion" type="string" required="true">
		<cfargument name="pvalor"       type="string" required="true">			
		
		<cfquery name="rsParamRev" datasource="#Session.DSN#">
			select 1 
			from Parametros 
			where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
			 and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">		
		</cfquery>
		
		<cfif isdefined('rsParamRev') and rsParamRev.recordCount EQ 0>
			<cfquery datasource="#Session.DSN#">
				insert INTO Parametros (Ecodigo, Pcodigo, Mcodigo, Pdescripcion, Pvalor)
				values (
					<cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.mcodigo)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pdescripcion)#">, 
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#"> 
					)
			</cfquery>
		<cfelse>
			<cfquery datasource="#Session.DSN#">
				update Parametros 
					set Pvalor = <cfqueryparam cfsqltype="cf_sql_varchar" value="#Trim(Arguments.pvalor)#">
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Session.Ecodigo#">
				  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">			
			</cfquery>				
		</cfif>

		<cfreturn true>
	</cffunction>
    
	<cftransaction>
	<cftry>		

	<!--- 1150. Agregar Empresa de Eliminación --->	
	<cfset b = insertCuenta(1150,'PR','Orden de trabajo por solicitud de compra',#form.APinterno#)>					
			
					
    
	<cfcatch type="database">
		<cfinclude template="../sif/errorPages/BDerror.cfm">
		<cfabort>
	</cfcatch>
	</cftry>
	</cftransaction>--->
    
</cfif>

<!---<form action="Consulta-OT.cfm" method="post" name="sql">
</form>
--->
<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>
