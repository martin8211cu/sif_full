<!--- 
	Creado por E. Raúl Bravo Gómez
		Fecha: 12-4-2010.	
 --->

 <!--- Obtiene los datos de la tabla de Parámetros según el pcodigo --->
<cffunction name="ObtenerDato" returntype="query">
	<cfargument name="pcodigo" type="numeric" required="true">	
	<cfquery name="rs" datasource="#Session.DSN#">
		select Pvalor,Pdescripcion
		from Parametros
		where Ecodigo = #Session.Ecodigo#
		  and Pcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Arguments.pcodigo#">
	</cfquery>
	<cfreturn #rs#>
</cffunction>

<!--- PARAMETROS RELACIONADOS CON ELIMINACIÓN DE CUENTAS --->
<cfset empElimina = ObtenerDato(1310)>
<cfset polizaElimina = ObtenerDato(1320)>

<cfset gpoElimina = ObtenerDato(1330)>

<cfset definidos = ObtenerDato(5)>
<cfset existenParametrosDefinidos = false >
<cfif definidos.RecordCount GT 0 >
	<cfif definidos.Pvalor NEQ "N" >
		<cfset existenParametrosDefinidos = true >
	</cfif>
</cfif>

<form action="SQLParametrosEliminacion.cfm" method="post" name="form1">
	<table width="100%" border="0" cellpadding="0" cellspacing="0">
		<tr>
			<td align="center">
			<table width="85%" border="0" cellpadding="2" cellspacing="2">
					<td colspan="2" nowrap align="center">
					    <table border="0">
							<tr> 
                                <td colspan="2" align="right" nowrap="nowrap">Grupo de Empresas:&nbsp;</td>
                                <td>
									<cfset rsGpoEmpresaPar = ObtenerDato(1330)> 
                                    
                                    <cfquery name="rsGpoEmpresa" datasource="#Session.DSN#">
                                            select a.GEid as Ecodigo, a.GEnombre as Edescripcion
                                            from AnexoGEmpresa a
                                            where a.CEcodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
                                    </cfquery>
                               
                                	<cfif isdefined('url.GE') >
										<cfset rscveGpoEmpresa = url.GE>
                                    <cfelse>
                                      	<cfset rscveGpoEmpresa = rsGpoEmpresaPar.Pvalor>
                                    </cfif>
                                                                      
                                    <select name="rsGpoEmpresaid" onchange="document.location.href='ParametrosCtaEliminacion.cfm?GE='+this.value;">
                                      <cfif rsGpoEmpresa.RecordCount EQ 0>
                                        <option value="-1"></option>
                                      </cfif>
                                      <cfoutput query="rsGpoEmpresa">
                                        <option value="#rsGpoEmpresa.Ecodigo#" <cfif rsGpoEmpresa.Ecodigo EQ rscveGpoEmpresa>selected</cfif>>#trim(rsGpoEmpresa.Edescripcion)# </option>
                                      </cfoutput>
                                    </select>                                                          
                                </td>								
							</tr>				
                        
							<tr> 
                                <td colspan="2" align="right" nowrap="nowrap">Empresa de Eliminaci&oacute;n:&nbsp;</td>
                                <td>
									<cfset rsEmpresaEliminacion = ObtenerDato(1310)>
                                    <cfif gpoElimina.Pvalor EQ ''>
                                    	<cfparam name= url.GE default= "#rsGpoEmpresa.Ecodigo#">
                                    <cfelse>
                                    	<cfparam name= url.GE default= "#gpoElimina.Pvalor#">                                    
                                    </cfif>
                                    <cfquery name="rsEmpresaElimina" datasource="#Session.DSN#">
                                        select Ecodigo, Edescripcion 
                                        from Empresas
                                        where Ecodigo in (Select Ecodigo from AnexoGEmpresaDet where GEid=#url.GE#)
                                        order by Ecodigo
                                    </cfquery>
                                    <select name="EmpresaEliminaid">
                                      <cfif rsEmpresaElimina.RecordCount EQ 0>
                                        <option value="-1"></option>
                                      </cfif>
                                      <cfoutput query="rsEmpresaElimina">
                                        <option value="#rsEmpresaElimina.Ecodigo#" <cfif rsEmpresaElimina.Ecodigo EQ rsEmpresaEliminacion.Pvalor>selected</cfif>>#trim(rsEmpresaElimina.Edescripcion)# </option>
                                      </cfoutput>
                                    </select>                                                          
                                </td>								
							</tr>				
							<!--- *************************************************** --->
							<tr> 								
								<td colspan="2" align="right" nowrap="nowrap">Lote/Concepto Contable de Eliminaci&oacute;n:&nbsp;</td>
								<td>                                		
									<cfset rsPolizaEliminacion = ObtenerDato(1320)>
                                    <cfquery datasource="#Session.DSN#" name="rsPolizaElimina">
                                        select Cconcepto,Cdescripcion from ConceptoContableE
                                        where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
                                    </cfquery>
									
							      	<select name="PolizaEliminaid">
								       	<cfif rsPolizaElimina.RecordCount EQ 0>
								        	<option value="-1"></option>
							           	</cfif>
								       	<cfoutput query="rsPolizaElimina">
								        	<option value="#rsPolizaElimina.Cconcepto#" <cfif rsPolizaElimina.Cconcepto EQ rsPolizaEliminacion.Pvalor>selected</cfif>>#trim(rsPolizaElimina.Cdescripcion)# </option>
							        	</cfoutput>
						        	</select>                                    								
                                </td>								
							</tr>                            
                    </table>
                </tr>						
                <tr><td colspan="3">&nbsp;</td></tr>
                <tr> 
                	<td colspan="3"><div align="center"> <input type="submit" name="Aceptar" value="Aceptar" onClick="javascript: return valida();"> 
                    </div> </td>
                </tr>
            </table>
		</td>	
	</tr>	
	</table>	
		
	<!--- Variables para saber si hay que hacer un insert o un update en el .sql de cada uno de estos registros ---->
    <cfif definidos.Recordcount GT 0 ><cfset hayParametrosDefinidos = 1 ></cfif>
    <cfoutput>
    	<input type="hidden" name="gpoElimina" value="#gpoElimina.Pdescripcion#">
        <input type="hidden" name="empElimina" value="#empElimina.Pdescripcion#">
        <input type="hidden" name="polizaElimina" value="#polizaElimina.Pdescripcion#">        
	</cfoutput>
	</form>
	
<script language="JavaScript1.2" >
	// valida los campos
	function valida() {
		<cfif not existenParametrosDefinidos >		
			alert('¡No están definidos los parámetros generales!');
			return false;
		</cfif>			
		return true;
	}	
</script>
