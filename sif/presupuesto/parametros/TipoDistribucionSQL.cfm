<cfset modo = "ALTA">
	<cfif not isdefined("Form.Nuevo")>
		<cfif isdefined("Form.Alta")>
			<cfquery name="insert" datasource="#Session.DSN#">
				insert into CPDistribucionCostos(Ecodigo, CPDCcodigo, CPDCdescripcion, CPDCactivo, CPDCporcTotal) 
				values ( <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ecodigo#">,
						 <cfqueryparam cfsqltype="cf_sql_char" value="#Form.CPDCcodigo#">,
                         <cfqueryparam cfsqltype="cf_sql_varchar" value="#Form.CPDCdescripcion#">,
						 <cfqueryparam cfsqltype="cf_sql_bit" value="0">,
						 <cfqueryparam cfsqltype="cf_sql_double" value="#Form.CPDCporcDis#">
					   )
			</cfquery>		   
			<cfset modo="ALTA">
			<cfelseif isdefined("Form.Baja")>
            	<cfquery name="rsDatos" datasource="#Session.DSN#">
                    select count(1) as cantidad from CPDistribucionCostos a
                    inner join 	CPDistribucionCostosCF b
                        on b.CPDCid = a.CPDCid
                    where a.Ecodigo  = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer">
                        and a.CPDCid = <cfqueryparam cfsqltype="cf_sql_numeric" value="#form.CPDCid#">
                </cfquery>
                <cfif rsDatos.cantidad gt 0>	
                    <cfthrow message="No se puede eliminar el registro ya que tiene centros funcionales ligados.">
                <cfelse>	
                    <cfquery name="delete" datasource="#session.DSN#">
                        delete from CPDistribucionCostos
                        where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
                           and  CPDCid = <cfqueryparam value="#form.CPDCid#" cfsqltype="cf_sql_numeric">
                    </cfquery>
                 </cfif>
			<cfset modo="BAJA">
	
		<cfelseif isdefined("Form.Cambio")>
			<cfquery name="update" datasource="#Session.DSN#">
				update CPDistribucionCostos set
					   CPDCcodigo = <cfqueryparam value="#Form.CPDCcodigo#" cfsqltype="cf_sql_char">,
					   CPDCdescripcion = <cfqueryparam value="#Form.CPDCdescripcion#" cfsqltype="cf_sql_varchar">,
					   CPDCactivo =  <cfif form.CPDCporcDis EQ 100 and isdefined("Form.Activo")>1<cfelse>0</cfif>, 
					   CPDCporcTotal = <cfqueryparam value="#Form.CPDCporcDis#" cfsqltype="cf_sql_double">
				where  Ecodigo = <cfqueryparam value="#session.ecodigo#" cfsqltype="cf_sql_integer"> 
					   and  CPDCid = <cfqueryparam value="#form.CPDCid#" cfsqltype="cf_sql_numeric">
			</cfquery> 
			<cfset modo="CAMBIO">
		</cfif>
	</cfif>
<cfoutput>
<form action="TipoDistribucion.cfm" method="post" name="sql">
	<input name="modo" type="hidden" value="<cfif isdefined("modo")>#modo#</cfif>">
	<cfif isdefined("Form.CPDCid") and isdefined("Form.Cambio") >
		<input name="CPDCid" type="hidden" value="#Form.CPDCid#">
	</cfif>
</form>
</cfoutput>	

<HTML>
<head>
</head>
<body>
<script language="JavaScript1.2" type="text/javascript">document.forms[0].submit();</script>
</body>
</HTML>



