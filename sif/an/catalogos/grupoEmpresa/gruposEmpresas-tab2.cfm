<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="LB_Mensaje" 	default="Seleccione las Empresas que pertenecen al grupo" 
returnvariable="LB_Mensaje" xmlfile="gruposEmpresas-tab2.xml"/>
<cfinvoke component="sif.Componentes.Translate" method="Translate" 	key="BTN_Guardar" 	default="Guardar" 
returnvariable="BTN_Guardar" xmlfile="gruposEmpresas-tab2.xml"/>
<cfif isdefined('url.GEid') and not isdefined('form.GEid')>
	<cfparam name="form.GEid" default="#url.GEid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.GEid') and len(trim(form.GEid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfoutput>
<form action="gruposEmpresas-tab2-sql.cfm" method="post">
	<table width="100%" border="0" align="left" cellpadding="0" cellspacing="4">
			<cfquery name="temp" datasource="#session.DSN#">
				select GEnombre
				from AnexoGEmpresa 
				where GEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEid#">
			</cfquery>
			<tr>
			  <td colspan="8" align="center" class="tituloListas" >#LB_Mensaje# "<cfoutput>#temp.GEnombre#</cfoutput>"</td></tr>
		    
			<cfquery name="lista" datasource="#session.DSN#">
				select Ecodigo, Edescripcion
				from Empresas 
				where cliente_empresarial = <cfqueryparam cfsqltype="cf_sql_numeric" value="#session.CEcodigo#">
			</cfquery>  							   
			
			<cfset cont = 0>
			<cfloop query="lista">
				
				<cfquery name="checks" datasource="#session.DSN#">
					select count(b.Ecodigo)as existe
					from AnexoGEmpresaDet b
					where b.GEid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.GEid#">
						and b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_numeric" value="#Ecodigo#">
				</cfquery>
				
				<cfif #cont# EQ 0><tr></cfif><!--- inicio de linea en la tabla --->
					
					<td><input id="EmpresasCB#Ecodigo#" name="EmpresasCB" type="checkbox" value="<cfoutput>#Ecodigo#</cfoutput>" 
						<cfif #checks.existe# NEQ 0> checked </cfif>></td>
					
					<td><label  for="EmpresasCB#Ecodigo#"><cfoutput>#Edescripcion#</cfoutput></label></td>
				
				<cfif cont EQ 3></tr> <cfset cont = -1></cfif><!--- fin de linea en la tabla --->
				
				<cfset cont = cont+1>
				
			</cfloop>
			<tr align="center">
			<td colspan="2">&nbsp;</td>
    </tr>
	<tr>
			<td colspan="8" align="center">
				<!--- <cfif modo neq 'ALTA' > --->
					<cfif isdefined('form.GEid') and len(trim(form.GEid))>
						<!--- <cf_botones modo='CAMBIO' exclude="BAJa" > --->
						<center><input name="Modificar" type="submit" value="#BTN_Guardar#"></center>
						<input type="hidden" name="Ecodigo" value="#lista.Ecodigo#">
						<input type="hidden" name="GEid" value="#form.GEid#">
					</cfif>
				<!--- <cfelse>
					<cf_botones modo='ALTA'>
				</cfif> --->
				
			</td>
		</tr> 
  </table>
 </form> 
  </cfoutput>