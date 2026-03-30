<cfif isdefined('url.GOid') and not isdefined('form.GOid')>
	<cfparam name="form.GOid" default="#url.GOid#">
</cfif>

<cfset modo = 'ALTA'>
<cfif isdefined('form.GOid') and len(trim(form.GOid))>
	<cfset modo = 'CAMBIO'>
</cfif>

<cfoutput>
<form action="gruposOficinas-tab2-sql.cfm" method="post">
	<table width="100%" border="0" align="left" cellpadding="0" cellspacing="4">
			<cfquery name="temp" datasource="#session.DSN#">
				select GOnombre
				from AnexoGOficina 
				where GOid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.GOid#">
			</cfquery>
			<tr><td colspan="8" align="center" class="tituloListas" >Seleccione las Oficinas que pertenecen al grupo "<cfoutput>#temp.GOnombre#</cfoutput>"</td></tr>
		    
			<cfquery name="lista" datasource="#session.DSN#">
				select Ocodigo, Oficodigo, Odescripcion
				from Oficinas 
				where Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
			</cfquery>  							   
			
			<cfset cont = 0>
			<cfloop query="lista">
				
				<cfquery name="checks" datasource="#session.DSN#">
					select count(b.Ocodigo)as existe
					from AnexoGOficinaDet b
					where b.Ecodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.Ecodigo#">
						and b.GOid = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.GOid#">
						and b.Ocodigo = <cfqueryparam cfsqltype="cf_sql_integer" value="#Ocodigo#">
				</cfquery>
				
				<cfif #cont# EQ 0><tr></cfif><!--- inicio de linea en la tabla --->
					
					<td><input id="oficinasCB#Ocodigo#" name="oficinasCB" type="checkbox" value="<cfoutput>#Ocodigo#</cfoutput>" 
						<cfif #checks.existe# NEQ 0> checked </cfif>></td>
					
					<td><label  for="oficinasCB#Ocodigo#"><cfoutput>#Odescripcion#</cfoutput></label></td>
				
				<cfif cont EQ 3></tr> <cfset cont = -1></cfif><!--- fin de linea en la tabla --->
				
				<cfset cont = cont+1>
				
			</cfloop>
			<tr align="center">
			<td colspan="2">&nbsp;</td>
    </tr>
	<tr>
			<td colspan="8" align="center">
				<!--- <cfif modo neq 'ALTA' > --->
					<cfif isdefined('form.GOid') and len(trim(form.GOid))>
						<!--- <cf_botones modo='CAMBIO' exclude="BAJa" > --->
						<center><input name="Modificar" type="submit" value="Guardar"></center>
						<input type="hidden" name="Ocodigo" value="#lista.Ocodigo#">
						<input type="hidden" name="GOid" value="#form.GOid#">
					</cfif>
				<!--- <cfelse>
					<cf_botones modo='ALTA'>
				</cfif> --->
				
			</td>
		</tr> 
  </table>
 </form> 
  </cfoutput>
  